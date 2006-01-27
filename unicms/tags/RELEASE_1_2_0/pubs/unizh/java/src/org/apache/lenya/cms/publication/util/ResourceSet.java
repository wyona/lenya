/*
 * $Id: ResourceSet.java,v 1.1 2004/02/18 18:47:07 andreas Exp $ <License>
 * 
 * ============================================================================ The Apache Software
 * License, Version 1.1
 * ============================================================================
 * 
 * Copyright (C) 1999-2003 The Apache Software Foundation. All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modifica- tion, are permitted
 * provided that the following conditions are met:
 *  1. Redistributions of source code must retain the above copyright notice, this list of
 * conditions and the following disclaimer.
 *  2. Redistributions in binary form must reproduce the above copyright notice, this list of
 * conditions and the following disclaimer in the documentation and/or other materials provided
 * with the distribution.
 *  3. The end-user documentation included with the redistribution, if any, must include the
 * following acknowledgment: "This product includes software developed by the Apache Software
 * Foundation (http://www.apache.org/)." Alternately, this acknowledgment may appear in the
 * software itself, if and wherever such third-party acknowledgments normally appear.
 *  4. The names "Apache Lenya" and "Apache Software Foundation" must not be used to endorse or
 * promote products derived from this software without prior written permission. For written
 * permission, please contact apache@apache.org.
 *  5. Products derived from this software may not be called "Apache", nor may "Apache" appear in
 * their name, without prior written permission of the Apache Software Foundation.
 * 
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE APACHE SOFTWARE FOUNDATION OR ITS CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLU- DING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * This software consists of voluntary contributions made by many individuals on behalf of the
 * Apache Software Foundation and was originally created by Michael Wechner <michi@apache.org> .
 * For more information on the Apache Soft- ware Foundation, please see <http://www.apache.org/> .
 * 
 * Lenya includes software developed by the Apache Software Foundation, W3C, DOM4J Project,
 * BitfluxEditor, Xopus, and WebSHPINX. </License>
 */
package org.apache.lenya.cms.publication.util;

import java.util.ArrayList;
import java.util.List;

import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.Resource;

/**
 * A set of resources.
 * 
 * @author <a href="mailto:andreas@apache.org">Andreas Hartmann</a>
 */
public class ResourceSet implements ResourceCollection {

    /**
	 * Ctor.
	 */
    public ResourceSet() {
    }
    
    /**
     * Ctor.
     * @param resourcs The initial resourcs.
     */
    public ResourceSet(Resource[] resourcs) throws PublicationException {
        for (int i = 0; i < resourcs.length; i++) {
            add(resourcs[i]);
        }
    }

    private List resources = new ArrayList();

    /**
	 * Returns the resources contained in this set.
	 * 
	 * @return An array of resources.
	 */
    public Resource[] getResources() throws PublicationException {
        return (Resource[]) resources.toArray(new Resource[resources.size()]);
    }

    /**
	 * Adds a resource to this set.
	 * 
	 * @param resource The resource to add.
	 */
    public void add(Resource resource) throws PublicationException {
        assert resource != null;
        assert !resources.contains(resource);
        resources.add(resource);
    }

    /**
     * Removes a resource from this set.
     * 
     * @param resource The resource to add.
     */
    public void remove(Resource resource) throws PublicationException {
        assert resource != null;
        assert resources.contains(resource);
        resources.remove(resource);
    }

    /**
	 * Checks if this set is empty.
	 * 
	 * @return A boolean value.
	 */
    public boolean isEmpty() throws PublicationException {
        return resources.isEmpty();
    }
    
    /**
     * Visits the resource set.
     * @param visitor The visitor.
     * @throws DocumentException if an error occurs during visiting.
     */
    public void visit(ResourceVisitor visitor) throws PublicationException {
        Resource[] resources = getResources();
        for (int i = 0; i < resources.length; i++) {
            resources[i].accept(visitor);
        }
    }
    

}
