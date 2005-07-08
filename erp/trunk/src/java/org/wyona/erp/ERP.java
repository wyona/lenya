package org.wyona.erp;

import org.apache.jackrabbit.core.jndi.RegistryHelper;
//import org.apache.jackrabbit.core.value.StringValue;

import javax.jcr.Credentials;
import javax.jcr.Node;
import javax.jcr.Repository;
import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.jcr.SimpleCredentials;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import java.util.Hashtable;

import org.apache.log4j.Category;

/**
 *
 */
public class ERP {

    private static Category log = Category.getInstance(ERP.class);

    private String REPO_NAME = "erp-repo";
    private String USERID = "michiii";
    private char[] PASSWORD = "".toCharArray();

    Context context;

    /**
     *
     */
    public ERP(String repoConfig, String repoHomeDir) {
        // NOTE: Is being set within the shell script
        //System.setProperty("java.security.auth.login.config", "jaas.config");
        try {
            bindRepository(repoConfig, repoHomeDir);
        } catch(Exception e) {
            log.error(e);
        }
    }

    /**
     * Add a new task to the repository
     *
     * @param title Title of task
     * @param owner Owner of task
     */
    public void addTask(String title, String owner) {
        log.info("Attempting to add task: " + title + " (" + owner + ")");

        Session session = null;
        try {
            Repository repo = getRepository();
            Credentials credentials = new SimpleCredentials(USERID, PASSWORD);
            //session = repo.login(credentials, workspaceName);
            session = repo.login(credentials, "default");
            Node rootNode = session.getRootNode();
	    log.info("Name of root node: " + rootNode.getPrimaryNodeType().getName());
            String relPath = "task-101";
 
            if (!rootNode.hasNode(relPath)) {
                //rootNode.checkout();
                Node taskNode = rootNode.addNode(relPath);
                taskNode.addMixin("mix:versionable");
                taskNode.setProperty("title", title);
                //taskNode.setProperty("title", new StringValue(title));
	        //log.info("UUID of task node: " + taskNode.getUUID());
	        log.info("Name of task node: " + taskNode.getName());
                session.checkPermission("/", "read");
                session.checkPermission("/", "add_node");
                session.save();
            } else {
                log.info("Node already exists: " + relPath);
            }
        } catch (Exception e) {
            log.error(e);
        } finally {
            if (session != null) session.logout();
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
    private void bindRepository(String repoConfig, String repoHomeDir) throws NamingException, RepositoryException {
        log.info("Bind repository (JNDI): " + REPO_NAME);
        Hashtable env = new Hashtable();
        env.put(Context.INITIAL_CONTEXT_FACTORY, "org.apache.jackrabbit.core.jndi.provider.DummyInitialContextFactory");
        env.put(Context.PROVIDER_URL, "localhost");

        context = new InitialContext(env);
        RegistryHelper.registerRepository(context, REPO_NAME, repoConfig, repoHomeDir, true);
    }
}
