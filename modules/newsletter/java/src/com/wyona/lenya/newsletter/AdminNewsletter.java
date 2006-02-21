package com.wyona.lenya.newsletter;

import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.Iterator;

import org.apache.lenya.cms.usecase.AbstractUsecase;

import com.wyona.james.rmi.NewsletterManager;
import com.wyona.lenya.rmi.RMIException;
import com.wyona.lenya.rmi.RMIProvider;

/**
 * Usecase to administer one single newsletter repository
 * 
 * @author Gregor Imboden
 */
public class AdminNewsletter extends AbstractUsecase {

    private NewsletterManager newsletterManager;
    
    private static final String NEWSLETTER_MANAGER_NAME = "newsletterManager";    
    
    private static final String USERS_PARAM_NAME = "users";
    private static final String NEWSLETTER_PARAM_NAME = "newsletter";            
    
    /* (non-Javadoc)
     * @see org.apache.lenya.cms.usecase.AbstractUsecase#doCheckPreconditions()
     */
    protected void doCheckPreconditions() throws Exception {
        super.doCheckPreconditions();        
        RMIProvider rmiProvider = null;       
        try {
            rmiProvider = (RMIProvider) this.manager.lookup(RMIProvider.ROLE);
            this.newsletterManager = (NewsletterManager) rmiProvider.getRMIObject(NEWSLETTER_MANAGER_NAME);
            String newsletter = this.getParameterAsString(NEWSLETTER_PARAM_NAME);
            if (newsletter == null) {
                this.addErrorMessage("No newsletter repository specified");
            } else if (!this.newsletterManager.setRepository(newsletter)) {
                this.addErrorMessage("No newsletter repository found with that name");
            } else {
                this.setParameter(USERS_PARAM_NAME, this.newsletterManager.getUserList());
            }            
        } catch (RMIException e) {
            this.addErrorMessage(e.getMessage());
        } catch (RemoteException e) {
            String msg = "Error occured while accessing a remote object: " + NEWSLETTER_MANAGER_NAME;
            getLogger().error(msg, e);
            this.addErrorMessage(msg);
        } finally {
            if (rmiProvider != null) {
                this.manager.release(rmiProvider);
            }
        }
    }

}
