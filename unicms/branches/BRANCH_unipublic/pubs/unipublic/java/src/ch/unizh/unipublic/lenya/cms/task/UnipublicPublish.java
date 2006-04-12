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

import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.avalon.framework.parameters.ParameterException;
import org.apache.lenya.cms.publication.Document;
import org.apache.lenya.cms.publication.DocumentBuildException;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.Resource;
import org.apache.lenya.cms.publication.ResourceIdentityMap;
import org.apache.lenya.cms.publication.Version;
import org.apache.lenya.cms.rc.RevisionControlException;
import org.apache.lenya.cms.task.ExecutionException;
import org.apache.lenya.workflow.WorkflowException;
import org.apache.log4j.Category;

import ch.unizh.lenya.cms.task.Publish;
import ch.unizh.unipublic.lenya.cms.publication.Article;
import ch.unizh.unipublic.lenya.cms.publication.ArticleVersion;
import ch.unizh.unipublic.lenya.cms.publication.Dossier;
import ch.unizh.unipublic.lenya.cms.publication.DossierVersion;
import ch.unizh.unipublic.lenya.cms.publication.DossiersBox;
import ch.unizh.unipublic.lenya.cms.publication.DossiersBoxVersion;
import ch.unizh.unipublic.lenya.cms.publication.Headlines;
import ch.unizh.unipublic.lenya.cms.publication.HeadlinesVersion;
import ch.unizh.unipublic.lenya.cms.publication.Newsletter;
import ch.unizh.unipublic.lenya.cms.publication.NewsletterVersion;
import ch.unizh.unipublic.lenya.cms.publication.UnipublicResourceIdentityMap;

/**
 * Publish a document. If it is an article, insert it in the frontpage and in the newsletter. If it is
 * a dossier, insert it in the box on the frontpage.
 * 
 * @author <a href="mailto:edith@apache.org">Edith Chevrier </a>
 */
public class UnipublicPublish extends Publish {
    private static final Category log = Category
            .getInstance(UnipublicPublish.class);

    private static final String format = "yyyy-MM-dd HH:mm:ss";

    private ResourceIdentityMap identityMap;

    /**
     * Returns the identity map.
     * 
     * @return A resource identity map.
     * @throws ExecutionException
     *             when something went wrong.
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
     * @see ch.unizh.lenya.cms.task.Publish#publish(org.apache.lenya.cms.publication.Resource,
     *      java.lang.String)
     */
    protected void publish(Resource resource, String language)
            throws ParameterException, ExecutionException,
            PublicationException, WorkflowException {

        Version authoringVersion = getVersion(resource,
                Publication.AUTHORING_AREA, language);
        boolean workflowWillFire = authoringVersion.canWorkflowFire(
                getEventName(), getSituation());
        boolean isArticle = Article.isArticleDocument(resource.getId());
        boolean isDossier = Dossier.isDossierDocument(resource.getId());
        boolean alreadyPublished = false;

        if (workflowWillFire && isArticle) {
            String date = new SimpleDateFormat(format).format(new Date());
            ArticleVersion authoringArticle = (ArticleVersion) authoringVersion;
            Article article = (Article) resource;
            alreadyPublished = article.isAlreadyPublished();
            if (!alreadyPublished) {
                authoringArticle.setFirstPublishingDate(date);
            }
            authoringArticle.setRevisionDate(date);
            authoringArticle.setRevisionId();
            authoringArticle.getDocument().getDublinCore().save();
            try {
                authoringArticle.checkIn(getUser());
            } catch (RevisionControlException e) {
                throw new ExecutionException(
                        "The checked in of the article failed", e);
            }
        }
        super.publish(resource, language, null, 1);

        if (workflowWillFire && areRequiredResourcesLive(resource) && isArticle) {
            Document doc = authoringVersion.getDocument();
            updateHeadlines(authoringVersion);
            updateNewsletter(authoringVersion);
        } else if (workflowWillFire && isDossier) {
            DossierVersion version = (DossierVersion) authoringVersion;
            addDossierToBox(version);
        }
    }

