package com.wyona.lenya.newsletter;

import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.HashMap;

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
    private static final String PAGES_PARAM_NAME = "pages";
    private static final String PAGENR_PARAM_NAME = "pagenr";
    private static final String QUERY_PARAM_NAME = "query";
    private static final String USER_COUNT_PARAM_NAME = "user-count";
    
    private static final String USER_COUNT_KEY = "userCount";
    private static final String USER_LIST_KEY = "userList";
    
    private static final int MAX_USERS_PER_PAGE = 7;
    
    /* (non-Javadoc)
     * @see org.apache.lenya.cms.usecase.AbstractUsecase#doCheckPreconditions()
     */
    protected void doCheckPreconditions() throws Exception {
        super.doCheckPreconditions();        
        RMIProvider rmiProvider = null;       
        try {
            rmiProvider = (RMIProvider) this.manager.lookup(RMIProvider.ROLE);
            this.newsletterManager = (NewsletterManager) rmiProvider.getRMIObject(NEWSLETTER_MANAGER_NAME);
            int pageNr = this.getParameterAsInteger(PAGENR_PARAM_NAME, 1);
            String query = this.getParameterAsString(QUERY_PARAM_NAME, "");            
            String newsletter = this.getParameterAsString(NEWSLETTER_PARAM_NAME);
            if (newsletter == null) {
                this.addErrorMessage("No newsletter repository specified");
            } else if (!this.newsletterManager.setRepository(newsletter)) {
                this.addErrorMessage("No newsletter repository found with that name");
            }
            if (!this.hasErrors()) {
                HashMap userNr = this.newsletterManager.getPaginatedUserList(MAX_USERS_PER_PAGE, pageNr, query);
                Integer totUsers = (Integer) userNr.get(USER_COUNT_KEY);
                ArrayList userList = (ArrayList) userNr.get(USER_LIST_KEY);
                this.setParameter(PAGES_PARAM_NAME, this.pageArray(totUsers.intValue()));
                this.setParameter(PAGENR_PARAM_NAME, String.valueOf(pageNr));
                this.setParameter(USERS_PARAM_NAME, userList);
                this.setParameter(USER_COUNT_PARAM_NAME, totUsers);
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
    
    /**
     * Returns the number of pages needed for this nrUsers
     * @param nrUsers
     * @return the number of pages
     */
    private int pageCount(int nrUsers) {
        int pages = 1;
        if (nrUsers > MAX_USERS_PER_PAGE) {
            pages = nrUsers / MAX_USERS_PER_PAGE;
            if (nrUsers % MAX_USERS_PER_PAGE != 0) {
                pages += 1;
            }
        }
        return pages;
    }
    
    /**
     * Returns an int Array containing the pagenumbers needed for this nrUsers
     * @param nrUsers
     * @return an int array containing all pagenumbers
     */
    private int[] pageArray(int nrUsers) {
        int pages = pageCount(nrUsers);
        int pageArray[] = new int[pages];
        for (int i=0; i<pageArray.length; i++) {
            pageArray[i] = i+1;
        }
        return pageArray;
    }
}
