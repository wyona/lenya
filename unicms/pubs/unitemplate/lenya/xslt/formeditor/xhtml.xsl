<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
>

<xsl:import href="../../../../../xslt/authoring/edit/form.xsl"/>
<xsl:import href="xhtml-common.xsl"/>
<xsl:import href="unizh-common.xsl"/>

<xsl:template match="xhtml:html">
<node name="Title" select="/xhtml:html/lenya:meta/dc:title[@tagID='{lenya:meta/dc:title/@tagID}']">
  <content><input type="text" name="&lt;xupdate:update select=&quot;/xhtml:html/lenya:meta/dc:title[@tagID='{lenya:meta/dc:title/@tagID}']&quot;&gt;" size="40"><xsl:attribute name="value"><xsl:value-of select="lenya:meta/dc:title"/></xsl:attribute></input></content>
</node>


<xsl:apply-templates select="xhtml:body"/>

<!--<xsl:call-template name="appendmenu"><xsl:with-param name="path">/*/xhtml:body</xsl:with-param></xsl:call-template>-->

<xsl:choose>
   <xsl:when test="@unizh:columns = '3'">
      <xsl:apply-templates select="unizh:highlights"/>
   </xsl:when>
   <xsl:otherwise/>
</xsl:choose>   

</xsl:template>

</xsl:stylesheet>  
