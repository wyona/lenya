<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: menu.xsl,v 1.7 2005/02/23 13:17:21 edith Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="nav"
    >

<xsl:import href="../../../../../xslt/navigation/menu.xsl"/>

<xsl:param name="root"/>

<xsl:template match="nav:node[@visibleinnav = 'false']" priority="1"/>

<xsl:template match="nav:node[@id = 'dossiers']">
  <div class="dossier-front"> 
    <a href="{@href}">
      <img src="{$root}images/dossiers/doss_rub_title.gif" alt="{@label}" width="112" height="28" border="0" />
    </a>
  </div>
</xsl:template>

<xsl:template name="item">
    <xsl:choose>
      <xsl:when test="@current = 'true'">
        <xsl:call-template name="item-selected"/>
      </xsl:when>
      <xsl:when test="count(ancestor-or-self::nav:node)='2' and descendant::nav:node[@current = 'true']">
        <xsl:call-template name="item-selected"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="item-default"/>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="item-default">
  <xsl:variable name="label"><xsl:value-of select="nav:label"/></xsl:variable>
  <xsl:choose>
    <xsl:when test="count(ancestor-or-self::nav:node)='1'">
      <div class="menuitem-{count(ancestor-or-self::nav:node)}">
        <img src="{$root}images/t_{@id}.gif" border="0" alt="{@label}"/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <div class="menuitem-{count(ancestor-or-self::nav:node)}">
        <a href="{@href}">
          <img height="25" src="{$root}images/nav_{@id}.gif" border="0" name="{@id}" alt="{@label}" width="115"/>
        </a>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="item-selected">
  <xsl:variable name="label"><xsl:value-of select="nav:label"/></xsl:variable>
  <div class="menuitem-selected-{count(ancestor-or-self::nav:node)}">
    <img height="25" src="{$root}images/nav_light_{@id}.gif" border="0" name="{@id}" alt="{$label}" width="115"/>
  </div>
</xsl:template>
    
</xsl:stylesheet> 
