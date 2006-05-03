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
package org.apache.lenya.htmlunit.blog.site;

import org.apache.lenya.htmlunit.LenyaTestCase;

import com.gargoylesoftware.htmlunit.html.HtmlForm;
import com.gargoylesoftware.htmlunit.html.HtmlSubmitInput;
import com.gargoylesoftware.htmlunit.html.HtmlTextInput;

import junit.framework.Test;
import junit.framework.TestSuite;

public class CreateTest extends LenyaTestCase {

    /*
     * (non-Javadoc)
     * 
     * @see junit.framework.TestCase#setUp()
     */
    protected void setUp() throws Exception {
        this.testName = "Create Entry";
        super.setUp();
    }

    /**
     * Attempts to create a blog entry
     * 
     * @throws Exception
     */
    public void testCreateBlogEntry() throws Exception {
        loginAsDefaultUser();
        
        // attempt to create the new document:
        loadHtmlPage(this.pubid + "/" + AUTHORING_AREA + "/feeds/all/index.html?lenya.usecase=site.create");
        assertTitleContains(this.config.getString("lenya.tests.site.create.pageTitle"));
        
        // fill out the form 
        HtmlForm form = (HtmlForm)this.currentPage.getForms().get(0); // form has no name :(
        
        HtmlTextInput inputDocId = (HtmlTextInput) form.getInputByName("documentId");
        inputDocId.setValueAttribute(createTestNodeID());
        
        HtmlTextInput inputTitle = (HtmlTextInput) form.getInputByName("title");
        inputTitle.setValueAttribute("htmlunit blog entry");
        
        HtmlSubmitInput button = (HtmlSubmitInput) form.getInputByName("submit");
        
        // Now submit the form by clicking the button
        click(button);

        assertTitleContains(this.config.getString("lenya.tests.general.authoringPageTitle"));
        
        logout();
    }

    public static Test suite() {
        return new TestSuite(CreateTest.class);
    }

}
