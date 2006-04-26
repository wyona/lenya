package org.apache.lenya.svn;

import org.tmatesoft.svn.cli.SVNCommandLine;

public class LenyaSvnClient {

    /**
     * @param args
     */
    public static void main(String[] args) {
        welcomeMessage();
        if (args == null || args.length < 1) {
            System.err.println("usage: svn commandName commandArguments");
            System.exit(0);
        }
        SVNCommandLine commandLine = null;
    }

    private static void welcomeMessage() {
        System.out.println("LenyaSvnClient - simple svn client for lenya");
    }

}
