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

public class SurfPublicationTest extends LenyaTestCase {

    protected void setUp() throws Exception {
        this.testName = "Surf Publication";
        super.setUp();
    }

    public void testSurfPublication() throws Exception {
        loginAsDefaultUser();
        assertPageContainsText("Hello and welcome to the Lenya default publication!");
        clickLinkWithText("Tutorial");
        assertPageContainsText("This tutorial gives you a short introduction into the Apache Lenya content management system");
        clickLinkWithText("Create new doctype");
        clickLinkWithText("Features");
        assertPageContainsText("Apache Lenya comes with the features you would expect of a modern Content Management System");
        clickLinkWithText("Home");
        assertPageContainsText("Hello and welcome to the Lenya default publication!");
        logout();
    }

    public static Test suite() {
        return new TestSuite(SurfPublicationTest.class);
    }
}
