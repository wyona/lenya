<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: atom-feed.xsl 42987 2005-05-30 13:20:39Z simon $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:atom="http://purl.org/atom/ns#"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
>


  <xsl:template match="/">
    <rss version="2.0">
      <xsl:apply-templates select="atom:feed"/> 
    </rss>
  </xsl:template>

  <xsl:template match="atom:feed">
    <channel>
        <xsl:apply-templates select="@xml:lang"/>
        <xsl:apply-templates select="atom:title"/> 
        <xsl:apply-templates select="atom:link" mode="feed"/>
        <xsl:apply-templates select="atom:modified" mode="feed"/>
        <description>no description available</description>
        <xsl:apply-templates select="atom:entry"/> 
      </channel>
  </xsl:template>

  <xsl:template match="@xml:lang">
    <language>
      <xsl:value-of select="."/>
    </language>
  </xsl:template>

  <xsl:template match="atom:title">
    <title>
      <xsl:apply-templates/>
    </title>
  </xsl:template>

  <xsl:template match="atom:entry">
    <item> 
      <xsl:apply-templates select="atom:title"/>    
      <xsl:apply-templates select="atom:link"/>    
    </item>
  </xsl:template>
 
  <xsl:template match="atom:link">
    <link>
      <xsl:value-of select="@href"/>
    </link>
  </xsl:template>

  <xsl:template match="atom:link" mode="feed">
    <xsl:choose>
      <xsl:when test="starts-with(@type, 'image')">
        <image>
          <url><xsl:value-of select="@href"/></url>
          <title><xsl:value-of select="@title"/></title>
          <link><xsl:value-of select="../atom:link/@href"/></link>
          <width>80</width>
          <height>60</height>
        </image>
      </xsl:when>
      <xsl:otherwise>
        <link>
          <xsl:value-of select="@href"/>
        </link>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="atom:modified" mode="feed">
    <lastBuildDate>
      <i18n:date-time src-pattern="yyyy-MM-dd'T'hh:mm:ss" pattern="EEE, d MMM yyyy HH:mm:ss Z"><xsl:value-of select="."/></i18n:date-time>
   </lastBuildDate>
  </xsl:template>   

</xsl:stylesheet>  