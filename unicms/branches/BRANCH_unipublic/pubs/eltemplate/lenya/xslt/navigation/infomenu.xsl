<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: infomenu.xsl,v 1.4 2005/03/21 13:11:29 thomas Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="nav"
    >


<xsl:template match="nav:site">
  <xsl:apply-templates select="nav:node[position() = last()]"/>
</xsl:template>

<xsl:template match="nav:node">
  <div id="infomenu" title="{nav:label}">
     <xsl:for-each select="nav:node">
       <a href="{@href}"><xsl:apply-templates select="nav:label"/></a> 
       <xsl:if test="position() != last()">&#160;&#160;|&#160;&#160;</xsl:if>
     </xsl:for-each>
  </div>
</xsl:template>


</xsl:stylesheet> 
