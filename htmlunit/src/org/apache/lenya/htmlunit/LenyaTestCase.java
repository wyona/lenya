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

import java.util.regex.Pattern;

import com.gargoylesoftware.htmlunit.FailingHttpStatusCodeException;
import com.gargoylesoftware.htmlunit.html.HtmlCheckBoxInput;
import com.gargoylesoftware.htmlunit.html.HtmlForm;
import com.gargoylesoftware.htmlunit.html.HtmlPasswordInput;
import com.gargoylesoftware.htmlunit.html.HtmlSubmitInput;
import com.gargoylesoftware.htmlunit.html.HtmlTextInput;
import com.gargoylesoftware.htmlunit.html.HtmlRadioButtonInput;;

/**
 * Abstract testcase for testing Lenya publications.
 */
public abstract class LenyaTestCase extends HtmlUnitTestCase {

    public static final String AUTHORING_AREA = "authoring";
    public static final String LIVE_AREA = "live";
    public static final String TRASH_AREA = "trash";
    public static final String ARCHIVE_AREA = "archive";
    public static final String ADMIN_AREA = "admin";
    
    /**
     * Publication id which should be defined in the property file.
     */
    protected String pubid;

    protected void setUp() throws Exception {
        super.setUp();
        this.pubid = this.config.getString("lenya.pubid");
    }

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
     * Login as the default user, using the username and password of
     * properties.xml.
     */
    protected void loginAsDefaultUser() throws Exception {
        String username = this.config.getString("lenya.defaultUsername");
        String password = this.config.getString("lenya.defaultPassword");

        login(username, password);
    }
    
    /**
     * Login as the reviewer user using the username and password of
     * properties.xml.
     */
    protected void loginAsReviewer() throws Exception {
        String username = this.config.getString("lenya.reviewerUsername");
        String password = this.config.getString("lenya.reviewerPassword");
        
        login(username, password);
    }

    /**
     * Logout from authoring.
     */
    protected void logout() throws Exception {
        this.logger.info("Logout from " + this.pubid + ".");

        loadHtmlPage(this.pubid + "/" + AUTHORING_AREA + "/?lenya.usecase=ac.logout");
        assertTitleContains(this.config.getString("lenya.tests.general.logoutPageTitle"));

        final HtmlForm form = (HtmlForm) currentPage.getForms().get(0);
        final HtmlSubmitInput button = (HtmlSubmitInput) form
                .getInputByName("submit");
        click(button);
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

        this.logger.info("Creating document " + parentDocID + "/" + newNodeID
                + " with title \"" + title + "\" and doctype " + doctype + ".");

        String prefix = this.pubid + "/" + AUTHORING_AREA + parentDocID;
        
        // check if the parent exists
        //loadHtmlPage(prefix + ".html");
        //assertTitleContains(this.config.getString("lenya.tests.general.authoringPageTitle"));
        parentExistsOrCreate(parentDocID, "htmlunit Tests", "xhtml");        

        // check if the newExists document does not exist yet:
        assertPageDoesNotExist(parentDocID + "/" + newNodeID, AUTHORING_AREA);

        // attempt to create the new document:
        loadHtmlPage(prefix + ".html?doctype=" + doctype
                + "&lenya.usecase=sitemanagement.create");
        assertTitleContains(this.config.getString("lenya.tests.sitemanagement.create.pageTitle"));

        // fill out the form, it has no name :(
        HtmlForm form = (HtmlForm) this.currentPage.getForms().get(0); 

        HtmlTextInput inputDocId = (HtmlTextInput) form
                .getInputByName("nodeName");
        inputDocId.setValueAttribute(newNodeID);

        HtmlTextInput inputTitle = (HtmlTextInput) form.getInputByName("dublincore.title");
        inputTitle.setValueAttribute(title);

        // Now submit the form by clicking the button
        clickButton("submit");

        assertTitleContains(this.config.getString("lenya.tests.general.authoringPageTitle"));
    }
    
    /**
     * Creates a new node id which will most probably be unique.
     * @return id of the form &quot;htmlunit33489823&quot;
     */
    protected String createTestNodeID() {
        return "htmlunit" + System.currentTimeMillis();
    }
    
    /**
     * Asserts that the page given by docID exists in the given area.
     * @param docID
     * @param area
     * @throws Exception
     */
    protected void assertPageExists(String docID, String area) throws Exception {
        loadHtmlPage(this.pubid + "/" + area + docID + ".html");
        assertTitleContains(this.config.getString("lenya.tests.general."+area+"PageTitle"));
    }

    /**
     * Asserts that the page given by docID <em>does not</em> exists in the given area.
     * @param docID
     * @param area
     * @throws Exception
     */
    protected void assertPageDoesNotExist(String docID, String area) throws Exception {
        String page = new String (this.pubid + "/" + area + docID + ".html");
        try {
            this.logger.info("Asserts that page \"" + docID + "\" does not exists, this should throw a 404");
            loadHtmlPage(page);
        } catch (FailingHttpStatusCodeException e) {
            //we expect to throw that exception
            return;
        }
        throw new Exception("assertPageDoesNotExists Error: page" + page+ "was found");
    }
    
