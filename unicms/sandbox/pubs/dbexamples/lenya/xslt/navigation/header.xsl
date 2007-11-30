<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: header.xsl,v 1.1 2004/05/26 10:43:39 tc Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
    >
    
<xsl:template match="content/*">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:if test="not(unizh:header)">
      <unizh:header/>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet> 
