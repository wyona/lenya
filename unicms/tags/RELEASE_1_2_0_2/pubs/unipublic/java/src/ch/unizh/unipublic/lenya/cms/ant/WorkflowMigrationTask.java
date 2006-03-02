/*
 * Copyright  1999-2004 The Apache Software Foundation
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

package ch.unizh.unipublic.lenya.cms.ant;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;

import org.apache.avalon.excalibur.io.FileUtil;
import org.apache.lenya.cms.ant.PublicationTask;
import org.apache.lenya.cms.publication.DefaultSiteTree;
import org.apache.lenya.cms.publication.Label;
import org.apache.lenya.cms.publication.SiteTreeException;
import org.apache.lenya.xml.DocumentHelper;
import org.apache.tools.ant.BuildException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import ch.unizh.unipublic.lenya.cms.publication.Article;
import ch.unizh.unipublic.lenya.cms.publication.Dossier;

/**
 * This task is used to instantiate the workflow, for all migrated document.
 * It copies a sample workflow file in the right place in the directory structure.
 */
public class WorkflowMigrationTask extends PublicationTask {
    
    private String baseDir;
    /**
     * Set the base dir, in which are the migrated document.
     * 
     * @param baseDir the base dir
     */
    public void setBaseDir(String baseDir) {
        this.baseDir = baseDir;
    }

    /**
     * Get the base dir.
     * 
     * @return the base dir
     */
    private String getBaseDir() {
        return this.baseDir;
    }

    private String workflowFile;
    /**
     * Set the sample workflow file. 
     * 
     * @param workflowFile the sample of a workflow file
     */
    public void setWorkflowFile(String workflowFile) {
        this.workflowFile = workflowFile;
    }

    /**
     * Get the sample workflow file.
     * 
     * @return the sample workflow file
     */
    private String getWorkflowFile() {
        return this.workflowFile;
    }

    private String workflowDir;
    /**
     * Set the workflow dir.
     * 
     * @param workflowDir the workflow dir
     */
    public void setWorkflowDir(String workflowDir) {
        this.workflowDir = workflowDir;
    }

    /**
     * Get the workflow dir.
     * 
     * @return the workflow dir
     */
    private String getWorkflowDir() {
        return this.workflowDir;
    }

    /**
     * @see org.apache.tools.ant.Task#execute()
     */
    public void execute() throws BuildException {
        log("baseDir: " + getBaseDir());
        File rootDir = new File(getBaseDir());
        File workflowInstance = new File(getWorkflowFile());
        
        try {
            copyWorkflowInstance(rootDir, workflowInstance, "");
        } catch (IOException e) {
            throw new BuildException(e);
        }

    }

    /**
     * @param file The directory in which are the migrated documents.
     * @param workflowSampleFile The sample of the workflow file.
     * @param documentId The id of the document.
     * @throws IOException when something went wrong.
     */
    private void copyWorkflowInstance(File file, File workflowSampleFile, String documentId) throws IOException {
        FilenameFilter directoryFilter = new FilenameFilter() {

            public boolean accept(File dir, String name) {
                File file = new File(dir, name);
                return file.isDirectory() && !file.getName().equals("frontpage") && !file.getName().equals("newsletter");
            }
        };

        FilenameFilter xmlFileFilter = new FilenameFilter() {

            public boolean accept(File dir, String name) {
                File file = new File(dir, name);
                return file.isFile() && FileUtil.getExtension(name).equals("xml");
            }
        };

        assert(file.isDirectory());

        if (!file.equals(new File (getBaseDir()))) {
            documentId = documentId + "/" +file.getName();
          }  
        
        File[] children = file.listFiles(directoryFilter);
        for (int i = 0; i < children.length; i++) {
            copyWorkflowInstance(children[i], workflowSampleFile, documentId);
        }
        String dir = getWorkflowDir() + documentId;
        File[] xmlFiles = file.listFiles(xmlFileFilter);
        for (int i = 0; i < xmlFiles.length; i++) {
            File workflowFile = new File(dir, xmlFiles[i].getName());
            if (!workflowFile.exists()){
                FileUtil.copyFile(workflowSampleFile, workflowFile);
            }
        }

    }
    
}
