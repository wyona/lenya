<?xml version="1.0" encoding="UTF-8"?>


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


  <xsl:template name="emergency">
    <xsl:comment>emergency message</xsl:comment>
    <xsl:comment>#if expr="\"$REMOTE_ADDR\" = /130.60./"</xsl:comment>
    <xsl:comment>#include virtual="/admin/notfallhinweis/emergency.txt"</xsl:comment>
    <xsl:comment>#endif</xsl:comment>
    <xsl:comment>end emergency message</xsl:comment>
  </xsl:template>


<!-- overwrite included templates -->

  <xsl:template match="unizh:teaser" priority="1">
    <div>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="@highlight and @highlight = 'true'">
            <xsl:text>teaser highlighted</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>teaser</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="xhtml:object">
        <xsl:apply-templates select="xhtml:object"/>
      </xsl:if>
      <h3><xsl:value-of select="unizh:title"/><xsl:comment/></h3>
      <xsl:apply-templates select="xhtml:p"/>
      <xsl:apply-templates select="lenya:asset"/>
      <xsl:apply-templates select="xhtml:a"/>
    </div>
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
                  <xsl:when test="starts-with(unizh:title/@href, 'http://') and not(contains(unizh:title/@href, '.unizh.ch')) and not(contains(unizh:title/@href, '.uzh.ch'))">
                    <xsl:text>www</xsl:text>
                  </xsl:when>
                  <xsl:when test="starts-with(unizh:title/@href, 'http://') and ((contains(unizh:title/@href, '.unizh.ch') ) or (contains(unizh:title/@href, '.uzh.ch')))">
                    <xsl:text>uzh</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>internal</xsl:text>
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
            <xsl:apply-templates select="."/>
          </li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>


  <xsl:template match="unizh:contcol1[parent::unizh:homepage or parent::unizh:overview or parent::unizh:homepage4cols]" priority="1">
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
    <a class="internal" href="{@href}"><i18n:text>more</i18n:text></a>
  </xsl:template>

</xsl:stylesheet>
