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


<xsl:variable name="isHomepage">
  <xsl:if test="/document/content/unizh:homepage">true</xsl:if>
  <xsl:if test="/document/content/unizh:homepage4cols">true</xsl:if>
</xsl:variable>

<xsl:variable name="tabs">
  <xsl:choose>
    <xsl:when test="$isHomepage = 'true'">
      <xsl:value-of select="/document/content/*/@unizh:tabs"/> 
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="/document/unizh:ancestors/unizh:ancestor[unizh:homepage | unizh:homepage4cols]/*/@unizh:tabs"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:variable name="homepage-basic-url" select="/document/unizh:ancestors/unizh:ancestor[unizh:homepage | unizh:homepage4cols][1]/@basic-url"/>
<xsl:variable name="super-homepage-basic-url" select="/document/unizh:ancestors/unizh:ancestor[unizh:homepage | unizh:homepage4cols][2]/@basic-url"/>

<xsl:variable name="index" select="/document/xhtml:div[@id = 'menu']/xhtml:div[@basic-url = 'index' and @current = 'true']"/>


<!-- hide navigation tree -->

<xsl:template match="nav:site"/>


<!-- Menu -->

<xsl:template match="xhtml:div[@id = 'menu']"> 
  <xsl:choose>
    <xsl:when test="$isHomepage = 'true'">

      <xsl:if test="$tabs = 'false'">
        <div id="menu">
          <xsl:choose>
            <xsl:when test="$index">
              <xsl:apply-templates select="xhtml:div[@basic-url != 'index']"/> 
            </xsl:when>
            <xsl:otherwise>
              <div class="home" href="{descendant::xhtml:div[@basic-url = $homepage-basic-url]/@href}">
                <xsl:value-of select="descendant::xhtml:div[@basic-url = $homepage-basic-url]/text()"/>
              </div>
              <xsl:apply-templates select="descendant::xhtml:div[@current = 'true']/xhtml:div"/>
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </xsl:if>
<!--
      <xsl:if test="($tabs = 'true') and not($index)">
        <div id="menu">
          <div class="home" href="{descendant::xhtml:div[@basic-url = $homepage-basic-url]/@href}">
            <xsl:value-of select="descendant::xhtml:div[@basic-url = $homepage-basic-url]/text()"/>
          </div>
        </div>
      </xsl:if>
-->
    </xsl:when>
    <xsl:otherwise>   <!-- $isHomepage != 'true' -->

      <xsl:choose>
        <xsl:when test="$tabs = 'true'">

          <xsl:choose>
            <xsl:when test="$homepage-basic-url = 'index'">
              <div id="menu">
                <xsl:apply-templates select="*/*"/>
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

        </xsl:when>
        <xsl:otherwise>

          <div id="menu">
            <xsl:choose>
              <xsl:when test="$homepage-basic-url = 'index'">
                <xsl:apply-templates select="xhtml:div[@basic-url != 'index']"/>
              </xsl:when>
              <xsl:otherwise>
                <div class="home" href="{descendant::xhtml:div[@basic-url = $super-homepage-basic-url]/@href}">
                  <xsl:value-of select="descendant::xhtml:div[@basic-url = $super-homepage-basic-url]/text()"/>
                </div>
                <xsl:apply-templates select="descendant::xhtml:div[@basic-url = $homepage-basic-url]/xhtml:div"/>
              </xsl:otherwise>
            </xsl:choose>
          </div>

        </xsl:otherwise>
      </xsl:choose>

    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Contcol1 (tabs) for contact, impressum, sitemap, search --> 

<xsl:template match="xhtml:div[@id = 'menu' and $tabs = 'true' and ($node-id = 'contact' or $node-id='sitemap' or $node-id = 'impressum' or $node-id = 'search')]">
  <unizh:contcol1> 
    <xsl:apply-templates select="/document/unizh:ancestors/unizh:ancestor[unizh:homepage | unizh:homepage4cols][1]/*/unizh:contcol1/unizh:quicklinks"/> 
  </unizh:contcol1>
</xsl:template>


<!-- tabs -->

<xsl:template match="xhtml:div[@id = 'tabs']">
  <xsl:if test="$tabs = 'true'">
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
  </xsl:if>
</xsl:template>


<!-- servicenav -->

<xsl:template match="xhtml:div[parent::xhtml:div[@id = 'servicenav'] and @id = 'home']">
  <div id="home">
    <xsl:attribute name="href">
      <xsl:choose>
        <xsl:when test="$isHomepage = 'true' and not($index)">
          <xsl:value-of select="//nav:node[@current = 'true']/@href"/>
        </xsl:when>
        <xsl:when test="$homepage-basic-url != 'index'">
          <xsl:value-of select="//nav:node[@basic-url = $homepage-basic-url]/@href"/> 
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@href"/>
        </xsl:otherwise> 
      </xsl:choose>
    </xsl:attribute> 
    <xsl:value-of select="."/> 
  </div>
</xsl:template>


