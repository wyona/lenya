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

  <!-- banner is only for extended publication related contents -->
  <xsl:template match="unizh:banner">
    <div class="banner">
      <xsl:apply-templates select="xhtml:object"/>
    </div>
  </xsl:template>


  <!-- the rainbow color csd flag in the left column -->
  <xsl:template match="unizh:directlinks">
    <ul id="directlinks">
      <xsl:for-each select="xhtml:a">
        <li>
          <a href="{@href}">
            <xsl:attribute name="id">directlink<xsl:value-of select="position()"/></xsl:attribute>
            <xsl:value-of select="."/>
          </a>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>


  <!-- faculty chooser -->
  <xsl:template match="unizh:relocator">
    <form>
      <xsl:attribute name="action"><xsl:value-of select="@href"/></xsl:attribute>
      <xsl:attribute name="method">post</xsl:attribute>
      <div class="relocator">
        <h3><xsl:value-of select="@label"/></h3>
        <select name="location" onchange="selectLocation( this.options[this.selectedIndex].value )">
          <xsl:for-each select="xhtml:a">
            <option>
              <xsl:attribute name="value"><xsl:value-of select="@href"/></xsl:attribute>
              <xsl:value-of select="."/>
            </option>
          </xsl:for-each>
        </select>
        <input type="submit" id="submit" value="go!" />
      </div>
    </form>
  </xsl:template>


  <!-- second column catalog element -->
  <xsl:template match="unizh:startlinks">
    <div id="startlinks">
      <xsl:apply-templates select="xhtml:object"/>
      <ul>
        <xsl:for-each select="unizh:startlink">
          <li>
            <xsl:if test="position() = 1">
              <xsl:attribute name="id">first</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="xhtml:a"/>
            <xsl:apply-templates select="text()"/>
          </li>
        </xsl:for-each>
      </ul>
      <xsl:apply-templates select="index:child"/>
    </div>
  </xsl:template>


  <!-- emergency message in fourth column -->
  <xsl:template name="emergency">
    <xsl:comment>emergency message</xsl:comment>
    <xsl:comment>#if expr="\"$REMOTE_ADDR\" = /130.60./"</xsl:comment>
    <xsl:comment>#include virtual="/admin/notfallhinweis/emergency.txt"</xsl:comment>
    <xsl:comment>#endif</xsl:comment>
    <xsl:comment>end emergency message</xsl:comment>
  </xsl:template>


<!-- overwrite included templates -->

  <!-- public home page might have contcol1 on overview pages -->
  <xsl:template match="unizh:contcol1[parent::unizh:homepage or parent::unizh:overview or parent::unizh:homepage4cols]" priority="1">
    <div class="contcol1" bxe_xpath="/{$document-element-name}/unizh:contcol1">
      <xsl:apply-templates/><xsl:comment/>
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
