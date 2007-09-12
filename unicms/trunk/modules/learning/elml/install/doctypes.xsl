<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:map="http://apache.org/cocoon/sitemap/1.0"> 
<xsl:output method="xml" indent="yes"/>

  <xsl:template match="map:resources">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>

      <map:resource name="elml-page">
        <map:aggregate element="document">
          <map:part element="content" src="cocoon:/xml"/>
          <map:part src="cocoon:/layout/xhtml" element="layout"/>
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
        <map:transform src="../unizh/xslt/elml-navigation.xsl">
        <map:parameter name="current_section" value="{{request-param:lesson.section}}"/>
          <map:parameter name="current_label" value="{{request-param:section.label}}"/>
        </map:transform>

        <map:transform src="../unizh/xslt/includeAssetMetaData.xsl">
          <map:parameter name="documentid" value="{{page-envelope:document-id}}"/>
        </map:transform>

        <map:transform src="../unizh/xslt/includeMathML.xsl">
          <map:parameter name="documentid" value="{{page-envelope:document-id}}"/>
        </map:transform>

        <map:transform type="cinclude"/>
        <map:transform src="lenya/xslt/navigation/header.xsl"/>
        <map:transform src="lenya/xslt/navigation/logic.xsl">
          <map:parameter name="node-id" value="{{page-envelope:document-node-id}}"/>
        </map:transform>
        <map:transform src="../unizh/xslt/sessionSwitchView.xsl">
          <map:parameter name="version" value="{{request-param:version}}"/>
          <map:parameter name="fontsize" value="{{request-param:fontsize}}"/>
        </map:transform>
        <map:transform type="session"/>

        <map:transform src="../unizh/xslt/doctypes/lesson-{{version}}.xsl">
          <map:parameter name="root" value="{{request:contextPath}}/{{page-envelope:publication-id}}/{{page-envelope:area}}"/>
          <map:parameter name="publicationid" value="{{page-envelope:publication-id}}"/>
          <map:parameter name="documentid" value="{{page-envelope:document-id}}"/>
          <map:parameter name="area" value="{{page-envelope:area}}"/>
          <map:parameter name="language" value="{{page-envelope:document-language}}"/>
          <map:parameter name="languages" value="{{page-envelope:document-languages-csv}}"/>
          <map:parameter name="defaultlanguage" value="{{page-envelope:default-language}}"/>
          <map:parameter name="nodeid" value="{{page-envelope:document-node-id}}"/>
          <map:parameter name="contextprefix" value="{{request:contextPath}}"/>
          <map:parameter name="rendertype" value="{{rendertype}}"/>
          <map:parameter name="lastmodified" value="{{page-envelope:document-lastmodified}}"/>
          <map:parameter name="fontsize" value="{{request-param:fontsize}}; {{session-context:font/size}}"/>
          <map:parameter name="querystring" value="{{request:queryString}}"/>
          <map:parameter name="creationdate" value="{{page-envelope:document-dc-date-created}}"/>
          <map:parameter name="servername" value="{{proxy-url:live:/index:de}}"/>
          <map:parameter name="current_section" value="{{request-param:lesson.section}}"/>
          <map:parameter name="current_label" value="{{request-param:section.label}}"/>
          <map:parameter name="omit_navigation" value="true"/>
        </map:transform> 
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

  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