    /**
     * Checks that the page nodeID exists in the Authoring-Area, if not create it.
     * @param nodeID
     * @param title
     * @param doctype
     * @throws Exception
     */
    protected void parentExistsOrCreate(String nodeID,
            String title, String doctype) throws Exception {
    	String page = new String (this.pubid + "/" + AUTHORING_AREA + nodeID +".html");
    	try {
    		loadHtmlPage(page);
    		return;
    	} catch (FailingHttpStatusCodeException e) {
    		this.logger.info(page+" does not exist, it will be created");
    		
    		String nodeIDpure = nodeID.replaceFirst("/","");
    		//createNewDocument("/index", NodeIDpure, title, doctype);
    		
    		String prefix = this.pubid + "/" + AUTHORING_AREA + "/index.html";
            // attempt to create the new document:
            loadHtmlPage(prefix + ".html?doctype=" + doctype
                    + "&lenya.usecase=sitemanagement.create");
            assertTitleContains(this.config.getString("lenya.tests.sitemanagement.create.pageTitle"));

            // fill out the form, it has no name :(
            HtmlForm form = (HtmlForm) this.currentPage.getForms().get(0); 

            HtmlTextInput inputDocId = (HtmlTextInput) form
                    .getInputByName("documentId");
            inputDocId.setValueAttribute(nodeIDpure);

            HtmlTextInput inputTitle = (HtmlTextInput) form.getInputByName("dublincore.title");
            inputTitle.setValueAttribute(title);
            
            HtmlRadioButtonInput inputRelation = (HtmlRadioButtonInput) form.getInputByValue("sibling after");
            inputRelation.setChecked(true);
            
            // Now submit the form by clicking the button
            clickButton("submit");    
    	    return;
        }
    }
    
    /**
     * Looks for the String What in the currentPage. Returns true if the currentPage contains String What
     * @param What
     */
    protected boolean findInPage(String what){
        String pagesource = this.currentPage.getPage().asText();
        Pattern patter = Pattern.compile(what);
        boolean found = patter.matcher(pagesource).find();
        return found;
    }    
    
    /**
     * Creates subdirectories for test articels
     * 
     * @param prefix
     * @param rendertype
     */
    protected void createSubFolder(String prefix, String rendertype)
            throws Exception {
        loadHtmlPage(prefix
                + ".html?doctype=folder&lenya.usecase=sitemanagement.create&lenya.exitUsecase=tab.overview&");
        assertTitleContains(this.config.getString("lenya.tests.sitemanagement.create.folder.pageTitle"));
        HtmlForm form;
        form = (HtmlForm) this.currentPage.getForms().get(0);
        form.getInputByName("documentId").setValueAttribute(rendertype);
        form.getInputByName("title").setValueAttribute(rendertype);
        clickButton("submit");
    }
    
    /**
     * Submit
     * 
     * @param docID
     * @throws Exception
     */
    protected void submit(String docID) throws Exception {

        this.logger.info("Submitting " + docID + ".");

        String url = this.pubid + "/" + AUTHORING_AREA + docID + ".html";

        // call the submit usecase
        loadHtmlPage(url + "?&lenya.usecase=workflow.submit");
        if (findInPage("The event submit")) {
            // in case it is already submited it shows the loginscreen
            assertTitleContains(this.config.getString("lenya.tests.workflow.submit.pageTitle"));
            this.logger.info("Can not submit: " + docID  + " seems to be already submited.");
        } else {
            assertTitleContains(this.config.getString("lenya.tests.workflow.submit.pageTitle"));
            clickButton("submit");
            assertTitleContains(this.config.getString("lenya.tests.general.authoringPageTitle"));
        }
    }

    /**
     * Publish
     * 
     * @param docID
     * @throws Exception
     */
    protected void publish(String docID) throws Exception {

        this.logger.info("Publishing " + docID + ".");

        String url = this.pubid + "/" + AUTHORING_AREA + docID + ".html";

        // call the publish usecase
        loadHtmlPage(url + "?lenya.usecase=workflow.publish");
        assertTitleContains(this.config.getString("lenya.tests.workflow.publish.pageTitle"));

        // uncheck the send notification (no smtp on testserver)
        HtmlForm form = (HtmlForm) this.currentPage.getForms().get(0);
        HtmlCheckBoxInput cb = (HtmlCheckBoxInput) form.getInputByName(this.config.getString("lenya.tests.workflow.publish.sendNotification"));
        cb.setChecked(false);

        // Now submit the form by clicking the button
        clickButton("submit");

        assertTitleContains(this.config.getString("lenya.tests.general.authoringPageTitle"));
    }
    
    /**
     * Executes a simple usecase on the given document. 
     * The usecase is required to have a confirmation view, where this method will
     * simply click ok.
     * @param docID
     * @param usecase
     * @throws Exception
     */
    public void executeSimpleUsecase(String docID, String usecase) throws Exception {
        // call the usecase on the given document
        loadHtmlPage(this.pubid + "/" + AUTHORING_AREA + docID + ".html?lenya.usecase="+usecase);
        assertTitleContains(this.config.getString("lenya.tests."+usecase+".pageTitle"));

        clickButton("submit");
        assertTitleContains(this.config.getString("lenya.tests.general.authoringPageTitle"));
    }
    
    
}