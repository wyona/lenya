<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: variables.xsl,v 1.2 2004/11/29 09:20:32 thomas Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:uz="http://unizh.ch"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  >
  
  <xsl:variable name="languagesuffix">
    <xsl:if test="$defaultlanguage != $language">.<xsl:value-of select="$language"/></xsl:if>
  </xsl:variable>
  
  <xsl:variable name="documentlanguagesuffix">
    <xsl:if test="$defaultlanguage != $language">_<xsl:value-of select="$language"/></xsl:if>
  </xsl:variable>
                  
  <xsl:variable name="imageprefix" select="concat($contextprefix, '/eltemplate/authoring/images')"/>
  
  <xsl:variable name="content" select="/document/content/*"/>
  
  <xsl:variable name="document-element-name" select="local-name($content)"/>

</xsl:stylesheet>