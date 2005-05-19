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
import java.util.Date;
import java.util.Locale;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;

import org.apache.avalon.excalibur.io.FileUtil;
import org.apache.lenya.cms.ant.PublicationTask;
import org.apache.lenya.xml.DocumentHelper;
import org.apache.tools.ant.BuildException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**
 * This task is used to rewrite all articles in a given directory and perform some changes.
 * For instance, the date will be rewrite in the iso format yyyy-MM-dd HH:mm:ss .
 */
public class ArticleMigrationTask extends PublicationTask {

    private String baseDir;
    /**
     * Set the base dir where in which the article will be changed.
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

    /**
     * @see org.apache.tools.ant.Task#execute()
     */
    public void execute() throws BuildException {
        log("baseDir: " + getBaseDir());
        File rootDir = new File(getBaseDir());

        try {
            write(rootDir);
        } catch (Exception e) {
            throw new BuildException(e);
        }

    }

    /**
     * performs some changes (set the date's format to iso format yyyy-MM-dd HH:mm:ss )and rewrite the articles 
     * @param file The directory or file. 
     * @throws ParserConfigurationException when something went wrong.
     * @throws SAXException when something went wrong.
     * @throws TransformerConfigurationException when something went wrong.
     * @throws TransformerException when something went wrong.
     * @throws IOException when something went wrong.
     */
    private void write(File file) throws ParserConfigurationException, SAXException, TransformerConfigurationException, TransformerException, IOException{

        FilenameFilter directoryFilter = new FilenameFilter() {

            public boolean accept(File dir, String name) {
                File file = new File(dir, name);
                return file.isDirectory() && !file.getName().equals("frontpage") && !file.getName().equals("newsletter") && !file.getName().equals("dossiers");
            }
        };

        FilenameFilter xmlFileFilter = new FilenameFilter() {

            public boolean accept(File dir, String name) {
                File file = new File(dir, name);
                return file.isFile() && FileUtil.getExtension(name).equals("xml");
            }
        };

        assert(file.isDirectory());

        File[] children = file.listFiles(directoryFilter);
        for (int i = 0; i < children.length; i++) {
            write(children[i]);
        }
        File[] xmlFiles = file.listFiles(xmlFileFilter);

        javax.xml.parsers.DocumentBuilder documentBuilder = DocumentHelper.createBuilder();
        
        for (int i = 0; i < xmlFiles.length; i++) {
            Document document = DocumentHelper.readDocument(xmlFiles[i]);
            NodeList list = document.getElementsByTagName("story.date");
            boolean changed = false;
            for (int j=0; j<list.getLength(); j++){ 
              Element dateE = (Element)list.item(j);
              String millis = dateE.getAttribute("millis");
              long ms = Long.valueOf(millis).longValue();
              Date date = new Date(ms);
              
              Locale locale = new Locale("en");
              SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", locale);
              String newDate = formatter.format(date);
              dateE.setAttribute("norm",newDate);
              changed = true;
            }
            if (changed) {
                DocumentHelper.writeDocument(document, xmlFiles[i]);             
            }

        }
    }

}
