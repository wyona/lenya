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
package ch.unizh.unipublic.lenya.cms.publication;

import org.apache.lenya.cms.publication.*;
import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.Resource;
import org.apache.lenya.cms.publication.ResourceIdentityMap;
import org.apache.lenya.cms.publication.impl.ResourceFactoryImpl;
import org.apache.log4j.Category;


/**
 * 
 * @author <a href="edith@apache.org">Edith Chevrier</a>
 */
public class UnipublicResourceFactory extends ResourceFactoryImpl {
    private static final Category log = Category.getInstance(UnipublicResourceFactory.class);

    /**
     * Ctor.
     */
    public UnipublicResourceFactory() {
    	super();
    }

    /** (non-Javadoc)
     * @see org.apache.lenya.cms.publication.ResourceFactory#buildResource(java.lang.String, org.apache.lenya.cms.publication.ResourceIdentityMap)
     */
    public Resource buildResource(
        String resourceId,
        ResourceIdentityMap map)
        throws PublicationException {
        Resource resource;  
    	if (!resourceId.startsWith("/")) {
            throw new PublicationException("The resource ID does not start with '/'!");
        } else if (Headlines.isHeadlinesDocument(resourceId)) {
            resource = new Headlines(map, resourceId);
        } else if (Article.isArticleDocument(resourceId)) {
            resource = new Article(map, resourceId);
        } else if (Dossier.isDossierDocument(resourceId)) {
            resource = new Dossier(map, resourceId);
        } else if (DossiersBox.isDossiersBoxDocument(resourceId)) {
            resource = new DossiersBox(map, resourceId);
        } else if (Newsletter.isNewsletterDocument(resourceId)) {
            resource = new Newsletter(map, resourceId);
        } else {    
        	resource = super.buildResource(resourceId, map);
        }
        return resource;
    }

    /** (non-Javadoc)
     * @see org.apache.lenya.cms.publication.ResourceFactory#buildVersion(org.apache.lenya.cms.publication.Resource, java.lang.String, java.lang.String)
     */
    public Version buildVersion(Resource resource, String area, String language)
        throws PublicationException {
    	Version version;
    	if (Article.isArticleDocument(resource.getId())) {
    		version = new ArticleVersion(resource, area, language);
        } else if (Headlines.isHeadlinesDocument(resource.getId())){
            version = new HeadlinesVersion(resource, area, language);
        } else if (Dossier.isDossierDocument(resource.getId())){
            version = new DossierVersion(resource, area, language);
        } else if (DossiersBox.isDossiersBoxDocument(resource.getId())){
            version = new DossiersBoxVersion(resource, area, language);
        } else if (Newsletter.isNewsletterDocument(resource.getId())){
            version = new NewsletterVersion(resource, area, language);
    	} else {
    		version = super.buildVersion(resource, area, language);
    	}
        return version;
    }

}
