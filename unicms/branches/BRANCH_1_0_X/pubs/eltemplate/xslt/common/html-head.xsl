<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: html-head.xsl,v 1.4 2005/03/29 08:28:40 thomas Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  >

<xsl:template name="html-head">
  <head>
    <title>
      <xsl:value-of select="$content/lenya:meta/dc:title"/>
    </title>
    <xsl:call-template name="include-css"/>
    <xsl:call-template name="meta-headers"/>
    <xsl:call-template name="include-js"/> 
  </head>
</xsl:template>

</xsl:stylesheet>
