/**
 * 
 */
package com.wyona.james.rmi;

import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.Iterator;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.ParseException;

import org.apache.avalon.framework.activity.Initializable;
import org.apache.avalon.framework.component.ComponentException;
import org.apache.avalon.framework.component.ComponentManager;
import org.apache.avalon.framework.component.Composable;
import org.apache.avalon.framework.configuration.Configurable;
import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;
import org.apache.avalon.framework.context.Context;
import org.apache.avalon.framework.context.ContextException;
import org.apache.avalon.framework.context.Contextualizable;
import org.apache.avalon.framework.logger.AbstractLogEnabled;
import org.apache.james.services.MailServer;
import org.apache.james.services.UsersRepository;
import org.apache.james.services.UsersStore;
import org.apache.mailet.MailAddress;

import com.wyona.james.repository.NewsletterUser;

/**
 * Default implementation of the NewsletterManager interface
 * note that only repositorys whose name start with NEWSLETTER_REPO_NAME
 * are recognized as newsletter repositorys
 * 
 * @author Gregor Imboden
 */
public class DefaultNewsletterManager extends AbstractLogEnabled implements NewsletterManager, Contextualizable, Composable, Configurable, Initializable {
    
    protected Context context;
    protected Configuration configuration;
    protected ComponentManager componentManager;
    
    private UsersStore usersStore;
    private MailServer mailServer;
    private UsersRepository repository;
    
    /** Newsletter repositorys names have to start with this String */
    private static final String NEWSLETTER_REPO_NAME = "newsletter-";
    
    
    /* (non-Javadoc)
     * @see com.wyona.james.rmi.NewsletterManager#getRepositoryNames()
     */
    public ArrayList getRepositoryNames() throws RemoteException {
        ArrayList repositoryNames = new ArrayList();
        Iterator it = this.usersStore.getRepositoryNames();
        while (it.hasNext()) {
            String repositoryName = (String) it.next();
            if (repositoryName.startsWith(NEWSLETTER_REPO_NAME)) {
                repositoryNames.add(repositoryName);
            }            
        }
        return repositoryNames;
    }

    /* (non-Javadoc)
     * @see com.wyona.james.rmi.NewsletterManager#setRepository(java.lang.String)
     */
    public boolean setRepository(String name) throws RemoteException {
        if (name.startsWith(NEWSLETTER_REPO_NAME)) {
            UsersRepository repository = this.usersStore.getRepository(name);
            if (repository != null) {
                this.repository = repository;
                return true;
            }
        }
        return false;
    }

    /* (non-Javadoc)
     * @see com.wyona.james.rmi.NewsletterManager#addUser(java.lang.String)
     */
    public boolean addUser(String emailAddress) throws RemoteException {
        NewsletterUser newsletterUser = new NewsletterUser(emailAddress);
        if (this.repository.contains(emailAddress)) {
            return false;
        } else {
            return this.repository.addUser(newsletterUser);
        }
    }

    /* (non-Javadoc)
     * @see com.wyona.james.rmi.NewsletterManager#delUser(java.lang.String)
     */
    public boolean delUser(String emailAddress) throws RemoteException {
        if (this.repository.contains(emailAddress)) {
            this.repository.removeUser(emailAddress);
            return true;
        } else {
            return false;
        }
    }
    
    /* (non-Javadoc)
     * @see com.wyona.james.rmi.NewsletterManager#countUsers()
     */
    public int countUsers() throws RemoteException {
        return this.repository.countUsers();
    }
    
    /* (non-Javadoc)
     * @see com.wyona.james.rmi.NewsletterManager#getUserList()
     */
    public ArrayList getUserList() throws RemoteException {
        ArrayList users = new ArrayList();
        Iterator it = this.repository.list();
        while (it.hasNext()) {
            users.add(it.next());
        }
        return users;
    }

    /* (non-Javadoc)
     * @see com.wyona.james.rmi.NewsletterManager#sendMailToRepositoryUsers(java.lang.String, java.lang.String, java.lang.String, java.lang.String)
     */
    public void sendMailToRepositoryUsers(String senderAddress, String senderName, String subject, String messageBody) throws RemoteException {                  
        Iterator it = this.repository.list();              
        try {
            while (it.hasNext()) {
                String emailAddress = (String) it.next();
                ArrayList userAddresses = new ArrayList();
                userAddresses.add(new MailAddress(emailAddress));
                MimeMessage mail = MailUtil.generateMail(emailAddress, senderAddress, senderName, subject, messageBody);
                this.mailServer.sendMail(new MailAddress(senderAddress), userAddresses, mail);                
            }                        
        } catch (ParseException e) {
            throw new RemoteException("Illegal mail address", e);
        } catch (MessagingException e) {
            throw new RemoteException("Illegal message", e);
        } catch (Exception e) {
            throw new RemoteException("Exception", e);
        }
    }
        
    /* (non-Javadoc)
     * @see org.apache.avalon.framework.context.Contextualizable#contextualize(org.apache.avalon.framework.context.Context)
     */
    public void contextualize(Context context) throws ContextException {
        this.context = context;
    }

    /* (non-Javadoc)
     * @see org.apache.avalon.framework.component.Composable#compose(org.apache.avalon.framework.component.ComponentManager)
     */
    public void compose(ComponentManager componentManager) throws ComponentException {
        this.componentManager = componentManager;
        this.usersStore = (UsersStore)this.componentManager.lookup("org.apache.james.services.UsersStore");
        this.mailServer = (MailServer)this.componentManager.lookup("org.apache.james.services.MailServer");
    }

    /* (non-Javadoc)
     * @see org.apache.avalon.framework.configuration.Configurable#configure(org.apache.avalon.framework.configuration.Configuration)
     */
    public void configure(Configuration configuration) throws ConfigurationException {
        this.configuration = configuration;        
    }

    /* (non-Javadoc)
     * @see org.apache.avalon.framework.activity.Initializable#initialize()
     */
    public void initialize() throws Exception {
        // TODO Auto-generated method stub        
    }
    
}
