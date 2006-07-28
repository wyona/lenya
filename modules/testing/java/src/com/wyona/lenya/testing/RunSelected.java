package com.wyona.lenya.testing;

import java.io.File;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.excalibur.source.Source;
import org.apache.excalibur.source.SourceResolver;
import org.apache.excalibur.source.SourceUtil;
import org.apache.lenya.cms.usecase.AbstractUsecase;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.ProjectHelper;

/**
 * Usecase to run different Anttargets for the Testingmodule. Usecase can handle
 * different calls of Targets which are in the generatedbuild.xml. Execution
 * over the GUI with selection boxes. Two main tasks of the usecase: 1) Generate
 * the dynamic buildgenerated.xml 2) Execute selected Targets (checkboxes in the
 * View)
 * 
 * @author Oliver Schalch
 */
public class RunSelected extends AbstractUsecase {

    /** Path to Module in the Webapp */
    protected String modulepath = "/lenya/modules/testing/";

    protected String buildxml;

    protected String buildgeneratedxml;

    protected Project p;

    protected ProjectHelper phelper;

    /*
     * (non-Javadoc)
     * 
     * @see org.apache.lenya.cms.usecase.AbstractUsecase#doExecute()
     */
    protected void doExecute() throws Exception {
        super.doExecute();

        /* Definition of the location of build and build generated */
        buildxml = getServletContext() + modulepath + "build.xml";
        buildgeneratedxml = getServletContext() + modulepath + "buildgenerated.xml";

        p = new Project();
        /* We need a ProjectHelper to actually parse the generated build file */
        phelper = ProjectHelper.getProjectHelper();
        p.init();
        /* Generate the new buildgenerated.xml with a own ant build.xml */
        generateBuildWithAnt();
        /* Run the Anttargets */
        runAntTarget();
    }

    /**
     * Execute Targets which are in the Vector from #prepareAntTargets()
     * 
     * @throws Exception
     */
    protected void runAntTarget() throws Exception {

        phelper.parse(p, new File(buildgeneratedxml));
        try {
            p.executeTargets(prepareAntTargets());
        } catch (BuildException e) {
            String msg = e.getMessage();
            getLogger().error(msg, e);
            this.addErrorMessage(msg);
        }
    }

    /**
     * Preperate the Vector from the selected Checkboxes in the View.
     * 
     * @return Vector with the Targets to execute.
     */
    protected Vector prepareAntTargets() {

        String[] params = getParameterNames();

        Vector allProject = new Vector();
        
        Pattern p0 = Pattern.compile(".*-all");
        Pattern p1 = Pattern.compile(".*:*.");

        for (int i = 0; i < params.length; i++) {
            
            Matcher m0 = p0.matcher(params[i]);
            Matcher m1 = p1.matcher(params[i]);

            if (m0.matches() && getBooleanCheckboxParameter(params[i]).equals("true")) {
                String projectname = params[i].substring(0, params[i].length() - 4);
                allProject.add(projectname);
            } else if (getBooleanCheckboxParameter("runtests").equals("true")) {
                allProject.add("run");
            } else if (m1.matches() && getBooleanCheckboxParameter(params[i]).equals("true")) {
                allProject.add(params[i]);
            }
        }
        return allProject;
    }

    /**
     * Returns the location of the Webapp Directory
     * 
     * @return String Path to the Webapp directory
     * @throws Exception
     */
    protected String getServletContext() throws Exception {

        SourceResolver resolver = null;
        Source source = null;

        try {
            resolver = (SourceResolver) this.manager.lookup(SourceResolver.ROLE);
            source = resolver.resolveURI("context:///");
            return SourceUtil.getFile(source).getCanonicalPath();
        } finally {
            if (resolver != null) {
                if (source != null) {
                    resolver.release(source);
                }
                this.manager.release(resolver);
            }
        }
    }

    /**
     * Execute the Anttarget to generated the dynamic buildgenerated.xml
     * 
     */
    protected void generateBuildWithAnt() {

        phelper.parse(p, new File(buildxml));

        try {
            p.executeTarget(p.getDefaultTarget());
        } catch (BuildException e) {
            String msg = e.getMessage();
            getLogger().error(msg, e);
            this.addErrorMessage(msg);
        }
    }
}