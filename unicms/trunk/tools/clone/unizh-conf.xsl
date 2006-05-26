<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:foo="http://unizh.ch"  exclude-result-prefixes="foo">

<xsl:param name="publicationName"/>
<xsl:param name="publicationSection"/>

<xsl:template match="foo:publication">
  <publication xmlns="http://unizh.ch">  <!-- namespace prevents empty attribute xmlns='' -->
    <xsl:apply-templates select="@*"/>
    <xsl:value-of select="$publicationName"/>
  </publication>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>
   
</xsl:stylesheet> 
