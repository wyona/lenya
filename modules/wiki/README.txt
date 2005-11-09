Wiki Module Installation (default Publication) BETA
---------------------------------------------------

1) Copy lib/WikiParser.jar to lenya-trunk/lib/WikiParser.jar

2) Copy wiki module folder to lenya-trunk/src/modules/wiki

3) Build lenya

4) Open build/lenya/webapp/lenya/pubs/default/sitemap.xmap
    4.1)    Uncomment Line 120-123
    4.2)    Delete Line 124

5) Open build/lenya/webapp/lenya/pubs/default/config/publication.xconf
    5.1)    Add on line ~40 <module name="wiki"/>

6) Start Lenya, login to default pub, create a new Wiki document

TODO's
------

* Modify some File's from Lenya that not so much have to get changed at build time.
* Finish Link-management (i.E. Sitetree)
* Maven tweaking / Installation
* Find & Fix Bugs (test Syntax more and more)
* maybe think about fileupload (versioning)
