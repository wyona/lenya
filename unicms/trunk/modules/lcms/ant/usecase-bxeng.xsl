<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:map="http://apache.org/cocoon/sitemap/1.0"
> 
<xsl:output method="xml" indent="yes"/>

  <xsl:template match="map:transform[@src = '../unizh/xslt/bxeInsertDummyObject.xsl']">
    <xsl:copy-of select="."/>
    <map:transform src="../unizh/xslt/bxe-loadxml.xsl">
      <map:parameter name="nodeid" value="{{page-envelope:document-node-id}}"/>
    </map:transform>
  </xsl:template>


  <xsl:template match="map:transform[@src = '../unizh/xslt/bxeRemoveDummyObject.xsl']">
    <xsl:copy-of select="."/>
    <map:transform src="../unizh/xslt/bxe-savexml.xsl">
      <map:parameter name="nodeid" value="{{page-envelope:document-node-id}}"/>
    </map:transform>
  </xsl:template>


  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
