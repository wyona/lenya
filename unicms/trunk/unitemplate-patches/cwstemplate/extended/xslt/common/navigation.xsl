<?xml version="1.0" encoding="UTF-8"?>


<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml"
>


  <xsl:include href="../../../unizh/xslt/common/navigation.xsl"/>


<!-- overwrite included templates -->

  <!-- home link in extended pubs links to UZH public -->
  <xsl:template match="xhtml:div[parent::xhtml:div[@id = 'servicenav'] and @id = 'home']">
    <a href="{/document/xhtml:div[@id = 'breadcrumb']/@root}">
      <xsl:attribute name="accesskey"><xsl:text>0</xsl:text></xsl:attribute>
      <xsl:value-of select="text()"/>
    </a>
  </xsl:template>


  <!-- no print view, no PDA view for extended publications -->
  <xsl:template match="xhtml:div[@id = 'toolnav']" priority="1">
    <div id="toolnav">
      <div class="icontextpos">
        <div id="icontext">&#160;</div>
      </div>
      <xsl:choose>
        <xsl:when test="count(xhtml:div[@class='language']) &gt; 1">
          <xsl:for-each select="xhtml:div[@class='language']">
            <a href="{@href}"><xsl:value-of select="translate(., 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/></a>
            <xsl:text> | </xsl:text>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="count(xhtml:div[@class='language']) = 1">
          <a>
            <xsl:attribute name="href"><xsl:value-of select="xhtml:div[@class='language']/@href"/></xsl:attribute>
            <xsl:choose>
              <xsl:when test="xhtml:div[@class='language']/text() = 'de'">Deutsch</xsl:when>
              <xsl:when test="xhtml:div[@class='language']/text() = 'en'">English</xsl:when>
              <xsl:when test="xhtml:div[@class='language']/text() = 'fr'">Français</xsl:when>
              <xsl:when test="xhtml:div[@class='language']/text() = 'it'">Italiano</xsl:when>
              <xsl:otherwise><xsl:value-of select="translate(xhtml:div[@class='language']/text(), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/></xsl:otherwise>
            </xsl:choose>
          </a>
          <xsl:text> | </xsl:text>
        </xsl:when>
      </xsl:choose>
      <a onmouseout="changeIcontext('')" onmouseover="changeIcontext('{xhtml:div[@id = 'fontsize']}')">
        <xsl:attribute name="id">switchFontSize</xsl:attribute>
        <img src="{$imageprefix}/icon_bigfont.gif" alt="{xhtml:div[@id = 'fontsize']}" width="18" height="9"/></a>
    </div>
    <div class="floatclear"><xsl:comment/></div>
  </xsl:template>

</xsl:stylesheet>
