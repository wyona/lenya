<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: footer.xsl,v 1.10 2004/11/24 11:52:50 jann Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 

  <xsl:template name="footer">
    <div class="footermargintop"><xsl:comment/></div>
    <div class="topnav"><a href="#top">top</a></div>
    <div class="solidline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1" /></div>
    <div id="footer">&#169; 2007 ESO - Economic and Social History online | <a href="{/document/xhtml:div[@id = 'footnav']/xhtml:div[@id = 'impressum']/@href}"><xsl:value-of select="/document/xhtml:div[@id = 'footnav']/xhtml:div[@id = 'impressum']"/></a></div>
  </xsl:template>
  
</xsl:stylesheet>
