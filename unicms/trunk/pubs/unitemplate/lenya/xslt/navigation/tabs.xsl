<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: menu.xsl,v 1.5 2005/02/24 15:29:24 jann Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="nav"
    >
   
<xsl:import href="node_attrs.xsl"/>
    

<xsl:template match="nav:site">
  <div id="tabs">
    <xsl:apply-templates select="nav:node[position() &gt; 1]"/>
  </div>
</xsl:template>

<xsl:template match="nav:node[@visibleinnav = 'false']"/>

<xsl:template match="nav:node">
 <div>
  <xsl:apply-templates select="." mode="node_attrs"/>
 </div>
</xsl:template>


</xsl:stylesheet> 
