/**
 * 
 */
package com.wyona.lenya.newsletter;

import java.io.InputStreamReader;
import java.io.Reader;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.Iterator;

import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;
import org.apache.avalon.framework.service.ServiceException;
import org.apache.excalibur.source.Source;
import org.apache.excalibur.source.SourceResolver;
import org.apache.lenya.cms.publication.ResourceType;
import org.apache.lenya.cms.usecase.DocumentUsecase;
import org.apache.lenya.cms.usecase.UsecaseException;

import com.wyona.james.rmi.NewsletterManager;
import com.wyona.lenya.rmi.RMIException;
import com.wyona.lenya.rmi.RMIProvider;

/**
 * Usecase to send the current document as a plaintext newsletter to all
 * users in the selected repository. 
 * 
 * This usescase has two steps:
 *  "init" - the user can select the newsletter repostiroy and set some parameters 
 *  "confirm" - the user sees his configration and has to confirm it
 *  if he confirms the selection the newsletter gets sent to the users 
 *  
 * @author Gregor Imboden
 */
public class SendNewsletter extends DocumentUsecase {

    private NewsletterManager newsletterManager;
    
    private static final String NEWSLETTER_MANAGER_NAME = "newsletterManager";    
    
    private static final String NEWSLETTER_ELEMENT_NAME = "newsletter";
    private static final String SENDER_ELEMENT_NAME = "sender";
    private static final String FORMAT_ELEMENT_NAME = "format";
    private static final String NAME_ATTRIBUTE_NAME = "name";
    private static final String ADDR_ATTRIBUTE_NAME = "addr";
        
    private static final String REPOSITORIES_PARAM_NAME = "repositories";    
    private static final String REPOSITORY_PARAM_NAME = "repository";
    private static final String USER_COUNT_PARAM_NAME = "nr-users";
    private static final String SUBJECT_PARAM_NAME = "subject";    
    private static final String STEP_PARAM_NAME = "step";
    
    /** The sender name used for outgoing mails */
    private String senderName;
    /** The sender email address used for outgoing mails */
    private String senderEmailAddress;
    /** The name of the configured format */
    private String formatName;    
    
    /* (non-Javadoc)
     * @see org.apache.lenya.cms.usecase.AbstractUsecase#configure(org.apache.avalon.framework.configuration.Configuration)
     */
    public void configure(Configuration config) throws ConfigurationException {
        super.configure(config);
        Configuration newsletterConfig = config.getChild(NEWSLETTER_ELEMENT_NAME);
        Configuration senderConfig = newsletterConfig.getChild(SENDER_ELEMENT_NAME);
        if (senderConfig == null) {
            throw new ConfigurationException("A newsletter must have a sender");
        }
        this.senderName = senderConfig.getAttribute(NAME_ATTRIBUTE_NAME);
        if (this.senderName == null) {
            throw new ConfigurationException("The sender name has to be specified");
        }
        this.senderEmailAddress = senderConfig.getAttribute(ADDR_ATTRIBUTE_NAME);
        if (this.senderEmailAddress == null) {
            throw new ConfigurationException("The sender email address has to be specified");
        }
        Configuration formatConfiguration= newsletterConfig.getChild(FORMAT_ELEMENT_NAME);
        this.formatName = formatConfiguration.getAttribute(NAME_ATTRIBUTE_NAME);
        if (this.formatName == null) {
            throw new ConfigurationException("The format name must be specified");
        }
    }

    /* (non-Javadoc)
     * @see org.apache.lenya.cms.usecase.DocumentUsecase#doCheckPreconditions()
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
        this.setParameter(STEP_PARAM_NAME, "init");             
    }

    /* (non-Javadoc)
     * @see org.apache.lenya.cms.usecase.AbstractUsecase#advance()
     */
    public void advance() throws UsecaseException {
        super.advance();        
        String repository = this.getParameterAsString(REPOSITORY_PARAM_NAME);
        RMIProvider rmiProvider = null;
        try {
            rmiProvider = (RMIProvider) this.manager.lookup(RMIProvider.ROLE);
            this.newsletterManager = (NewsletterManager) rmiProvider.getRMIObject(NEWSLETTER_MANAGER_NAME);
            if (!this.newsletterManager.setRepository(repository)) {
                this.addErrorMessage("No repository found with name: " + repository);
            }            
            Integer userCount = new Integer(this.newsletterManager.countUsers());
            this.setParameter(USER_COUNT_PARAM_NAME, userCount);    
        } catch (RMIException e) {
            this.addErrorMessage(e.getMessage());
        } catch (RemoteException e) {
            String msg = "Error occured while accessing a remote object: " + NEWSLETTER_MANAGER_NAME;
            getLogger().error(msg, e);
            this.addErrorMessage(msg);
        } catch (ServiceException e) {
            throw new UsecaseException(e);
        } finally {
            if (rmiProvider != null) {
                this.manager.release(rmiProvider);
            }
        }
        this.setParameter(STEP_PARAM_NAME, "confirm");        
    }    
    
    /* (non-Javadoc)
     * @see org.apache.lenya.cms.usecase.AbstractUsecase#doExecute()
     */
    protected void doExecute() throws Exception {
        super.doExecute();        
        String repository = this.getParameterAsString(REPOSITORY_PARAM_NAME);
        String subject = this.getParameterAsString(SUBJECT_PARAM_NAME, "Newsletter");        
        RMIProvider rmiProvider = null;        
        SourceResolver resolver = null;        
        try {
            rmiProvider = (RMIProvider) this.manager.lookup(RMIProvider.ROLE);
            resolver = (SourceResolver) this.manager.lookup(SourceResolver.ROLE);            
            this.newsletterManager = (NewsletterManager) rmiProvider.getRMIObject(NEWSLETTER_MANAGER_NAME);
            if (!this.newsletterManager.setRepository(repository)) {
                this.addInfoMessage("No repository found with name: " + repository);
                return;
            }            
            ResourceType resourceType = this.getSourceDocument().getResourceType();
            String formatURI = resourceType.getFormatURI(this.formatName);            
            String body = getURIContentsAsString(resolver, formatURI);
            this.newsletterManager.sendMailToRepositoryUsers(this.senderEmailAddress, this.senderName, subject, body);                
        } catch (RMIException e) {
            this.addErrorMessage(e.getMessage());
        } catch (RemoteException e) {
            String msg = "Error occured while accessing a remote object: " + NEWSLETTER_MANAGER_NAME;
            getLogger().error(msg, e);
            this.addErrorMessage(msg);
            throw new RemoteException(msg, e);
        } catch (ServiceException e) {
            throw new UsecaseException(e);
        } finally {
            if (rmiProvider != null) {
                this.manager.release(rmiProvider);
            }
            if (resolver != null) {
                this.manager.release(resolver);
            }
        }            
    }
    
    /**
     * Resolves the URI and returns it's contents as a String object
     * @param resolver The SourceResolver
     * @param uri The URI
     * @return The URI content
     * @throws Exception
     */
    private String getURIContentsAsString(SourceResolver resolver, String uri) throws Exception {
        Source source = resolver.resolveURI(uri);            
        Reader reader = new InputStreamReader(source.getInputStream(), "UTF-8");                        
        StringBuffer buf = new StringBuffer();
        int rb = 0;
        char[] cbuf = new char[1024];
        while ((rb = reader.read(cbuf)) > 0) {
            buf.append(cbuf, 0, rb);
        }          
        return buf.toString();
    }

}
