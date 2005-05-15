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
package org.apache.lenya.pubs.wiki.cocoon.transformation;

import java.io.File;
import java.io.IOException;
import java.util.Map;

import org.apache.avalon.framework.parameters.Parameters;
import org.apache.avalon.framework.activity.Disposable;
import org.apache.avalon.framework.service.ServiceSelector;
import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.transformation.AbstractSAXTransformer;
import org.apache.lenya.ac.AccessControlException;
import org.apache.lenya.ac.AccessController;
import org.apache.lenya.ac.AccessControllerResolver;
import org.apache.lenya.ac.AccreditableManager;
import org.apache.lenya.ac.Authorizer;
import org.apache.lenya.ac.Policy;
import org.apache.lenya.ac.PolicyManager;
import org.apache.lenya.ac.impl.DefaultAccessController;
import org.apache.lenya.ac.impl.PolicyAuthorizer;
import org.apache.lenya.cms.publication.Document;
import org.apache.lenya.cms.publication.DocumentBuilder;
import org.apache.lenya.cms.publication.PageEnvelope;
import org.apache.lenya.cms.publication.PageEnvelopeFactory;
import org.apache.lenya.cms.publication.Proxy;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.util.ServletHelper;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;

/**
 * <p>
 * Link rewriting transformer.
 * </p>
 * 
 * <p>
 * This transformer is applied to an XHMTL document. It processes <code>&lt;xhtml:a href="..."&gt;</code>
 * attributes of the following form:
 * </p>
 * <p>
 * <code>{context-prefix}/{publication-id}/{area}{document-url}</code>
 * </p>
 * <p>
 * These links are rewritten using the following rules:
 * </p>
 * <ul>
 * <li>The area is replaced by the current area (obtained from the page envelope).</li>
 * <li>A URL prefix is added depending on the proxy configuration of the publication.</li>
 * <li>If the target document does not exist, the <code>&lt;a/&gt;</code> element is removed to disable the link.</li>
 * </ul>
 * 
 */
public class LinkRewritingTransformer extends AbstractSAXTransformer implements Disposable {

    private boolean ignoreAElement = false;
    private ServiceSelector serviceSelector;
    private PolicyManager policyManager;
    private AccessControllerResolver acResolver;
    private AccreditableManager accreditableManager;

    private Document currentDocument;

    /**
     * @see org.apache.cocoon.sitemap.SitemapModelComponent#setup(org.apache.cocoon.environment.SourceResolver,
     *      java.util.Map, java.lang.String,
     *      org.apache.avalon.framework.parameters.Parameters)
     */
    public void setup(SourceResolver resolver, Map objectModel, String source, Parameters parameters)
            throws ProcessingException, SAXException, IOException {
        super.setup(resolver, objectModel, source, parameters);

        try {
            PageEnvelope envelope = PageEnvelopeFactory.getInstance().getPageEnvelope(objectModel);
            this.currentDocument = envelope.getDocument();

        } catch (Exception e) {
            throw new ProcessingException(e);
        }

        if (getLogger().isDebugEnabled()) {
            getLogger().debug("Setting up transformer");
            getLogger().debug("    Processed version:       [" + getCurrentDocument() + "]");
        }

        Request request = ObjectModelHelper.getRequest(objectModel);

        this.serviceSelector = null;
        this.acResolver = null;
        this.policyManager = null;

        try {
            this.serviceSelector = (ServiceSelector) this.manager
                    .lookup(AccessControllerResolver.ROLE + "Selector");
            this.acResolver = (AccessControllerResolver) this.serviceSelector
                    .select(AccessControllerResolver.DEFAULT_RESOLVER);

            if (getLogger().isDebugEnabled()) {
                getLogger().debug("    Resolved AC resolver [" + this.acResolver + "]");
            }
            String webappUrl = ServletHelper.getWebappURI(request);
            AccessController accessController = this.acResolver.resolveAccessController(webappUrl);
            if (accessController instanceof DefaultAccessController) {
                DefaultAccessController defaultAccessController = (DefaultAccessController) accessController;
                this.accreditableManager = defaultAccessController.getAccreditableManager();
                Authorizer[] authorizers = defaultAccessController.getAuthorizers();
                for (int i = 0; i < authorizers.length; i++) {
                    if (authorizers[i] instanceof PolicyAuthorizer) {
                        PolicyAuthorizer policyAuthorizer = (PolicyAuthorizer) authorizers[i];
                        this.policyManager = policyAuthorizer.getPolicyManager();
                    }
                }
            }
            if (getLogger().isDebugEnabled()) {
                getLogger().debug("    Using policy manager [" + this.policyManager + "]");
            }
        } catch (Exception e) {
            throw new ProcessingException(e);
        }
    }

    /**
     * Returns the currently processed document.
     * 
     * @return A document.
     */
    protected Document getCurrentDocument() {
        return this.currentDocument;
    }

    /**
     * The local name of the HTML &lt;a&gt; href attribute.
     */
    public static final String ATTRIBUTE_HREF = "href";

    private String indent = "";

