<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" 
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
>


  <xsl:template name="header">
    <div id="headerarea">
      <div class="imgunilogo">
        <a href="http://www.uzh.ch"><img src="{$imageprefix}/logo_small_{$language}.gif" alt="unizh logo" width="130" height="32" /></a>
      </div>
      <div class="imgjubilogo">
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="/document/xhtml:div[@id = 'breadcrumb']/xhtml:div[@basic-url = 'index']/@href" />
          </xsl:attribute>
          <img src="{$imageprefix}/logo_uni175.gif" alt="unizh175 logo" width="163" height="47" />
        </a>
      </div>
      <div id="servicenav">
        <xsl:apply-templates select="/document/xhtml:div[@id = 'servicenav']/xhtml:div[@id = 'search']" mode="form" />
        <div id="links">
          <xsl:apply-templates select="/document/xhtml:div[@id = 'servicenav']/xhtml:div" />
        </div>
      </div>
    </div>
    <xsl:apply-templates select="/document/xhtml:div[@id = 'tabs']" />
    <!-- titlearea -->
    <!-- simply display titlearea if the needed data is in the XML tree (project and home pages, plus children of project pages) -->
    <!-- logic is in the aggregation / transformation -->
    <xsl:if test="/document/content/*/unizh:header/*">
      <div id="titlearea">
        <xsl:apply-templates select="/document/content/*/unizh:header/@class" />
        <h1>
          <a href="{/document/content/*/unizh:header/unizh:heading/@href}">
            <xsl:value-of select="/document/content/*/unizh:header/unizh:heading" />
          </a>
        </h1>
        <xsl:if test="/document/content/*/unizh:header/unizh:superscription and normalize-space( /document/content/*/unizh:header/unizh:superscription ) != ''">
          <h2>
            <xsl:value-of select="/document/content/*/unizh:header/unizh:superscription" />
          </h2>
        </xsl:if>
      </div>
    </xsl:if>
    <!-- highlight -->
    <xsl:if test="/document/content/*/unizh:highlight">
      <div id="highlight">
        <xsl:attribute name="class">
          <xsl:value-of select="/document/content/*/unizh:highlight/@class" />
        </xsl:attribute>
        <xsl:apply-templates select="/document/content/*/unizh:highlight/xhtml:object" />
        <xsl:if test="/document/content/*/unizh:highlight/unizh:title">
          <h3>
            <a href="{/document/content/*/unizh:highlight/unizh:title/@href}">
              <xsl:value-of select="/document/content/*/unizh:highlight/unizh:title" />
            </a>
          </h3>
        </xsl:if>
        <xsl:if test="/document/content/*/unizh:highlight/xhtml:p">
          <xsl:copy-of select="/document/content/*/unizh:highlight/xhtml:p" />
        </xsl:if>
        <xsl:apply-templates select="/document/content/*/unizh:highlight/lenya:asset-dot" />
        <xsl:comment />
      </div>
    </xsl:if>
  </xsl:template>


  <xsl:template match="xhtml:object[parent::unizh:highlight]">
    <xsl:call-template name="objectImage">
      <xsl:with-param name="width" select="800" />
      <xsl:with-param name="src" select="@data" />
      <xsl:with-param name="alt" select="@title" />
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
