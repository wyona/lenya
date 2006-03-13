<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:map="http://apache.org/cocoon/sitemap/1.0"> 
<xsl:output method="xml" indent="yes"/>

  <xsl:template match="map:components/map:actions/map:action">
    <xsl:copy>
      <xsl:apply-templates select="@*|*"/>
      <sourcetype name="elml">
        <document-element local-name="lesson"/>
      </sourcetype>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="doc[@type = 'homepage']/children">
    <xsl:copy>
      <xsl:apply-templates/>
        <doc type="elml"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="doc[@type = 'xhtml']/children">
    <xsl:copy>
      <xsl:apply-templates/>
        <doc type="elml"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
