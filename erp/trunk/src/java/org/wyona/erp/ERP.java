package org.wyona.erp;

import javax.jcr.Repository;

import javax.naming.Context;
import javax.naming.NamingException;

import org.apache.log4j.Category;

/**
 *
 */
public class ERP {

    private static Category log = Category.getInstance(ERP.class);

    String REPO_NAME = "erp-repo";

    Context context;

    /**
     *
     */
    public ERP() {
        bindRepository();
    }

    /**
     *
     */
    public void addTask(String title, String owner) {
        try {
            Repository repo = getRepository();
            System.out.println("Add Task: " + title + " (" + owner + ")");
        } catch (Exception e) {
            log.error(e);
        }
    }

    /**
     *
     */
    private Repository getRepository() throws NamingException {
        return (Repository) context.lookup(REPO_NAME);
    }

    /**
     *
     */
    private void bindRepository() {
    }
}
