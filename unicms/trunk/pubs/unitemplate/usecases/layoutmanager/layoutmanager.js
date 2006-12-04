
importClass(Packages.java.io.File);
importClass(Packages.java.util.zip.ZipFile);
importClass(Packages.org.apache.lenya.cms.authoring.UploadHelper);
importClass(Packages.java.util.ArrayList);
importClass(Packages.org.apache.lenya.cms.cocoon.flow.FlowHelper);
importClass(Packages.org.apache.excalibur.source.SourceResolver);
importClass(Packages.org.apache.excalibur.source.SourceUtil);
importClass(Packages.java.io.FileOutputStream);
importClass(Packages.java.lang.StringBuffer);
importClass(Packages.java.io.ByteArrayInputStream);
importClass(Packages.java.util.regex.Pattern);
importClass(Packages.java.util.regex.Matcher);
importClass(Packages.java.net.URL);

var referer;
var packages;
var packagesDir;
var installDir;

/** Layout manager usecase. Manages layout packages.  
** @author Thomas Comiotto
**/



function manager() {

  referer = cocoon.request.getHeader("referer");

  var flowHelper = new FlowHelper();
  var pubDir = flowHelper.getPageEnvelope(cocoon).getPublication().getDirectory();
  packagesDir = new File(pubDir + "/resources/shared/layout-packages");
  installDir = new File(pubDir + "/resources/shared/layout");


  cocoon.log.error("Opening layout manager");
  if (packagesDir.exists()) {
    packages = packagesDir.listFiles();
  }
  
  dialog();

}


function dialog() {

  if (cocoon.request.get("submit") == "Done") {
    cocoon.redirectTo(referer);
  }


  if (cocoon.request.get("upload-file") != null) {
    add();
  }

  if (cocoon.request.get("lenya.step") == "remove") {
    remove();
  }

  if (cocoon.request.get("lenya.step") == "install" && cocoon.request.get("submit") == "Install") {
    install();
  }

  cocoon.sendPageAndWait("manager.jx", {"packages": packages}); 
  dialog();

}


function add() {
    var uploadHelper = new UploadHelper(packagesDir);
    var file = uploadHelper.save(cocoon.request, "upload-file");
    packages = packagesDir.listFiles();
}


function remove() {
   var layoutPackage = new File(packagesDir.getPath() + "/" + cocoon.request.get("filename"));
   cocoon.log.error(layoutPackage.getPath());
   if (layoutPackage.exists()) {
     layoutPackage["delete"]();
     packages = packagesDir.listFiles();
   }
}


function install() {
 
  var resolver = cocoon.getComponent(SourceResolver.ROLE);
  var packageName = cocoon.request.get("filename");

  if (packageName == "default_package") {
    // remove custom package
   deleteDirectory(installDir);
   return;
  }   

  var layoutPackage = new File(packagesDir.getPath() + "/" + cocoon.request.get("filename")); 
  var zip = new ZipFile(layoutPackage);

  var entries = zip.entries();

  for (entries; entries.hasMoreElements();) {
    var entry = entries.nextElement();
    var relCSSPath = entry.getName().substring(entry.getName().indexOf("/") + 1);
    var destPath = installDir.getPath() + "/" + relCSSPath;

    /* Rewrite linked binaries in css stylesheets */
    if (entry.getName().indexOf(".css") > -1) {
      var is = zip.getInputStream(entry);
      var sb = new StringBuffer();
      var buffer = new java.lang.reflect.Array.newInstance(java.lang.Byte.TYPE, 4096);
      var len;

       while((len = is.read(buffer)) >= 0)
          sb.append(new Packages.java.lang.String(buffer, 0, len));

       var cssString = sb.toString();
 
       var pattern = Pattern.compile("url\\((.*?)\\)");

       var matcher = pattern.matcher(cssString);
       var sb = new StringBuffer();

       while(matcher.find()) {
     
         var cssURL = new URL("http://localhost:8888/unitemplate/authoring/layout/" + relCSSPath);
         var relURL = matcher.group(1);
         var url = new URL(cssURL, relURL);
         var lenyaURL = url.toString().replaceFirst("layout/", "layout-"); // FIXME: find better pipeline matcher or remove reserved url namespaces from core

         matcher.appendReplacement(sb, "url(" + lenyaURL + ")");
       } 

       matcher.appendTail(sb);
       cssString = sb.toString();

       var is = new ByteArrayInputStream(cssString.getBytes());
       var source = resolver.resolveURI(destPath);
       var os = source.getOutputStream();
       SourceUtil.copy(is, os);      
       is.close();
       os.close(); 

    } else if (!entry.isDirectory()) {
      var is = zip.getInputStream(entry);
      var source = resolver.resolveURI(destPath); 
      var os = source.getOutputStream(); 
      SourceUtil.copy(is, os);
      is.close();
      os.close();
    }

  }

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


function deleteDirectory(path) {
    if(path.exists() ) {
      var files = path.listFiles();
      for(var i=0; i<files.length; i++) {
         if(files[i].isDirectory()) {
           deleteDirectory(files[i]);
         }
         else {
           files[i]["delete"]();
         }
      }
    }
    return(path["delete"]());
 }






function sendStatus(sc) {
  cocoon.sendStatus(sc);
}

