<?xml version="1.0" encoding="UTF-8" ?>
<!-- $Id: parameter-doctype-xmap.xsl, v 1.00 2006/12/15 17:00:00 mike Exp $ -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:map="http://apache.org/cocoon/sitemap/1.0">

  <xsl:template match="map:actions/map:action">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <sourcetype name="portal">
        <document-element local-name="portal"/>
      </sourcetype>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 