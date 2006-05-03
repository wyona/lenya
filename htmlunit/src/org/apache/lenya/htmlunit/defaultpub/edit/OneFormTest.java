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
package org.apache.lenya.htmlunit.defaultpub.edit;

import org.apache.lenya.htmlunit.LenyaTestCase;

import com.gargoylesoftware.htmlunit.html.HtmlForm;
import com.gargoylesoftware.htmlunit.html.HtmlSubmitInput;
import com.gargoylesoftware.htmlunit.html.HtmlTextArea;

import junit.framework.Test;
import junit.framework.TestSuite;

public class OneFormTest extends LenyaTestCase {

    /*
     * (non-Javadoc)
     * 
     * @see junit.framework.TestCase#setUp()
     */
    protected void setUp() throws Exception {
        this.testName = "Edit with One Form";
        super.setUp();
    }
    
    /**
     * Attempts to edit a document.
     * 
     * @throws Exception
     */
    public void testEditOneForm() throws Exception {
        loginAsDefaultUser();
        
        String newNodeID = createTestNodeID();
        String startDocID = this.config.getString("lenya.tests.general.startDocID");
        
        createNewDocument(startDocID, newNodeID,
                "htmlunit test document", "xhtml");
        
        editWithOneForm(startDocID + "/" + newNodeID);
        logout();
    }
    
    public static Test suite() {
        return new TestSuite(OneFormTest.class);
    }

    /**
     * Edit with One Form Editor.
     * 
     * @param docID
     * @throws Exception
     */
    public void editWithOneForm(String docID) throws Exception {

        this.logger.info("Editing " + docID + " with one form editor.");

        // the url contains no .html as a workaround for the following problem:
        // on submit, a post request is send, and lenya responds with a redirect
        // to the same url, which htmlunit does not like
        // without the .html the url is not the same but everything works
        String url = this.pubid + "/" + AUTHORING_AREA + docID;
        
        // load one form editor
        loadHtmlPage(url + "?&lenya.event=edit&lenya.usecase=edit.oneform");
        assertTitleContains(this.config.getString("lenya.tests.edit.oneform.pageTitle"));

        // get the form, but it has no name :(
        HtmlForm form = (HtmlForm) this.currentPage.getForms().get(0);
        
        HtmlTextArea areaContent = (HtmlTextArea) form.getTextAreasByName("content").get(0);
        String content = areaContent.getText();
        
        // edit the page by replacing a string:
        String sampleString = this.config.getString("lenya.tests.edit.oneform.pageContent");
        String replacementString = "one form test";
        
        content = content.replaceFirst(sampleString, replacementString);
        
        areaContent.setText(content);

        clickButton("submit");
        
        
        // now verify the edited page
        assertTitleContains(this.config.getString("lenya.tests.general.authoringPageTitle"));
        assertPageContainsText(replacementString);

    }
}
