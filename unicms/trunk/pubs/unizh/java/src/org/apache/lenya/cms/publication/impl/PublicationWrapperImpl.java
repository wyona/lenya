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
import java.util.HashMap;
import java.util.Map;

import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.DefaultConfigurationBuilder;
import org.apache.lenya.cms.publication.Document;
import org.apache.lenya.cms.publication.Proxy;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.PublicationWrapper;
import org.apache.lenya.cms.publication.ResourceIdentityMap;
import org.apache.lenya.cms.publication.SiteTreeException;
import org.apache.lenya.cms.publication.Version;
import org.apache.lenya.cms.site.SiteManager;
import org.apache.lenya.cms.site.tree.TreeSiteManager;
import org.apache.log4j.Category;

/**
 * A publication wrapper implementation.
 * 
 * @author <a href="andreas@apache.org">Andreas Hartmann </a>
 * @version $Id: PublicationWrapperImpl.java,v 1.2 2004/02/19 15:42:03 andreas
 *          Exp $
 */
public class PublicationWrapperImpl implements PublicationWrapper {

    private static final Category log = Category.getInstance(PublicationWrapperImpl.class);

    private static final String ELEMENT_PROXY = "proxy";
    private static final String ATTRIBUTE_AREA = "area";
    private static final String ATTRIBUTE_URL = "url";
    private static final String ATTRIBUTE_SSL = "ssl";

    /**
     * Ctor.
     * @param map The resource identity map to use.
     */
    public PublicationWrapperImpl(ResourceIdentityMap map) {
        this.map = map;

        File configFile = new File(getPublication().getDirectory(), Publication.CONFIGURATION_FILE);
        DefaultConfigurationBuilder builder = new DefaultConfigurationBuilder();

        Configuration config;

        try {
            config = builder.buildFromFile(configFile);

            Configuration[] proxyConfigs = config.getChildren(ELEMENT_PROXY);
            for (int i = 0; i < proxyConfigs.length; i++) {
                String url = proxyConfigs[i].getAttribute(ATTRIBUTE_URL);
                String ssl = proxyConfigs[i].getAttribute(ATTRIBUTE_SSL);
                String area = proxyConfigs[i].getAttribute(ATTRIBUTE_AREA);

                Proxy proxy = new Proxy();
                proxy.setUrl(url);

                Object key = getProxyKey(area, Boolean.valueOf(ssl).booleanValue());
                this.areaSsl2proxy.put(key, proxy);
                if (log.isDebugEnabled()) {
                    log.debug("Adding proxy: [" + proxy + "] for area=[" + area + "] SSL=[" + ssl + "]");
                }
            }

        } catch (Exception e) {
            log.error("Initializing " + this.getClass().getName() + " failed: ", e);
            throw new IllegalStateException(e.getMessage());
        }
    }

    private ResourceIdentityMap map;

    /**
     * @see org.apache.lenya.cms.publication.PublicationWrapper#getPublication()
     */
    public Publication getPublication() {
        return this.map.getPublication();
    }

    /**
     * Returns the resource identity map.
     * 
     * @return A resource identity map.
     */
    protected ResourceIdentityMap getIdentityMap() {
        return this.map;
    }

    /**
     * @see org.apache.lenya.cms.publication.PublicationWrapper#getSiteManager()
     */
    public SiteManager getSiteManager() throws PublicationException {
        SiteManager manager = null;
        try {
            if (getPublication().getSiteTree(Publication.AUTHORING_AREA) != null) {
                manager = new TreeSiteManager(getIdentityMap());
            }
        } catch (SiteTreeException e) {
            throw new PublicationException(e);
        }
        return manager;
    }

    /**
     * @see org.apache.lenya.cms.publication.PublicationWrapper#move(org.apache.lenya.cms.publication.Version,
     *      org.apache.lenya.cms.publication.Version)
     */
    public void move(Version source, Version destination) throws PublicationException {
        if (log.isDebugEnabled()) {
            log.debug("Move document [" + this + "]");
            log.debug("    From: [" + source + "]");
            log.debug("    To:   [" + destination + "]");
        }
        Document sourceDocument = ((VersionImpl) source).getDocument();
        Document destinationDocument = ((VersionImpl) destination).getDocument();
        getPublication().moveDocument(sourceDocument, destinationDocument);
    }

    /**
     * @see org.apache.lenya.cms.publication.PublicationWrapper#copy(org.apache.lenya.cms.publication.Version,
     *      org.apache.lenya.cms.publication.Version)
     */
    public void copy(Version source, Version destination) throws PublicationException {
        if (log.isDebugEnabled()) {
            log.debug("Copy document [" + this + "]");
            log.debug("    From: [" + source + "]");
            log.debug("    To:   [" + destination + "]");
        }
        Document sourceDocument = ((VersionImpl) source).getDocument();
        Document destinationDocument = ((VersionImpl) destination).getDocument();
        getPublication().copyDocument(sourceDocument, destinationDocument);
    }

    private Map areaSsl2proxy = new HashMap();
    
    /**
     * Generates a hash key for a  area-SSL combination.
     * @param area The area.
     * @param isSslProtected If the proxy is assigned for SSL-protected pages.
     * @return An object.
     */
    protected Object getProxyKey(String area, boolean isSslProtected) {
        return area + ":" + isSslProtected;
    }

    /* (non-Javadoc)
     * @see org.apache.lenya.cms.publication.PublicationWrapper#getProxy(org.apache.lenya.cms.publication.Version)
     */
    public Proxy getProxy(Version version, boolean isSslProtected) {

        Object key = getProxyKey(version.getDocument().getArea(), isSslProtected);
        Proxy proxy = (Proxy) this.areaSsl2proxy.get(key);
        
        if (log.isDebugEnabled()) {
            log.debug("Resolving proxy for [" + version + "] SSL=[" + isSslProtected + "]");
            log.debug("Resolved proxy: [" + proxy + "]");
        }
        
        return proxy;
    }

}