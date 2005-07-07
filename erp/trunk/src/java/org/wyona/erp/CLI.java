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
            System.out.println("Usage: --add-task");
            return;
        }

        String command = args[0];

        if (command.equals("--add-task")) {
            new ERP().addTask("My first task", "michi");
        } else {
            System.out.println("No such command: " + command);
        }
    }
}
