<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: newsletter-bitflux-back.xsl,v 1.1 2004/12/20 15:52:51 thomas Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:col="http://apache.org/cocoon/lenya/collection/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  >
  
  <xsl:template match="col:documents">
      <xsl:apply-templates/>
  </xsl:template> 

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
