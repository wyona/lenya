/*
 * <License>
 * The Apache Software License
 *
 * Copyright (c) 2002 lenya. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice, this
 *    list of conditions and the following disclaimer in the documentation and/or
 *    other materials provided with the distribution.
 *
 * 3. All advertising materials mentioning features or use of this software must
 *    display the following acknowledgment: "This product includes software developed
 *    by lenya (http://www.lenya.org)"
 *
 * 4. The name "lenya" must not be used to endorse or promote products derived from
 *    this software without prior written permission. For written permission, please
 *    contact contact@lenya.org
 *
 * 5. Products derived from this software may not be called "lenya" nor may "lenya"
 *    appear in their names without prior written permission of lenya.
 *
 * 6. Redistributions of any form whatsoever must retain the following acknowledgment:
 *    "This product includes software developed by lenya (http://www.lenya.org)"
 *
 * THIS SOFTWARE IS PROVIDED BY lenya "AS IS" WITHOUT ANY WARRANTY EXPRESS OR IMPLIED,
 * INCLUDING THE WARRANTY OF NON-INFRINGEMENT AND THE IMPLIED WARRANTIES OF MERCHANTI-
 * BILITY AND FITNESS FOR A PARTICULAR PURPOSE. lenya WILL NOT BE LIABLE FOR ANY DAMAGES
 * SUFFERED BY YOU AS A RESULT OF USING THIS SOFTWARE. IN NO EVENT WILL lenya BE LIABLE
 * FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR LOST PROFITS EVEN IF lenya HAS
 * BEEN ADVISED OF THE POSSIBILITY OF THEIR OCCURRENCE. lenya WILL NOT BE LIABLE FOR ANY
 * THIRD PARTY CLAIMS AGAINST YOU.
 *
 * Lenya includes software developed by the Apache Software Foundation, W3C,
 * DOM4J Project, BitfluxEditor and Xopus.
 * </License>
 */
package ch.unizh.unipublic.lenya.cms.task;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.avalon.framework.parameters.ParameterException;
import org.apache.avalon.framework.parameters.Parameters;
import org.apache.lenya.cms.publication.DocumentBuildException;
import org.apache.lenya.cms.publication.DocumentBuilder;
import org.apache.lenya.cms.publication.DocumentException;
import org.apache.lenya.cms.publication.DublinCore;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.Resource;
import org.apache.lenya.cms.publication.ResourceIdentityMap;
import org.apache.lenya.cms.publication.SiteTreeNode;
import org.apache.lenya.cms.publication.Version;
import org.apache.lenya.cms.rc.RevisionControlException;
import org.apache.lenya.cms.site.SiteException;
import org.apache.lenya.cms.site.SiteManager;
import org.apache.lenya.cms.task.ExecutionException;
import org.apache.lenya.workflow.WorkflowException;
import org.apache.lenya.xml.DocumentHelper;
import org.apache.log4j.Category;
import org.xml.sax.SAXException;

import ch.unizh.lenya.cms.task.ResourceTask;
import ch.unizh.unipublic.lenya.cms.publication.Dossier;
import ch.unizh.unipublic.lenya.cms.publication.DossierVersion;
import ch.unizh.unipublic.lenya.cms.publication.UnipublicResourceIdentityMap;

/**
 * Abstract super class for dossier-based tasks.
 * 
 * @author <a href="mailto:edith@apache.org">Edith Chevrier</a>
 */
public abstract class DossierTask extends ResourceTask {

    private static final Category log = Category.getInstance(DossierTask.class);
    public static final String PARAMETER_LANGUAGE = "document-language";
    private List messages = new ArrayList();

    private ResourceIdentityMap identityMap;

