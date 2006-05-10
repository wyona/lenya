package org.apache.lenya.svn;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.commons.configuration.Configuration;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.ConfigurationFactory;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.impl.SimpleLog;

import org.tmatesoft.svn.core.SVNCommitInfo;
import org.tmatesoft.svn.core.SVNErrorCode;
import org.tmatesoft.svn.core.SVNErrorMessage;
import org.tmatesoft.svn.core.SVNException;
import org.tmatesoft.svn.core.SVNNodeKind;
import org.tmatesoft.svn.core.SVNURL;
import org.tmatesoft.svn.core.auth.ISVNAuthenticationManager;
import org.tmatesoft.svn.core.internal.io.dav.DAVRepositoryFactory;
import org.tmatesoft.svn.core.internal.io.fs.FSRepositoryFactory;
import org.tmatesoft.svn.core.internal.io.svn.SVNRepositoryFactoryImpl;
import org.tmatesoft.svn.core.io.SVNRepository;
import org.tmatesoft.svn.core.io.SVNRepositoryFactory;
import org.tmatesoft.svn.core.wc.ISVNOptions;
import org.tmatesoft.svn.core.wc.SVNClientManager;
import org.tmatesoft.svn.core.wc.SVNRevision;
import org.tmatesoft.svn.core.wc.SVNUpdateClient;
import org.tmatesoft.svn.core.wc.SVNWCUtil;

public class LenyaSvnClient {
    
    private static SVNRepository repository;
    private static SVNClientManager ourClientManager;
    private static ISVNAuthenticationManager authManager;
    private static ISVNOptions options;
    private static String urlRep;
    private static SVNURL svnUrl;
    private static String localRep;
    
    private static final String PROP_EXIT_MES = "\nWARNING: Local configuration already exists";
    private static final String PROP_EXIT_OVERRIDE = "Do you want to overwrite (y/N)? ";
    private static boolean debug =false;
    protected static final String DEBUG_STRING = "-v";
    private static final String PROP_EXIT_OVERRIDE_EXT = "Do you want to overwrite or extend or keep this (o/e/K)? ";

    private static final String CONFIGURATION_FILE = "src/config/default-config.xml";
    private static Configuration config;
    private static BufferedReader br;
    
    /**
     * @param args
     * @throws IOException 
     */
    public static void main(String[] args) throws Exception {
        
        setupConfiguration(args);
        
        try {
          
            doSvnCommand(args,br);

        } catch (SVNException e) {
            System.err.println(e.getMessage());
            System.exit(1);
        }finally{
            br.close();
        }
    }

    private static void setupConfiguration(String[] args) throws Exception {

      for (int i = 0; i < args.length; i++) {
        if (args[i].equals(DEBUG_STRING)){
            debug=true;
        }
        if(debug)
            System.out.println("args["+i+"] = "+args[i]);
      }

      br = new BufferedReader(new InputStreamReader(System.in));
      
      // read the config file
      ConfigurationFactory factory = new ConfigurationFactory();
      URL configURL = new File(CONFIGURATION_FILE).toURL();
      factory.setConfigurationURL(configURL);
      config = factory.getConfiguration();

      System.out.println("\n*************************************************************");
      System.out.println("*    LenyaSvnClient - simple SVN client for Apache Lenya    *");
      System.out.println("*************************************************************\n");

      setupLibrary();

      urlRep = config.getString("lenyaSvn.urlRep");
      svnUrl = SVNURL.parseURIEncoded(urlRep);
      repository = SVNRepositoryFactory.create(svnUrl);
      if (debug)System.out.println("URL that points to repository: " + urlRep);

      // Credentials to use for authentication.
      String userName = config.getString("lenyaSvn.userName");
      String userPassword = config.getString("lenyaSvn.userPassword");
      
      localRep=config.getString("lenyaSvn.localRep");
      ISVNAuthenticationManager authManager = SVNWCUtil.createDefaultAuthenticationManager(userName, userPassword);
      repository.setAuthenticationManager(authManager);

      /*
       * Get type of the node located at URL we used to create SVNRepository.
       * 
       * "" (empty string) is path relative to that URL, 
       * -1 is value that may be used to specify HEAD (latest) revision.
       */
      SVNNodeKind nodeKind = repository.checkPath("", -1);

      /*
       * Checks  up  if the current path really corresponds to a directory. If 
       * it doesn't, the program exits. SVNNodeKind is that one who says  what
       * is located at a path in a revision. 
       */
      if (nodeKind == SVNNodeKind.NONE) {
          SVNErrorMessage err = SVNErrorMessage.create(SVNErrorCode.UNKNOWN, "No entry at URL ''{0}''", svnUrl);
          throw new SVNException(err);
      } else if (nodeKind == SVNNodeKind.FILE) {
          SVNErrorMessage err = SVNErrorMessage.create(SVNErrorCode.UNKNOWN, "Entry at URL ''{0}'' is a file while directory was expected", svnUrl);
          throw new SVNException(err);
      }
      
      // Get exact value of the latest (HEAD) revision.
      long latestRevision = repository.getLatestRevision();
      if(debug) System.out.println("Repository latest revision (before committing): " + latestRevision);
      
      // setup client manager, create (update) status
      ISVNOptions options = SVNWCUtil.createDefaultOptions(true);
      ourClientManager = SVNClientManager.newInstance(options, userName, userPassword);
      
    }
    
