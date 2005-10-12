<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: menu.xsl,v 1.5 2005/02/24 15:29:24 jann Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="nav"
    >
   
 
<xsl:template match="nav:site">
  <div id="servicenav">
    <div id="home" href="{nav:node[@id = 'index']/@href}">Home</div>
    <xsl:apply-templates select="nav:node[@id = 'contact']"/>
    <xsl:apply-templates select="nav:node[@id = 'sitemap']"/>
    <xsl:apply-templates select="nav:node[@id = 'search']"/>
  </div>
</xsl:template>


<xsl:template match="nav:node">
  <div id="{@id}" href="{@href}"><xsl:value-of select="."/></div>
</xsl:template>

</xsl:stylesheet>

