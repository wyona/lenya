<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: breadcrumb.xsl,v 1.1 2004/05/26 10:43:39 gregor Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="nav"
    >
    
<xsl:import href="node_attrs.xsl"/>

<xsl:template match="nav:site">
  <div id="breadcrumb">
    <xsl:apply-templates select="nav:node">
      <xsl:with-param name="position" select="'0'"/>
    </xsl:apply-templates>
  </div>
</xsl:template>

<xsl:template match="nav:site/nav:node[@id='index']"/>

<xsl:template match="nav:node">
 <xsl:param name="position"/>
 <xsl:if test="descendant-or-self::nav:node[@current = 'true']">
  <div>
<!-- the position attribute is needed to start the breadcrumb path at subhomepage level (not at root level) -->
    <xsl:attribute name="position">
      <xsl:value-of select="$position"/>
    </xsl:attribute>
    <xsl:apply-templates select="." mode="node_attrs"/>
  </div>
  <xsl:apply-templates select="nav:node">
    <xsl:with-param name="position" select="$position + 1"/>
  </xsl:apply-templates>
 </xsl:if>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet> 
