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
package org.apache.lenya.htmlunit.defaultpub12.admin;

import org.apache.lenya.htmlunit.LenyaTestCase12;

import com.gargoylesoftware.htmlunit.html.HtmlForm;
import com.gargoylesoftware.htmlunit.html.HtmlPasswordInput;
import com.gargoylesoftware.htmlunit.html.HtmlTextInput;

import junit.framework.Test;
import junit.framework.TestSuite;

public class CreateUserTest extends LenyaTestCase12 {

    /*
     * (non-Javadoc)
     * 
     * @see junit.framework.TestCase#setUp()
     */
    protected void setUp() throws Exception {
        this.testName = "Create User";
        super.setUp();
    }

    /**
     * Attempts to create a new user.
     * 
     * @throws Exception
     */
    public void testCreateUser() throws Exception {
        loginAsDefaultUser();
        String userid = "htmlunit"+(System.currentTimeMillis() % 10000);
        createNewUser(userid, "Mr HtmlUnit", "htmlunit@dev.null",
                "htmlunit123");
        logout();
    }
    
    public static Test suite() {
        return new TestSuite(CreateUserTest.class);
    }

    /**
     * Attempts to create a new user.
     * 
     * @param userid
     * @param name
     * @param email
     * @param password
     * @throws Exception
     */
    public void createNewUser(String userid, String name, String email,
            String password) throws Exception {

        this.logger.info("Creating user " + userid + " (" + name + ").");

        // go to the admin users page
        loadHtmlPage(this.pubid + "/" + ADMIN_AREA + "/users.html");
        assertTitleContains(this.config.getString("lenya.tests.general.adminPageTitle"));

        // get the form, but it has no name :(
        HtmlForm form = (HtmlForm) this.currentPage.getFormByName("add-user-form");
        
        // Now submit the form by clicking the button
        clickButton("submit");

        assertPageContainsText(this.config.getString("lenya.tests.admin.users.pageContent"));

        // fill out the form
        form = (HtmlForm) this.currentPage.getForms().get(0); 

        HtmlTextInput inputUserId = (HtmlTextInput) form
                .getInputByName("userid");
        inputUserId.setValueAttribute(userid);

        HtmlTextInput inputName = (HtmlTextInput) form
                .getInputByName("fullname");
        inputName.setValueAttribute(name);

        HtmlTextInput inputEmail = (HtmlTextInput) form.getInputByName("email");
        inputEmail.setValueAttribute(email);

        HtmlPasswordInput inputPassword1 = (HtmlPasswordInput) form
                .getInputByName("new-password");
        inputPassword1.setValueAttribute(password);

        HtmlPasswordInput inputPassword2 = (HtmlPasswordInput) form
                .getInputByName("confirm-password");
        inputPassword2.setValueAttribute(password);

        // Now submit the form by clicking the button
        clickButton("submit");

        assertPageContainsText(this.config.getString("lenya.tests.admin.user.pageContent"));

    }

}
