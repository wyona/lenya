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

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.lenya.cms.publication.Document;
import org.apache.lenya.cms.publication.DocumentBuildException;
import org.apache.lenya.cms.publication.DocumentBuilder;
import org.apache.lenya.cms.publication.DocumentException;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.PublicationWrapper;
import org.apache.lenya.cms.publication.Resource;
import org.apache.lenya.cms.publication.ResourceFactory;
import org.apache.lenya.cms.publication.ResourceIdentityMap;
import org.apache.lenya.cms.publication.Version;
import org.apache.lenya.cms.publication.util.AreaFilter;
import org.apache.lenya.cms.publication.util.ResourceVisitor;
import org.apache.lenya.cms.publication.util.VersionFilter;
import org.apache.log4j.Category;

/**
 * A resource, containing a document for each area.
 * 
 * @author <a href="andreas@apache.org">Andreas Hartmann</a>
 * @version $Id: ResourceImpl.java,v 1.3 2004/11/26 17:00:53 edith Exp $
 */
public class ResourceImpl implements Resource {

    private static final Category log = Category.getInstance(ResourceImpl.class);

    private String resourceId;
    private Map documents = new HashMap();
    private ResourceIdentityMap identityMap;

    /**
     * Ctor.
     * @param resourceId The resource ID.
     * @param identityMap The identity map that stores this resource.
     */
    protected ResourceImpl(ResourceIdentityMap identityMap, String resourceId) {
        this.identityMap = identityMap;
        this.resourceId = resourceId;
    }

    /**
     * Returns the identity map that stores this resource.
     * @return An identity map.
     */
    public ResourceIdentityMap getIdentityMap() {
        return identityMap;
    }

    /**
     * Sets the resource ID.
     * @param resourceId A string.
     */
    protected void setResourceId(String resourceId) {
        this.resourceId = resourceId;
    }

    /**
     * Returns the resource ID.
     * @return A string.
     */
    public String getId() {
        return resourceId;
    }

    /**
     * Returns the publication this document group belongs to.
     * @return A publication.
     */
    public Publication getPublication() {
        return getIdentityMap().getPublication();
    }

    /**
     * Returns the document of this group for a certain area.
     * @param area The area.
     * @return A document.
     */
    public Document getVersion(String area) throws DocumentBuildException {
        return getVersion(area, getPublication().getDefaultLanguage());
    }

    /**
     * Returns the document of this group for a certain area and a certain language.
     * @param area The area.
     * @param language The language.
     * @return A document.
     */
    public Document getVersion(String area, String language) throws DocumentBuildException {
        Document document = (Document) documents.get(area);
        if (document == null) {
            DocumentBuilder builder = getPublication().getDocumentBuilder();
            String url = builder.buildCanonicalUrl(getPublication(), area, getId(), language);
            document = builder.buildDocument(getPublication(), url);
            documents.put(area, document);
        }
        return document;
    }

    /**
     * @see java.lang.Object#equals(java.lang.Object)
     */
    public boolean equals(Object object) {
        boolean equals = false;
        if (getClass().isInstance(object) && object.getClass().isInstance(this)) {
            equals = getKey().equals(((ResourceImpl) object).getKey());
        }
        return equals;
    }

    /**
     * @see java.lang.Object#hashCode()
     */
    public int hashCode() {
        String key = getKey();
        return key.hashCode();
    }

    /**
     * Returns the key used by equals() and hashCode().
     * @return A string.
     */
    protected String getKey() {
        String key = "";
        try {
            key =
                getPublication().getServletContext().getCanonicalPath()
                    + ":"
                    + getPublication().getId()
                    + ":"
                    + getId();
        } catch (IOException e) {
            log.error(e);
        }
        return key;
    }

    protected static final String[] AREAS =
        {
            Publication.AUTHORING_AREA,
            Publication.STAGING_AREA,
            Publication.LIVE_AREA,
            Publication.TRASH_AREA,
            Publication.ARCHIVE_AREA };

    /**
     * Returns the available areas.
     * @return An array of strings.
     */
    protected String[] getAreas() {
        return AREAS;
    }

    /**
     * @see org.apache.lenya.cms.publication.Resource#getLatestVersion()
     */
    public Document getLatestVersion() throws PublicationException {
        Document latestVersion = null;
        Document authoringVersion = getVersion(Publication.AUTHORING_AREA);
        if (authoringVersion.exists()) {
            latestVersion = authoringVersion;
        } else {
            Document stagingVersion = getVersion(Publication.STAGING_AREA);
            if (stagingVersion.exists()) {
                latestVersion = stagingVersion;
            }
        }
        return latestVersion;
    }

    /**
     * @see java.lang.Object#toString()
     */
    public String toString() {
        return getPublication().getId() + ":" + getId();
    }

    /**
     * @see org.apache.lenya.cms.publication.Resource#accept(org.apache.lenya.cms.publication.util.ResourceVisitor)
     */
    public void accept(ResourceVisitor visitor) throws DocumentException {
        try {
            visitor.visitDocument(this);
        } catch (PublicationException e) {
            throw new DocumentException(e);
        }
    }

    /**
     * @see org.apache.lenya.cms.publication.Resource#delete()
     */
    public void delete() throws PublicationException {
        String[] areas = getAreas();
        for (int i = 0; i < areas.length; i++) {
            VersionFilter filter = new AreaFilter(areas[i]);
            getVersions(filter)[0].delete();
        }
    }

    private PublicationWrapper wrapper;

    /**
     * @see org.apache.lenya.cms.publication.Resource#getPublicationWrapper()
     */
    public PublicationWrapper getPublicationWrapper() {
        if (wrapper == null) {
            wrapper = new PublicationWrapperImpl(getIdentityMap());
        }
        return wrapper;
    }

    private List versions;

    /**
     * Returns the versions of this resource.
     * @return
     * @throws PublicationException
     */
    protected List getVersions() throws PublicationException {
        if (versions == null) {

            versions = new ArrayList();
            String[] areas = getAreas();
            String[] languages = getPublication().getLanguages();

            ResourceFactory factory = getIdentityMap().getResourceFactory();
            for (int areaIndex = 0; areaIndex < areas.length; areaIndex++) {
                for (int langIndex = 0; langIndex < languages.length; langIndex++) {
                    Version version =
                        factory.buildVersion(this, areas[areaIndex], languages[langIndex]);
                    versions.add(version);
                }
            }
        }

        return versions;
    }

    /**
     * @see org.apache.lenya.cms.publication.Resource#getVersions(org.apache.lenya.cms.publication.util.VersionFilter)
     */
    public Version[] getVersions(VersionFilter filter) throws PublicationException {
        List versions = getVersions();
        List acceptedVersions = new ArrayList();
        for (Iterator i = versions.iterator(); i.hasNext();) {
            Version version = (Version) i.next();
            if (filter.accepts(version)) {
                acceptedVersions.add(version);
            }
        }
        return (Version[]) acceptedVersions.toArray(new Version[acceptedVersions.size()]);
    }

}
