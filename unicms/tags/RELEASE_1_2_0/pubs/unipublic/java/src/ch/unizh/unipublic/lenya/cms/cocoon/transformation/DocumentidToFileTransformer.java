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

package ch.unizh.unipublic.lenya.cms.cocoon.transformation;

import org.apache.avalon.framework.parameters.Parameters;

import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.transformation.AbstractSAXTransformer;
import org.apache.cocoon.transformation.AbstractTransformer;
import org.apache.cocoon.transformation.XIncludeTransformer;
import org.apache.lenya.cms.publication.Document;
import org.apache.lenya.cms.publication.DocumentBuildException;
import org.apache.lenya.cms.publication.DocumentBuilder;
import org.apache.lenya.cms.publication.PageEnvelope;
import org.apache.lenya.cms.publication.PageEnvelopeException;
import org.apache.lenya.cms.publication.PageEnvelopeFactory;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;

import java.io.File;
import java.io.IOException;
import java.util.Map;

/**
 * This transformer replace the href in the xinclude's href attribute
 * with the path of the corresponding file 
 */
public class DocumentidToFileTransformer extends AbstractSAXTransformer {

    private PageEnvelope envelope = null;

    public static final String HREF_ATTR_NAME = "href";
    public static final String XPOINTER_ATTR_NAME ="xpointer";
    
    /**
     * @see org.apache.cocoon.sitemap.SitemapModelComponent#setup(org.apache.cocoon.environment.SourceResolver, java.util.Map, java.lang.String, org.apache.avalon.framework.parameters.Parameters)
     */
    public void setup(
        SourceResolver resolver,
        Map objectModel,
        String source,
        Parameters parameters)
        throws ProcessingException, SAXException, IOException {
        
        super.setup(resolver, objectModel, source, parameters);
        
        try {
            envelope =
                PageEnvelopeFactory.getInstance().getPageEnvelope(objectModel);
        } catch (PageEnvelopeException e) {
            throw new ProcessingException(e);
        }
    }

    /** (non-Javadoc)
     * @see org.xml.sax.ContentHandler#startElement(java.lang.String, java.lang.String, java.lang.String, org.xml.sax.Attributes)
     */
    public void startElement(
        String uri,
        String name,
        String qname,
        Attributes attrs)
        throws SAXException {

        AttributesImpl newAttrs = null;
        
        if (lookingAtXInclude(uri, name)) {

                String documentId = attrs.getValue("", HREF_ATTR_NAME);
                String xpointer = attrs.getValue("", XPOINTER_ATTR_NAME);
                if (documentId != null) {

                    try { 
                        File file = getFile(documentId);
                        if (newAttrs == null) {
                            newAttrs = new AttributesImpl(attrs);
                        }
                        if (xpointer != null) {
                            newAttrs.setValue(newAttrs.getIndex(HREF_ATTR_NAME), file.getAbsolutePath() + "#xpointer(" + xpointer + ")");
                            newAttrs.removeAttribute(newAttrs.getIndex(XPOINTER_ATTR_NAME));
                        } else {
                            newAttrs.setValue(newAttrs.getIndex(HREF_ATTR_NAME), file.getAbsolutePath());    
                        }
                        
                        
                    } catch (DocumentBuildException e) {
                        throw new SAXException("Could not build a document", e);
                    }
                }
  
        } 
        if (newAttrs == null) {
            super.startElement(uri, name, qname, attrs);
        } else {
            super.startElement(uri, name, qname, newAttrs);
        }
    }

    private File getFile(String documentId) throws DocumentBuildException {
        DocumentBuilder builder = envelope.getPublication().getDocumentBuilder();
        Document doc = builder.buildDocument(envelope.getPublication(), builder.buildCanonicalUrl(envelope.getPublication(), envelope.getDocument().getArea(), documentId));
        return doc.getFile();
    }

    /**
     * look if the element is a xinclude element
     * @param uri The Uri namespace.
     * @param name The name of the element
     * @return boolean. True if the element correpond to a xinlude element.
     */
    private boolean lookingAtXInclude(String uri, String name) {
        return uri != null
            && uri.equals(XIncludeTransformer.XINCLUDE_NAMESPACE_URI)
            && name.equals(XIncludeTransformer.XINCLUDE_INCLUDE_ELEMENT);
    }

    /** (non-Javadoc)
     * @see org.apache.avalon.excalibur.pool.Recyclable#recycle()
     */
    public void recycle() {
        super.recycle();
    }
}
