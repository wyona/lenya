<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: toc.xsl,v 1.1 2005/02/01 20:57:32 thomas Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="nav"
    >


<xsl:template match="nav:site">
  <div id="toc">
      <xsl:for-each select="nav:node[position() != last()]/nav:node/nav:node">
        <xsl:call-template name="item"/>
      </xsl:for-each>
  </div>
</xsl:template>


<xsl:template name="item">
  <xsl:choose>
    <xsl:when test="nav:node">
      <h3><a href="{nav:node/@href}" class="menuitem"><xsl:apply-templates select="nav:label"/></a></h3>
      <xsl:for-each select="nav:node">
        <a href="{@href}"><xsl:apply-templates select="nav:label"/></a><br/>
      </xsl:for-each>	
    </xsl:when>
    <xsl:otherwise>
      <h3><a href="{@href}" class="menuitem"><xsl:apply-templates select="nav:label"/></a></h3>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="nav:label">
    <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet> 
