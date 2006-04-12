<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns="http://www.w3.org/1999/xhtml" 
      xmlns:xhtml="http://www.w3.org/1999/xhtml" 
      xmlns:dc="http://purl.org/dc/elements/1.1/" 
      xmlns:dcterms="http://purl.org/dc/terms/" 
      xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
      xmlns:up="http://www.unipublic.unizh.ch/2002/up" 
      xmlns:col="http://apache.org/cocoon/lenya/collection/1.0" 
      xmlns:xlink="http://www.w3.org/1999/xlink" 
      dc:dummy="FIXME:keepNamespace" 
      dcterms:dummy="FIXME:keepNamespace" 
      lenya:dummy="FIXME:keepNamespace" 
      xhtml:dummy="FIXME:keepNamespace">

  
  <xsl:param name="publicationPath"/>
  
  <xsl:template match="dossier">
    <up:dossier>

      <lenya:meta xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" >
        <dc:title xmlns:dc="http://purl.org/dc/elements/1.1/">
          <xsl:value-of select="head/title"/>
        </dc:title>
        <dc:description xmlns:dc="http://purl.org/dc/elements/1.1/">
          <xsl:value-of select="head/abstract"/>
        </dc:description>
      </lenya:meta>

      <up:color xmlns:up="http://www.unipublic.unizh.ch/2002/up">
        <xsl:value-of select="head/color"/>
      </up:color>

      <up:teaser xmlns:up="http://www.unipublic.unizh.ch/2002/up">
        <div class="tsr-text">
          <xsl:value-of select="head/teasertext"/>
        </div>
        <xsl:apply-templates select = "head/media"/>
      </up:teaser>

      <xsl:apply-templates select="related-content"/>

      <xsl:apply-templates select="articles/article"/>

    </up:dossier>
  </xsl:template>

  <xsl:template match="article">
    <xsl:variable name="channel"><xsl:value-of select="./@channel"/></xsl:variable>
    <xsl:variable name="section"><xsl:value-of select="./@section"/></xsl:variable>
    <xsl:variable name="year"><xsl:value-of select="./@year"/></xsl:variable>
    <xsl:variable name="id"><xsl:value-of select="./@id"/></xsl:variable>
    <xsl:variable name="docId"><xsl:value-of select="concat('/', $channel, '/', $section, '/', $year, '/', $id)"/></xsl:variable>

    <col:document xmlns:col="http://apache.org/cocoon/lenya/collection/1.0"> 
      <xsl:attribute name="id"><xsl:value-of select="$docId"/></xsl:attribute>
      <xsl:attribute name="xlink:href" namespace="http://www.w3.org/1999/xlink"><xsl:value-of select="concat($publicationPath, '/content/authoring/', $channel, '/', $section, '/', $year, '/', $id, '/index_de.xml')"/></xsl:attribute>
      <xsl:attribute name="xlink:show" namespace="http://www.w3.org/1999/xlink">embed</xsl:attribute>
    </col:document> 
  </xsl:template>
  
  <xsl:template match="related-content">
    <up:related-contents  xmlns:up="http://www.unipublic.unizh.ch/2002/up">
      <xsl:apply-templates select="block" mode="RelatedContent"/>
    </up:related-contents>
  </xsl:template>

  <xsl:template match="block" mode="RelatedContent">
    <up:related-content  xmlns:up="http://www.unipublic.unizh.ch/2002/up">
      <up:title><xsl:value-of select="title"/></up:title>
      <xsl:apply-templates select="item" mode="RelatedContent"/>
    </up:related-content>
  </xsl:template>

  <xsl:template match="item" mode="RelatedContent">
    <up:link>
      <xsl:apply-templates/>
    </up:link>
  </xsl:template>

  <xsl:template match="ulink">
    <a href="{@url}"><xsl:apply-templates/></a>
  </xsl:template>

  <xsl:template match="media">
    <xsl:variable name="source" select="media-reference/@source"/>
    <xhtml:p xmlns:xhtml="http://www.w3.org/1999/xhtml">
      <xhtml:object xmlns:xhtml="http://www.w3.org/1999/xhtml">
        <xsl:attribute name="data">
          <xsl:value-of select="media-reference/@source"/>
        </xsl:attribute>
        <xsl:attribute name="type">
          <xsl:value-of select="@media-type"/>
        </xsl:attribute>
        <xsl:value-of select="media-caption"/>
      </xhtml:object>
    </xhtml:p>
  </xsl:template>

</xsl:stylesheet> 
