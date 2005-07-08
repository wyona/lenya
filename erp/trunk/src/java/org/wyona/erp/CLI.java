package org.wyona.erp;

/**
 *
 */
public class CLI {

    /**
     *
     */
    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("Usage: --help");
            return;
        }

        if (args[0].equals("--help")) {
            listHelp();
            return;
        }

        if (args.length <= 2) {
            System.out.println("Usage: REPO_CONFIG REPO_HOME [command]");
            return;
        }
        String repoConfig = args[0]; // e.g. repository.xml
        String repoHomeDir = args[1]; // e.g. repotest
        String command = args[2];

        if (command.equals("--help")) {
            listHelp();
	} else if (command.equals("--add-task")) {
            if (args.length < 5) {
                System.out.println("Usage: REPO_CONFIG REPO_HOME --add-task TITLE OWNER");
                return;
            }
            String title = args[3]; // e.g. My first task
            String owner = args[4]; // e.g. michi
            new ERP(repoConfig, repoHomeDir).addTask(title, owner);
	} else if (command.equals("--list-tasks")) {
            String workspaceName = "default";
            new ERP(repoConfig, repoHomeDir).listTasks(workspaceName);
        } else {
            System.out.println("No such command: " + command);
        }
    }

    /**
     *
     */
    public static void listHelp() {
        System.out.println("Add Task:       REPO_CONFIG REPO_HOME --add-task TITLE OWNER");
        System.out.println("Lists Tasks:    REPO_CONFIG REPO_HOME --list-tasks");
    }
}
