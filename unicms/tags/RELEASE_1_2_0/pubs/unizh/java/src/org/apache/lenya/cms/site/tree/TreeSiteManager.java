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
package org.apache.lenya.cms.site.tree;

import java.util.ArrayList;
import java.util.List;

import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.Resource;
import org.apache.lenya.cms.publication.ResourceIdentityMap;
import org.apache.lenya.cms.publication.SiteTree;
import org.apache.lenya.cms.publication.SiteTreeException;
import org.apache.lenya.cms.publication.SiteTreeNode;
import org.apache.lenya.cms.site.AbstractSiteManager;
import org.apache.lenya.cms.site.SiteException;
import org.apache.log4j.Category;

/**
 * A tree-based site manager.
 * 
 * @author <a href="andreas@apache.org">Andreas Hartmann</a>
 * @version $Id: TreeSiteManager.java,v 1.4 2004/02/25 08:59:54 andreas Exp $
 */
public class TreeSiteManager extends AbstractSiteManager {

    private static final Category log = Category.getInstance(TreeSiteManager.class);

    /**
     * Ctor.
     * @param map The resource identity map.
     */
    public TreeSiteManager(ResourceIdentityMap map) {
        super(map);
    }

    /**
     * Returns the site tree for a certain area.
     * @param area The area.
     * @return A site tree.
     * @throws SiteTreeException if an error occurs.
     */
    protected SiteTree getTree(String area) throws SiteException {
        SiteTree tree;
        try {
            tree = getIdentityMap().getPublication().getTree(area);
        } catch (SiteTreeException e) {
            throw new SiteException(e);
        }
        return tree;
    }

    /**
     * Returns the parent of a resource.
     * @param resource The resource.
     * @return A resource.
     * @throws PublicationException if an error occurs.
     */
    protected Resource getParent(Resource resource) throws SiteException {
        Resource parent = null;
        int lastSlashIndex = resource.getId().lastIndexOf(Resource.ID_SEPARATOR);
        if (lastSlashIndex > 0) {
            String parentId = resource.getId().substring(0, lastSlashIndex);
            try {
                parent = getIdentityMap().get(parentId);
            } catch (PublicationException e) {
                throw new SiteException(e);
            }
        }
        return parent;
    }

    /**
     * Returns the ancestors of a resource, beginning with the parent.
     * @param resource The resource.
     * @return A list of resources.
     * @throws SiteException if an error occurs.
     */
    protected List getAncestors(Resource resource) throws SiteException {
        List ancestors = new ArrayList();
        Resource parent = getParent(resource);
        if (parent != null) {
            ancestors.add(parent);
            ancestors.addAll(getAncestors(parent));
        }
        return ancestors;
    }

    /**
     * @see org.apache.lenya.cms.site.SiteManager#requires(org.apache.lenya.cms.publication.Resource, org.apache.lenya.cms.publication.Resource)
     */
    public boolean requires(Resource dependingResource, Resource requiredResource)
        throws SiteException {
        return getAncestors(dependingResource).contains(requiredResource);
    }

    /**
     * @see org.apache.lenya.cms.site.SiteManager#getRequiredResources(org.apache.lenya.cms.publication.Resource, java.lang.String)
     */
    public Resource[] getRequiredResources(Resource resource, String area) throws SiteException {
        List ancestors = getAncestors(resource);
        return (Resource[]) ancestors.toArray(new Resource[ancestors.size()]);
    }

    /**
     * @see org.apache.lenya.cms.site.SiteManager#getRequiringResources(org.apache.lenya.cms.publication.Resource, java.lang.String)
     */
    public Resource[] getRequiringResources(Resource resource, String area) throws SiteException {

        if (log.isDebugEnabled()) {
            log.debug("Obtaining requiring resources of [" + area + "][" + resource + "]");
        }

        SiteTree tree = getTree(area);

        SiteTreeNode node = tree.getNode(resource.getId());
        List preOrder = node.preOrder();
        
        // remove original resource (does not require itself)
        preOrder.remove(0);
        
        Resource[] resources = new Resource[preOrder.size()];

        try {
            for (int i = 0; i < resources.length; i++) {
                SiteTreeNode descendant = (SiteTreeNode) preOrder.get(i);
                resources[i] = getIdentityMap().get(descendant.getAbsoluteId());
                if (log.isDebugEnabled()) {
                    log.debug("    Descendant: [" + resources[i] + "]");
                }
            }
        } catch (PublicationException e) {
            throw new SiteException(e);
        }

        if (log.isDebugEnabled()) {
            log.debug("Obtaining requiring resources completed.");
        }

        return resources;
    }

    /**
     * @see org.apache.lenya.cms.site.SiteManager#contains(org.apache.lenya.cms.publication.Resource, java.lang.String)
     */
    public boolean contains(Resource resource, String area) throws SiteException {
        SiteTreeNode node = getTree(area).getNode(resource.getId());
        return node != null;
    }

}