    /**
     * Returns the identity map.
     * @return A resource identity map.
     * @throws ExecutionException when something went wrong.
     */
    protected ResourceIdentityMap getIdentityMap() throws ExecutionException {
        if (identityMap == null) {
            identityMap = new UnipublicResourceIdentityMap(getPublication());
        }
        return identityMap;
    }
    /**
     * @see org.apache.lenya.cms.task.Task#execute(java.lang.String)
     */
    public void execute(String servletContextPath) throws ExecutionException {
        try {
            Resource resource = getResource();
            String userId = getUser();
            Dossier[] dossiers = getDossiers(resource);

            cleanMessages();

            if (!checkPreconditions(resource, dossiers)) {
                setResult(FAILURE);
            } else {
                if (log.isDebugEnabled()) {
                    log.debug("Can execute task: preconditions are complied");
                }
                
                checkoutAllDocuments(resource, dossiers, userId); 
                try {
                    executeTask(resource, dossiers);
                } catch (Exception e) {
                    log.error(e.getMessage(), e);
                    checkinAllDocuments(resource, dossiers, userId);
                }
                checkinAllDocuments(resource, dossiers, userId);
                setResult(SUCCESS);
            }
            addMessages(); 
        } catch (ExecutionException e) {
            throw e;
        } catch (Exception e) {
            throw new ExecutionException(e);
        }

    }
    /**
     * Checks if the preconditions are complied.
     * @param resource The resource
     * @param dossiers The dossiers
     * @return boolean. True if the preconditions are complied
     * @throws ExecutionException when something went wrong
     * @throws PublicationException when something went wrong
     * @throws DocumentBuildException when something went wrong
     * @throws ParameterException when something went wrong
     * @throws WorkflowException when something went wrong
     * @throws RevisionControlException when something went wrong
     */
    protected boolean checkPreconditions(Resource resource, Dossier[] dossiers)
        throws
            ExecutionException,
            PublicationException,
            DocumentBuildException,
            ParameterException,
            WorkflowException, RevisionControlException {

        boolean OK = true;
            String userId = getUser();
            List versions = new ArrayList();

            Version authoringVersion = getVersion(resource, Publication.AUTHORING_AREA, getLanguage());
			if (!authoringVersion.canCheckOut(userId)) {
                OK = false;
                messages.add("The resource ["+authoringVersion+"] is checked out by another user.");
                if (log.isDebugEnabled()) {
			        log.error("The resource [" + authoringVersion
			                + "] is checked out by another user.");
			    }
				return OK;        
			}
            if (!authoringVersion.canWorkflowFire(getEventName(), getSituation())) {
                OK = false;
                if (log.isDebugEnabled()) {
                    log.debug(
                        "Cannot execute task: the workflow event [" + getEventName() + "] isn't supported for the resource.");
                }
            }
            
            
            for (int i=0; i<dossiers.length; i++){
                DossierVersion  dossierVersion = (DossierVersion) getVersion(dossiers[i], Publication.AUTHORING_AREA, getLanguage());       
                if (!dossierVersion.canCheckOut(userId)) {
                    OK = false;
                    messages.add("The resource ["+dossierVersion+"] is checked out by another user.");
                    if (log.isDebugEnabled()) {
                        log.error("The dossier [" + dossierVersion
                                + "] is checked out by another user.");
                    }
                    return OK;
                }
                if (!dossierVersion.canWorkflowFire(getEventName(), getSituation())) {
                    OK = false;
                    if (log.isDebugEnabled()) {
                        log.debug(
                            "Cannot execute task: the workflow event [" + getEventName() + "] is not supported for the dossier: "+dossierVersion);
                    }
                }
                
            }

        return OK;
    }

    /**execute the task
     * @param resource The resource
     * @param dossiers The dossiers
     * @throws ParameterException when something went wrong
     * @throws ExecutionException when something went wrong
     * @throws PublicationException when something went wrong
     */
    abstract void executeTask(Resource resource, Dossier[] dossiers) throws ParameterException, ExecutionException, PublicationException, WorkflowException;

    /**
     * Check out the resource and the dossiers.
     * @param resource The resource.
     * @param dossiers The dossiers.
     * @param userId The user.
     * @throws ParameterException when something went wrong.
     * @throws ExecutionException when something went wrong.
     * @throws PublicationException when something went wrong.
     * @throws RevisionControlException when something went wrong.
     */
    protected void checkoutAllDocuments(Resource resource, Dossier[] dossiers, String userId) throws ParameterException, ExecutionException, PublicationException, RevisionControlException {
        Version authoringVersion = getVersion(resource, Publication.AUTHORING_AREA,  getLanguage());
        authoringVersion.checkOut(userId);
        for (int i=0; i<dossiers.length; i++){
            DossierVersion  dossierVersion = (DossierVersion) getVersion(dossiers[i], Publication.AUTHORING_AREA, getLanguage());
            dossierVersion.checkOut(userId);
        }
    }

    /**
     * Check in the resource and the dossiers.
     * @param resource The resource.
     * @param dossiers The dossiers.
     * @param userId The user.
     * @throws ParameterException when something went wrong.
     * @throws ExecutionException when something went wrong.
     * @throws PublicationException when something went wrong.
     * @throws RevisionControlException when something went wrong.
     */
    protected void checkinAllDocuments(Resource resource, Dossier[] dossiers, String userId) throws ParameterException, ExecutionException, PublicationException, RevisionControlException{
        Version authoringVersion = getVersion(resource, Publication.AUTHORING_AREA,  getLanguage());
        authoringVersion.checkIn(userId);
        for (int i=0; i<dossiers.length; i++){
            DossierVersion  dossierVersion = (DossierVersion) getVersion(dossiers[i], Publication.AUTHORING_AREA, getLanguage());
            dossierVersion.checkIn(userId);
        }
    }

