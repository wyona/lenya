/** Exports eLML lesson to: eLML source package, IMS CP, pdf
**  @author Thomas Comiotto
**/


importClass(Packages.java.io.File);
importClass(Packages.java.util.zip.ZipEntry);
importClass(Packages.java.util.ArrayList);
importClass(Packages.org.apache.lenya.cms.cocoon.flow.FlowHelper);
importClass(Packages.org.apache.lenya.cms.cocoon.uriparameterizer.URIParameterizer);
importClass(Packages.org.apache.avalon.framework.parameters.Parameters);
importClass(Packages.java.util.zip.ZipOutputStream);
importClass(Packages.org.apache.lenya.cms.publication.ResourcesManager);
importClass(Packages.org.apache.lenya.cms.publication.PublicationHelper);


function selectExportMode() {

  /* Obtain document from page envelope */
  var flowHelper = new FlowHelper();
  var doc = flowHelper.getPageEnvelope(cocoon).getDocument();

  /* Send mode selection screen */
  var label = doc.getLabel();
  cocoon.sendPageAndWait("select.jx", {"label" : label});

  /* Enter requested export mode  */
  var mode = cocoon.request.getParameter("mode");

  if (mode.equals("source")) {
    exportSource(doc);
  } else if (mode.equals("cp")) {
    exportCP(doc);
  } else if (mode.equals("pdf")){
    exportPDF(doc);
  }
}



/* Export to eLML Source */

function exportSource(doc) {

  var pipelineUtil = cocoon.createObject(Packages.org.apache.cocoon.components.flow.util.PipelineUtil);
  var flowHelper = new FlowHelper();
  var pageEnvelope = flowHelper.getPageEnvelope(cocoon);


  var pub = doc.getPublication();
  var languages = new Array();

  var filename = doc.getName() + ".zip";
  
  var resManager = new ResourcesManager(doc);
  var zipPath = resManager.getPath().getAbsolutePath() + "/" + filename;
  var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);
  var source = resolver.resolveURI(zipPath);

  var out = new ZipOutputStream(source.getOutputStream());

  var languages = doc.getLanguages();

  for (var i=0; i < languages.length; i++) { 

    var language = languages[i];
    var lessonPath = doc.getId() + "/index_" + language + ".xml";
    var assets = new ArrayList();

    cocoon.log.error("Current language: " + language + "\n");

    var lessonDOM = pipelineUtil.processToDOM("xml/" + lessonPath, null);
    var lessonNode = lessonDOM.getElementsByTagNameNS("http://www.elml.ch", "lesson").item(0);

    var resMgr = new ResourcesManager(doc);
    var assetsPath = resMgr.getPath().getAbsolutePath();
    var assetNodes = lessonNode.getElementsByTagNameNS("http://www.elml.ch", "multimedia");

    for (var j = 0; j < assetNodes.length; j++) {
      var assetNode = assetNodes.item(j);
      var assetName = assetNode.getAttribute("src");
      var dir = getAssetExportDir(assetName);
      var asset = new File(assetsPath + "/" + assetName);

      if (asset.exists()) {
        cocoon.log.error("Asset exists: " + asset.exists());
          
        assets.add({"src" : assetsPath + "/" + assetName, "dest" : dir + "/" + assetName});
        assetNode.setAttribute("src", "../" + dir + "/" + assetName); // FIXME: path configuration
      }
    }

    var zipEntry = new ZipEntry(doc.getName() + "/" + language + "/text/" + doc.getName() + ".xml");
    out.putNextEntry(zipEntry);
   
    cocoon.processPipelineTo("lesson.jx", {"dom": lessonNode}, out);

    for (var j = 0; j < assets.size(); j++) {
      var src = assets.get(j).src;
      var dest = assets.get(j).dest;
      var source = resolver.resolveURI(src);
      var is = source.getInputStream();
      
      var assetName = doc.getName() + "/" + language + "/" + dest;
      cocoon.log.error("Asset: " + assetName + "\n");
      var zipEntry = new ZipEntry(assetName);
      out.putNextEntry(zipEntry);
      var buffer = new java.lang.reflect.Array.newInstance(java.lang.Byte.TYPE, 1024);
      var len;

      while((len = is.read(buffer)) >= 0)
        out.write(buffer, 0, len);
      is.close();
      
    } 

  }

  out.close();


  var url = doc.getName() + "/" + filename;
  var size = Math.round(new File(zipPath).length() / 1024) + " KB";
  cocoon.sendPageAndWait("download.jx", {"url" : url, "filename" : filename, "length": size});

  cocoon.redirectTo(pageEnvelope.getContext() + "/" + doc.getCompleteURL());

}



 /** Export to IMS Content Package format **/

