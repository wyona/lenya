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
package org.apache.lenya.cms.publication;

import java.util.HashMap;
import java.util.Map;

import org.apache.lenya.cms.publication.impl.*;

/**
 * <p>
 * An identity map storing the resources of a publication.
 * The key is {document-id}.
 * </p>
 * <p>
 * The identity map pattern ensures that you have only one instance
 * of a domain object per session. This avoids persistence conflicts.
 * The pattern is described in <em>Martin Fowler: Patterns for Enterprise
 * Application Artictectures</em>.
 * </p>
 * 
 * @author <a href="andreas@apache.org">Andreas Hartmann</a>
 * @version $Id: ResourceIdentityMap.java,v 1.4 2004/10/12 16:27:05 edith Exp $
 */
public class ResourceIdentityMap {
    
    private Map resources = new HashMap();
    
    private Publication publication;
    
    /**
     * Ctor.
     * @param publication The publication.
     */
    public ResourceIdentityMap(Publication publication) {
        this.publication = publication;
    }

    /**
     * Adds a resource;
     * @param resource A resource.
     */
    protected void add(Resource resource) {
        resources.put(generateKey(resource), resource);
    }
    
    /**
     * Generates a key for a resource.
     * @param resource The resource.
     * @return A string.
     */
    protected String generateKey(Resource resource) {
        return resource.getId();
    }
    
    /**
     * Returns a resource for a certain document ID.
     * @param key The document ID.
     * @return A resource.
     * @throws PublicationException when something went wrong.
     */
    public Resource get(String key) throws PublicationException {
        Resource resource = (Resource) resources.get(key);
        if (resource == null) {
            ResourceFactory factory = getResourceFactory() ;
            resource = factory.buildResource(key, this);
            add(resource);
        }
        return resource;
    }
    
    /**
     * Returns the publication.
     * @return A publication.
     */
    public Publication getPublication() {
        return publication;
    }
    
    /** 
     * Returns the resource factory .
     * @return A ResourceFactory.
     */
    public ResourceFactory getResourceFactory() {
        return new ResourceFactoryImpl();
    }
    
}
