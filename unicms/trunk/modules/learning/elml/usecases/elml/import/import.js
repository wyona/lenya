/*
* Copyright 1999-2007 University of Zuerich  
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
  var importer = new LessonImporter(); 
  importer.importLesson(); 
}


function LessonImporter() {


}

LessonImporter.prototype = {

  importLesson: function() {

    var flowHelper = new FlowHelper();
    var pageEnvelope = flowHelper.getPageEnvelope(cocoon);
    var publication = pageEnvelope.getPublication();

    cocoon.sendPageAndWait("upload.jx");

    var submit = (cocoon.request.get("submit"));

    if (submit == "Upload") {

      var uploadFile = cocoon.request.get("upload-file");
      if (!uploadFile) 
        this.importLesson();

      var languages = publication.getLanguages();
      var lessonURI = null;

      var uploadHelper = new UploadHelper("/tmp");
      var file = uploadHelper.save(cocoon.request, "upload-file");
      var zipFile = new ZipFile(file);
      var archive = new LessonArchive(zipFile);


      for (var i=0; i < languages.length; i++) {
        var language = languages[i];
        var lessonDOM = archive.getLessonDOM(language);
       
        if (lessonDOM) {
          var lesson = this.createLesson(lessonDOM, language);
          if (lesson) {
            this.createAssets(lesson, lessonDOM, zipFile);

            if (language == publication.getDefaultLanguage() || !lessonURI) 
              lessonURI = lesson.getCompleteURL();
          }
        }
      }


      if (lessonURI) {
        cocoon.sendPage("confirmation.jx", {"url" : lessonURI});
        return; 
      } else {
        var msg = "Import failed. Either the zip file does not contain any lesson files or the lesson data does not match a language supported by the CMS.";
        cocoon.sendPage("error.jx", {"msg" : msg});
        return; 
      }
    }

    cocoon.redirectTo(cocoon.request.getHeader("referer")); 

  },


  createLesson: function(aLessonDOM, aLanguage) {

    var flowHelper = new FlowHelper();
    var pageEnvelope = flowHelper.getPageEnvelope(cocoon);
    var publication = pageEnvelope.getPublication();

    var documentCreator = new DocumentCreator();
    var documentHelper = flowHelper.getDocumentHelper(cocoon);
    var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);

    var id = null;
    var title = null;
    var parentDocument = pageEnvelope.getDocument();
    var relativeAuthoringDirectoryPath = "content" + File.separator + "authoring";
    var authoringDirectory = new File(publication.getDirectory(), relativeAuthoringDirectoryPath);

    var documentElement = aLessonDOM.documentElement;

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

    // rewrite multimedia paths

    var multimediaNodes = documentElement.getElementsByTagName("multimedia"); 
     
    for (var i=0; i <  multimediaNodes.length; i++) {
      var node = multimediaNodes.item(i); 
      if (node.hasAttribute("src")) {
        var src = node.getAttribute("src"); 
        node.setAttribute("src", src.substring(src.lastIndexOf("/") + 1));  
      }
    }

    documentCreator.create(publication, authoringDirectory, "authoring", parentId, id, title , "leaf", "lesson", aLanguage, true);

    var lessonDocument = this.buildDocument(parentId + delimiter + id, aLanguage);
    var lessonURL = pageEnvelope.getContext() + lessonDocument.getCompleteURL();
    var sourceURL = documentHelper.getSourceUri(lessonDocument);
    var src = resolver.resolveURI(sourceURL);

    var siteTree = publication.getTree("authoring");
    var treeNode = siteTree.getNode(lessonDocument.getId());

    if (treeNode && !treeNode.getLabel(aLanguage)) {
      var label = new Label(title, aLanguage);
      treeNode.addLabel(label);
    }

    var out = src.getOutputStream();
    cocoon.processPipelineTo("createdocument",  {"dom" : aLessonDOM} , out);
    out.close();

    resolver.release(src);

    // Init Workflow History. FIXME: Remove the hack

    var wfSource = resolver.resolveURI("usecases/elml/import/content/workflow.xml");
    var destSource = resolver.resolveURI("content/workflow/history/authoring/" + lessonDocument.getId() + "/index_" + aLanguage + ".xml");

    var sourceUtil = Packages.org.apache.lenya.cms.cocoon.source.SourceUtil;
    sourceUtil.copy(wfSource, destSource, false);

    return lessonDocument; 

  },  


  createAssets: function (aLesson, aLessonDOM, aZip) {

    var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);
    var resManager = new ResourcesManager(aLesson);

    var multimediaNodes = aLessonDOM.getElementsByTagName("multimedia");

    for (var i=0; i < multimediaNodes.length; i++) {
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

      var entries = aZip.entries();

      while (entries.hasMoreElements()) {
        var entry = entries.nextElement();
        if (thumbnailName != null && entry.getName().indexOf(thumbnailName) > -1) {
          assetName = thumbnailName;
        }

        if (entry.getName().indexOf(assetName) > -1) {
          var is = aZip.getInputStream(entry);  // FIXME: eventually use zipSource
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

          switch(suffix) {
            case "jpeg": 
              mimeType = "image/jpg"; 
              break;
            case "jpg": 
              mimeType = "image/jpg"; 
              break; 
            case "gif": 
              mimeType = "image/gif"; 
              break;
            case "png": 
              mimeType = "image/png"; 
              break;
            case "flash": 
              mimeType = "application/x-shockwave-flash";
              break;
            default: 
              mimeType = "unknown";  
          }

          var title = assetName.substring(0, assetName.indexOf(".")); // FIXME: elml:multimedia should provide title attribute

          cocoon.processPipelineTo("createmetadata", {"mimeType" : mimeType, "title" : title}, out);

          out.close();
        }
      }
    }
  }, 


  buildDocument: function (aID, aLanguage) {

    var flowHelper = new FlowHelper();
    var pageEnvelope = flowHelper.getPageEnvelope(cocoon);
    var pub = pageEnvelope.getPublication();
    var documentBuilder = pub.getDocumentBuilder();
    var documentHelper = flowHelper.getDocumentHelper(cocoon);

    var url = documentHelper.getDocumentUrl(aID, "authoring", aLanguage);
    if (url.indexOf("lenya") > -1) {
      url = url.substring(6); // FIXME: obtain prefix
    }

    var doc = documentBuilder.buildDocument(pub, url);
    return doc;

  }

}; 


function LessonArchive(aZipFile) {

  this.zipFile = aZipFile; 

  var parserFactory = Packages.javax.xml.parsers.DocumentBuilderFactory.newInstance();
  parserFactory.setNamespaceAware(true);

  var domParser = parserFactory.newDocumentBuilder();
  this.domParser = domParser; 

}


LessonArchive.prototype = {

  zipFile: null,
  domParser: null,


  getLessonDOM: function (aLanguage) {


    var zipFile = this.zipFile; 
    var lessonDOM = null; 

    if (zipFile && zipFile.entries()) {

      var entries = zipFile.entries();

      while (entries.hasMoreElements()) {

        var entry = entries.nextElement();

        var name = new String(entry.getName());
        var pathSegments = name.split("/"); 

        if (pathSegments[1] == aLanguage && name.indexOf(".xml") == name.length - 4) {

          cocoon.log.debug("Creating lesson for language: " + aLanguage + "\n");

          var is = zipFile.getInputStream(entry);
          var domParser = this.domParser; 

          try {
            var xmlDOM = domParser.parse(is);
            var documentElement = xmlDOM.documentElement;

            if (documentElement.localName == "lesson" && documentElement.namespaceURI == 'http://www.elml.ch') {
              lessonDOM = xmlDOM;  
            }
          } catch (e) {
            cocoon.log.error(e);
          } finally {
            is.close();
          }
        }
      }
    }


    return lessonDOM; 

  },

  getAssets: function(aLanguage) {


  }

};



function sendStatus(sc) {
  cocoon.sendStatus(sc);
}

