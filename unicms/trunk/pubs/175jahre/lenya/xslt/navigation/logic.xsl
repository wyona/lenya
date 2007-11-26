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


  <!-- doctypes specific navigation logic -->

  <xsl:param name="node-id"/>

  <xsl:variable name="isProject">
    <xsl:if test="/document/content/unizh:project">true</xsl:if>
    <xsl:if test="/document/content/unizh:project4cols">true</xsl:if>
  </xsl:variable>

  <xsl:variable name="isHomepage">
    <xsl:if test="/document/content/unizh:homepage4cols">true</xsl:if>
  </xsl:variable>

  <xsl:variable name="home-basic-url">
    <xsl:choose>
      <xsl:when test="$isHomepage = 'true' or $isProject = 'true'">
        <xsl:value-of select="/document/xhtml:div[@id = 'menu']/descendant::*[@current = 'true']/@basic-url"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/document/unizh:ancestors/descendant::unizh:ancestor[unizh:homepage4cols | unizh:project | unizh:project4cols][1]/@basic-url"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- use this like a boolean -->
  <xsl:variable name="index" select="/document/xhtml:div[@id = 'menu']/xhtml:div[@basic-url = 'index' and @current = 'true']"/>

  <xsl:variable name="home-href">
    <xsl:value-of select="/document/xhtml:div[@id = 'menu']/descendant::*[@basic-url = $home-basic-url]/@href" />
  </xsl:variable>


  <!-- hide navigation tree -->

  <xsl:template match="nav:site" />


  <!-- Menu -->

  <xsl:template match="/document/xhtml:div[@id = 'menu']"> 
      <xsl:choose>
        <!-- we are directly below the root node -->
        <xsl:when test="$home-basic-url = 'index'">
          <div id="menu">
            <xsl:apply-templates select="*/*"/>
          </div>
        </xsl:when>
        <!-- we are inside a project subpub -->
        <xsl:otherwise>
          <div id="menu">
            <xsl:apply-templates select="descendant::xhtml:div[@basic-url = $home-basic-url]/*"/>
          </div>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <xsl:template match="xhtml:div[ancestor::xhtml:div[@id = 'menu']]">
    <xsl:copy>
      <xsl:if test="descendant-or-self::*/@current = 'true'">
        <xsl:attribute name="selected"><xsl:text>true</xsl:text></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>


  <!-- Contcol1 (tabs) for contact, impressum, sitemap, search --> 

  <xsl:template match="/document/xhtml:div[@id = 'menu' and ($node-id = 'contact' or $node-id='sitemap' or $node-id = 'impressum' or $node-id = 'search')]">
    <unizh:contcol1> 
      <xsl:apply-templates select="/document/unizh:ancestors/unizh:ancestor[unizh:homepage | unizh:homepage4cols][1]/*/unizh:contcol1/unizh:quicklinks"/> 
    </unizh:contcol1>
  </xsl:template>


  <!-- servicenav -->

  <xsl:template match="/document/xhtml:div[@id = 'servicenav']/xhtml:div[@id = 'contact']">
    <div id="contact">
      <xsl:attribute name="href">
        <xsl:choose>
          <xsl:when test="$home-basic-url != 'index' and //nav:node[@basic-url = $home-basic-url]/nav:node[@id = 'contact']">
            <xsl:value-of select="//nav:node[@basic-url = $home-basic-url]/nav:node[@id = 'contact']/@href"/>
          </xsl:when> 
          <xsl:otherwise>
            <xsl:value-of select="@href"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:value-of select="."/> 
    </div>
  </xsl:template>


  <xsl:template match="/document/xhtml:div[@id = 'servicenav']/xhtml:div[@id = 'search']">
    <div id="search">
      <xsl:attribute name="href">
        <xsl:choose>
          <xsl:when test="$home-basic-url != 'index' and //nav:node[@basic-url = $home-basic-url]/nav:node[@id = 'search']">
            <xsl:value-of select="//nav:node[@basic-url = $home-basic-url]/nav:node[@id = 'search']/@href"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@href"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:value-of select="."/>
    </div>
  </xsl:template>


<!-- header -->
 
<xsl:template match="unizh:header">
  <unizh:header>
    <xsl:choose>
      <!-- publication index and project subpubs get headers -->
      <xsl:when test="$isProject = 'true' or $isHomepage = 'true'">
        <xsl:apply-templates select="@*" />
        <unizh:heading href="{$home-href}">
          <xsl:value-of select="/document/content/*/unizh:header/unizh:heading"/>
        </unizh:heading>
        <unizh:superscription>
          <xsl:value-of select="/document/content/*/unizh:header/unizh:superscription"/>
        </unizh:superscription>
      </xsl:when>
      <!-- normal pages get no header -->
      <xsl:when test="$home-basic-url = 'index'" />
      <!-- pages inside project subpubs get headers -->
      <xsl:otherwise>
        <xsl:apply-templates select="/document/unizh:ancestors/unizh:ancestor[unizh:homepage4cols | unizh:project | unizh:project4cols][1]/*/unizh:header/@*" />
        <unizh:heading href="{$home-href}">
          <xsl:value-of select="/document/unizh:ancestors/unizh:ancestor[unizh:homepage4cols | unizh:project | unizh:project4cols][1]/*/unizh:header/unizh:heading" />
        </unizh:heading>
      </xsl:otherwise>
    </xsl:choose>
  </unizh:header>
</xsl:template>


<!-- highlight -->

