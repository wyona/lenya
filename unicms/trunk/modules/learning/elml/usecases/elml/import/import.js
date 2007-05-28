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
importClass(Packages.org.apache.lenya.cms.publication.ResourcesManager);
importClass(Packages.java.io.FileOutputStream);
importClass(Packages.org.apache.lenya.cms.publication.Label);


/** 
* Import usecase for eLML lessons. See http://www.elml.ch for information about eLML (e-Learning markup language). 
* @author Thomas Comiotto
*/

function importLesson() {

  var referer = cocoon.request.getHeader("referer");
  var uploadHelper = new UploadHelper("/tmp");
  var flowHelper = new FlowHelper();
  var pageEnvelope = flowHelper.getPageEnvelope(cocoon);
  var documentHelper = flowHelper.getDocumentHelper(cocoon);
  var parentDocument = pageEnvelope.getDocument();
  var publication = pageEnvelope.getPublication();
  var relativeAuthoringDirectoryPath = "content" + File.separator + "authoring";
  var authoringDirectory = new File(publication.getDirectory(), relativeAuthoringDirectoryPath);
  var documentCreator = new DocumentCreator();
  var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);


  var lessonDOM = null;

  cocoon.sendPageAndWait("upload.jx");
  
  if (cocoon.request.get("submit") == "cancel") {
    cocoon.redirectTo(referer);
    return; 
  }
  
  if (cocoon.request.get("upload-file") == null) {
    /* Recurse */
    importLesson();
  } 

  
  var file = uploadHelper.save(cocoon.request, "upload-file");
  var zip = new ZipFile(file);
  var entries = zip.entries();

  if (!entries.hasMoreElements()) {
    var msg = "Zip archive empty";
    cocoon.sendPage("error.jx", {"msg" : msg});  
    return;
  }
    

  var parserFactory = Packages.javax.xml.parsers.DocumentBuilderFactory.newInstance();
  parserFactory.setNamespaceAware(true);
  var domParser = parserFactory.newDocumentBuilder();
 
  var lessonDocuments = new Array();
 
  var languages = publication.getLanguages();
  var defaultLanguage = publication.getDefaultLanguage(); 

  for (entries; entries.hasMoreElements();) {
    var entry = entries.nextElement();

    var name = entry.getName();
    for (var i=0; i < languages.length; i++) {

    var language = languages[i];

      if (!entry.isDirectory() && name.indexOf(language) == name.indexOf("/") + 1 && name.indexOf(".xml") == name.length() - 4) {

        cocoon.log.error("Creating lesson for language: " + language + "\n");

        var is = zip.getInputStream(entry);

        try {
          var documentDOM = domParser.parse(is);
          var documentElement = documentDOM.documentElement;
          if (documentElement.localName == "lesson" && documentElement.namespaceURI == 'http://www.elml.ch') {
            cocoon.log.error("Adding lesson to lessons\n");
            lessonDocuments.push(new Array(language, documentDOM)); 
          } 

        } catch (e) {
          cocoon.log.error(e);
        } finally {
          is.close();
        }
      }
    }
  }
    
 
  if (lessonDocuments.length == 0) {
    var msg = "No lesson found in archive";
    cocoon.sendPage("error.jx", {"msg" : msg});
    return; 
  }


  /* Create documents  */


  for (var i=0; i < lessonDocuments.length; i++) {

    var language = lessonDocuments[i][0];
    var lessonDOM = lessonDocuments[i][1];
    var id = null;
    var title = null;

    var documentElement = lessonDOM.documentElement;

    if (documentElement.hasAttribute("label")) {
      id = documentElement.getAttribute("label");
    } else if (documentElement.hasAttribute("title")) {
      id = documentElement.getAttribute("title");
    } else {
      id = "lesson" + Date().getTime(); 
    }

    // convert to document id 
    var str = new String(id);
    id = str.replace(/[^a-zA-Z0-9]/g, "");

    if (documentElement.hasAttribute("title")) {
      title = documentElement.getAttribute("title");
    } else {
      title = "Lesson Title";
    }


    if (parentDocument.getId() == "/index") {
      var parentId = "/";
      var delimiter = "";
    } else {
      var parentId = parentDocument.getId();
      var delimiter = "/";
    }

    documentCreator.create(publication, authoringDirectory, "authoring", parentId, id, title , "leaf", "lesson", language, true);
 
    var lessonDocument = buildDocument(parentId + delimiter + id, language);
    var lessonURL = pageEnvelope.getContext() + lessonDocument.getCompleteURL();
    var sourceUri = documentHelper.getSourceUri(lessonDocument);
    var src = resolver.resolveURI(sourceUri);

    var siteTree = publication.getTree("authoring");
    var treeNode = siteTree.getNode(lessonDocument.getId());

    if (treeNode && !treeNode.getLabel(language)) {
      var label = new Label(title, language);
      treeNode.addLabel(label);
    }

    createAssets(zip, lessonDOM, lessonDocument); // FIXME: add assets to confirmation page

    var out = src.getOutputStream();
    cocoon.processPipelineTo("createdocument",  {"dom" : lessonDOM} , out);  
    out.close();

    resolver.release(src);


    // Init Workflow History. FIXME: How to remove the hack
  
    var wfSource = resolver.resolveURI("usecases/elml/import/content/workflow.xml");
    var destSource = resolver.resolveURI("content/workflow/history/authoring/" + lessonDocument.getId() + "/index_" + language + ".xml");

    var sourceUtil = Packages.org.apache.lenya.cms.cocoon.source.SourceUtil;
    sourceUtil.copy(wfSource, destSource, false);

  }

  cocoon.releaseComponent(resolver);
  cocoon.log.error("Lesson created");

  cocoon.sendPage("confirmation.jx", {"url" : lessonURL});


}


function createAssets(zip, dom, doc) {

  var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);
  var resManager = new ResourcesManager(doc);
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

