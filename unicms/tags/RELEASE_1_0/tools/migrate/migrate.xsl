<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns="http://www.w3.org/1999/xhtml"
      xmlns:xhtml="http://www.w3.org/1999/xhtml"
      xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
      xmlns:dc="http://purl.org/dc/elements/1.1/"
      xmlns:dcterms="http://purl.org/dc/terms/"
      xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
      xmlns:up="http://www.unipublic.unizh.ch/2002/up" 
      dc:dummy="FIXME:keepNamespace" dcterms:dummy="FIXME:keepNamespace"
      lenya:dummy="FIXME:keepNamespace" xhtml:dummy="FIXME:keepNamespace">

<xsl:param name="resourcePath"/>

<xsl:template match="xhtml:homepage">
  <unizh:homepage>
    <xsl:copy-of select="@dc:dummy|@dcterms:dummy|@lenya:dummy|@unizh:columns|@xhtml:dummy"/>
    <xsl:apply-templates/>
  </unizh:homepage>
</xsl:template>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet> 
