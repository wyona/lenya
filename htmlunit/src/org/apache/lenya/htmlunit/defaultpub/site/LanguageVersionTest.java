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
package org.apache.lenya.htmlunit.defaultpub.site;

import org.apache.lenya.htmlunit.LenyaTestCase;

import com.gargoylesoftware.htmlunit.html.HtmlForm;
import com.gargoylesoftware.htmlunit.html.HtmlSubmitInput;
import com.gargoylesoftware.htmlunit.html.HtmlTextInput;

import junit.framework.Test;
import junit.framework.TestSuite;

public class LanguageVersionTest extends LenyaTestCase {

    /*
     * (non-Javadoc)
     * 
     * @see junit.framework.TestCase#setUp()
     */
    protected void setUp() throws Exception {
        this.testName = "Create and Delete Language Version";
        super.setUp();
    }

    /**
     * Attempts to create a new language version of a document.
     * 
     * @throws Exception
     */
    public void testNewLanguageVersion() throws Exception {
        loginAsDefaultUser();

        String startDocID = this.config.getString("lenya.tests.general.startDocID");
        String language = this.config.getString("lenya.tests.sitemanagement.createLanguage.language");
        String newNodeID = createTestNodeID();
        
        createNewDocument(startDocID, newNodeID,
                "htmlunit test document", "xhtml");
        
        createNewLanguageVersion(startDocID + "/" + newNodeID, language);

        logout();
    }
    
    /**
     * Attempts to remove a language version of a document.
     * 
     * @throws Exception
     */
    public void testRemoveLanguageVersion() throws Exception {
        loginAsDefaultUser();

        String startDocID = this.config.getString("lenya.tests.general.startDocID");
        String newNodeID = createTestNodeID();
        String language = this.config.getString("lenya.tests.sitemanagement.createLanguage.language");
        
        createNewDocument(startDocID, newNodeID,
                "htmlunit test document", "xhtml");
        
        createNewLanguageVersion(startDocID + "/" + newNodeID, language);

        removeLanguageVersion(startDocID + "/" + newNodeID, language);

        logout();
    }
    
    /**
     * Creates a new language version of a given document.
     * @param docID
     * @param language
     * @throws Exception
     */
    protected void createNewLanguageVersion(String docID, String language) throws Exception {
        this.logger.info("Creating new language version of " + docID + ".");
        
        // call the usecase
        loadHtmlPage(this.pubid + "/" + AUTHORING_AREA + docID
                + ".html?lenya.usecase=sitemanagement.createLanguage");
        assertTitleContains(this.config.getString("lenya.tests.sitemanagement.create.pageTitle"));
        
        // fill out the form
        HtmlForm form = (HtmlForm) this.currentPage.getForms().get(0);
        
        HtmlTextInput inputTitle = (HtmlTextInput) form.getInputByName("dublincore.title");
        inputTitle.setValueAttribute("htmlunit "+language);
        
        // Now submit the form by clicking the button
        clickButton("submit");
        
        assertTitleContains(this.config.getString("lenya.tests.general.authoringPageTitle"));
    }

    /**
     * Removes a language version from a given document.
     * @param docID
     * @param language
     * @throws Exception
     */
    protected void removeLanguageVersion(String docID, String language) throws Exception {
        this.logger.info("Removing language version of " + docID + ".");
        
        // call the usecase
        loadHtmlPage(this.pubid + "/" + AUTHORING_AREA + docID
                + "_" + language + ".html?lenya.usecase=sitemanagement.deleteLanguage");
        assertTitleContains(this.config.getString("lenya.tests.sitemanagement.deleteLanguage.pageTitle"));
        
        // Now submit the form by clicking the button
        clickButton("submit");
        
        assertTitleContains(this.config.getString("lenya.tests.general.authoringPageTitle"));
    }

    public static Test suite() {
        return new TestSuite(LanguageVersionTest.class);
    }

}
