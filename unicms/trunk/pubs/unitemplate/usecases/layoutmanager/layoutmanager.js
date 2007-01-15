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
importClass(Packages.org.apache.cocoon.components.flow.util.PipelineUtil);


var PACKAGE_STORE_PATH = "resources/shared/layout-packages";
var INSTALL_DIRECTORY_PATH = "resources/shared/layout";
var REGISTRY_PATH = "usecases/layoutmanager/registry.xml";


function LayoutManager(aPackageStorePath, aInstallPath, aPublicationURL) {

  var registry =  new LayoutRegistry();
  registry.loadData(REGISTRY_PATH);
  this.registry = registry;
  this.availablePackages = registry.layoutPackages;
  cocoon.log.error(this.availablePackages);

  for (var i=0; i < this.availablePackages.length; i++) {
    cocoon.log.error("Available package: " + this.availablePackages[i].name);
  }

  var pkgStoreDirectory = new File(aPackageStorePath);
  this.pkgStoreDirectory = pkgStoreDirectory;

  this.installDirectory = new File(aInstallPath);
  this.publicationURL = aPublicationURL;


}


LayoutManager.prototype = {

  publicationURL: null,
  pkgStoreDirectory: null,
  installDirectory: null,
  availablePackages: null,
  registry: null,

  openWindow: function() {

    /* Main processing loop */

    while(cocoon.request.get("submit") != "Done") {

      var step = cocoon.request.get("lenya.step");

      if (step == "addPackage") {
        this.addPackage();
      }

      if (step == "deletePackage") {
        cocoon.log.error("Deleting Package...");
        var pkgName = cocoon.request.get("filename");
        this.deletePackage(pkgName);
      }

      if (step == "installPackage") {
        var pkgName = cocoon.request.get("filename");
        this.installPackage(pkgName);
      }

      cocoon.sendPageAndWait("manager.jx", {"packages": this.availablePackages});
    }
  },


  addPackage: function() {
    var uploadHelper = new UploadHelper(this.pkgStoreDirectory);
    var file = uploadHelper.save(cocoon.request, "upload-file");
    var name = file.getName();

    // Prevent from overriding existing packages
    if (this.registry.getPackage(name) != null) return;

    var title = cocoon.request.getParameter("package-title");
    if (!title) title = name;

    cocoon.log.error("Created Layout Package from upload with name, title" + name + ", " + title);
    
    var pkg = new LayoutPackage(name, title);

    this.registry.addPackage(pkg);
    
    this.availablePackages = this.registry.layoutPackages;

  },

  deletePackage: function(aPackageName) {
    var pkgStoreDirectory = this.pkgStoreDirectory;

    var pkg = new File(pkgStoreDirectory.getPath() + "/" + aPackageName);
    cocoon.log.error("Package to delete is: " + pkg.getPath());
    if (pkg.exists()) {
      pkg["delete"]();
      this.registry.removePackage(aPackageName);

      this.availablePackages = this.registry.layoutPackages; 
    }
  },


  installPackage: function(aPackageName) {
    var resolver = cocoon.getComponent(SourceResolver.ROLE);
    var installDirectory = this.installDirectory;

    if (aPackageName == "default_package") {
      // remove custom package
      this.deleteDirectory(this.installDirectory);
      var fakeLayoutPackage = new LayoutPackage("_def", "_def");
      this.registry.setInstalledFlag(fakeLayoutPackage);
      this.availablePackages = this.registry.layoutPackages;
      return;
    }

    var layoutPackage = new File(this.pkgStoreDirectory.getPath() + "/" + aPackageName);

    if (!layoutPackage.exists()) return;  // Throw error: registred archive missing 

    var zip = new ZipFile(layoutPackage);
    var zipEntries = zip.entries();

    while (zipEntries.hasMoreElements()) {

      var entry = zipEntries.nextElement();
      var name = entry.getName();
      var path =  entry.getName().substring(entry.getName().indexOf("/")); 

      var destinationPath = this.installDirectory.getPath() + path; 

      if (entry.isDirectory()) {
        cocoon.log.error("Entry is a directory");
        var dir = new File(destinationPath);
        if (!dir.exists()) {
          dir.mkdir();
        } 

        continue;
      }

      var is = zip.getInputStream(entry); 
      var source = resolver.resolveURI(destinationPath);

      try {
        var os = source.getOutputStream();

        /* Rewrite linked binaries in css stylesheets */
        if (path.indexOf(".css") > -1) {

          var sb = new StringBuffer();
          var buffer = new java.lang.reflect.Array.newInstance(java.lang.Byte.TYPE, 4096);
          var len;

          while((len = is.read(buffer)) >= 0)
            sb.append(new Packages.java.lang.String(buffer, 0, len));

          var cssContent = sb.toString();

          var cssURL = new URL(this.publicationURL + "/authoring/layout" + path);

          cssContent = this.rewriteCSSResources(cssContent, cssURL);

          var bis = new ByteArrayInputStream(cssContent.getBytes());
          SourceUtil.copy(bis, os);
          bis.close();

        } else {
          SourceUtil.copy(is, os);
        }

      } catch (e) {
        cocoon.log.error(e); 
      } finally {
        if (is != null) is.close();
        if (os != null) os.close();
      }

    }

    var pkg = this.registry.getPackage(aPackageName);
    this.registry.setInstalledFlag(pkg);
    this.availablePackages = this.registry.layoutPackages;

  },

  uninstallPackage: function(aPackage) {

  },


  rewriteCSSResources: function (aCSSContent, aBaseURL) {

    var baseURL = aBaseURL;
    var pattern = Pattern.compile("url\\((.*?)\\)");

    var matcher = pattern.matcher(aCSSContent);
    var sb = new StringBuffer();

    while(matcher.find()) {
     
      var relURL = matcher.group(1);
      var url = new URL(baseURL, relURL);
      var lenyaURL = url.toString().replaceFirst("layout/", "layout-"); // FIXME: find better pipeline matcher or remove reserved url namespaces from core

      matcher.appendReplacement(sb, "url(" + lenyaURL + ")");
    } 

    matcher.appendTail(sb);
    return sb.toString();

  },


  deleteDirectory: function(aDirectory) {

    if(aDirectory.exists() ) {
      var files = aDirectory.listFiles();
      for(var i=0; i<files.length; i++) {
         if(files[i].isDirectory()) {
           this.deleteDirectory(files[i]);
         }
         else {
           files[i]["delete"]();
         }
      }
    }
    return(aDirectory["delete"]());
 }

};


