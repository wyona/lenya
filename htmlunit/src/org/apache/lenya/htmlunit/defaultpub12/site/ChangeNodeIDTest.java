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

import com.gargoylesoftware.htmlunit.html.HtmlForm;
import com.gargoylesoftware.htmlunit.html.HtmlTextInput;

import junit.framework.Test;
import junit.framework.TestSuite;

public class ChangeNodeIDTest extends LenyaTestCase12 {

    /*
     * (non-Javadoc)
     * 
     * @see junit.framework.TestCase#setUp()
     */
    protected void setUp() throws Exception {
        this.testName = "Change Node ID of a Document";
        super.setUp();
    }

    /**
     * Attempts to create a document and then change it's id.
     * 
     * @throws Exception
     */
    public void testChangeNodeID() throws Exception {
        loginAsDefaultUser();
        String nodeID = createTestNodeID(); 
        String newNodeID = nodeID+"new"; 
        String startDocID = this.config.getString("lenya.tests.general.startDocID");
        createNewDocument(startDocID, nodeID,
                "changeNodeID test document", "xhtml");
        changeNodeID(startDocID + "/" + nodeID, newNodeID);
        
        // verify
        loadHtmlPage(this.pubid + "/" + AUTHORING_AREA + startDocID + "/" + newNodeID + ".html");
        assertTitleContains(this.config.getString("lenya.tests.general.authoringPageTitle"));
        
        logout();
    }

    /**
     * Calls the changeNodeID usecase.
     * 
     * @throws Exception
     */
    public void changeNodeID(String docID, String newNodeID) throws Exception {
        this.logger.info("Changing the node id  of " + docID + " to " + newNodeID + ".");
        
        // call the usecase
        loadHtmlPage(this.pubid + "/" + INFO_AUTHORING_AREA + docID
                + ".html?&lenya.usecase=rename&lenya.step=showscreen");
        assertTitleContains(this.config.getString("lenya.tests.site.changeNodeID.pageTitle"));
        
        // fill out the form
        HtmlForm form = (HtmlForm) this.currentPage.getForms().get(0);
        
        HtmlTextInput inputNodeID = (HtmlTextInput) form.getInputByName("properties.node.secdocumentid");
        inputNodeID.setValueAttribute(newNodeID);
        
        clickButton("Rename");
        
        assertTitleContains(this.config.getString("lenya.tests.general.infoPageTitle"));
    }

    public static Test suite() {
        return new TestSuite(ChangeNodeIDTest.class);
    }

}
