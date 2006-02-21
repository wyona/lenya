/**
 * 
 */
package com.wyona.james.repository;

import java.io.Serializable;

import javax.mail.internet.ParseException;

import org.apache.james.services.User;
import org.apache.mailet.MailAddress;

/**
 * NewsletterUser implementation
 * 
 * @author greg
 */
public class NewsletterUser implements User, Serializable {

    /** The users email address */
    private String emailAddr;    

    public NewsletterUser(String emailAddress) {
        this.emailAddr = emailAddress;
    }

    public NewsletterUser(MailAddress emailAddress) {
        this.emailAddr = emailAddress.getUser() + "@" + emailAddress.getHost();
    }
    
    /**
     * Get the MailAddress object for this user
     * @return the MailAddress object for this user
     * @throws ParseException 
     */
    public MailAddress getMailAddress() throws ParseException {
        return new MailAddress(this.emailAddr);
    }
    
    /**
     * Set the email address for this user
     * @param mailAddress the mail addres for this user
     */
    public void setMailAddress(MailAddress mailAddress) {
        this.emailAddr = mailAddress.getUser() + "@" + mailAddress.getHost();        
    }
    
    /* (non-Javadoc)
     * @see org.apache.james.services.User#getUserName()
     */
    public String getUserName() {
        return this.emailAddr;
    }
        
    /* (non-Javadoc)
     * @see org.apache.james.services.User#verifyPassword(java.lang.String)
     */
    public boolean verifyPassword(String pass) {
        return false;
    }

    /* (non-Javadoc)
     * @see org.apache.james.services.User#setPassword(java.lang.String)
     */
    public boolean setPassword(String newPass) {
        return false;
    }

}
