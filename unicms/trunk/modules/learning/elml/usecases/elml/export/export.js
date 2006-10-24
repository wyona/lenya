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
importClass(Packages.java.util.zip.ZipEntry);
importClass(Packages.java.util.ArrayList);
importClass(Packages.org.apache.lenya.cms.cocoon.flow.FlowHelper);
importClass(Packages.org.apache.lenya.cms.cocoon.uriparameterizer.URIParameterizer);
importClass(Packages.org.apache.avalon.framework.parameters.Parameters);
importClass(Packages.java.util.zip.ZipOutputStream);
importClass(Packages.org.apache.lenya.cms.publication.ResourcesManager);
importClass(Packages.org.apache.lenya.cms.publication.PublicationHelper);


/** Exports a eLML lesson to a eLML source package or to IMS CP format. 
**  @author Thomas Comiotto
**/


function showscreen() {

  var flowHelper = new FlowHelper();
  var pageEnvelope = flowHelper.getPageEnvelope(cocoon);
  var doc = pageEnvelope.getDocument();

  var label = doc.getLabel();
  cocoon.sendPageAndWait("select.jx", {"label" : label});

  var mode = cocoon.request.getParameter("mode");
  if (mode.equals("elml")) {
    exportELML(doc);
  } else if (mode.equals("cp")) {
    exportCP(doc);
  } else if (mode.equals("pdf")){
    exportPDF(doc);
  }

  cocoon.redirectTo(pageEnvelope.getContext() + "/" + doc.getCompleteURL());

}



/** Export to eLML Source **/

function exportELML(doc) {

  var pipelineUtil = cocoon.createObject(Packages.org.apache.cocoon.components.flow.util.PipelineUtil);
  var pub = doc.getPublication();
  var children = getChildren(doc);
  var assetPaths = new ArrayList();

  /* Parse dom from lesson document */

  var path = doc.getId() + "/index_" + doc.getLanguage() + ".xml";
  var dom = pipelineUtil.processToDOM("xml/" + path, null);

  /* Collect document assets and rewrite asset links */
  var resMgr = new ResourcesManager(doc);
  var assetsPath = resMgr.getPath().getAbsolutePath();

  var assetNodes = dom.getElementsByTagNameNS("http://www.elml.ch", "multimedia");

  for (var i = 0; i < assetNodes.length; i++) {
    var assetNode = assetNodes.item(i);
    var assetName = assetNode.getAttribute("src");
    var dir = getAssetExportDir(assetName);

    assetPaths.add({"src" : assetsPath + assetNode.getAttribute("src"), "dest" : dir + "/" + assetName});
    cocoon.log.debug("Added path: " + assetsPath + assetNode.getAttribute("src"));

    assetNode.setAttribute("src", "../" + dir + "/" + assetName); // FIXME: path configuration
  }

  /* Parse dom from lesson parts  */
  
  for (var i = 0; i < children.size(); i++) {
    var path = children.get(i).getId() + "/index_" + doc.getLanguage() + ".xml";
    var partDOM = pipelineUtil.processToDOM("xml/" + path, null);


    /* Collect assets and rewrite asset links */
    var resMgr = new ResourcesManager(children.get(i));
    var assetsPath = resMgr.getPath().getAbsolutePath();

    var assetNodes = partDOM.getElementsByTagNameNS("http://www.elml.ch", "multimedia");
    cocoon.log.error("Node count: " + assetNodes.length);
  
    for (var j = 0; j < assetNodes.length; j++) {
      var assetNode = assetNodes.item(j);
      var assetName = assetNode.getAttribute("src");
      var dir = getAssetExportDir(assetName);

      assetPaths.add({"src" : assetsPath + "/" + assetNode.getAttribute("src"), "dest" : dir + "/" + assetName});
      cocoon.log.error("Added path: " + assetsPath + "/" + assetNode.getAttribute("src"));
  
      assetNode.setAttribute("src", "../" + dir + "/" + assetName);
    }

     /* Add fragment to lesson dom */
     var cloned = dom.importNode(partDOM.documentElement, true);
     dom.documentElement.appendChild(cloned);
   }


   /* Create archive of gathered stuff */

   var filename = doc.getName() + ".zip";
   
   var resManager = new ResourcesManager(doc);
   var path = resManager.getPath().getAbsolutePath() + "/" + filename;
   var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);
   var source = resolver.resolveURI(path);

   var out = new ZipOutputStream(source.getOutputStream());
   var zipEntry = new ZipEntry(doc.getName() + "/" + doc.getLanguage() + "/text/" + doc.getName() + ".xml");
   out.putNextEntry(zipEntry);
   
   /* Serialize lesson to string */
   cocoon.processPipelineTo("dom.jx", {"dom": dom}, out);
   
   /* Copy assets */

   for (var i = 0; i < assetPaths.size(); i++) {
     var src = assetPaths.get(i).src;
     var dest = assetPaths.get(i).dest;
     var source = resolver.resolveURI(src);
     cocoon.log.error("Created source " + source);
     var is = source.getInputStream();
     var zipEntry = new ZipEntry(doc.getName() + "/" + doc.getLanguage() + "/" + dest);
     cocoon.log.error("Created entry: " + zipEntry);
     out.putNextEntry(zipEntry);
     cocoon.log.error("Reading from input stream " + is + " to output stream " + out);
     var buffer = new java.lang.reflect.Array.newInstance(java.lang.Byte.TYPE, 1024);
     var len;

     while((len = is.read(buffer)) >= 0)
       out.write(buffer, 0, len);
     is.close();
   }

   out.close();

   /* Provide download location for created archive  */

   var url = doc.getName() + "/" + filename;
   var size = Math.round(new File(path).length() / 1024) + " KB";
   cocoon.sendPageAndWait("download.jx", {"url" : url, "filename" : filename, "length": size});

}


