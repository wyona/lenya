importClass(Packages.java.io.File);
importClass(Packages.java.util.ArrayList);
importClass(Packages.org.apache.lenya.cms.cocoon.flow.FlowHelper);
importClass(Packages.org.apache.lenya.cms.cocoon.uriparameterizer.URIParameterizer);
importClass(Packages.org.apache.avalon.framework.parameters.Parameters);
importClass(Packages.java.util.zip.ZipOutputStream);
importClass(Packages.org.apache.lenya.cms.publication.ResourcesManager);
importClass(Packages.org.apache.lenya.cms.publication.PublicationHelper);




function update() {

  var flowHelper = new FlowHelper();
  var pageEnvelope = flowHelper.getPageEnvelope(cocoon);

  var sourceUtil = Packages.org.apache.lenya.cms.cocoon.source.SourceUtil;

  var doc = flowHelper.getPageEnvelope(cocoon).getDocument();
  var lessonResourcesManager = new ResourcesManager(doc);
  var lessonResourcesDirectory = lessonResourcesManager.getPath();

  var pipelineUtil = cocoon.createObject(Packages.org.apache.cocoon.components.flow.util.PipelineUtil);
  var pub = doc.getPublication();
  var assetPaths = new ArrayList();


  var sectionDocuments = getChildren(doc);

  var sectionIdToLabelMap = new Object();
  
  for (var i = 0; i < sectionDocuments.size(); i++) {
    var sectionDocument = sectionDocuments.get(i);
    var sectionPath = sectionDocument.getId() + "/index_" + doc.getLanguage() + ".xml";
    var sectionNode = pipelineUtil.processToDOM("xml/" + sectionPath, null); 
    var label = sectionNode.documentElement.getAttribute("label");
    var id = sectionDocument.getId();
    cocoon.log.error("Id, Label: " + id + ", " + label + "\n");
    sectionIdToLabelMap[id] = label;
  }


  var path = doc.getId() + "/index_" + doc.getLanguage() + ".xml";
  var lessonDOM = pipelineUtil.processToDOM("xml/" + path, null);

  lessonDOM.documentElement.removeAttribute("dc:dummy");
  lessonDOM.documentElement.removeAttribute("dcterms:dummy");
  lessonDOM.documentElement.removeAttribute("lenya:dummy");
  lessonDOM.documentElement.removeAttribute("elml:dummy");
  lessonDOM.documentElement.removeAttribute("xhtml:dummy");

  var lenyaMetaNode = lessonDOM.getElementsByTagNameNS("http://apache.org/cocoon/lenya/page-envelope/1.0", "meta").item(0);  
  lenyaMetaNode.parentNode.removeChild(lenyaMetaNode);


  var links = lessonDOM.getElementsByTagNameNS("http://www.elml.ch", "link");

  for (var i = 0; i < links.length; i++) {
    var link = links.item(i);
    var uri = link.getAttribute("uri");
    if (link.hasAttribute("uri") && link.getAttribute("uri").indexOf("authoring") != -1) {
      var uri = link.getAttribute("uri");
      var id = uri.substring(uri.indexOf("authoring") + 9, uri.indexOf(".html"));
      cocoon.log.error("Id: " + id + "\n");
      var label = sectionIdToLabelMap[id];
      if (label) {
        cocoon.log.error("Label: " + label + "\n");
        link.removeAttribute("uri");
        link.setAttribute("targetLabel", label);
      }
    }
  }


  for (var i = 0; i < sectionDocuments.size(); i++) {
    var sectionDocument = sectionDocuments.get(i);
    var sectionPath = sectionDocument.getId() + "/index_" + doc.getLanguage() + ".xml";
    var sectionNode = pipelineUtil.processToDOM("xml/" + sectionPath, null);
    var lenyaMetaNode = sectionNode.getElementsByTagNameNS("http://apache.org/cocoon/lenya/page-envelope/1.0", "meta").item(0);
    lenyaMetaNode.parentNode.removeChild(lenyaMetaNode);
   
    sectionNode.documentElement.removeAttribute("dc:dummy");
    sectionNode.documentElement.removeAttribute("dcterms:dummy");
    sectionNode.documentElement.removeAttribute("lenya:dummy");
    sectionNode.documentElement.removeAttribute("elml:dummy");
    sectionNode.documentElement.removeAttribute("xhtml:dummy");

    var links = lessonDOM.getElementsByTagNameNS("http://www.elml.ch", "link");

    for (var j = 0; j < links.length; j++) {
      var link = links.item(j);
      if (link.hasAttribute("uri") && link.getAttribute("uri").indexOf("authoring") != -1) {
        var uri = link.getAttribute("uri");
        try {
          var id = uri.substring(uri.indexOf("authoring") + 9, uri.indexOf(".html"));
          cocoon.log.error("Id: " + id + "\n");
          var label = sectionIdToLabelMap[id];
          if (label) {
            cocoon.log.error("Label: " + label + "\n");
            link.removeAttribute("uri");
            link.setAttribute("targetLabel", label);
          }
        } catch (e) {
          cocoon.log.error(e);
        }
      }
    }

    var importNode = lessonDOM.importNode(sectionNode.documentElement, true);
    lessonDOM.documentElement.appendChild(importNode);

    var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);
    var resourcesManager = new ResourcesManager(sectionDocument);
    var resources = resourcesManager.getResources();

    for (var j = 0; j < resources.length; j++) {
      var resource = resources[j];
      var srcPath = resource.getAbsolutePath();
      var destPath = lessonResourcesDirectory +  File.separator + resource.getName(); 

      var source = resolver.resolveURI(srcPath);
      var dest = resolver.resolveURI(destPath); 
   
      sourceUtil.copy(resolver, srcPath, destPath);     
 
    }

    
    var metaFiles = resourcesManager.getMetaFiles();

    for (var j = 0; j < metaFiles.length; j++) {
      var metaFile = metaFiles[j];
      var srcPath = metaFile.getAbsolutePath();
      var destPath = lessonResourcesDirectory +  File.separator + metaFile.getName();
      
      var source = resolver.resolveURI(srcPath);
      var dest = resolver.resolveURI(destPath); 
   
      sourceUtil.copy(resolver, srcPath, destPath);
    } 

    var siteTree = pub.getTree("authoring");
    siteTree.deleteNode(sectionDocument.getId()); 

  }  


  var documentPath = doc.getFile().getAbsolutePath();
  var source = resolver.resolveURI(documentPath);
  var out = source.getOutputStream();

  cocoon.processPipelineTo("lesson.jx", {"lesson": lessonDOM}, out);
  out.close();

  cocoon.redirectTo(pageEnvelope.getContext() + "/" + doc.getCompleteURL());

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



