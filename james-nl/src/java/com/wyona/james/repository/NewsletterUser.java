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

    /** The personal string of this user */
    private String personal;
    
    public NewsletterUser(String emailAddress) {
        this.emailAddr = emailAddress;
        this.personal = null;
    }

    public NewsletterUser(String emailAddress, String personal) {
        this.emailAddr = emailAddress;
        this.personal = personal;
    }
    
    public NewsletterUser(MailAddress emailAddress) {
        this.emailAddr = emailAddress.getUser() + "@" + emailAddress.getHost();
        this.personal = null;
    }

    public NewsletterUser(MailAddress emailAddress, String personal) {
        this.emailAddr = emailAddress.getUser() + "@" + emailAddress.getHost();
        this.personal = personal;
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
       
    /**
     * Set this users personal
     * @param name the user name
     */
    public void setPersonal(String personal) {
        this.personal = personal;
    }

    /**
     * Get this users personal
     * @param name the users personal
     */
    public String getPersonal() {
        return this.personal;
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
