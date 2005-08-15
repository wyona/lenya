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
  <div id="menu">
      <xsl:apply-templates select="nav:node"/>
  </div>
</xsl:template>

<xsl:template match="nav:node[@visibleinnav = 'false']"/>

<xsl:template match="nav:node">
 <div>
  <xsl:apply-templates select="." mode="node_attrs"/>
  <xsl:apply-templates select="nav:node"/>
 </div>
</xsl:template>


<!-- hide everything but siblings, parents and first level children. yes its that complicated :) -->
<xsl:template match="nav:node/nav:node
          [not(ancestor-or-self::nav:node[@current = 'true']) and
           not(descendant-or-self::nav:node[@current = 'true']) and
           not(..//nav:node[@current = 'true'])]"/>


<xsl:template match="nav:node[@current = 'true']/*/nav:node"/>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet> 