    /** (non-Javadoc)
     * @see ch.unizh.lenya.cms.task.Publish#checkPreconditions(org.apache.lenya.cms.publication.Resource)
     */
    protected boolean checkPreconditions(Resource resource)
            throws ExecutionException, PublicationException,
            DocumentBuildException, ParameterException, WorkflowException {
        boolean OK = super.checkPreconditions(resource);
        if (!OK) {
            return OK;
        }
     
        Version authoringVersion = getVersion(resource,
                Publication.AUTHORING_AREA, getLanguage());
        boolean isArticle = Article.isArticleDocument(resource.getId());
        boolean isDossier = Dossier.isDossierDocument(resource.getId());
        String userId = getUser();

        if (isArticle) {
            try {
                if (!authoringVersion.canCheckOut(userId)) {
                    OK = false;
                    if (log.isDebugEnabled()) {
                        log.info("The resource [" + authoringVersion
                                + "] is checked out by another user.");
                    }
                    return OK;
                }
            } catch (RevisionControlException e) {
                throw new ExecutionException(
                        "The article can not be checked out", e);
            }

            Headlines headlines = (Headlines) authoringVersion.getResource()
                    .getIdentityMap().get(Headlines.HEADLINES_ID);
            HeadlinesVersion headlinesVersion = (HeadlinesVersion) getVersion(
                    headlines, authoringVersion.getDocument().getArea(),
                    authoringVersion.getDocument().getLanguage());
            try {
                if (!headlinesVersion.canCheckOut(userId)) {
                    OK = false;
                    if (log.isDebugEnabled()) {
                        log.info("The resource [" + headlinesVersion
                                + "] is checked out by another user.");
                    }
                    return OK;
                }
            } catch (RevisionControlException e) {
                throw new ExecutionException(
                        "The headlines can not be checked out", e);
            }

            Newsletter newsletter = (Newsletter) authoringVersion.getResource()
                    .getIdentityMap().get(Newsletter.NEWSLETTER_ID);
            NewsletterVersion newsletterVersion = (NewsletterVersion) getVersion(
                    newsletter, authoringVersion.getDocument().getArea(),
                    authoringVersion.getDocument().getLanguage());
            try {

                if (!newsletterVersion.canCheckOut(userId)) {
                    OK = false;
                    if (log.isDebugEnabled()) {
                        log.info("The resource [" + newsletterVersion
                                + "] is checked out by another user.");
                    }
                    return OK;
                }
            } catch (RevisionControlException e) {
                throw new ExecutionException(
                        "The newsletter can not be checked out", e);
            }
            try {
                authoringVersion.checkOut(userId);
                headlinesVersion.checkOut(userId);
                newsletterVersion.checkOut(userId);
            } catch (RevisionControlException e) {
                throw new ExecutionException(
                        "The checked out of the headlines or the newsletter failed",
                        e);
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
                        log.info("The resource [" + dossiersBoxVersion
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
     * insert a document in the headlines
     * 
     * @param version.
     *            The version.
     * @throws PublicationException
     *             when something went wrong
     * @throws ExecutionException
     *             when something went wrong
     * @throws ParameterException
     *             when something went wrong
     */
    private void updateHeadlines(Version version) throws ParameterException,
            ExecutionException, PublicationException {
        Headlines headlines = (Headlines) version.getResource()
                .getIdentityMap().get(Headlines.HEADLINES_ID);
        HeadlinesVersion headlinesVersion = (HeadlinesVersion) getVersion(
                headlines, version.getDocument().getArea(), version
                        .getDocument().getLanguage());
        headlinesVersion.add(version.getDocument(), 0);
        try {
            headlinesVersion.checkIn(getUser());
        } catch (RevisionControlException e) {
            throw new ExecutionException(
                    "The checked in of the headlines failed", e);
        }
    }

    /**
     * insert a document in the newsletter
     * 
     * @param version.
     *            The version.
     * @throws PublicationException
     *             when something went wrong
     * @throws ExecutionException
     *             when something went wrong
     * @throws ParameterException
     *             when something went wrong
     */
    private void updateNewsletter(Version version) throws ParameterException,
            ExecutionException, PublicationException {
        Newsletter newsletter = (Newsletter) version.getResource()
                .getIdentityMap().get(Newsletter.NEWSLETTER_ID);
        NewsletterVersion newsletterVersion = (NewsletterVersion) getVersion(
                newsletter, version.getDocument().getArea(), version
                        .getDocument().getLanguage());
        newsletterVersion.add(version.getDocument(), 0);
        try {
            newsletterVersion.checkIn(getUser());
        } catch (RevisionControlException e) {
            throw new ExecutionException(
                    "The checked in of the newsletter failed", e);
        }
    }

    /**
     * Insert a dossier in the dossier's box
     * 
     * @param version.
     *            The version of the dossier.
     * @throws ParameterException
     *             when something went wrong
     * @throws ExecutionException
     *             when something went wrong
     * @throws PublicationException
     *             when something went wrong
     */
    private void addDossierToBox(DossierVersion version)
            throws ParameterException, ExecutionException, PublicationException {
        Dossier dossier = (Dossier) version.getResource();
        DossiersBox box = (DossiersBox) dossier.getIdentityMap().get(
                DossiersBox.DOSSIERSBOX_ID);
        DossiersBoxVersion dossiersBoxVersion = (DossiersBoxVersion) getVersion(
                box, version.getDocument().getArea(), version.getDocument()
                        .getLanguage());
        dossiersBoxVersion.add(version.getDocument(), 0);
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