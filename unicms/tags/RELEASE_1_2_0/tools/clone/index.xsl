<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"> 

  <xsl:param name="publicationName"/>

  <xsl:template match="unizh:heading">
    <unizh:heading>
       <xsl:value-of select="$publicationName"/>
    </unizh:heading>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
