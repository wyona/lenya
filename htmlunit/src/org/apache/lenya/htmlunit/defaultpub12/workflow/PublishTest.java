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
package org.apache.lenya.htmlunit.defaultpub12.workflow;

import org.apache.lenya.htmlunit.LenyaTestCase12;

import java.util.regex.Pattern;
import junit.framework.Test;
import junit.framework.TestSuite;

public class PublishTest extends LenyaTestCase12 {

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

        //submit and publish startDocID so that there is no problem to publish childrens of it
        loginAsDefaultUser();
        submit(startDocID);
        logout();
        login(this.config.getString("lenya.reviewerUsername"), this.config.getString("lenya.reviewerPassword"));
        publish(startDocID);
        logout();        
        
        // login, create document, and submit it
        loginAsDefaultUser();
        createNewDocument(startDocID, newNodeID,
                "Publish test document", "xhtml");
        submit(startDocID + "/" + newNodeID);
        logout();
        
        // login as alice and publish the document
        login(this.config.getString("lenya.reviewerUsername"), this.config.getString("lenya.reviewerPassword"));
        publish(startDocID + "/" + newNodeID);
        logout();
        
        // verify if the live page exists
        loadHtmlPage(this.pubid + "/" + LIVE_AREA + startDocID + "/" + newNodeID + ".html");
        assertPageContainsText(this.config.getString("lenya.tests.general.samplePageContent"));
    }
    
    /**
     * Submit
     * @param docID
     * @throws Exception
     */
    public void submit(String docID) throws Exception {

        this.logger.info("Submitting " + docID + ".");

        String url = this.pubid + "/" + AUTHORING_AREA + docID + ".html";
        
        // call the submit usecase
        loadHtmlPage(url + "?&lenya.event=submit&lenya.usecase=submit&lenya.step=showscreen");
        
        if(findInPage("Submit")){
        	clickButton("submit");
        	assertTitleContains(this.config.getString("lenya.tests.general.authoringPageTitle"));
        }
        else{
        	//in case it is already submited it shows the loginscreen
        	assertTitleContains(this.config.getString("lenya.tests.general.loginPageTitle"));
        	this.logger.info("Can not submit: " + docID + " seems to be already submited.");
        }

    }

    /**
     * Publish
     * @param docID
     * @throws Exception
     */
    public void publish(String docID) throws Exception {

        this.logger.info("Publishing " + docID + ".");

        String url = this.pubid + "/" + AUTHORING_AREA + docID + ".html";
        
        Pattern patter = Pattern.compile("http://[-.a-zA-Z0-9]+([:][0-9]{0,4})?");
        String contextprefix = patter.matcher(baseURL).replaceFirst("");
        
        // call the publish usecase
        String docIDpure = docID.replaceFirst("/","");
        loadHtmlPage(url + "?uris="+contextprefix+this.pubid+"/"+LIVE_AREA+docID+".html&sources="+docIDpure+"/index_"+this.config.getString("lenya.tests.site.createLanguage")+".xml&task-id=publish&lenya.event=publish&lenya.usecase=publish&lenya.step=showscreen");

        if(findInPage("Publish")){
        	assertTitleContains(this.config.getString("lenya.tests.workflow.publish.pageTitle"));
        	
        	// Now submit the form by clicking the button
        	clickButton("Publish");
        	
        	assertTitleContains(this.config.getString("lenya.tests.general.authoringPageTitle"));
        }
        else{
        	//in case it is already published it shows the loginscreen
          	assertTitleContains(this.config.getString("lenya.tests.general.loginPageTitle"));
           	this.logger.info("Can not publish: " + docID + " seems to be already published.");
        }        	
    }
    
    public static Test suite() {
        return new TestSuite(PublishTest.class);
    }
}
