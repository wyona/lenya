<?xml version="1.0" encoding="UTF-8" ?>

<!--
$Id: addMetaData.xsl,v 1.6 2004/02/04 14:41:17 gregor Exp $
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  exclude-result-prefixes="xhtml"
  >

  <xsl:param name="creator"/>
  <xsl:param name="title"/>
  <xsl:param name="description"/>
  <xsl:param name="subject"/>
  <xsl:param name="language"/>
  <xsl:param name="docsubtype"/>
  <xsl:param name="publisher"/>
  <xsl:param name="date"/>
  <xsl:param name="rights"/>
  <xsl:param name="columns"/>
  <xsl:param name="tabs"/>

  <xsl:template match="/*[$columns!='']">
    <xsl:copy>
      <xsl:attribute name="unizh:columns" namespace="http://unizh.ch/doctypes/elements/1.0"><xsl:value-of select="$columns"/></xsl:attribute>
      <xsl:apply-templates select="@*[local-name()!='columns']|node()"/>
    </xsl:copy>
  </xsl:template>  

  <xsl:template match="/*[$tabs!='']">
    <xsl:copy>
      <xsl:attribute name="unizh:tabs" namespace="http://unizh.ch/doctypes/elements/1.0"><xsl:value-of select="$tabs"/></xsl:attribute>
      <xsl:apply-templates select="@*[local-name()!='tabs']|node()"/>
    </xsl:copy>
  </xsl:template>  

  <xsl:template match="dc:creator[$creator!='']">
    <dc:creator>
      <xsl:value-of select="$creator"/>
    </dc:creator>
  </xsl:template>  

  <xsl:template match="dc:title[$title!='']">
    <dc:title>
      <xsl:value-of select="$title"/>
    </dc:title>
  </xsl:template>  

  <xsl:template match="dc:description[$description!='']">
    <dc:description>
      <xsl:value-of select="$description"/>
    </dc:description>
  </xsl:template>  

  <xsl:template match="dc:subject[$subject!='']">
    <dc:subject>
      <xsl:value-of select="$subject"/>
    </dc:subject>
  </xsl:template>  

  <xsl:template match="dc:language[$language!='']">
    <dc:language>
      <xsl:value-of select="$language"/>
    </dc:language>
  </xsl:template>  

  <xsl:template match="dc:publisher">
    <dc:publisher>
      <xsl:value-of select="$publisher"/>
    </dc:publisher>
  </xsl:template>  

  <xsl:template match="dcterms:created[$date!='']">
    <dcterms:created>
      <xsl:value-of select="$date"/>
    </dcterms:created>
  </xsl:template>  

  <xsl:template match="dc:rights">
    <dc:rights>
      <xsl:value-of select="$rights"/>
    </dc:rights>
  </xsl:template>  

  <xsl:template match="unizh:newsitem/xhtml:body/xhtml:p">
    <xsl:choose>
      <xsl:when test="($docsubtype = 'summary only') or($docsubtype = 'summary and link')">
        <p>&#160;</p>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>  

  <xsl:template match="unizh:newsitem/unizh:short/xhtml:a">
    <xsl:choose>
      <xsl:when test="($docsubtype = 'summary only') or($docsubtype = 'summary and details')"/>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>  

  <!-- Identity transformation -->
  <xsl:template match="@*|*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>  
  
</xsl:stylesheet>