    private static void doSvnCommand(String[] args, BufferedReader br) throws SVNException {
      
        // TODO before starting, we should update the local repository (reduces conflicts possibilities)      
        
        StatusHandler statusHandler = new StatusHandler(false,debug);
        ourClientManager.getCommitClient().setEventHandler(statusHandler);
        ourClientManager.getUpdateClient().setEventHandler(statusHandler);
        File lr = new File(localRep);
        ourClientManager.getStatusClient().doStatus(lr,true,false,false,false,statusHandler);
        
        HashMap elementMap= statusHandler.getBeans();
        if (elementMap.size() == 0) {
          System.out.println("\nNo local changes, the script will terminate");
          return;
        }
        if(debug) System.out.println("Modified resources count "+elementMap.size());

        Iterator iteratorMap = elementMap.entrySet().iterator();

        ArrayList addedNodeToSitetree = new ArrayList();
        
        while (iteratorMap.hasNext()){
          Map.Entry entry = (Map.Entry) iteratorMap.next();
          StatusBean valueNode = (StatusBean) entry.getValue();
          String keyNode = (String) entry.getKey();
          String fileStatus = valueNode.getStatus();
          boolean isDirectory = valueNode.getFile().isDirectory();
          
          if(debug) {
              System.out.println("\n**************");
              System.out.println("File ".concat(keyNode));
              System.out.println("Status: ".concat(fileStatus));
          }
              
          // File modified
          if (fileStatus.equals("M")) {
            // do nothing
          } 

          // File not added yet
          else if (fileStatus.equals("?")) {
            //do nothing
          } 
          
          // File added
          else if (fileStatus.equals("A") && !(isDirectory)) {
            commitAddedFile(valueNode, br, localRep, addedNodeToSitetree);
          } 
          
          // Directory added
          else if (fileStatus.equals("A") && isDirectory) {
            checkDirConsistency(valueNode);
          } 

          else {            
            SVNErrorMessage err = SVNErrorMessage.create(SVNErrorCode.UNKNOWN, 
                "Operation " + fileStatus  + " not supported (file " + keyNode + 
            "), please clean your svn repository manually");
            throw new SVNException(err);
          }
      }

      // update all new nodes in the sitetree  
      SitetreeUpdater.updateSitetree (localRep + "/sitetree.xml", addedNodeToSitetree, debug);
        
      String logMessage = getLogmessage();  

      System.out.println("\nsending commit ...");
      commit(lr,false,logMessage); // commit all local changes to the server 
      System.out.println("commit successful");
    }    
  
