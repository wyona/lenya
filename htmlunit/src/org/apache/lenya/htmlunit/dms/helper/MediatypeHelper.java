package org.apache.lenya.htmlunit.dms.helper;

import org.apache.lenya.htmlunit.LenyaTestCase;

import com.gargoylesoftware.htmlunit.html.HtmlCheckBoxInput;
import com.gargoylesoftware.htmlunit.html.HtmlFileInput;
import com.gargoylesoftware.htmlunit.html.HtmlForm;
import com.gargoylesoftware.htmlunit.html.HtmlSubmitInput;
import com.gargoylesoftware.htmlunit.html.HtmlTextInput;

public class MediatypeHelper extends LenyaTestCase {
	/*
	 * (non-Javadoc)
	 * 
	 * @see junit.framework.TestCase#setUp()
	 */
	public void setUp(String testName) throws Exception {
		this.testName = testName;
		super.setUp();
	}

    public static final String CREATE_MEDIA_SUFFIX = "/index.html?doctype=mediatype&lenya.usecase=create.media.assets";

    public void mediaCreate(String newId,String verifyString) throws Exception {
        loginAsDefaultUser();
        // attempt to create the new mediaType:
        loadHtmlPage(this.pubid + "/" + AUTHORING_AREA + CREATE_MEDIA_SUFFIX);
        assertTitleContains(this.config.getString("lenya.tests.site.create.mediaType.pageTitle"));
        
        // fill out the form 
        HtmlForm form = (HtmlForm)this.currentPage.getForms().get(0); // form has no name :(
        
        HtmlTextInput inputDocId = (HtmlTextInput) form.getInputByName("documentId");
        inputDocId.setValueAttribute(newId);
        
        HtmlTextInput inputTitle = (HtmlTextInput) form.getInputByName("title");
        inputTitle.setValueAttribute(this.config.getString("lenya.tests.site.create.mediaType.testName"));

        HtmlFileInput inputFile = (HtmlFileInput) form.getInputByName("file");
        inputFile.setValueAttribute(this.config.getString("lenya.tests.site.create.mediaType.file"));
        
        HtmlSubmitInput button = (HtmlSubmitInput) form.getInputByName("submit");
        
        // Now submit the form by clicking the button
        click(button);

        assertTitleContains(verifyString);
        logout();
    }
    /**
     * publish startDocID 
     * childrens of it
     * 
     * @param startDocID - document to publish
     * @throws Exception
     */
    public void doPublish(String startDocID,String verifyString) throws Exception {
        loginAsReviewer();
        this.publish(startDocID,verifyString);
        logout();
    }
    /**
     * Publish
     * 
     * @param docID
     * @throws Exception
     */
    protected void publish(String docID,String verifyString) throws Exception {

        this.logger.info("Publishing " + docID + ".");

        String url = this.pubid + "/" + AUTHORING_AREA + docID + ".html";

        // call the publish usecase
        loadHtmlPage(url + "?lenya.usecase=mediatype.publish");
        assertTitleContains(this.config.getString("lenya.tests.workflow.publish.pageTitle"));

        // uncheck the send notification (no smtp on testserver)
        HtmlForm form = (HtmlForm) this.currentPage.getForms().get(0);
        HtmlCheckBoxInput cb = (HtmlCheckBoxInput) form.getInputByName(this.config.getString("lenya.tests.workflow.publish.sendNotification"));
        cb.setChecked(false);

        // Now submit the form by clicking the button
        clickButton("submit");

        assertTitleContains(verifyString);
    }
}
