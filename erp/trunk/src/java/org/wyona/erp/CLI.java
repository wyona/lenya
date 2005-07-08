package org.wyona.erp;

/**
 *
 */
public class CLI {

    /**
     *
     */
    public static void main(String[] args) {
        if (args.length <= 2) {
            System.out.println("Usage: REPO_CONFIG REPO_HOME --add-task");
            return;
        }

        String repoConfig = args[0]; // e.g. repository.xml
        String repoHomeDir = args[1]; // e.g. repotest
        String command = args[2];

        if (command.equals("--add-task")) {
            new ERP(repoConfig, repoHomeDir).addTask("My first task", "michi");
        } else {
            System.out.println("No such command: " + command);
        }
    }
}