function exportCP(doc) {

   var pipelineUtil = cocoon.createObject(Packages.org.apache.cocoon.components.flow.util.PipelineUtil);
   var sourceUtil = Packages.org.apache.lenya.cms.cocoon.source.SourceUtil;
   var flowHelper = new FlowHelper();
   var documentHelper = flowHelper.getDocumentHelper(cocoon);
   var pub = doc.getPublication();
   var filename = doc.getName() + "-cp.zip";
   var resManager = new ResourcesManager(doc);
   var path = pub.getDirectory().getAbsolutePath() + "/usecases/elml/export/data/" + filename;
   var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);
   var source = resolver.resolveURI(path);

   var documentPath = doc.getId() + "/index_" + doc.getLanguage() + ".xml";
   var lessonDOM = pipelineUtil.processToDOM("xml/" + documentPath, null);
   var lessonNode = lessonDOM.getElementsByTagNameNS("http://www.elml.ch", "lesson").item(0);

   var headerHeading = lessonNode.getAttribute("title");
   cocoon.sendPageAndWait("cp-config.jx", {"header_heading" : headerHeading});
 
   headerHeading = cocoon.request.get("header_heading");
   var pagebreakLevel = cocoon.request.get("pagebreak_level");
   var headerSuperscription = cocoon.request.get("header_superscription");

   var omitHeader = "false";
   if(cocoon.request.get("omit_header")) {
     omitHeader = "true";
   };


   var sectionNodes = new Array();

  if (pagebreakLevel == "unit") {
   
     var childNodes = lessonNode.childNodes;
   
     for (var i=0; i < childNodes.length; i++) {
       var childNode = childNodes.item(i);
       var localName = childNode.localName;

       if (localName == "unit" ||
           localName == "summary" ||
           localName == "selfAssessment" ||
           localName == "furtherReading" ||
           localName == "glossary" ||
           localName == "bibliography") {
         sectionNodes.push(childNode);
       }
     }
   }

   // circumvent concurrency check
   var tmpSource = resolver.resolveURI(path + ".tmp");
   if (tmpSource.exists())
     tmpSource["delete"]();

   var out = new ZipOutputStream(source.getOutputStream());


   var lessonLabel = lessonNode.getAttribute("label");
   var lessonTitle = lessonNode.getAttribute("title");
   var sections = new Array();

   for (var i = 0; i < sectionNodes.length; i++) {

     var node = sectionNodes[i];
     var label = null;
     var title = null;

     if (node.hasAttribute("label")) {
       label = node.getAttribute("label");
     } else {
       label = node.localName;
     }

     if (node.hasAttribute("title")) {
       title = node.getAttribute("title");
     } else {
       var messages = lessonDOM.getElementsByTagName("msg");
       var hasMessage = false;

       for (var j=0; j < messages.length; j++) {
         if (messages.item(j).getAttribute("name") == "name_" + node.localName) {
           title = messages.item(j).textContent;
           hasMessage = true;
           break;
         }
       }

       if (!hasMessage) {
         title = node.localName;
       }
     }

     var section = new Object();
     section.label = label;
     section.title = title;
     section.type = node.localName;
     sections.push(section);
   }


   /* Document */
   var zipEntry = new ZipEntry("imsmanifest.xml");
   out.putNextEntry(zipEntry);
   cocoon.processPipelineTo("manifest.jx", {"lessonLabel" : lessonLabel, "lessonTitle": lessonTitle, "sections" : sections}, out);


   zipEntry = new ZipEntry(lessonLabel + ".html");
   out.putNextEntry(zipEntry);
   cocoon.processPipelineTo("xhtml/cp", {
     "pagebreak_level": pagebreakLevel,
     "section": "",
     "label": "",
     "cssdir" : "css",
     "jsdir" : "js",
     "imgdir" : "images",
     "assetdir": "resources",
     "header_heading": headerHeading,
     "header_superscription": headerSuperscription,
     "omit_header": omitHeader},
      out);

   for (var i=0; i < sections.length; i++) {
     var section = sections[i];
     zipEntry = new ZipEntry(section.label + ".html");
     cocoon.log.error("Section entry: " + zipEntry + "\n");
     out.putNextEntry(zipEntry);
     cocoon.log.error("Creating section: " + pagebreakLevel + ", " + section.type + ", " + section.label + "\n");
     cocoon.processPipelineTo("xhtml/cp", {
       "pagebreak_level": pagebreakLevel,
       "current_section": section.type,
       "current_label": section.label,
       "cssdir" : "css",
       "jsdir" : "js",
       "imgdir" : "images",
       "assetdir": "resources", 
       "header_heading": headerHeading, 
       "header_superscription": headerSuperscription,
       "omit_header": omitHeader},
       out);
   }


   /* Resources */
   var assets = resManager.getResources();
   for (var i = 0; i < assets.length; i++) {

     var source = resolver.resolveURI(assets[i].getAbsolutePath());
     var dir = null;

     if (assets[i].getName() == filename) continue;  // exclude existing cp-archive from being copied into new archive

     if (assets[i].getName().indexOf(".swf") > -1) {  // FIXME: Test for mimeType
       dir = "resources";
     } else {
       dir = "images";
     }
     var zipEntry = new ZipEntry(dir + "/" + assets[i].getName());
     out.putNextEntry(zipEntry);

     var is = source.getInputStream();
     var buffer = new java.lang.reflect.Array.newInstance(java.lang.Byte.TYPE, 1024);
     var len;
     while((len = is.read(buffer)) >= 0)
       out.write(buffer, 0, len);
     is.close();
   }


   /* Add static resources (images, css) used by document layout to the archive */

   var imgPath = pub.getDirectory().getAbsolutePath() + "/usecases/elml/export/cp/resources/images";
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
    
   
  var cssPath = pub.getDirectory().getAbsolutePath() + "/usecases/elml/export/cp/resources/css";
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

   
   var jsPath = pub.getDirectory().getAbsolutePath() + "/usecases/elml/export/cp/resources/js";
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
 
   var destPath = resManager.getPath().getAbsolutePath() + "/" + filename;
   var tmpDest = resolver.resolveURI(destPath + ".tmp");
   if (tmpDest.exists())
     tmpDests["delete"]();
 
   sourceUtil.copy(resolver, path, destPath);


   var url = doc.getName() + "/" + filename;
   var size = Math.round(new File(path).length() / 1024) + " KB";
   cocoon.sendPageAndWait("download.jx", {"url" : url, "filename" : filename, "length": size});

   cocoon.redirectTo(pageEnvelope.getContext() + "/" + doc.getCompleteURL());

}


