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
package org.apache.lenya.htmlunit.dms.workflow.tests;

import junit.framework.Test;
import junit.framework.TestSuite;

import org.apache.lenya.htmlunit.LenyaTestCase;
import org.apache.lenya.htmlunit.dms.helper.FolderHelper;
import org.apache.lenya.htmlunit.dms.helper.WorkflowHelper;

public class PublishFolderTest extends LenyaTestCase {

	private static final String TEST_NAME = "DMS Publish Folder testing";

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
	 * Attempts to create a document, submit it, and publish it.
	 * 
	 * @throws Exception
	 */
	public void testPublishFolder() throws Exception {
        String newId = createTestNodeID();
        String verifyString= this.config.getString("lenya.tests.general.authoringPageTitle");
        //setup helper
        FolderHelper helper = new FolderHelper();
        helper.setUp(TEST_NAME);
        WorkflowHelper flowHelper = new WorkflowHelper();
        flowHelper.setUp(TEST_NAME);
//      create a new media type 
        helper.folderCreate(newId, verifyString);
        
		String startDocID = "/index/"+newId;
        // submit the document
        flowHelper.doSubmit(startDocID);
        //publish the document
        flowHelper.doPublish(startDocID);
		// verify if the live page exists
        verifyString = this.config.getString("lenya.tests.general.startPageContent");
        flowHelper.doVerify(startDocID, verifyString);
	}

	public static Test suite() {
		return new TestSuite(PublishFolderTest.class);
	}
}
