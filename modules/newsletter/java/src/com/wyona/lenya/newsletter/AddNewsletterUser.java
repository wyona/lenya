package com.wyona.lenya.newsletter;

import java.rmi.RemoteException;

import org.apache.lenya.cms.usecase.AbstractUsecase;

import com.wyona.james.rmi.NewsletterManager;
import com.wyona.lenya.rmi.RMIException;
import com.wyona.lenya.rmi.RMIProvider;

/**
 * Usecase to add one user to a newsletter repository
 * 
 * @author Gregor Imboden
 */
public class AddNewsletterUser extends AbstractUsecase {

    private NewsletterManager newsletterManager;
    
    private static final String NEWSLETTER_MANAGER_NAME = "newsletterManager";    
    
    private static final String EMAIL_ADDR_PARAM_NAME = "email-address";            
    private static final String NEWSLETTER_PARAM_NAME = "newsletter";    
    private static final String PERSONAL_PARAM_NAME = "personal";    
    
    /* (non-Javadoc)
     * @see org.apache.lenya.cms.usecase.AbstractUsecase#doExecute()
     */
    protected void doExecute() throws Exception {
        super.doExecute();     
        this.setExitParameter(NEWSLETTER_PARAM_NAME, this.getParameterAsString(NEWSLETTER_PARAM_NAME));
        RMIProvider rmiProvider = null;        
        try {
            rmiProvider = (RMIProvider) this.manager.lookup(RMIProvider.ROLE);
            this.newsletterManager = (NewsletterManager) rmiProvider.getRMIObject(NEWSLETTER_MANAGER_NAME);
            String newsletter = this.getParameterAsString(NEWSLETTER_PARAM_NAME);
            if (newsletter == null) {
                this.addErrorMessage("No newsletter repository specified");
            } else if (!this.newsletterManager.setRepository(newsletter)) {
                this.addErrorMessage("No newsletter repository found with that name");
            }
            String personal = this.getParameterAsString(PERSONAL_PARAM_NAME);
            if (personal == null || personal.length() == 0) {
                this.addErrorMessage("Invalid name");
            }
            String emailAddress = this.getParameterAsString(EMAIL_ADDR_PARAM_NAME);
            if (!isValidEmailAddress(emailAddress)) {
                this.addErrorMessage("Invalid email address");            
            }
            if (!this.hasErrors()) {
                if (!this.newsletterManager.addUser(emailAddress, personal)) {
                    this.addErrorMessage("Newsletter User already exists: " + emailAddress);
                }
            }
        } catch (RMIException e) {
            this.addErrorMessage(e.getMessage());
        } catch (RemoteException e) {
            String msg = "An error occured while adding a newsletter user, check the RMI connection";
            getLogger().error(msg, e);
            this.addErrorMessage(msg);
        } finally {
            if (rmiProvider != null) {
                this.manager.release(rmiProvider);
            }
        }
    }        
    
    /**
     * Check wether the emailAddress is a valid email address
     * @param emailAddress
     * @return true if the emailAddress is valid otherwise false
     */
    private boolean isValidEmailAddress(String emailAddress) {
        // http://www.h2co3.com/blog/archives/000013.html
        return emailAddress.matches("^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*$");
    }
    
}
