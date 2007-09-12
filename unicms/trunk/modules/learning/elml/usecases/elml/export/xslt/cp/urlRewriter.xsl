<?xml version="1.0" encoding="UTF-8" ?>


<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
>


<xsl:param name="imgdir">images</xsl:param>
<xsl:param name="cssdir">css</xsl:param>
<xsl:param name="jsdir">js</xsl:param>
<xsl:param name="assetdir">resources</xsl:param>


<xsl:template match="@href[parent::xhtml:a]">

  <xsl:variable name="section">
    <xsl:if test="contains(., 'lesson.section')">
      <xsl:choose>
        <xsl:when test="substring-before(substring-after(., 'lesson.section='), '&amp;') != ''">
          <xsl:value-of select="substring-before(substring-after(., 'lesson.section='), '&amp;')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="substring-after(., 'lesson.section=')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="section-label">
    <xsl:if test="contains(., 'section.label')">
      <xsl:value-of select="substring-after(., 'section.label=')"/>
    </xsl:if>
  </xsl:variable>

  <xsl:attribute name="href">

    <xsl:choose>
      <xsl:when test="$section = 'unit' and $section-label != ''">
        <xsl:value-of select="$section-label"/>.html
      </xsl:when>
      <xsl:when test="$section = 'selfAssessment'">
        <xsl:text>selfAssessment.html</xsl:text>
      </xsl:when>
      <xsl:when test="$section = 'furtherReading'">
        <xsl:text>furtherReading.html</xsl:text>
      </xsl:when>
      <xsl:when test="starts-with($section, 'glossary')">
        <xsl:text>glossary.html</xsl:text>
      </xsl:when>
      <xsl:when test="starts-with($section, 'bibliography')">
        <xsl:text>bibliography.html</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>#</xsl:text>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:attribute>
</xsl:template>



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
