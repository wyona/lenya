<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: homepage-standard.xsl,v 1.11 2004/12/22 10:01:40 edith Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xhtml"
  >
  
  <xsl:template match="rss/channel">
    <table style="font-size: 80%;" border="0" cellspacing="0" cellpadding="0" width="389">
      <tr>
        <xsl:apply-templates select="item[1]"></xsl:apply-templates>
        <xsl:apply-templates select="item[2]"></xsl:apply-templates>
      </tr>
    </table>
  </xsl:template>

  
  <xsl:template match="image">
    <a>
      <xsl:attribute name="href"><xsl:value-of select="../../link"/></xsl:attribute>
      <img border="0" width="80" height="60">
        <xsl:attribute name="alt"><xsl:value-of select="title"/></xsl:attribute>
        <xsl:attribute name="src"><xsl:value-of select="url"/></xsl:attribute>
      </img>    
    </a>
  </xsl:template>

  <xsl:template match="enclosure">
    <a>
      <xsl:attribute name="href"><xsl:value-of select="../../link"/></xsl:attribute>
      <img border="0">
        <xsl:attribute name="width">80</xsl:attribute>
        <xsl:attribute name="height">60</xsl:attribute>
        <xsl:attribute name="alt"><xsl:value-of select="../description"/></xsl:attribute>
        <xsl:attribute name="src"><xsl:value-of select="@url"/></xsl:attribute>
      </img>    
    </a>
  </xsl:template>
  
  <xsl:template match="item">
      <td>
        <xsl:apply-templates select="image"></xsl:apply-templates>
      </td>
      <td>&#160;</td>
      <td width="112">
        <a>
          <xsl:attribute name="href"><xsl:value-of select="../link"/></xsl:attribute>
          <span class="tsr-title"><xsl:value-of select="title"/></span>
        </a>
      </td>
      <td>&#160;</td>
  </xsl:template>

</xsl:stylesheet>
