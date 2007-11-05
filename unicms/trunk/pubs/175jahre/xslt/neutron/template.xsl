<?xml version="1.0" encoding="ISO-8859-1" ?>

<!-- $Id: includeAssetMetaData.xsl,v 1.4 2004/06/23 16:07:25 edith Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  >



  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
 
  <xsl:template match="/document">
    <document>
      <xsl:apply-templates/>
    </document>
  </xsl:template>

 
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="/document/content/*">
    <xi:include href="#"/>    
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
