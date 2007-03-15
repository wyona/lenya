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
importClass(Packages.java.util.zip.ZipFile);
importClass(Packages.org.apache.lenya.cms.authoring.UploadHelper);
importClass(Packages.java.util.ArrayList);
importClass(Packages.org.apache.lenya.cms.authoring.DocumentCreator);
importClass(Packages.org.apache.lenya.cms.cocoon.flow.FlowHelper);
importClass(Packages.org.apache.lenya.cms.cocoon.source.SourceUtil);
importClass(Packages.org.apache.lenya.cms.publication.ResourcesManager);
importClass(Packages.java.io.FileOutputStream);


var referer;

/** Import usecase for eLML lessons. See http://www.elml.ch for information about eLML (e-Learning markup language). 
** @author Thomas Comiotto
**/

function importLesson() {

  cocoon.log.info("Entering eLML Import usecase");

  referer = cocoon.request.getHeader("referer");

  /** Display upload dialog **/ 

  cocoon.log.info("Displaying upload dialog");
  
  cocoon.sendPageAndWait("upload.jx");
  
  /* Test for cancel operation and redirect to the page the usecase was executed */
  if (cocoon.request.get("submit") == "cancel") {
    cocoon.redirectTo(referer);
    return; 
  }
  
  /* Validate the upload form submission */
  cocoon.log.info("Validating upload form submission");
  if (cocoon.request.get("upload-file") == null) {
    cocoon.log.info("No data provided - displaying upload form again");
    importLesson();
  } 


  /* Archive introspection code. Introspects an uploaded archive for lesson 
  * data and creates a lesson if possible. 
  */
  
  cocoon.log.info("Introspecting archive");
  
  var uploadHelper = new UploadHelper("/tmp");
  var factory = Packages.javax.xml.parsers.DocumentBuilderFactory.newInstance();
  factory.setNamespaceAware(true);
  var builder = factory.newDocumentBuilder(); 
  var dom = null;
  var zip = null;

  try {
  
    /* Create zip object from uploaded data */
    var file = uploadHelper.save(cocoon.request, "upload-file");
    zip = new ZipFile(file);
    var entries = zip.entries();

    if (!entries.hasMoreElements()) {
    
      /* Emtpy archive uploaded. Send error screen. */
      var msg = "Zip archive empty";
      cocoon.log.warning(msg);
      cocoon.sendPage("error.jx", {"msg" : msg});  
      return;
    }

    /** Parsing zip for eLML source files by looking at the document root element.
    ** FIXME: currently the first language is imported. Choosing from  
    ** different language versions should be supported 
    */

    cocoon.log.info("Looking for eLML source files within archive");
    
    var hasLesson = false;
    
    for (entries; entries.hasMoreElements();) {
      var entry = entries.nextElement();
      if (!entry.isDirectory() && entry.getName().indexOf(".xml") == entry.getName().length() - 4) {
        var is = zip.getInputStream(entry);
        try {
          var tmp = builder.parse(is);
          if (tmp.documentElement.nodeName == "lesson" && tmp.documentElement.namespaceURI == "http://www.elml.ch") {
            dom = tmp;
            cocoon.log.info("Found lesson document.");
            hasLesson = true;
            break;
          } 
        } catch (e) {
          cocoon.log.error(e);
        } finally {
          is.close();
        }
      }
    }
    
    /* Send error page if no lesson data found */
    if (!hasLesson) {      
      cocoon.log.warning("Archive does not contain eLML lesson");
      var msg = "Archive does not contain eLML lesson. Please check that eLML source files are provided and eventually check namespace definitions (should read: xmlns=\"http://www.elml.ch\")";
      cocoon.sendPage("error.jx", {"msg" : msg});  
      return; 
    }


    /** Building lenya documents based on lesson data. Note that the eLML lesson is split into seperate  
    ** documents of type unit | selfAssessement | furtherReading | glossary | bibliography. 
    **/
    
    cocoon.log.info("Building documents from uploaded lesson data");

    var parts = new ArrayList();
    var partsInfo = new ArrayList();
    var nodes = dom.documentElement.childNodes;

    /* Extract document fragments contained in lesson childNodes */
    for (var i = 0; i < nodes.length; i++) {
      var node = nodes.item(i);
      
      // FIXME: Add custom metadata handling
      if (node.nodeName.indexOf("metadata") > -1) {
        dom.documentElement.removeChild(node);
        i--;
        continue;
      }

      /* Extract lesson fragments that will be converted to lenya documents. Display confirmation screen 
      ** with information about the fragments. 
      ** Note: elml:entry and elml:goals are kept within the lesson document. 
      */
      if (!(node.nodeName.indexOf("entry") > -1 || node.nodeName.indexOf("goals") > -1) && node.nodeType == 1) {

        cocoon.log.info("Build document from lesson fragment");
        var frgDOM = builder.newDocument();
        var clonedNode = frgDOM.importNode(node, true);

        frgDOM.appendChild(clonedNode);
        parts.add(frgDOM);

        var documentElement = frgDOM.documentElement;
        var doctypeInfo = null;
        var doctype;
        var label = null;
        var title = null;
        var unCount = 0;
        var saCount = 0;
        var suCount = 0;
        var glossCount = 0;
        var bibCount = 0;
        var frCount = 0;
        var currentCount = 0;

        /* Gathering information about the current fragment for the confirmation screen */ 
        /** FIXME: test for node.nodeName && node.namespaceURI **/
        if (documentElement.nodeName.indexOf("unit") > -1) {
          doctypeInfo = "Unit";
          doctype = "unit";
          unCount++;
          currentCount = unCount;
        } else if (documentElement.nodeName.indexOf("selfAssessment") > -1) {
          doctypeInfo = "Self Assessment";
          doctype = "selfAssessment";
          saCount++;
          currentCount = saCount;
        } else if (documentElement.nodeName.indexOf("summary") > -1) {
          doctypeInfo = "Summary";
          doctype = "summary";
          suCount++;
          currentCount = suCount;
        } else if (documentElement.nodeName.indexOf("glossary") > -1) {
          doctypeInfo = "Glossary";
          doctype = "glossary";
          glossCount++;
          currentCount = glossCount;
        } else if (documentElement.nodeName.indexOf("bibliography") > -1) {
          doctypeInfo = "Bibliography";
          doctype = "bibliography";
          bibCount++;
          currentCount = bibCount;
        } else if (documentElement.nodeName.indexOf("furtherReading") > -1) {
          doctypeInfo = "Further reading";
          doctype = "furtherReading";
          frCount++;
          currentCount = frCount;
        } else if (documentElement.nodeName.indexOf("bibliography") > -1) {
          doctypeInfo = "Bibliography";
          doctype = "bibliography";
          bibCount++;
          currentCount = bibCount;
        } else {
          doctypeInfo = "Unknown doctype";
          doctype = null;
          currentCount = null;
        }

        if (documentElement.hasAttribute("label")) {
          label = documentElement.getAttribute("label");
          
          // remove special characters in document names/labels 
          var jslabel = new String(label);
          label = jslabel.replace(/[^a-zA-Z0-9]/g, "");
          documentElement.setAttribute("label", label);
          
        } else {
          if (currentCount > 1) {
            label = doctypeInfo + " " + currentCount;
          } else {
            label = doctypeInfo;
          }
        }
       
        if (documentElement.hasAttribute("title")) {
          title = documentElement.getAttribute("title");
        } else {
          if (currentCount > 1) {
            title = doctypeInfo + " " + currentCount;
          } else {
            title = doctypeInfo;
          }
        }

        partsInfo.add({
                    "doctypeInfo" : doctypeInfo,
                    "label" : label,
                    "title" : title,
                    "doctype" : doctype
        });

        dom.documentElement.removeChild(node);
        i--;
      }
    }

  } catch (e) {
    cocoon.log.error(e);
    cocoon.sendPage("error.jx", {"msg" : e});
    return;
  }


  /** Send a confirmation screen with information about the to be created documents **/
  cocoon.log.info("Sending confirmation page");

  cocoon.sendPageAndWait("create.jx", {"zipEntry" : entry, "dom" : dom, "partsInfo" : partsInfo});

  /* Test for cancel operation and redirect to the page the usecase was executed */
  if (cocoon.request.get("submit") == "cancel") {
    cocoon.redirectTo(referer);
    return; 
  }
  

  /** Creating lenya documents from lesson fragments **/

  cocoon.log.info("Creating documents");

  var flowHelper = new FlowHelper();
  var pageEnvelope = flowHelper.getPageEnvelope(cocoon);
  var documentHelper = flowHelper.getDocumentHelper(cocoon);
  var doc = pageEnvelope.getDocument();
  var publication = pageEnvelope.getPublication();
  var authoringDir = "content" + File.separator + "authoring";
  var authoringDirectory =  new File(publication.getDirectory(), authoringDir);
  var documentCreator = new DocumentCreator();  
 
  var domToDocumentMap = new Array();
 
 
  /* Create documents and add them to domToDocumentMap for later processing */ 
 
  var lessonId = null;
  var lessonTitle = null;
  if (dom.documentElement.hasAttribute("label")) {
    lessonId = dom.documentElement.getAttribute("label");
      
    // remove special characters in document names/labels 
    var jslabel = new String(lessonId);
    lessonId = jslabel.replace(/[^a-zA-Z0-9]/g, "");
    dom.documentElement.setAttribute("label", jslabel);
    
  } else if (dom.documentElement.hasAttribute("title")) {
    lessonId = dom.documentElement.getAttribute("title");
    
    // remove special characters in document names/labels 
    var jslabel = new String(lessonId);
    lessonId = jslabel.replace(/[^a-zA-Z0-9]/g, "");
    dom.documentElement.setAttribute("label", jslabel);
    
  } else {
    lessonId = "lesson";
  }

  if (dom.documentElement.hasAttribute("title")) {
    lessonTitle = dom.documentElement.getAttribute("title");
  } else {
    lessonTitle = "Lesson Title";
  }


  var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);

  if (doc.getId() == "/index") {
    var parentId = "/";
    var delimiter = "";
  } else {
    var parentId = doc.getId();
    var delimiter = "/";
  }

 
  documentCreator.create(publication, authoringDirectory, "authoring", parentId, lessonId, lessonTitle , "leaf", "lesson", "de", true);
  
  var createdDoc = buildDocument(parentId + delimiter + lessonId, "de"); 
  var lessonURL = pageEnvelope.getContext() + createdDoc.getCompleteURL();

  // Add lesson dom and document to domToDocumentMap 
  domToDocumentMap.push (new Array(dom, createdDoc));

  for (var i = 0; i < partsInfo.size(); i++) {
     var label = new Packages.java.lang.String(partsInfo.get(i).label);
     var title = partsInfo.get(i).title;
     var doctype = partsInfo.get(i).doctype;

     var partId = label.replaceAll("\\s+", "");
     cocoon.log.debug("Creating document with id: " + partId + " and Doctype: " + doctype);
  
     documentCreator.create(publication, authoringDirectory, "authoring", parentId + delimiter + lessonId, partId, title, "leaf", doctype, "de", true); 

     var partDocumentId = parentId + delimiter + lessonId + "/" + partId;
     var createdDoc = buildDocument(partDocumentId, "de");
     domToDocumentMap.push (new Array(parts.get(i), createdDoc));
  }
  
  /** Pre-Processing: process dom fragments before serializing to documents **/
  
      
  /* Serialize DOM fragments to documents */
  
  for (var i=0; i < domToDocumentMap.length; i++) {
    
    var dom = domToDocumentMap[i][0];
    var document = domToDocumentMap[i][1];
    
    createAssets(zip, dom, document); // FIXME: add assets to confirmation page
    
    var sourceUri = documentHelper.getSourceUri(document);  
    var source = resolver.resolveURI(sourceUri); 
    var out = source.getOutputStream();
    cocoon.log.error("Serializing dom to: " + out);
    cocoon.processPipelineTo("createdocument",  {"dom" : dom} , out);  
    out.close();  
  }

  cocoon.sendPage("confirmation.jx", {"url" : lessonURL});
}


