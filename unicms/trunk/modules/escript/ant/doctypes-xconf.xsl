<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 
<xsl:output method="xml" indent="yes"/>

  <xsl:template match="doctypes">
    <xsl:copy>
      <xsl:apply-templates/>
      <doc type="elml">
        <creator src="org.apache.lenya.cms.authoring.DefaultBranchCreator">
          <sample-name>elml.xml</sample-name>
        </creator>
        <workflow src="2stage.xml"/>
      </doc>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="doc[@type = 'homepage']/children">
    <xsl:copy>
      <xsl:apply-templates/>
        <doc type="elml"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="doc[@type = 'xhtml']/children">
    <xsl:copy>
      <xsl:apply-templates/>
        <doc type="elml"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
