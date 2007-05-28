<?xml version="1.0" encoding="UTF-8" ?>


<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
    xmlns:elml="http://www.elml.ch"
>


<xsl:param name="pagebreak_level"><xsl:value-of select="//elml:pagebreak_level"/></xsl:param>
<xsl:param name="current_section"/>
<xsl:param name="current_label"/>

<xsl:template match="//xhtml:div[ancestor::xhtml:div[@id='menu'] and $pagebreak_level = 'unit' and @current ='true']">
   <xsl:copy>
    <xsl:if test="$current_section = ''">
      <xsl:attribute name="current">true</xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="@*[name() != 'current']|node()"/>

    <xsl:for-each select="//elml:unit">
      <xhtml:div href="?lesson.section=unit&#38;section.label={@label}">
        <xsl:if test="$current_section = 'unit' and $current_label = @label">
          <xsl:attribute name="current">true</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="@title"/>        
      </xhtml:div>
    </xsl:for-each>
    <xsl:if test="//elml:lesson/elml:furtherReading">
      <xhtml:div href="?lesson.section=furtherReading">
        <xsl:if test="$current_section = 'furtherReading'">
          <xsl:attribute name="current">true</xsl:attribute>
        </xsl:if>
         <xsl:value-of select="//elml:messagebundle/elml:msg[@name = 'name_furtherReading']"/>
      </xhtml:div>
    </xsl:if>
    <xsl:if test="//elml:lesson/elml:selfAssessment">
      <xhtml:div href="?lesson.section=selfAssessment">
        <xsl:if test="$current_section = 'selfAssessment'">
          <xsl:attribute name="current">true</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="//elml:messagebundle/elml:msg[@name = 'name_selfAssessment']"/>
      </xhtml:div>
    </xsl:if>
    <xsl:if test="//elml:lesson/elml:summary">
      <xhtml:div href="?lesson.section=summary">
        <xsl:if test="$current_section = 'summary'">
          <xsl:attribute name="current">true</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="//elml:messagebundle/elml:msg[@name = 'name_summary']"/>
      </xhtml:div>
    </xsl:if>
    <xsl:if test="//elml:lesson/elml:glossary">
      <xhtml:div href="?lesson.section=glossary">
         <xsl:if test="$current_section = 'glossary'">
          <xsl:attribute name="current">true</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="//elml:messagebundle/elml:msg[@name = 'name_glossary']"/>
      </xhtml:div>
    </xsl:if>
    <xsl:if test="//elml:lesson/elml:bibliography">
      <xhtml:div href="?lesson.section=bibliography">
        <xsl:if test="$current_section = 'bibliography'">
          <xsl:attribute name="current">true</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="//elml:messagebundle/elml:msg[@name = 'name_bibliography']"/>
      </xhtml:div>
    </xsl:if>
  </xsl:copy>
</xsl:template> 






<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet> 
