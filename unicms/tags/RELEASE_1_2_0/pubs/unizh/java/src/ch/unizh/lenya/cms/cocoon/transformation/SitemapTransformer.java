/*
 * Copyright  1999-2004 The Apache Software Foundation
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

/* $Id: SitemapTransformer.java 2005-09-21 ch.unizh.mike $  */

package ch.unizh.lenya.cms.cocoon.transformation;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.avalon.framework.parameters.ParameterException;
import org.apache.avalon.framework.parameters.Parameterizable;
import org.apache.avalon.framework.parameters.Parameters;
import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.transformation.AbstractSAXTransformer;
import org.apache.lenya.cms.publication.Document;
import org.apache.lenya.cms.publication.DocumentBuildException;
import org.apache.lenya.cms.publication.DocumentBuilder;
import org.apache.lenya.cms.publication.DocumentException;
import org.apache.lenya.cms.publication.DublinCore;
import org.apache.lenya.cms.publication.PageEnvelope;
import org.apache.lenya.cms.publication.PageEnvelopeFactory;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.SiteTree;
import org.apache.lenya.cms.publication.SiteTreeNode;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;

/**
 * This transformer lists all documents if the tag <namespaceURI:sitemap> 
 * is present in this document. The list of the documents is in the form:
 *
 * <namespaceURI:sitemap>
 *   <namespaceURI:node id="..." href="/pub/area/path/level1.html">
 *     <namespaceURI:title>...</namespaceURI:title>
 *     <namespaceURI:description>...</namespaceURI:description>
 *     <namespaceURI:node id="..." href="/pub/area/path/level1/level2.html"/>
 *     ...
 *   </namespaceURI:node>
 * </namespaceURI:sitemap>
 *
 * Multiple language : if a document doesn't exist in the parent language, then the version 
 * in the default language will be considered. If it doesn't exist too, any other existent 
 * language will be considered.
 */
public class SitemapTransformer extends AbstractSAXTransformer implements Parameterizable {

    private String namespace;

    public static final String SITEMAP_ELEMENT = "sitemap";    
    public static final String NAMESPACE = "http://unizh.ch/doctypes/elements/1.0";
    public static final String PREFIX = "unizh:";

    /** (non-Javadoc)
    	 * @see org.apache.avalon.framework.parameters.Parameterizable#parameterize(org.apache.avalon.framework.parameters.Parameters)
    	 */
    public void parameterize(Parameters parameters) throws ParameterException {
        this.namespace = parameters.getParameter("namespace", null);
    }

    private Document document;

    private Publication publication;

    private String area;

    private DocumentBuilder builder;

    private SiteTree siteTree;

    /** (non-Javadoc)
     * @see org.apache.cocoon.sitemap.SitemapModelComponent#setup(org.apache.cocoon.environment.SourceResolver, java.util.Map, java.lang.String, org.apache.avalon.framework.parameters.Parameters)
     */
    public void setup(SourceResolver resolver, Map objectModel, String src, Parameters parameters)
        throws ProcessingException, SAXException, IOException {
        try {

        	super.setup(resolver, objectModel, src, parameters);

        	parameterize(parameters);

            PageEnvelope envelope = null;
            envelope = PageEnvelopeFactory.getInstance().getPageEnvelope(objectModel);

            setDocument(envelope.getDocument());
            setPublication(document.getPublication());
            setArea(document.getArea());
            setBuilder(document.getPublication().getDocumentBuilder());
            setSiteTree(publication.getTree(area));

        } catch (Exception e) {
            throw new ProcessingException(e);
        }

    }

    /** (non-Javadoc)
     * @see org.xml.sax.ContentHandler#startElement(java.lang.String, java.lang.String, java.lang.String, org.xml.sax.Attributes)
     */
    public void startElement(String uri, String localName, String raw, Attributes attr)
        throws SAXException {

        if (uri != null
            && uri.equals(namespace)
            && localName.equals(SITEMAP_ELEMENT)) {
                
            if (getLogger().isInfoEnabled()) {
                getLogger().info("Inserting index");
            }

            super.startElement(uri, localName, raw, attr);

            // for providing links in the language version of the calling document
            String documentId = document.getId();
            String language = document.getLanguage();
            String defaultLanguage = publication.getDefaultLanguage();

            SiteTreeNode[] topNodes = siteTree.getTopNodes();

            for (int i = 0; i < topNodes.length; i++) {
                String topNodeId = "/" + topNodes[i].getId();
                traverseSiteTree(topNodeId,language,defaultLanguage);
            }

        } else {
            super.startElement(uri, localName, raw, attr);
        }

    }


