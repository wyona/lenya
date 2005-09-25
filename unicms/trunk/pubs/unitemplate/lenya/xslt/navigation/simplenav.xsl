<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: menu.xsl,v 1.5 2005/02/24 15:29:24 jann Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="nav"
    >
   
<xsl:import href="node_attrs.xsl"/> 
    

<xsl:template match="nav:site">
  <xhtml:div id="simplenav">
    <xsl:apply-templates select="nav:node"/>
  </xhtml:div>
</xsl:template>


<xsl:template match="nav:node[@current = 'true']">
  <xsl:if test="parent::nav:node">
    <xhtml:div id="up" href="{parent::nav:node/@href}" label="UP ONE LEVEL"/>
  </xsl:if>
  <xsl:if test="preceding-sibling::nav:node[@basic-url = 'index']">
    <xhtml:div id="up" href="{preceding-sibling::nav:node[@id = 'index']/@href}" label ="UP ONE LEVEL"/>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="@basic-url = 'index'">
      <xsl:for-each select="following-sibling::nav:node[not(@visibleinnav = 'false')]">
        <xhtml:div href="{@href}" label="{nav:label}"/>
      </xsl:for-each> 
    </xsl:when>
    <xsl:otherwise>
      <xsl:for-each select="nav:node[not(@visibleinnav = 'false')]">
        <xhtml:div href="{@href}" label="{nav:label}"/>
      </xsl:for-each>
    </xsl:otherwise> 
  </xsl:choose>
</xsl:template>


<xsl:template match="nav:node">
  <xsl:apply-templates select="nav:node"/>
</xsl:template> 


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet> 
