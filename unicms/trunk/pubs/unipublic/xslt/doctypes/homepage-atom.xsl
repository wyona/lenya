<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: homepage-standard.xsl,v 1.11 2004/12/22 10:01:40 edith Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns="http://purl.org/atom/ns#"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:up="http://www.unipublic.unizh.ch/2002/up"
  xmlns:col="http://apache.org/cocoon/lenya/collection/1.0"
  exclude-result-prefixes="xhtml"
  >
 
  <xsl:param name="root"/> <!-- the URL up to (including) the area -->
  
  <xsl:param name="documentid"/>
  
  <xsl:param name="lastmodified"/>
  
  <xsl:template match="document">
    <feed version="0.3" xml:lang="de">
      <title>Unipublic</title>
      <link rel="alternate" type="text/html" href="http://www.unipublic.unizh.ch"/>
      <modified><xsl:value-of select="$lastmodified"/></modified>
      <xsl:call-template name="image"/> 
      <xsl:apply-templates select="content/up:homepage/col:document"/>
    </feed>
  </xsl:template>

  <xsl:template name="image">
    <image>
      <title><xsl:value-of select="content/up:homepage/col:document[1]/up:teaser/xhtml:p/xhtml:object/@title"/></title>
      <url><xsl:value-of select="$root"/><xsl:value-of select="content/up:homepage/col:document[1]/@id"/>/<xsl:value-of select="content/up:homepage/col:document[1]/up:teaser/xhtml:p/xhtml:object/@data"/></url>
      <width>80</width>
      <height>60</height>
    </image>
  </xsl:template>

  <xsl:template match="col:document">
    <entry>
      <title><xsl:value-of select="lenya:meta/dc:title"/></title>
<!-- it doesn't work always. Fixme: add an image for evry entry.
      <xsl:variable name="data"><xsl:value-of select="up:teaser/xhtml:p/xhtml:object/@data"/></xsl:variable>
      <xsl:variable name="type"><xsl:value-of select="substring-after($data, '.')"/></xsl:variable>
      <enclosure>
        <url><xsl:value-of select="$root"/><xsl:value-of select="$documentid"/>/<xsl:value-of select="$data"/></url>
        <type>mime-type="image/<xsl:value-of select="$type"/></type>
      </enclosure>
-->
    </entry>
  </xsl:template>
</xsl:stylesheet>
