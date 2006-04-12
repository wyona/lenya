<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: html-head.xsl,v 1.2 2004/02/04 14:34:37 gregor Exp $ -->
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
      <i18n:text><xsl:value-of select="/document/uz:unizh/uz:university"/></i18n:text> -
      <xsl:value-of select="$content/lenya:meta/dc:title"/>
    </title>
    <xsl:call-template name="include-css"/>
    <xsl:call-template name="meta-headers"/>
    <xsl:call-template name="include-js"/>
  </head>
</xsl:template>


</xsl:stylesheet>