    /**
     * Get the resources of the dossiers with which the task should be executed.
     * @param resource The resource
     * @return A set of dossiers. The dossiers.
     * @throws ParameterException when something went wrong. 
     * @throws ExecutionException when something went wrong.
     * @throws PublicationException when something went wrong.
     */
    protected Dossier[] getDossiers(Resource resource) throws ParameterException, ExecutionException, PublicationException{
        List dossiers = new ArrayList();
        String[] dossiersIds = getDossiersId(resource);
        for (int i=0; i<dossiersIds.length; i++){
            Dossier dossier = (Dossier) getIdentityMap().get(dossiersIds[i]);
            dossiers.add(dossier);
        }
        return (Dossier[]) dossiers.toArray(new Dossier[dossiers.size()]);
        
    }

    /**
     * Get the ids of the dossiers from the task's parameters.
     * @param resource A resource.
     * @return A set of strings The ids
     * @throws ParameterException when something went wrong.
     * @throws ExecutionException when something went wrong.
     * @throws PublicationException when something went wrong.s
     */
    protected String[] getDossiersId(Resource resource) throws ParameterException, ExecutionException, PublicationException {
        List dossierIds = new ArrayList();
        String[] names = getParameters().getNames();

        for (int i=0; i<names.length; i++){
            if (names[i].startsWith("dossier-id")){
                String dossierId = getParameters().getParameter(names[i]);
                dossierIds.add(dossierId); 
            }
        }
        return (String[]) dossierIds.toArray(new String[dossierIds.size()]);
    }

    /**
     * Returns the user
     * @return A string.
     * @throws ParameterException when the parameter is not present.
     */
    protected String getUser() throws ParameterException {
        String userId = getParameters().getParameter("user-id");

        return userId;
    }

    /**
     * Returns the language.
     * @return A string.
     * @throws ParameterException when the parameter is not present.
     * @throws ExecutionException when the language is not valid.
     */
    protected String getLanguage() throws ParameterException, ExecutionException {
        String language = getParameters().getParameter(PARAMETER_LANGUAGE);

        String[] languages = getPublication().getLanguages();
        if (!Arrays.asList(languages).contains(language)) {
            throw new ExecutionException("The language [" + language + "] is not valid!");
        }

        return language;
    }

    /**
     * Get the file in which the messages are written
     * @return File The file.
     * @throws ExecutionException when something went wrong.
     * @throws ParameterException when something went wrong.
     */
    protected File getMessagesFile() throws ExecutionException, ParameterException{
        
        String fileName = getParameters().getParameter("messages-file");
        File file = new File(getPublication().getDirectory(), fileName);
        return file; 
        
    }
    /**
     * Add a message in the message's file, to which it will be redirected
     * @throws ExecutionException when something went wrong.
     */
    protected void addMessages() throws ExecutionException{
        try {
            File file = getMessagesFile();

            org.w3c.dom.Document doc = DocumentHelper.readDocument(file);
            org.w3c.dom.Element root = doc.getDocumentElement();
            for (int i=0; i<messages.size(); i++){
                String message = (String)messages.get(i);
                org.w3c.dom.Element messageE = doc.createElement("message");
                org.w3c.dom.Node node = doc.createTextNode(message);
                messageE.appendChild(node);
                root.appendChild(messageE);
            }
            DocumentHelper.writeDocument(doc, file);
        } catch (Exception e) {
            log.error(e.getMessage(), e);
            throw new ExecutionException(e);
        }
    }

    /**Clean the messages in the message's file, to which it will be redirected
     * @throws ExecutionException when something went wrong.
     */
    protected void cleanMessages() throws ExecutionException{
        try {
            File file = getMessagesFile();
             
            org.w3c.dom.Document doc = DocumentHelper.readDocument(file);
            org.w3c.dom.Element root = doc.getDocumentElement();
            org.w3c.dom.NodeList children = root.getChildNodes();
            for(int i=0; i<children.getLength(); i++){
                org.w3c.dom.Node child = children.item(i); 
                if (child.getNodeName().equals("message")){
                    root.removeChild(child);       
                }
            }
            DocumentHelper.writeDocument(doc, file);
        } catch (Exception e) {
            log.error(e.getMessage(), e);
            throw new ExecutionException(e);
        }
    }
    
}
