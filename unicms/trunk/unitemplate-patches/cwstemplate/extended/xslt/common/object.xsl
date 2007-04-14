<?xml version="1.0" encoding="UTF-8"?>


<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:index="http://apache.org/cocoon/lenya/documentindex/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" xmlns:uz="http://unizh.ch"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>


  <xsl:include href="../../../unizh/xslt/common/object.xsl"/>


<!-- define new templates -->

  <xsl:template match="xhtml:object[parent::unizh:banner]">
    <xsl:call-template name="object">
      <xsl:with-param name="width">180</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="xhtml:object[parent::unizh:startlinks]">
    <xsl:call-template name="object">
      <xsl:with-param name="width">198</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


<!-- overwrite included templates -->

  <xsl:template match="xhtml:object[parent::unizh:links]" priority="1">
    <xsl:variable name="src" select="concat($nodeid, '/', @data)"/>
    <xsl:variable name="alt">
      <xsl:choose>
        <xsl:when test="@title != ''">
          <xsl:value-of select="@title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="dc:metadata/dc:title"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="width">
      <xsl:choose>
        <xsl:when test="$numColumns = 3">
          <xsl:value-of select="191"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="198"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@href != ''">
        <a href="{@href}">
          <img src="{$src}" alt="{$alt}" width="{$width}" />
        </a>
      </xsl:when>
      <xsl:otherwise>
        <img src="{$src}" alt="{$alt}" width="{$width}" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="xhtml:object[parent::unizh:short]" priority="1">
    <div class="imgTextfluss">
      <xsl:choose>
    <xsl:when test="ancestor::index:child">
      <xsl:call-template name="object">
        <xsl:with-param name="src" select="concat($contextprefix, substring-before(../../../../@href, '.html'), '/', @data)"/>
        <xsl:with-param name="width">100</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="object">
        <xsl:with-param name="width">100</xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>


  <xsl:template match="xhtml:object[parent::unizh:teaser and ancestor::unizh:column]" priority="1">
    <xsl:call-template name="object">
      <xsl:with-param name="width">
        <xsl:choose>
          <xsl:when test="$numColumns = 3">
            <xsl:value-of select="171"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="178"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
