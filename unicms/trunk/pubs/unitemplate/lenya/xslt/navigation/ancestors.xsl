<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: breadcrumb.xsl,v 1.1 2004/05/26 10:43:39 gregor Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    >

<xsl:param name="area"/>
<xsl:param name="chosenlanguage"/>
<xsl:param name="defaultlanguage"/>

<xsl:template match="nav:node[@current = 'true']">
  <unizh:ancestors>
    <xsl:apply-templates select="parent::nav:node" mode="ancestor"/>
    <xsl:apply-templates select="/nav:site/nav:node[@id = 'index']" mode="ancestor"/> 
  </unizh:ancestors>
</xsl:template>


<xsl:template match="nav:node" mode="ancestor">
  <xsl:variable name="path">
    <xsl:choose>
      <xsl:when test="@language-suffix = ''">
        <xsl:value-of select="concat('cocoon:/xml/', $area, '/', @basic-url, '/index_', $defaultlanguage, '.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('cocoon:/xml/', $area, '/', @basic-url, '/index', @language-suffix, '.xml')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <unizh:ancestor basic-url="{@basic-url}" href="{@href}">
    <cinclude:includexml ignoreErrors="true">
      <cinclude:src><xsl:value-of select="$path"/></cinclude:src>
    </cinclude:includexml>
  </unizh:ancestor> 
  <xsl:apply-templates select="parent::nav:node" mode="ancestor"/>
</xsl:template>

</xsl:stylesheet> 
