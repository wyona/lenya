/*
 * $Id: ClearNewsletterTask.java,v 1.1 2004/12/06 14:18:38 edith Exp $
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
 *    by lenya (http://cocoon.apache.org/lenya/)"
 *
 * 4. The name "lenya" must not be used to endorse or promote products derived from
 *    this software without prior written permission. For written permission, please
 *    contact board@apache.org
 *
 * 5. Products derived from this software may not be called "lenya" nor may "lenya"
 *    appear in their names without prior written permission of lenya.
 *
 * 6. Redistributions of any form whatsoever must retain the following acknowledgment:
 *    "This product includes software developed by lenya (http://cocoon.apache.org/lenya/)"
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
/*
 * ClearNewsletterTask.java
 *
 * Created on November 20, 2002, 5:08 PM
 */
package ch.unizh.unipublic.lenya.cms.task;

import org.apache.avalon.framework.parameters.ParameterException;
import org.apache.log4j.Category;

import org.apache.lenya.cms.publication.DocumentBuildException;
import org.apache.lenya.cms.publication.DocumentException;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.Resource;
import org.apache.lenya.cms.publication.ResourceIdentityMap;
import org.apache.lenya.cms.publication.XlinkCollection;
import org.apache.lenya.cms.rc.RevisionControlException;
import org.apache.lenya.cms.task.ExecutionException;

import org.apache.lenya.workflow.WorkflowException;

import ch.unizh.lenya.cms.task.ResourceTask;
import ch.unizh.unipublic.lenya.cms.publication.Newsletter;
import ch.unizh.unipublic.lenya.cms.publication.NewsletterVersion;
import ch.unizh.unipublic.lenya.cms.publication.UnipublicResourceIdentityMap;

import java.util.Arrays;


/**
 * Task to clean the newsletter document. All document will be removed from the collection.
 *
 * @author <a href="mailto:edith@apache.org">Edith Chevrier</a>
 * @author <a href="mailto:andreas@apache.org">Andreas Hartmann</a>
 */
public class ClearNewsletterTask extends ResourceTask {
    private static Category log = Category.getInstance(ClearNewsletterTask.class);

    public static final String PARAMETER_LANGUAGE = "document-language";

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

        if (log.isDebugEnabled()) {
            log.debug("Starting to clean the newsletter");
        }

        try {
            Newsletter resource = (Newsletter) getResource();
            String language = getLanguage();
            if (!checkPreconditions(resource)) {
            } else {
                if (log.isDebugEnabled()) {
                    log.debug("Can execute task");
                }
                clearNewsletter(resource, language);
            }

        } catch (ExecutionException e) {
            throw e;
        } catch (Exception e) {
            throw new ExecutionException(e);
        }

    }

    
    /**
     * Checks if the preconditions are complied.
     * @param resource The newsletter. 
     * @return 
     * @throws PublicationException
     * @throws ExecutionException
     * @throws RevisionControlException
     * @throws DocumentException
     */
    protected boolean checkPreconditions(Resource resource)
        throws
            ExecutionException,
            PublicationException,
            DocumentBuildException,
            ParameterException,
            WorkflowException, RevisionControlException {

        boolean OK = true;
        return OK;
    }

    /** Clear the newsletter. Remove all documents inside the collection.
     * @param resource
     * @param language
     * @throws PublicationException
     * @throws ExecutionException
     * @throws ParameterException
     */
    public void clearNewsletter(Newsletter resource, String language) throws ParameterException, ExecutionException, PublicationException {
        NewsletterVersion authoringVersion = (NewsletterVersion) getVersion(resource,
                Publication.AUTHORING_AREA, language);
        XlinkCollection document = (XlinkCollection) authoringVersion.getDocument();
        document.clear();
        document.save();
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


}
