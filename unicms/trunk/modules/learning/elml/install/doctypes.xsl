<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:map="http://apache.org/cocoon/sitemap/1.0"> 
<xsl:output method="xml" indent="yes"/>

  <xsl:template match="map:resources">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>

      <map:resource name="elml-page">
        <map:aggregate element="document">
          <map:part src="cocoon:/xml" element="content"/>
          <map:part src="cocoon://navigation/{{publication-id}}/{{area}}/breadcrumb/{{document-id}}.html.xml"/>
          <map:part src="cocoon://navigation/{{publication-id}}/{{area}}/servicenav/{{document-id}}.html.xml"/>
          <map:part src="cocoon://navigation/{{publication-id}}/{{area}}/toolnav/{{document-id}}.html.xml"/>
          <map:part src="cocoon://navigation/{{publication-id}}/{{area}}/menu/{{document-id}}.html.xml"/>
          <map:part src="cocoon://navigation/{{publication-id}}/{{area}}/tabs/{{document-id}}.html.xml"/>
          <map:part src="cocoon://navigation/{{publication-id}}/{{area}}/footnav/{{document-id}}.html.xml"/>
          <map:part src="cocoon://navigation/{{publication-id}}/{{area}}/simplenav/{{document-id}}.html.xml"/>
          <map:part src="cocoon://navigation/{{publication-id}}/{{area}}/ancestors/{{document-id}}.html.xml"/>
          <map:part src="cocoon://navigation/{{publication-id}}/{{area}}/parent/{{document-id}}.html.xml"/>
          <map:part src="cocoon://navigation/{{publication-id}}/{{area}}/allnodes/{{document-id}}.html.xml"/>
          <map:part src="cocoon:/unizh.xconf"/>
        </map:aggregate>
        <map:transform src="../unizh/xslt/elml-level.xsl"/>
        <map:transform type="level">
          <map:parameter value="http://unizh.ch/doctypes/elements/1.0" name="namespace"/>
          <map:parameter value="http://apache.org/cocoon/include/1.0" name="cIncludeNamespace"/>
        </map:transform>
        <map:transform src="../unizh/xslt/includeAssetMetaData.xsl">
          <map:parameter value="{{page-envelope:document-id}}" name="documentid"/>
        </map:transform>
        <map:transform type="cinclude"/>
        <map:transform src="lenya/xslt/navigation/header.xsl"/>
        <map:transform src="lenya/xslt/navigation/logic.xsl">
          <map:parameter value="{{page-envelope:document-node-id}}" name="node-id"/>
        </map:transform>
        <map:transform src="../unizh/xslt/sessionSwitchView.xsl">
          <map:parameter value="{{request-param:version}}" name="version"/>
          <map:parameter value="{{request-param:fontsize}}" name="fontsize"/>
        </map:transform>
        <map:transform type="session"/>
        <map:call resource="transformation">
          <map:parameter value="{{publication-id}}" name="publication-id"/>
          <map:parameter value="{{area}}" name="area"/>
          <map:parameter value="elml" name="stylesheet"/>
          <map:parameter value="{{rendertype}}" name="rendertype"/>
          <map:parameter value="{{version}}" name="version"/>
        </map:call>
      </map:resource>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="map:match[following-sibling::*[1][@pattern='*-*-*/*/*/**.html']]">
    <xsl:copy-of select="."/>
     <map:match pattern="lesson-*-*/*/*/**.html">
      <map:call resource="elml-page">
        <map:parameter value="{{1}}" name="rendertype"/>
        <map:parameter value="{{2}}" name="version"/>
        <map:parameter value="{{3}}" name="publication-id"/>
        <map:parameter value="{{4}}" name="area"/>
        <map:parameter value="{{5}}" name="document-id"/>
      </map:call>
      <map:serialize type="xml"/>
    </map:match>

    <map:match pattern="unit-*-*/*/*/**.html">
      <map:call resource="elml-page">
        <map:parameter value="{{1}}" name="rendertype"/>
        <map:parameter value="{{2}}" name="version"/>
        <map:parameter value="{{3}}" name="publication-id"/>
        <map:parameter value="{{4}}" name="area"/>
        <map:parameter value="{{5}}" name="document-id"/>
      </map:call>
      <map:serialize type="xml"/>
    </map:match>

    <map:match pattern="selfAssessment-*-*/*/*/**.html">
      <map:call resource="elml-page">
        <map:parameter value="{{1}}" name="rendertype"/>
        <map:parameter value="{{2}}" name="version"/>
        <map:parameter value="{{3}}" name="publication-id"/>
        <map:parameter value="{{4}}" name="area"/>
        <map:parameter value="{{5}}" name="document-id"/>
      </map:call>
      <map:serialize type="xml"/>
    </map:match>

    <map:match pattern="summary-*-*/*/*/**.html">
      <map:call resource="elml-page">
        <map:parameter value="{{1}}" name="rendertype"/>
        <map:parameter value="{{2}}" name="version"/>
        <map:parameter value="{{3}}" name="publication-id"/>
        <map:parameter value="{{4}}" name="area"/>
        <map:parameter value="{{5}}" name="document-id"/>
      </map:call>
      <map:serialize type="xml"/>
    </map:match>

    <map:match pattern="furtherReading-*-*/*/*/**.html">
      <map:call resource="elml-page">
        <map:parameter value="{{1}}" name="rendertype"/>
        <map:parameter value="{{2}}" name="version"/>
        <map:parameter value="{{3}}" name="publication-id"/>
        <map:parameter value="{{4}}" name="area"/>
        <map:parameter value="{{5}}" name="document-id"/>
      </map:call>
      <map:serialize type="xml"/>
    </map:match>

    <map:match pattern="glossary-*-*/*/*/**.html">
      <map:call resource="elml-page">
        <map:parameter value="{{1}}" name="rendertype"/>
        <map:parameter value="{{2}}" name="version"/>
        <map:parameter value="{{3}}" name="publication-id"/>
        <map:parameter value="{{4}}" name="area"/>
        <map:parameter value="{{5}}" name="document-id"/>
      </map:call>
      <map:serialize type="xml"/>
    </map:match>

   <map:match pattern="bibliography-*-*/*/*/**.html">
      <map:call resource="elml-page">
        <map:parameter value="{{1}}" name="rendertype"/>
        <map:parameter value="{{2}}" name="version"/>
        <map:parameter value="{{3}}" name="publication-id"/>
        <map:parameter value="{{4}}" name="area"/>
        <map:parameter value="{{5}}" name="document-id"/>
      </map:call>
      <map:serialize type="xml"/>
    </map:match>

  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
