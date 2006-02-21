/**
 * 
 */
package com.wyona.james.mailet;

import javax.mail.MessagingException;

import org.apache.avalon.framework.component.ComponentException;
import org.apache.avalon.framework.component.ComponentManager;
import org.apache.james.Constants;
import org.apache.james.services.UsersRepository;
import org.apache.james.services.UsersStore;
import org.apache.mailet.GenericMailet;
import org.apache.mailet.Mail;
import org.apache.mailet.MailetConfig;

import com.wyona.james.repository.NewsletterUser;

/**
 * This mailet handles newsletter registration mails, it adds all
 * senders to the configured newsletter store
 * 
 * @author Gregor Imboden
 */
public class NewsletterMailet extends GenericMailet {
    
    private UsersRepository repository;
    
    private static final String CONF_REPO_NAME = "repositoryName";
        
    /* (non-Javadoc)
     * @see org.apache.mailet.Mailet#init(org.apache.mailet.MailetConfig)
     */
    public void init(MailetConfig config) throws MessagingException {       
        super.init(config);
        ComponentManager componentManager = (ComponentManager) getMailetContext().getAttribute(Constants.AVALON_COMPONENT_MANAGER);        
        try {
            UsersStore usersStore = (UsersStore) componentManager.lookup("org.apache.james.services.UsersStore");
            String repositoryName = this.getInitParameter(CONF_REPO_NAME);
            log("Using repository: " + repositoryName);
            this.repository = usersStore.getRepository(repositoryName);            
        } catch (ComponentException e) {
            String msg = "error while looking up UsersStore component";
            log(msg, e);
            throw new MessagingException(msg, e);
        } 
    }

    /* (non-Javadoc)
     * @see org.apache.mailet.Mailet#service(org.apache.mailet.Mail)
     */
    public void service(Mail mail) throws MessagingException {
        NewsletterUser user = new NewsletterUser(mail.getSender());
        if (!this.repository.contains(user.getUserName())) {
            this.repository.addUser(user);
            log("adding user " + user.getUserName() + " to the newsletter repository");
        } else {
            log("user " + user.getUserName() + " is already registered, ignoring");
        }
        mail.setState(Mail.GHOST);
    }

}
