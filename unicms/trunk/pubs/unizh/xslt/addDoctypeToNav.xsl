<?xml version="1.0" encoding="UTF-8" ?>


<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
    xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
    exclude-result-prefixes="nav"
    >
    
<xsl:template match="xhtml:div[@id = 'ancestry']/xhtml:div">

      <xsl:variable name="thisNodesHref" select="@href"/>
      <xsl:variable name="thisNodesDouble" select="//document/xhtml:div[@id = 'ancestry']/xhtml:div[@href = $thisNodesHref]"/>

      <xsl:copy>
        <xsl:attribute name="doctype">
          <xsl:value-of select="name($thisNodesDouble/xhtml:content/*)"/>
        </xsl:attribute>
        <xsl:attribute name="subhomepageType">
          <xsl:value-of select="$thisNodesDouble/xhtml:content/unizh:homepage/@unizh:subhomepageType"/>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:value-of select="$thisNodesDouble/xhtml:content/*/lenya:meta/dc:title"/>
        </xsl:attribute>
        <xsl:apply-templates select="@*"/>
      </xsl:copy>

</xsl:template>


<xsl:template match="xhtml:div[@id = 'menu']//xhtml:div">

      <xsl:variable name="thisNodesHref" select="@href"/>
      <xsl:variable name="thisNodesDouble" select="//document/xhtml:div[@id = 'ancestry']/xhtml:div[@href = $thisNodesHref]"/>
      <xsl:variable name="thisNodesDoctype" select="name($thisNodesDouble/xhtml:content/*)"/>

      <xsl:copy>
        <xsl:attribute name="doctype">
          <xsl:value-of select="$thisNodesDoctype"/>
        </xsl:attribute>
        <xsl:attribute name="subhomepageType">
          <xsl:value-of select="$thisNodesDouble/xhtml:content/unizh:homepage/@unizh:subhomepageType"/>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:value-of select="$thisNodesDouble/xhtml:content/*/lenya:meta/dc:title"/>
        </xsl:attribute>
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates select="xhtml:div"/>
      </xsl:copy>

</xsl:template>


<xsl:template match="xhtml:div[@id = 'breadcrumb']/xhtml:div">

      <xsl:variable name="thisNodesHref" select="@href"/>
      <xsl:variable name="thisNodesDouble" select="//document/xhtml:div[@id = 'ancestry']/xhtml:div[@href = $thisNodesHref]"/>
      <xsl:variable name="thisNodesDoctype" select="name($thisNodesDouble/xhtml:content/*)"/>

      <xsl:copy>
        <xsl:attribute name="doctype">
          <xsl:value-of select="$thisNodesDoctype"/>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:value-of select="$thisNodesDouble/xhtml:content/*/lenya:meta/dc:title"/>
        </xsl:attribute>
        <xsl:apply-templates select="@*"/>
      </xsl:copy>

</xsl:template>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet> 
