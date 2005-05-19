<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: newsletter-bitflux.xsl,v 1.1 2004/12/22 16:45:39 thomas Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:up="http://www.unipublic.unizh.ch/2002/up"
  xmlns:col="http://apache.org/cocoon/lenya/collection/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  >
 
  <xsl:template match="up:newsletter">
   <xsl:copy>
     <xsl:apply-templates select="@*"/>
     <xsl:apply-templates select="*[not(self::col:document)]"/>
     <xsl:if test="col:document">
       <col:documents>
         <xsl:apply-templates select="col:document"/>
       </col:documents>
     </xsl:if>
   </xsl:copy>
  </xsl:template>
 
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
