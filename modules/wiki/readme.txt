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

6) Open build/lenya/webapp/lenya/pubs/default/content/authoring/sitetree.xml
    6.1)    Add on line ~55:
            <node id="wiki">
              <label xml:lang="en">Wiki Doctype</label>
              <label xml:lang="de">Wiki Dokumenttyp</label>
            </node>

7) copy opendocument folder from  build/lenya/webapp/lenya/pubs/default/content/authoring/doctypes/ to wiki
    7.1) Delete both *.odt files
    7.2) Open index_en.xml.meta change Line 11:
         <lenya:resourceType>wiki</lenya:resourceType>
         <lenya:contentType>wiki</lenya:contentType>
    7.3) Repeate for index_de.xml.meta

8) create sample files in build/lenya/webapp/lenya/pubs/default/content/authoring/doctypes/index_en.xml (and index_de.xml) (make a newline at end of the files!!!)

9) Start Lenya, login to default pub, check Wiki Doctype.
