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

<!-- $Id$ -->


cocoon.load("../../../../../usecases/webdav/webdav.js");


function getLesson() {

 var pipelineUtil = cocoon.createObject(Packages.org.apache.cocoon.components.flow.util.PipelineUtil);
 var lesson = cocoon.context.getAttribute("doc");
 var pub = lesson.getPublication();
 var children = getChildren(lesson);

 var path = lesson.getId() + "/index_" + lesson.getLanguage() + ".xml";
 var lsDOM = pipelineUtil.processToDOM("xml/" + path, null);

 for (var i = 0; i < children.size(); i++) {
   var path = children.get(i).getId() + "/index_" + lesson.getLanguage() + ".xml";
   var fragmentDOM = pipelineUtil.processToDOM("xml/" + path, null);
   var cloned = lsDOM.importNode(fragmentDOM.documentElement, true);
   lsDOM.documentElement.appendChild(cloned);
 }

 cocoon.sendPage("lesson.jx", {"lsDOM" : lsDOM});
}

function propfindLesson () {

  var doc = cocoon.context.getAttribute("doc");
  var mapto = cocoon.context.getAttribute("mapto");
  var asset = cocoon.context.getAttribute("asset");

  // FIXME: refer to location with trailing slash in case client refers to collections without one (mac finder does so).

  // FIXME: - fetch requested props. Send 404 if missing prop requested
  // body = requestBody(request);
  // props[] = fetchProps(requestbody);

  if (mapto.equals("document")) {

    var pub = doc.getPublication();
    var depth = getDepth(cocoon.request);

    var sources = getSources(doc);
    if (!doc.getId().equals("/")) {
      var assetsDir = ASSETS_DIR;
    }

    cocoon.sendPage("propfind.jx",
       {"doc" : doc,
        "sources" : sources,
        "assetsDir" : assetsDir,
        "depth" : depth}
    );

  } else if (mapto.equals("source")) {

    cocoon.sendPage("filePropfind.jx",
      {"doc" : doc,
       "url" : doc.getId() +
       "/index_" + doc.getLanguage() +
       ".xml"});

  } else if (mapto.equals("assetdir")) {

    var assetInfos = getAssetInfos(doc);
    var assetsDoc = new DefaultDocument(doc.getPublication(), doc.getId() + "/doc-assets");

    cocoon.sendPage("propfind.jx", {"doc" : assetsDoc, "assetInfos" : assetInfos});

  } else if (mapto.equals("asset")) {
     cocoon.sendPage("filePropfind.jx", {"doc" : doc, "url" : doc.getId() + "/doc-assets/" + asset});
  } else {
    sendStatus(404);
  }

}


function putLesson() {

  var doc = cocoon.context.getAttribute("doc");
  var mapto = cocoon.context.getAttribute("mapto");
  var asset = cocoon.context.getAttribute("asset");

  if (mapto.equals("document") || mapto.equals("assetdir")) {
    sendStatus(412);
  }

  var flowHelper = new FlowHelper();
  var documentHelper = flowHelper.getDocumentHelper(cocoon);
  var uri = null;

  if (mapto.equals("source") && invokeWorkflow(doc, "edit")) {

    var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);
    var builder = Packages.javax.xml.parsers.DocumentBuilderFactory.newInstance().newDocumentBuilder();

    // Writing .tmp file and building dom of uploaded data. Reader has to be used due to goliath sending misleading getContentType() info.

    uri = documentHelper.getSourceUri(doc) + ".imported";
    copySource("cocoon:/request/generate", uri);

    var source = resolver.resolveURI(uri);
    var is = source.getInputStream();
    var dom = builder.parse(is);
    is.close();
    resolver.release(source);

    var fragments = new ArrayList();
    var nodes = dom.documentElement.childNodes;

    for (var i = 0; i < nodes.length; i++) {
      var node = nodes.item(i);
      cocoon.log.error("Current node name: " + node.nodeName);
      if (!(node.nodeName.equals("elml:entry") || node.nodeName.equals("elml:goals")) && node.nodeType == 1) {
        cocoon.log.error("Building document from fragment");
        var frgDOM = builder.newDocument();
        var clonedNode = frgDOM.importNode(node, true);
        // var ns = "http://www.elml.ch";
        // clonedNode.setAttribute("xmlns", ns);
        frgDOM.appendChild(clonedNode);
        fragments.add(frgDOM);
        dom.documentElement.removeChild(node);
        i--;
      }
    }

     /** Getting existing metadata. Will be overridden in pipeline later **/

    var pipelineUtil = cocoon.createObject(Packages.org.apache.cocoon.components.flow.util.PipelineUtil);
    var path = doc.getId() + "/index_" + doc.getLanguage() + ".xml"; // FIXME: fix pipeline and use doc.getSourceURI
    var oldDom = pipelineUtil.processToDOM("xml/" + path, null);
    var meta = oldDom.documentElement.getElementsByTagName("lenya:meta").item(0);
    var clonedMeta = dom.importNode(meta, true);
    dom.documentElement.insertBefore(clonedMeta, dom.documentElement.childNodes.item(0));

    var testurl = documentHelper.getSourceUri(doc);
    var src = resolver.resolveURI(testurl);
    if (src instanceof Packages.org.apache.excalibur.source.ModifiableSource) {
      cocoon.log.error("Writing testfile to: " + testurl);
      cocoon.log.error("Metadata: " + meta);
      var out = src.getOutputStream();
      cocoon.processPipelineTo("putLesson.jx",  {"dom" : dom} , out);
      out.close();
      resolver.release(src);
    } else {
      cocoon.log.error("No modifiable source");
    }

    // updating lesson fragments

    var children = getChildren(doc);
    if (children.size() == fragments.size()) {

      for (var i = 0; i < children.size(); i++) {
        var child = children.get(i);
        var fragment = fragments.get(i);
        clonedMeta = fragment.importNode(meta, true);
        fragment.documentElement.insertBefore(clonedMeta, fragment.documentElement.childNodes.item(0));
        testurl = documentHelper.getSourceUri(child);
        src = resolver.resolveURI(testurl);
        if (src instanceof Packages.org.apache.excalibur.source.ModifiableSource) {
          cocoon.log.error("Writing testfile to: " + testurl);
          cocoon.log.error("Metadata: " + meta);
          out = src.getOutputStream();
          cocoon.processPipelineTo("putLesson.jx",  {"dom" : fragment} , out);
          out.close();
         } else {
           cocoon.log.error("No modifiable source");
         }
       }
    } else {
      // create new documents
    }

    // release src and close stream. Modifiable src? Repository ?
    sendStatus(200);
  }
}


