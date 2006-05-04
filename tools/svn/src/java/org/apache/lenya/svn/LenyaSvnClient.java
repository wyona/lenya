package org.apache.lenya.svn;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.tmatesoft.svn.core.SVNErrorCode;
import org.tmatesoft.svn.core.SVNErrorMessage;
import org.tmatesoft.svn.core.SVNException;
import org.tmatesoft.svn.core.SVNNodeKind;
import org.tmatesoft.svn.core.SVNURL;
import org.tmatesoft.svn.core.auth.ISVNAuthenticationManager;
import org.tmatesoft.svn.core.internal.io.dav.DAVRepositoryFactory;
import org.tmatesoft.svn.core.internal.io.fs.FSRepositoryFactory;
import org.tmatesoft.svn.core.internal.io.svn.SVNRepositoryFactoryImpl;
import org.tmatesoft.svn.core.io.ISVNEditor;
import org.tmatesoft.svn.core.io.SVNRepository;
import org.tmatesoft.svn.core.io.SVNRepositoryFactory;
import org.tmatesoft.svn.core.wc.SVNStatusClient;
import org.tmatesoft.svn.core.wc.SVNWCUtil;

public class LenyaSvnClient {
    
    private static SVNRepository repository;
    
    private static final String PROP_EXIT_MES = "\nWARNING: Local configuration already exists";
    private static final String PROP_EXIT_OVERRIDE = "Do you want to overwrite (y/N)? ";
    private static boolean debug =false;
    protected static final String DEBUG_STRING = "-v";
    private static final String PROP_EXIT_OVERRIDE_EXT = "Do you want to overwrite or extend or keep this (o/e/K)? ";

    /**
     * @param args
     * @throws IOException 
     */
    public static void main(String[] args) throws IOException {
        welcomeMessage();
        
        for (int i = 0; i < args.length; i++) {
            if (args[i].equals(DEBUG_STRING)){
                debug=true;
            }
            if(debug)
                System.out.println("args["+i+"] = "+args[i]);
        }
//      preparing io actions with the user
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
//        if (args == null || args.length < 1) {
//            System.err.println("usage: svn commandName commandArguments");
//            System.exit(0);
//        }
        try {
            doSvnCommand(args,br);
        } catch (SVNException e) {
            System.err.println(e.getMessage());
            System.exit(1);
        }finally{
            br.close();
        }
    }

    private static void welcomeMessage() {
        System.out.println("LenyaSvnClient - simple svn client for lenya");
    }
    
