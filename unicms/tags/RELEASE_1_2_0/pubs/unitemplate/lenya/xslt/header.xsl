<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: breadcrumb.xsl,v 1.1 2004/05/26 10:43:39 gregor Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
    xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    >
    
<xsl:template match="/document">
  <document>
    <unizh:header>
      <unizh:title href="{unizh:ancestors/unizh:ancestor[@basic-url = 'index']/@href}">
        <xsl:value-of select="unizh:ancestors/unizh:ancestor[@basic-url = 'index']/unizh:homepage/lenya:meta/dc:title"/>
      </unizh:title>
      <unizh:spitzmarke></unizh:spitzmarke>
    </unizh:header>
    <xsl:apply-templates/>
  </document>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet> 
