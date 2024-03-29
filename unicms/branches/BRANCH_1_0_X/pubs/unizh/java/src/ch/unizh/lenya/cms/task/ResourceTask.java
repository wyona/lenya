/*
 * <License>
 * The Apache Software License
 *
 * Copyright (c) 2002 lenya. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice, this
 *    list of conditions and the following disclaimer in the documentation and/or
 *    other materials provided with the distribution.
 *
 * 3. All advertising materials mentioning features or use of this software must
 *    display the following acknowledgment: "This product includes software developed
 *    by lenya (http://www.lenya.org)"
 *
 * 4. The name "lenya" must not be used to endorse or promote products derived from
 *    this software without prior written permission. For written permission, please
 *    contact contact@lenya.org
 *
 * 5. Products derived from this software may not be called "lenya" nor may "lenya"
 *    appear in their names without prior written permission of lenya.
 *
 * 6. Redistributions of any form whatsoever must retain the following acknowledgment:
 *    "This product includes software developed by lenya (http://www.lenya.org)"
 *
 * THIS SOFTWARE IS PROVIDED BY lenya "AS IS" WITHOUT ANY WARRANTY EXPRESS OR IMPLIED,
 * INCLUDING THE WARRANTY OF NON-INFRINGEMENT AND THE IMPLIED WARRANTIES OF MERCHANTI-
 * BILITY AND FITNESS FOR A PARTICULAR PURPOSE. lenya WILL NOT BE LIABLE FOR ANY DAMAGES
 * SUFFERED BY YOU AS A RESULT OF USING THIS SOFTWARE. IN NO EVENT WILL lenya BE LIABLE
 * FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR LOST PROFITS EVEN IF lenya HAS
 * BEEN ADVISED OF THE POSSIBILITY OF THEIR OCCURRENCE. lenya WILL NOT BE LIABLE FOR ANY
 * THIRD PARTY CLAIMS AGAINST YOU.
 *
 * Lenya includes software developed by the Apache Software Foundation, W3C,
 * DOM4J Project, BitfluxEditor and Xopus.
 * </License>
 */
package ch.unizh.lenya.cms.task;

import org.apache.avalon.framework.parameters.ParameterException;
import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.Resource;
import org.apache.lenya.cms.publication.ResourceIdentityMap;
import org.apache.lenya.cms.publication.Version;
import org.apache.lenya.cms.publication.task.PublicationTask;
import org.apache.lenya.cms.publication.util.AreaFilter;
import org.apache.lenya.cms.publication.util.ComposedFilter;
import org.apache.lenya.cms.publication.util.LanguageFilter;
import org.apache.lenya.cms.task.ExecutionException;

/**
 * Task to be executed on a resource.
 * 
 * @author <a href="mailto:andreas@apache.org">Andreas Hartmann</a>
 */
public abstract class ResourceTask extends PublicationTask {

    private ResourceIdentityMap identityMap;

    /**
     * Returns the identity map.
     * @return A resource identity map.
     * @throws ExecutionException when something went wrong.
     */
    protected ResourceIdentityMap getIdentityMap() throws ExecutionException {
        if (identityMap == null) {
            identityMap = new ResourceIdentityMap(getPublication());
        }
        return identityMap;
    }

    public static final String PARAMETER_RESOURCE_ID = "document-id";
    private Resource resource;

    /**
     * Returns the resource to apply this task on.
     * @return A document.
     * @throws ParameterException when something went wrong.
     * @throws DocumentBuildException when something went wrong.
     * @throws ExecutionException when something went wrong.
     */
    protected Resource getResource()
        throws ParameterException, PublicationException, ExecutionException {
        if (resource == null) {
            String id = getParameters().getParameter(PARAMETER_RESOURCE_ID);
            resource = getIdentityMap().get(id);
        }
        return resource;
    }

    /**
     * Returns the version of a resource in a specific area and language.
     * @param resource The resource.
     * @param area The area.
     * @param language The language.
     * @return A version.
     * @throws ParameterException if an error occurs.
     * @throws ExecutionException if an error occurs.
     * @throws PublicationException if an error occurs.
     */
    protected Version getVersion(Resource resource, String area, String language)
        throws ParameterException, ExecutionException, PublicationException {
        ComposedFilter filter = new ComposedFilter();
        filter.add(new AreaFilter(area));
        filter.add(new LanguageFilter(language));
        return resource.getVersions(filter)[0];
    }

}
