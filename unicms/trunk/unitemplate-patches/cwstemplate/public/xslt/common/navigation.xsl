<?xml version="1.0" encoding="UTF-8"?>


<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml"
>


  <xsl:include href="../../../unizh/xslt/common/navigation.xsl"/>


<!-- define new templates -->

  <!-- subtabs. only on public home page -->
  <xsl:template match="xhtml:div[@id = 'subtabs']">
    <div id="secnavTab">
      <xsl:for-each select="xhtml:div">
        <a href="{@href}">
          <xsl:if test="@current = 'true'">
            <xsl:attribute name="class">activ</xsl:attribute>
          </xsl:if>
          <xsl:value-of select="text()"/>
        </a>
        <xsl:if test="position() &lt; last()">
          <div class="linkseparator">|</div>
        </xsl:if>
      </xsl:for-each>
      &#160;
    </div>
  </xsl:template>


<!-- overwrite included templates -->

  <!-- public home page breadcrumb does not need home link (it IS home ) -->
  <xsl:template match="xhtml:div[@id = 'servicenav']" priority="1">
    <div id="servicenavpos">
      <xsl:choose>
        <xsl:when test="$document-element-name = 'unizh:homepage4cols' or $document-element-name = 'unizh:homepage'">
          <xsl:apply-templates select="xhtml:div[@id != 'home']"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates />
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>


  <!-- no print view, no PDA view for public publication -->
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


  <!-- first level navigation on home page has no pipes, but javascript mouseover -->
  <xsl:template match="xhtml:div[@id = 'tabs']" priority="1">
    <div id="primarnav">
      <a name="navigation" class="namedanchor"><xsl:comment/></a>
      <xsl:for-each select="xhtml:div">
        <a href="{@href}">
          <xsl:choose>
            <xsl:when test="@current = 'true'">
              <xsl:attribute name="class">activ</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="onmouseover">changeImgNav(<xsl:value-of select="position()"/>)</xsl:attribute>
              <xsl:attribute name="onmouseout">changeImgNav(<xsl:value-of select="$navPosition"/>)</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="text()"/>
        </a>
      </xsl:for-each>
      <xsl:comment/>
    </div>
  </xsl:template>

</xsl:stylesheet>
