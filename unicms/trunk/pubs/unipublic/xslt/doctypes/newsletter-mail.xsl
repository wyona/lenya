<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"  
    xmlns:up="http://www.unipublic.unizh.ch/2002/up"
    xmlns:col="http://apache.org/cocoon/lenya/collection/1.0"
    xmlns:mail="http://apache.org/cocoon/lenya/mail/1.0">

  <xsl:import href="variables.xsl"/>
  <xsl:param name="root"/> <!-- the URL up to (including) the area -->
  
  <xsl:param name="contextprefix"/>

  <xsl:param name="language"/>
  <xsl:param name="defaultlanguage"/>

  <xsl:strip-space elements="footer"/>

<!-- template rule matching source root element -->
  <xsl:template match="document">
    <xsl:apply-templates select="content"/>
  </xsl:template>

<xsl:template match="content">
  <mail:mail>
    <xsl:apply-templates select="up:newsletter/up:email/*"/>
    <mail:body>
      <xsl:value-of select="up:newsletter/lenya:meta/dc:title"/>
      <xsl:text>&#10;</xsl:text>
      <xsl:call-template name="underline">
        <xsl:with-param name="title" select="up:newsletter/lenya:meta/dc:title"/>
      </xsl:call-template>
      <xsl:text>&#10;</xsl:text>
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates select="up:newsletter/lenya:meta/dc:description"/>
      <xsl:text>&#10;</xsl:text>
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates select="up:newsletter/col:document"/>
      <xsl:apply-templates select="up:newsletter/up:footer"/>
    </mail:body>
  </mail:mail>
</xsl:template>

<xsl:template match="col:document">
    <xsl:value-of select="lenya:meta/dc:title"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:call-template name="underline">
      <xsl:with-param name="title" select="lenya:meta/dc:title"/>
    </xsl:call-template>
    <xsl:text>&#10;</xsl:text>
    <xsl:choose>
      <xsl:when test="up:teaser/xhtml:div[@class='tsr-text']!=''">
        <xsl:value-of select="up:teaser/xhtml:div[@class='tsr-text']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="lenya:meta/dc:description"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="lenya:meta/dcterms:issued!=''">
        <xsl:text/>(<xsl:apply-templates select="lenya:meta/dcterms:issued" mode="section"/>)<xsl:text/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&#10;(Noch nie publiziert)</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#10;Mehr unter:&#10;</xsl:text>
    <xsl:value-of select="concat('http://www.unipublic.unizh.ch', @id, $documentlanguagesuffix, '.html')"/> 
    
    <xsl:text>&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="text()">
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="br">
   <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="up:email/up:to">
  <mail:to><xsl:apply-templates/></mail:to>
</xsl:template>

<xsl:template match="up:email/up:cc">
  <mail:cc><xsl:apply-templates/></mail:cc>
</xsl:template>

<xsl:template match="up:email/up:bcc">
  <mail:bcc><xsl:apply-templates/></mail:bcc>
</xsl:template>

<xsl:template match="up:email/up:subject">
  <mail:subject><xsl:apply-templates/></mail:subject>
</xsl:template>

<xsl:template name="underline">
  <xsl:param name="title"/>
  <xsl:if test="string-length($title) &gt; 0">*<xsl:text/>
    <xsl:call-template name="underline">
      <xsl:with-param name="title" select="substring($title, 2)"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

</xsl:stylesheet> 
