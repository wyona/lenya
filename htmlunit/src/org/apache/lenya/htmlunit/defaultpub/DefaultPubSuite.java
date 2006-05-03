package org.apache.lenya.htmlunit.defaultpub;

import org.apache.lenya.htmlunit.defaultpub.admin.AdminSuite;
import org.apache.lenya.htmlunit.defaultpub.edit.EditSuite;
import org.apache.lenya.htmlunit.defaultpub.site.SiteSuite;
import org.apache.lenya.htmlunit.defaultpub.tab.TabSuite;
import org.apache.lenya.htmlunit.defaultpub.workflow.WorkflowSuite;

import junit.framework.Test;
import junit.framework.TestSuite;

public class DefaultPubSuite {

    public static Test suite() {

        TestSuite suite = new TestSuite();

        suite.addTest(ConnectToLenyaTest.suite());
        suite.addTest(LoginTest.suite());
        suite.addTest(SurfPublicationTest.suite());

        suite.addTest(AdminSuite.suite());

        suite.addTest(SiteSuite.suite());

        suite.addTest(TabSuite.suite());

        suite.addTest(WorkflowSuite.suite());
        
        suite.addTest(EditSuite.suite());
        
        return suite;
    }

    public static void main(String[] args) {
        junit.textui.TestRunner.run(suite());
    }
}
