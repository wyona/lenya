package org.apache.lenya.htmlunit.dms.helper;

import org.apache.lenya.htmlunit.LenyaTestCase;

import com.gargoylesoftware.htmlunit.html.HtmlForm;
import com.gargoylesoftware.htmlunit.html.HtmlSubmitInput;
import com.gargoylesoftware.htmlunit.html.HtmlTextInput;

public class FolderHelper extends LenyaTestCase {
	/*
	 * (non-Javadoc)
	 * 
	 * @see junit.framework.TestCase#setUp()
	 */
	public void setUp(String testName) throws Exception {
		this.testName = testName;
		super.setUp();
	}
    public static final String CREATE_FOLDER_SUFFIX = "/index.html?doctype=folder&lenya.usecase=site.create";

    public void folderCreate(String newId,String verifyString) throws Exception {
        loginAsDefaultUser();
        // attempt to create the new folder:
        loadHtmlPage(this.pubid + "/" + AUTHORING_AREA + CREATE_FOLDER_SUFFIX);
        assertTitleContains(this.config.getString("lenya.tests.site.create.folder.pageTitle"));
        
        // fill out the form 
        HtmlForm form = (HtmlForm)this.currentPage.getForms().get(0); // form has no name :(
        
        HtmlTextInput inputDocId = (HtmlTextInput) form.getInputByName("documentId");
        inputDocId.setValueAttribute(newId);
        
        HtmlTextInput inputTitle = (HtmlTextInput) form.getInputByName("title");
        inputTitle.setValueAttribute(this.config.getString("lenya.tests.site.create.folder.testName"));
        
        HtmlSubmitInput button = (HtmlSubmitInput) form.getInputByName("submit");
        
        // Now submit the form by clicking the button
        click(button);

        assertTitleContains(verifyString);
        logout();
    }
}
