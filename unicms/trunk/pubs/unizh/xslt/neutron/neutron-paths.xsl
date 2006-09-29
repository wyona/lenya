<?xml version="1.0" encoding="ISO-8859-1" ?>

<!-- $Id: includeAssetMetaData.xsl,v 1.4 2004/06/23 16:07:25 edith Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:xslt="http://www.unizh.ch/MetaTransform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml"
  >

  <xsl:namespace-alias stylesheet-prefix="xslt" result-prefix="xsl"/>

  <xsl:param name="scheme"/>
  <xsl:param name="servername"/>
  <xsl:param name="port"/>
  <xsl:param name="contextprefix"/>
  <xsl:param name="publication-id"/>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="@src">
    <xsl:attribute name="src">
      <xsl:value-of select="concat($scheme, '://', $servername, ':', $port, .)"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="xhtml:style">
    <style type="text/css">
      @import url("<xsl:value-of select="concat($scheme, '://', $servername, ':', $port, $contextprefix, '/', $publication-id)"/>/authoring/content-neutron.css");
    </style>
  </xsl:template>


  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
