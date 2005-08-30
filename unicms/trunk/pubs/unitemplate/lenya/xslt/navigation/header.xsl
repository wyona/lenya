<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: header.xsl,v 1.1 2004/05/26 10:43:39 tc Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
    >
    
<xsl:template match="/document">
  <document>
    <unizh:header>
      <unizh:superscription>
        <xsl:value-of select="unizh:ancestors/unizh:ancestor[@basic-url = 'index']/unizh:homepage/unizh:header/unizh:superscription"/> 
      </unizh:superscription>
      <unizh:heading href="{unizh:ancestors/unizh:ancestor[@basic-url = 'index']/@href}">
        <xsl:value-of select="unizh:ancestors/unizh:ancestor[@basic-url = 'index']/unizh:homepage/unizh:header/unizh:heading"/>
      </unizh:heading>
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
