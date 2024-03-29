<?xml version="1.0" encoding="UTF-8" ?>


<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:uz="http://unizh.ch"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
>


  <xsl:include href="../../../unizh/xslt/doctypes/variables.xsl"/>


<!-- define new variables -->

  <xsl:variable name="navPosition">
    <xsl:choose>
      <xsl:when test="$document-element-name = 'unizh:homepage' or $document-element-name = 'unizh:homepage4cols'">
        <xsl:value-of select="0"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="count(/document/xhtml:div[@id = 'tabs']/xhtml:div[@current = 'true']/preceding-sibling::xhtml:div) + 1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


<!-- overwrite included templates -->

  <xsl:variable name="numColumns">
    <xsl:choose>
      <xsl:when test="$document-element-name = 'unizh:homepage4cols'">
        <xsl:value-of select="count(/document/content/unizh:homepage4cols/xhtml:body/unizh:column)"/>
      </xsl:when>
      <xsl:when test="$document-element-name = 'unizh:overview'">
        <xsl:choose>
          <xsl:when test="count(/document/unizh:ancestors/unizh:ancestor) &lt; 2">
            <xsl:value-of select="count(/document/content/unizh:overview/xhtml:body/unizh:column)"/>
          </xsl:when>
            <xsl:otherwise>
            <xsl:value-of select="2"/>
            </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

</xsl:stylesheet>
