/**
 * 
 */
package com.wyona.james.matcher;

import java.util.Collection;

import javax.mail.MessagingException;

import org.apache.mailet.GenericMatcher;
import org.apache.mailet.Mail;
import org.apache.mailet.MailAddress;
import org.apache.mailet.MatcherConfig;

/**
 * This matcher determines wheter a mail belongs to a newsletter
 * registration request, it does this by checking the recipient address
 * against a configured pattern
 * 
 * @author Gregor Imboden
 */
public class NewsletterMatcher extends GenericMatcher {
    
    private String newsletterAddr;
    private MailAddress subscribeAddr;    
    
    /** 
     * The subscribe command, recipient addresses have to end with this String
     * to be recognized.
     */
    public final static String COMMAND_SUBSCRIBE = "-subscribe";
    
    
    /* (non-Javadoc)
     * @see org.apache.mailet.Matcher#destroy()
     */
    public void destroy() {
        // TODO Auto-generated method stub

    }

    /* (non-Javadoc)
     * @see org.apache.mailet.Matcher#init(org.apache.mailet.MatcherConfig)
     */
    public void init(MatcherConfig config) throws MessagingException {        
        super.init(config);        
        this.newsletterAddr = this.getCondition();
        String[] userHost = this.newsletterAddr.split("@");
        if (userHost.length != 2) {
            String msg = "invalid matcher condition, expected <user>@<host> found: " + this.newsletterAddr;
            log(msg);
            throw new MessagingException(msg);
        }
        String user = userHost[0];
        String host = userHost[1];
        this.subscribeAddr = new MailAddress(user + COMMAND_SUBSCRIBE + "@" + host);
    }
        
    /* (non-Javadoc)
     * @see org.apache.mailet.Matcher#match(org.apache.mailet.Mail)
     */
    public Collection match(Mail mail) throws MessagingException {
        Collection recipients = mail.getRecipients();
        if (recipients.size() == 1 && recipients.contains(this.subscribeAddr)) {
            log("matched newsletter subscription request from user " + mail.getSender().getUser());
            return recipients;
        }
        log("ignoring message from: " + mail.getSender().getUser());
        return null;
    }

}
