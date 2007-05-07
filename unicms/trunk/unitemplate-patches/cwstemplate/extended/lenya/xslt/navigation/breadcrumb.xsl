<?xml version="1.0" encoding="UTF-8" ?>
<!-- $Id: breadcrumb.xsl,v 1.1 2004/05/26 10:43:39 gregor Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
>


<xsl:include href="../../xslt-fallback/navigation/breadcrumb.xsl"/>


<!-- overwrite included templates -->

<xsl:template match="nav:site" priority="1">
  <div id="breadcrumb">
    <xsl:choose>
      <xsl:when test="descendant-or-self::nav:node[@current = 'true']/nav:label/@xml:lang = 'en'">
        <xsl:attribute name="root">
          <xsl:text>http://www.uzh.ch/index_en.html</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="label">
          <xsl:text>University of Zurich</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="root">
          <xsl:text>http://www.uzh.ch</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="label">
          <xsl:text>Universit&#228;t Z&#252;rich</xsl:text>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="nav:node[@id = 'index' or descendant-or-self::nav:node[@current = 'true']]"/> 
  </div>
</xsl:template>


<xsl:template match="nav:node[@id = 'index' or descendant-or-self::nav:node[@current = 'true']]" priority="1">
  <div>
    <xsl:copy-of select="@href"/>
    <xsl:copy-of select="@basic-url"/>
    <xsl:copy-of select="@current"/>
    <xsl:value-of select="nav:label"/>
  </div> 
 <xsl:apply-templates select="nav:node"/> 
</xsl:template>

</xsl:stylesheet> 
