<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: menu.xsl,v 1.5 2005/02/24 15:29:24 jann Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="nav"
    >
   
<xsl:param name="url"/>
<xsl:param name="chosenlanguage"/>
<xsl:param name="defaultlanguage"/>
<xsl:param name="root"/>

<xsl:template match="nav:site">
  <div id="toolnav">
    <xsl:apply-templates select="descendant::nav:node[@current = 'true']"/>
    <div id="print" href="{concat(substring-before($url, '.html'), '.print.html')}">
      Print
    </div>
  </div>
</xsl:template>


<xsl:template match="nav:node">
  <xsl:if test="@alternative-languages = 'en'">
    <div id="language">
      <xsl:attribute name="href">
        <xsl:choose>
          <xsl:when test="contains($url, '_')">
            <xsl:value-of select="concat(substring-before($url, '_'), '_en.html')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat(substring-before($url, '.html'), '_en.html')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
       EN
    </div>
  </xsl:if> 
  <xsl:if test="@alternative-languages = 'de'">
    <div id="language"> 
      <xsl:attribute name="href">
        <xsl:choose>
          <xsl:when test="contains($url, '_')">
            <xsl:value-of select="concat(substring-before($url, '_'), '_de.html')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat(substring-before($url, '.html'), '_de.html')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
       DE
    </div>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>

