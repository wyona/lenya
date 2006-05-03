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
package org.apache.lenya.htmlunit.defaultpub.tab;

import org.apache.lenya.htmlunit.LenyaTestCase;

import com.gargoylesoftware.htmlunit.html.HtmlForm;
import com.gargoylesoftware.htmlunit.html.HtmlSubmitInput;
import com.gargoylesoftware.htmlunit.html.HtmlTextArea;
import com.gargoylesoftware.htmlunit.html.HtmlTextInput;

import junit.framework.Test;
import junit.framework.TestSuite;

public class MetaDataTest extends LenyaTestCase {

    /*
     * (non-Javadoc)
     * 
     * @see junit.framework.TestCase#setUp()
     */
    protected void setUp() throws Exception {
        this.testName = "Edit Meta Data";
        super.setUp();
    }
    
    /**
     * Attempts to edit the meta data.
     * 
     * @throws Exception
     */
    public void testMetaData() throws Exception {
        loginAsDefaultUser();
        
        String newNodeID = createTestNodeID();
        String startDocID = this.config.getString("lenya.tests.general.startDocID");
        
        createNewDocument(startDocID, newNodeID,
                "htmlunit test document", "xhtml");
        
        editMetaData(startDocID + "/" + newNodeID);
        logout();
    }
    
    public static Test suite() {
        return new TestSuite(MetaDataTest.class);
    }

    /**
     * Edit Meta Data.
     * 
     * @param docID
     * @throws Exception
     */
    public void editMetaData(String docID) throws Exception {

        this.logger.info("Editing meta data of " + docID + ".");

        String url = this.pubid + "/" + AUTHORING_AREA + docID + ".html";
        
        // go to the meta data page
        loadHtmlPage(url + "?lenya.usecase=tab.meta");
        assertTitleContains(this.config.getString("lenya.tests.general.authoringPageTitle"));

        // new meta data:
        String title = "htmlunit test title"; // TODO: add some special chars äöü
        String subject = "htmlunit test subject";
        String description = "htmlunit test description";
        String publisher = "htmlunit test publisher";
        String rights = "htmlunit test rights";
        
        // get the form, but it has no name :(
        HtmlForm form = (HtmlForm) this.currentPage.getForms().get(0);
        
        HtmlTextInput inputTitle = (HtmlTextInput) form
                .getInputByName("meta.dc.title");
        inputTitle.setValueAttribute(title);

        HtmlTextInput inputSubject = (HtmlTextInput) form
                .getInputByName("meta.dc.subject");
        inputSubject.setValueAttribute(subject);

        HtmlTextArea areaDescription = (HtmlTextArea) form.getTextAreasByName("meta.dc.description").get(0);
        areaDescription.setText(description);

        HtmlTextInput inputPublisher = (HtmlTextInput) form.getInputByName("meta.dc.publisher");
        inputPublisher.setValueAttribute(publisher);

        HtmlTextInput inputRights = (HtmlTextInput) form.getInputByName("meta.dc.rights");
        inputRights.setValueAttribute(rights);

        // Now submit the form by clicking the button
        clickButton("submit");
        
        // now verify the edited meta data:

        form = (HtmlForm) this.currentPage.getForms().get(0);
        
        inputTitle = (HtmlTextInput) form.getInputByName("meta.dc.title");
        assertEquals("Edited meta data not saved correctly", title, inputTitle.getValueAttribute());

        inputSubject = (HtmlTextInput) form.getInputByName("meta.dc.subject");
        assertEquals("Edited meta data not saved correctly", subject, inputSubject.getValueAttribute());

        areaDescription = (HtmlTextArea) form.getTextAreasByName("meta.dc.description").get(0);
        assertEquals("Edited meta data not saved correctly", description, areaDescription.getText());

        inputPublisher = (HtmlTextInput) form.getInputByName("meta.dc.publisher");
        assertEquals("Edited meta data not saved correctly", publisher, inputPublisher.getValueAttribute());

        inputRights = (HtmlTextInput) form.getInputByName("meta.dc.rights");
        assertEquals("Edited meta data not saved correctly", rights, inputRights.getValueAttribute());
    }
}