    private void traverseSiteTree(String documentId, String language, String defaultLanguage)
        throws SAXException {

                //get document with the same language than the parent document
                String url = builder.buildCanonicalUrl(publication, area, documentId, language);
                Document doc;
                try {
                    doc = builder.buildDocument(publication, url);
                } catch (DocumentBuildException e) {
                    throw new SAXException(e);
                }

                File file = doc.getFile();

                if (!file.exists()) {
                    //get first the document in the default language and then in any other existent language
                    getLogger().debug(
                        "There is no document file "
                            + file.getAbsolutePath()
                            + " in the same language as the parent document ["
                            + language
                            + "]");

                    //available language    
                    String[] availableLanguages = null;
                    try {
                        availableLanguages = doc.getLanguages();
                    } catch (DocumentException e) {
                        throw new SAXException(e);
                    }

                    List languages = new ArrayList();
                    for (int l = 0; l < availableLanguages.length; l++) {
                        if (availableLanguages[l].equals(language)) {
                            getLogger().debug(
                                "Do nothing because language was already tested: ["
                                    + availableLanguages[l]
                                    + "]");
                        } else if (availableLanguages[l].equals(defaultLanguage)) {
                            languages.add(0, availableLanguages[l]);
                        } else {
                            languages.add(availableLanguages[l]);
                        }
                    }

                    int j = 0;
                    while (!file.exists() && j < languages.size()) {
                        String newlanguage = (String) languages.get(j);
                        url = builder.buildCanonicalUrl(publication, area, documentId, newlanguage);
                        try {
                            doc = builder.buildDocument(publication, url);
                        } catch (DocumentBuildException e) {
                            throw new SAXException(e);
                        }
                        file = doc.getFile();

                        j++;
                    }
                }

                if (file.exists()) {
                    //create the tags for the document
                    String docTitle = null;
                    String docDescription = null;
                    DublinCore dublinCore;
                    try {
                        dublinCore = doc.getDublinCore();
                        docTitle = dublinCore.getTitle();
                        docDescription = dublinCore.getDescription();
                    } catch (DocumentException e) {
                        throw new SAXException(e);
                    }

                    AttributesImpl attributes = new AttributesImpl();
                    attributes.addAttribute("", "id", "id", "", documentId);
                    attributes.addAttribute("", "href", "href", "", url);
                    super.startElement(NAMESPACE, "node", PREFIX + "node", attributes);

                    AttributesImpl noAttributes = new AttributesImpl();
                    super.startElement(NAMESPACE, "title", PREFIX + "title", noAttributes);
                    sendTextEvent(docTitle);
                    super.endElement(NAMESPACE, "title", PREFIX + "title");

                    super.startElement(NAMESPACE, "description", PREFIX + "description", noAttributes);
                    sendTextEvent(docDescription);
                    super.endElement(NAMESPACE, "description", PREFIX + "description");

                    SiteTreeNode[] children = siteTree.getNode(documentId).getChildren();
                    for (int i = 0; i < children.length; i++) {
                        String childId = documentId + "/" + children[i].getId();
                        traverseSiteTree(childId,language,defaultLanguage);
                    }

                    super.endElement(NAMESPACE, "node", PREFIX + "node");
                } else {
                    //do nothing for this document
                    getLogger().warn("There are no existing file for the document with id " + documentId);
                }
    }


    /**
     * @return SiteTree The siteTree belonging to the area of the document
     */
    public SiteTree getSiteTree() {
        return siteTree;
    }

    /**
     * @param tree The siteTree of the area, which the document belongs.
     */
    public void setSiteTree(SiteTree tree) {
        siteTree = tree;
    }

    /**
     * @param string The area, which the document belongs.
     */
    public void setArea(String string) {
        area = string;
    }

    /**
     * @param builder The document builder.
     */
    public void setBuilder(DocumentBuilder builder) {
        this.builder = builder;
    }

    /**
     * @param document The document.
     */
    public void setDocument(Document document) {
        this.document = document;
    }

    /**
     * @param publication The publication, which the document belongs.
     */
    public void setPublication(Publication publication) {
        this.publication = publication;
    }

}