    private static void doSvnCommand(String[] args, BufferedReader br) throws SVNException {
        /*
         * Initialize the library. It must be done before calling any 
         * method of the library.
         */
        setupLibrary();
        /*
         * URL that points to repository. 
         */
        String urlRep = "http://svn.wyona.com/repos/public/lenya/tools/svn";
        
        
        /*
         * Do we want to override this?
         */
        System.out.println(PROP_EXIT_MES);
        System.out.println("for the URL that points to repository.\ncurrent value: "+urlRep);
        System.out.print(PROP_EXIT_OVERRIDE);
        try {
            String value = br.readLine();
            if (value.equals("y")) {
                System.out.println("Please define a new url");
                urlRep=br.readLine();
            } else {
                System.out.println("Local configuration has NOT been overwritten.");
            }
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
        
        /**
         * Creating svnurl
         */
        if(debug)
        System.out.println("\nUsing "+urlRep);
        SVNURL url = SVNURL.parseURIEncoded(urlRep);
        /*
         * Create an instance of SVNRepository class. This class is the main entry point 
         * for all "low-level" Subversion operations supported by Subversion protocol. 
         * 
         * These operations includes browsing, update and commit operations. See 
         * SVNRepository methods javadoc for more details.
         */
        repository = SVNRepositoryFactory.create(url);
        
        /*
         * Credentials to use for authentication.
         */
        String userName = "anonymous";
        String userPassword = "anonymous";
        
        /*
         * Do we want to override this?
         */
        System.out.println(PROP_EXIT_MES);
        System.out.println("for the Credentials to use for authentication.\ncurrent value:\nuserName: "+userName+"\nuserPassword "+userPassword);
        System.out.print(PROP_EXIT_OVERRIDE);
        try {
            String value = br.readLine();
            if (value.equals("y")) {
                System.out.println("Please define a new userName");
                userName=br.readLine();
                System.out.println("Please define a new userPassword");
                userPassword=br.readLine();
            } else {
                System.out.println("Local configuration has NOT been overwritten.");
            }
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
        
        /*
         * User's authentication information (name/password) is provided via  an 
         * ISVNAuthenticationManager  instance.  SVNWCUtil  creates  a   default 
         * authentication manager given user's name and password.
         * 
         * Default authentication manager first attempts to use provided user name 
         * and password and then falls back to the credentials stored in the 
         * default Subversion credentials storage that is located in Subversion 
         * configuration area. If you'd like to use provided user name and password 
         * only you may use BasicAuthenticationManager class instead of default 
         * authentication manager:
         * 
         *  authManager = new BasicAuthenticationsManager(userName, userPassword);
         *  
         * You may also skip this point - anonymous access will be used. 
         */
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
            SVNErrorMessage err = SVNErrorMessage.create(SVNErrorCode.UNKNOWN, "No entry at URL ''{0}''", url);
            throw new SVNException(err);
        } else if (nodeKind == SVNNodeKind.FILE) {
            SVNErrorMessage err = SVNErrorMessage.create(SVNErrorCode.UNKNOWN, "Entry at URL ''{0}'' is a file while directory was expected", url);
            throw new SVNException(err);
        }
        /*
         * Get exact value of the latest (HEAD) revision.
         */
        long latestRevision = repository.getLatestRevision();
        if(debug)
        System.out.println("Repository latest revision (before committing): " + latestRevision);
        
        //DEBUG: cli
        //System.out.println("CLI start");
        //SVN.main(args);
        //System.out.println("CLI stop");
        
        StatusHandler statusHandler = new StatusHandler(false,debug);
        SVNStatusClient status = new SVNStatusClient(authManager, null);
        
        String localRep="/home/thorsten/projects/wyona-public/lenya/tools/svn";
        /*
         * Do we want to override this?
         */
        System.out.println(PROP_EXIT_MES);
        System.out.println("for the local checkout for the repository.\ncurrent value: "+localRep);
        System.out.print(PROP_EXIT_OVERRIDE);
        try {
            String value = br.readLine();
            if (value.equals("y")) {
                System.out.println("Please define the new location of the rep (needs to be a directory!!!)");
                localRep=br.readLine();
            } else {
                System.out.println("Local configuration has NOT been overwritten.");
            }
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
        
        File test = new File(localRep);
        status.doStatus(test,true,false,false,false,statusHandler);
        
        if(debug)
        System.out.println("DEBUG: trying beans.");
        
        HashMap elementMap= statusHandler.getBeans();
        
        if(debug)
        System.out.println("Modified resources count "+elementMap.size());
        Iterator iteratorMap = elementMap.entrySet().iterator();
        String[] pass = statusHandler.pass;
        while (iteratorMap.hasNext()){
            Map.Entry entry = (Map.Entry) iteratorMap.next();
            StatusBean valueNode = (StatusBean) entry.getValue();
            String keyNode = (String) entry.getKey();
            String statusFile = valueNode.getStatus();
            if(debug){
                System.out.println("Key/Path: ".concat(keyNode));
                System.out.println("Status: ".concat(statusFile));
                System.out.println("**************");
            }
            for (int i = 0; i < pass.length; i++) {
                String passString = pass[i];
                if (statusFile.equals(passString))
                    commit(valueNode,br);
            }
        }
    }
    private static void commit(StatusBean valueNode, BufferedReader br) throws SVNException {
        /*
         * Gets an editor for committing the changes to  the  repository.  NOTE:
         * you  must not invoke methods of the SVNRepository until you close the
         * editor with the ISVNEditor.closeEdit() method.
         * 
         * commitMessage will be applied as a log message of the commit.
         * 
         * ISVNWorkspaceMediator instance will be used to store temporary files, 
         * when 'null' is passed, then default system temporary directory will be used to
         * create temporary files.  
         */
        ISVNEditor editor;
        
        String logMessage = "Automated commit by LenyaSvnClient";
        /*
         * Do we want to override this?
         */
        System.out.println(PROP_EXIT_MES);
        System.out.println("for the commitMessage (will be applied as a log message of the commit).\ncurrent value: "+logMessage);
        System.out.print(PROP_EXIT_OVERRIDE_EXT);
        try {
            String value = br.readLine();
            if (value.equals("o")) {
                System.out.println("Please define a *new* commitMessage");
                logMessage=br.readLine();
            } else if(value.equals("e")) {
                System.out.println("Please extend the commitMessage");
                logMessage=logMessage.concat("\n").concat(br.readLine());
            }else {
                System.out.println("Local configuration has NOT been overwritten.");
            }
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
        
        if(debug)
            System.out.println("\nUsing "+logMessage);
        try {
            
            // FIXME: this commit is not working yet 
                        editor = 
                repository.getCommitEditor(logMessage, new CommitMediator());
                editor.openRoot(valueNode.getWorkingRevision());
                editor.closeDir();
        } catch (SVNException svne) {
            throw new SVNException(svne.getErrorMessage());
        }
        
    }

    /*
     * Initializes the library to work with a repository via 
     * different protocols.
     */
    private static void setupLibrary() {
        /*
         * For using over http:// and https://
         */
        DAVRepositoryFactory.setup();
        /*
         * For using over svn:// and svn+xxx://
         */
        SVNRepositoryFactoryImpl.setup();
        
        /*
         * For using over file:///
         */
        FSRepositoryFactory.setup();
    }

}