/** Export to IMS Content Package format **/

function exportCP(doc) {

   // cocoon.sendPageAndWait("cpconf.jx", {"heading" : doc.getLabel()});

   var superscription = cocoon.request.getParameter("superscription");
   var heading = cocoon.request.getParameter("heading");

   var flowHelper = new FlowHelper();
   var documentHelper = flowHelper.getDocumentHelper(cocoon);
   var pub = doc.getPublication();
   var filename = doc.getName() + "-cp.zip";
   var resManager = new ResourcesManager(doc);
   var path = resManager.getPath().getAbsolutePath() + "/" + filename;
   var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);
   var source = resolver.resolveURI(path);

   /* Create the archive file */

   var out = new ZipOutputStream(source.getOutputStream());
   
   /* Create the IMS manifest zip entry */
   
   var zipEntry = new ZipEntry("imsmanifest.xml");
   out.putNextEntry(zipEntry);
   var children = getChildren(doc);
   cocoon.log.error("Serializing manifest for : " + doc + " " + children); 
   cocoon.processPipelineTo("manifest.jx", {"doc" : doc, "items" : children}, out);

   /* Serialize lesson to xhtml files and add to archive */

   // Serialize lesson document
   var sourceUri = documentHelper.getSourceUri(doc);
   zipEntry = new ZipEntry(doc.getName() + ".html");
   out.putNextEntry(zipEntry);
   cocoon.log.error("Serializing lesson document: " + doc.getName() + " " + sourceUri + " " + superscription + " " + heading);
  
   cocoon.processPipelineTo("xhtml/cp", {"nodeid": doc.getName(), "sourceUri": sourceUri, "superscription" : superscription, "heading" : heading, "cssdir" : "css", "jsdir" : "js", "imgdir" : "images"}, out);

   // Serialize lesson fragments 
   for (var i = 0; i < children.size(); i++) {
     var child = children.get(i);
     sourceUri = documentHelper.getSourceUri(child);
     zipEntry = new ZipEntry(child.getName() + ".html");
     cocoon.log.error("Putting output stream to first child entry");
     out.putNextEntry(zipEntry);
     cocoon.processPipelineTo("xhtml/cp", {"nodeid": child.getName(), "sourceUri": sourceUri, "superscription" : superscription, "heading" : heading, "cssdir" : "css", "jsdir" : "js", "imgdir" : "images", "assetdir" : "resources"}, out);
   }

   /* Add assets to archive */

   // Add lesson assets
   var resManager = new ResourcesManager(doc);
   var assets = resManager.getResources();
   for (var i = 0; i < assets.length; i++) {
     // FIXME: prevent deadlock by working on tmp file first.
     if(assets[i].getName().equals(filename)) continue;
 
     var source = resolver.resolveURI(assets[i].getAbsolutePath());
     var dir = null;
     if (assets[i].getName().indexOf(".swf") > -1) {  // FIXME: Test for mimeType
       dir = "resources";
     } else {
       dir = "images";
     } 
     var zipEntry = new ZipEntry(dir + "/" + assets[i].getName());
     cocoon.log.error("Created entry: " + zipEntry);
     out.putNextEntry(zipEntry);

     var is = source.getInputStream();
     cocoon.log.error("Reading from input stream " + is + " to output stream " + out);
     var buffer = new java.lang.reflect.Array.newInstance(java.lang.Byte.TYPE, 1024);
     var len;
     while((len = is.read(buffer)) >= 0)
       out.write(buffer, 0, len);
     is.close(); 
   }


   // Add assets of lesson fragments
   for (var i = 0; i < children.size(); i++) {
     var resManager = new ResourcesManager(children.get(i));
     var assets = resManager.getResources();

     for (var j = 0; j < assets.length; j++) {
       var source = resolver.resolveURI(assets[j].getAbsolutePath());
       var dir = null;
       if (assets[j].getName().indexOf(".swf") > -1) {  // FIXME: Test for mimeType            
         dir = "resources";
       } else {
         dir = "images";
       }
       var zipEntry = new ZipEntry(dir + "/" + assets[j].getName());
       cocoon.log.error("Created entry: " + zipEntry);
       out.putNextEntry(zipEntry);
     
       var is = source.getInputStream();
       cocoon.log.error("Reading from input stream " + is + " to output stream " + out);
       var buffer = new java.lang.reflect.Array.newInstance(java.lang.Byte.TYPE, 1024);
       var len;
       while((len = is.read(buffer)) >= 0)
         out.write(buffer, 0, len);
       is.close();
     }
   }

   /* Add static resources (images, css) used by document layout to the archive */

   var imgPath = pub.getDirectory().getAbsolutePath() + "/usecases/elml/export/images";
   var dir = new File(imgPath);
   var files = dir.listFiles();
   if (files != null) {
     for (var i = 0; i < files.length; i++) {
       var source = resolver.resolveURI(files[i].getAbsolutePath());
       var zipEntry = new ZipEntry("images/" + files[i].getName());
       out.putNextEntry(zipEntry);
      
       var is = source.getInputStream();
       var buffer = new java.lang.reflect.Array.newInstance(java.lang.Byte.TYPE, 1024);
       var len;
       while((len = is.read(buffer)) >= 0)
         out.write(buffer, 0, len);
       is.close();
     }
   }
    
   
  var cssPath = pub.getDirectory().getAbsolutePath() + "/usecases/elml/export/css";
   var dir = new File(cssPath);
   var files = dir.listFiles();
   if (files != null) {
     for (var i = 0; i < files.length; i++) {
       var source = resolver.resolveURI(files[i].getAbsolutePath());
       var zipEntry = new ZipEntry("css/" + files[i].getName());
       out.putNextEntry(zipEntry);

       var is = source.getInputStream();
       var buffer = new java.lang.reflect.Array.newInstance(java.lang.Byte.TYPE, 1024);
       var len;
       while((len = is.read(buffer)) >= 0)
         out.write(buffer, 0, len);
       is.close();
     }
   }

   
   var jsPath = pub.getDirectory().getAbsolutePath() + "/usecases/elml/export/js";
   var dir = new File(jsPath);
   var files = dir.listFiles();
   if (files != null) {
     for (var i = 0; i < files.length; i++) {
       var source = resolver.resolveURI(files[i].getAbsolutePath());
       var zipEntry = new ZipEntry("js/" + files[i].getName());
       out.putNextEntry(zipEntry);

       var is = source.getInputStream();
       var buffer = new java.lang.reflect.Array.newInstance(java.lang.Byte.TYPE, 1024);
       var len;
       while((len = is.read(buffer)) >= 0)
         out.write(buffer, 0, len);
       is.close();
     }
   }

   
   out.close();
  
   var url = doc.getName() + "/" + filename;
   var size = Math.round(new File(path).length() / 1024) + " KB";
   cocoon.sendPageAndWait("download.jx", {"url" : url, "filename" : filename, "length": size});

}


