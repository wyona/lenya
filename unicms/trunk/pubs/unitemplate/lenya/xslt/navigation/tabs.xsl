<?xml version="1.0" encoding="UTF-8" ?>


<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
>


<xsl:template match="nav:site">
  <div id="tabs">
    <xsl:apply-templates select="nav:node[position() &gt; 1]"/>
  </div>
</xsl:template>


<xsl:template match="nav:node">
  <div>
    <xsl:if test="@current = 'true' or descendant::nav:node[@current = 'true']">
      <xsl:attribute name="current">true</xsl:attribute>
    </xsl:if>
    <xsl:copy-of select="@href"/>
    <xsl:copy-of select="@basic-url"/>
    <xsl:value-of select="nav:label"/>
  </div>
</xsl:template>




<xsl:template match="nav:node[@visibleinnav = 'false']"/>


</xsl:stylesheet> 
