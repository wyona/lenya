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
 * This task is used to insert a node in a sitetree, for all migrated document.
 */
public class TreeMigrationTask extends PublicationTask {
    
    private String baseDir;
    /**
     * Set the base dir, directory in which are the migrated document.
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

    private String siteTreeFile;
    /**
     * Set the siteTree file.
     * 
     * @param siteTreeFile the siteTree file
     */
    public void setSiteTreeFile(String siteTreeFile) {
        this.siteTreeFile = siteTreeFile;
    }

    /**
     * Get the siteTree file.
     * 
     * @return the siteTree file
     */
    private String getSiteTreeFile() {
        return this.siteTreeFile;
    }

    /**
     * @see org.apache.tools.ant.Task#execute()
     */
    public void execute() throws BuildException {
        log("baseDir: " + getBaseDir());
        File rootDir = new File(getBaseDir());
        
        String treefilename = getSiteTreeFile();
        try {
            DefaultSiteTree siteTree = new DefaultSiteTree(treefilename);
            migrateSiteTree(siteTree, rootDir, "", "");
            siteTree.save();
        } catch (SiteTreeException e) {
            throw new BuildException(e);
        }

    }

    /**
     * Add a node in a site tree, for all migrated document. Go through the directory in
     * which are the migrated documents.
     * @param siteTree The site tree.
     * @param file. The directory.
     * @param parentId The parent id of the document.
     * @param id The id of the document.
     * @throws SiteTreeException when something went wrong.
     */
    private void migrateSiteTree(DefaultSiteTree siteTree, File file, String parentId, String id) throws SiteTreeException {
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
        if (parentId.equals("/")) {
          parentId = parentId + id;
          id = file.getName();
        } else if (!file.equals(new File (getBaseDir()))) {
          parentId = parentId + "/" + id;
          id = file.getName();
        }  
        File[] children = file.listFiles(directoryFilter);
        for (int i = 0; i < children.length; i++) {
            migrateSiteTree(siteTree, children[i], parentId, id);
        }

        boolean visibleinnav = true; 
        if (Article.isArticleDocument(parentId + "/" + id) || Dossier.isDossierDocument(parentId + "/" + id)) {
          visibleinnav = false;    
        } 
        
        ArrayList labelList = new ArrayList();
        labelList.add(new Label("dummy", "de"));
        Label[] labels = (Label[]) labelList.toArray(new Label[labelList.size()]);
        
        File[] xmlFiles = file.listFiles(xmlFileFilter);
        for (int i = 0; i < xmlFiles.length; i++) {
            siteTree.addNode(parentId, id, labels, visibleinnav);
        }

    }
    
}
