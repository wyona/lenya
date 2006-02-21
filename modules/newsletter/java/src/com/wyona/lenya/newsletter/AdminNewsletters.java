package com.wyona.lenya.newsletter;

import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.Iterator;

import org.apache.lenya.cms.usecase.AbstractUsecase;

import com.wyona.james.rmi.NewsletterManager;
import com.wyona.lenya.rmi.RMIException;
import com.wyona.lenya.rmi.RMIProvider;

/**
 * This usecase generates an overview over all newsletter repositories
 * 
 * @author Gregor Imboden
 */
public class AdminNewsletters extends AbstractUsecase {

    private NewsletterManager newsletterManager;
    
    private static final String NEWSLETTER_MANAGER_NAME = "newsletterManager";  
    
    private static final String REPOSITORIES_PARAM_NAME = "repositories";

    
    /* (non-Javadoc)
     * @see org.apache.lenya.cms.usecase.AbstractUsecase#doCheckPreconditions()
     */
    protected void doCheckPreconditions() throws Exception {
        super.doCheckPreconditions();        
        RMIProvider rmiProvider = null;         
        try {
            rmiProvider = (RMIProvider) this.manager.lookup(RMIProvider.ROLE);
            this.newsletterManager = (NewsletterManager) rmiProvider.getRMIObject(NEWSLETTER_MANAGER_NAME);            
            Iterator it = this.newsletterManager.getRepositoryNames().iterator();
            ArrayList repositoryNames = new ArrayList();
            while (it.hasNext()) {
                repositoryNames.add(it.next());
            }
            this.setParameter(REPOSITORIES_PARAM_NAME, repositoryNames.toArray());
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
