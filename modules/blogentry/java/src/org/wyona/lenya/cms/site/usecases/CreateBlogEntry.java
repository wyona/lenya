/*
 * Copyright  1999-2006 The Apache Software Foundation
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */
package org.wyona.lenya.cms.site.usecases;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;
import org.apache.avalon.framework.service.ServiceException;
import org.apache.avalon.framework.service.ServiceSelector;
import org.apache.cocoon.components.ContextHelper;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.Session;
import org.apache.lenya.ac.Identity;
import org.apache.lenya.cms.cocoon.source.SourceUtil;
import org.apache.lenya.cms.metadata.dublincore.DublinCore;
import org.apache.lenya.cms.publication.Document;
import org.apache.lenya.cms.publication.DocumentException;
import org.apache.lenya.cms.publication.DocumentFactory;
import org.apache.lenya.cms.publication.DocumentLocator;
import org.apache.lenya.cms.publication.DocumentManager;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.ResourceType;
import org.apache.lenya.cms.repository.Node;
import org.apache.lenya.cms.site.SiteException;
import org.apache.lenya.cms.site.SiteStructure;
import org.apache.lenya.cms.site.SiteUtil;
import org.apache.lenya.cms.usecase.DocumentUsecase;
import org.apache.lenya.cms.usecase.UsecaseException;
import org.apache.lenya.xml.DocumentHelper;
import org.apache.xpath.XPathAPI;
import org.w3c.dom.Element;

/**
 * Usecase to create a Blog entry.
 * 
 * @version $Id: CreateBlogEntry.java 408702 2006-05-22 16:03:49Z andreas $
 */
public class CreateBlogEntry extends DocumentUsecase {

    protected static final String PARENT_ID = "parentId";
    protected static final String DOCUMENT_TYPE = "doctype";
    protected static final String DOCUMENT_ID = "documentId";

    protected static String DEFAULT_RESOURCE_TYPE = "xhtml";
    protected static final String DEFAULT_EXTENSION = "xml";

    protected static final String ELEMENT_ROOT = "resource-type";
    protected static final String ATTRIBUTE_TYPE = "select";

    private String parentId;

    public void configure(Configuration config) throws ConfigurationException {
        super.configure(config);
        Configuration resourceTypeConfig = config.getChild(ELEMENT_ROOT, false);
        if (resourceTypeConfig != null) {
            DEFAULT_RESOURCE_TYPE = resourceTypeConfig.getAttribute(ATTRIBUTE_TYPE);
        }
    }