function lockLesson() {
  cocoon.log.error("Locking lesson..");
  var doc = cocoon.context.getAttribute("doc");
  var mapto = cocoon.context.getAttribute("mapto");
  var asset = cocoon.context.getAttribute("asset");

  if (mapto.equals("document") || mapto.equals("assetdir")) {
    sendStatus(412);
  }

  // FIXME: fetch lockinfo from request body

  var identity = new Identity();
  var ident = identity.getIdentity(cocoon.session);
  var flowHelper = new FlowHelper();
  var docToPathMapper = new DefaultDocumentIdToPathMapper();
  var rc = flowHelper.getRevisionController(cocoon);

  var path = null;
  var children = getChildren(doc);

  for (var i = 0; i < children.size(); i++) {
    path = "/content/authoring/" + docToPathMapper.getPath(children.get(i).getId(), children.get(i).getLanguage());
    try {
      rc.reservedCheckOut(path, ident.getUser().getId());
    } catch (e) {
      cocoon.log.error(e);
      sendStatus(412);
    }
  }

  path = "/content/authoring/" + docToPathMapper.getPath(doc.getId(), doc.getLanguage());

  try {
    var uri = null;
    rc.reservedCheckOut(path, ident.getUser().getId()); // FIXME: obtain file path from ?
    if (type.equals("source")) {
      uri = doc.getCompleteURL();
    } else {
      uri = "/lenya/unitemplate/authoring/resources" + doc.getId() + "/" + filename;
    }
    cocoon.sendPage("lock.jx", {"uri" : uri, "identity" : ident});

  } catch (e) {
    cocoon.log.error(e);
    sendStatus(412);
  }

}


function unlockLesson() {

  var doc = cocoon.context.getAttribute("doc");
  var mapto = cocoon.context.getAttribute("mapto");

  if (mapto.equals("document") || mapto.equals("assetdir")) {
    sendStatus(412);
  }

  // FIXME: fetch lockinfo from request body

  var identity = new Identity();
  var ident = identity.getIdentity(cocoon.session);
  var flowHelper = new FlowHelper();
  var docToPathMapper = new DefaultDocumentIdToPathMapper();
  var rc = flowHelper.getRevisionController(cocoon);
  var path = null;

  var children = getChildren(doc);

  for (var i = 0; i < children.size(); i++) {
    path = "/content/authoring/" + docToPathMapper.getPath(children.get(i).getId(), children.get(i).getLanguage());
    try {
      rc.reservedCheckIn(path, ident.getUser().getId(), true);
    } catch (e) {
     sendStatus(412);
    }
  }

  path = docToPathMapper.getPath(doc.getId(), doc.getLanguage());

  try {
    rc.reservedCheckIn("/content/authoring/" + path, ident.getUser().getId(), true); // FIXME: obtain file path from ?
    sendStatus(204);
  } catch (e) {
    sendStatus(412);
  }
}


