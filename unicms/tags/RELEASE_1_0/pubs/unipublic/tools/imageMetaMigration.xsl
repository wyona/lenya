<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:dc="http://purl.org/dc/elements/1.1/"> 

  <xsl:template match="dc:metadata">
    <dc:metadata><xsl:apply-templates/></dc:metadata>
  </xsl:template>

  <xsl:template match="source">
    <dc:source><xsl:apply-templates/></dc:source>
  </xsl:template>

  <xsl:template match="publisher">
    <dc:publisher><xsl:apply-templates/></dc:publisher>
  </xsl:template>

  <xsl:template match="relation">
    <dc:relation><xsl:apply-templates/></dc:relation>
  </xsl:template>

  <xsl:template match="rights">
    <dc:rights><xsl:apply-templates/></dc:rights>
  </xsl:template>

  <xsl:template match="contributor">
    <dc:contributor><xsl:apply-templates/></dc:contributor>
  </xsl:template>

  <xsl:template match="creator">
    <dc:creator><xsl:apply-templates/></dc:creator>
  </xsl:template>

  <xsl:template match="date">
    <dc:date><xsl:apply-templates/></dc:date>
  </xsl:template>

  <xsl:template match="language">
    <dc:language><xsl:apply-templates/></dc:language>
  </xsl:template>

  <xsl:template match="identifier">
    <dc:identifier><xsl:apply-templates/></dc:identifier>
  </xsl:template>

  <xsl:template match="type">
    <dc:type><xsl:apply-templates/></dc:type>
  </xsl:template>

  <xsl:template match="subject">
    <dc:subject><xsl:apply-templates/></dc:subject>
  </xsl:template>

  <xsl:template match="title">
    <dc:title><xsl:apply-templates/></dc:title>
  </xsl:template>

  <xsl:template match="format">
    <dc:format><xsl:apply-templates/></dc:format>
  </xsl:template>

  <xsl:template match="description">
    <dc:description><xsl:apply-templates/></dc:description>
  </xsl:template>

  <xsl:template match="coverage">
    <dc:coverage><xsl:apply-templates/></dc:coverage>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
