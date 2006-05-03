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
package org.apache.lenya.htmlunit.dms.site.tests;

import junit.framework.Test;
import junit.framework.TestSuite;

import org.apache.lenya.htmlunit.LenyaTestCase;
import org.apache.lenya.htmlunit.dms.helper.MediatypeHelper;

public class CreateTestMediatype extends LenyaTestCase {
	
	private static final String TEST_NAME="DMS Media testing";

    /*
     * (non-Javadoc)
     * 
     * @see junit.framework.TestCase#setUp()
     */
    protected void setUp() throws Exception {
        this.testName = TEST_NAME;
        super.setUp();
    }

    /**
     * Attempts to create a folder
     * 
     * @throws Exception
     */
    public void testCreateDmsMedia() throws Exception {
        String newId = createTestNodeID();
        String verifyString= this.config.getString("lenya.tests.general.authoringPageTitle");
        MediatypeHelper helper = new MediatypeHelper();
        helper.setUp(TEST_NAME);
//      create a new media type 
        helper.mediaCreate(newId, verifyString);
    }
    
	

    public static Test suite() {
        return new TestSuite(CreateTestMediatype.class);
    }

}
