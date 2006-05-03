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

public class OpenODTDocument extends LenyaTestCase {

    /*
     * @see junit.framework.TestCase#setUp()
     */
    protected void setUp() throws Exception {
        this.testName = "Open an Open Office Document in Lenya";
        super.setUp();
    }

    /**
     * Attempts to open an .odt document.
     * 
     * @throws Exception
     */
    public void testOpenODTDocument() throws Exception {
        loginAsDefaultUser();
        String docID = this.config.getString("lenya.tests.odt.documentPath");
        loadHtmlPage(this.pubid + "/" + AUTHORING_AREA + docID + ".html");
        assertTitleContains(this.config.getString("lenya.tests.odt.pageTitle"));
        assertPageContainsText(this.config.getString("lenya.tests.odt.pageContent"));
        logout(); 
    }

    public static Test suite() {
        return new TestSuite(OpenODTDocument.class);
    }

}
