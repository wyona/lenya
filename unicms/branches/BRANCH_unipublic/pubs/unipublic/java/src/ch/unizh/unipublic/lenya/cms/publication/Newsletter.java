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
package ch.unizh.unipublic.lenya.cms.publication;

import org.apache.lenya.cms.publication.ResourceIdentityMap;
import org.apache.lenya.cms.publication.impl.ResourceImpl;
import org.apache.log4j.Category;


/**
 * A Newsletter resource.
 * 
 * @author <a href="edith@apache.org">Edith Chevrier</a>
 * 
 */
public class Newsletter extends ResourceImpl {

    private static final Category log = Category.getInstance(Newsletter.class);

    public static final String NEWSLETTER_ID= "/newsletter";

    /**
     * Ctor.
     * @param resourceId The resource ID.
     * @param identityMap The identity map that stores this resource.
     */
    public Newsletter(ResourceIdentityMap identityMap, String resourceId) {
        super(identityMap, resourceId);
    }

    /**
     * Checks if a document ID represents a Newsletter.
     * @param documentId The document ID.
     * @return A boolean value.
     */
    public static boolean isNewsletterDocument(String documentId){
        boolean isNewsletter =false;
        if (documentId.equals(NEWSLETTER_ID)) {
            isNewsletter=true;      
        }
        return isNewsletter;
      }
}