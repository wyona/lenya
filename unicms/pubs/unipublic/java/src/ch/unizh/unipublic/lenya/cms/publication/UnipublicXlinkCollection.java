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

import java.io.File;
import java.util.ArrayList;


import org.apache.lenya.cms.publication.DocumentException;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.XlinkCollection;
import org.apache.log4j.Category;

/**
 * An xlinkCollection, which document doesn't have a node in the sitetree 
 * @author <a href="mailto:edith@apache.org">Edith Chevrier </a>
 */
public class UnipublicXlinkCollection extends XlinkCollection{

    private static final Category log = Category.getInstance(UnipublicXlinkCollection.class);

    /**
     * Ctor.
     * @param publication A publication.
     * @param id The document ID.
     * @param area The area the document belongs to.
     * @throws DocumentException when something went wrong.
     */
    public UnipublicXlinkCollection(Publication publication, String id, String area)
            throws DocumentException {
        super(publication, id, area);
    }

    /**
     * Ctor.
     * @param publication A publication.
     * @param id The document ID.
     * @param area The area the document belongs to.
     * @param language The language of the document.
     * @throws DocumentException when something went wrong.
     */
    public UnipublicXlinkCollection(Publication publication, String id, String area, String language)
            throws DocumentException {
        super(publication, id, area, language);
    }

    /**
     * @see org.apache.lenya.cms.publication.Document#getLanguage()
     */
    public String[] getLanguages() throws DocumentException {
        ArrayList languages = new ArrayList();
        String[] pubLanguages = getPublication().getLanguages();

        for (int i=0; i<pubLanguages.length; i++){
            File langFile = getPublication().getPathMapper().getFile(getPublication(), getArea(), getId(), pubLanguages[i]);
            if (langFile.exists()) {
                languages.add(pubLanguages[i]);   
            }
        }    
        return (String[]) languages.toArray(new String[languages.size()]);
    }
    
    /**
     * @see org.apache.lenya.cms.publication.Document#getLabel()
     */
    public String getLabel() throws DocumentException {
        return null;
    }

    /** (non-Javadoc)
     * @see org.apache.lenya.cms.publication.Document#exists()
     */
    public boolean exists() throws DocumentException {
        return getFile().exists();
    }

    /** (non-Javadoc)
     * @see org.apache.lenya.cms.publication.Document#existsInAnyLanguage()
     */
    public boolean existsInAnyLanguage() throws DocumentException {
        boolean exists = false;
        String[] languages = getLanguages();  
        if (languages!=null && languages.length>0){
            exists = true;
        }
        return exists;
    }

}