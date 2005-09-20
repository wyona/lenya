<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: header.xsl,v 1.40 2005/03/09 11:11:13 peter Exp $ -->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
                xmlns="http://www.w3.org/1999/xhtml" 
                xmlns:dc="http://purl.org/dc/elements/1.1/" 
                xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" 
                xmlns:uz="http://unizh.ch" 
                xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                >
                

  <xsl:template match="xhtml:div[@id = 'servicenav']">
    <div id="servicenavpos">
      <xsl:for-each select="xhtml:div[position() &lt; last()]">
        <a href="{@href}"><xsl:value-of select="."/></a>
        <xsl:if test="position() &lt; last()">|</xsl:if>
      </xsl:for-each>
      <form id="formsearch" action="" method="post" enctype="text/plain">
        <div class="servieceform">
          <input type="text" name="searchtext"/>
        </div>
        <div class="servieceform">
          <a href="javascript:document.forms['formsearch'].submit();">Suche</a>
        </div>
      </form>
    </div>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'toolnav']">
    <div id="toolnav">
      <a href="{xhtml:div[@id = 'language']/@href}"><xsl:value-of select="xhtml:div[@id = 'language']"/></a> |
      <a href="{xhtml:div[@id = 'print']/@href}"><img src="/lenya/unizh/authoring/images/icon_print.gif" alt="icon print link " width="10" height="10" border="0" /></a> |
      <a href="#"><img src="/lenya/unizh/authoring/images/icon_bigfont.gif" alt="icon bigfont link" border="0" width="16" height="10"/></a> |
      <a href="{xhtml:div[@id = 'pda']/@href}"><img src="/lenya/unizh/authoring/images/icon_pda.gif" alt="icon pda link" width="14" height="10" border="0" /></a>
    </div>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'menu']">
    <div id="secnav">
      <div class="solidline">
        <img src="/lenya/unizh/authoring/images/1.gif" alt="separation line" width="1" height="1" border="0" />
      </div>
      <ul>
        <xsl:apply-templates select="xhtml:div"/>
      </ul>
    </div>
  </xsl:template>


  <xsl:template match="xhtml:div[ancestor::xhtml:div[@id = 'menu']]">
    <li>
      <a href="{@href}">
        <xsl:if test="@current = 'true'">
          <xsl:attribute name="class">activ</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="text()"/>
      </a>
      <xsl:if test="xhtml:div">
        <ul>
          <xsl:apply-templates select="xhtml:div"/>
        </ul>
      </xsl:if>
      <xsl:if test="parent::xhtml:div[@id = 'menu']">
        <div class="dotline">
          <img src="/lenya/unizh/authoring/images/1.gif" alt="separation line" width="1" height="1" border="0" />
        </div>
      </xsl:if>
    </li>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'tabs']">
    <div id="primarnav"><xsl:comment/>
      <xsl:for-each select="xhtml:div">
        <a href="{@href}"> <xsl:value-of select="@label"/> </a>
        <xsl:if test="position() &lt; last()">
          <div class="linkseparator">|</div>
        </xsl:if>
      </xsl:for-each>
    </div>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'breadcrumb']">
    <div id="breadclamnav">
      <a href="{@root}"><xsl:value-of select="@label"/></a>
      <xsl:for-each select="xhtml:div">
         &gt; <a href="{@href}"><xsl:value-of select="."/></a>
      </xsl:for-each>
    </div>
  </xsl:template>


</xsl:stylesheet>


