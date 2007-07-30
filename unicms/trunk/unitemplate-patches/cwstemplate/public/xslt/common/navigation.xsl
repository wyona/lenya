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
