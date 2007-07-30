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
    <a>
      <xsl:attribute name="href"><xsl:text>http://www.uzh.ch</xsl:text></xsl:attribute>
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
      <xsl:for-each select="xhtml:div[@class='language']">
        <xsl:choose>
          <xsl:when test=". = 'de'">
            <a href="{@href}">Deutsch</a>
          </xsl:when>
          <xsl:when test=". = 'en'">
            <a href="{@href}">English</a>
          </xsl:when>
          <xsl:when test=". = 'fr'">
            <a href="{@href}">Français</a>
          </xsl:when>
          <xsl:when test=". = 'it'">
            <a href="{@href}">Italiano</a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{@href}"><xsl:value-of select="translate(., 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/></a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </div>
    <div class="floatclear"><xsl:comment/></div>
  </xsl:template>

</xsl:stylesheet>
