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
import com.gargoylesoftware.htmlunit.html.HtmlPage;
import com.gargoylesoftware.htmlunit.html.HtmlSubmitInput;
import com.gargoylesoftware.htmlunit.html.HtmlTextArea;

import junit.framework.Test;
import junit.framework.TestSuite;

public class OneFormLockTest extends LenyaTestCase {

    /*
     * (non-Javadoc)
     * 
     * @see junit.framework.TestCase#setUp()
     */
    protected void setUp() throws Exception {
        this.testName = "Edit with One Form with two different users";
        super.setUp();
    }
    
    /**
     * Attempts to edit a document with two different users.
     * A locking error is expected.
     * 
     * @throws Exception
     */
    public void testEditOneFormLock() throws Exception {
        loginAsDefaultUser();
        
        String newNodeID = createTestNodeID();
        String startDocID = this.config.getString("lenya.tests.general.startDocID");
        
        createNewDocument(startDocID, newNodeID,
                "htmlunit test document", "xhtml");
        
        // the url contains no .html as a workaround for the following problem:
        // on submit, a post request is send, and lenya responds with a redirect
        // to the same url, which htmlunit does not like
        // without the .html the url is not the same but everything works
        String url = this.pubid + "/" + AUTHORING_AREA + startDocID + "/" + newNodeID;
        
        // load one form editor
        loadHtmlPage(url + "?&lenya.event=edit&lenya.usecase=editors.oneform");
        assertTitleContains(this.config.getString("lenya.tests.editors.oneform.pageTitle"));
        // don't submit the form, just log out
        logout();
        
        // login as alice and load the form editor
        login(this.config.getString("lenya.reviewerUsername"), this.config.getString("lenya.reviewerPassword"));
        loadHtmlPage(url + "?&lenya.event=edit&lenya.usecase=editors.oneform");
        // the document should be locked
        assertPageContainsText(this.config.getString("lenya.tests.editors.oneform.lockError"));
        logout();
        
        // now log in again as lenya user and cancel the edit
        loginAsDefaultUser();
        loadHtmlPage(url + "?&lenya.event=edit&lenya.usecase=editors.oneform");
        assertTitleContains(this.config.getString("lenya.tests.editors.oneform.pageTitle"));
        clickButton("cancel");
        logout();
        
        // login again as alice and load the form editor
        login(this.config.getString("lenya.reviewerUsername"), this.config.getString("lenya.reviewerPassword"));
        loadHtmlPage(url + "?&lenya.event=edit&lenya.usecase=editors.oneform");
        // the document should not be locked anymore
        assertTitleContains(this.config.getString("lenya.tests.editors.oneform.pageTitle"));
        clickButton("cancel");
        logout();
    }
        
    public static Test suite() {
        return new TestSuite(OneFormLockTest.class);
    }
}