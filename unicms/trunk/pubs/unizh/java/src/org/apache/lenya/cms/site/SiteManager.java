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
package org.apache.lenya.cms.site;

import org.apache.lenya.cms.publication.Resource;

/**
 * <p>A site structure management component.</p>
 * 
 * <p>Dependence on a set of resources must be a strict partial order <strong>&lt;</strong>:</p>
 * <ul>
 * <li><em>irreflexive:</em> d<strong>&lt;</strong>d does not hold for any resource d</li>
 * <li><em>antisymmetric:</em> d<strong>&lt;</strong>e and e<strong>&lt;</strong>d implies d=e</li>
 * <li><em>transitive:</em> d<strong>&lt;</strong>e and e<strong>&lt;</strong>f implies d<strong>&lt;</strong>f</li>
 * </ul>

 *  * @author <a href="andreas@apache.org">Andreas Hartmann</a>
 * @version $Id: SiteManager.java,v 1.1 2004/02/18 18:47:07 andreas Exp $
 */
public interface SiteManager {

    /**
     * Checks if a resource requires another one.
     * @param dependingResource The depending resource.
     * @param requiredResource The required resource.
     * @return A boolean value.
     * @throws SiteException if an error occurs.
     */
    boolean requires(Resource dependingResource, Resource requiredResource) throws SiteException;

    /**
     * Returns the resources which are required by a certain resource.
     * @param resource The depending resource.
     * @param area The area.
     * @return An array of resources.
     * @throws SiteException if an error occurs.
     */
    Resource[] getRequiredResources(Resource resource, String area) throws SiteException;
    
    /**
     * Returns the resources which require a certain resource.
     * @param resource The required resource.
     * @return An array of resources.
     * @throws SiteException if an error occurs.
     */
    Resource[] getRequiringResources(Resource resource, String area) throws SiteException;
    
    /**
     * Checks if the site structure contains a certain resource in a certain area.
     * @param resource The resource.
     * @param area The area.
     * @return A boolean value.
     * @throws SiteException if an error occurs.
     */
    boolean contains(Resource resource, String area) throws SiteException;

}
