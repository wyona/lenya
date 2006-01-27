/*
<License>

 ============================================================================
                   The Apache Software License, Version 1.1
 ============================================================================

 Copyright (C) 1999-2003 The Apache Software Foundation. All rights reserved.

 Redistribution and use in source and binary forms, with or without modifica-
 tion, are permitted provided that the following conditions are met:

 1. Redistributions of  source code must  retain the above copyright  notice,
    this list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. The end-user documentation included with the redistribution, if any, must
    include  the following  acknowledgment:  "This product includes  software
    developed  by the  Apache Software Foundation  (http://www.apache.org/)."
    Alternately, this  acknowledgment may  appear in the software itself,  if
    and wherever such third-party acknowledgments normally appear.

 4. The names "Apache Lenya" and  "Apache Software Foundation"  must  not  be
    used to  endorse or promote  products derived from  this software without
    prior written permission. For written permission, please contact
    apache@apache.org.

 5. Products  derived from this software may not  be called "Apache", nor may
    "Apache" appear  in their name,  without prior written permission  of the
    Apache Software Foundation.

 THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED WARRANTIES,
 INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS  FOR A PARTICULAR  PURPOSE ARE  DISCLAIMED.  IN NO  EVENT SHALL  THE
 APACHE SOFTWARE  FOUNDATION  OR ITS CONTRIBUTORS  BE LIABLE FOR  ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL  DAMAGES (INCLU-
 DING, BUT NOT LIMITED TO, PROCUREMENT  OF SUBSTITUTE GOODS OR SERVICES; LOSS
 OF USE, DATA, OR  PROFITS; OR BUSINESS  INTERRUPTION)  HOWEVER CAUSED AND ON
 ANY  THEORY OF LIABILITY,  WHETHER  IN CONTRACT,  STRICT LIABILITY,  OR TORT
 (INCLUDING  NEGLIGENCE OR  OTHERWISE) ARISING IN  ANY WAY OUT OF THE  USE OF
 THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 This software  consists of voluntary contributions made  by many individuals
 on  behalf of the Apache Software  Foundation and was  originally created by
 Michael Wechner <michi@apache.org>. For more information on the Apache Soft-
 ware Foundation, please see <http://www.apache.org/>.

 Lenya includes software developed by the Apache Software Foundation, W3C,
 DOM4J Project, BitfluxEditor, Xopus, and WebSHPINX.
</License>
*/
package org.apache.lenya.cms.publication.impl;

import java.io.File;
import java.io.IOException;

import org.apache.lenya.cms.publication.Document;
import org.apache.lenya.cms.publication.DocumentBuildException;
import org.apache.lenya.cms.publication.DocumentBuilder;
import org.apache.lenya.cms.publication.DocumentIdToPathMapper;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.Resource;
import org.apache.lenya.cms.publication.Version;
import org.apache.lenya.cms.rc.RCEnvironment;
import org.apache.lenya.cms.rc.RevisionControlException;
import org.apache.lenya.cms.rc.RevisionController;
import org.apache.lenya.cms.workflow.WorkflowFactory;
import org.apache.lenya.workflow.Event;
import org.apache.lenya.workflow.Situation;
import org.apache.lenya.workflow.SynchronizedWorkflowInstances;
import org.apache.lenya.workflow.WorkflowException;
import org.apache.log4j.Category;

/**
 * A version of a resource.
 * 
 * @author <a href="andreas@apache.org">Andreas Hartmann</a>
 * @version $Id: VersionImpl.java,v 1.1 2004/02/19 15:42:02 andreas Exp $
 */
public class VersionImpl implements Version {

    private static final Category log = Category.getInstance(VersionImpl.class);

    private Resource resource;
    private Document document;

    protected VersionImpl(Resource resource, String area, String language)
        throws DocumentBuildException {
        this.resource = resource;
        Publication publication = resource.getPublication();
        DocumentBuilder builder = publication.getDocumentBuilder();
        String url = builder.buildCanonicalUrl(publication, area, resource.getId(), language);
        this.document = builder.buildDocument(publication, url);
    }

    /**
     * Returns the area of this version.
     * @return A string.
     */
    public String getArea() {
        return getDocument().getArea();
    }

    /**
     * Returns the language of this version.
     * @return A string.
     */
    public String getLanguage() {
        return getDocument().getLanguage();
    }

    /**
     * @see org.apache.lenya.cms.publication.Version#checkIn(org.apache.lenya.ac.Identity)
     */
    public void checkIn(String identity) throws RevisionControlException {

        try {
            String path = getRevisionFilePath();
            getRevisionController().reservedCheckIn(path, identity, true);
        } catch (RevisionControlException e) {
            throw e;
        } catch (Exception e) {
            throw new RevisionControlException(e);
        }
    }

    /**
     * @see org.apache.lenya.cms.publication.Version#checkOut(org.apache.lenya.ac.Identity)
     */
    public void checkOut(String identity) throws RevisionControlException {

        try {
            String path = getRevisionFilePath();
            getRevisionController().reservedCheckOut(path, identity);
        } catch (RevisionControlException e) {
            throw e;
        } catch (Exception e) {
            throw new RevisionControlException(e);
        }
    }

    /**
     * @see org.apache.lenya.cms.publication.Version#canCheckOut(org.apache.lenya.ac.Identity)
     */
    public boolean canCheckOut(String identity) throws RevisionControlException {
        boolean canCheckOut = false;
        try {
            String path = getRevisionFilePath();
            canCheckOut = getRevisionController().canCheckOut(path, identity);
        } catch (RevisionControlException e) {
            throw e;
        } catch (Exception e) {
            throw new RevisionControlException(e);
        }
        return canCheckOut;
    }

