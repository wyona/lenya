<?xml version="1.0" encoding="ISO-8859-1" ?>

<!-- $Id: includeAssetMetaData.xsl,v 1.1 2004/11/23 07:51:47 thomas Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xhtml"
  >

  <xsl:param name="documentid"/>
  
  <xsl:template match="lenya:asset">
    <xsl:variable name="metaFileURI">cocoon:<xsl:value-of select="$documentid"/>/<xsl:value-of select="@src"/>.meta</xsl:variable>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <cinclude:include src="{$metaFileURI}" ignoreErrors="true"/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="xhtml:object">
    <xsl:variable name="metaFileURI">cocoon:<xsl:value-of select="$documentid"/>/<xsl:value-of select="@data"/>.meta</xsl:variable>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <cinclude:include src="{$metaFileURI}" ignoreErrors="true"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
