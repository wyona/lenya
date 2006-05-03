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
import org.apache.lenya.htmlunit.dms.helper.WorkflowHelper;

public class PublishIndexTest extends LenyaTestCase {

	private static final String TEST_NAME = "DMS Publish Index testing";

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
	public void testPublishIndex() throws Exception {
		String startDocID = "/index";
		String verifyString = this.config
				.getString("lenya.tests.general.startPageContent");
		WorkflowHelper helper = new WorkflowHelper();
		helper.setUp(TEST_NAME);
        helper.doSubmit(startDocID);
		helper.doPublish(startDocID);
		// verify if the live page exists
		helper.doVerify(startDocID, verifyString);
	}

	public static Test suite() {
		return new TestSuite(PublishIndexTest.class);
	}
}
