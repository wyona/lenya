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
package org.apache.lenya.htmlunit.defaultpub.workflow;

import org.apache.lenya.htmlunit.LenyaTestCase;

import junit.framework.Test;
import junit.framework.TestSuite;

public class DeactivateTest extends LenyaTestCase {

    /*
     * (non-Javadoc)
     * 
     * @see junit.framework.TestCase#setUp()
     */
    protected void setUp() throws Exception {
        this.testName = "Deactivate Test";
        super.setUp();
    }

    /**
     * Attempts to create a document, submit it, and publish it.
     * 
     * @throws Exception
     */
    public void testDeactivate() throws Exception {
        String newNodeID = createTestNodeID();
        String startDocID = this.config
                .getString("lenya.tests.general.startDocID");

        // login, create document, and submit it
        loginAsDefaultUser();
        createNewDocument(startDocID, newNodeID, "htmlunit test document",
                "xhtml");
        submit(startDocID + "/" + newNodeID);
        logout();
        
        
        // finally publish it with reviewer
        loginAsReviewer();
        publish(startDocID + "/" + newNodeID);
        logout();
        
        
        // verify if the live page exists
        loadHtmlPage(this.pubid + "/" + LIVE_AREA + startDocID + "/"
                + newNodeID + ".html");
        assertPageContainsText(this.config
                .getString("lenya.tests.general.samplePageContent"));
        
        // deactivate document
        loginAsReviewer();
        deactivate(startDocID + "/" + newNodeID);
        logout();
        
        // check that document is not in LIVE Area
        assertPageDoesNotExist(startDocID + "/" + newNodeID, LIVE_AREA);
        
    }

    /**
     * Deactivate
     * 
     * @param docID
     * @throws Exception
     */
    private void deactivate(String docID) throws Exception {
        this.logger.info("Deactivating " + docID + ".");

        String url = this.pubid + "/" + AUTHORING_AREA + docID + ".html";

        // call the deactivate usecase
        loadHtmlPage(url + "?lenya.usecase=workflow.deactivate");
        assertTitleContains(this.config
                .getString("lenya.tests.workflow.deactivate.pageTitle"));

        // Now submit the form by clicking the button
        clickButton("submit");

        assertTitleContains(this.config
                .getString("lenya.tests.general.authoringPageTitle"));

    }

    public static Test suite() {
        return new TestSuite(DeactivateTest.class);
    }
}
