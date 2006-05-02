package org.apache.lenya.svn;

import java.io.File;

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
import org.tmatesoft.svn.core.io.ISVNReporterBaton;
import org.tmatesoft.svn.core.io.SVNRepository;
import org.tmatesoft.svn.core.io.SVNRepositoryFactory;
import org.tmatesoft.svn.core.wc.SVNStatusClient;
import org.tmatesoft.svn.core.wc.SVNWCUtil;
import org.tmatesoft.svn.cli.SVN;

public class LenyaSvnClient {

    /**
     * @param args
     */
    public static void main(String[] args) {
        welcomeMessage();
        for (int i = 0; i < args.length; i++) {
            System.out.println(i+" "+args[i]);
        }
//        if (args == null || args.length < 1) {
//            System.err.println("usage: svn commandName commandArguments");
//            System.exit(0);
//        }
        try {
            doSvnCommand(args);
        } catch (SVNException e) {
            System.err.println(e.getMessage());
            System.exit(1);
        }
    }

    private static void welcomeMessage() {
        System.out.println("LenyaSvnClient - simple svn client for lenya");
    }
    
    private static void doSvnCommand(String[] args) throws SVNException {
        /*
         * Initialize the library. It must be done before calling any 
         * method of the library.
         */
        setupLibrary();
        /*
         * URL that points to repository. 
         */
        SVNURL url = SVNURL.parseURIEncoded("http://svn.wyona.com/repos/public/lenya/tools/svn");
        /*
         * Credentials to use for authentication.
         */
        String userName = "anonymous";
        String userPassword = "anonymous";
        /*
         * Create an instance of SVNRepository class. This class is the main entry point 
         * for all "low-level" Subversion operations supported by Subversion protocol. 
         * 
         * These operations includes browsing, update and commit operations. See 
         * SVNRepository methods javadoc for more details.
         */
        SVNRepository repository = SVNRepositoryFactory.create(url);
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
        System.out.println("Repository latest revision (before committing): " + latestRevision);
        
        //DEBUG: cli
        //System.out.println("CLI start");
        //SVN.main(args);
        //System.out.println("CLI stop");
        
        StatusHandler statusHandler = new StatusHandler(false);
        SVNStatusClient status = new SVNStatusClient(authManager, null);
        File test = new File("/home/thorsten/projects/wyona-public/lenya/tools/svn");
        status.doStatus(test,true,false,false,false,statusHandler);
        
        
        
        //ISVNReporterBaton reporter;
        
        //repository.status(latestRevision,null,true,);
        
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
        ISVNEditor editor = repository.getCommitEditor("directory and file added", null);
        
        String logMessage = "your commit log message";
//        try {
//            editor = 
//                repository.getCommitEditor(logMessage, new CommitMediator());
//        } catch (SVNException svne) {
//            throw new SVNException(svne.getErrorMessage());
//        }
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