    /**
     * (non-Javadoc)
     * 
     * @see org.xml.sax.ContentHandler#startElement(java.lang.String,
     *      java.lang.String, java.lang.String, org.xml.sax.Attributes)
     */
    public void startElement(String uri, String name, String qname, Attributes attrs) throws SAXException {
        //getLogger().error(this.indent + "<" + qname + "> (ignoreAElement = " + isIgnoreAElement() + ")");

        AttributesImpl newAttrs = new AttributesImpl(attrs);
        if(name.equals("link")) {
            getLogger().debug(this.indent + "<" + qname + "> (Link element found)");
            String href = attrs.getValue(ATTRIBUTE_HREF);
            if (href != null) {
                getLogger().debug("href=" + href);

                // Check if linked file exists
		File currentFile = getCurrentDocument().getFile();
		getLogger().debug("Current Document file: " + currentFile);
		File linkedFile = new File(new File(currentFile.getParent()).getParent() + File.separator + replaceHTMLbyXMLSuffix(href));
		getLogger().debug("Linked Document file: " + linkedFile);

                if(!linkedFile.isDirectory()) {
		    getLogger().info("Linked document does not exist yet: " + linkedFile);
                    setHrefAttribute(newAttrs, "?lenya.usecase=wikicreate&lenya.step=confirm&path=" + removeIndex(href));
                }
            } else {
                getLogger().warn("Link element does not have href attribute!");
            }
        }


        // Re-insert start of element
        super.startElement(uri, name, qname, newAttrs);
        if (getLogger().isDebugEnabled()) {
            getLogger().debug(this.indent + "<" + qname + "> (Insert element)");
        }
    }

    /**
     * Rewrites a link.
     * 
     * @param newAttrs The new attributes.
     * @param targetDocument The target document.
     * @param anchor The anchor (the string after the # character in the URL).
     * @throws AccessControlException when something went wrong.
     * @throws PublicationException when something went wrong.
     */
    protected void rewriteLink(AttributesImpl newAttrs, Document targetDocument, String anchor)
            throws AccessControlException, PublicationException {
        String webappUrl = targetDocument.getCompleteURL();
        Policy policy = this.policyManager.getPolicy(this.accreditableManager, webappUrl);

        Proxy proxy = targetDocument.getPublication().getProxy(targetDocument, policy.isSSLProtected());

        String rewrittenURL;
        if (proxy == null) {
            rewrittenURL = this.request.getContextPath() + webappUrl;
        } else {
            rewrittenURL = proxy.getURL(targetDocument);
        }
        
        if (anchor != null) {
            rewrittenURL += "#" + anchor;
        }

        if (getLogger().isDebugEnabled()) {
            getLogger().debug(this.indent + "SSL protection: [" + policy.isSSLProtected() + "]");
            getLogger().debug(this.indent + "Resolved proxy: [" + proxy + "]");
            getLogger().debug(this.indent + "Rewriting URL to: [" + rewrittenURL + "]");
        }

        setHrefAttribute(newAttrs, rewrittenURL);
    }

    /**
     * Sets the value of the href attribute.
     * 
     * @param attr The attributes.
     * @param value The value.
     * @throws IllegalArgumentException if the href attribute is not contained
     *             in this attributes.
     */
    protected void setHrefAttribute(AttributesImpl attr, String value) {
        int position = attr.getIndex(ATTRIBUTE_HREF);
        if (position == -1) {
            throw new IllegalArgumentException("The href attribute is not available!");
        }
        attr.setValue(position, value);
    }

    /**
     * (non-Javadoc)
     * 
     * @see org.xml.sax.ContentHandler#endElement(java.lang.String,
     *      java.lang.String, java.lang.String)
     */
    public void endElement(String uri, String name, String qname) throws SAXException {
        if (getLogger().isDebugEnabled()) {
            this.indent = this.indent.substring(2);
            getLogger().debug(this.indent + "</" + qname + ">");
        }
        if (lookingAtAElement(name) && isIgnoreAElement()) {
            setIgnoreAElement(false);
        } else {
            if (getLogger().isDebugEnabled()) {
                getLogger().debug(this.indent + "</" + qname + "> sent");
            }
            super.endElement(uri, name, qname);
        }
    }

    /**
     * Check if we are looking at a link element
     * 
     * @param name name of the element
     * 
     * @return true if we are looking at a link element
     */
    protected boolean lookingAtLinkElement(String name) {
        return lookingAtAElement(name);
    }

    protected boolean lookingAtAElement(String name) {
        return name.equals("a");
    }

    /**
     * @see org.apache.avalon.framework.activity.Disposable#dispose()
     */
    public void dispose() {
        if (getLogger().isDebugEnabled()) {
            getLogger().debug("Disposing transformer");
        }
        if (this.serviceSelector != null) {
            if (this.acResolver != null) {
                this.serviceSelector.release(this.acResolver);
            }
            this.manager.release(this.serviceSelector);
        }
    }

    /**
     * (non-Javadoc)
     * @see org.apache.avalon.excalibur.pool.Recyclable#recycle()
     */
    public void recycle() {
        this.ignoreAElement = false;
    }
    /**
     * @return Returns the ignoreAElement.
     */
    protected boolean isIgnoreAElement() {
        return ignoreAElement;
    }

    /**
     * @param ignoreAElement The ignoreAElement to set.
     */
    protected void setIgnoreAElement(boolean ignoreAElement) {
        this.ignoreAElement = ignoreAElement;
    }

    /**
     * Replace HTML by XML suffix
     */
    private String replaceHTMLbyXMLSuffix(String href) {
        return href.substring(0, href.length() - 4) + "xml";
    }

    /**
     * Remove /index.html
     */
    private String removeIndex(String href) {
        return href.substring(0, href.length() - 11);
    }
}
