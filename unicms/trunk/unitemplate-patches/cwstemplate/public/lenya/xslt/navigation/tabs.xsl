<?xml version="1.0" encoding="UTF-8" ?>
<!-- $Id: menu.xsl,v 1.5 2005/02/24 15:29:24 jann Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
>


<xsl:include href="../../xslt-fallback/navigation/tabs.xsl"/>


<!-- define new templates -->

<xsl:template match="/*/nav:node[@visibleinnav = 'true']">
  <div>
    <xsl:if test="@current = 'true' or descendant::nav:node[@current = 'true']">
      <xsl:attribute name="current">true</xsl:attribute>
    </xsl:if>
    <xsl:copy-of select="@href"/>
    <xsl:copy-of select="@basic-url"/>
    <xsl:value-of select="nav:label"/>
  </div>
</xsl:template>

</xsl:stylesheet> 
