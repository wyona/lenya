package com.wyona.james.rmi;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.ArrayList;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.apache.mailet.MailAddress;

/**
 * This interface describes the functionality needed to manage and send
 * newsletters over an RMI connection.
 * 
 * @author Gregor Imboden
 */
public interface NewsletterManager extends Remote {

    /**
     * Get a list of all repository names
     * @return List of all repository names
     * @throws RemoteException;
     */
    ArrayList getRepositoryNames() throws RemoteException;
 
    
    /**
     * Set the current repository
     * @return true if the repository was set, false if no repository was found
     * @throws RemoteException
     */
    boolean setRepository(String name) throws RemoteException;
    
    
    /**
     * Add a user to the repository
     * @param emailAddress
     * @return true if the user was added, false if the user already exists
     * @throws RemoteException
     */
    boolean addUser(String emailAddress) throws RemoteException;

    
    /**
     * Delete a user from the repository
     * @param emailAddress
     * @return true if the user was removed, false if the user doesn't exist
     * @throws RemoteException
     */
    boolean delUser(String emailAddress) throws RemoteException;
    
    
    /**
     * Returns a list of all users in the repository
     * @return list of all users in the repository
     * @throws RemoteException
     */
    ArrayList getUserList() throws RemoteException;
    
    
    /**
     * Return the number of users stored in this repository
     * @return the number of users in this repository
     * @throws RemoteException
     */
    int countUsers() throws RemoteException;    
    
    
    /**
     * Send a MimeMessage to all users in the selected repository
     * @param senderAddress The senders email address
     * @param senderName The senders name
     * @param subject The message subject
     * @param messageBody The message body
     * @throws RemoteException
     */
    void sendMailToRepositoryUsers(String senderAddress, String senderName, String subject, String messageBody) 
        throws RemoteException;
}
