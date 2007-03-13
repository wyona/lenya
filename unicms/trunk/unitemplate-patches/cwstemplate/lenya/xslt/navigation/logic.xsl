<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: logic.xsl, v 1.00 2006/12/01 17:00:00 mike Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns="http://www.w3.org/1999/xhtml">

 <xsl:include href="../../xslt-fallback/navigation/logic.xsl"/>


<xsl:template match="xhtml:div[(@id = 'menu')]">
  <xsl:choose>
    <xsl:when test="$index"/>
    <xsl:when test="xhtml:div[@current = 'true' or descendant::xhtml:div[@current = 'true']]/*">

      <div id="menu">
        <xsl:apply-templates select="xhtml:div[@current = 'true' or descendant::xhtml:div[@current = 'true']]/*"/>
      </div>

    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:template>


<xsl:template match="xhtml:div[@id = 'tabs']">
    <div id="tabs">
      <xsl:apply-templates/>
    </div>
</xsl:template>


<xsl:template match="xhtml:div[@id = 'sub-tabs']"/>


</xsl:stylesheet>