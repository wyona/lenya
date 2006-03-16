<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:xhtml="http://www.w3.org/1999/xhtml"> 
<xsl:output method="xml" indent="yes"/>

  <xsl:template match="xhtml:script">
    <xsl:copy-of select="."/>
    <script type="text/javascript" src="{{$contextprefix}}/unizh/authoring/javascript/elml.js"></script>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