function exportPDF(doc) {

  var pipelineUtil = cocoon.createObject(Packages.org.apache.cocoon.components.flow.util.PipelineUtil);
  var pub = doc.getPublication();
  var filename = doc.getName() + ".pdf";
  var resManager = new ResourcesManager(doc);
  var pdfFile = resManager.getPath().getAbsolutePath() + "/" + filename;
  var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);
  var source = resolver.resolveURI(pdfFile);

  /* Process lesson document to dom */

  var path = doc.getId() + "/index_" + doc.getLanguage() + ".xml";
  var lessonDOM = pipelineUtil.processToDOM("xml/" + path, null);
  var lessonNode = lessonDOM.getElementsByTagNameNS("http://www.elml.ch", "lesson").item(0);


  /* Rewrite multimedia tags */

  var multimediaNodes = lessonNode.getElementsByTagNameNS("http://www.elml.ch", "multimedia");

  for (var i = 0; i < multimediaNodes.length; i++) {
    var multimediaNode = multimediaNodes.item(i);
    var src = multimediaNode.getAttribute("src");
    multimediaNode.setAttribute("src", resManager.getPath().getAbsolutePath() + "/" + src);
  }

  var label = doc.getLabel();
  var units = new ArrayList();

  var unitNodes = lessonNode.getElementsByTagNameNS("http://www.elml.ch", "unit");
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
  var font = cocoon.request.get("font");
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

   cocoon.processPipelineTo("pdf/", {"dom": lessonNode, "date": yearMonth, "role": role, "publisher": publisher, "author" : author, "url": url, "pagebreak_level" : pagebreak_level, "chapter_numbers" : chapter_numbers, "font" : font, "optional_units": optional_units}, out);
   out.close();

   var url = doc.getName() + "/" + filename;
   var size = Math.round(new File(pdfFile).length() / 1024) + " KB";
   cocoon.sendPageAndWait("pdf/download.jx", {"url" : url, "filename" : filename, "length": size});

   cocoon.redirectTo(pageEnvelope.getContext() + "/" + doc.getCompleteURL());

}


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