function createAssets(zip, dom, doc) {

  var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);
  var multimediaNodes = dom.getElementsByTagName("multimedia");
  var multimediaNodesNS = dom.getElementsByTagNameNS("http://www.elml.ch", "multimedia");
 
  for (var i = 0; i < multimediaNodes.length; i++) {
    var node = multimediaNodes.item(i);
    var src = node.getAttribute("src");
    var thumbnail = null;
    if (node.hasAttribute("thumbnail")) {
      thumbnail = node.getAttribute("thumbnail");
    }
    
    var assetName = src.substring(src.lastIndexOf("/") + 1);
    node.setAttribute("src", assetName);
    cocoon.log.error("src was: " + src + " rewritten to: " + node.getAttribute("src"));
    
    var thumbnailName = null;
    if (thumbnail != null) {
      thumbnailName = thumbnail.substring(thumbnail.lastIndexOf("/") + 1);
      node.setAttribute("thumbnail", thumbnailName);
      cocoon.log.error("thumbnail was: " + thumbnail + " rewritten to: " + node.getAttribute("thumbnail"));
    }
   
    var entries = zip.entries();

    for (entries; entries.hasMoreElements();) {
      var entry = entries.nextElement();
      if (thumbnailName != null && entry.getName().indexOf(thumbnailName) > -1) {
        assetName = thumbnailName;
      }
      if (entry.getName().indexOf(assetName) > -1) {
        var is = zip.getInputStream(entry);  // FIXME: eventually use zipSource
        var resManager = new ResourcesManager(doc);
        var dir = resManager.getPath();
        var path = dir +  File.separator + assetName;
        var source = resolver.resolveURI(path);
        var out = source.getOutputStream();

        var buffer = new java.lang.reflect.Array.newInstance(java.lang.Byte.TYPE, 1024);
        var len;

        while((len = is.read(buffer)) >= 0)
          out.write(buffer, 0, len);

        is.close();
        out.close();

        // Generate asset meta file

        var metasrc = resolver.resolveURI(path + ".meta");
        out = metasrc.getOutputStream();

        var suffix = assetName.substring(assetName.indexOf(".") + 1);
        cocoon.log.error("suffix is : " + suffix);
        var mimeType = null;
        if (suffix.equals("jpeg") || suffix.equals("jpg")) {
           mimeType = "image/jpg";
        } else if (suffix.equals("gif")) {
           mimeType = "image/gif";
        } else if (suffix.equals("png")) {
           mimeType = "image/png";
        } else if (suffix.equals("swf")) {
           mimeType = "application/x-shockwave-flash";
        } else {
           mimeType = "unknown";
        }

        var title = assetName.substring(0, assetName.indexOf(".")); // FIXME: elml:multimedia should provide title attribute

        cocoon.processPipelineTo("createmetadata", {"mimeType" : mimeType, "title" : title}, out);

        out.close();
      }
    }
  }

  for (var i = 0; i < multimediaNodesNS.length; i++) {

  }

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


function sendStatus(sc) {
  cocoon.sendStatus(sc);
}