<xsl:template match="xhtml:div[parent::xhtml:div[@id = 'servicenav'] and @id = 'contact']">
  <div id="contact">
    <xsl:attribute name="href">
      <xsl:choose>
        <xsl:when test="$isHomepage = 'true' and not($index) and //nav:node[@current = 'true']/nav:node[@id = 'contact']">
          <xsl:value-of select="//nav:node[@current = 'true']/nav:node[@id = 'contact']/@href"/>  
        </xsl:when>
        <xsl:when test="$homepage-basic-url != 'index' and //nav:node[@basic-url = $homepage-basic-url]/nav:node[@id = 'contact']">
          <xsl:value-of select="//nav:node[@basic-url = $homepage-basic-url]/nav:node[@id = 'contact']/@href"/>
        </xsl:when> 
        <xsl:otherwise>
          <xsl:value-of select="@href"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:value-of select="."/> 
  </div>
</xsl:template>


<xsl:template match="xhtml:div[parent::xhtml:div[@id = 'servicenav'] and @id = 'sitemap']">
  <div id="sitemap">
    <xsl:attribute name="href">
      <xsl:choose>
        <xsl:when test="$isHomepage = 'true' and not($index) and //nav:node[@current = 'true']/nav:node[@id = 'sitemap']">
          <xsl:value-of select="//nav:node[@current = 'true']/nav:node[@id = 'sitemap']/@href"/>
        </xsl:when>
        <xsl:when test="$homepage-basic-url != 'index' and //nav:node[@basic-url = $homepage-basic-url]/nav:node[@id = 'sitemap']">
          <xsl:value-of select="//nav:node[@basic-url = $homepage-basic-url]/nav:node[@id = 'sitemap']/@href"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@href"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </div>
</xsl:template>


<xsl:template match="xhtml:div[parent::xhtml:div[@id = 'servicenav'] and @id = 'search']">
  <div id="search">
    <xsl:attribute name="href">
      <xsl:choose>
        <xsl:when test="$isHomepage = 'true' and not($index) and //nav:node[@current = 'true']/nav:node[@id = 'search']">
          <xsl:value-of select="//nav:node[@current = 'true']/nav:node[@id = 'search']/@href"/>
        </xsl:when>
        <xsl:when test="$homepage-basic-url != 'index' and //nav:node[@basic-url = $homepage-basic-url]/nav:node[@id = 'search']">
          <xsl:value-of select="//nav:node[@basic-url = $homepage-basic-url]/nav:node[@id = 'search']/@href"/>
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
      <xsl:when test="$isHomepage = 'true'">
        <unizh:superscription>
          <xsl:value-of select="/document/content/*/unizh:header/unizh:superscription"/>
        </unizh:superscription>
        <unizh:heading href="#">
          <xsl:value-of select="/document/content/*/unizh:header/unizh:heading"/>
        </unizh:heading>
      </xsl:when>
      <xsl:otherwise>
        <unizh:superscription>
          <xsl:value-of select="/document/unizh:ancestors/unizh:ancestor[unizh:homepage | unizh:homepage4cols][1]/*/unizh:header/unizh:superscription"/>
        </unizh:superscription>
        <unizh:heading>
          <xsl:value-of select="/document/unizh:ancestors/unizh:ancestor[unizh:homepage | unizh:homepage4cols][1]/*/unizh:header/unizh:heading"/>              
        </unizh:heading>
      </xsl:otherwise>
    </xsl:choose>
  </unizh:header>
</xsl:template>


<!-- breadcrumb path -->


<xsl:template match="xhtml:div[@id = 'breadcrumb']">
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


<!-- footer -->

<xsl:template match="xhtml:div[parent::xhtml:div[@id = 'footnav'] and @id = 'impressum']">
  <div id="impressum">
    <xsl:attribute name="href">
      <xsl:choose>
        <xsl:when test="$isHomepage = 'true' and not($index) and //nav:node[@current = 'true']/nav:node[@id = 'impressum']">
          <xsl:value-of select="//nav:node[@current = 'true']/nav:node[@id = 'impressum']/@href"/>
        </xsl:when>
        <xsl:when test="$homepage-basic-url != 'index' and //nav:node[@basic-url = $homepage-basic-url]/nav:node[@id = 'impressum']">
          <xsl:value-of select="//nav:node[@basic-url = $homepage-basic-url]/nav:node[@id = 'impressum']/@href"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@href"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </div>
</xsl:template>


<!-- Show/Hide Contcol1 -->

<xsl:template match="unizh:contcol1[$tabs = 'false']"/>

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
  <xsl:variable name="subsite-homepage-basic-url" select="concat('/', $homepage-basic-url)"/>
  <xsl:choose>
    <xsl:when test="$homepage-basic-url = 'index'">
      <xsl:copy-of select="."/>
    </xsl:when>
    <xsl:when test="@id = $subsite-homepage-basic-url">
      <xsl:copy>
        <xsl:apply-templates select="@*|*[name() != 'unizh:node']"/>
      </xsl:copy>
      <xsl:apply-templates select="unizh:node"/>
    </xsl:when>
    <xsl:when test="starts-with(@id, $subsite-homepage-basic-url)">
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
