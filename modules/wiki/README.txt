Wiki Module Installation (default Publication) BETA
---------------------------------------------------

1) Add wiki module path to local.build.properties of Lenya

2) Add the default-wiki publication path to local.build.properties
   (https://svn.wyona.com/repos/public/lenya/pubs/defaultwiki)

   OR

   - patch the default publication build/lenya/webapp/lenya/pubs/default/sitemap.xmap
     - Uncomment Line 111: <map:part src="cocoon://modules/{page-envelope:document-type}/{1}.xml"/>
     - Comment Line 113: <map:part src="{resource-type:format-xhtml}"/>

   - Add <module name="wiki"/> to config/publication.xconf
   
   - Add the following usecases to {yourpub}/config/ac/usecase-policies.xml
		        
		    <usecase id="wiki.create">
		      <role id="admin"/>
		      <role id="edit"/>
		    </usecase>  
		
		    <usecase id="wiki.edit">
		      <role id="admin"/>
		      <role id="edit"/>
		    </usecase>  

3) Build Lenya

4) Start Lenya, login to default-wiki or default pub and create a new Wiki document


CHANGELOG:

-edit usecase works now with an uri view which is build dynamically. edit.jx is not used anymore.
