<?xml version="1.0" encoding="UTF-8" ?>


<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
    xmlns:uz="http://unizh.ch"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
>


<xsl:include href="../../xslt-fallback/navigation/logic.xsl"/>


<!-- overwrite included templates -->

<xsl:variable name="tabs" priority="1"/>


<!-- menu -->

<xsl:template match="/document/xhtml:div[@id = 'menu']" priority="1"> 
  <xsl:choose>
    <xsl:when test="$homepage-basic-url = 'index'">
      <div id="menu">
        <xsl:apply-templates select="*/*/*"/>
      </div>
    </xsl:when>
    <xsl:when test="descendant::xhtml:div[@basic-url = $homepage-basic-url]/*/*">
      <div id="menu">
<!--
        <div class="home" href="{descendant::xhtml:div[@basic-url = $super-homepage-basic-url]/@href}">
          <xsl:value-of select="descendant::xhtml:div[@basic-url = $super-homepage-basic-url]/text()"/>
        </div>
-->
        <xsl:apply-templates select="descendant::xhtml:div[@basic-url = $homepage-basic-url]/*/*"/>
      </div>
    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:template>


<!-- Contcol1 (tabs) for contact, impressum, sitemap, search --> 

<xsl:template match="/document/xhtml:div[@id = 'menu' and ($node-id = 'contact' or $node-id='sitemap' or $node-id = 'impressum' or $node-id = 'search')]" priority="1">
  <unizh:contcol1> 
    <xsl:apply-templates select="/document/unizh:ancestors/unizh:ancestor[unizh:homepage | unizh:homepage4cols][1]/*/unizh:contcol1/unizh:quicklinks"/> 
  </unizh:contcol1>
</xsl:template>


<!-- tabs -->

<xsl:template match="/document/xhtml:div[@id = 'tabs']" priority="1">
  <div id="tabs">
    <xsl:choose>
      <xsl:when test="$isHomepage = 'true'">
        <xsl:choose>
          <xsl:when test="$index">
            <xsl:apply-templates/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="//xhtml:div[ancestor::xhtml:div[@id = 'menu'] and @current = 'true']/xhtml:div"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$homepage-basic-url = 'index'">
            <xsl:apply-templates/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="//xhtml:div[ancestor::xhtml:div[@id = 'menu'] and @basic-url = $homepage-basic-url]/xhtml:div">
              <div>
                <xsl:choose>
                  <xsl:when test="@current = 'true' or descendant::xhtml:div[@current = 'true']">
                    <xsl:attribute name="current">true</xsl:attribute>
                  </xsl:when>
                </xsl:choose>
                <xsl:copy-of select="@href"/>
                <xsl:copy-of select="@basic-url"/>
                <xsl:value-of select="nav:label"/>
                <xsl:apply-templates select="text()"/>
              </div> 
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise> 
    </xsl:choose>
  </div>
</xsl:template>


<!-- breadcrumb path -->

<xsl:template match="/document/xhtml:div[@id = 'breadcrumb']" priority="1">
  <div id="breadcrumb" root="{@root}" label="{@label}">
    <xsl:if test="/document/uz:unizh/uz:section/@breadcrumb = 'true'">
      <div>
        <xsl:value-of select="/document/uz:unizh/uz:section"/>
      </div>
    </xsl:if>
    <xsl:apply-templates select="xhtml:div[@basic-url = /document/unizh:ancestors/unizh:ancestor[unizh:homepage | unizh:homepage4cols]/@basic-url]"/>
    <xsl:choose>
      <xsl:when test="$isHomepage = 'true'">
        <xsl:if test="not($index)">
          <xsl:apply-templates select="xhtml:div[@current = 'true']"/>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$homepage-basic-url = 'index'">
          <xsl:apply-templates select="xhtml:div[@basic-url != 'index']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="xhtml:div[starts-with(@basic-url, concat($homepage-basic-url, '/'))]"/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template> 

</xsl:stylesheet> 
