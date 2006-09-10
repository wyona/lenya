/*
* Copyright 1999-2004 The Apache Software Foundation
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

importClass(Packages.java.io.File);
importClass(Packages.java.util.ArrayList);
importClass(Packages.org.apache.lenya.cms.cocoon.flow.FlowHelper);
importClass(Packages.org.apache.lenya.cms.cocoon.uriparameterizer.URIParameterizer);
importClass(Packages.org.apache.avalon.framework.parameters.Parameters);
importClass(Packages.org.apache.lenya.cms.publication.ResourcesManager);
importClass(Packages.org.apache.lenya.cms.publication.PublicationHelper);


/** Import usecase for eLML lessons. See http://www.elml.ch for information about eLML (e-Learning markup language). 
** @author Thomas Comiotto
**/

function convertLesson() {

  cocoon.log.info("Entering eLML Conversion usecase");

  var flowHelper = new FlowHelper();
  var pageEnvelope = flowHelper.getPageEnvelope(cocoon);
  var documentHelper = flowHelper.getDocumentHelper(cocoon);
  var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);
  var doc = pageEnvelope.getDocument();
 

  var name = doc.getLabel();
  cocoon.sendPageAndWait("convert.jx", {"name" : name});

  
  /* Test for cancel operation and redirect to the page the usecase was executed on */
  if (cocoon.request.get("submit") == "cancel") {
    cocoon.redirectTo(pageEnvelope.getContext() + doc.getCompleteURL());
    return; 
  }
  
  var pipelineUtil = cocoon.createObject(Packages.org.apache.cocoon.components.flow.util.PipelineUtil);
  var pub = doc.getPublication();
  var domToDocumentMap = new Array();

  /* Parse dom of lesson  */

  var path = doc.getId() + "/index_" + doc.getLanguage() + ".xml";
  var dom = pipelineUtil.processToDOM("xml/" + path, null);
  cocoon.log.error("Pushing Lesson to map " + dom + " ," + doc);
  domToDocumentMap.push(new Array(dom, doc));
  
  
  /* Parse  dom of lesson parts  */
 
  var children = getChildren(doc);
  
  for (var i = 0; i < children.size(); i++) {
    var doc = children.get(i);
    var path = children.get(i).getId() + "/index_" + doc.getLanguage() + ".xml";
    var dom = pipelineUtil.processToDOM("xml/" + path, null);
    cocoon.log.error("Pushing Lesson fragment to map " + dom + " ," + doc);
    domToDocumentMap.push(new Array(dom, doc));
  }
  
  
  /* Convert Lesson **/
  
   /* Rewrite links */
  
  cocoon.log.info("Starting Link rewrite process...");
  
  var labelToURIMap = new Array();
  
  for (var i = 0; i < domToDocumentMap.length; i++) {
      
    var dom = domToDocumentMap[i][0];
    var document = domToDocumentMap[i][1];
    
    var elements = dom.getElementsByTagName("*");
    for (var j = 0; j < elements.length; j++) {
      if (elements.item(j).hasAttribute("label")) {
        var label = elements.item(j).getAttribute("label");
        var uri = pageEnvelope.getContext() + document.getCompleteURL() + "#" + label;
        labelToURIMap.push (new Array(label, uri));
      }
    }
  }  
  
  for (var i = 0; i < domToDocumentMap.length; i++) {
      
    var dom = domToDocumentMap[i][0];
    
    while (dom.getElementsByTagName("link").length > 0) {
    
      var link = dom.getElementsByTagName("link").item(0); 
      var uri = null;
      
      if (link.hasAttribute("targetLabel")) {
        var targetLabel = link.getAttribute("targetLabel");
        
        for (var z = 0; z < labelToURIMap.length; z++) {
          var label = labelToURIMap[z][0];
          if (label.equals(targetLabel)) {
              var uri = labelToURIMap[z][1]; 
          }
        }
      } else {
        uri = link.getAttribute("uri");
      }
      
      var anchor = dom.createElementNS("http://www.w3.org/1999/xhtml", "xhtml:a");
      anchor.setAttribute("href", uri);
      var childNodes = link.childNodes;
      
      for (var y = 0; y < childNodes.length; y++) {
        var node = childNodes.item(y);
        var clone = node.cloneNode(true);
        anchor.appendChild(clone);
      }
              
      var link = link.parentNode.replaceChild(anchor, link);
      cocoon.log.error("Changed link: " + link + " to: " + anchor);
      
      
    }
  }
  
  
  cocoon.log.info("Starting conversion elml:multimedia -> lenya:asset or xhtml:object");
    
  for (var i = 0; i < domToDocumentMap.length; i++) {
      
    var dom = domToDocumentMap[i][0];
    
    while (dom.getElementsByTagName("multimedia").length > 0) {
    
      var multimedia = dom.getElementsByTagName("multimedia").item(0); 
      
      if (multimedia.hasAttribute("src")) {
        var src = multimedia.getAttribute("src");
        var type = multimedia.getAttribute("type");
        
        if (type == "gif" || type == "jpeg" || type == "png") {
        
          var object = dom.createElementNS("http://www.w3.org/1999/xhtml", "xhtml:object");
          cocoon.log.error("Replacing : " + multimedia + " by " + object);    
          object.setAttribute("data", src.substr(src.lastIndexOf("/") + 1));
          if (multimedia.hasAttribute("width")) {
            object.setAttribute("width", multimedia.getAttribute("width"));
          }
          if (multimedia.hasAttribute("height")) {
            object.setAttribute("height", multimedia.getAttribute("height"));
          }
          
          cocoon.log.error("Object src attribute: " + object.getAttribute("data"));       
          multimedia.parentNode.replaceChild(object, multimedia);
          
        } else {
        
          var asset = dom.createElementNS("http://apache.org/cocoon/lenya/page-envelope/1.0", "lenya:asset"); 
          cocoon.log.error("Replacing : " + multimedia + " by " + asset);    
          asset.setAttribute("src", src.substr(src.lastIndexOf("/") + 1));
          asset.setAttribute("type", multimedia.getAttribute("type"));
          asset.setAttribute("size", "");
          cocoon.log.error("Asset src attribute: " + asset.getAttribute("src"));       
          multimedia.parentNode.replaceChild(asset, multimedia);
          
        }
      } else {
        multimedia.parentNode.removeChild(multimedia);
      }
    }
  }  
  
  
   /* Serialize DOM fragments to documents */
   
  for (var i=0; i < domToDocumentMap.length; i++) {
    
    var dom = domToDocumentMap[i][0];
    var document = domToDocumentMap[i][1];
  
    var sourceUri = documentHelper.getSourceUri(document);  
    var source = resolver.resolveURI(sourceUri); 
    var out = source.getOutputStream();
    cocoon.log.error("Serializing dom to: " + out);
    cocoon.processPipelineTo("createdocument",  {"dom" : dom} , out);  
    out.close();  
  }
  
  cocoon.sendPage("confirmation.jx", {"url" : pageEnvelope.getContext() + doc.getCompleteURL()});

}


function getChildren(doc)  {

  var docs = new ArrayList();
  var pub = doc.getPublication();
  var tree = pub.getTree("authoring");
  var node = tree.getNode(doc.getId());

  var children = node.getChildren();
  for (var i = 0; i < children.length; i++) {
    var doc = buildDocument(children[i].getAbsoluteId(), doc.getLanguage());
    docs.add(doc);
  }
  return docs;
}


function buildDocument(id, lang) {

  var flowHelper = new FlowHelper();
  var pageEnvelope = flowHelper.getPageEnvelope(cocoon);
  var pub = pageEnvelope.getPublication();
  var documentBuilder = pub.getDocumentBuilder();
  var documentHelper = flowHelper.getDocumentHelper(cocoon);

  if (lang == null) {
    lang = pub.getDefaultLanguage();
  }

  var url = documentHelper.getDocumentUrl(id, "authoring", lang);
  if (url.indexOf("lenya") > -1) {
    url = url.substring(6); // FIXME: obtain prefix
  }

  var doc = documentBuilder.buildDocument(pub, url);
  return doc;

}




 