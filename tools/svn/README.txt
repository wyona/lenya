SVN-LENYA client
****************
Goals
  o For version control and off-line edit.
  o The Lenya content shall be based on a local SVN workspace
  o the CMS does not query the repository for every request, 
    but has a background process which does SVN updates according to a queue (not implemented yet)
  o client processes can intervene to push a part of the document space to the front of the queue (not implemented yet)
  o when updates are pulled from the SVN repository the CMS regenerates dependent files 
    (e.g. HTML and PDF from wiki syntax) (not implemented yet)
  o Notification/Observer: The CMS is observing or being notified by the SVN server (not implemented yet)

Setup:
Edit the config.xml file to match your password, username, ... short all default configuration
parameter that you may want to change.

Note: 
<urlRep/> and <localRep/> should point to the dir where as well the lenya sitetree.xml exists.

Important:
Till now only modification (M) and svn adds (A) are supported. 
If you add a new document, the svn-client will generate the meta files on the fly.