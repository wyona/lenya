<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: homepage-standard.xsl,v 1.11 2004/12/22 10:01:40 edith Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xhtml"
  >
  
  <xsl:template match="rss/channel">
    <table cellpadding="0" cellspacing="0" border="0">
      <xsl:apply-templates select="item"></xsl:apply-templates>
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
    <tr>
      <td>
        <xsl:apply-templates select="image"></xsl:apply-templates>
      </td>
      <td>&#160;</td>
      <td>
        <a>
          <xsl:attribute name="href"><xsl:value-of select="../link"/></xsl:attribute>
          <span class="tsr-title"><xsl:value-of select="title"/></span>
        </a>
      </td>
      <td>&#160;</td>
    </tr>
    
  </xsl:template>

</xsl:stylesheet>
