<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:map="http://apache.org/cocoon/sitemap/1.0"> 
<xsl:output method="xml" indent="yes"/>

  <xsl:template match="map:match[@pattern='*/**']">
     <map:match type="doctype" pattern="lesson">
        <map:generate type="serverpages" src="config/menus/lesson.xsp"/>
        <map:serialize type="xml"/>
      </map:match>

      <map:match type="doctype" pattern="unit">
        <map:generate type="serverpages" src="../unizh/config/menus/childless.xsp"/>
        <map:serialize type="xml"/>
      </map:match>

      <map:match type="doctype" pattern="selfAssessment">
        <map:generate type="serverpages" src="../unizh/config/menus/childless.xsp"/>
        <map:serialize type="xml"/>
      </map:match>

      <map:match type="doctype" pattern="summary">
        <map:generate type="serverpages" src="../unizh/config/menus/childless.xsp"/>
        <map:serialize type="xml"/>
      </map:match>

      <map:match type="doctype" pattern="furtherReading">
        <map:generate type="serverpages" src="../unizh/config/menus/childless.xsp"/>
        <map:serialize type="xml"/>
      </map:match>

      <map:match type="doctype" pattern="glossary">
        <map:generate type="serverpages" src="../unizh/config/menus/childless.xsp"/>
        <map:serialize type="xml"/>
      </map:match>

      <map:match type="doctype" pattern="bibliography">
        <map:generate type="serverpages" src="../unizh/config/menus/childless.xsp"/>
        <map:serialize type="xml"/>
      </map:match>

    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="map:generate[parent::map:match[@type = 'doctype' and @pattern='homepage']]">
      <map:generate type="serverpages" src="config/menus/homepage.xsp"/>
  </xsl:template>

  <xsl:template match="map:generate[parent::map:match[@type = 'doctype' and @pattern='xhtml']]">
      <map:generate type="serverpages" src="config/menus/xhtml.xsp"/>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
