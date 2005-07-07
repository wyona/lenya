package org.wyona.erp;

import javax.jcr.Repository;

/**
 *
 */
public class ERP {

    /**
     *
     */
    public void addTask(String title, String owner) {
        System.out.println("Add Task: " + title + " (" + owner + ")");
    }

    /**
     *
     */
    private Repository getRepository() {
        String REPO_NAME = "erp-repo";
        //return (Repository) ctx.lookup(REPO_NAME);
        return null;
    }
}
