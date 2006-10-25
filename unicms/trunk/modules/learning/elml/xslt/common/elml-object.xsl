<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: elements.xsl,v 1.79 2005/01/17 09:15:15 thomas Exp $ -->
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:index="http://apache.org/cocoon/lenya/documentindex/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" xmlns:uz="http://unizh.ch"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
  <xsl:param name="documentid"/>
  <xsl:param name="nodeid"/>
  <xsl:param name="contextprefix"/>
  <xsl:param name="rendertype"/>

  <xsl:template name="width-attribute">
    <xsl:choose>
      <xsl:when test="@popup = 'true'">
        <xsl:choose>
          <xsl:when test="@width > 0">
            <xsl:value-of select="@width" />
          </xsl:when>
          <xsl:otherwise>
             <xsl:text>204</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="not(@width) or (@width = '')">
        <xsl:text>204</xsl:text>
      </xsl:when>
      <xsl:when test="(@float = 'true') and not(@align = 'right')">
        <xsl:text>204</xsl:text>
      </xsl:when>
      <xsl:when test="/document/content/xhtml:html/@unizh:columns = 1">
        <xsl:choose>
          <xsl:when test="@width > 800">
            <xsl:text>800</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@width"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="/document/content/xhtml:html/@unizh:columns = 2"> 
        <xsl:choose>
          <xsl:when test="@width > 615">
            <xsl:text>615</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@width"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="@width > 415">
        <xsl:text>415</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@width"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="xhtml:object">
    <xsl:variable name="width">
      <xsl:if test="@width">
        <xsl:choose>
          <xsl:when test="@width > 415">415</xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@width"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:variable>
    <xsl:call-template name="object">
      <xsl:with-param name="width"><xsl:value-of select="$width"/></xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="object">

    <xsl:param name="width"/>
    <xsl:param name="height"/>
    <xsl:param name="src" select="concat($nodeid, '/', @data)"/>
    <xsl:param name="href" select="@href"/>
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

    <xsl:choose>
      <xsl:when test="$rendertype = 'imageupload'">
        <a href="{lenya:asset-dot/@href}">
          <img src="{$src}" alt="{$alt}">
            <xsl:if test="$width">
              <xsl:attribute name="width">
                <xsl:value-of select="$width"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="$height">
              <xsl:attribute name="height">
                <xsl:value-of select="$height"/>
              </xsl:attribute>
            </xsl:if>
          </img>
        </a>
      </xsl:when>
      <xsl:when test="$href != ''">
        <a href="{$href}">
          <img src="{$src}" alt="{$alt}">
            <xsl:if test="$width">
              <xsl:attribute name="width">
                <xsl:value-of select="$width"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="$height">
              <xsl:attribute name="height">
                <xsl:value-of select="$height"/>
              </xsl:attribute>
            </xsl:if>
          </img>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <img src="{$src}" alt="{$alt}">
          <xsl:if test="$width">
            <xsl:attribute name="width">
              <xsl:value-of select="$width"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="$height">
            <xsl:attribute name="height">
              <xsl:value-of select="$height"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="$width = 415">
            <xsl:attribute name="class">fullimg</xsl:attribute>
          </xsl:if>
        </img>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template> 

</xsl:stylesheet>