    private static String getLogmessage() {
      
       String logMessage = config.getString("lenyaSvn.defaultLogMessage");

       // Do we want to override this?
       System.out.println("\n*************************************************************");
       System.out.println("Please enter the log message for the commit.\nDefault value is: "+logMessage);
       System.out.print(PROP_EXIT_OVERRIDE);
       try {
           String value = br.readLine();
           if (value.equals("y")) {
               System.out.println("Please define the new log message");
               logMessage = br.readLine();
           } else {
               System.out.println("Using default value " + logMessage);
           }
       } catch (Exception e) {
           System.err.println(e.getMessage());
       }
       
      return logMessage;
    }

    private static void commitAddedFile(StatusBean valueNode, BufferedReader br, 
        String localRep, ArrayList addedNodeToSitetree) throws SVNException {

      String relativeNodePath = valueNode.getPath().replaceFirst(localRep,"");
      if(debug) System.out.println("relativePath "+relativeNodePath);
      
      String filename = valueNode.getFile().getName();
      
      if (filename.equals("index_en.xml")) {
        
        File meta = new File (valueNode.getPath() + ".meta");

        if (!meta.exists()) {
          
          // Ask user for ressource type
          String ressourceType = "xhtml";
          System.out.println("*************************************************************");
          System.out.println("Adding file " + 
              relativeNodePath);
          System.out.println("Please enter the ressource type for this file. The default value is: "+ ressourceType); 
          System.out.print(PROP_EXIT_OVERRIDE);
          try {
            String value = br.readLine();
            if (value.equals("y")) {
              System.out.println("Please define the new ressource type");
              ressourceType=br.readLine();
            } else {
              System.out.println("Using default value " + ressourceType);
            }
          } catch (Exception e) {
            System.err.println(e.getMessage());
          }
          
          // Ask user for title
          String title = "Title";
          System.out.println("*************************************************************");
          System.out.println("Please enter the title for this file. The default value is: "+ title); 
          System.out.print(PROP_EXIT_OVERRIDE);
          try {
            String value = br.readLine();
            if (value.equals("y")) {
              System.out.println("Please define the new title");
              title=br.readLine();
            } else {
              System.out.println("Using default value " + title);
            }
          } catch (Exception e) {
            System.err.println(e.getMessage());
          }
          
          // Get default publisher from config
          String publisher = config.getString("lenyaSvn.defaultPublisher");

          // create metadata file
          MetaDataWriter metadatawriter = new MetaDataWriter();
          metadatawriter.addMetaFile(meta, ressourceType, title, publisher);      
          
          // add meta file to repository
          addEntry(meta);
        }
  
        addedNodeToSitetree.add(relativeNodePath);
  
      }      
      else if (filename.equals("index_en.xml.meta")) {
        // meta file already exists
      
      } else {
        SVNErrorMessage err = SVNErrorMessage.create(SVNErrorCode.UNKNOWN, 
            "Cannot commit local changes: the file "+ valueNode.getPath() + 
        "\n has no valid name, only index_en.xml or index_en.xml.meta accepted");
        throw new SVNException(err);
      }      
    }
    
    /** Primitive test to ensure that the dir has at least a child called index_en.xml
     * @throws SVNException */
    private static void checkDirConsistency(StatusBean valueNode) throws SVNException {
      
      File child [] = valueNode.getFile().listFiles();
      
      for (int i = 0; i < child.length; i++) {
        if (child[i].getName().equals("index_en.xml")) {
          return;
        }      
      }
      SVNErrorMessage err = SVNErrorMessage.create(SVNErrorCode.UNKNOWN, "Cannot commit " +
            "local changes: The directory " +
          valueNode.getPath() + " must contain a file named index_en.xml");
      throw new SVNException(err);
    }
    
