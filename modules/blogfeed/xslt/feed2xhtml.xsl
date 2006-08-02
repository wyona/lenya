<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:mobi="http://mobi.ch/homepage/1.0"
  xmlns:media="http://apache.org/lenya/pubs/default/media/1.0"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:blog="http://apache.org/cocoon/blog/1.0"
  exclude-result-prefixes="xhtml lenya mobi dc">
  
  <xsl:param name="root"/> <!-- the URL up to (including) the area -->
  <xsl:param name="documentId"/>
  <xsl:param name="context-prefix" select="''"/>
  <xsl:param name="language"/>
  <xsl:param name="document-type"/>
  <xsl:param name="documentParent"/>
  <xsl:param name="title"/>
  <xsl:variable name="nodeid"
    select="concat($context-prefix,$root,$documentParent)"/>
  
  <xsl:template match="/">
    <xhtml:div id="body">
      <!--<xsl:apply-templates />-->
      <xsl:apply-templates select="//blog:overview" mode="overview"/>
      <xsl:apply-templates select="//xhtml:body/*"/>
    </xhtml:div>
  </xsl:template>
  
  <xsl:template match="*[@id='feedBXE']">
    <div>
      <xsl:attribute name="bxe_xpath">//*[@id = '<xsl:value-of select="@id"/>']</xsl:attribute>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="./*|text()"/>
    </div>
  </xsl:template>
  
  <xsl:template match="blog:overview" mode="overview">
    <h2>Archive</h2>
    <div class="overview">
      <xsl:choose>
        <xsl:when test="not(*)">No entries yet.</xsl:when>
        <xsl:otherwise><xsl:apply-templates mode="overview"/></xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>
  
  <xsl:template match="blog:year" mode="overview">
    <div class="overview-year">
      <i18n:text>Year</i18n:text>: <xsl:value-of select="@id"/>
    </div>
    <xsl:apply-templates mode="overview"/>
  </xsl:template>
  
  <xsl:template match="blog:month" mode="overview">
    <div class="overview-month">
      <i18n:text>Month</i18n:text>: <xsl:value-of select="@id"/>
    </div>
    <xsl:apply-templates mode="overview"/>
  </xsl:template>
  
  <xsl:template match="blog:day" mode="overview">
    <div class="overview-day">
      <i18n:text>Day</i18n:text>: <xsl:value-of select="@id"/>
    </div>
    <xsl:apply-templates mode="overview"/>
  </xsl:template>
  
  <xsl:template match="blog:entry" mode="overview">
    <div class="overview-entry"> <a href="{@url}"><xsl:value-of select="@title"/>
      </a> - <xsl:value-of select="."/>
    </div>
  </xsl:template>
  
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
