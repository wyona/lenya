package com.wyona.lenya.newsletter;

import java.rmi.RemoteException;

import org.apache.lenya.cms.usecase.AbstractUsecase;

import com.wyona.james.rmi.NewsletterManager;
import com.wyona.lenya.rmi.RMIException;
import com.wyona.lenya.rmi.RMIProvider;

/**
 * Usecase to delete a newsletter user
 * 
 * @author Gregor Imboden
 */
public class DelNewsletterUser extends AbstractUsecase {

    private NewsletterManager newsletterManager;
    
    private static final String NEWSLETTER_MANAGER_NAME = "newsletterManager";    
    
    private static final String EMAIL_ADDR_PARAM_NAME = "email-address";            
    private static final String NEWSLETTER_PARAM_NAME = "newsletter";    
        
    
    /* (non-Javadoc)
     * @see org.apache.lenya.cms.usecase.AbstractUsecase#doExecute()
     */
    protected void doExecute() throws Exception {
        super.doExecute();       
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
            String emailAddress = this.getParameterAsString(EMAIL_ADDR_PARAM_NAME);
            if (emailAddress != null) {
                if (!this.newsletterManager.delUser(emailAddress)) {
                    this.addErrorMessage("Newsletter User does not exist: " + emailAddress);
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
    
}
