<?xml version="1.0" encoding="ISO-8859-1" ?>

<!-- $Id: includeAssetMetaData.xsl,v 1.4 2004/06/23 16:07:25 edith Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:elml="http://www.elml.ch" 
  exclude-result-prefixes="xhtml"
  >

  <xsl:param name="documentid"/>
  
  <xsl:template match="elml:multimedia[@src and @type = 'mathml']">
    <xsl:variable name="metaFileURI">resources/authoring/<xsl:value-of select="$documentid"/>/<xsl:value-of select="@src"/></xsl:variable>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <cinclude:includexml ignoreErrors="false">
       <cinclude:src><xsl:value-of select="$metaFileURI"/></cinclude:src>
      </cinclude:includexml>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
