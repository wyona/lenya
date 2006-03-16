<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:map="http://apache.org/cocoon/sitemap/1.0"> 
<xsl:output method="xml" indent="yes"/>

  <xsl:template match="map:match[@pattern='*/**.rng']">
    <map:match pattern="authoring/elml/**.rng">
      <map:generate src="config/doctypes/schemas/elml/{{1}}.rng"/>
      <map:transform src="../unizh/xslt/bxe-rng.xsl"/>
      <map:serialize type="xml"/>
    </map:match>
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
