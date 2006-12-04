<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: logic-add-on.xsl, v 1.00 2006/12/01 17:00:00 mike Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns="http://www.w3.org/1999/xhtml">


<xsl:template match="xhtml:div[(@id = 'menu')][(($isHomepage = 'true') and ($homepage-basic-url = 'index')) or ($super-homepage-basic-url = 'index')]">
  <xsl:choose>
    <xsl:when test="$index"/>
    <xsl:when test="xhtml:div[@current = 'true']"/>
    <xsl:when test="*/xhtml:div[@current = 'true' or descendant::xhtml:div[@current = 'true']]/*">

      <div id="menu">
        <xsl:apply-templates select="*/xhtml:div[@current = 'true' or descendant::xhtml:div[@current = 'true']]/*"/>
      </div>

    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:template>


<xsl:template match="xhtml:div[@id = 'tabs'][(($isHomepage = 'true') and ($homepage-basic-url = 'index')) or ($super-homepage-basic-url = 'index')]">
  <div id="tabs">
    <xsl:apply-templates/>
  </div>
</xsl:template>


<xsl:template match="xhtml:div[@id = 'sub-tabs']">
  <xsl:if test="(($isHomepage = 'true') and ($homepage-basic-url = 'index')) or ($super-homepage-basic-url = 'index')">
    <div id="sub-tabs">
      <xsl:apply-templates/>
    </div>
  </xsl:if>
</xsl:template>


</xsl:stylesheet>