    /**
     * Returns the revision file path of a specific version.
     * @return A string.
     * @throws DocumentBuildException when something went wrong.
     */
    protected String getRevisionFilePath() throws DocumentBuildException {
        Document version = getDocument();
        DocumentIdToPathMapper mapper = getPublication().getPathMapper();

        String path =
            "content"
                + File.separator
                + getArea()
                + File.separator
                + mapper.getPath(version.getId(), version.getLanguage());
        return path;
    }

    /**
     * Returns the document that represents this version.
     * @return A document.
     */
    public Document getDocument() {
        return document;
    }

    private RevisionController revisionController;

    /**
     * Returns the revision controller.
     * @return A revision controller.
     * @throws IOException when something went wrong.
     */
    protected RevisionController getRevisionController() throws RevisionControlException {
        if (revisionController == null) {
            File publicationDir = getPublication().getDirectory();
            RCEnvironment rcEnvironment;
            try {
                File servletContext = getPublication().getServletContext();
                rcEnvironment = RCEnvironment.getInstance(servletContext.getCanonicalPath());
            } catch (IOException e) {
                throw new RevisionControlException(e);
            }

            File rcmlDirectory = new File(publicationDir, rcEnvironment.getRCMLDirectory());
            File backupDirectory = new File(publicationDir, rcEnvironment.getBackupDirectory());

            revisionController =
                new RevisionController(
                    rcmlDirectory.getAbsolutePath(),
                    backupDirectory.getAbsolutePath(),
                    publicationDir.getAbsolutePath());
        }
        return revisionController;
    }

    /**
     * Returns the publication this version belongs to.
     * @return A Publication.
     */
    protected Publication getPublication() {
        return getResource().getPublication();
    }

    /**
     * @see org.apache.lenya.cms.publication.Version#delete()
     */
    public void delete() throws PublicationException {
        if (getDocument().exists()) {
            getPublication().deleteDocument(getDocument());
        }
    }

    /**
     * Checks if a workflow event can be invoked on this document group.
     * @param eventName The name of the event.
     * @param situation The current workflow situation.
     * @return A boolean value.
     * @throws WorkflowException when something went wrong.
     * @throws DocumentBuildException when something went wrong.
     */
    public boolean canWorkflowFire(String eventName, Situation situation)
        throws WorkflowException, DocumentBuildException {

        if (log.isDebugEnabled()) {
            log.debug("Checking workflow of [" + this +"].");
        }

        boolean canFire = true;

        WorkflowFactory factory = WorkflowFactory.newInstance();
        Document document = getDocument();
        if (factory.hasWorkflow(document)) {
            SynchronizedWorkflowInstances instance = factory.buildSynchronizedInstance(document);
            Event event = getExecutableEvent(instance, situation, eventName);

            if (event == null) {
                canFire = false;
            }

        }
        return canFire;
    }

    /**
     * Invokes the workflow on a document group.
     * @param eventName The name of the event.
     * @param situation The current workflow situation.
     * @throws WorkflowException when something went wrong.
     * @throws DocumentBuildException when something went wrong.
     */
    public void triggerWorkflow(String eventName, Situation situation)
        throws WorkflowException, DocumentBuildException {

        if (log.isDebugEnabled()) {
            log.debug("Trying to execute workflow on [" + this +"].");
        }

        WorkflowFactory factory = WorkflowFactory.newInstance();
        Document document = getDocument();
        if (factory.hasWorkflow(document)) {

            SynchronizedWorkflowInstances instance = factory.buildSynchronizedInstance(document);

            Event event = getExecutableEvent(instance, situation, eventName);

            if (event == null) {
                throw new WorkflowException(
                    "The event [" + eventName + "] is not executable on version [" + this +"]");
            }

            if (log.isDebugEnabled()) {
                log.debug("Invoking event [" + event.getName() + "]");
            }
            instance.invoke(situation, event);
            if (log.isDebugEnabled()) {
                log.debug("Invoking transition completed.");
            }
        } else {
            if (log.isDebugEnabled()) {
                log.debug("No workflow associated with document.");
            }
        }

    }

    /**
     * Returns the executable event for a certain event name.
     * @param instance The workflow instance.
     * @param situation The situation.
     * @param eventName The name of the event.
     * @return An event.
     * @throws WorkflowException when something went wrong.
     * @throws ParameterException when the {@link #PARAMETER_WORKFLOW_EVENT} parameter could not be resolved.
     */
    protected Event getExecutableEvent(
        SynchronizedWorkflowInstances instance,
        Situation situation,
        String eventName)
        throws WorkflowException {

        Event event = null;
        Event[] events = instance.getExecutableEvents(situation);

        if (log.isDebugEnabled()) {
            log.debug("Workflow event name: [" + eventName + "]");
            log.debug("Resolved executable events.");
        }

        for (int i = 0; i < events.length; i++) {
            if (events[i].getName().equals(eventName)) {
                event = events[i];
            }
        }

        if (log.isDebugEnabled()) {
            log.debug("Executable event found: [" + event + "]");
        }

        return event;
    }

    /**
     * @see org.apache.lenya.cms.publication.Version#getResource()
     */
    public Resource getResource() {
        return resource;
    }

    /**
     * @see java.lang.Object#toString()
     */
    public String toString() {
        return getArea() + ":" + getResource().getId() + ":" + getLanguage();
    }

}
