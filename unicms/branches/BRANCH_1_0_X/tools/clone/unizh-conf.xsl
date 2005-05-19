<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:foo="http://unizh.ch"  exclude-result-prefixes="foo">

<xsl:param name="publicationName"/>
<xsl:param name="publicationSection"/>

<xsl:template match="foo:publication">
  <publication breadcrumb="true"><xsl:value-of select="$publicationName"/></publication>
</xsl:template>

<xsl:template match="foo:section">
   <section breadcrumb="false"><xsl:value-of select="$publicationSection"/></section>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>
   
</xsl:stylesheet> 
