<?xml version="1.0" encoding="UTF-8" ?>
<!-- $Id: doctypes-xmap.xsl, v 1.00 2006/11/22 12:00:00 mike Exp $ -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:map="http://apache.org/cocoon/sitemap/1.0">
<xsl:output method="xml" indent="yes"/>

  <xsl:template match="map:resource/map:transform/@src">
    <xsl:attribute name="src">
      <xsl:text>xslt/doctypes/{stylesheet}-{version}.xsl</xsl:text>
    </xsl:attribute>
  </xsl:template>


  <xsl:template match="map:transform[@src='../unizh/xslt/assetDots.xsl']">
    <xsl:copy>
      <xsl:attribute name="src">
        <xsl:text>xslt/assetDots.xsl</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates select="@*[name()!='src']|node()"/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="map:transform[@src='../unizh/xslt/common/rss.xsl']">
    <xsl:copy>
      <xsl:attribute name="src">
        <xsl:text>xslt/common/rss.xsl</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates select="@*[name()!='src']|node()"/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 