Wiki Module Installation (default Publication) BETA
---------------------------------------------------

1) Add wiki module path to local.build.properties of Lenya

2) Add the default-wiki publication path to local.build.properties
   (https://svn.wyona.com/repos/public/lenya/pubs/defaultwiki)

   OR

   patch the default publication build/lenya/webapp/lenya/pubs/default/sitemap.xmap

    - Uncomment Line 111: <map:part src="cocoon://modules/{page-envelope:document-type}/{1}.xml"/>
    - Comment Line 113: <map:part src="{resource-type:format-xhtml}"/>

    - Add <module name="wiki"/> to config/publication.xconf

3) Build Lenya

4) Start Lenya, login to default-wiki or default pub and create a new Wiki document
