<?xml version="1.0" encoding="UTF-8" ?>


<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
>


<xsl:template match="/document[content/*[local-name() = 'unit' or local-name() = 'selfAssessment' or local-name() = 'furtherReading']]">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
    <unizh:level/>
  </xsl:copy>
</xsl:template>



<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet> 
