<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: menu.xsl,v 1.5 2005/02/24 15:29:24 jann Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
   

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>

