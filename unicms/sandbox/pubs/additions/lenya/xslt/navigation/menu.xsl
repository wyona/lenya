<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: menu.xsl,v 1.5 2005/02/24 15:29:24 jann Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    >
   

<xsl:template match="nav:site">
  <xhtml:div id="menu">
    <xsl:apply-templates select="nav:node"/>
  </xhtml:div>
</xsl:template>


<xsl:template match="nav:node">
 <xhtml:div>
  <xsl:copy-of select="@href"/>
  <xsl:copy-of select="@basic-url"/>
  <xsl:copy-of select="@current"/> 
  <xsl:value-of select="nav:label"/>
  <xsl:apply-templates select="nav:node[descendant-or-self::nav:node[@current = 'true'] or parent::nav:node[@current = 'true'] or ../nav:node[descendant-or-self::nav:node[@current = 'true']]]"/> 

</xhtml:div>
</xsl:template>


<xsl:template match="nav:node[@visibleinnav = 'false']"/>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet> 
