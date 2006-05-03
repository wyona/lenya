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

public class RejectTest extends LenyaTestCase {

    /*
     * (non-Javadoc)
     * 
     * @see junit.framework.TestCase#setUp()
     */
    protected void setUp() throws Exception {
        this.testName = "Reject Test";
        super.setUp();
    }

    /**
     * Attempts to create a document, submit it, and reject it.
     * 
     * @throws Exception
     */
    public void testReject() throws Exception {
        String newNodeID = createTestNodeID();
        String startDocID = this.config
                .getString("lenya.tests.general.startDocID");

        // login, create document, and submit it
        loginAsDefaultUser();
        createNewDocument(startDocID, newNodeID, "htmlunit test document",
                "xhtml");
        submit(startDocID + "/" + newNodeID);
        logout();
        
        // reject document
        loginAsReviewer();
        reject(startDocID + "/" + newNodeID);
        logout();
        
        // check that document is not in LIVE Area
        assertPageDoesNotExist(startDocID + "/" + newNodeID, LIVE_AREA);
        
    }

    /**
     * Reject
     * 
     * @param docID
     * @throws Exception
     */
    private void reject(String docID) throws Exception {
        this.logger.info("Deactivating " + docID + ".");

        String url = this.pubid + "/" + AUTHORING_AREA + docID + ".html";

        // call the deactivate usecase
        loadHtmlPage(url + "?lenya.usecase=workflow.reject");
        assertTitleContains(this.config
                .getString("lenya.tests.workflow.reject.pageTitle"));

        // Now submit the form by clicking the button
        clickButton("submit");

        assertTitleContains(this.config
                .getString("lenya.tests.general.authoringPageTitle"));

    }

    public static Test suite() {
        return new TestSuite(RejectTest.class);
    }
}
