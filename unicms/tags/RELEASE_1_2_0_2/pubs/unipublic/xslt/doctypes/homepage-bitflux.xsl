<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: homepage-bitflux.xsl,v 1.3 2004/12/09 10:04:18 thomas Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:col="http://apache.org/cocoon/lenya/collection/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  >
  
<xsl:template match="col:document">
    <xsl:copy>  
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="lenya:meta/dc:title"/>
    </xsl:copy> 
  </xsl:template> 

  <xsl:template match="dc:title">
    <xsl:copy>
      <xsl:value-of select="."/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
