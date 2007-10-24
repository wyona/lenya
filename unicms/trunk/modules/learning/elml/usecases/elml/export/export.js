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


function exportLesson() {

  var exporter = new LessonExporter(); 
  exporter.run(); 

}


function LessonExporter() {


}

LessonExporter.prototype = {

  run: function() {
 
    var flowHelper = new FlowHelper();
    var lesson = flowHelper.getPageEnvelope(cocoon).getDocument();

    /* Display initial export screen */
    cocoon.sendPageAndWait("select.jx", {"label" : lesson.getLabel()});

    var mode = cocoon.request.getParameter("mode");

    if (mode == "source") {
      this.exportSource(lesson); 
    } else if (mode == "cp") { 
      this.exportCP(lesson); 
    } else if (mode == "pdf") {
      this.exportPDF(lesson); 
    }

  },


  exportSource: function(aLesson) {

    var pipelineUtil = cocoon.createObject(Packages.org.apache.cocoon.components.flow.util.PipelineUtil);
    var flowHelper = new FlowHelper();
    var pageEnvelope = flowHelper.getPageEnvelope(cocoon);
    var resourcesManager = new ResourcesManager(aLesson);
    var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);

    var pub = aLesson.getPublication();
    var languages = aLesson.getLanguages();


    var assetsPath = resourcesManager.getPath().getAbsolutePath();

    var filename = aLesson.getName() + ".zip";
    var zipPath = assetsPath + "/" + filename;


    // override previous version. 
    var oldArchive = resolver.resolveURI(zipPath);
    if (oldArchive.exists())
      oldArchive["delete"]();

    // remove .tmp from failed run 
    var tmpSource = resolver.resolveURI(zipPath + ".tmp");
    if (tmpSource.exists())
      tmpSource["delete"]();


    var source = resolver.resolveURI(zipPath);
    var out = new ZipOutputStream(source.getOutputStream());

    /* Export language versions */
  
    for (var i=0; i < languages.length; i++) {

      var language = languages[i];
      var lessonPath = aLesson.getId() + "/index_" + language + ".xml";
      var assets = new ArrayList();

      /* Pre process lesson : rewrite asset paths */

      var lessonDOM = pipelineUtil.processToDOM("xml/" + lessonPath, null);

      var lessonNode = lessonDOM.getElementsByTagNameNS("http://www.elml.ch", "lesson").item(0);

      var assetNodes = lessonNode.getElementsByTagNameNS("http://www.elml.ch", "multimedia");

      for (var j = 0; j < assetNodes.length; j++) {
        var assetNode = assetNodes.item(j);
        var assetName = assetNode.getAttribute("src"); 

        var dir = this.getExportAssetDirectoryName(assetName);

        var asset = new File(assetsPath + "/" + assetName);

        if (asset.exists()) {

          assets.add({"src" : assetsPath + "/" + assetName, "dest" : dir + "/" + assetName});
          assetNode.setAttribute("src", "../" + dir + "/" + assetName); // FIXME: path configuration
        }
      }

      /* Add lesson to archive */

      var zipEntry = new ZipEntry(aLesson.getName() + "/" + language + "/text/" + aLesson.getName() + ".xml");

      // cocoon.sendPageAndWait("error.jx", {"msg" : zipEntry});

      out.putNextEntry(zipEntry);

      cocoon.processPipelineTo("lesson.jx", {"dom": lessonNode}, out);

      out.closeEntry(); 

      /* Add assets to archive */

      var archiveIndex = new Object(); 

      for (var j = 0; j < assets.size(); j++) {
        var src = assets.get(j).src;
        var dest = assets.get(j).dest;
        var source = resolver.resolveURI(src);
        var is = source.getInputStream();

        var entryName = aLesson.getName() + "/" + language + "/" + dest;

        if (!archiveIndex[entryName]) {
          var zipEntry = new ZipEntry(entryName);

          out.putNextEntry(zipEntry);
          var buffer = new java.lang.reflect.Array.newInstance(java.lang.Byte.TYPE, 1024);
          var len;

          while((len = is.read(buffer)) >= 0)
            out.write(buffer, 0, len);

          out.closeEntry();

          archiveIndex[new String(entryName)] = true;
        }
         
        is.close();
      }

    }

    out.close();

    var url = aLesson.getName() + "/" + filename;
    var size = Math.round(new File(zipPath).length() / 1024) + " KB";
    cocoon.sendPageAndWait("download.jx", {"url" : url, "filename" : filename, "length": size});

    cocoon.redirectTo(pageEnvelope.getContext() + "/" + aLesson.getCompleteURL());

  },


  exportCP: function(aLesson) {

    var pipelineUtil = cocoon.createObject(Packages.org.apache.cocoon.components.flow.util.PipelineUtil);
    var sourceUtil = Packages.org.apache.lenya.cms.cocoon.source.SourceUtil;
    var flowHelper = new FlowHelper();
    var documentHelper = flowHelper.getDocumentHelper(cocoon);
    var pub = aLesson.getPublication();
    var filename = aLesson.getName() + "-cp.zip";

    var resourcesManager = new ResourcesManager(aLesson);
    var path = pub.getDirectory().getAbsolutePath() + "/usecases/elml/export/data/" + filename;
    var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);
    var source = resolver.resolveURI(path);

    var documentPath = aLesson.getId() + "/index_" + aLesson.getLanguage() + ".xml";
    var lessonDOM = pipelineUtil.processToDOM("xml/" + documentPath, null);
    var lessonNode = lessonDOM.getElementsByTagNameNS("http://www.elml.ch", "lesson").item(0);


    /* Display CP configuration dialog */
    var headerHeading = lessonNode.getAttribute("title");
    cocoon.sendPageAndWait("cp-config.jx", {"header_heading" : headerHeading});


    headerHeading = cocoon.request.get("header_heading");
    var pagebreakLevel = cocoon.request.get("pagebreak_level");
    var headerSuperscription = cocoon.request.get("header_superscription");

    var omitHeader = "false";
    if(cocoon.request.get("omit_header")) {
      omitHeader = "true";
    };

 
    var pageNodes = new Array();

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
           pageNodes.push(childNode);
        }
      }
    }
    

    // remove cocoon cruft                    
    var tmpSource = resolver.resolveURI(path + ".tmp");
    if (tmpSource.exists())
      tmpSource["delete"]();


    /* Create Archive */

    var out = new ZipOutputStream(source.getOutputStream());


    var lessonLabel = lessonNode.getAttribute("label");
    var lessonTitle = lessonNode.getAttribute("title");
    var pages = new Array();

    for (var i = 0; i < pageNodes.length; i++) {

      var node = pageNodes[i];
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
          title = node.nodeName;
        }
      }

      var page = new Object();
      page.label = label;
      page.title = title;
      page.type = node.localName;
      pages.push(page);
    }


    /* IMS manifest */
    var zipEntry = new ZipEntry("imsmanifest.xml");
    out.putNextEntry(zipEntry);
    cocoon.processPipelineTo("manifest.jx", {"lessonLabel" : lessonLabel, "lessonTitle": lessonTitle, "pages" : pages}, out);


    zipEntry = new ZipEntry(lessonLabel + ".html");
    out.putNextEntry(zipEntry);

    /* Process index page */

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


    /* Process individual pages */

    for (var i=0; i < pages.length; i++) {
      var page = pages[i];
      zipEntry = new ZipEntry(page.label + ".html");
      out.putNextEntry(zipEntry);

      cocoon.processPipelineTo("xhtml/cp", {
        "pagebreak_level": pagebreakLevel,
        "current_section": page.type,
        "current_label": page.label,
        "cssdir" : "css",
        "jsdir" : "js",
        "imgdir" : "images",
        "assetdir": "resources",
        "header_heading": headerHeading,
        "header_superscription": headerSuperscription,
        "omit_header": omitHeader},
        out);
    }


    /* Process assets */
    var assets = resourcesManager.getResources();

    for (var i = 0; i < assets.length; i++) {

     var source = resolver.resolveURI(assets[i].getAbsolutePath());
     var dir = null;

     if (assets[i].getName() == filename) continue;  // exclude existing cp-archive from being copied into archive

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


   /* Add static resources (images, css) used by document layout to archive */

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


   // Copy archive to assets and display confirmation screen

   var destPath = resourcesManager.getPath().getAbsolutePath() + "/" + filename;
   sourceUtil.copy(resolver, path, destPath);


   var url = aLesson.getName() + "/" + filename;
   var size = Math.round(new File(path).length() / 1024) + " KB";
   cocoon.sendPageAndWait("download.jx", {"url" : url, "filename" : filename, "length": size});

   cocoon.redirectTo(pageEnvelope.getContext() + "/" + aLesson.getCompleteURL());


  },


  exportPDF: function(aLesson) {

    var pipelineUtil = cocoon.createObject(Packages.org.apache.cocoon.components.flow.util.PipelineUtil);
    var pub = aLesson.getPublication();
    var filename = aLesson.getName() + ".pdf";
    var resourcesManager = new ResourcesManager(aLesson);
    var pdfFile = resourcesManager.getPath().getAbsolutePath() + "/" + filename;
    var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);

    var source = resolver.resolveURI(pdfFile);

    var path = aLesson.getId() + "/index_" + aLesson.getLanguage() + ".xml";
    var lessonDOM = pipelineUtil.processToDOM("xml/" + path, null);
    var lessonNode = lessonDOM.getElementsByTagNameNS("http://www.elml.ch", "lesson").item(0);  

    /* Rewrite multimedia tags */

    var multimediaNodes = lessonNode.getElementsByTagNameNS("http://www.elml.ch", "multimedia");

    for (var i = 0; i < multimediaNodes.length; i++) {
      var multimediaNode = multimediaNodes.item(i);
      var src = multimediaNode.getAttribute("src");
      multimediaNode.setAttribute("src", resourcesManager.getPath().getAbsolutePath() + "/" + src);
    }

    var label = aLesson.getLabel();
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

    var url = aLesson.getName() + "/" + filename;
    var size = Math.round(new File(pdfFile).length() / 1024) + " KB";
    cocoon.sendPageAndWait("pdf/download.jx", {"url" : url, "filename" : filename, "length": size});

    cocoon.redirectTo(pageEnvelope.getContext() + "/" + aLesson.getCompleteURL());

  },


  getExportAssetDirectoryName: function (assetName) {

    var suffix = assetName.substring(assetName.indexOf(".") + 1);

    if (suffix.equals("jpg") || suffix.equals("jpeg") || suffix.equals("gif") || suffix.equals("png")) {
      return "image";
    } else {
      return "multimedia";
    }
  }

}



function sendStatus(sc) {
  cocoon.sendStatus(sc);
}

