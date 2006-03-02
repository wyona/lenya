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

import org.apache.avalon.excalibur.io.FileUtil;
import org.apache.avalon.framework.parameters.ParameterException;
import org.apache.lenya.cms.publication.Document;
import org.apache.lenya.cms.publication.DocumentException;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.Resource;
import org.apache.lenya.cms.publication.ResourceIdentityMap;
import org.apache.lenya.cms.publication.ResourcesManager;
import org.apache.lenya.cms.publication.SiteTreeException;
import org.apache.lenya.cms.publication.Version;
import org.apache.lenya.cms.rc.RevisionControlException;
import org.apache.lenya.cms.task.ExecutionException;
import org.apache.lenya.workflow.WorkflowException;
import org.apache.log4j.Category;

import ch.unizh.lenya.cms.task.Deactivate;
import ch.unizh.unipublic.lenya.cms.publication.Article;
import ch.unizh.unipublic.lenya.cms.publication.Dossier;
import ch.unizh.unipublic.lenya.cms.publication.DossierVersion;
import ch.unizh.unipublic.lenya.cms.publication.DossiersBox;
import ch.unizh.unipublic.lenya.cms.publication.DossiersBoxVersion;
import ch.unizh.unipublic.lenya.cms.publication.Headlines;
import ch.unizh.unipublic.lenya.cms.publication.HeadlinesVersion;
import ch.unizh.unipublic.lenya.cms.publication.UnipublicResourceIdentityMap;

/**
 * Deactivate a document. If it is an article, it will be removed from the
 * headlines. If it is a dossier, it will be removed from the box.
 * 
 * @author <a href="mailto:edith@apache.org">Edith Chevrier </a>
 */
public class UnipublicDeactivate extends Deactivate {

    private static final Category log = Category
            .getInstance(UnipublicDeactivate.class);

    private ResourceIdentityMap identityMap;

    private List messages = new ArrayList();

    /**
     * (non-Javadoc)
     * 
     * @see ch.unizh.lenya.cms.task.ResourceTask#getIdentityMap()
     */
    protected ResourceIdentityMap getIdentityMap() throws ExecutionException {
        if (identityMap == null) {
            identityMap = new UnipublicResourceIdentityMap(getPublication());
        }
        return identityMap;
    }

    /**
     * (non-Javadoc)
     * 
     * @see ch.unizh.lenya.cms.task.Deactivate#deactivate(org.apache.lenya.cms.publication.Resource)
     */
    protected void deactivate(Resource resource) throws PublicationException,
            ExecutionException, IOException, ParameterException,
            WorkflowException, DocumentException {

        Version authoringVersion = getVersion(resource,
                Publication.AUTHORING_AREA, getLanguage());
        boolean isArticle = Article.isArticleDocument(resource.getId());
        boolean isDossier = Dossier.isDossierDocument(resource.getId());
        if (authoringVersion.canWorkflowFire(getEventName(), getSituation())) {
            Version liveVersion = getVersion(resource, Publication.LIVE_AREA,
                    getLanguage());

            copyToDeleteDirectory(liveVersion.getDocument(), resource.getPublicationWrapper().getPublication());
            liveVersion.delete();
            if (isArticle) {
                updateHeadlines(authoringVersion);
            } else if (isDossier) {
                DossierVersion version = (DossierVersion) authoringVersion;
                removeDossierFromBox(version);
            }

            Document liveDocument = liveVersion.getDocument();
            if (!liveDocument.existsInAnyLanguage()) {
                ResourcesManager resourcesManager = new ResourcesManager(
                        liveDocument);
                resourcesManager.deleteResources();
            }

            authoringVersion.triggerWorkflow(getEventName(), getSituation());
        }
    }

    protected void copyToDeleteDirectory(Document document, Publication publication) 
    throws PublicationException {
        String destRootPath = publication.getDirectory().getAbsolutePath() + File.separator + Publication.DELETE_PATH;
        String documentURL = document.getDocumentURL();
        File destinationFile = new File (destRootPath, documentURL);        

        File file = document.getFile();
        
        try {
            FileUtil.copyFile(file, destinationFile);
        } catch (IOException e) {
            throw new PublicationException(e);
        }
    
    }

    /**
     * (non-Javadoc)
     * 
     * @see ch.unizh.lenya.cms.task.Deactivate#checkPreconditions(org.apache.lenya.cms.publication.Resource)
     */
    protected boolean checkPreconditions(Resource resource)
            throws DocumentException, ParameterException, PublicationException,
            SiteTreeException, ExecutionException {

        boolean OK = super.checkPreconditions(resource);

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
                    messages.add("The resource [" + headlinesVersion
                            + "] is checked out by another user.");
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
                    messages.add("The resource [" + dossiersBoxVersion
                            + "] is checked out by another user.");
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
     * remove a document from the frontpage
     * 
     * @param doc
     *            The document.
     * @throws PublicationException
     * @throws ExecutionException
     * @throws ParameterException
     */
    private void updateHeadlines(Version version) throws ParameterException,
            ExecutionException, PublicationException {
        Headlines headlines = (Headlines) version.getResource()
                .getIdentityMap().get(Headlines.HEADLINES_ID);
        HeadlinesVersion headlinesVersion = (HeadlinesVersion) getVersion(
                headlines, version.getDocument().getArea(), version
                        .getDocument().getLanguage());
        headlinesVersion.remove(version.getDocument());
        try {
            headlinesVersion.checkIn(getUser());
        } catch (RevisionControlException e) {
            throw new ExecutionException(
                    "The checked in of the headlines failed", e);
        }
    }

    private void removeDossierFromBox(DossierVersion version)
            throws ParameterException, ExecutionException, PublicationException {
        Dossier dossier = (Dossier) version.getResource();
        DossiersBox box = (DossiersBox) dossier.getIdentityMap().get(
                DossiersBox.DOSSIERSBOX_ID);
        DossiersBoxVersion dossiersBoxVersion = (DossiersBoxVersion) getVersion(
                box, version.getDocument().getArea(), version.getDocument()
                        .getLanguage());
        dossiersBoxVersion.remove(version.getDocument());
        try {
            dossiersBoxVersion.checkIn(getUser());
        } catch (RevisionControlException e) {
            throw new ExecutionException(
                    "The checked in of the dossiers' box failed", e);
        }
    }

    /**
     * Returns the user
     * 
     * @return A string.
     * @throws ParameterException
     *             when the parameter is not present.
     */
    protected String getUser() throws ParameterException {
        String userId = getParameters().getParameter("user-id");

        return userId;
    }

}