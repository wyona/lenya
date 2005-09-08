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

/* $Id: UnizhImpl.java 2005-09-08 ch.unizh.mike $  */

package ch.unizh.lenya.cms.publication;

import java.io.File;

import org.apache.lenya.cms.publication.Document;
import org.apache.lenya.cms.publication.DocumentException;
import org.apache.lenya.cms.publication.PageEnvelope;
import org.apache.lenya.xml.DocumentHelper;
import org.apache.lenya.xml.NamespaceHelper;
import org.w3c.dom.Element;

/**
 * Access the root element in documents.
 */
public class UnizhImpl {
    private Document cmsdocument;
    private File infofile;
    public static final String NAMESPACE = "http://unizh.ch/doctypes/elements/1.0";
    public static final String DEFAULT_PREFIX = "unizh";
    private static final String META = "meta";
    private static final String REDIRECT_TO = "redirect-to";

    /** 
     * Creates a new instance of Unizh
     * 
     * @param aDocument the document for which the Unizh instance is created.
     * 
     * @throws DocumentException if an error occurs
     */
    public UnizhImpl(Document aDocument) throws DocumentException {
        this.cmsdocument = aDocument;
        infofile =
            cmsdocument.getPublication().getPathMapper().getFile(
                cmsdocument.getPublication(),
                cmsdocument.getArea(),
                cmsdocument.getId(),
                cmsdocument.getLanguage());
    }

    /**
     * Loads the href attribute of the <unizh:redirect-to> element from the XML file.
     * @throws DocumentException when something went wrong.
     */
    public String getRedirectURI() throws DocumentException {

        String value = null;
        if (infofile.exists()) {
            org.w3c.dom.Document doc = null;
            try {
                doc = DocumentHelper.readDocument(infofile);
            } catch (Exception e) {
                throw new DocumentException("Parsing file [" + infofile + "] failed: ", e);
            }

            NamespaceHelper lenyaNamespaceHelper =
                new NamespaceHelper(PageEnvelope.NAMESPACE, PageEnvelope.DEFAULT_PREFIX, doc);
            Element documentElement = doc.getDocumentElement();
            Element metaElement = lenyaNamespaceHelper.getFirstChild(documentElement, META);
            // FIXME: what if "lenya:meta" element doesn't exist yet?
            // Currently the element is inserted.

            NamespaceHelper unizhNamespaceHelper =
                new NamespaceHelper(NAMESPACE, DEFAULT_PREFIX, doc);
            Element redirectElement = unizhNamespaceHelper.getFirstChild(metaElement, REDIRECT_TO);
            // returns null if "unizh:redirect-to" element doesn't exist
            // FIXME: is this an appropriate work around?
            if (redirectElement != null) {
                value = redirectElement.getAttribute("href");
            }
        }
        return value;
    }

}
