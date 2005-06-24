/*
 * Copyright  1999-2004 The Apache Software Foundation
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

package org.apache.lenya.pubs.wiki;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Map;

import org.apache.lenya.cms.authoring.DefaultCreator;
import org.apache.lenya.xml.DocumentHelper;
import org.apache.log4j.Category;

import org.w3c.dom.Document;

import org.wyona.yarep.core.Path;
import org.wyona.yarep.core.Repository;
import org.wyona.yarep.core.RepositoryFactory;

public class NewWikiDocCreator extends DefaultCreator {
    Category log = Category.getInstance(NewWikiDocCreator.class);

    /**
     * Return the child type.
     *
     * @param childType a <code>short</code> value
     *
     * @return a <code>short</code> value
     *
     * @exception Exception if an error occurs
     */
    public short getChildType(short childType) throws Exception {
        return BRANCH_NODE;
    }

    /** (non-Javadoc)
     * @see org.apache.lenya.cms.authoring.DefaultCreator#getChildFileName(java.io.File, java.lang.String)
     */
    protected String getChildFileName(
        File parentDir,
        String childId,
        String language) {

        log.info("Parent directory: " + parentDir);

        // TODO: Quite a hack, but needs to be replaced by JCR anyway
        File file = new File(parentDir.getParentFile().getParent()
            + File.separator + "repository" + File.separator + "paths" + File.separator + "authoring"
            + File.separator
            + childId
            + File.separator
            + "index"
            + getLanguageSuffix(language)
            + ".xml"
	    + File.separator + "resource-content"
            );

        log.info("Filename: " + file.getAbsolutePath());

        return file.getAbsolutePath();
    }

    /**
      * DOCUMENT ME!
      *
      * @param samplesDir DOCUMENT ME!
      * @param parentDir DOCUMENT ME!
      * @param childId DOCUMENT ME!
      * @param childType DOCUMENT ME!
      * @param childName the name of the child
      * @param language for which the document is created
      * @param parameters additional parameters that can be considered when 
      *  creating the child
      *
      * @throws Exception DOCUMENT ME!
      */
    public void create(
        File samplesDir,
        File parentDir,
        String childId,
        short childType,
        String childName,
        String language,
        Map parameters)
        throws Exception {
        // Set filenames
        String id = generateTreeId(childId, childType);
        String filenameMeta = getChildMetaFileName(parentDir, id, language);

        String doctypeSample = samplesDir + File.separator + getSampleResourceName();
        //String doctypeMeta = samplesDir + File.separator + sampleMetaName;

        File sampleFile = new File(doctypeSample);
        if (!sampleFile.exists()) {
            log.error("No such sample file: " + sampleFile + " Have you configured the sample within doctypes.xconf?");
            throw new FileNotFoundException("" + sampleFile);
        }

        // Read sample file
        log.debug("Read sample file: " + doctypeSample);

        Document doc = DocumentHelper.readDocument(new File(doctypeSample));

        log.debug("sample document: " + doc);

        // transform the xml if needed
        log.debug("transform sample file: ");
        transformXML(doc, id, childType, childName, parameters);

        // write the document (create the path, i.e. the parent
        // directory first if needed)
	log.error(parentDir.toString());
	log.error(id);
	log.error(language);
        String filename = getChildFileName(parentDir, id, language);
        log.error(filename);
        File parent = new File(new File(filename).getParent());

        if (!parent.exists()) {
            parent.mkdirs();
        }

        // Write file
        log.debug("write file: " + filename);
        DocumentHelper.writeDocument(doc, new File(filename));

	Repository repo = new RepositoryFactory().newRepository("wiki");
        DocumentHelper.writeDocument(doc, repo.getWriter(new Path("/" + id + "_" + language + ".xml")));

        // now do the same thing for the meta document if the
        // sampleMetaName is specified
/*
        if (sampleMetaName != null) {
            doc = DocumentHelper.readDocument(new File(doctypeMeta));

            transformMetaXML(doc, id, childType, childName, parameters);

            parent = new File(new File(filenameMeta).getParent());

            if (!parent.exists()) {
                parent.mkdirs();
            }

            DocumentHelper.writeDocument(doc, new File(filenameMeta));
        }
*/
    }
}
