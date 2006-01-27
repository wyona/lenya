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
package ch.unizh.lenya.cms.workflow;

import org.apache.lenya.cms.publication.Document;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.Resource;
import org.apache.lenya.cms.publication.ResourceIdentityMap;
import org.apache.lenya.cms.publication.Version;
import org.apache.lenya.cms.publication.util.AreaFilter;
import org.apache.lenya.cms.publication.util.VersionFilter;
import org.apache.lenya.cms.site.SiteManager;
import org.apache.lenya.cms.workflow.WorkflowDocument;
import org.apache.lenya.workflow.Condition;
import org.apache.lenya.workflow.Situation;
import org.apache.lenya.workflow.WorkflowException;
import org.apache.lenya.workflow.WorkflowInstance;

/**
 * Check if a document can be deleted.
 * 
 * @author <a href="mailto:andreas@apache.org">Andreas Hartmann</a>
 */
public class DeleteCondition implements Condition {

    /* (non-Javadoc)
     * @see org.apache.lenya.workflow.Condition#isComplied(org.apache.lenya.workflow.Situation, org.apache.lenya.workflow.WorkflowInstance)
     */
    public boolean isComplied(Situation situation, WorkflowInstance instance) throws WorkflowException {
        
        boolean isComplied = true;
        try {
            WorkflowDocument workflowDocument = (WorkflowDocument) instance;
            Document document = workflowDocument.getDocument();
            
            ResourceIdentityMap map = new ResourceIdentityMap(document.getPublication());
            Resource resource = map.get(document.getId());
            
            SiteManager manager = resource.getPublicationWrapper().getSiteManager();
            Resource[] ancestors = manager.getRequiringResources(resource, Publication.AUTHORING_AREA);
            
            VersionFilter authoring = new AreaFilter(Publication.AUTHORING_AREA);
            
            for (int i = 0; i < ancestors.length; i++) {
                Version authoringVersion = ancestors[i].getVersions(authoring)[0];
                if (!authoringVersion.canWorkflowFire("delete", situation)) {
                    isComplied = false;
                }
            }
            
        } catch (PublicationException e) {
            throw new WorkflowException(e);
        }
        return isComplied;
    }

    /* (non-Javadoc)
     * @see org.apache.lenya.workflow.Condition#setExpression(java.lang.String)
     */
    public void setExpression(String expression) throws WorkflowException {
    }

}