    //*******************************************************
    // methods copied from WorkingCopy.java
    //*******************************************************
    
    
    /**
     * Committs changes in a working copy to a repository. Like 
     * 'svn commit PATH -m "some comment"' command. It's done by invoking 
     * 
     * SVNCommitClient.doCommit(File[] paths, boolean keepLocks, String commitMessage, 
     * boolean force, boolean recursive) 
     * 
     * which takes the following parameters:
     * 
     * paths - working copy paths which changes are to be committed;
     * 
     * keepLocks - if true then doCommit(..) won't unlock locked paths; otherwise they will
     * be unlocked after a successful commit; 
     * 
     * commitMessage - a commit log message;
     * 
     * force - if true then a non-recursive commit will be forced anyway;  
     * 
     * recursive - if true and a path corresponds to a directory then doCommit(..) recursively 
     * commits changes for the entire directory, otherwise - only for child entries of the 
     * directory;
     */
    private static SVNCommitInfo commit(File wcPath, boolean keepLocks, String commitMessage)
            throws SVNException {
        /*
         * Returns SVNCommitInfo containing information on the new revision committed 
         * (revision number, etc.) 
         */
        return ourClientManager.getCommitClient().doCommit(new File[] { wcPath }, keepLocks,
                commitMessage, false, true);
    }
    
    /**
     * Puts directories and files under version control scheduling them for addition
     * to a repository. They will be added in a next commit. Like 'svn add PATH' 
     * command. It's done by invoking 
     * 
     * SVNWCClient.doAdd(File path, boolean force, 
     * boolean mkdir, boolean climbUnversionedParents, boolean recursive) 
     * 
     * which takes the following parameters:
     * 
     * path - an entry to be scheduled for addition;
     * 
     * force - set to true to force an addition of an entry anyway;
     * 
     * mkdir - if true doAdd(..) creates an empty directory at path and schedules
     * it for addition, like 'svn mkdir PATH' command;
     * 
     * climbUnversionedParents - if true and the parent of the entry to be scheduled
     * for addition is not under version control, then doAdd(..) automatically schedules
     * the parent for addition, too;
     * 
     * recursive - if true and an entry is a directory then doAdd(..) recursively 
     * schedules all its inner dir entries for addition as well. 
     */
    private static void addEntry(File wcPath) throws SVNException {
        ourClientManager.getWCClient().doAdd(wcPath, false, false, false, true);
    }
    
    /**
     * Updates a working copy (brings changes from the repository into the working copy). 
     * Like 'svn update PATH' command; It's done by invoking 
     * 
     * SVNUpdateClient.doUpdate(File file, SVNRevision revision, boolean recursive) 
     * 
     * which takes the following parameters:
     * 
     * file - a working copy entry that is to be updated;
     * 
     * revision - a revision to which a working copy is to be updated;
     * 
     * recursive - if true and an entry is a directory then doUpdate(..) recursively 
     * updates the entire directory, otherwise - only child entries of the directory;   
     */
    private static long update(File wcPath,
            SVNRevision updateToRevision, boolean isRecursive)
            throws SVNException {
 
        SVNUpdateClient updateClient = ourClientManager.getUpdateClient();
        /*
         * sets externals not to be ignored during the update
         */
        updateClient.setIgnoreExternals(false);
        /*
         * returns the number of the revision wcPath was updated to
         */
        return updateClient.doUpdate(wcPath, updateToRevision, isRecursive);
    }
    
    /**
     * Initializes the library to work with a repository via 
     * different protocols.
     */
    private static void setupLibrary() {
        // For using over http:// and https://
        DAVRepositoryFactory.setup();

        // For using over svn:// and svn+xxx://
        SVNRepositoryFactoryImpl.setup();
        
        // For using over file:///
        FSRepositoryFactory.setup();
    } 
    
    /** Returns the contents of the file in a byte array. */
    public static byte[] getBytesFromFile(File file) throws IOException {
        InputStream is = new FileInputStream(file);
        long length = file.length();
        if (length > Integer.MAX_VALUE) {
        }
        byte[] bytes = new byte[(int)length];
        int offset = 0;
        int numRead = 0;
        while (offset < bytes.length
               && (numRead=is.read(bytes, offset, bytes.length-offset)) >= 0) {
            offset += numRead;
        }
        if (offset < bytes.length) {
            throw new IOException("Could not completely read file "+file.getName());
        }
        is.close();
        return bytes;
    }
}
