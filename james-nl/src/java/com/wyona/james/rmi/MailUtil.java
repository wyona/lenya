/**
 * 
 */
package com.wyona.james.rmi;

import javax.activation.DataHandler;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import org.apache.james.transport.mailets.listservcommands.MailDataSource;

/**
 * Mail utility class, contains helper function for mail message
 * contruction
 * 
 * @author Gregor Imboden
 */
public final class MailUtil {

    /**
     * Generate a MimeMessage with the specified attributes
     * @param destEmailAddr The destination email address
     * @param fromEmailAddr The sender email address
     * @param fromName The senders display name
     * @param emailSubject The subject
     * @param emailPlainText The message body (plaintext)
     * @return The MimeMessage object
     * @throws Exception
     */
    public static MimeMessage generateMail(String destEmailAddr, 
            String destPersonalName,
            String fromEmailAddr,
            String fromName,
            String emailSubject,
            String emailPlainText) throws Exception {

        MimeMessage message = new MimeMessage(Session.getDefaultInstance(System.getProperties(), null));

        InternetAddress[] toAddrs = InternetAddress.parse(destEmailAddr, false);
        if (destPersonalName != null) {
            toAddrs[0].setPersonal(destPersonalName);
        }        
        InternetAddress from = new InternetAddress(fromEmailAddr);
        from.setPersonal(fromName);
        
        message.setRecipients(Message.RecipientType.TO, toAddrs);
        message.setFrom(from);
        message.setSubject(emailSubject);
        message.setSentDate(new java.util.Date());

        MimeMultipart msgbody = new MimeMultipart();
        MimeBodyPart html = new MimeBodyPart();
        html.setDataHandler(new DataHandler(new MailDataSource(emailPlainText, "text/plain")));
        msgbody.addBodyPart(html);
        message.setContent(msgbody);
        
        return message;
    }    
    
}
