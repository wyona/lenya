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
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  exclude-result-prefixes="xhtml col up lenya"
  >
 
  <xsl:param name="root"/> <!-- the URL up to (including) the area -->
  
  <xsl:param name="documentid"/>
  
  <xsl:param name="lastmodified"/>
  
  <xsl:template match="document">
    <feed version="0.3" xml:lang="de">
      <title>Unipublic</title>
      <link rel="alternate" type="text/html" href="http://www.unipublic.unizh.ch"/>
      <modified>
        <i18n:date-time src-pattern="yyyy-MM-dd hh:mm:ss" pattern="yyyy-MM-dd'T'hh:mm:ss-hh:mm"> 
          <xsl:value-of select="$lastmodified"/>
        </i18n:date-time>
      </modified>
      <xsl:apply-templates select="content/up:homepage/col:document[1]/up:teaser/xhtml:p/xhtml:object"/>
      <xsl:apply-templates select="content/up:homepage/col:document[1]"/>
    </feed>
  </xsl:template>

  <xsl:template match="col:document">
    <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
    <entry>
      <title><xsl:value-of select="lenya:meta/dc:title"/></title>
      <link rel="alternate" type="text/html">
        <xsl:attribute name="href"><xsl:value-of select="concat('http://www.unipublic.unizh.ch',$id,'.html')"/></xsl:attribute>
      </link> 
      <author>
        <name>
          <xsl:value-of select="lenya:meta/dc:creator"/>
        </name>
      </author>
      <issued>
        <i18n:date-time src-pattern="yyyy-MM-dd hh:mm:ss" pattern="yyyy-MM-dd'T'hh:mm:ss-hh:mm"> 
          <xsl:value-of select="lenya:meta/dcterms:issued"/>
        </i18n:date-time>
      </issued>
      <modified>
        <i18n:date-time src-pattern="yyyy-MM-dd hh:mm:ss" pattern="yyyy-MM-dd'T'hh:mm:ss-hh:mm"> 
          <xsl:value-of select="lenya:meta/dcterms:dateCopyrighted"/>
        </i18n:date-time>
      </modified>
      <id><xsl:value-of select="concat('http://www.unipublic.unizh.ch',$id,'.html')"/></id>
    </entry>
  </xsl:template>
  
  <xsl:template match="xhtml:object">
    <xsl:variable name="data"><xsl:value-of select="@data"/></xsl:variable>
    <xsl:variable name="type"><xsl:value-of select="substring-after($data, '.')"/></xsl:variable>
    <xsl:variable name="id"><xsl:value-of select="../../../@id"/></xsl:variable>
      <link rel="alternate">
       <xsl:attribute name="type"><xsl:value-of select="concat('image/', $type)"/></xsl:attribute>
       <xsl:attribute name="href"><xsl:value-of select="concat('http://www.unipublic.unizh.ch', $id,'/', $data)"/></xsl:attribute>
       <xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute>
      </link> 
  </xsl:template>
</xsl:stylesheet>
