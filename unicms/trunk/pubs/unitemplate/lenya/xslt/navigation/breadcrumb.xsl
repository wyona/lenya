<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: breadcrumb.xsl,v 1.1 2004/05/26 10:43:39 gregor Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="nav"
    >
    

<xsl:template match="nav:site">
  <div id="breadcrumb" root="http://www.unizh.ch" label="Universit&#228;t Z&#252;rich">
    <xsl:apply-templates select="nav:node"/>
  </div>
</xsl:template>


<xsl:template match="nav:node[@id = 'index' or descendant-or-self::nav:node[@current = 'true']]">
  <div>
    <xsl:copy-of select="@*"/>
    <xsl:value-of select="nav:label"/>
  </div>
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet> 
