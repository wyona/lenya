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

import org.apache.avalon.framework.parameters.ParameterException;
import org.apache.lenya.cms.publication.DocumentException;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.Resource;
import org.apache.lenya.cms.publication.SiteTreeException;
import org.apache.lenya.cms.publication.Version;
import org.apache.lenya.cms.publication.util.OrderedResourceSet;
import org.apache.lenya.cms.publication.util.ResourceVisitor;
import org.apache.lenya.cms.rc.RevisionControlException;
import org.apache.lenya.cms.site.SiteManager;
import org.apache.lenya.cms.task.ExecutionException;
import org.apache.lenya.cms.task.Task;
import org.apache.lenya.workflow.WorkflowException;
import org.apache.log4j.Category;

import ch.unizh.unipublic.lenya.cms.publication.Article;
import ch.unizh.unipublic.lenya.cms.publication.Dossier;
import ch.unizh.unipublic.lenya.cms.publication.DossiersBox;
import ch.unizh.unipublic.lenya.cms.publication.DossiersBoxVersion;
import ch.unizh.unipublic.lenya.cms.publication.Headlines;
import ch.unizh.unipublic.lenya.cms.publication.HeadlinesVersion;

/**
 * Deactivate a tree of documents. If a document is an article, it will be removed from the frontpage.
 * If a document is a dossier, it will be removed from the homepage.
 * 
 * @author <a href="mailto:edith@apache.org">Edith Chevrier</a>
 */
public class UnipublicDeactivateTree extends UnipublicDeactivate implements ResourceVisitor {

    private static final Category log = Category.getInstance(UnipublicDeactivateTree.class);

    /**
     * Checks if the preconditions are complied.
     * @param liveDocument The document to deactivate.
     * @return A boolean value.
     * @throws PublicationException when something went wrong.
     * @throws ExecutionException when something went wrong.
     * @throws DocumentException when something went wrong.
     */
    protected boolean checkPreconditions(Resource resource) throws PublicationException,
            DocumentException, SiteTreeException, ParameterException, ExecutionException {
        boolean OK = true;
        Version authoringVersion = getVersion(resource,
                Publication.AUTHORING_AREA, getLanguage());
        boolean isArticle = Article.isArticleDocument(resource.getId());
        boolean isDossier = Dossier.isDossierDocument(resource.getId());
        String userId = getUser();

        if (isArticle) {
            Headlines headlines = (Headlines) authoringVersion.getResource()
                    .getIdentityMap().get(Headlines.HEADLINES_ID);
            HeadlinesVersion headlinesVersion = (HeadlinesVersion) getVersion(
                    headlines, authoringVersion.getDocument().getArea(),
                    authoringVersion.getDocument().getLanguage());
            try {
                if (!headlinesVersion.canCheckOut(userId)) {
                    OK = false;
                    if (log.isDebugEnabled()) {
                        log.error("The resource [" + headlinesVersion
                                + "] is checked out by another user.");
                    }
                    return OK;
                }
            } catch (RevisionControlException e) {
                throw new ExecutionException(
                        "The headlines can not be checked out", e);
            }

            try {
                headlinesVersion.canCheckOut(userId);
            } catch (RevisionControlException e) {
                throw new ExecutionException(
                        "The checked out of the headlines failed", e);
            }
        }
        if (isDossier) {
            try {
                DossiersBox box = (DossiersBox) authoringVersion.getResource()
                        .getIdentityMap().get(DossiersBox.DOSSIERSBOX_ID);
                DossiersBoxVersion dossiersBoxVersion = (DossiersBoxVersion) getVersion(
                        box, authoringVersion.getDocument().getArea(),
                        authoringVersion.getDocument().getLanguage());

                if (!dossiersBoxVersion.canCheckOut(userId)) {
                    OK = false;
                    if (log.isDebugEnabled()) {
                        log.error("The resource [" + dossiersBoxVersion
                                + "] is checked out by another user.");
                    }
                    return OK;
                }
                dossiersBoxVersion.checkOut(userId);
            } catch (RevisionControlException e) {
                throw new ExecutionException(
                        "The dossiers box can not be checked out", e);
            }
        }
        return OK;

    }

    /**
     * Deactivates a tree of resources.
     * @param resource The resource.
     */
    protected void deactivate(Resource resource)
        throws PublicationException, ExecutionException, ParameterException, WorkflowException {

        if (log.isDebugEnabled()) {
            log.debug("Deactivating subtree below resource [" + resource + "]");
        }

        CheckConditions  visitor = new CheckConditions(); 
        
        SiteManager manager = resource.getPublicationWrapper().getSiteManager();
        Resource[] ancestors = manager.getRequiringResources(resource, Publication.AUTHORING_AREA);

        OrderedResourceSet set = new OrderedResourceSet(ancestors);
        set.add(resource);
        set.visitDescending(visitor);
        if (this.getResult() == SUCCESS) {
            set.visitDescending(this);
        } 
        
        if (log.isDebugEnabled()) {
            log.debug("Deactivating completed.");
        }

    }

    /**
     * @see org.apache.lenya.cms.publication.util.ResourceVisitor#visitDocument(org.apache.lenya.cms.publication.Resource)
     */
    public void visitDocument(Resource resource) throws PublicationException {

        if (log.isDebugEnabled()) {
            log.debug("Visiting resource [" + resource + "]");
        }
        try {
            super.deactivate(resource);
        } catch (PublicationException e) {
            throw e;
        } catch (Exception e) {
            throw new PublicationException(e);
        }
    }

    public class CheckConditions implements ResourceVisitor {

        /**
         * @see org.apache.lenya.cms.publication.util.ResourceVisitor#visitDocument(org.apache.lenya.cms.publication.Resource)
         */
        
    public void visitDocument(Resource resource) throws PublicationException {
            if (UnipublicDeactivateTree.this.getResult()==Task.SUCCESS){
                try {
                    if (!UnipublicDeactivateTree.this.checkPreconditions(resource)) {
                        UnipublicDeactivateTree.this.setResult(Task.FAILURE);
                    }    
                } catch (PublicationException e) {
                    throw e;
                } catch (Exception e) {
                    throw new PublicationException(e);
                }
            }
        }

    }
    
}
