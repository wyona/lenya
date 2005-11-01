<?xml version="1.0" encoding="UTF-8" ?>
<!-- $Id: sitetree2nav.xsl,v 1.2 2005/01/07 15:15:26 jann Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tree="http://apache.org/cocoon/lenya/sitetree/1.0"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    exclude-result-prefixes="tree"
    >


  <xsl:param name="root"/>
  <xsl:param name="url"/>
  <xsl:param name="chosenlanguage"/>
  <xsl:param name="defaultlanguage"/>
 

  <xsl:template match="tree:site">
    <nav:site url="{$root}{$url}">
      <xsl:apply-templates/>
    </nav:site>
  </xsl:template>


  <xsl:template name="language">
    <xsl:choose>
      <xsl:when test="tree:label[lang($chosenlanguage)]"><xsl:value-of select="$chosenlanguage"/></xsl:when>
      <xsl:when test="tree:label[lang($defaultlanguage)]"><xsl:value-of select="$defaultlanguage"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="tree:label/@xml:lang"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="other-languages">
    <xsl:attribute name="other-languages">
      <xsl:for-each select="tree:label[@xml:lang != $chosenlanguage]/@xml:lang">
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">,</xsl:if>
      </xsl:for-each>
    </xsl:attribute>
  </xsl:template>


  <xsl:template match="tree:node">

    <xsl:param name="parent-dir"/>
    <xsl:variable name="basic-url" select="concat($parent-dir, @id)"/>
    <xsl:variable name="language">
      <xsl:call-template name="language"/>
    </xsl:variable>
    <xsl:variable name="language-suffix" select="concat('_', $language)"/>
    <xsl:variable name="canonical-language-suffix">
      <xsl:if test="$language !='' and $language != $defaultlanguage">
        <xsl:value-of select="$language-suffix"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="canonical-url" select="concat($basic-url, $canonical-language-suffix, '.html')"/>
    <xsl:variable name="non-canonical-url" select="concat($basic-url, $language-suffix, '.html')"/>

    <nav:node>
      <xsl:copy-of select="@id"/>
      <xsl:attribute name="basic-url">
        <xsl:value-of select="$parent-dir"/><xsl:value-of select="@id"/>
      </xsl:attribute>
      <xsl:call-template name="other-languages"/>
      <xsl:copy-of select="@visibleinnav"/>
    
      <xsl:if test="$url = $canonical-url or $url = $non-canonical-url">
        <xsl:attribute name="current">true</xsl:attribute>
      </xsl:if>
    
      <xsl:attribute name="href">
        <xsl:value-of select="concat($root, $canonical-url)"/>
      </xsl:attribute>
      
      <xsl:attribute name="language-suffix" select="$language-suffix"/>
 
      <xsl:choose>
        <xsl:when test="tree:label[lang($language)]"> 
          <xsl:apply-templates select="tree:label[lang($language)]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="tree:label[1]"/>
        </xsl:otherwise>
      </xsl:choose> 
    
      <xsl:apply-templates select="tree:node">
        <xsl:with-param name="parent-dir" select="concat($basic-url, '/')"/>
      </xsl:apply-templates> 
    </nav:node>
  </xsl:template>


  <xsl:template match="tree:label">
    <nav:label>
      <xsl:apply-templates/>
    </nav:label>
  </xsl:template>


  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>


</xsl:stylesheet> 
