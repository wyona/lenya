<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: html-head.xsl,v 1.2 2004/02/04 14:34:37 gregor Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  >
  
<xsl:param name="fontsize"/>
<xsl:param name="contextprefix"/>
<xsl:param name="root"/>
<xsl:param name="area"/>

<xsl:variable name="localsharedresources" select="concat(substring-before($root, $area), 'authoring')"/>


<xsl:template match="style[@type = 'text/css']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
  <xsl:comment>
    <xsl:choose>
      <xsl:when test="contains($fontsize, 'big') and not(contains($fontsize, 'normal'))">
        @import url("<xsl:value-of select="$contextprefix"/>/unizh/authoring/css/big.css");
        @import url("<xsl:value-of select="$localsharedresources"/>/css/institute.css");
      </xsl:when>
      <xsl:when test="contains($fontsize, 'normal')">
        @import url("<xsl:value-of select="$contextprefix"/>/unizh/authoring/css/main.css");
        @import url("<xsl:value-of select="$localsharedresources"/>/css/institute.css");
      </xsl:when>
      <xsl:otherwise>
        @import url("<xsl:value-of select="$contextprefix"/>/unizh/authoring/css/main.css");
        @import url("<xsl:value-of select="$localsharedresources"/>/css/institute.css");
      </xsl:otherwise>
    </xsl:choose>
  </xsl:comment>
  </xsl:copy>
</xsl:template>


<xsl:template match="a[@id = 'switchFontSize']">
  <xsl:copy>
        <xsl:attribute name="href">
          <xsl:choose>
            <xsl:when test="contains($fontsize, 'big') and not(contains($fontsize, 'normal'))">?fontsize=normal</xsl:when>
            <xsl:when test="contains($fontsize, 'normal')">?fontsize=big</xsl:when>
            <xsl:otherwise>?fontsize=big</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
    <xsl:copy-of select="@*|node()"/>
  </xsl:copy>
</xsl:template>


  <xsl:template match="unizh:rss-reader">
    <unizh:rss-reader url="{@url}" items="{@items}" image="{@image}" link="{@link}" itemDescription="{@itemDescription}" itemImage="{@itemImage}" itemPubdate="{@itemPubdate}">
      <unizh:title><xsl:value-of select="unizh:title"/></unizh:title>
      <cinclude:includexml ignoreErrors="true">
        <xsl:choose>
          <xsl:when test="starts-with(@url, 'http://')">
            <cinclude:src><xsl:value-of select="@url"/></cinclude:src>
          </xsl:when>
          <xsl:otherwise>
            <cinclude:src>cocoon:/include-rss/<xsl:value-of select="@url"/></cinclude:src>
          </xsl:otherwise>
        </xsl:choose>
      </cinclude:includexml>
    </unizh:rss-reader>
  </xsl:template>


<xsl:template match="@*|node()" priority="-3">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