<xsl:template match="unizh:highlight">
  <xsl:choose>
    <xsl:when test="* or @*">
      <xsl:copy>
        <xsl:attribute name="class">
          <xsl:value-of select="@class" />
        </xsl:attribute>
        <xsl:if test="xhtml:object">
          <xhtml:object>
            <xsl:attribute name="data">
              <xsl:value-of select="concat( substring-before( /document/nav:site/@url, '.html' ), '/', xhtml:object/@data )" />
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="xhtml:object/@title" />
            </xsl:attribute>
          </xhtml:object>
        </xsl:if>
        <xsl:copy-of select="unizh:title" />
        <xsl:copy-of select="xhtml:p" />
      </xsl:copy>
    </xsl:when>
    <!-- normal pages without highlight fetch parent's highlight -->
    <xsl:when test="$home-basic-url = 'index'">
      <xsl:copy>
        <xsl:attribute name="class">
          <xsl:value-of select="/document/unizh:ancestors/unizh:ancestor[descendant::unizh:highlight][1]/*/unizh:highlight/@class" />
        </xsl:attribute>
        <xsl:if test="/document/unizh:ancestors/unizh:ancestor[descendant::unizh:highlight][1]/*/unizh:highlight/xhtml:object">
          <xhtml:object>
            <xsl:attribute name="data">
              <xsl:value-of select="concat( substring-before( /document/unizh:ancestors/unizh:ancestor[descendant::unizh:highlight][1]/@href, '.html' ), '/', /document/unizh:ancestors/unizh:ancestor[descendant::unizh:highlight][1]/*/unizh:highlight/xhtml:object/@data )" />
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="/document/unizh:ancestors/unizh:ancestor[descendant::unizh:highlight][1]/*/unizh:highlight/xhtml:object/@title" />
            </xsl:attribute>
          </xhtml:object>
        </xsl:if>
        <xsl:copy-of select="/document/unizh:ancestors/unizh:ancestor[descendant::unizh:highlight][1]/*/unizh:highlight/unizh:title" />
        <xsl:copy-of select="/document/unizh:ancestors/unizh:ancestor[descendant::unizh:highlight][1]/*/unizh:highlight/xhtml:p" />
      </xsl:copy>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<!-- breadcrumb path -->

<xsl:template match="/document/xhtml:div[@id = 'breadcrumb']">
  <div id="breadcrumb" root="{@root}" label="{@label}">
    <xsl:apply-templates select="xhtml:div[@basic-url = /document/unizh:ancestors/unizh:ancestor/@basic-url]"/>
    <xsl:if test="not($index)">
      <xsl:apply-templates select="xhtml:div[@current = 'true']"/>
    </xsl:if>

<!--
    <xsl:choose>
      <xsl:when test="$isHomepage = 'true'">
        <xsl:if test="not($index)">
          <xsl:apply-templates select="xhtml:div[@current = 'true']"/>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$home-basic-url = 'index'">
          <xsl:apply-templates select="xhtml:div[@basic-url != 'index']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="xhtml:div[starts-with(@basic-url, concat($home-basic-url, '/'))]"/>
      </xsl:otherwise>
    </xsl:choose>
-->
  </div>
</xsl:template> 


<!-- footer -->

<xsl:template match="xhtml:div[parent::xhtml:div[@id = 'footnav'] and @id = 'impressum']">
  <div id="impressum">
    <xsl:attribute name="href">
      <xsl:choose>
        <xsl:when test="$home-basic-url != 'index' and //nav:node[@basic-url = $home-basic-url]/nav:node[@id = 'impressum']">
          <xsl:value-of select="//nav:node[@basic-url = $home-basic-url]/nav:node[@id = 'impressum']/@href"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@href"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </div>
</xsl:template>


<!-- Collections. Hide children nodes in menu -->

<xsl:template match="xhtml:div[/document/content[unizh:news | unizh:collection | unizh:team] and ancestor::xhtml:div[@id = 'menu'] and parent::xhtml:div[@current = 'true']]"/>

<!-- Collection items. Hide current level in menu -->

<xsl:template match="xhtml:div[/document/unizh:ancestors/unizh:ancestor[unizh:news | unizh:collection | unizh:team] and ancestor::xhtml:div[@id = 'menu'] and (@current = 'true' or ../xhtml:div/@current = 'true')]"/>

<!-- Collection items. Select parent in Menu -->

<xsl:template match="xhtml:div[/document/unizh:ancestors/unizh:ancestor[unizh:news | unizh:collection | unizh:team] and ancestor::xhtml:div[@id = 'menu'] and xhtml:div/@current = 'true']">
  <xhtml:div current="true" href="{@href}"><xsl:value-of select="text()"/></xhtml:div>
</xsl:template> 


<!-- Collection items. Link to parent -->

<xsl:template match="xhtml:div[@id='link-to-parent']">
  <xsl:if test="/document/unizh:ancestors/unizh:ancestor[unizh:news | unizh:collection | unizh:team]">
    <xsl:copy-of select="."/>
  </xsl:if>
</xsl:template> 


<!-- Sitemap within subsite should cover subsite only -->

<xsl:template match="unizh:node">
  <xsl:variable name="subsite-home-basic-url" select="concat('/', $home-basic-url)"/>
  <xsl:choose>
    <xsl:when test="$home-basic-url = 'index'">
      <xsl:copy-of select="."/>
    </xsl:when>
    <xsl:when test="@id = $subsite-home-basic-url">
      <xsl:copy>
        <xsl:apply-templates select="@*|*[name() != 'unizh:node']"/>
      </xsl:copy>
      <xsl:apply-templates select="unizh:node"/>
    </xsl:when>
    <xsl:when test="starts-with(@id, $subsite-home-basic-url)">
      <xsl:copy-of select="."/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="unizh:node"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet> 
