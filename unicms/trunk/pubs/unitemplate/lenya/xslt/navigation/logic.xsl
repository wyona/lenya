<?xml version="1.0" encoding="UTF-8" ?>


<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
    xmlns:uz="http://unizh.ch"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    >

<!-- doctype specific navigation logic -->

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


<xsl:variable name="homepage-basic-url" select="/document/unizh:ancestors/unizh:ancestor[unizh:homepage | unizh:homepage4cols][1]/@basic-url">
</xsl:variable>


<xsl:variable name="index" select="/document/xhtml:div[@id = 'menu']/xhtml:div[@basic-url = 'index' and @current = 'true']"/>


<xsl:template match="xhtml:div[@id = 'menu']"> 
  <xsl:choose>
    <xsl:when test="$isHomepage = 'true'">
      <xsl:if test="$tabs = 'false'">
        <xhtml:div id="menu">
          <xsl:choose>
            <xsl:when test="$index">
              <xsl:apply-templates select="xhtml:div[@basic-url != 'index']"/> 
            </xsl:when>
            <xsl:otherwise>
              <xhtml:div class="home" href="{xhtml:div[@basic-url = 'index']/@href}">
                <xsl:value-of select="xhtml:div[@basic-url = 'index']/text()"/>
              </xhtml:div><xsl:if test="descendant::xhtml:div[@current = 'true']/xhtml:div">asf</xsl:if>
              <xsl:apply-templates select="descendant::xhtml:div[@current = 'true']/xhtml:div"/>
            </xsl:otherwise>
          </xsl:choose>
        </xhtml:div>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xhtml:div id="menu">
        <xsl:choose>
          <xsl:when test="$tabs = 'true'">
            <xsl:choose>
              <xsl:when test="$homepage-basic-url = 'index'">
                <xsl:apply-templates select="xhtml:div[descendant-or-self::xhtml:div[@current = 'true']]/xhtml:div"/> 
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="descendant::xhtml:div[@basic-url = $homepage-basic-url]/xhtml:div[descendant-or-self::xhtml:div[@current = 'true']]/xhtml:div"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$homepage-basic-url = 'index'">
                <xsl:apply-templates select="xhtml:div[not(@basic-url = 'index')]"/>
              </xsl:when>
              <xsl:otherwise>
                <xhtml:div class="home" href="{descendant::xhtml:div[@basic-url = 'index']/@href}">
                  <xsl:value-of select="descendant::xhtml:div[@basic-url = 'index']/text()"/>
                </xhtml:div>
                <xsl:apply-templates select="descendant::xhtml:div[@basic-url = $homepage-basic-url]/xhtml:div"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xhtml:div>
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
    <xhtml:div id="tabs">
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
              <xsl:apply-templates select="//xhtml:div[ancestor::xhtml:div[@id = 'menu'] and @basic-url = $homepage-basic-url]/xhtml:div"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise> 
      </xsl:choose>
    </xhtml:div>
  </xsl:if>
</xsl:template>


<!-- servicenav -->

<xsl:template match="xhtml:div[parent::xhtml:div[@id = 'servicenav'] and @id = 'home']">
  <xhtml:div id="home">
    <xsl:attribute name="href">
      <xsl:choose>
        <xsl:when test="$isHomepage = 'true'">
          <xsl:value-of select="//xhtml:div[ancestor::xhtml:div[@id = 'menu'] and @current = 'true']/@href"/>
        </xsl:when>
        <xsl:when test="$homepage-basic-url != 'index'">
          <xsl:value-of select="//xhtml:div[ancestor::xhtml:div[@id = 'menu'] and @basic-url = $homepage-basic-url]/@href"/> 
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@href"/>
        </xsl:otherwise> 
      </xsl:choose>
    </xsl:attribute> 
    <xsl:value-of select="."/> 
  </xhtml:div>
</xsl:template>


<xsl:template match="xhtml:div[parent::xhtml:div[@id = 'servicenav'] and @id = 'contact']">
  <xhtml:div id="contact">
    <xsl:attribute name="href">
      <xsl:choose>
        <xsl:when test="$isHomepage = 'true' and not($index)">
          <xsl:choose>
            <xsl:when test="//xhtml:div[ancestor::xhtml:div[@id = 'menu'] and @current = 'true']/xhtml:div[contains(@basic-url , 'contact')]">
              <xsl:value-of select="//xhtml:div[ancestor::xhtml:div[@id = 'menu'] and @current = 'true']/xhtml:div[contains(@basic-url, 'contact')]/@href"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@href"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$homepage-basic-url != 'index'">
          <xsl:choose>
            <xsl:when test="//xhtml:div[ancestor::xhtml:div[@id = 'menu'] and @basic-url = $homepage-basic-url]/xhtml:div[contains(@basic-url, 'contact')]">
              <xsl:value-of select="//xhtml:div[ancestor::xhtml:div[@id = 'menu'] and @basic-url = $homepage-basic-url]/xhtml:div[contains(@basic-url, 'contact')]/@href"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@href"/>
            </xsl:otherwise>
          </xsl:choose> 
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@href"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:value-of select="."/> 
  </xhtml:div>
</xsl:template>


<xsl:template match="xhtml:div[parent::xhtml:div[@id = 'servicenav'] and @id = 'sitemap']">
  <xhtml:div id="sitemap">
    <xsl:attribute name="href">
      <xsl:choose>
        <xsl:when test="$isHomepage = 'true' and not($index)">
          <xsl:choose>
            <xsl:when test="//xhtml:div[ancestor::xhtml:div[@id = 'menu'] and @current = 'true']/xhtml:div[contains(@basic-url , 'sitemap')]">
              <xsl:value-of select="//xhtml:div[ancestor::xhtml:div[@id = 'menu'] and @current = 'true']/xhtml:div[contains(@basic-url, 'sitemap')]/@href"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@href"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$homepage-basic-url != 'index'">
          <xsl:choose>
            <xsl:when test="//xhtml:div[ancestor::xhtml:div[@id = 'menu'] and @basic-url = $homepage-basic-url]/xhtml:div[contains(@basic-url, 'sitemap')]">
              <xsl:value-of select="//xhtml:div[ancestor::xhtml:div[@id = 'menu'] and @basic-url = $homepage-basic-url]/xhtml:div[contains(@basic-url, 'sitemap')]/@href"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@href"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@href"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:value-of select="."/> 
  </xhtml:div>
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
    <xsl:apply-templates select="xhtml:div[@basic-url = 'index']"/>
    <xsl:choose>
      <xsl:when test="$isHomepage = 'true'">
        <xsl:apply-templates select="xhtml:div[not(@basic-url = 'index' or following-sibling::xhtml:div[@current = 'true'])]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="xhtml:div[not(@basic-url = 'index' or following-sibling::xhtml:div[@basic-url = $homepage-basic-url])]"/>
      </xsl:otherwise>
    </xsl:choose>
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

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet> 
