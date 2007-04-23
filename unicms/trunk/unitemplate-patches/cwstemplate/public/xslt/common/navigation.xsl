<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: header.xsl,v 1.40 2005/03/09 11:11:13 peter Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml"
>


  <xsl:include href="../../../unizh/xslt/common/navigation.xsl"/>


<!-- define new templates -->

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


  <xsl:template match="xhtml:div[parent::xhtml:div[@id = 'servicenav'] and @id = 'search']" priority="1">
    <form>
      <xsl:attribute name="id">searchbox_009347054195260226203:hahgnjx1tks</xsl:attribute>
      <xsl:attribute name="action">http://www.google.uzh.ch/result.html</xsl:attribute>
      <xsl:attribute name="method">get</xsl:attribute>
      <xsl:attribute name="accept-charset">UTF-8</xsl:attribute>
      <input type="hidden" name="cx" value="009347054195260226203:hahgnjx1tks" />
      <input type="hidden" name="cof" value="FORID:11" />
      <input type="hidden" id="custom" name="sitesearch" value="{$servername}"/>
      <div class="serviceform">
        <input type="text" name="q" accesskey="5" />
      </div>
      <div class="serviceform">
        <a href="javascript:document.forms['searchbox_009347054195260226203:hahgnjx1tks'].submit();"><xsl:value-of select="text()"/></a>
      </div>
    </form>
  </xsl:template>


<!-- overwrite included templates -->

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
        <xsl:text> | </xsl:text>
      </xsl:for-each>
      <a href="#" onClick="window.open('{xhtml:div[@id = 'print']/@href}', '', 'width=700,height=700,menubar=yes,scrollbars')" onmouseout="changeIcontext('')" onmouseover="changeIcontext('{xhtml:div[@id = 'print']}')"><img src="{$imageprefix}/icon_print.gif" alt="{xhtml:div[@id = 'print']}" width="10" height="10" /></a> |
      <a onmouseout="changeIcontext('')" onmouseover="changeIcontext('{xhtml:div[@id = 'fontsize']}')">
        <xsl:attribute name="id">switchFontSize</xsl:attribute>
        <img src="{$imageprefix}/icon_bigfont.gif" alt="{xhtml:div[@id = 'fontsize']}" width="18" height="9"/></a> |
      <a href="{xhtml:div[@id = 'simpleview']/@href}" onmouseout="changeIcontext('')" onmouseover="changeIcontext('{xhtml:div[@id = 'simpleview']}')"><img src="{$imageprefix}/icon_pda.gif" alt="{xhtml:div[@id = 'simpleview']}" width="18" height="9" /></a>
    </div>
    <div class="floatclear"><xsl:comment/></div>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'menu']" priority="1">
    <xsl:variable name="descendants" select="descendant::xhtml:div[descendant-or-self::xhtml:div[@current = 'true']]"/>
    <xsl:variable name="current" select="descendant::xhtml:div[@current = 'true']"/>
    <xsl:variable name="level" select="count($descendants)"/>

    <div id="secnav">
      <xsl:apply-templates select="xhtml:div[@class = 'home']"/>
      <xsl:if test="$level > 3">
        <a href="{$descendants[$level - 3]/@href}">[...] <xsl:value-of select="$descendants[$level - 3]/text()"/></a>
       </xsl:if>
      <xsl:if test="(descendant::xhtml:div[@current = 'true']) or ($hideChildren != 'true')">
        <ul>
          <xsl:choose>
            <xsl:when test="$level > 3">
              <xsl:apply-templates select="$descendants[$level - 2]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="xhtml:div[not(@class = 'home')]"/>
            </xsl:otherwise>
          </xsl:choose>
        </ul>
      </xsl:if>
      <xsl:comment/>
    </div>
  </xsl:template>


  <xsl:template match="xhtml:div[ancestor::xhtml:div[@id = 'menu']]" priority="1">
    <li>
      <a href="{@href}">
        <xsl:if test="@current = 'true'">
          <xsl:attribute name="class">activ</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="text()"/>
      </a>
      <xsl:if test="xhtml:div and not((@current = 'true') and ($hideChildren = 'true'))">
        <ul>
          <xsl:apply-templates select="xhtml:div"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>


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
