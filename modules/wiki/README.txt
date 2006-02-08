Wiki Module Installation (default Publication) BETA
---------------------------------------------------

1) Add wiki module path to local.build.properties of Lenya

2) Build lenya

4) Open build/lenya/webapp/lenya/pubs/default/sitemap.xmap
    4.1)    Uncomment Line 111: <map:part src="cocoon://modules/{page-envelope:document-type}/{1}.xml"/>
    4.2)    Comment Line 113: <map:part src="{resource-type:format-xhtml}"/>

5) Open build/lenya/webapp/lenya/pubs/default/config/publication.xconf
    5.1)    Add on line ~40 <module name="wiki"/>

6) Start Lenya, login to default pub, create a new Wiki document
