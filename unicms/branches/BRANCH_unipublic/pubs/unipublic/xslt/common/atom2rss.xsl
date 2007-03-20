<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: atom-feed.xsl 42987 2005-05-30 13:20:39Z simon $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:atom="http://purl.org/atom/ns#"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
>


  <xsl:template match="/">
    <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="/lenya/unipublic/live/xsl/default_rss.xsl"</xsl:processing-instruction>
    <rss version="2.0">
      <xsl:apply-templates select="atom:feed"/> 
    </rss>
  </xsl:template>

  <xsl:template match="atom:feed">
    <channel>
        <xsl:apply-templates select="@xml:lang"/>
        <xsl:apply-templates select="atom:title"/> 
        <xsl:apply-templates select="atom:link"/>
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
      <xsl:apply-templates select="atom:summary"/>
      <xsl:apply-templates select="atom:link"/>    
      <xsl:apply-templates select="atom:issued"/>
    </item>
  </xsl:template>
  
  <xsl:template match="atom:summary">
    <description>
      <xsl:apply-templates/>
    </description>
  </xsl:template>
 
  <xsl:template match="atom:link">
    <xsl:choose>
      <xsl:when test="@rel='enclosure'">
        <image>
          <title><xsl:value-of select="@title"/></title>
          <url><xsl:value-of select="@href"/></url>
          <link><xsl:value-of select="../atom:link[@rel='alternate']/@href"/></link>
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

  <xsl:template match="atom:issued">
    <pubDate>
      <i18n:date-time src-pattern="yyyy-MM-dd'T'hh:mm:ss" pattern="EEE, dd MMM yyyy HH:mm:ss Z" locale="en_US"><xsl:value-of select="."/></i18n:date-time>
   </pubDate>
  </xsl:template>

  <xsl:template match="atom:modified" mode="feed">
    <lastBuildDate>
      <i18n:date-time src-pattern="yyyy-MM-dd'T'hh:mm:ss" pattern="EEE, d MMM yyyy HH:mm:ss Z"><xsl:value-of select="."/></i18n:date-time>
   </lastBuildDate>
  </xsl:template>   

</xsl:stylesheet>  
