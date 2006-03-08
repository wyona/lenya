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
package ch.unizh.lenya.cms.task;

import java.io.File;
import java.util.Arrays;

import org.apache.avalon.framework.parameters.ParameterException;
import org.apache.lenya.cms.publication.DocumentBuildException;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.SiteTree;
import org.apache.lenya.cms.publication.SiteTreeNode;
import org.apache.lenya.cms.publication.SiteTreeException;
import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.Resource;
import org.apache.lenya.cms.publication.Version;
import org.apache.lenya.cms.site.SiteException;
import org.apache.lenya.cms.site.SiteManager;
import org.apache.lenya.cms.task.ExecutionException;
import org.apache.lenya.workflow.WorkflowException;
import org.apache.log4j.Category;

import ch.unizh.lenya.util.CacheHandler;

/**
 * Publish a document.
 * 
 * @author <a href="mailto:andreas@apache.org">Andreas Hartmann</a>
 */
public class Publish extends ResourceTask {

    private static final Category log = Category.getInstance(Publish.class);

    public static final String PARAMETER_LANGUAGE = "document-language";
    public static final String TASK_NAME = "publish";

    /**
     * @see org.apache.lenya.cms.task.Task#execute(java.lang.String)
     */
    public void execute(String servletContextPath) throws ExecutionException {

        if (log.isDebugEnabled()) {
            log.debug("Starting publishing");
        }

        try {
            Resource resource = getResource();

            if (!checkPreconditions(resource)) {
                setResult(FAILURE);
            } else {
                if (log.isDebugEnabled()) {
                    log.debug("Can execute task: parent is published.");
                }
                publish(resource);
                setResult(SUCCESS);
            }

        } catch (ExecutionException e) {
            throw e;
        } catch (Exception e) {
            throw new ExecutionException(e);
        }

    }
    /**
     * Checks if the preconditions are complied.
     * @param resource The root resource of the tree to publish. 
     * @return
     * @throws PublicationException
     * @throws ExecutionException
     * @throws DocumentException
     */
    protected boolean checkPreconditions(Resource resource)
        throws
            ExecutionException,
            PublicationException,
            DocumentBuildException,
            ParameterException,
            WorkflowException {
        boolean OK = true;

        Version authoringVersion = getVersion(resource, Publication.AUTHORING_AREA, getLanguage());
        if (log.isDebugEnabled()) {
            log.debug("Version: [" + authoringVersion + "]");
        }

        if (!authoringVersion.canWorkflowFire(getEventName(), getSituation())) {
            OK = false;
            if (log.isDebugEnabled()) {
                log.debug(
                    "Cannot execute task: workflow event [" + getEventName() + "] not supported.");
            }
        }

        boolean ancestorsPublished = areRequiredResourcesLive(resource);
        OK = OK && ancestorsPublished;

        return OK;
    }

    /**
     * Checks if the required resources are live.
     * @param resource The resource.
     * @return A boolean value.
     * @throws PublicationException if an error occurs.
     * @throws SiteException if an error occurs.
     */
    protected boolean areRequiredResourcesLive(Resource resource)
        throws PublicationException, SiteException {
        boolean ancestorsPublished = true;
        SiteManager manager = resource.getPublicationWrapper().getSiteManager();
        Resource[] requiredResources =
            manager.getRequiredResources(resource, Publication.LIVE_AREA);

        for (int i = 0; i < requiredResources.length; i++) {
            if (!manager.contains(requiredResources[i], Publication.LIVE_AREA)) {
                ancestorsPublished = false;
                if (log.isDebugEnabled()) {
                    log.debug(
                        "The live tree does not contain the required resource ["
                            + requiredResources[i]
                            + "].");
                }
            }
        }
        return ancestorsPublished;
    }

    /**
     * Publishes a resource.
     * @param resource The resource.
     */
    protected void publish(Resource resource)
        throws PublicationException, ExecutionException, ParameterException, WorkflowException {
        publish(resource, getLanguage(), null, 1);
    }

    /**
     * Publishes a certain language version of a resource.
     * @param resource The resource.
     * @param language The language.
     * @param rootNode only if a subtree should be published otherwise null
     * @numOfDocumentsToPublish Number of Documenst to publish. Usually > 1 if a subtree is published
     */
    protected void publish(Resource resource, String language, Resource rootNode, int numOfDocumentsToPublish)
        throws ParameterException, ExecutionException, PublicationException, WorkflowException {
        
        Version authoringVersion = getVersion(resource, Publication.AUTHORING_AREA, language);
        
        if (authoringVersion.canWorkflowFire(getEventName(), getSituation())
            && areRequiredResourcesLive(resource)) {
            Version liveVersion = getVersion(resource, Publication.LIVE_AREA, getLanguage());
            boolean isLive = isNodeLive(liveVersion);

            resource.getPublicationWrapper().copy(authoringVersion, liveVersion);
            copyResources(authoringVersion.getDocument(), liveVersion.getDocument());

            authoringVersion.triggerWorkflow(getEventName(), getSituation());
            
            try {
                if (rootNode == null){
                    CacheHandler cacheHandler = new CacheHandler();
                    cacheHandler.deleteCache(liveVersion, isLive, TASK_NAME);
                }
            } catch (SiteTreeException e) {
                throw new ExecutionException ("Unable to get sitetree.", e);
            }
        }
        // If a subtree is published, the cached docuemnt-tree should be deleted 
        // only if the last document is published otherwise conflicts might occur.
        try{ 
            if (rootNode != null && numOfDocumentsToPublish == 1) {
                Version treeVersion = getVersion(rootNode, Publication.LIVE_AREA, getLanguage()); 
                boolean isLive = isNodeLive(treeVersion);
                CacheHandler cacheHandler = new CacheHandler();
                cacheHandler.deleteCache(treeVersion, isLive, TASK_NAME);
            }            
        } catch (SiteTreeException e) {
            throw new ExecutionException ("Unable to get sitetree.", e);
        }

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
    
    protected boolean isNodeLive (Version liveVersion){
        
        SiteTree siteTree = null;
        
        try {
            Publication pub = liveVersion.getDocument().getPublication();
            siteTree = pub.getTree(Publication.LIVE_AREA);
            SiteTreeNode node = siteTree.getNode(liveVersion.getDocument().getId());
            if (node != null) return true;
        } catch (SiteTreeException e) {
            return false;
        }
        return false;
    }

}
