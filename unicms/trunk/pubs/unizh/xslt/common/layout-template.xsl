<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: header.xsl,v 1.40 2005/03/09 11:11:13 peter Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:tal="http://xml.zope.org/namespaces/tal"
>


  <xsl:template match="document" priority="2">
    <xsl:choose>
      <xsl:when test="layout/xhtml:html">
        <xsl:apply-templates select="layout/xhtml:html"/> 
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*[ancestor::layout]|node()[ancestor::layout]">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template> 



  <xsl:template match="*[@tal:content]">
    <xsl:copy>
      <xsl:apply-templates select="@*[name() != 'tal:content']"/>
      <xsl:choose>
        <xsl:when test="@tal:content = 'header/superscription'">
          <xsl:value-of select="/document/content/*/unizh:header/unizh:superscription"/>
        </xsl:when>
        <xsl:when test="@tal:content = 'header/title'">
          <xsl:value-of select="/document/content/*/unizh:header/unizh:heading"/>
        </xsl:when>
        <xsl:when test="@tal:content = 'content/title'">
          <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*[contains(@tal:content, 'structure')]">
    <xsl:copy>
      <xsl:apply-templates select="@*[name() != 'tal:content']"/>
      <xsl:choose>
        <xsl:when test="@tal:content = 'structure breadcrumbtrail'">
          <xsl:call-template name="breadcrumbtrail"/>
        </xsl:when>
        <xsl:when test="@tal:content = 'structure tabs'">
          <xsl:call-template name="tabs"/>
        </xsl:when>
        <xsl:when test="@tal:content = 'structure body'">
          <xsl:call-template name="body"/>
        </xsl:when>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*[contains(@tal:replace, 'structure')]">
    <xsl:choose>
      <xsl:when test="@tal:replace = 'structure links/home'">
        <a href="{/document/xhtml:div[@id = 'servicenav']/xhtml:div[@id = 'home']/@href}">
          <xsl:value-of select="/document/xhtml:div[@id = 'servicenav']/xhtml:div[@id = 'home']/text()"/>
        </a>
      </xsl:when>
      <xsl:when test="@tal:replace = 'structure links/contact'">
        <a href="{/document/xhtml:div[@id = 'servicenav']/xhtml:div[@id = 'contact']/@href}">
          <xsl:value-of select="/document/xhtml:div[@id = 'servicenav']/xhtml:div[@id = 'contact']/text()"/>
        </a>
      </xsl:when>
      <xsl:when test="@tal:replace = 'structure links/sitemap'">
        <a href="{/document/xhtml:div[@id = 'servicenav']/xhtml:div[@id = 'sitemap']/@href}">
          <xsl:value-of select="/document/xhtml:div[@id = 'servicenav']/xhtml:div[@id = 'sitemap']/text()"/>
        </a>
      </xsl:when>
      <xsl:when test="@tal:replace = 'structure links/search'">
        <a href="{/document/xhtml:div[@id = 'servicenav']/xhtml:div[@id = 'search']/@href}">
          <xsl:value-of select="/document/xhtml:div[@id = 'servicenav']/xhtml:div[@id = 'search']/text()"/>
        </a>
      </xsl:when>
      <xsl:when test="@tal:replace = 'structure links/print'">
        <a href="{/document/xhtml:div[@id = 'toolnav']/xhtml:div[@id = 'print']/@href}">
          <span>
            <xsl:value-of select="/document/xhtml:div[@id = 'toolnav']/xhtml:div[@id = 'print']/text()"/>
          </span>
        </a>
      </xsl:when>
      <xsl:when test="@tal:replace = 'structure links/fontsize'">
        <a href="{/document/xhtml:div[@id = 'toolnav']/xhtml:div[@id = 'fontsize']/@href}">
          <span>
            <xsl:value-of select="/document/xhtml:div[@id = 'toolnav']/xhtml:div[@id = 'fontsize']/text()"/>
          </span>
        </a>
      </xsl:when>
      <xsl:when test="@tal:replace = 'structure links/simpleview'">
        <a href="{/document/xhtml:div[@id = 'toolnav']/xhtml:div[@id = 'fontsize']/@href}">
          <span>
            <xsl:value-of select="/document/xhtml:div[@id = 'toolnav']/xhtml:div[@id = 'simpleview']/text()"/>
          </span>
        </a>
      </xsl:when>
      <xsl:when test="@tal:replace = 'structure lists/items/links/languages'">
        <xsl:for-each select="/document/xhtml:div[@id = 'toolnav']/xhtml:div[@class='language']">
          <li id="language">
            <a href="{@href}">
              <span>
                <xsl:value-of select="text()"/>
              </span>
            </a>
          </li>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="@tal:replace = 'structure quicklinks'">
        <xsl:call-template name="quicklinks"/>
      </xsl:when>
      <xsl:when test="@tal:replace = 'structure menu'">
        <xsl:call-template name="menu"/>
      </xsl:when>
      <xsl:when test="@tal:replace = 'structure sidebar'">
        <xsl:call-template name="sidebar"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>



  <xsl:template name="breadcrumbtrail">
    <ul>
      <xsl:for-each select="/document/xhtml:div[@id = 'breadcrumb']/xhtml:div">
        <li><a href="{@href}"><xsl:value-of select="text()"/></a></li>
      </xsl:for-each>
    </ul>
  </xsl:template>


  <xsl:template name="tabs">
    <ul>
      <xsl:for-each select="/document/xhtml:div[@id = 'tabs']/xhtml:div">
        <li><a href="{@href}"><xsl:value-of select="text()"/></a></li>
      </xsl:for-each>
    </ul>
  </xsl:template>


  <xsl:template name="body">
    <h2>
      <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/><xsl:comment/>
    </h2>
    <xsl:apply-templates select="/document/content/*/*[not(self::lenya:meta) and not(self::unizh:related-content) and not(self::unizh:contcol1) and not(self::unizh:header)]/*"/>
  </xsl:template>

  <xsl:template name="quicklinks">
    <xsl:if test="/document/content/*/unizh:contcol1/unizh:quicklinks/unizh:quicklink">
      <div id="quicklinks">
        <xsl:for-each select="/document/content/*/unizh:contcol1/unizh:quicklinks/unizh:quicklink">
          <h2><xsl:value-of select="xhtml:p"/></h2>
          <ul>
            <xsl:for-each select="xhtml:a">
              <li><a href="{@href}"><xsl:value-of select="text()"/></a></li>
            </xsl:for-each>
          </ul>
        </xsl:for-each>
      </div>
    </xsl:if>
    <xsl:comment/>
  </xsl:template>
  

  <xsl:template match="@href[ancestor::layout]">
    <xsl:attribute name="href">
      <xsl:value-of select="concat('/unitemplate/authoring/layout-', .)"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="@src[ancestor::layout]">
    <xsl:attribute name="src">
      <xsl:value-of select="concat('/unitemplate/authoring/layout-', .)"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template name="menu">
    <xsl:if test="/document/xhtml:div[@id = 'menu']/xhtml:div">
      <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']" mode="layout"/>
    </xsl:if>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'menu']" mode="layout">
      <xsl:variable name="descendants" select="descendant::xhtml:div[descendant-or-self::xhtml:div[@current = 'true']]"/>
      <xsl:variable name="current" select="descendant::xhtml:div[@current = 'true']"/>
      <xsl:variable name="level" select="count($descendants)"/>

      <div id="menu">
        <xsl:if test="$level > 3">
          <a href="{$descendants[$level - 3]/@href}">[...] <xsl:value-of select="$descendants[$level - 3]/text()"/></a>
        </xsl:if>
        <ul>
          <xsl:choose>
            <xsl:when test="$level > 3">
              <xsl:apply-templates select="$descendants[$level - 2]" mode="layout"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="xhtml:div[not(@class = 'home')]" mode="layout"/>
            </xsl:otherwise>
          </xsl:choose>
        </ul>
        <xsl:comment/>
      </div>
  </xsl:template>


  <xsl:template match="xhtml:div[ancestor::xhtml:div[@id = 'menu']]" mode="layout">
    <li>
      <xsl:if test="@current = 'true'">
        <xsl:attribute name="class">selected</xsl:attribute>
      </xsl:if>
      <a href="{@href}">
        <xsl:value-of select="text()"/>
      </a>
      <xsl:if test="xhtml:div">
        <ul>
          <xsl:apply-templates select="xhtml:div" mode="layout"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>



  <xsl:template name="sidebar">
    <xsl:if test="/document/content/*/unizh:related-content/*">
      <div id="sidebar"><xsl:comment/>
        <xsl:apply-templates select="/document/content/*/unizh:related-content/*"/>
      </div>
    </xsl:if>
    <xsl:comment/>
  </xsl:template>



  <xsl:template match="dc:*" priority="2"/>


</xsl:stylesheet>


