<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: breadcrumb.xsl,v 1.2 2004/02/04 14:34:37 gregor Exp $ -->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:lenya="http://apache.org/cocoon/lenya/document/1.0" 
                xmlns="http://www.w3.org/1999/xhtml" 
                xmlns:dc="http://purl.org/dc/elements/1.1/" 
                xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" 
                xmlns:uz="http://unizh.ch" 
                xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                >
  
  <xsl:template name="breadcrumb">
    <div id="breadcrumb">
      <xsl:apply-templates select="/document/uz:unizh/uz:university" mode="breadcrumb"/>
      <xsl:apply-templates select="/document/uz:unizh/uz:section" mode="breadcrumb"/>
      <xsl:apply-templates select="/document/uz:unizh/uz:publication" mode="breadcrumb"/>

<!-- start the breadcrumb path at subhomepage level (not at root level) -->
      <xsl:variable name="subhomepages" select="/document/xhtml:div[(@id = 'breadcrumb')]/*[@doctype = 'unizh:homepage']"/>
      <xsl:variable name="lastSubhomepage" select="$subhomepages[last()]"/>

      <xsl:variable name="lastSubhomepagePosition">
        <xsl:choose>
          <xsl:when test="$lastSubhomepage">
            <xsl:value-of select="$lastSubhomepage/@position"/>
          </xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
        </xsl:variable>

      <xsl:apply-templates select="/document/xhtml:div[(@id = 'breadcrumb')]/*[@position &gt; $lastSubhomepagePosition - 1]" mode="breadcrumb"/>
    </div>
  </xsl:template>
  
  
  <xsl:template match="uz:unizh/uz:university[not(@breadcrumb = 'false')]" mode="breadcrumb">
    <a href="{@href}"><i18n:text><xsl:value-of select="."/></i18n:text></a>
    <xsl:call-template name="breadcrumb_separator"/>
  </xsl:template>
  
  
  <xsl:template match="uz:unizh/uz:section[not(@breadcrumb = 'false')]" mode="breadcrumb">
    <a href="{../uz:university/@href}/{.}/"><i18n:text>section_<xsl:value-of select="."/></i18n:text></a>
    <xsl:call-template name="breadcrumb_separator"/>
  </xsl:template>
  
  
  <xsl:template match="uz:unizh/uz:publication[not(@breadcrumb = 'false')]" mode="breadcrumb">
      <a href="{$root}/index{$documentlanguagesuffix}.html"><i18n:text>publication_<xsl:value-of select="."/></i18n:text></a>
  </xsl:template>
  
  
  <xsl:template match="uz:unizh/*[@breadcrumb = 'false']" mode="breadcrumb"/>
  

  <xsl:template match="xhtml:div[@current = 'true']" mode="breadcrumb">

    <xsl:call-template name="breadcrumb_separator"/>
    <xsl:value-of select="@label"/>

  </xsl:template>
  

  <xsl:template match="xhtml:div" mode="breadcrumb">

    <xsl:call-template name="breadcrumb_separator"/>
    <a href="{@href}"> <xsl:value-of select="@label"/> </a>

  </xsl:template>


  <xsl:template name="breadcrumb_separator">
    &gt;
  </xsl:template>


</xsl:stylesheet>


