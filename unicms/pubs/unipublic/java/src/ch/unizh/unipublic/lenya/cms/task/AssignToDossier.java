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
 * Assign a document to a dossier.
 * 
 * @author <a href="mailto:edith@apache.org">Edith Chevrier</a>
 */
public class AssignToDossier extends DossierTask {

    private static final Category log = Category.getInstance(AssignToDossier.class);

    protected void executeTask(Resource resource, Dossier[] dossiers) throws DocumentBuildException, ParameterException, ExecutionException, PublicationException, WorkflowException{
        for (int i=0; i<dossiers.length; i++){
            if (assignResourceToDossier(resource, dossiers[i])) {
                setReference(resource, dossiers[i].getId());
            }
        }
    }

    /**
     * Set a reference to the dossier in the resource. (The dossier's id in the DublinCore.TERM_ISREFERENCEDBY)
     * @param resource The resource.
     * @param dossierId The id of the dossier.
     * @throws ExecutionException when something went wrong.
     * @throws PublicationException when something went wrong.
     * @throws ParameterException  when something went wrong.
     * @throws WorkflowException when something went wrong.
     * @throws DocumentBuildException when something went wrong.
     */
    protected void setReference(Resource resource, String dossierId) throws ExecutionException, PublicationException, DocumentBuildException, ParameterException, WorkflowException {
        Version authoringVersion = getVersion(resource, Publication.AUTHORING_AREA,  getLanguage());
        if (authoringVersion.canWorkflowFire(getEventName(), getSituation())) {
            authoringVersion.getDocument().getDublinCore().addValue(DublinCore.TERM_ISREFERENCEDBY, dossierId);
            authoringVersion.getDocument().getDublinCore().save();
            authoringVersion.triggerWorkflow(getEventName(), getSituation());
        }

    }

    /**
     * Assign a resource to a dossier
     * @param resource The resource.
     * @param dossier The resource of the dossier.
     * @throws PublicationException when something went wrong.
     * @throws ExecutionException when something went wrong.
     * @throws ParameterException
     * @throws WorkflowException
     * @throws DocumentBuildException
     */
    protected boolean assignResourceToDossier(Resource resource, Dossier dossier) throws ExecutionException, PublicationException, DocumentBuildException, ParameterException, WorkflowException  {
        boolean added = false; 
        Version authoringVersion = getVersion(resource, Publication.AUTHORING_AREA,  getLanguage());
        DossierVersion  dossierVersion = (DossierVersion) getVersion(dossier, Publication.AUTHORING_AREA, getLanguage());
        if (dossierVersion.canWorkflowFire(getEventName(), getSituation())) {
            added = dossierVersion.add(authoringVersion.getDocument());
            dossierVersion.triggerWorkflow(getEventName(), getSituation());            
        }
        return added;
    }

}
