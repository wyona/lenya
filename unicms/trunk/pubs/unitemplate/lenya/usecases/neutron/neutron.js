/*
 * Copyright  1999-2004 The Apache Software Foundation
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

importClass(Packages.org.apache.lenya.cms.cocoon.flow.FlowHelper);
importClass(Packages.org.apache.excalibur.source.SourceResolver);
importClass(Packages.org.apache.lenya.cms.cocoon.source.SourceUtil);
importClass(Packages.org.apache.lenya.ac.Identity);
importClass(Packages.org.apache.lenya.cms.publication.DefaultDocumentIdToPathMapper);

/**
 * Provides flow functions for neutron protocol support.
   @see http://www.wyona.org/osr-101/osr-101.xhtml
 * @version $Id$
 */

/**
 * introspect a document and serve introspection file
 */

function introspect() {

      var flowHelper = new FlowHelper();
      var document = flowHelper.getPageEnvelope(cocoon).getDocument();
   
      cocoon.sendPage("introspection.jx", {"document" : document}); 
}

/**
 * opens a document source
 */
function open() {

   var flowHelper = new FlowHelper();
   var document = flowHelper.getPageEnvelope(cocoon).getDocument();

   var path = "/" + document.getId() + "/index_" + document.getLanguage() + ".xml";
   cocoon.sendPage("xml/" + path);
  
}


function save() {     
   
   var flowHelper = new FlowHelper();
   var document = flowHelper.getPageEnvelope(cocoon).getDocument();
   
   try {
     flowHelper.reservedCheckIn(cocoon, true);
     var resolver = cocoon.getComponent(SourceResolver.ROLE);
     var dstUri = flowHelper.getDocumentHelper(cocoon).getSourceUri(document);
     SourceUtil.copy(resolver, "cocoon:/request2document", dstUri, true);
     cocoon.sendStatus(200);
     return;
   
   } catch (e) {
    cocoon.log.error(e);
    cocoon.response.setStatus(500);
    cocoon.sendPage("exception-checkin.jx", {"message" : e});
    return;
  } 
 	
}

function checkout () {

  var flowHelper = new FlowHelper();
  var document = flowHelper.getPageEnvelope(cocoon).getDocument();
  var rc = flowHelper.getRevisionController(cocoon);
  
  var identity = new Identity();
  var userID = identity.getIdentity(cocoon.session).getUser().getId();


  var docToPathMapper = new DefaultDocumentIdToPathMapper();
  var path = docToPathMapper.getPath(document.getId(), document.getLanguage());

  if (!rc.canCheckOut("/content/authoring/" + path, userID)) { 
    cocoon.response.setStatus(500);
    var message = "Document has been checked out by some other user";
    cocoon.sendPage("exception-checkout.jx", {"message": message});
    return;
  }
 
  try {
    rc.reservedCheckOut("/content/authoring/" + path, userID);
  } catch (e) {
    cocoon.response.setStatus(500);
    cocoon.sendPage("exception-checkout.jx");
    return;
  }
  cocoon.sendPage("xml/" + path);
}


function checkin () {

   var flowHelper = new FlowHelper();
   var document = flowHelper.getPageEnvelope(cocoon).getDocument();
   
   try {
     flowHelper.reservedCheckIn(cocoon, true);
     var resolver = cocoon.getComponent(SourceResolver.ROLE);
     var dstUri = flowHelper.getDocumentHelper(cocoon).getSourceUri(document);
     SourceUtil.copy(resolver, "cocoon:/request2document", dstUri, true);
     cocoon.sendStatus(200);
     return;
   
   } catch (e) {
    cocoon.log.error(e);
    cocoon.response.setStatus(500);
    cocoon.sendPage("exception-checkin.jx", {"message" : e});
    return;
  }
  
}

function lock() {
  
  var flowHelper = new FlowHelper();
  var document = flowHelper.getPageEnvelope(cocoon).getDocument();
  var rc = flowHelper.getRevisionController(cocoon);
  
  var identity = new Identity();
  var userID = identity.getIdentity(cocoon.session).getUser().getId();


  var docToPathMapper = new DefaultDocumentIdToPathMapper();
  var path = docToPathMapper.getPath(document.getId(), document.getLanguage());

  if (!rc.canCheckOut("/content/authoring/" + path, userID)) { 
    cocoon.response.setStatus(500);
    var message = "Document has been checked out by some other user";
    cocoon.sendPage("exception-checkout.jx", {"message": message});
    return;
  }
 
  try {
    rc.reservedCheckOut("/content/authoring/" + path, userID);
  } catch (e) {
    cocoon.response.setStatus(500);
    cocoon.sendPage("exception-checkout.jx");
    return;
  }
  cocoon.sendPage("xml/" + path);
 
}

/** not covered by Neutron specs yet **/
function unlock () {
  var flowHelper = new FlowHelper();
  var document = flowHelper.getPageEnvelope(cocoon).getDocument();
   
  try {
    flowHelper.reservedCheckIn(cocoon, true);
    cocoon.sendStatus(200);
    return;
   
  } catch (e) {
    cocoon.log.error(e);
    cocoon.response.setStatus(500);
    cocoon.sendPage("exception-checkin.jx", {"message" : e});
    return;
  }
}


function authorize() {


}



function _getParameter(name, defaultValue) {
    if(cocoon.parameters[name])
        return cocoon.parameters[name];
    else
        return defaultValue;
}
