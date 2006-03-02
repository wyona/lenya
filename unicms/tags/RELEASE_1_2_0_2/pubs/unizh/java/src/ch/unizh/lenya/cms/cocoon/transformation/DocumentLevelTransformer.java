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

/* $Id: DocumentLevelTransformer.java 160149 2005-08-19 09:51:54Z tc $  */

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
import org.apache.lenya.cms.publication.PageEnvelope;
import org.apache.lenya.cms.publication.PageEnvelopeFactory;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.SiteTree;
import org.apache.lenya.cms.publication.SiteTreeNode;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;

/**
 * This transformer lists all the documents of the same level as the requested document (including the requested document) if the tag <namespaceURI:level> 
 * is present in this document. The list of the level is in the form :
 * <namespaceURI:level>
 *   <node href="....html>
 *     <ci:include src="..." element="included"/> 
 *   </node>
 *   ...
 * </namespaceURI:level>
 * Multiple language : if one of the nodes doesn't exist in the language of the requested document, then the version 
 * in the default language will be considered. If it doesn't exist too, any other existent 
 * language will be considered.
 */
public class DocumentLevelTransformer extends AbstractSAXTransformer implements Parameterizable {

    private String namespace;
    private String cIncludeNamespace;

    public static final String LEVEL_ELEMENT = "level";
    public static final String ABSTRACT_ATTRIBUTE = "abstract";
    
    public static final String NAMESPACE = "http://apache.org/cocoon/lenya/documentlevel/1.0";
    public static final String PREFIX = "level:";

    /** (non-Javadoc)
    	 * @see org.apache.avalon.framework.parameters.Parameterizable#parameterize(org.apache.avalon.framework.parameters.Parameters)
    	 */
    public void parameterize(Parameters parameters) throws ParameterException {
        this.namespace = parameters.getParameter("namespace", null);
        this.cIncludeNamespace = parameters.getParameter("cIncludeNamespace", null);
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
            && cIncludeNamespace != null
            && localName.equals(LEVEL_ELEMENT)) {
                
            if (getLogger().isInfoEnabled()) {
                getLogger().info("Inserting level index");
            }

            String cIncludePrefix = "";
            if (!this.cIncludeNamespace.equals("")) {
                cIncludePrefix = "ci:";
            }

            String documentId = document.getId();
            String language = document.getLanguage();
            String defaultLanguage = publication.getDefaultLanguage();
            SiteTreeNode[] Level = siteTree.getNode(documentId).getParent().getChildren(); 


            super.startElement(uri, localName, raw, attr);

            for (int i = 0; i < Level.length; i++) {
                String nodeId = Level[i].getAbsoluteId();

                //get documents with the same language than the requested document
                String url = builder.buildCanonicalUrl(publication, area, nodeId, language);
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
                        "There is no node file "
                            + file.getAbsolutePath()
                            + " in the same language as the requested document ["
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
                        url = builder.buildCanonicalUrl(publication, area, nodeId, newlanguage);
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
                    //create the tags for the level node
                    String path;
                    try {
                        path = file.getCanonicalPath();
                    } catch (IOException e) {
                        throw new SAXException(e);
                    }

                    AttributesImpl attribute = new AttributesImpl();
                    attribute.addAttribute("", "href", "href", "", url);
                    super.startElement(NAMESPACE, "node", PREFIX + "node", attribute);

                    AttributesImpl attributes = new AttributesImpl();
                    attributes.addAttribute("", "src", "src", "", path);
                    attributes.addAttribute("", "element", "element", "", "included");

                    super.startElement(
                        this.cIncludeNamespace,
                        "include",
                        cIncludePrefix + "include",
                        attributes);
                    super.endElement(this.cIncludeNamespace, "include", cIncludePrefix + "include");
                    super.endElement(NAMESPACE, "node", PREFIX + "node");
                } else {
                    //do nothing for this child
                    getLogger().warn("There are no existing file for the node with id " + nodeId);
                }

            }
        } else {
            super.startElement(uri, localName, raw, attr);
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
