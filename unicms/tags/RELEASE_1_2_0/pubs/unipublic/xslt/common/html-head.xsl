<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: html-head.xsl,v 1.1 2004/12/22 09:59:07 edith Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:uz="http://unizh.ch"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  >

<xsl:template name="html-head">
  <head>
    <title>
      <i18n:text>publication_Unipublic</i18n:text> -
      <xsl:choose>
        <xsl:when test="$content/lenya:meta/dc:title">
          <xsl:value-of select="$content/lenya:meta/dc:title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Das Online-Magazin der Universit&#228;t Z&#252;rich</xsl:text>         
        </xsl:otherwise>
      </xsl:choose>
    </title>
    <xsl:call-template name="include-css"/>
    <xsl:call-template name="include-js"/>
    <xsl:if test="$documentid='/index'">
      <xsl:call-template name="include-homepage-style"/>
    </xsl:if>
  </head>
</xsl:template>


</xsl:stylesheet>