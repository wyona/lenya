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
package org.apache.lenya.htmlunit.defaultpub;

import junit.framework.Test;
import junit.framework.TestSuite;

import org.apache.lenya.htmlunit.LenyaTestCase;

public class LoginTest extends LenyaTestCase {

    protected void setUp() throws Exception {
        this.testName = "Login";
        super.setUp();
    }

    public void testLogin() throws Exception {
        loginAsDefaultUser();
        assertTitleContains(this.config.getString("lenya.tests.general.authoringPageTitle"));
        assertPageContainsText(this.config.getString("lenya.tests.general.startPageContent"));
        
        logout();
        assertTitleContains(this.config.getString("lenya.tests.general.loginPageTitle"));
    }

    public static Test suite() {
        return new TestSuite(LoginTest.class);
    }
}
