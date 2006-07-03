<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:map="http://apache.org/cocoon/sitemap/1.0"> 
<xsl:output method="xml" indent="yes"/>

  <xsl:template match="map:components/map:actions/map:action">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <sourcetype name="lesson">
        <document-element local-name="lesson"/>
      </sourcetype>

      <sourcetype name="unit">
        <document-element local-name="unit"/>
      </sourcetype>

      <sourcetype name="selfAssessment">
        <document-element local-name="selfAssessment"/>
      </sourcetype>

      <sourcetype name="furtherReading">
        <document-element local-name="furtherReading"/>
      </sourcetype>

      <sourcetype name="summary">
        <document-element local-name="summary"/>
      </sourcetype>

      <sourcetype name="glossary">
        <document-element local-name="glossary"/>
      </sourcetype>

      <sourcetype name="bibliography">
        <document-element local-name="bibliography"/>
      </sourcetype>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="doc[@type = 'homepage']/children">
    <xsl:copy>
      <xsl:apply-templates/>
        <doc type="lesson"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="doc[@type = 'xhtml']/children">
    <xsl:copy>
      <xsl:apply-templates/>
        <doc type="lesson"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
