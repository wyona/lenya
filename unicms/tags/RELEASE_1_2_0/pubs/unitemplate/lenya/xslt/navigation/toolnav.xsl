<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: menu.xsl,v 1.5 2005/02/24 15:29:24 jann Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    >

<xsl:param name="root"/>   
<xsl:param name="url"/>
<xsl:param name="chosenlanguage"/>
<xsl:param name="defaultlanguage"/>

<xsl:variable name="suffix">
  <xsl:choose>
    <xsl:when test="$chosenlanguage = $defaultlanguage">
      <xsl:text>.html</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('_', $chosenlanguage, '.html')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:template match="nav:site">
  <div id="toolnav">
    <xsl:apply-templates select="descendant::nav:node[@current = 'true']"/>
    <div id="print" href="{concat(descendant::nav:node[@current = 'true']/@id, '_', $chosenlanguage, '.print.html')}">
      <xsl:choose>
        <xsl:when test="$chosenlanguage = 'en'">Print this page</xsl:when>
        <xsl:otherwise>Diese Seite drucken</xsl:otherwise>
      </xsl:choose>
    </div>
    <div id="fontsize">
      <xsl:choose>
        <xsl:when test="$chosenlanguage = 'en'">Change font size</xsl:when>
        <xsl:otherwise>Schrift gr&#246;sser/kleiner</xsl:otherwise>
      </xsl:choose>
    </div>
    <div id="simpleview">
      <xsl:attribute name="href">
        <xsl:choose>
          <xsl:when test="not(contains ($root, 'authoring'))">
            <xsl:text>?version=simple</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>#</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="$chosenlanguage = 'en'">PDA view</xsl:when>
        <xsl:otherwise>PDA-optimierte Ansicht</xsl:otherwise>
      </xsl:choose>
    </div>
  </div>
</xsl:template>


<xsl:template match="nav:node">
  <xsl:call-template name="split-languages">
    <xsl:with-param name="languages">
      <xsl:value-of select="@other-languages"/>
    </xsl:with-param>
  </xsl:call-template> 
</xsl:template>


<xsl:template name="split-languages">
  <xsl:param name="languages"/>
  <xsl:choose>
    <xsl:when test="contains($languages, ',')">
      <div class="language">
        <xsl:attribute name="href">
          <xsl:choose>
            <xsl:when test="substring-before($languages, ',') = $defaultlanguage">
              <xsl:value-of select="concat($root, substring-before($url, $suffix), '.html')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($root, substring-before($url, $suffix), '_', substring-before($languages, ','), '.html')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="substring-before($languages, ',')"/>
      </div>
      <xsl:call-template name="split-languages">
        <xsl:with-param name="languages">
          <xsl:value-of select="substring-after($languages, ',')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$languages != ''">
      <div class="language">
        <xsl:attribute name="href">
          <xsl:choose>
            <xsl:when test="normalize-space($languages) = $defaultlanguage">
              <xsl:value-of select="concat($root, substring-before($url, $suffix), '.html')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($root, substring-before($url, $suffix), '_', normalize-space($languages), '.html')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="normalize-space($languages)"/>
      </div>
    </xsl:when>
  </xsl:choose>
</xsl:template> 

</xsl:stylesheet>

