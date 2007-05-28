<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:map="http://apache.org/cocoon/sitemap/1.0"> 
<xsl:output method="xml" indent="yes"/>

  <xsl:template match="map:components/map:actions/map:action">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <sourcetype name="lesson">
        <document-element local-name="lessonEnvelope"/>
      </sourcetype>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
