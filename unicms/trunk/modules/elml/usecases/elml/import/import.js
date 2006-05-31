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


function importLesson() {

  cocoon.sendPageAndWait("upload.jx");

  var uploadHelper = new UploadHelper("/tmp");
  var builder = Packages.javax.xml.parsers.DocumentBuilderFactory.newInstance().newDocumentBuilder(); 
  var dom = null;
  var zip = null;

  try {
    var file = uploadHelper.save(cocoon.request, "upload-file");
    zip = new ZipFile(file);
    var entries = zip.entries();

    for (entries; entries.hasMoreElements();) {
      var entry = entries.nextElement();
      if (!entry.isDirectory() && entry.getName().indexOf(".xml") == entry.getName().length() - 4) {
        var is = zip.getInputStream(entry);
        try {
          var tmp = builder.parse(is);
          if (tmp.documentElement.nodeName.indexOf("lesson") > -1) dom = tmp;
        } catch (e) {
          cocoon.log.error("Cant parse document");
        } finally {
          is.close();
        }
      }
    }

    var parts = new ArrayList();
    var partsInfo = new ArrayList();
    var nodes = dom.documentElement.childNodes;

    for (var i = 0; i < nodes.length; i++) {
      var node = nodes.item(i);
      cocoon.log.error("Current node name: " + node.nodeName);

      // FIXME: handle metadata 
      if (node.nodeName.indexOf("metadata") > -1) {
        dom.documentElement.removeChild(node);
        i--;
        continue;
      }
      // FIXME: add summary doctype
      if (node.nodeName.indexOf("summary") > -1) { 
        dom.documentElement.removeChild(node);
        i--;
        continue;
      }

      if (!(node.nodeName.indexOf("entry") > -1 || node.nodeName.indexOf("goals") > -1) && node.nodeType == 1) {
        cocoon.log.error("Building document from fragment");
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
       
        cocoon.log.error("Collecting infos");
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
        cocoon.log.error("Adding infos..");
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
    cocoon.sendPage("error.jx");
  }


  cocoon.log.error("Sending page and wait.");
  cocoon.sendPageAndWait("create.jx", {"zipEntry" : entry, "dom" : dom, "partsInfo" : partsInfo});
  cocoon.log.error("Creating documents");

  var authoringDir = "content" + File.separator + "authoring";
  cocoon.log.error("authoring dir" + authoringDir);
  var flowHelper = new FlowHelper();
  var pageEnvelope = flowHelper.getPageEnvelope(cocoon);
  var documentHelper = flowHelper.getDocumentHelper(cocoon);
  var doc = pageEnvelope.getDocument();
  var publication = pageEnvelope.getPublication();
  var authoringDirectory =  new File(publication.getDirectory(), authoringDir);

  var documentCreator = new DocumentCreator();  
  var lessonId = null;
  var lessonTitle = null;
  if (dom.documentElement.hasAttribute("label")) {
    lessonId = dom.documentElement.getAttribute("label");
  } else if (dom.documentElement.hasAttribute("title")) {
    lessonId = dom.documentElement.getAttribute("title");
  } else {
    lessonId = "lesson";
  }

  if (dom.documentElement.hasAttribute("title")) {
    lessonTitle = dom.documentElement.getAttribute("title");
  } else {
    lessonTitle = "Lesson Title";
  }

  lessonId = lessonId.replaceAll("\\s+","");

  var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);

  documentCreator.create(publication, authoringDirectory, "authoring", doc.getId(), lessonId, lessonTitle , "leaf", "lesson", "de", true);

  var createdDoc = buildDocument(doc.getId() + "/" + lessonId, "de"); 
  var url = documentHelper.getSourceUri(createdDoc);
  var lessonURL = pageEnvelope.getContext() + createdDoc.getCompleteURL();
  cocoon.log.error("Created doc url: " + url);

  createAssets(zip, dom, createdDoc, true); // FIXME: move confirmation info to options page

  var source = resolver.resolveURI(url); 
  var out = source.getOutputStream();
  cocoon.log.error("Processing pipeline to: " + out);
  cocoon.processPipelineTo("createdocument",  {"dom" : dom} , out);  
  out.close();


  for (var i = 0; i < partsInfo.size(); i++) {
   var label = new Packages.java.lang.String(partsInfo.get(i).label);
   var title = partsInfo.get(i).title;
   var doctype = partsInfo.get(i).doctype;

   var partId = label.replaceAll("\\s+", "");
   cocoon.log.error("Creating part document with id: " + partId + " and Doctype: " + doctype);
  
   documentCreator.create(publication, authoringDirectory, "authoring", doc.getId() + "/" + lessonId, partId, title, "leaf", doctype, "de", true); 

   var partDocumentId = doc.getId() + "/" + lessonId + "/" + partId;
   var createdDoc = buildDocument(partDocumentId, "de");
   var url = documentHelper.getSourceUri(createdDoc);
   cocoon.log.error("Created part url: " + url);

   createAssets(zip, parts.get(i), createdDoc, true);

   var source = resolver.resolveURI(url);
   var out = source.getOutputStream();
   cocoon.log.error("Processing pipline to: " + out);
   cocoon.processPipelineTo("createdocument", {"dom" : parts.get(i)}, out);
   out.close();
  } 
 
  cocoon.sendPage("confirmation.jx", {"url" : lessonURL});
}



function createAssets(zip, dom, doc, rewriteLinks) {

  var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);
  var assetNodes = dom.getElementsByTagName("multimedia");
  var assetNodesNS = dom.getElementsByTagNameNS("http://www.elml.ch", "multimedia");
  
  for (var i = 0; i < assetNodes.length; i++) {
    var node = assetNodes.item(i);
    var src = node.getAttribute("src");
    var assetName = src.substring(src.lastIndexOf("/") + 1);
    node.setAttribute("src", assetName);
    cocoon.log.error("src was: " + src + " rewritten to: " + node.getAttribute("src"));
    var entries = zip.entries();

    for (entries; entries.hasMoreElements();) {
      var entry = entries.nextElement();
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

  for (var i = 0; i < assetNodesNS.length; i++) {

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

