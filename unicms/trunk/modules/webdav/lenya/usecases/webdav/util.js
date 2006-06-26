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

<!-- $Id: webdav.js 344359 2005-11-15 12:44:22Z thomas $ -->

importClass(Packages.java.util.ArrayList);
importClass(Packages.java.io.ByteArrayOutputStream);
importClass(Packages.org.apache.lenya.cms.cocoon.flow.FlowHelper);
importClass(Packages.org.apache.lenya.xml.DocumentHelper); 
importClass(Packages.org.apache.lenya.cms.publication.DefaultDocument);
importClass(Packages.org.apache.avalon.framework.parameters.Parameters);
importClass(Packages.org.apache.lenya.cms.cocoon.uriparameterizer.URIParameterizer);
importClass(Packages.org.apache.lenya.cms.publication.ResourcesManager);
importClass(Packages.org.apache.lenya.ac.Identity);
importClass(Packages.org.apache.lenya.cms.publication.DefaultDocumentIdToPathMapper);
importClass(Packages.org.apache.lenya.cms.cocoon.source.SourceUtil);
importClass(Packages.org.apache.lenya.ac.impl.PolicyAuthorizer);
importClass(Packages.org.apache.lenya.util.ServletHelper);



function checkin (ident, doc) {

  var flowHelper = new FlowHelper();
  var docToPathMapper = new DefaultDocumentIdToPathMapper();
  var path = docToPathMapper.getPath(doc.getId(), doc.getLanguage());
  var rc = flowHelper.getRevisionController(cocoon);

  try {
    rc.reservedCheckIn("/content/authoring/" + path, ident.getUser().getId(), true); // FIXME: obtain file path from ?
    return true;
  } catch (e) {
    return false;
  }
  return false;
}


function checkout (ident, doc) {

  var flowHelper = new FlowHelper();
  var docToPathMapper = new DefaultDocumentIdToPathMapper();
  var path = docToPathMapper.getPath(doc.getId(), doc.getLanguage());
  var rc = flowHelper.getRevisionController(cocoon);

  if (rc.canCheckOut(path, ident)) {
    try {
      var uri = null;
      rc.reservedCheckOut("/content/authoring/" + path, ident.getUser().getId()); // FIXME: obtain file path from ?
      return true;
    } catch (e) {
      return false;
    }
  }
  return false;
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


function copySource(src, dest) {
 
  var resolver = cocoon.getComponent(Packages.org.apache.excalibur.source.SourceResolver.ROLE);
  cocoon.log.error("Copying resource " + src + " to dest " + dest);
  SourceUtil.copy(resolver, src, dest, true);

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

