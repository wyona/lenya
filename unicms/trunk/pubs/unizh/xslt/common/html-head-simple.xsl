<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: html-head.xsl,v 1.2 2004/02/04 14:34:37 gregor Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  >

<xsl:template name="html-head">
  <head>
    <title><xsl:value-of select="*/lenya:meta/dc:title"/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <style type="text/css">
      <xsl:comment>
        @import url("<xsl:value-of select="$contextprefix"/>/unizh/authoring/css/simple.css");
      </xsl:comment>
    </style>
  </head>
</xsl:template>


</xsl:stylesheet>
