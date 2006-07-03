<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 
<xsl:output method="xml" indent="yes"/>

  <xsl:template match="doctypes">
    <xsl:copy>
      <xsl:apply-templates/>
      <doc type="lesson">
        <children>
          <doc type="introduction"/>
          <doc type="unit"/>
          <doc type="selfAssessment"/>
          <doc type="summary"/>
          <doc type="furtherReading"/>
          <doc type="glossary"/>
          <doc type="bibliography"/>
        </children>
        <creator src="org.apache.lenya.cms.authoring.DefaultBranchCreator">
          <sample-name>lesson.xml</sample-name>
        </creator>
        <workflow src="2stage.xml"/>
      </doc>
    
      <doc type="unit">
        <creator src="org.apache.lenya.cms.authoring.DefaultBranchCreator">
          <sample-name>unit.xml</sample-name>
        </creator>
        <workflow src="2stage.xml"/>
      </doc>

      <doc type="selfAssessment">
        <creator src="org.apache.lenya.cms.authoring.DefaultBranchCreator">
          <sample-name>selfAssessment.xml</sample-name>
        </creator>
        <workflow src="2stage.xml"/>
      </doc>

      <doc type="summary">
        <creator src="org.apache.lenya.cms.authoring.DefaultBranchCreator">
          <sample-name>summary.xml</sample-name>
        </creator>
        <workflow src="2stage.xml"/>
      </doc>

      <doc type="furtherReading">
        <creator src="org.apache.lenya.cms.authoring.DefaultBranchCreator">
          <sample-name>furtherReading.xml</sample-name>
        </creator>
        <workflow src="2stage.xml"/>
      </doc>

      <doc type="glossary">
        <creator src="org.apache.lenya.cms.authoring.DefaultBranchCreator">
          <sample-name>glossary.xml</sample-name>
        </creator>
        <workflow src="2stage.xml"/>
      </doc>

      <doc type="bibliography">
        <creator src="org.apache.lenya.cms.authoring.DefaultBranchCreator">
          <sample-name>bibliography.xml</sample-name>
        </creator>
        <workflow src="2stage.xml"/>
      </doc>
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
