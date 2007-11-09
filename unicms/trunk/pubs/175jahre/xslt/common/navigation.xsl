<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml" 
>


  <xsl:param name="servername" />

  <xsl:template match="xhtml:div[@id = 'servicenav']">
    <div id="servicenav">
      <xsl:apply-templates />
    </div>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'servicenav']/xhtml:div">
    <xsl:if test="position() &gt; 1">
      <xsl:text> | </xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@id='search'">
        <a href="javascript:showSearch()" accesskey="3">
          <xsl:value-of select="text()" />
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a>
          <xsl:attribute name="href"><xsl:value-of select="@href" /></xsl:attribute>
          <xsl:attribute name="accesskey">
            <xsl:choose>
              <xsl:when test="@id = 'home'">0</xsl:when>
              <xsl:when test="@id = 'contact'">3</xsl:when>
              <xsl:when test="@id = 'sitemap'">4</xsl:when>
            </xsl:choose>
          </xsl:attribute>
          <xsl:value-of select="text()" />
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'servicenav']/xhtml:div[@id = 'search']" mode="form">
    <div id="searchform">
      <form>
        <xsl:attribute name="id">searchbox_009347054195260226203:hahgnjx1tks</xsl:attribute>
        <xsl:attribute name="action">
          <xsl:value-of select="@href" />
        </xsl:attribute>
        <xsl:attribute name="method">get</xsl:attribute>
        <xsl:attribute name="accept-charset">UTF-8</xsl:attribute>
        <input type="hidden" name="cx" value="009347054195260226203:hahgnjx1tks" />
        <input type="hidden" name="cof" value="FORID:11" />
        <input type="hidden" id="custom" name="sitesearch" value="{$servername}" />
        <a href="javascript:hideSearch()" class="iconclose" alt="Suchformular schliessen"><img src="{$imageprefix}/1.gif" width="7" height="7" /></a>
        <div class="inputfield">
          Suchen: <input accesskey="5" name="q" type="text" class="text" />
        </div>
        <div class="submitfield">
          <input type="image" class="button" src="{$localsharedresources}/images/search_button.gif" alt="Suche starten" id="searchButton" width="19" height="16" border="0" />
        </div>
      </form>
    </div>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'menu']">
    <xsl:variable name="descendants" select="descendant::xhtml:div[descendant-or-self::xhtml:div[@current = 'true']]" />
    <xsl:variable name="current" select="descendant::xhtml:div[@current = 'true']" />
    <xsl:variable name="level" select="count($descendants)" />

    <div id="secnav">
      <xsl:if test="$level > 3">
        <a href="{$descendants[$level - 3]/@href}">[...] <xsl:value-of select="$descendants[$level - 3]/text()" /></a>
      </xsl:if>
      <xsl:if test="(descendant::xhtml:div[@current = 'true']) or ($hideChildren != 'true')">
        <ul>
          <xsl:choose>
            <xsl:when test="$level > 3">
              <xsl:apply-templates select="$descendants[$level - 2]" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="xhtml:div" />
            </xsl:otherwise>
          </xsl:choose>
        </ul>
      </xsl:if>
      <xsl:comment/>
    </div>
  </xsl:template>


  <xsl:template match="xhtml:div[ancestor::xhtml:div[@id = 'menu']]">
    <li>
      <a href="{@href}">
        <xsl:choose>
          <xsl:when test="@current = 'true'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:when>
          <xsl:when test="@selected = 'true'">
            <xsl:attribute name="class">active</xsl:attribute>
          </xsl:when>
        </xsl:choose>
        <xsl:value-of select="text()" />
      </a>
      <xsl:if test="xhtml:div">
        <ul>
          <xsl:apply-templates select="xhtml:div" />
        </ul>
      </xsl:if>
    </li>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'tabs']">
    <div id="primarnav">
      <a name="navigation" class="namedanchor" /> 
      <xsl:for-each select="xhtml:div">
        <a href="{@href}">
          <xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
          <xsl:if test="@current = 'true'">
            <xsl:attribute name="class">activ</xsl:attribute>
          </xsl:if>
          <xsl:value-of select="text()" />
        </a>
      </xsl:for-each>
    </div>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'breadcrumb']">
    <div>
      <xsl:for-each select="xhtml:div">
        <xsl:if test="position() &gt; 1">
          <xsl:text> &gt; </xsl:text>
        </xsl:if>
        <a href="{@href}"><xsl:value-of select="." /></a>
      </xsl:for-each>
    </div>
  </xsl:template>


</xsl:stylesheet>


