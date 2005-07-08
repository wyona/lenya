package org.wyona.erp.doctypes;

/**
 *
 */
public class Task {
    String title;
    String owner;
    String status;
    String description;
    String type;
    String priority;
    String severity;
    String project;
    String component;
    String invoice;
    class Effort {
        String hours;
        String days;
    }

    /**
     *
     */
    public Task(String title, String owner) {
        this.title = title;
        this.owner = owner;
    }
}