function exportPDF(doc) {

  var pipelineUtil = cocoon.createObject(Packages.org.apache.cocoon.components.flow.util.PipelineUtil);
  var pub = doc.getPublication();
  var children = getChildren(doc);
  var filename = doc.getName() + ".pdf";
  var resManager = new ResourcesManager(doc);
  var pdfFile = resManager.getPath().getAbsolutePath() + "/" + filename;
  var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);
  var source = resolver.resolveURI(pdfFile);

  /* Process lesson document to dom */

  var path = doc.getId() + "/index_" + doc.getLanguage() + ".xml";
  var dom = pipelineUtil.processToDOM("xml/" + path, null);


  /* Rewrite multimedia tags */

  var mmNodes = dom.getElementsByTagNameNS("http://www.elml.ch", "multimedia");

  for (var i = 0; i < mmNodes.length; i++) {
    var mmNode = mmNodes.item(i);
    var src = mmNode.getAttribute("src");

    mmNode.setAttribute("src", resManager.getPath().getAbsolutePath() + "/" + src);
  }

   /* Process lesson parts to dom  */

  for (var i = 0; i < children.size(); i++) {
    var path = children.get(i).getId() + "/index_" + doc.getLanguage() + ".xml";
    var partDOM = pipelineUtil.processToDOM("xml/" + path, null);
    var resManager = new ResourcesManager(children.get(i));

    var mmNodes = partDOM.getElementsByTagNameNS("http://www.elml.ch", "multimedia");

    for (var j = 0; j < mmNodes.length; j++) {
      var mmNode = mmNodes.item(j);
      var src = mmNode.getAttribute("src");

      mmNode.setAttribute("src", resManager.getPath().getAbsolutePath() + "/" + src);
    }

     /* Add part to lesson */
     var cloned = dom.importNode(partDOM.documentElement, true);
     dom.documentElement.appendChild(cloned);
   }


  var label = doc.getLabel();
  var units = new ArrayList();

  var unitNodes = dom.getElementsByTagNameNS("http://www.elml.ch", "unit");
  for (var i = 0; i < unitNodes.length; i++) {
    units.add(unitNodes.item(i));
  }

  cocoon.sendPageAndWait("pdf/configure.jx", {"label" : label, "units" : units});

  var role = cocoon.request.get("role");
  var publisher = cocoon.request.get("publisher");
  var author = cocoon.request.get("author");
  var url = cocoon.request.get("url");
  var pagebreak_level = cocoon.request.get("pagebreak_level");
  var chapter_numbers = cocoon.request.get("chapter_numbers");
  var optional_units = "";

  var date = new Date();
  var yearMonth = "" + date.getMonth() + ". " + date.getFullYear();

  for (var i = 0; i < unitNodes.length; i++) {
    var label = unitNodes.item(i).getAttribute("label");
    if (cocoon.request.get(label)) {
      optional_units += unitNodes.item(i).getAttribute("label");
    }
  }


   var out = source.getOutputStream();
   /* Serialize lesson to string */
   cocoon.processPipelineTo("pdf/", {"dom": dom, "date": yearMonth, "role": role, "publisher": publisher, "author" : author, "url": url, "pagebreak_level" : pagebreak_level, "chapter_numbers" : chapter_numbers, "optional_units": optional_units}, out);
   out.close();

   var url = doc.getName() + "/" + filename;
   var size = Math.round(new File(pdfFile).length() / 1024) + " KB";
   cocoon.sendPageAndWait("pdf/download.jx", {"url" : url, "filename" : filename, "length": size});

}



/** returns a directory name for asset storage **/

function getAssetExportDir(assetName) {
  // FIXME: use metadata to obtain mimeType. Define constants for dir names.
  var suffix = assetName.substring(assetName.indexOf(".") + 1);
  if (suffix.equals("jpg") || suffix.equals("jpeg") || suffix.equals("gif") || suffix.equals("png")) {
    return "image";
  } else {
    return "multimedia";
  }
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


function getDoctype(doc) {

  var parameterizer = cocoon.getComponent(URIParameterizer.ROLE);
  var parameters = new Parameters();
  parameters.setParameter("doctype", "cocoon://uri-parameter/" + doc.getPublication().getId() + "/doctype");
  var map = parameterizer.parameterize("/authoring" + doc.getDocumentURL(), "/authoring" + doc.getDocumentURL(), parameters);

  var doctype = map.get("doctype");
  return doctype;
}


function sendStatus(sc) {
  cocoon.sendStatus(sc);
}

