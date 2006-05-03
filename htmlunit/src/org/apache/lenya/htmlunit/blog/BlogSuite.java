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
package org.apache.lenya.htmlunit.blog;

import org.apache.lenya.htmlunit.defaultpub.ConnectToLenyaTest;
import org.apache.lenya.htmlunit.defaultpub.LoginTest;
import org.apache.lenya.htmlunit.defaultpub.admin.AdminSuite;
import org.apache.lenya.htmlunit.blog.site.SiteSuite;

import junit.framework.Test;
import junit.framework.TestSuite;

public class BlogSuite {

  public static Test suite() {

    TestSuite suite = new TestSuite();

    // tests from the default pub:
    suite.addTest(ConnectToLenyaTest.suite());
    suite.addTest(LoginTest.suite());
    suite.addTest(AdminSuite.suite());
    
    // tests specific for the blog pub:
    suite.addTest(SiteSuite.suite());

    return suite;
  }

  public static void main(String[] args) {
    junit.textui.TestRunner.run(suite());
  }
}
