<?xml version="1.0" encoding="UTF-8" ?>


<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
>


<xsl:param name="imgdir"/>
<xsl:param name="cssdir"/>
<xsl:param name="jsdir"/>
<xsl:param name="assetdir"/>

<xsl:template match="@href[parent::xhtml:link[@type = 'text/css']]">
  <xsl:attribute name="href">
    <xsl:value-of select="concat($cssdir, '/')"/>
    <xsl:call-template name="substring-after-last">
      <xsl:with-param name="input"><xsl:value-of select="."/></xsl:with-param>
      <xsl:with-param name="substr">/</xsl:with-param>
    </xsl:call-template>
  </xsl:attribute>
</xsl:template>

<xsl:template match="@src[parent::xhtml:script]">
  <xsl:attribute name="src">
    <xsl:value-of select="concat($jsdir, '/')"/>
    <xsl:call-template name="substring-after-last">
      <xsl:with-param name="input"><xsl:value-of select="."/></xsl:with-param>
      <xsl:with-param name="substr">/</xsl:with-param>
    </xsl:call-template>
  </xsl:attribute>
</xsl:template>


<xsl:template match="@src[parent::xhtml:img]">
  <xsl:attribute name="src">
    <xsl:value-of select="concat($imgdir, '/')"/>
    <xsl:call-template name="substring-after-last">
      <xsl:with-param name="input"><xsl:value-of select="."/></xsl:with-param>
      <xsl:with-param name="substr">/</xsl:with-param>
    </xsl:call-template>
  </xsl:attribute>
</xsl:template>

<xsl:template match="@href[parent::xhtml:a]">
  <xsl:attribute name="href">
    <xsl:call-template name="substring-after-last">
      <xsl:with-param name="input"><xsl:value-of select="."/></xsl:with-param>
      <xsl:with-param name="substr">/</xsl:with-param>
    </xsl:call-template>
  </xsl:attribute>
</xsl:template>



<xsl:template match="@src[parent::xhtml:embed]">
  <xsl:attribute name="src">
    <xsl:value-of select="concat($assetdir, '/')"/>
    <xsl:call-template name="substring-after-last">
      <xsl:with-param name="input"><xsl:value-of select="."/></xsl:with-param>
      <xsl:with-param name="substr">/</xsl:with-param>
    </xsl:call-template>
  </xsl:attribute>
</xsl:template>


<xsl:template match="@value[parent::xhtml:param[@name='movie' and parent::xhtml:object]]">
  <xsl:attribute name="value">
    <xsl:value-of select="concat($assetdir, '/')"/>
    <xsl:call-template name="substring-after-last">
      <xsl:with-param name="input"><xsl:value-of select="."/></xsl:with-param>
      <xsl:with-param name="substr">/</xsl:with-param>
    </xsl:call-template>
  </xsl:attribute>
</xsl:template>


<xsl:template name="substring-after-last">
  <xsl:param name="input" />
  <xsl:param name="substr" />
  <xsl:variable name="temp" select="substring-after($input,$substr)"/>
  <xsl:choose>
    <xsl:when test="$substr and contains($temp,$substr)">
      <xsl:call-template name="substring-after-last">
        <xsl:with-param name="input"  select="$temp" />
        <xsl:with-param name="substr" select="$substr" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$temp" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet> 
