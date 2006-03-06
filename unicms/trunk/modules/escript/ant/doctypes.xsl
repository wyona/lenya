<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:map="http://apache.org/cocoon/sitemap/1.0"> 
<xsl:output method="xml" indent="yes"/>

  <xsl:template match="map:match[following-sibling::*[1][@pattern='*-*-*/*/*/**.html']]">
    <xsl:copy-of select="."/>
    <xsl:comment> This pipeline builds the page content (without header) for
           - elml pages
    </xsl:comment>
    <xsl:text>
    </xsl:text>
    <xsl:comment> {doctype}-{rendertype}-{version}/{publication-id}/{area}{document-url} </xsl:comment>
    <xsl:text>
    </xsl:text>
    <xsl:comment>            1            2         3                      4             </xsl:comment>
    <xsl:text>
    </xsl:text>
    <map:match pattern="elml-*-*/*/*/**.html">
        <map:aggregate element="document">
          <map:part element="content" src="cocoon:/xml"/>
          <map:part src="cocoon://navigation/{{3}}/{{4}}/breadcrumb/{{5}}.html.xml"/>
          <map:part src="cocoon://navigation/{{3}}/{{4}}/servicenav/{{5}}.html.xml"/>
          <map:part src="cocoon://navigation/{{3}}/{{4}}/toolnav/{{5}}.html.xml"/>
          <map:part src="cocoon://navigation/{{3}}/{{4}}/menu/{{5}}.html.xml"/>
          <map:part src="cocoon://navigation/{{3}}/{{4}}/tabs/{{5}}.html.xml"/>
          <map:part src="cocoon://navigation/{{3}}/{{4}}/footnav/{{5}}.html.xml"/>
          <map:part src="cocoon://navigation/{{3}}/{{4}}/simplenav/{{5}}.html.xml"/>
          <map:part src="cocoon://navigation/{{3}}/{{4}}/ancestors/{{5}}.html.xml"/>
          <map:part src="cocoon://navigation/{{3}}/{{4}}/parent/{{5}}.html.xml"/>
          <map:part src="cocoon://navigation/{{3}}/{{4}}/allnodes/{{5}}.html.xml"/>
          <map:part src="cocoon:/unizh.xconf"/>
        </map:aggregate>
        <map:transform src="../unizh/xslt/includeAssetMetaData.xsl">
          <map:parameter name="documentid" value="{{page-envelope:document-id}}"/>
        </map:transform>

        <map:transform src="../unizh/xslt/assetDots.xsl">
          <map:parameter name="rendertype" value="{{1}}"/>
        </map:transform>


        <map:transform src="../unizh/xslt/sessionSwitchView.xsl">
          <map:parameter name="version" value="{{request-param:version}}"/>
          <map:parameter name="fontsize" value="{{request-param:fontsize}}"/>
        </map:transform>

        <map:transform type="session"/>

        <map:call resource="transformation">
          <map:parameter name="publication-id" value="{{3}}"/>
          <map:parameter name="area" value="{{4}}"/>
          <map:parameter name="stylesheet" value="elml"/>
          <map:parameter name="rendertype" value="{{1}}"/>
          <map:parameter name="version" value="{{2}}"/>
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
