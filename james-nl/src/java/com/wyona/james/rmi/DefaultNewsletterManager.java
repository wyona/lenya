/**
 * 
 */
package com.wyona.james.rmi;

import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.HashMap;
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
    
    private static final String USER_COUNT_KEY = "userCount";
    private static final String USER_LIST_KEY = "userList";
    
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
    public boolean addUser(String emailAddress, String personal) throws RemoteException {
        NewsletterUser newsletterUser = new NewsletterUser(emailAddress, personal);
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
            NewsletterUser newsletterUser = (NewsletterUser) this.repository.getUserByName((String) it.next());
            users.add(newsletterUser);
        }
        return users;
    }
    

    /* (non-Javadoc)
     * @see com.wyona.james.rmi.NewsletterManager#getPaginatedUserList(int, int, java.lang.String)
     */
    public HashMap getPaginatedUserList(int usersPerPage, int pageNr, String queryString) throws RemoteException {
        if (queryString.length() > 0) {
            return this.paginateQueryUserList(usersPerPage, pageNr, queryString);
        } else {
            return this.paginateUserList(usersPerPage, pageNr);
        }        
    }

    /**
     * Returns an List of repository users having the query string in their
     * email address or name. 
     * @param queryString
     * @return the user list
     */
    private ArrayList getQueryUserList(String queryString) {
        ArrayList matchingUsers = new ArrayList();
        Iterator it = this.repository.list();
        while (it.hasNext()) {
            NewsletterUser newsletterUser = (NewsletterUser) this.repository.getUserByName((String) it.next());
            if (newsletterUser.getUserName().indexOf(queryString) >= 0 ||
                    newsletterUser.getPersonal().indexOf(queryString) >= 0) {
                matchingUsers.add(newsletterUser);
            }                
        }        
        return matchingUsers;
    }
    
    /**
     * Returns a HashMap containing the user list for this pageNr according to usersPerPage
     * and the total number of users matched by this query.
     * This implementations calls the repository iterator (n-1)-times to ge the n'th
     * repository user.
     * @param usersPerPage
     * @param pageNr
     * @param queryString
     * @return the user list for this pageNr
     */
    private HashMap paginateQueryUserList(int usersPerPage, int pageNr, String queryString) {        
        int listStart = 0;
        int listEnd = 0;
        HashMap userNr = new HashMap();
        ArrayList paginatedUsers = new ArrayList();
        ArrayList matchingUsers = this.getQueryUserList(queryString);
        int userCount = matchingUsers.size();                
        listStart = (pageNr-1) * usersPerPage;
        listEnd = Math.min(pageNr * usersPerPage, userCount);        
        for (int i=listStart; i<listEnd; i++) {
            paginatedUsers.add(matchingUsers.get(i));
        }
        userNr.put(USER_COUNT_KEY, new Integer(userCount));
        userNr.put(USER_LIST_KEY, paginatedUsers);
        return userNr;
    }    
    
    /**
     * Returns HashMap containing the user list for this pageNr according to usersPerPage
     * and the total number of users in this repository.
     * This implementation calls the repository iterator (n-1)-times to get the n'th 
     * repository user.
     * @param usersPerPage
     * @param nrUsers
     * @return the user list for this pageNr
     */
    private HashMap paginateUserList(int usersPerPage, int pageNr) {        
        int listStart = 0;
        int listEnd = 0;        
        int userCount = this.repository.countUsers();                        
        Iterator userIterator = this.repository.list();
        HashMap userNr = new HashMap();
        listStart = (pageNr-1) * usersPerPage;
        listEnd = Math.min(pageNr * usersPerPage, userCount);        
        for (int i=0; i<listStart && userIterator.hasNext(); i++) {
            userIterator.next();
        }
        ArrayList paginatedUsers = new ArrayList();
        for (int i=listStart; i<listEnd && userIterator.hasNext(); i++) {
            paginatedUsers.add(this.repository.getUserByName((String) userIterator.next()));
        }       
        userNr.put(USER_COUNT_KEY, new Integer(userCount));
        userNr.put(USER_LIST_KEY, paginatedUsers);
        return userNr;
    }
    
    /* (non-Javadoc)
     * @see com.wyona.james.rmi.NewsletterManager#sendMailToRepositoryUsers(java.lang.String, java.lang.String, java.lang.String, java.lang.String)
     */
    public void sendMailToRepositoryUsers(String senderAddress, String senderName, String subject, String messageBody) throws RemoteException {                  
        Iterator it = this.getUserList().iterator();          
        try {
            while (it.hasNext()) {
                NewsletterUser newsletterUser = (NewsletterUser) it.next();
                ArrayList userAddresses = new ArrayList();
                userAddresses.add(newsletterUser.getMailAddress());
                MimeMessage mail = MailUtil.generateMail(newsletterUser.getUserName(), 
                        newsletterUser.getPersonal(), senderAddress, senderName, subject, messageBody);
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
