/*
 * Copyright 2005 The Apache Software Foundation Licensed under the Apache
 * License, Version 2.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * 
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.lenya.htmlunit.defaultpub12.site;

import org.apache.lenya.htmlunit.LenyaTestCase12;
import junit.framework.Test;
import junit.framework.TestSuite;

public class DeleteArchiveRestoreTest extends LenyaTestCase12 {

    /*
     * (non-Javadoc)
     * 
     * @see junit.framework.TestCase#setUp()
     */
    protected void setUp() throws Exception {
        this.testName = "Delete / Archive / Restore a Document";
        super.setUp();
    }

    /**
     * Attempts to create a tree of documents, delete it, restore it,
     * archive it, and restore it again.
     * 
     * @throws Exception
     */
    public void testDeleteArchiveRestore() throws Exception {
        loginAsDefaultUser();
        String startDocID = this.config.getString("lenya.tests.general.startDocID");
        
        // create a tree with two documents
        String nodeID1 = createTestNodeID(); 
        createNewDocument(startDocID, nodeID1,
                "deleteArchiveRestore test document 1", "xhtml");
        String nodeID2 = createTestNodeID(); 
        createNewDocument(startDocID + "/" + nodeID1, nodeID2,
                "deleteArchiveRestore test document 2", "xhtml");
        
        String docID = startDocID + "/" + nodeID1; 
        
        // test delete
        delete(docID);
        restore(docID, TRASH_AREA);
        assertPageExists(docID, AUTHORING_AREA);
                
        // test archive
        archive(docID);
        restore(docID, ARCHIVE_AREA);
        assertPageExists(docID, AUTHORING_AREA);
        assertPageExists(docID + "/" + nodeID2, AUTHORING_AREA);
                
        logout();
    }

    /**
     * Deletes the given document (it will be moved to the trash area).
     * @param docID
     * @throws Exception
     */
    public void delete(String docID) throws Exception {
        this.logger.info("Deleting " + docID + ".");
        
        
        // call the usecase
        loadHtmlPage(this.pubid + "/" + INFO_AUTHORING_AREA + docID + ".html?&lenya.event=delete&lenya.usecase=delete&lenya.step=showscreen");
        assertTitleContains(this.config.getString("lenya.tests.site.delete.pageTitle"));

        // Now submit the form by clicking the button
        clickButton("Delete");
       
        assertTitleContains(this.config.getString("lenya.tests.general.infoPageTitle"));
    }

    /**
     * Archives the given document (it will be moved to the trash area).
     * @param docID
     * @throws Exception
     */
    protected void archive(String docID) throws Exception {
        this.logger.info("Archiving " + docID + ".");
        
        // call the usecase
        loadHtmlPage(this.pubid + "/" + INFO_AUTHORING_AREA + docID + ".html?&lenya.event=archive&lenya.usecase=archive&lenya.step=showscreen");
        assertTitleContains(this.config.getString("lenya.tests.site.archive.pageTitle"));

        // Now submit the form by clicking the button
        clickButton("Archive");
       
        assertTitleContains(this.config.getString("lenya.tests.general.infoPageTitle"));
    }

    /**
     * Restores the given document from the trash area.
     * @param docID
     * @throws Exception
     */
    protected void restore(String docID, String area) throws Exception {
        this.logger.info("Restoring " + docID + " from " + area + ".");
        
        //in trash or archive is the docid without startDocID
        docID = docID.replaceFirst(this.config.getString("lenya.tests.general.startDocID"), "");

        // call the usecase
        loadHtmlPage(this.pubid + "/" + area + docID + ".html?&lenya.event=restore&lenya.usecase=restore&lenya.step=showscreen");
        assertTitleContains(this.config.getString("lenya.tests.site.restore.pageTitle"));

        // Now submit the form by clicking the button
        clickButton("Restore");
       
        assertTitleContains(this.config.getString("lenya.tests.general.infoPageTitle"));
    }

    public static Test suite() {
        return new TestSuite(DeleteArchiveRestoreTest.class);
    }

}
