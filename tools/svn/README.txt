SVN-LENYA client
****************

For version control and off-line edit of Lenya content repository, using a local SVN workspace

Features:
  o Shell script to wrap the Java implementation
  o Creates Lenya meta files automagically
  o Adds new nodes to the sitetree.xml file

Roadmap (proposal):
  o The CMS does not query the repository for every request, 
    but has a background process which does SVN updates according to a queue (not implemented yet)
  o Client processes can intervene to push a part of the document space to the front of the queue (not implemented yet)
  o When updates are pulled from the SVN repository the CMS regenerates dependent files 
    (e.g. HTML and PDF from wiki syntax) (not implemented yet)
  o Notification/Observer: The CMS is observing or being notified by the SVN server (not implemented yet)

Configure:
Edit the config.xml file to match your password, username, ... short all default configuration
parameter that you may want to change.
Note: <urlRep/> and <localRep/> should point to the dir where as well the lenya sitetree.xml exists.

Install:
go to where you downloaded .../tools/svn
execute ant to build the client

Usage:
* user makes changes on her local svn copy
* user updates her local copy (svn up)
* user adds the new files to be commited (svn add)
* user runs the script to commit her changes
* script does the following:
  ** for modified docs, just add and commit it
  ** for new docs:
     *** asks for resourcetype for each new document
     *** create metadata (java.io), add it for commit
     *** if everything is fine, update sitetree (DOM) and commit the whole thing (atomic commit)
  ** if the script cannot cope with the local modifications, it throws error, and ask the user to clean her repository.
  
Limitations of the solution:
* user can only add documents (no ressources)
* expects the user to create documents with the "correct" name and structure for Lenya (the user needs to create a new folder, with a "index_en.xml file in it").
* only add new doc (svn status "A") or modify existing doc (svn status "M").
* no conflict management, will throw an error if it cannot handle the local changes
* several meta data values  are set to hardcoded default values.
* no creation of revision control files (RCML) --> cannot roll back