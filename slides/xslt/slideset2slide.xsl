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

<xsl:output method="xml" encoding="iso-8859-1"/>
 
<xsl:param name="slideId"/>

<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="s:slideset">
<s:slideset>
  <show-only-one-slide slideId="{$slideId}"/>
  <xsl:copy-of select="s:metadata"/>
  <xsl:copy-of select="s:slide"/>
<!--
  <xsl:copy-of select="s:slide[@id=$slideId]"/>
-->
</s:slideset>
</xsl:template>

</xsl:stylesheet>
