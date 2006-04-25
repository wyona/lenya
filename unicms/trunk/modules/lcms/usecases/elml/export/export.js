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


function showscreen() {

  var flowHelper = new FlowHelper();
  var pageEnvelope = flowHelper.getPageEnvelope(cocoon);
  var doc = pageEnvelope.getDocument();
  var doctype = getDoctype(doc);

  if (!doctype.equals("lesson")) {
    var msg = "Export is only available on lesson doctypes";
    cocoon.sendPage("error.jx", {"msg": msg});
  }

  var url = doc.getLabel();
  cocoon.sendPageAndWait("export.jx", {"url" : url});
 
  var pipelineUtil = cocoon.createObject(Packages.org.apache.cocoon.components.flow.util.PipelineUtil);
  var pub = doc.getPublication();
  var children = getChildren(doc); 
  var path = doc.getId() + "/index_" + doc.getLanguage() + ".xml";
  var dom = pipelineUtil.processToDOM("xml/" + path, null);
  
  for (var i = 0; i < children.size(); i++) {
     var path = children.get(i).getId() + "/index_" + doc.getLanguage() + ".xml";
     var fragmentDOM = pipelineUtil.processToDOM("xml/" + path, null);
     var cloned = dom.importNode(fragmentDOM.documentElement, true);
     dom.documentElement.appendChild(cloned);
   }

   var filename = "lesson.zip";
   var resManager = new ResourcesManager(doc);
   var path = resManager.getPath().getAbsolutePath() + "/" + filename;
   var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);
   var source = resolver.resolveURI(path);

   var out = new ZipOutputStream(source.getOutputStream());
   var zipEntry = new ZipEntry("test.xml");
   out.putNextEntry(zipEntry);
   cocoon.processPipelineTo("dom.jx", {"dom": dom}, out);
   out.close();
   
   var url = doc.getName() + "/" + filename;
   var size = Math.round(new File(path).length() / 1024) + " KB"; 
   cocoon.sendPageAndWait("download.jx", {"url" : url, "filename" : filename, "length": size});

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