function LayoutRegistry() {


}


LayoutRegistry.prototype = {
 
  registryDocument: null,
  layoutPackages: null,
  registryFilePath: null,

  loadData: function (aFilePath) {
    
    cocoon.log.error("Loading registry document");
    var pipelineUtil = cocoon.createObject(Packages.org.apache.cocoon.components.flow.util.PipelineUtil);

    var registryDocument = pipelineUtil.processToDOM("xml/" + aFilePath, null);
    cocoon.log.error("Document loaded" + registryDocument.documentElement);
    this.registryDocument = registryDocument;
    this.registryFilePath = aFilePath;
    this.layoutPackages = new Array();    
    
    var pkgElements = registryDocument.getElementsByTagName("package"); 
   
    for (var i = 0; i < pkgElements.length; i++) {
      var elem = pkgElements.item(i);
      var name = elem.getAttribute("name");
      var title = elem.getAttribute("title");
      var installed = elem.getAttribute("installed");
      cocoon.log.error("Registry has package: " + name + ", " + title);

      var pkg = new LayoutPackage(name, title);
      if (installed == "true") pkg.installed = true;
      this.layoutPackages.push(pkg);
    }


  },


  getPackage: function (aPackageName) {

    for(var i = 0; i < this.layoutPackages.length; i++) {
      var pkg = this.layoutPackages[i];
      if (pkg.name.equals(aPackageName)) {
        return pkg;
      }
    }

    return null;  

  },


  addPackage: function (aPackage) {

    var resolver = cocoon.getComponent(SourceResolver.ROLE);
    var pkgElem = this.registryDocument.createElement("package");
 
    pkgElem.setAttribute("name", aPackage.name);
    pkgElem.setAttribute("title", aPackage.title);

    this.registryDocument.documentElement.appendChild(pkgElem); 

    var flowHelper = new FlowHelper();
    var publicationPath = flowHelper.getPageEnvelope(cocoon).getPublication().getDirectory().getPath(); 
    var registryPath = publicationPath + "/" + this.registryFilePath;
    cocoon.log.error("Registry Path: " + registryPath);

    var source = resolver.resolveURI(registryPath);
    var out = source.getOutputStream();
    cocoon.log.error("Serializing registryDocument to: " + out);
    cocoon.processPipelineTo("createdocument",  {"dom" : this.registryDocument} , out);
    out.close();

    this.layoutPackages.push(aPackage);

  },


  removePackage: function (aPackageName) {

    var resolver = cocoon.getComponent(SourceResolver.ROLE);
    var flowHelper = new FlowHelper();
    var publicationPath = flowHelper.getPageEnvelope(cocoon).getPublication().getDirectory().getPath();
    var registryPath = publicationPath + "/" + this.registryFilePath;
    var source = resolver.resolveURI(registryPath);

    cocoon.log.error("Removing package with name: " + aPackageName);
    for (var i = 0; i < this.layoutPackages.length; i++) {
      var pkg = this.layoutPackages[i];
      if (pkg.name.equals(aPackageName)) {
        this.layoutPackages.splice(i, 1);
      }
    }  

    var pkgElements = this.registryDocument.getElementsByTagName("package");

    for (var i = 0; i < pkgElements.length; i++) {
      var elem = pkgElements.item(i);
      if (elem.getAttribute("name").equals(aPackageName)) {
        elem.parentNode.removeChild(elem);
      }
    }

    var out = source.getOutputStream();
    cocoon.log.error("Serializing registryDocument to: " + out);
    cocoon.processPipelineTo("createdocument",  {"dom" : this.registryDocument} , out);
    out.close();

  }, 

  setInstalledFlag: function (aPackage) {

    var resolver = cocoon.getComponent(SourceResolver.ROLE);
    var flowHelper = new FlowHelper();
    var publicationPath = flowHelper.getPageEnvelope(cocoon).getPublication().getDirectory().getPath();
    var registryPath = publicationPath + "/" + this.registryFilePath;
    var source = resolver.resolveURI(registryPath);

    cocoon.log.error("Setting installed flag for package: " + aPackage.name);

    for (var i = 0; i < this.layoutPackages.length; i++) {
      var pkg = this.layoutPackages[i];
      if (pkg.name.equals(aPackage.name)) {
        pkg.installed = true;
      } else {
        pkg.installed = null;
      }
    } 

    var pkgElements = this.registryDocument.getElementsByTagName("package");

    for (var i = 0; i < pkgElements.length; i++) {
      var elem = pkgElements.item(i);
      if (elem.getAttribute("name").equals(aPackage.name)) {
        elem.setAttribute("installed", "true"); 
      } else {
        elem.removeAttribute("installed");
      }
    }

    var out = source.getOutputStream();
    cocoon.log.error("Serializing registryDocument to: " + out);
    cocoon.processPipelineTo("createdocument",  {"dom" : this.registryDocument} , out);
    out.close(); 
  },

};


