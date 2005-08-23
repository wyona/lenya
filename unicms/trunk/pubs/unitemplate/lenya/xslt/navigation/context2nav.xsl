<?xml version="1.0" encoding="UTF-8" ?>


<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
    xmlns:uz="http://unizh.ch"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
    >


<xsl:variable name="tabs" select="/document/uz:unizh/uz:publication/@tabs"/>
<xsl:variable name="isSubhome" select="/document/content/unizh:subhomepage"/>
<xsl:variable name="hasSubhome" select="/document/unizh:ancestors/unizh:ancestor/unizh:subhomepage"/>

<xsl:variable name="subhomeTabs">
  <xsl:choose>
    <xsl:when test="$isSubhome"><xsl:value-of select="/document/content/unizh:subhomepage/@unizh:tabs"/>
    </xsl:when>
    <xsl:otherwise><xsl:value-of select="/document/unizh:ancestors/unizh:ancestor/unizh:subhomepage/@unizh:tabs"/></xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!-- header: subhomepage title -->

<xsl:template match="unizh:header/unizh:title">
  <unizh:title>
    <xsl:choose>
      <xsl:when test="$isSubhome and not($subhomeTabs = 'root')">
        <xsl:value-of select="/document/content/unizh:subhomepage/lenya:meta/dc:title"/>
      </xsl:when>
      <xsl:when test="$hasSubhome and not($subhomeTabs = 'root')">
        <xsl:attribute name="href">
          <xsl:value-of select="/document/unizh:ancestors/unizh:ancestor/@href"/>
        </xsl:attribute>
        <xsl:value-of select="/document/unizh:ancestors/unizh:ancestor/unizh:subhomepage/lenya:meta/dc:title"/> 
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </unizh:title>
</xsl:template>

<!-- menu: root node -->

<xsl:template match="xhtml:div[@id = 'menu']">
  <xhtml:div id="menu">
    <xsl:choose>
      <xsl:when test="$isSubhome or $hasSubhome">
        <xsl:choose>
          <xsl:when test="$subhomeTabs = 'true'">
            <xsl:choose>
              <xsl:when test="$isSubhome"></xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="descendant::xhtml:div[@basic-url=/document/unizh:ancestors/unizh:ancestor[unizh:subhomepage]/@basic-url]/xhtml:div[descendant-or-self::xhtml:div[@current = 'true']]/xhtml:div"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$subhomeTabs = 'root'">
            <xsl:choose>
              <xsl:when test="$isSubhome">
                <xsl:apply-templates select="descendant::xhtml:div[@current = 'true']"/> 
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="descendant::xhtml:div[@basic-url=/document/unizh:ancestors/unizh:ancestor[unizh:subhomepage]/@basic-url]"/> 
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$subhomeTabs = 'false'">
            <xsl:choose>
              <xsl:when test="$isSubhome">
                  <xsl:apply-templates select="descendant::xhtml:div[@current = 'true']/xhtml:div"/> 
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="descendant::xhtml:div[@basic-url=/document/unizh:ancestors/unizh:ancestor[unizh:subhomepage]/@basic-url]/xhtml:div"/>
              </xsl:otherwise>
             </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$tabs = 'true'">
            <xsl:apply-templates select="xhtml:div[descendant-or-self::xhtml:div[@current = 'true']]/xhtml:div"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>        
  </xhtml:div> 
</xsl:template>

<!-- tabs -->

<xsl:template match="xhtml:div[@id = 'tabs']">
  <xsl:if test="$tabs = 'true'">
    <xhtml:div id="tabs">
      <xsl:choose>
        <xsl:when test="$isSubhome or $hasSubhome">
          <xsl:choose>
            <xsl:when test="$subhomeTabs = 'true'">
              <xsl:choose>
                <xsl:when  test="$isSubhome">
                  <xsl:apply-templates select="//xhtml:div[ancestor::xhtml:div[@id = 'menu'] and @current = 'true']/xhtml:div"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="//xhtml:div[ancestor::xhtml:div[@id = 'menu'] and @basic-url=/document/unizh:ancestors/unizh:ancestor[unizh:subhomepage]/@basic-url]/xhtml:div"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="$subhomeTabs = 'root'">
               <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/> 
        </xsl:otherwise>
      </xsl:choose>
    </xhtml:div>
  </xsl:if> 
</xsl:template>

<!-- breadcrumb path -->

<xsl:template match="xhtml:div[@id = 'breadcrumb']">
  <xhtml:div id="breadcrumb">
    <xsl:for-each select="xhtml:div">
      <xsl:choose>
        <xsl:when test="following-sibling::xhtml:div[@basic-url = /document/unizh:ancestors/unizh:ancestor[unizh:subhomepage]/@basic-url]">
        </xsl:when>
        <xsl:when test="$isSubhome">
          <xsl:apply-templates select="self::xhtml:div[@current = 'true']"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xhtml:div>
</xsl:template> 

<!-- Doctype News. Hide children nodes in menu -->

<xsl:template match="xhtml:div[/document/content/unizh:news and ancestor::xhtml:div[@id = 'menu'] and parent::xhtml:div[@current = 'true']]"/>

<!-- Doctype Newsitem. Hide current level in menu -->

<xsl:template match="xhtml:div[/document/content/unizh:newsitem and ancestor::xhtml:div[@id = 'menu'] and (@current = 'true' or ../xhtml:div/@current = 'true')]"/>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet> 
