<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: homepage-standard.xsl,v 1.11 2004/12/22 10:01:40 edith Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xhtml"
  >
  
  <xsl:template match="rss/channel">
    <table cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td>
        <xsl:apply-templates select="image"/>
      </td>
      <td>&#160;</td>
      <td>
        <xsl:apply-templates select="item"/>
      </td>
      <td>&#160;</td>
    </tr>
    </table>
  </xsl:template>

  <xsl:template match="image">
    <a>
      <xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute>
      <img border="0">
        <xsl:attribute name="width"><xsl:value-of select="width"/></xsl:attribute>
        <xsl:attribute name="height"><xsl:value-of select="height"/></xsl:attribute>
        <xsl:attribute name="alt"><xsl:value-of select="title"/></xsl:attribute>
        <xsl:attribute name="src"><xsl:value-of select="url"/></xsl:attribute>
      </img>    
    </a>
  </xsl:template>

  <xsl:template match="item">
    <a>
      <xsl:attribute name="href"><xsl:value-of select="../link"/></xsl:attribute>
      <span class="tsr-title"><xsl:value-of select="title"/></span>
    </a>
  </xsl:template>

</xsl:stylesheet>