    /**
     * @see org.apache.lenya.cms.usecase.AbstractUsecase#initParameters()
     */
    protected void initParameters() {
        super.initParameters();

        Document parent = getSourceDocument();
        try {
            setParameter(PARENT_ID, parent.getPath());
        } catch (DocumentException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * @see org.apache.lenya.cms.usecase.AbstractUsecase#doCheckExecutionConditions()
     */
    protected void doCheckExecutionConditions() throws Exception {

        String documentId = getParameterAsString(DOCUMENT_ID);

        if (documentId.equals("")) {
            addErrorMessage("The document ID is required.");
        }

        if (documentId.matches("[^a-zA-Z0-9\\-]+")) {
            addErrorMessage("The document ID is not valid.");
        }

        super.doCheckExecutionConditions();
    }

    /**
     * @see org.apache.lenya.cms.usecase.AbstractUsecase#doExecute()
     */
    protected void doExecute() throws Exception {
        super.doExecute();

        // prepare values necessary for blog entry creation
        Document parent = getSourceDocument();
        String language = parent.getPublication().getDefaultLanguage();
        this.parentId = parent.getLocator().getPath();

        // create new document
        // implementation note: since blog does not have a hierarchy,
        // document id (full path) and document id-name (this leaf's id)
        // are the same
        DocumentManager documentManager = null;
        ServiceSelector selector = null;
        ResourceType resourceType = null;

        try {
            String documentId = getDocumentID();
            DocumentLocator locator = DocumentLocator.getLocator(parent.getPublication().getId(),
                    parent.getArea(),
                    documentId,
                    language);
            createParentDocs(parent);
            selector = (ServiceSelector) this.manager.lookup(ResourceType.ROLE + "Selector");
            resourceType = (ResourceType) selector.select(getDocumentTypeName());

            documentManager = (DocumentManager) this.manager.lookup(DocumentManager.ROLE);

            DocumentFactory map = getDocumentFactory();
            String contentUri = resourceType.getSampleURI(resourceType.getSampleNames()[0]);
            Document document = documentManager.add(map,
                    resourceType,
                    contentUri,
                    getSourceDocument().getPublication(),
                    locator.getArea(),
                    locator.getPath(),
                    locator.getLanguage(),
                    "xml",
                    getParameterAsString(DublinCore.ELEMENT_TITLE),
                    true);

            transformXML(document);
        } finally {
            if (documentManager != null) {
                this.manager.release(documentManager);
            }
            if (selector != null) {
                if (resourceType != null) {
                    selector.release(resourceType);
                }
                this.manager.release(selector);
            }
        }
    }

    protected void createParentDocs(Document doc) throws ServiceException, PublicationException {
        DocumentFactory map = getDocumentFactory();
        String[] pathId = getDocumentID().split("/");
        String docRoot = "";
        String pubId = doc.getPublication().getId(), area = doc.getArea(), lang=doc.getLanguage();
        Publication pub= doc.getPublication();
        for (int i = 0; i < pathId.length - 1; i++) {
            String currentDoc = pathId[i];
            if (currentDoc.length() >= 1) {
                docRoot = docRoot + "/" + currentDoc;
                boolean exists = SiteUtil.contains(manager, map, pub, area, docRoot);
                if (!exists) {
                    DocumentManager documentManager = null;
                    ServiceSelector selector = null;
                    ResourceType resourceType = null;
                    try {
                        selector = (ServiceSelector) this.manager.lookup(ResourceType.ROLE
                                + "Selector");
                        documentManager = (DocumentManager) this.manager.lookup(DocumentManager.ROLE);
                        resourceType = (ResourceType) selector.select(DEFAULT_RESOURCE_TYPE);
                        DocumentLocator locator = DocumentLocator.getLocator(pubId
                                , area, docRoot, lang);
                        String sampleUri = resourceType.getSampleURI(resourceType.getSampleNames()[0]);
                        documentManager.add(map,
                                resourceType,
                                sampleUri,
                                getSourceDocument().getPublication(),
                                locator.getArea(),
                                locator.getPath(),
                                locator.getLanguage(),
                                DEFAULT_EXTENSION,
                                currentDoc,
                                true);
                    } finally {
                        if (documentManager != null) {
                            this.manager.release(documentManager);
                        }
                        if (selector != null) {
                            if (resourceType != null) {
                                selector.release(resourceType);
                            }
                            this.manager.release(selector);
                        }
                    }
                }
            }
        }
    }

    /**
     * The blog publication has a specific site structuring: it groups nodes by date.
     * 
     * <p>
     * Example structuring of blog entries:
     * </p>
     * <ul>
     * <li>2004</li>
     * <li>2005</li>
     * <ul>
     * <li>01</li>
     * <li>02</li>
     * <ul>
     * <li>23</li>
     * <li>24</li>
     * <ul>
     * <li>article-one</li>
     * <li>article-two</li>
     * </ul>
     * </ul>
     * </ul>
     * </ul>
     * 
     * @return The document ID.
     */
    protected String getDocumentID() {
        DateFormat fmtyyyy = new SimpleDateFormat("yyyy");
        DateFormat fmtMM = new SimpleDateFormat("MM");
        DateFormat fmtdd = new SimpleDateFormat("dd");
        Date date = new Date();

        String year = fmtyyyy.format(date);
        String month = fmtMM.format(date);
        String day = fmtdd.format(date);

        String documentId = this.parentId + "/" + year + "/" + month + "/" + day + "/"
                + getNewDocumentName();
        return documentId;
    }

    /**
     * @return The document name.
     * @see org.apache.lenya.cms.site.usecases.Create#getNewDocumentName()
     */
    protected String getNewDocumentName() {
        return getParameterAsString(DOCUMENT_ID);
    }

    /**
     * @return The name of the document type.
     * @see org.apache.lenya.cms.site.usecases.Create#getDocumentTypeName()
     */
    protected String getDocumentTypeName() {
        return getParameterAsString(DOCUMENT_TYPE);
    }

    protected void transformXML(Document document) throws Exception {

        Map objectModel = ContextHelper.getObjectModel(getContext());
        Request request = ObjectModelHelper.getRequest(objectModel);
        Session session = request.getSession(false);
        Identity identity = (Identity) session.getAttribute(Identity.class.getName());
        String title = getParameterAsString(DublinCore.ELEMENT_TITLE);

        org.w3c.dom.Document xmlDoc = SourceUtil.readDOM(document.getSourceURI(), this.manager);

        Element parent = xmlDoc.getDocumentElement();

        if (getLogger().isDebugEnabled())
            getLogger().debug("NewBlogEntryCreator.transformXML(): " + document);

        String[] steps = document.getLocator().getPath().split("/");
        int depth = steps.length - 1;
        String nodeId = steps[depth];

        // Replace id
        Element element = (Element) XPathAPI.selectSingleNode(parent,
                "/*[local-name() = 'entry']/*[local-name() = 'id']");

        String year = steps[depth - 3];
        String month = steps[depth - 2];
        String day = steps[depth - 1];

        DocumentHelper.setSimpleElementText(element, year + "/" + month + "/" + day + "/" + nodeId);

        // Replace title
        element = (Element) XPathAPI.selectSingleNode(parent,
                "/*[local-name() = 'entry']/*[local-name() = 'title']");
        DocumentHelper.setSimpleElementText(element, title);

        element = (Element) XPathAPI.selectSingleNode(parent,
                "/*[local-name() = 'entry']/*[local-name() = 'link']");
        element.setAttribute("rel", "alternate");
        element.setAttribute("href", document.getCanonicalWebappURL());
        element.setAttribute("type", "text/xml");

        // Replace Summary
        element = (Element) XPathAPI.selectSingleNode(parent,
                "/*[local-name() = 'entry']/*[local-name() = 'summary']");
        DocumentHelper.setSimpleElementText(element, "Summary");

        element = (Element) XPathAPI.selectSingleNode(parent,
                "/*[local-name() = 'entry']/*[local-name() = 'author']/*[local-name() = 'name']");

        if (element == null) {
            throw new RuntimeException("Element entry/author/name not found.");
        }

        DocumentHelper.setSimpleElementText(element, identity.getUser().getId());

        // Replace date created, issued and modified
        DateFormat datefmt = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
        DateFormat ofsfmt = new SimpleDateFormat("Z");
        Date date = new Date();

        String dateofs = ofsfmt.format(date);
        String datestr = datefmt.format(date) + dateofs.substring(0, 3) + ":"
                + dateofs.substring(3, 5);

        element = (Element) XPathAPI.selectSingleNode(parent,
                "/*[local-name() = 'entry']/*[local-name() = 'created']");
        DocumentHelper.setSimpleElementText(element, datestr);
        element = (Element) XPathAPI.selectSingleNode(parent,
                "/*[local-name() = 'entry']/*[local-name() = 'issued']");
        DocumentHelper.setSimpleElementText(element, datestr);
        element = (Element) XPathAPI.selectSingleNode(parent,
                "/*[local-name() = 'entry']/*[local-name() = 'modified']");
        DocumentHelper.setSimpleElementText(element, datestr);

        SourceUtil.writeDOM(xmlDoc, document.getSourceURI(), this.manager);
    }
}
