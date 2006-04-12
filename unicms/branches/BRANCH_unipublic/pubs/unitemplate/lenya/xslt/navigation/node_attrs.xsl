<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: menu.xsl,v 1.5 2005/02/24 15:29:24 jann Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    exclude-result-prefixes="nav"
    >
   

  <xsl:template match="*" mode="node_attrs">

    <xsl:if test="@current = 'true'">
      <xsl:attribute name="current">
        <xsl:value-of select="'true'"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:attribute name="basic-url">
      <xsl:value-of select="@basic-url"/>
    </xsl:attribute>

    <xsl:attribute name="href">
<!--
      <xsl:value-of select="concat(@basic-url, @language-suffix, @suffix)"/>
-->
      <xsl:value-of select="@href"/>
    </xsl:attribute>

    <xsl:attribute name="label">
      <xsl:value-of select="nav:label"/>
    </xsl:attribute>

    <xsl:attribute name="lang">
      <xsl:value-of select="nav:label/@xml:lang"/>
    </xsl:attribute>

    <xsl:attribute name="level">
      <xsl:choose>
        <xsl:when test="@id = 'index'">
          <xsl:value-of select="count(ancestor-or-self::nav:node) - 1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="count(ancestor-or-self::nav:node)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:attribute name="suffix">
      <xsl:value-of select="@suffix"/>
    </xsl:attribute>

    <xsl:value-of select="nav:label"/>    <!-- node's text -->

  </xsl:template>
    

</xsl:stylesheet> 
