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

package org.apache.lenya.ac.impl;

import java.io.*;
import java.util.Vector;

import javax.xml.parsers.*;
import org.w3c.dom.*;
import org.xml.sax.*;

public class LdapACHelper {
    
    public Vector getAcGroups (File file) {
        
        Vector groups = new Vector();
        
        Document doc = getDomDocument(file.getAbsolutePath(), false);
        NodeList nodeList=doc.getElementsByTagName("ac:group");
        for (int i=0; i < nodeList.getLength(); i++){
            Node attrNode= nodeList.item(i).getAttributes().getNamedItem("id");
            groups.add(attrNode.getNodeValue().toLowerCase());
        }
        return groups;
        
    }
    
    protected Document getDomDocument(String filename, boolean validating) {
        try {
            // Create a builder factory
            DocumentBuilderFactory factory = DocumentBuilderFactory
                    .newInstance();
            factory.setValidating(validating);

            // Create the builder and parse the file
            Document doc = factory.newDocumentBuilder().parse(
                    new File(filename));
            return doc;
        } catch (SAXException e) {
            // A parsing error occurred; the xml input is not valid
        } catch (ParserConfigurationException e) {

        } catch (IOException e) {

        }
        return null;
    }
    
    public Vector getAllUserInGroup(String groupName, String htGroupFile) {
 
        Vector allIds = new Vector();
        
        try {
            String userIds[] = null;
            BufferedReader input = new BufferedReader( new FileReader(htGroupFile) );
            String line = null; 
            while ( (line = input.readLine()) != null ){
                int ii = line.indexOf(":");
                String name = line.substring(0, ii);

                if (name.equals(groupName)){
                    userIds = line.trim().substring(ii+1).split("\\s+");
                    break;
                }
            }
            input.close();
            for (int i=0; i < userIds.length; i++) {
                allIds.add(userIds[i]);
            }

        } catch (FileNotFoundException ex) {
            ex.printStackTrace();
        } catch (IOException ex){
            ex.printStackTrace();
        }
        return allIds;

    }
    
}
