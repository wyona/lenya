<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: html-head.xsl,v 1.2 2004/02/04 14:34:37 gregor Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  >

<xsl:template name="html-head">
  <head>
    <title>UZH - <xsl:value-of select="/document/content/*/unizh:header/unizh:heading"/> - <xsl:value-of select="*/lenya:meta/dc:title"/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <style type="text/css">
      <xsl:comment>
        <xsl:choose>
          <xsl:when test="contains($fontsize, 'big') and not(contains($fontsize, 'normal'))">
            @import url("<xsl:value-of select="$contextprefix"/>/unizh/authoring/css/big.css");
            @import url("<xsl:value-of select="$localsharedresources"/>/css/institute.css");
          </xsl:when>
          <xsl:when test="contains($fontsize, 'normal')">
            @import url("<xsl:value-of select="$contextprefix"/>/unizh/authoring/css/main.css");
            @import url("<xsl:value-of select="$localsharedresources"/>/css/institute.css");
          </xsl:when>
          <xsl:otherwise>
            @import url("<xsl:value-of select="$contextprefix"/>/unizh/authoring/css/main.css");
            @import url("<xsl:value-of select="$localsharedresources"/>/css/institute.css");
          </xsl:otherwise>
        </xsl:choose>
      </xsl:comment>
    </style>
    <xsl:if test="$document-element-name = 'unizh:news'">
      <link rel="alternate" type="application/rss+xml" title="{/document/content/*/lenya:meta/dc:title}" href="{$nodeid}.rss.xml" /> 
    </xsl:if>
  </head>
</xsl:template>


</xsl:stylesheet>
