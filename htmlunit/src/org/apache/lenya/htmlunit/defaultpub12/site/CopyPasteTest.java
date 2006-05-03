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

public class CopyPasteTest extends LenyaTestCase12 {

    /*
     * (non-Javadoc)
     * 
     * @see junit.framework.TestCase#setUp()
     */
    protected void setUp() throws Exception {
        this.testName = "Cut, Copy, and Paste Documents";
        super.setUp();
    }

    /**
     * Attempts to create two documents and to perform some cut, copy, 
     * and paste operations with them.
     * 
     * @throws Exception
     */
    public void testCopyPaste() throws Exception {
        loginAsDefaultUser();
        String startDocID = this.config.getString("lenya.tests.general.startDocID");
        
        // create two documents
        String nodeID1 = createTestNodeID(); 
        createNewDocument(startDocID, nodeID1,
                "copy test document 1", "xhtml");
        
        String nodeID2 = createTestNodeID(); 
        createNewDocument(startDocID, nodeID2,
                "copy test document 2", "xhtml");
        
        // copy the first document and insert it as the child of the other
        copypaste(startDocID + "/" + nodeID1, startDocID + "/" + nodeID2);
        
        // now cut the second document and insert it as the child of the first one
        cutpaste(startDocID + "/" + nodeID2, startDocID + "/" + nodeID1);
        
        // verify
        loadHtmlPage(this.pubid + "/" + AUTHORING_AREA + startDocID + "/" + nodeID1 
                + "/" + nodeID2 + "/" + nodeID1 + ".html");
        
        assertTitleContains(this.config.getString("lenya.tests.general.authoringPageTitle"));
        
        logout();
    }
    public void copypaste(String docID, String newParentID) throws Exception {
        this.logger.info("Copying " + docID + " and pasting it at " + newParentID + ".");
        executeSimpleUsecase(docID, "copy", "Copy");
        executeSimpleUsecase(newParentID, "paste", "Paste");
    }

    public void cutpaste(String docID, String newParentID) throws Exception {
        this.logger.info("Cutting " + docID + " and pasting it at " + newParentID + ".");
        executeSimpleUsecase(docID, "cut", "Cut");
        executeSimpleUsecase(newParentID, "paste", "Paste");
    }

    public void executeSimpleUsecase(String docID, String usecase, String buttonname) throws Exception {
        // call the usecase on the given document
        loadHtmlPage(this.pubid + "/" + INFO_AUTHORING_AREA + docID + ".html?lenya.usecase="+usecase+"&lenya.step=showscreen");
        assertTitleContains(this.config.getString("lenya.tests.site."+usecase+".pageTitle"));

        clickButton(buttonname);
        assertTitleContains(this.config.getString("lenya.tests.general.infoPageTitle"));
    }
    
    public static Test suite() {
        return new TestSuite(CopyPasteTest.class);
    }

}