function LayoutPackage(aName, aTitle) {
  this.name = aName;
  this.title = aTitle;
}


LayoutPackage.prototype = {

  name: null,
  title: null,
  installed: null,

}





/** Layout manager usecase. Installs/uninstalls layout packages.  
** @author Thomas Comiotto
**/


function init() {

  var flowHelper = new FlowHelper();
  var pageEnvelope = flowHelper.getPageEnvelope(cocoon);

  var contextPath = pageEnvelope.getContext();
  var publication = pageEnvelope.getPublication();
  var publicationDirectory = publication.getDirectory();

  var documentURL = pageEnvelope.getDocument().getCompleteURL();

  var publicationURL = "http://" + cocoon.request.getServerName() + 
      ":" + cocoon.request.getServerPort() +
      contextPath + "/" + publication.getId();
 
  cocoon.log.error("PublicationURL: " + publicationURL );

  var packageStorePath = publicationDirectory + "/" + PACKAGE_STORE_PATH;
  var installDirectoryPath = publicationDirectory + "/" + INSTALL_DIRECTORY_PATH;

  var manager = new LayoutManager(packageStorePath, installDirectoryPath, publicationURL);
  manager.openWindow();

  cocoon.redirectTo(documentURL);

}



function sendStatus(sc) {
  cocoon.sendStatus(sc);
}

