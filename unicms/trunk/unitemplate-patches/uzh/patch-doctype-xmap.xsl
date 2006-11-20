<?xml version="1.0" encoding="UTF-8" ?>
<!-- $Id: patch-doctype-xmap.xsl, v 1.00 2006/11/20 17:00:00 mike Exp $ -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:map="http://apache.org/cocoon/sitemap/1.0">

  <xsl:template match="map:resource/map:transform/@src">
    <xsl:attribute name="src">
      <xsl:text>xslt/doctypes/{stylesheet}-{version}.xsl</xsl:text>
    </xsl:attribute>
  </xsl:template>


  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
