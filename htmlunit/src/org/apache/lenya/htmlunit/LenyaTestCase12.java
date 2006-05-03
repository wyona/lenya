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
package org.apache.lenya.htmlunit;


import com.gargoylesoftware.htmlunit.FailingHttpStatusCodeException;
import com.gargoylesoftware.htmlunit.html.HtmlForm;
import com.gargoylesoftware.htmlunit.html.HtmlPasswordInput;
import com.gargoylesoftware.htmlunit.html.HtmlSubmitInput;
import com.gargoylesoftware.htmlunit.html.HtmlTextInput;

/**
 * Abstract testcase for testing Lenya 1.2.x publications.
 */
public abstract class LenyaTestCase12 extends LenyaTestCase {

    public static final String INFO_AUTHORING_AREA = "info-authoring";
    public static final String TRASH_AREA = "info-trash";
    public static final String ARCHIVE_AREA = "info-archive";    

    /**
     * Login to the authoring area of the publication as the specified user.
     * 
     * @param username
     * @param password
     * @throws Exception
     */
    protected void login(String username, String password) throws Exception {

        assertNotNull(
                "Publication-id must be specified in the configuration file.",
                this.pubid);

        String pubname = this.config.getString("lenya.pubname");

        this.logger.info("Login to " + this.pubid + " publication (" + pubname
                + ") as user " + username + ".");

        // Get the login page
        loadHtmlPage(this.pubid + "/" + AUTHORING_AREA + "/");
        assertTitleContains(this.config.getString("lenya.tests.general.loginPageTitle"));

        // Get the form that we are dealing with and within that form,
        // find the submit button and the field that we want to change.
        final HtmlForm form = (HtmlForm) currentPage.getForms().get(0);

        // TODO name the form, then
        // final HtmlForm form = currentPage.getFormByName("login");

        final HtmlTextInput inputUsername = (HtmlTextInput) form
                .getInputByName("username");
        final HtmlPasswordInput inputPassword = (HtmlPasswordInput) form
                .getInputByName("password");

        // Change the value of the text field
        inputUsername.setValueAttribute(username);
        inputPassword.setValueAttribute(password);

        // Now submit the form by clicking the button
        clickButton("submit");

    }

    /**
     * Logout from authoring.
     */
    protected void logout() throws Exception {
        this.logger.info("Logout from " + this.pubid + ".");

        loadHtmlPage(this.pubid + "/" + AUTHORING_AREA + "/?&lenya.usecase=logout");
        assertTitleContains(this.config.getString("lenya.tests.general.logoutPageTitle"));

        loadHtmlPage(this.pubid + "/" + AUTHORING_AREA + "/");
    }

    /**
     * Creates a document as a child of the given parent document.
     * 
     * @param parentDocID
     * @param newNodeID
     * @param title
     * @param doctype
     * @throws Exception
     */
    public void createNewDocument(String parentDocID, String newNodeID,
            String title, String doctype) throws Exception {
    	
/*    	if(parentDocID == "/index"){
    		throw new Exception("The startDocID should not be /index, because Lenya 1.2 can not create children of /index");
    	}*/

        this.logger.info("Creating document " + parentDocID + "/" + newNodeID
                + " with title \"" + title + "\" and doctype " + doctype + ".");

        String prefix = this.pubid + "/" + AUTHORING_AREA + parentDocID;
        
        // check if the parent exists
        PageExistsOrCreate(parentDocID, "htmlunit Tests", "xhtml");

        // check if the newExists document does not exist yet:
        assertPageDoesNotExist(parentDocID + "/" + newNodeID, AUTHORING_AREA);
        // attempt to create the new document:
        loadHtmlPage(prefix + ".html?doctype=" + doctype
                + "&lenya.usecase=create&lenya.step=showscreen");
        assertTitleContains(this.config.getString("lenya.tests.site.create.pageTitle"));

        // fill out the form, it has no name :(
        HtmlForm form = (HtmlForm) this.currentPage.getForms().get(0); 

        HtmlTextInput inputDocId = (HtmlTextInput) form
                .getInputByName("properties.create.child-id");
        inputDocId.setValueAttribute(newNodeID);

        HtmlTextInput inputTitle = (HtmlTextInput) form.getInputByName("properties.create.child-name");
        inputTitle.setValueAttribute(title);

        // Now submit the form by clicking the button
        HtmlSubmitInput button = (HtmlSubmitInput) form
        .getInputByValue("Create");
        click(button);

        assertTitleContains(this.config.getString("lenya.tests.general.authoringPageTitle"));
    }
    
    /**
     * Checks that the page nodeID exists in the Authoring-Area, if not create it.
     * @param NodeID
     * @param title
     * @param doctype
     * @throws Exception
     */
    protected void PageExistsOrCreate(String NodeID,
            String title, String doctype) throws Exception {
    	String page = new String (this.pubid + "/" + AUTHORING_AREA + NodeID +".html");
    	try {
    		loadHtmlPage(page);
    		return;
    	}catch (FailingHttpStatusCodeException e){
    		this.logger.info(page+" does not exist, it will be created");
    		
    		String NodeIDpure = NodeID.replaceFirst("/","");
    		createNewDocument("/index", NodeIDpure, title, doctype);
    	    return;
        }
    }
}