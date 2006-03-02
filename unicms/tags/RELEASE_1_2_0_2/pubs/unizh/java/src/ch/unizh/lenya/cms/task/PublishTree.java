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

import org.apache.avalon.framework.parameters.ParameterException;
import org.apache.lenya.cms.publication.DocumentBuildException;
import org.apache.lenya.cms.publication.DocumentException;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.Resource;
import org.apache.lenya.cms.publication.Version;
import org.apache.lenya.cms.publication.util.OrderedResourceSet;
import org.apache.lenya.cms.publication.util.ResourceVisitor;
import org.apache.lenya.cms.site.SiteException;
import org.apache.lenya.cms.site.SiteManager;
import org.apache.lenya.cms.task.ExecutionException;
import org.apache.lenya.workflow.WorkflowException;
import org.apache.log4j.Category;

/**
 * Publish a tree of documents.
 * 
 * @author <a href="mailto:andreas@apache.org">Andreas Hartmann</a>
 */
public class PublishTree extends Publish implements ResourceVisitor {

    private Resource rootNode = null;
    private int numOfDocuments = 1;
    private static final Category log = Category.getInstance(PublishTree.class);

    /**
     * Publishes a tree of resources.
     * @param resource The resource.
     */
    protected void publish(Resource resource)
        throws PublicationException, ExecutionException, ParameterException, WorkflowException {

        if (log.isDebugEnabled()) {
            log.debug("Publishing subtree below resource [" + resource + "]");
        }

        SiteManager manager = resource.getPublicationWrapper().getSiteManager();
        Resource[] ancestors = manager.getRequiringResources(resource, Publication.AUTHORING_AREA);
        if (ancestors.length > 0 ) {
            numOfDocuments = ancestors.length + 1;
            rootNode = resource;
        }

        OrderedResourceSet set = new OrderedResourceSet(ancestors);
        set.add(resource);
        set.visitAscending(this);

        if (log.isDebugEnabled()) {
            log.debug("Publishing completed.");
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
            publishAllLanguageVersions(resource);
        } catch (PublicationException e) {
            throw e;
        } catch (Exception e) {
            throw new PublicationException(e);
        }
    }

    /**
     * Publishes all existing language versions of a resource.
     * @param resource The resource.
     */
    protected void publishAllLanguageVersions(Resource resource)
        throws
            DocumentException,
            DocumentBuildException,
            ParameterException,
            SiteException,
            WorkflowException,
            PublicationException,
            ExecutionException {

        int numOfDocumentsToPublish = this.numOfDocuments--;
        String[] languages = getPublication().getLanguages();
        for (int i = 0; i < languages.length; i++) {
            Version version = getVersion(resource, Publication.AUTHORING_AREA, languages[i]);
            if (version.getDocument().exists()) {
                publish(resource, languages[i], this.rootNode, numOfDocumentsToPublish);
            }
        }

    }

}
