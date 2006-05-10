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

importClass(Packages.java.util.Map);
importClass(Packages.java.util.ArrayList);
importClass(Packages.java.io.ByteArrayOutputStream);
importClass(Packages.java.io.File);
importClass(Packages.org.apache.lenya.cms.cocoon.flow.FlowHelper);
importClass(Packages.org.apache.lenya.xml.DocumentHelper); 
importClass(Packages.org.apache.lenya.cms.publication.DefaultDocument);
importClass(Packages.org.apache.avalon.framework.parameters.Parameters);
importClass(Packages.org.apache.lenya.cms.cocoon.uriparameterizer.URIParameterizer);
importClass(Packages.org.apache.lenya.cms.publication.ResourcesManager);
importClass(Packages.org.apache.cocoon.components.source.impl.ModuleSource);
importClass(Packages.org.apache.lenya.ac.Identity);
importClass(Packages.org.apache.lenya.cms.publication.DefaultDocumentIdToPathMapper);
importClass(Packages.org.apache.excalibur.source.SourceResolver);
importClass(Packages.org.apache.lenya.cms.cocoon.source.SourceUtil);
importClass(Packages.org.apache.lenya.ac.impl.PolicyAuthorizer);
importClass(Packages.org.apache.lenya.cms.workflow.CMSSituation);
importClass(Packages.org.apache.lenya.util.ServletHelper);

var DAV_PREFIX = "webdav";
var ASSETS_DIR = "doc-assets";

function method() {

  var docid = cocoon.parameters.documentId;
  var type = cocoon.parameters.type;
  var lang = cocoon.parameters.language;
  var filename = cocoon.parameters.filename;

  var method = cocoon.request.getMethod();

  var doc;
   // document builder bug. FIXME: report.
  if (docid.indexOf(".") >= 0) {
    sendStatus(404);
    return;
  } else {
    doc = buildDocument(docid, lang);
  }

  var doctype = "default";
  if (!docid.equals("/")) {
    doctype = getDoctype(doc);
  } 

  // FIXME: pass bean to sitemap instead of storing objects in servlet context.

  cocoon.context.setAttribute("doc", doc);
  cocoon.context.setAttribute("type", type);
  cocoon.context.setAttribute("filename", filename);

  cocoon.sendPage(method + "/" + doctype);

}


function get() {

  var doc = cocoon.context.getAttribute("doc");
  var type = cocoon.context.getAttribute("type");
  var filename = cocoon.context.getAttribute("filename");

   if (type.equals("source")) {
     var path = "/" + doc.getId() + "/index_" + doc.getLanguage() + ".xml";
     cocoon.sendPage("xml/" + path);
   } else if (type.equals("asset")) {
     cocoon.sendPage("asset/" + filename, {"documentid" : doc.id});
   } else {
     sendStatus(404);
   }
}


function propfind() {

  var doc = cocoon.context.getAttribute("doc");
  var type = cocoon.context.getAttribute("type");
  var filename = cocoon.context.getAttribute("filename");

  // FIXME: refer to location with trailing slash in case client refers to collections without one (mac finder does so).

  // FIXME: - fetch requested props. Send 404 if missing prop requested 
  // body = requestBody(request);
  // props[] = fetchProps(requestbody);

  if (type.equals("doc")) {

    var pub = doc.getPublication();
    var depth = getDepth(cocoon.request);
 
    // FIXME: add support for depth infinity
    var members = getChildren(doc);

    var sources = getSources(doc);


    if (!doc.getId().equals("/")) {
      var assetsDir = ASSETS_DIR;  
    }
    
    cocoon.sendPage("propfind.jx", 
       {"doc" : doc, 
        "sources" : sources,
        "members" : members, 
        "assetsDir" : assetsDir, 
        "depth" : depth}
    );

  } else if (type.equals("source")) {

    var rcmlEntry = getLatestRCMLEntry(doc);

    cocoon.sendPage("filePropfind.jx", 
      {"doc" : doc, 
       "url" : doc.getId() + "/index_" + doc.getLanguage() + ".xml", 
       "rcmlEntry" : rcmlEntry}
    );

  } else if (type.equals("assetdir")) {

    var assetInfos = getAssetInfos(doc);
    var assetsDoc = new DefaultDocument(doc.getPublication(), doc.getId() + "/doc-assets");

    cocoon.sendPage("propfind.jx", {"doc" : assetsDoc, "assetInfos" : assetInfos});

  } else if (type.equals("asset")) {
     var rcmlEntry = getLatestRCMLEntry(doc);
     cocoon.sendPage("filePropfind.jx", {"doc" : doc, "url" : doc.getId() + "/doc-assets/" + filename, "rcmlEntry" : rcmlEntry});
  } else {
    sendStatus(404);
  }
}

