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

/* @version $Id: SitetreeFragmentGenerator.java 159584 2005-03-31 12:49:41Z andreas $*/

package org.apache.lenya.cms.cocoon.generation;

import org.apache.avalon.framework.service.ServiceSelector;
import org.apache.lenya.cms.publication.DocumentBuilder;
import org.apache.lenya.cms.publication.DocumentIdentifier;
import org.apache.lenya.cms.site.tree.SiteTreeNode;
import org.xml.sax.SAXException;
import org.apache.lenya.cms.publication.Document;

/**
 * Generates a fragment of the navigation XML from the sitetree, corresponding to a given node. 
 */
public class SitetreeFragmentGeneratorResourcetype extends SitetreeFragmentGenerator {
  
  protected static final String ATTR_RESOURCETYPE = "resourcetype";
  
  /**
   * Returns the doctype of the document.
   * @param node
   * @param doctype1
   * @return
   */
  protected String getResourceType(SiteTreeNode node) {
    
      ServiceSelector selector = null;
      DocumentBuilder builder = null;
      try {
          selector = (ServiceSelector) this.manager.lookup(DocumentBuilder.ROLE + "Selector");
          String hint = this.publication.getDocumentBuilderHint();
          builder = (DocumentBuilder) selector.select(hint);
          String lang = node.getLabels()[0].getLanguage();
          DocumentIdentifier identifier = new DocumentIdentifier(this.publication, this.area, node.getAbsoluteId(), lang);
          Document document = builder.buildDocument(this.identityMap, identifier);
          String resourcetype = document.getResourceType().getName();
          return resourcetype;
          
      } catch (Exception e) {
          throw new RuntimeException(e);
      } finally {
          if (selector != null) {
              if (builder != null) {
                  selector.release(builder);
              }
              this.manager.release(selector);
          }
      }
  }  
 
    /**
     * Calls super and sets the attributes for resourcetype.
     * @param node
     * @throws SAXException if an error occurs while setting the attributes
     */
    protected void setNodeAttributes(SiteTreeNode node) throws SAXException {
        
        super.setNodeAttributes(node);
                
        String resourceType = getResourceType(node);

        if (this.getLogger().isDebugEnabled()) {
            this.getLogger().debug("adding attribute resourcetype: " + resourceType);
        }
        
        this.attributes.addAttribute("", ATTR_RESOURCETYPE, ATTR_RESOURCETYPE, "CDATA", resourceType);
    }
}