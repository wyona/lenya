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
import org.apache.lenya.cms.publication.DocumentBuildException;
import org.apache.lenya.cms.publication.DocumentException;
import org.apache.lenya.cms.publication.DublinCore;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.Resource;
import org.apache.lenya.cms.publication.Version;
import org.apache.lenya.cms.task.ExecutionException;
import org.apache.lenya.workflow.WorkflowException;
import org.apache.log4j.Category;

import ch.unizh.unipublic.lenya.cms.publication.Dossier;
import ch.unizh.unipublic.lenya.cms.publication.DossierVersion;

/**
 * Remove a document from a dossier.
 * 
 * @author <a href="mailto:edith@apache.org">Edith Chevrier</a>
 */
public class RemoveFromDossier extends DossierTask {

    private static final Category log = Category.getInstance(RemoveFromDossier.class);

    /** (non-Javadoc)
     * @see ch.unizh.unipublic.lenya.cms.task.DossierTask#executeTask(org.apache.lenya.cms.publication.Resource, ch.unizh.unipublic.lenya.cms.publication.Dossier[])
     */
    protected void executeTask(Resource resource, Dossier[] dossiers) throws ParameterException, ExecutionException, PublicationException, WorkflowException{
        for (int i=0; i<dossiers.length; i++){
            if (removeResourceFromDossier(resource, dossiers[i])) {
                removeReference(resource, dossiers[i].getId());
            }
        }
    }

    /**
     * Remove a reference to the dossier in the resource. (The dossier's id in the DublinCore.TERM_ISREFERENCEDBY)
     * @param resource The resource.
     * @param dossierId The id of the dossier.
     * @throws ExecutionException when something went wrong.
     * @throws PublicationException when something went wrong.
     * @throws ParameterException when something went wrong.
     * @throws WorkflowException when something went wrong.
     * @throws DocumentException when something went wrong.
     * @throws DocumentBuildException when something went wrong.
     */
    protected void removeReference(Resource resource, String dossierId) throws ExecutionException, PublicationException, DocumentBuildException, ParameterException, DocumentException, WorkflowException {
        Version authoringVersion = getVersion(resource, Publication.AUTHORING_AREA,  getLanguage());
        if (authoringVersion.canWorkflowFire(getEventName(), getSituation())) {
            authoringVersion.getDocument().getDublinCore().removeValue(DublinCore.TERM_ISREFERENCEDBY, dossierId);
            authoringVersion.getDocument().getDublinCore().save();
            authoringVersion.triggerWorkflow(getEventName(), getSituation());
        }
    }
    /**
     * Remove a resource from a dossier
     * @param resource The resource.
     * @param dossier The resource of the dossier.
     * @throws ExecutionException when something went wrong.
     * @throws ParameterException
     * @throws PublicationException
     * @throws WorkflowException
     * @throws DocumentBuildException
     */
    protected boolean removeResourceFromDossier(Resource resource, Dossier dossier) throws ExecutionException, DocumentBuildException, ParameterException, WorkflowException, PublicationException  {
        boolean removed = false;
        Version authoringVersion = getVersion(resource, Publication.AUTHORING_AREA,  getLanguage());
        DossierVersion  dossierVersion = (DossierVersion) getVersion(dossier, Publication.AUTHORING_AREA, getLanguage());
        if (dossierVersion.canWorkflowFire(getEventName(), getSituation())) {
            removed = dossierVersion.remove(authoringVersion.getDocument());
            dossierVersion.triggerWorkflow(getEventName(), getSituation());            
        }
        return removed;
    }
    
}