function getLatestRCMLEntry(doc) {

   var flowHelper = new FlowHelper();
   var rc = flowHelper.getRevisionController(cocoon);
   var identity = new Identity();
   var ident = identity.getIdentity(cocoon.session);
   var docToPathMapper = new DefaultDocumentIdToPathMapper();
   var path = docToPathMapper.getPath(doc.getId(), doc.getLanguage());
   var rcml = rc.getRCML("/content/authoring/" + path); // FIXME: obtain file path from ?

   return rcml.getLatestEntry();
}


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


function putLesson() {

  var doc = cocoon.context.getAttribute("doc");
  var type = cocoon.context.getAttribute("type");
  var filename = cocoon.context.getAttribute("filename");

  if (type.equals("doc") || type.equals("assetdir")) {
    sendStatus(412);
  }

  var flowHelper = new FlowHelper();
  var documentHelper = flowHelper.getDocumentHelper(cocoon);
  var uri = null;

  if (type.equals("source") && invokeWorkflow(doc, "edit")) {

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


/** Utility functions **/

function getDepth(request) {
  if (request.getHeader("Depth") != null) { 
    return request.getHeader("depth");
  } 
  return "infinity";
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


function getSources (doc) {

   var sources = new ArrayList();

   if (!doc.getId().equals("/")) {
      var flowHelper = new FlowHelper();
      var pageEnvelope = flowHelper.getPageEnvelope(cocoon);
      var contextPrefix = pageEnvelope.getContext();
      var languages = doc.getLanguages();
      var pub = doc.getPublication();
      for (var i = 0; i < languages.length; i++) {
        var url = contextPrefix +
        "/" +  pub.getId() + "/webdav" + doc.getId() +
        "/index_" + languages[i] + ".xml";
        var source = new DefaultDocument(pub, doc.getId());
        source.setDocumentURL(url);
        source.setLanguage(languages[i]);
        var rcmlEntry = getLatestRCMLEntry(source);

        sources.add({
                    "doc" : source,
                    "rcmlEntry" : rcmlEntry
      });
      }
    }

    return sources;
}


function getAssetInfos(doc) {

  var resourcesMgr = new ResourcesManager(doc);
  var assets = resourcesMgr.getResources();
  var assetInfos = new ArrayList();

  for(var i = 0; i < assets.length; i++) {
    var metaDoc = DocumentHelper.readDocument(resourcesMgr.getMetaFile(assets[i]));
    if (metaDoc != null) {
      var title = metaDoc.getElementsByTagNameNS("http://purl.org/dc/elements/1.1/",
                    "title").item(0).getChildNodes().item(0).getNodeValue();
      var rcmlEntry = getLatestRCMLEntry(doc);
      /** FIXME: unique lock tokens vs. simultaneous locking of multiple files **/
      assetInfos.add({
                    "url" : "/lenya/" +
                    doc.getPublication().getId() +
                    "/webdav" + doc.getId() +
                    "/" +
                    ASSETS_DIR +
                    "/" +
                    assets[i].getName(),
                    "name" : assets[i].getName(),
                    "title" : title,
                    "length" : assets[i].length(),
                    "rcmlEntry" : rcmlEntry
      });
    }
  }

  return assetInfos;
}


function nextNode(node) {
  if (!node) return null;
    if (node.getChildren()[0] != null){
        return node.getChildren()[0];
    } else {
        return nextWide(node);
  }
}

 function nextWide(node) {
    if (!node) return null;
    if (node.getNextSiblings()[0] != null) {
        return node.getNextSiblings()[0];
    } else {
        return nextWide(node.getParent());
    }
  }

 

function lock() {
  
  var doc = cocoon.context.getAttribute("doc");
  var type = cocoon.context.getAttribute("type");
  var filename = cocoon.context.getAttribute("filename");

  if (type.equals("doc") || type.equals("assetdir")) {
    sendStatus(412);
  }

  // FIXME: fetch lockinfo from request body

  var identity = new Identity();
  var ident = identity.getIdentity(cocoon.session);
  var flowHelper = new FlowHelper();
  var docToPathMapper = new DefaultDocumentIdToPathMapper();
  var path = docToPathMapper.getPath(doc.getId(), doc.getLanguage());
  var rc = flowHelper.getRevisionController(cocoon);
  if (rc.canCheckOut(path, ident)) {
    try {
      var uri = null;
      rc.reservedCheckOut("/content/authoring/" + path, ident.getUser().getId()); // FIXME: obtain file path from ?

      if (type.equals("source")) {
        uri = doc.getCompleteURL();
      } else {
        uri = "/lenya/unitemplate/authoring/resources" + doc.getId() + "/" + filename;
      }
      
      cocoon.sendPage("lock.jx", {"uri" : uri, "identity" : ident});
 
    } catch (e) {
      sendStatus(412);
    }
  }

}


function unlock() {
 
  var doc = cocoon.context.getAttribute("doc");
  var type = cocoon.context.getAttribute("type");

  if (type.equals("doc") || type.equals("assetdir")) {
    sendStatus(412);
  }

  // FIXME: fetch lockinfo from request body

  var identity = new Identity();
  var ident = identity.getIdentity(cocoon.session);
  var flowHelper = new FlowHelper();
  var docToPathMapper = new DefaultDocumentIdToPathMapper();
  var path = docToPathMapper.getPath(doc.getId(), doc.getLanguage());
  var rc = flowHelper.getRevisionController(cocoon);
  try {
    rc.reservedCheckIn("/content/authoring/" + path, ident.getUser().getId(), true); // FIXME: obtain file path from ?
    sendStatus(204);
  } catch (e) {
    sendStatus(412);
  }
}


function options(type) {
  cocoon.response.setHeader("DAV","1, 2");
  // cocoon.response.setHeader("DAV","1");
  var options = "";
  if (type == "source" || type == "asset") {
    options = "OPTIONS,GET,HEAD,POST,DELETE,TRACE,PROPFIND,PROPPATCH,COPY,MOVE,PUT,LOCK,UNLOCK";
  } else {
    options = "OPTIONS,GET,HEAD,POST,DELETE,TRACE,PROPFIND,PROPPATCH,COPY,MOVE,LOCK,UNLOCK";
  }
  cocoon.response.setHeader("Allow",options);

  //interoperability with Windows 2000
  var w2kDAVDiscoverAgent = "Microsoft Data Access Internet"
                          + " Publishing Provider Protocol Discovery";
  if (cocoon.request.getHeader("User-Agent") == w2kDAVDiscoverAgent) {
      cocoon.response.setHeader("MS-Author-Via","DAV");
  }

  sendStatus(200);
}

/*
 * parse the depth header to find out if recursion
 * take place. (used by MOVE and COPY)
 */

function isRecurse(depth) {
  var recurse;
  if (depth == null || depth == '') {
    recurse = true;
  }
  else if (depth == 'Infinity') {
    recurse = true;
  }
  else {
    recurse = false;
  }
  return recurse;
}

/*
 * convert the overwrite header into a boolean type
 */
function isOverwrite(header) {
  var overwrite = true;
  if (header == 'F') {
    overwrite = false;
  }
  return overwrite;
}


function mkcol() {
  var status = executeUsecase("webdav.mkcol");
  if(status)
    sendStatus(201);
  else
    sendStatus(403);
}


function invokeWorkflow(doc, eventName) {

  var webappURI = ServletHelper.getWebappURI(cocoon.request);  
  var wfFactory = Packages.org.apache.lenya.cms.workflow.WorkflowFactory.newInstance();
  var acSelector = cocoon.getComponent(Packages.org.apache.lenya.ac.AccessControllerResolver.ROLE + "Selector");
  var acResolver = acSelector.select("publication");
  var ac = acResolver.resolveAccessController(webappURI);

  var accreditableManager = ac.getAccreditableManager();
  var authorizers = ac.getAuthorizers();
  var policyManager = null;

  for (var i = 0; i < authorizers.length; i++) {
    if (authorizers[i] instanceof PolicyAuthorizer) {
      var policyAuthorizer = authorizers[i];
      policyManager = policyAuthorizer.getPolicyManager();
    }
  }

  var policy = policyManager.getPolicy(accreditableManager, doc.getCompleteURL());

  var identity = new Identity();
  var ident = identity.getIdentity(cocoon.session);
  var roles = policy.getRoles(ident);

  var sit = wfFactory.buildSituation(roles, ident);

  try {
    var wf = wfFactory.buildInstance(doc);
    wf.invoke(sit, eventName);
    return true;

  } catch (e) {
    cocoon.log.error(e);
  }

  return false;
}


function put() {

  var doc = cocoon.context.getAttribute("doc");
  var type = cocoon.context.getAttribute("type");
  var filename = cocoon.context.getAttribute("filename");

  if (type.equals("doc") || type.equals("assetdir")) {
    sendStatus(412);
  }
  
  var flowHelper = new FlowHelper();
  var documentHelper = flowHelper.getDocumentHelper(cocoon);
  var uri = null;

  if (type.equals("source")) {
    uri = documentHelper.getSourceUri(doc);
  } else {
    uri = "context:/lenya/pubs/" + doc.getPublication().getId() + "/resources/authoring" + doc.getId() + "/" + filename;
  }

  if (invokeWorkflow(doc, "edit")) {
    copySource("cocoon:/request/generate", uri); 
    sendStatus(200);

  } else {
    sendStatus(412);
  } 
}


function copySource(src, dest) {
 
  var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);
  cocoon.log.error("Copying resource " + src + " to dest " + dest);
  SourceUtil.copy(resolver, src, dest, true);

}


function remove() {
  var status = executeUsecase("webdav.delete");
  sendStatus(200);
}


function getRequestBody() {

  if (cocoon.request.getContentLength() > 0) {
    // var pipelineUtil = cocoon.createObject(Packages.org.apache.cocoon.components.flow.util.PipelineUtil)
    // var DOM = pipelineUtil.processToDOM("request/generate", null);
    // var str = DOM.documentElement;
    var out = new java.io.ByteArrayOutputStream();
    cocoon.processPipelineTo("request/generate", null, out);
    var bytes = out.toByteArray();
    var str = new java.lang.String(bytes);
    return str;
  }

  return null;
}


function getDoctype(doc) {

  var parameterizer = cocoon.getComponent(URIParameterizer.ROLE);
  var parameters = new Parameters();
  parameters.setParameter("doctype", "cocoon://uri-parameter/" + doc.getPublication().getId() + "/doctype");
  var map = parameterizer.parameterize("/authoring" + doc.getDocumentURL(), "/authoring" + doc.getDocumentURL(), parameters);

  var doctype = map.get("doctype");
  return doctype;
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


/** eLML specific method handlers **/

function propfindLesson () {

  var doc = cocoon.context.getAttribute("doc");
  var type = cocoon.context.getAttribute("type");
  var filename = cocoon.context.getAttribute("filename");

  // FIXME: refer to location with trailing slash in case client refers to collections without one (mac finder does so).

  // FIXME: - fetch requested props. Send 404 if missing prop requested
  // body = requestBody(request);
  // props[] = fetchProps(requestbody);

  if (type.equals("doc")) {

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

  } else if (type.equals("source")) {

    cocoon.sendPage("filePropfind.jx",
      {"doc" : doc,
       "url" : doc.getId() +
       "/index_" + doc.getLanguage() +
       ".xml"});

  } else if (type.equals("assetdir")) {

    var assetInfos = getAssetInfos(doc);
    var assetsDoc = new DefaultDocument(doc.getPublication(), doc.getId() + "/doc-assets");

    cocoon.sendPage("propfind.jx", {"doc" : assetsDoc, "assetInfos" : assetInfos});

  } else if (type.equals("asset")) {
     cocoon.sendPage("filePropfind.jx", {"doc" : doc, "url" : doc.getId() + "/doc-assets/" + filename});
  } else {
    sendStatus(404);
  }

}


function lockLesson() {
  cocoon.log.error("Locking lesson.."); 
  var doc = cocoon.context.getAttribute("doc");
  var type = cocoon.context.getAttribute("type");
  var filename = cocoon.context.getAttribute("filename");

  if (type.equals("doc") || type.equals("assetdir")) {
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
  var type = cocoon.context.getAttribute("type");

  if (type.equals("doc") || type.equals("assetdir")) {
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
