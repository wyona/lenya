<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
>

<xsl:param name="publicationName"/>

<xsl:template match="*[@id='index']/*">
  <label xml:lang="{@xml:lang}" xmlns="http://apache.org/cocoon/lenya/sitetree/1.0">
     <!-- namespace prevents empty attribute xmlns='' -->
    <xsl:value-of select="$publicationName"/>
  </label>
</xsl:template>


<!--
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:foo="http://apache.org/cocoon/lenya/sitetree/1.0"
    exclude-result-prefixes="foo">

<xsl:output method="xml"/>
<xsl:strip-space elements="foo:site"/>

<xsl:param name="publicationName"/>
<xsl:param name="templateName"/>
<xsl:variable name="newline" select="'&#xa;'"/>

<xsl:template match="foo:node">
  <xsl:if test="contains(.,$templateName)">
  <xsl:value-of select="$newline"/>
  <node id="{attribute::id}">
     <xsl:value-of select="$newline"/>
     <label xml:lang="de"><xsl:value-of select="$publicationName"/></label><xsl:value-of select="$newline"/>
     <label xml:lang="en"><xsl:value-of select="$publicationName"/></label><xsl:value-of select="$newline"/>
   </node>
   </xsl:if>
</xsl:template>
-->

<!--
<xsl:template match="foo:site">
   <xsl:value-of select="$newline"/>
   <xsl:copy>
     <xsl:apply-templates select="@*|node()"/>
   </xsl:copy>
</xsl:template>
-->

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
