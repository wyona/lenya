package org.apache.lenya.htmlunit.dms.helper;

import org.apache.lenya.htmlunit.LenyaTestCase;

public class WorkflowHelper extends LenyaTestCase {
	/*
	 * (non-Javadoc)
	 * 
	 * @see junit.framework.TestCase#setUp()
	 */
	public void setUp(String testName) throws Exception {
		this.testName = testName;
		super.setUp();
	}

	/**
	 * verify if the live page startDocID exists
	 * 
	 * @param startDocID - document to publish
	 * @param verifyString - the verification string
	 * @throws Exception
	 */
	public void doVerify(String startDocID, String verifyString)
			throws Exception {
		loadHtmlPage(this.pubid + "/" + LIVE_AREA + startDocID + ".html");
		assertPageContainsText(verifyString);
	}

	/**
	 * submit and publish startDocID so that there is no problem to publish
	 * childrens of it
	 * 
	 * @param startDocID - document to publish
	 * @throws Exception
	 */
	public void doSubmit(String startDocID) throws Exception {
		// submit startDocID so that there is no problem to publish
		// childrens of it
		loginAsDefaultUser();
		submit(startDocID);
		logout();
	}
    
    /**
     * publish startDocID 
     * childrens of it
     * 
     * @param startDocID - document to publish
     * @throws Exception
     */
    public void doPublish(String startDocID) throws Exception {
        loginAsReviewer();
        publish(startDocID);
        logout();
    }
}
