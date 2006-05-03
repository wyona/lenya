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

import junit.framework.Test;
import junit.framework.TestSuite;

import org.apache.lenya.htmlunit.LenyaTestCase;

public class PublishTest extends LenyaTestCase {

    /*
     * (non-Javadoc)
     * 
     * @see junit.framework.TestCase#setUp()
     */
    protected void setUp() throws Exception {
        this.testName = "Publish Test";
        super.setUp();
    }

    /**
     * Attempts to create a document, submit it, and publish it.
     * 
     * @throws Exception
     */
    public void testPublish() throws Exception {
        String newNodeID = createTestNodeID();
        String startDocID = this.config.getString("lenya.tests.general.startDocID");

        // submit and publish startDocID so that there is no problem to publish
        // childrens of it
        loginAsDefaultUser();
        submit(startDocID);
        logout();
        loginAsReviewer();
        publish(startDocID);
        logout();

        // login, create document, and submit it
        loginAsDefaultUser();
        createNewDocument(startDocID, newNodeID, "htmlunit test document", "xhtml");
        submit(startDocID + "/" + newNodeID);
        logout();

        // login as alice and publish the document
        loginAsReviewer();
        publish(startDocID + "/" + newNodeID);
        logout();

        // verify if the live page exists
        loadHtmlPage(this.pubid + "/" + LIVE_AREA + startDocID + "/"
                + newNodeID + ".html");
        assertPageContainsText(this.config.getString("lenya.tests.general.samplePageContent"));
    }

    public static Test suite() {
        return new TestSuite(PublishTest.class);
    }
}
