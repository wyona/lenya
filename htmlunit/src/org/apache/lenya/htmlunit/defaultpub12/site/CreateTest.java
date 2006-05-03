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

public class CreateTest extends LenyaTestCase12 {

    /*
     * (non-Javadoc)
     * 
     * @see junit.framework.TestCase#setUp()
     */
    protected void setUp() throws Exception {
        this.testName = "Create Documents";
        super.setUp();
    }

    /**
     * Attempts to create an XHTML document.
     * 
     * @throws Exception
     */
    public void testCreateXhtmlDocument() throws Exception {
        loginAsDefaultUser();
        String nodeID = createTestNodeID(); 
        String startDocID = this.config.getString("lenya.tests.general.startDocID");
        createNewDocument(startDocID, nodeID,
                "create xhtml document", "xhtml"); // TODO: add special chars to label
        logout();
    }

    /**
     * Attempts to create a links document.
     * 
     * @throws Exception
     */
    public void testCreateLinksDocument() throws Exception {
        loginAsDefaultUser();
        String nodeID = createTestNodeID(); 
        String startDocID = this.config.getString("lenya.tests.general.startDocID");
        createNewDocument(startDocID, nodeID,
                "create link document", "links");
        logout();
    }

    public static Test suite() {
        return new TestSuite(CreateTest.class);
    }

}
