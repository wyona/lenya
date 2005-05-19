<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: menu.xsl,v 1.8 2005/03/08 14:42:44 thomas Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="nav"
    >


<xsl:template match="nav:site">
  <div id="menu">
    <table class="menu" cellspacing="0">
      <xsl:apply-templates select="nav:node[@id = 'index']"/>
      <xsl:for-each select="nav:node[position() != last()]/nav:node">
        <xsl:call-template name="item">
          <xsl:with-param name="level">1</xsl:with-param>
        </xsl:call-template>
        <xsl:for-each select="nav:node">
          <xsl:call-template name="item">
            <xsl:with-param name="level">2</xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:for-each>
    </table>
  </div>
</xsl:template>


<xsl:template match="nav:node[@id = 'index']">
  <tr>
    <td class="menuindex">
      <a href="{@href}" class="menuitem"><xsl:value-of select="nav:label"/></a>
    </td>
  </tr>
  <tr>
    <td class="menuspacer"/>
  </tr>
</xsl:template>


<xsl:template name="item">
  <xsl:param name="level" select="2"/>
  <tr>
    <td class="menuitem{$level}"> 
      <xsl:choose>
        <xsl:when test="$level = 1">
          <a href="{@href}" class="menuitem"><xsl:value-of select="nav:label"/></a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="nav:node">
              <a href="{nav:node/@href}" class="menuitem"><xsl:apply-templates select="nav:label"/></a>	
            </xsl:when>
            <xsl:otherwise>
              <a href="{@href}" class="menuitem"><xsl:apply-templates select="nav:label"/></a>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </td>
  </tr>
  <tr>
    <td class="menuspacer"/>
  </tr>
</xsl:template>

<xsl:template match="nav:label">
  <div class="menulabel">
    <div class="left"><xsl:value-of select="substring-before (., ' ')"/></div>
    <div class="right"><xsl:value-of select="substring-after (., ' ')"/></div>
  </div>
</xsl:template>

</xsl:stylesheet> 
