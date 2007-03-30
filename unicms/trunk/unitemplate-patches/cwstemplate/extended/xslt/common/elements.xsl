<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: elements.xsl,v 1.79 2005/01/17 09:15:15 thomas Exp $ -->

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:index="http://apache.org/cocoon/lenya/documentindex/1.0"
  xmlns:level="http://apache.org/cocoon/lenya/documentlevel/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" 
  xmlns:uz="http://unizh.ch"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:ci="http://apache.org/cocoon/include/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
>


  <xsl:include href="../../../unizh/xslt/common/elements.xsl"/>


<!-- define new templates -->

  <xsl:template match="unizh:banner">
    <div class="banner">
      <xsl:apply-templates select="xhtml:object"/>
    </div>
  </xsl:template>


  <xsl:template match="unizh:select">
    <div id="select">
      <h3><xsl:value-of select="@label"/></h3>
      <form action="javascript:selectLocation()" method="POST" enctype="text/plain">
        <select name="target" onchange="selectLocation()">
          <xsl:for-each select="xhtml:a">
            <option>
              <xsl:attribute name="value"><xsl:value-of select="@href"/></xsl:attribute>
              <xsl:value-of select="."/>
            </option>
          </xsl:for-each>
        </select>
        <input type="submit" id="submit" value="go!" />
      </form>
    </div>
  </xsl:template>


<!-- overwrite included templates -->

  <xsl:template match="unizh:teaser" priority="1">
    <div class="teaser">
      <xsl:if test="xhtml:object">
        <xsl:apply-templates select="xhtml:object"/>
      </xsl:if>
      <h3><xsl:value-of select="unizh:title"/><xsl:comment/></h3>
      <xsl:apply-templates select="xhtml:p"/>
      <xsl:for-each select="lenya:asset">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
      <xsl:for-each select="xhtml:a">
        <a href="{@href}">
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="starts-with(@href, 'http://')">
                <xsl:text>extern</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                 <xsl:text>arrow</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:copy-of select="@target"/>
          <xsl:apply-templates/>
        </a>
      </xsl:for-each> 
    </div>
  </xsl:template>


  <xsl:template match="unizh:teaser[parent::unizh:column]" priority="1">
    <xsl:choose>
      <xsl:when test="preceding-sibling::* or ../../unizh:lead/xhtml:object or ../../unizh:lead/xhtml:p/descendant-or-self::*[text()]">
        <div class="solidlinemitmargin">
          <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="solidline">
          <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
    <div class="kleintitel">
      <xsl:value-of select="unizh:title"/>
    </div>
    <xsl:apply-templates select="unizh:title/lenya:asset-dot"/> 
    <xsl:choose>
      <xsl:when test="xhtml:object">
        <xsl:apply-templates select="xhtml:object"/>
      </xsl:when>
      <xsl:otherwise>
        <div class="dotline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  /></div>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="xhtml:p"/>
    <xsl:for-each select="lenya:asset">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    <xsl:for-each select="xhtml:a">
      <a class="arrow" href="{@href}"><xsl:value-of select="."/></a><br/>
    </xsl:for-each>
    <xsl:apply-templates select="lenya:asset-dot"/>
    <div class="dotlinemitmargin"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  /></div>
  </xsl:template>


  <xsl:template match="unizh:links" priority="1">
    <div class="links">
      <h3>
        <xsl:choose>
          <xsl:when test="unizh:title/@href">
            <xsl:choose>
              <xsl:when test="xhtml:object">
                <xsl:attribute name="class">linked</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">noimage linked</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <a href="{unizh:title/@href}">
              <xsl:attribute name="class">
                <xsl:choose>
                  <xsl:when test="starts-with(unizh:title/@href, 'http://')">
                    <xsl:text>extern</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>arrow</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:value-of select="unizh:title"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="not(xhtml:object)">
              <xsl:attribute name="class">noimage</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="unizh:title"/>
          </xsl:otherwise>
        </xsl:choose>
      </h3>
      <xsl:if test="xhtml:object">
        <xsl:apply-templates select="xhtml:object"/>
      </xsl:if>
      <xsl:apply-templates select="xhtml:p"/>
      <ul>
        <xsl:for-each select="xhtml:a">
          <li>
            <a href="{@href}">
              <xsl:attribute name="class">
                <xsl:choose>
                  <xsl:when test="starts-with(@href, 'http://')">
                    <xsl:text>extern</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>arrow</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:value-of select="."/>
            </a>
          </li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>


  <xsl:template match="unizh:contcol1[parent::unizh:homepage or parent::unizh:overview or parent::unizh:homepage4cols]">
    <div class="contcol1" bxe_xpath="/{$document-element-name}/unizh:contcol1">
      <xsl:apply-templates/><xsl:comment/>
    </div>
  </xsl:template>


  <xsl:template match="unizh:quicklinks" priority="1">
    <div id="quicklinks">
      <h3><xsl:value-of select="@label"/></h3>
      <xsl:for-each select="unizh:quicklink">
        <ul>
          <xsl:for-each select="xhtml:a">
            <li>
              <a href="{@href}"><xsl:value-of select="."/></a>
            </li>
          </xsl:for-each>
        </ul>
      </xsl:for-each>
    </div>
  </xsl:template>


  <xsl:template match="xhtml:p[parent::unizh:short]" priority="1">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="xhtml:a[parent::unizh:short]" priority="1">
    <br/>
    <a class="arrow" href="{@href}"><i18n:text>more</i18n:text></a>
  </xsl:template>

</xsl:stylesheet>
