<?xml version="1.0" encoding="iso-8859-1"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:s="http://www.oscom.org/2002/SlideML/0.9/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<!--
	xmlns="http://www.w3.org/1999/xhtml"
-->

<xsl:output encoding="iso-8859-1"/>
 

<xsl:include href="root.xsl"/>

<xsl:param name="presentation"/>

<xsl:template match="s:slideset">
<html>
<head>
<title><xsl:value-of select="s:metadata/s:title"/></title>
</head>
<body>

<xsl:if test="not(show-only-one-slide)">
<h1><xsl:value-of select="s:metadata/s:title"/></h1>
<xsl:call-template name="toc"/>
<h3>SLIDES</h3>
<xsl:for-each select="s:slide">
  <hr />
  <a name="{@id}"/>
  <xsl:apply-templates select="."/>
</xsl:for-each>
</xsl:if>

<xsl:if test="show-only-one-slide">
<!--
<xsl:for-each select="s:slide">
  current-id=<xsl:value-of select="@id"/>, one-id=<xsl:value-of select="../show-only-one-slide/@slideId"/><br />
  <xsl:if test="@id=../show-only-one-slide/@slideId">
    <xsl:apply-templates select="."/>
  </xsl:if>
</xsl:for-each>
-->
<!--
  <xsl:apply-templates select="s:slide"/>
-->
  <xsl:apply-templates select="s:slide[@id=../show-only-one-slide/@slideId]"/>
</xsl:if>

</body>
</html>
</xsl:template>


<xsl:include href="slide/body.xsl"/>




<!-- Table of Contents -->
<xsl:template name="toc">
<a name="toc"/>
<h3>TABLE OF CONTENTS</h3>
<ol>
<xsl:for-each select="/s:slideset/s:slide">
 <li><a href="#{@id}"><xsl:value-of select="s:title"/></a> (Status: <xsl:choose><xsl:when test="@status = 'ready'"><font color="green">Ready</font></xsl:when><xsl:when test="@status = 'wip'"><font color="red">Work in Progress</font></xsl:when><xsl:otherwise>No such status!</xsl:otherwise></xsl:choose> <xsl:apply-templates select="@note"/>)</li>
</xsl:for-each>
</ol>
</xsl:template>


<xsl:template match="@note">
, Note: <xsl:value-of select="."/>
</xsl:template>




</xsl:stylesheet>
