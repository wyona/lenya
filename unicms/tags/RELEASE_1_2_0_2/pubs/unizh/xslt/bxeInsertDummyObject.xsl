<?xml version="1.0" encoding="UTF-8" ?>


<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
>


<xsl:template match="unizh:teaser">
  <xsl:copy>
    <xsl:copy-of select="@name"/>
    <xsl:copy-of select="@link"/>
    <xsl:if test="not(xhtml:object)">
      <xhtml:object id="dummy"/>
    </xsl:if>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="unizh:short">
  <xsl:copy>
    <xsl:if test="not(xhtml:object)">
      <xhtml:object id="dummy"/>
    </xsl:if>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>



<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet> 
