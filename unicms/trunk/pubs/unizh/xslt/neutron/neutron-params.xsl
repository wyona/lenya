<?xml version="1.0" encoding="ISO-8859-1" ?>

<!-- $Id: neutron-params.xsl,v 1.4 2004/06/23 16:07:25 thomas Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xslt="http://www.unizh.ch/MetaTransform"

  >

 

  <xsl:param name="root"/>
  <xsl:param name="publication-id"/>
  <xsl:param name="documentid"/>
  <xsl:param name="area"/>
  <xsl:param name="language"/>
  <xsl:param name="languages"/>
  <xsl:param name="defaultlanguage"/>
  <xsl:param name="nodeid"/>
  <xsl:param name="contextprefix"/>
  <xsl:param name="rendertype"/>
  <xsl:param name="lastmodified"/>
  <xsl:param name="fontsize"/>
  <xsl:param name="creationdate"/>
  <xsl:param name="querystring"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="xsl:param[@name='root']">
    <xsl:copy>
      <xsl:apply-templates select="@name"/>
      <xsl:value-of select="$root"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xsl:param[@name='publication-id']">
    <xsl:copy>
      <xsl:apply-templates select="@name"/>
      <xsl:value-of select="$publication-id"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="xsl:param[@name='documentid']">
    <xsl:copy>
      <xsl:apply-templates select="@name"/>
      <xsl:value-of select="$documentid"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="xsl:param[@name='area']">
    <xsl:copy>
      <xsl:apply-templates select="@name"/>
      <xsl:value-of select="$area"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="xsl:param[@name='language']">
    <xsl:copy>
      <xsl:apply-templates select="@name"/>
      <xsl:value-of select="$language"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xsl:param[@name='languages']">
    <xsl:copy>
      <xsl:apply-templates select="@name"/>
      <xsl:value-of select="$languages"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xsl:param[@name='defaultlanguage']">
    <xsl:copy>
      <xsl:apply-templates select="@name"/>
      <xsl:value-of select="$defaultlanguage"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xsl:param[@name='nodeid']">
    <xsl:copy>
      <xsl:apply-templates select="@name"/>
      <xsl:value-of select="$nodeid"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="xsl:param[@name='contextprefix']">
    <xsl:copy>
      <xsl:apply-templates select="@name"/>
      <xsl:value-of select="$contextprefix"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xsl:param[@name='rendertype']">
    <xsl:copy>
      <xsl:apply-templates select="@name"/>
      <xsl:value-of select="$rendertype"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xsl:param[@name='lastmodified']">
    <xsl:copy>
      <xsl:apply-templates select="@name"/>
      <xsl:value-of select="$lastmodified"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xsl:param[@name='fontsize']">
    <xsl:copy>
      <xsl:apply-templates select="@name"/>
      <xsl:value-of select="$fontsize"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xsl:param[@name='creationdate']">
    <xsl:copy>
      <xsl:apply-templates select="@name"/>
      <xsl:value-of select="$creationdate"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
