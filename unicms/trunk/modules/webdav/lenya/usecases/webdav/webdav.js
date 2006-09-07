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


cocoon.load("util.js");

importClass(Packages.org.apache.lenya.cms.cocoon.flow.FlowHelper);
importClass(Packages.org.apache.lenya.ac.Identity);
importClass(Packages.org.apache.lenya.cms.publication.DefaultDocument);
importClass(Packages.org.apache.lenya.cms.publication.DefaultDocumentIdToPathMapper);
importClass(Packages.org.safehaus.uuid.UUIDGenerator);

 
const DAV_PREFIX = "webdav";
const ASSETS_DIR = "doc-assets";


function method() {

  var method = cocoon.request.getMethod();

  // Build requested document and retrieve doctype

  var docid = cocoon.parameters.docid;
  var lang = cocoon.parameters.language;
  var doc = buildDocument(docid, lang);
  
  var doctype = "default";
  if (!docid.equals("/")) {
    doctype = getDoctype(doc);
  } 

  if (cocoon.parameters.location) {
    cocoon.response.addHeader("content-location", cocoon.parameters.location);
  }

  cocoon.context.setAttribute("mapto", cocoon.parameters.mapto);
  cocoon.context.setAttribute("doc", doc);
  cocoon.context.setAttribute("asset", cocoon.parameters.asset);

  cocoon.sendPage(method + "/" + doctype);

}


function get() {

  var doc = cocoon.context.getAttribute("doc");
  var mapto = cocoon.context.getAttribute("mapto");

   if (mapto.equals("source")) {
     var path = "/" + doc.getId() + "/index_" + doc.getLanguage() + ".xml";
     cocoon.sendPage("xml/" + path);
   } else if (mapto.equals("asset")) {
     var asset = cocoon.context.getAttribute("asset");
     cocoon.sendPage("asset/" + asset, {"docid" : doc.id});
   } else {

     /** FIXME: GET on collection could return xhtml view of default language **/
     sendStatus(404);
   }
}


function propfind() {

  var doc = cocoon.context.getAttribute("doc");
  var mapto = cocoon.context.getAttribute("mapto");

  // FIXME: - fetch requested props. Send 404 if missing prop requested 
  // body = requestBody(request);
  // props[] = fetchProps(requestbody);

  if (mapto.equals("document")) {

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

  } else if (mapto.equals("source")) {

    var rcmlEntry = getLatestRCMLEntry(doc);
    cocoon.sendPage("filePropfind.jx", 
      {"doc" : doc, 
       "url" : doc.getId() + "/index_" + doc.getLanguage() + ".xml", 
       "rcmlEntry" : rcmlEntry}
    );

  } else if (mapto.equals("assetdir")) {

    var assetInfos = getAssetInfos(doc);
    var assetsDoc = new DefaultDocument(doc.getPublication(), doc.getId() + "/doc-assets");
    cocoon.sendPage("propfind.jx", {"doc" : assetsDoc, "assetInfos" : assetInfos});

  } else if (mapto.equals("asset")) {
     var asset = cocoon.context.getAttribute("asset");
     var rcmlEntry = getLatestRCMLEntry(doc);
     cocoon.sendPage("filePropfind.jx", {"doc" : doc, "url" : doc.getId() + "/doc-assets/" + asset, "rcmlEntry" : rcmlEntry});
  } else {
    sendStatus(404);
  }
}


function put() {

  var doc = cocoon.context.getAttribute("doc");
  var mapto = cocoon.context.getAttribute("mapto");

  if (mapto.equals("document") || mapto.equals("assetdir")) {
    sendStatus(412);
  }

  var flowHelper = new FlowHelper();
  var documentHelper = flowHelper.getDocumentHelper(cocoon);
  var uri = null;

  if (mapto.equals("source")) {
    uri = documentHelper.getSourceUri(doc);
  } else {
    var asset = cocoon.context.getAttribute("asset");
    uri = "context:/lenya/pubs/" + doc.getPublication().getId() + "/resources/authoring" + doc.getId() + "/" + asset;
  }

  if (invokeWorkflow(doc, "edit")) {
    copySource("cocoon:/request/generate", uri);
    sendStatus(200);

  } else {
    sendStatus(412);
  }
}







function lock() {
  
  var doc = cocoon.context.getAttribute("doc");
  var mapto = cocoon.context.getAttribute("mapto");

  /** FIXME: checkout doc on selecting dirs, assets etc. **/
  if (mapto.equals("document") || mapto.equals("assetdir")) {
    sendStatus(412);
  }

  // FIXME: fetch lockinfo from request body

  var identity = new Identity();
  var ident = identity.getIdentity(cocoon.session);

  if (checkout(ident, doc)) {
    if (mapto.equals("source")) {
      uri = doc.getCompleteURL(); 
    } else {
      var asset = cocoon.context.getAttribute("asset");
      uri = "/lenya/unitemplate/authoring/resources" + doc.getId() + "/" + asset;
    }
    cocoon.sendPage("lock.jx", {"uri" : uri, "identity" : ident});
  } else {
    sendStatus(412);
  }

}


function unlock() {
 
  var doc = cocoon.context.getAttribute("doc");
  var mapto = cocoon.context.getAttribute("mapto");

  if (mapto.equals("document") || mapto.equals("assetdir")) {
    sendStatus(412);
  }

  // FIXME: fetch lockinfo from request body

  var identity = new Identity();
  var ident = identity.getIdentity(cocoon.session);
  if (checkin(ident, doc)) {
    sendStatus(204);
  } else {
    sendStatus(412);
  }
}


function options() {

  var mapto = cocoon.context.getAttribute("mapto");

  cocoon.response.setHeader("DAV","1, 2");
  var options = "";

  if (mapto.equals("source") || mapto.equals("asset")) {
    options = "OPTIONS,GET,HEAD,POST,DELETE,TRACE,PROPFIND,PROPPATCH,COPY,MOVE,PUT,LOCK,UNLOCK";
  } else {
    options = "OPTIONS,GET,HEAD,POST,DELETE,TRACE,PROPFIND,PROPPATCH,COPY,MOVE,LOCK,UNLOCK";
  }
  cocoon.response.setHeader("Allow", options);

  //interoperability with Windows 2000
  var w2kDAVDiscoverAgent = "Microsoft Data Access Internet"
                          + " Publishing Provider Protocol Discovery";
  if (cocoon.request.getHeader("User-Agent") == w2kDAVDiscoverAgent) {
      cocoon.response.setHeader("MS-Author-Via","DAV");
  }

  sendStatus(200);
}


/** Helper functions **/

function getDepth(request) {
  if (request.getHeader("Depth") != null) {
    return request.getHeader("depth");
  } 
  return "infinity";
}

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

