<?xml version="1.0" encoding="UTF-8" ?>

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


  <xsl:variable name="localsharedresources" select="concat( substring-before( $root, $area ), 'authoring' )"/>
  <xsl:variable name="imageprefix" select="concat( $localsharedresources, '/images' )"/>


  <xsl:variable name="content" select="/document/content/*"/>


  <xsl:variable name="document-element-name">
    <xsl:choose>
      <xsl:when test="name($content) = local-name($content)">
        <xsl:value-of select="concat('xhtml:', name($content))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="name($content)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


   <xsl:variable name="hideChildren">
    <xsl:choose>
      <xsl:when test="/document/content/*/@unizh:hideChildren">
        <xsl:value-of select="/document/content/*/@unizh:hideChildren"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>false</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <xsl:variable name="numColumns">
    <xsl:choose>
      <xsl:when test="/document/content/*/xhtml:body/unizh:column">
        <xsl:value-of select="count( /document/content/*/xhtml:body/unizh:column )"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="0"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <xsl:variable name="numDoubles">
    <xsl:choose>
      <xsl:when test="/document/content/*/xhtml:body/unizh:column">
        <xsl:value-of select="count( /document/content/*/xhtml:body/unizh:column[@double = 'true'] )"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="0"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- this key is valid for all maps in http://cms.uzh.ch/ and is registered for stefan.paschke@gmail.com -->
  <xsl:variable name="googleKeyAuthoring">ABQIAAAA71si2DaO4nTRE11c0Y-9rRTBfUk9TZrBRaIteybtnU2KziHEpRTsFYn75zZeZJ8WoDN0lQORnC4jsA</xsl:variable>

</xsl:stylesheet>
