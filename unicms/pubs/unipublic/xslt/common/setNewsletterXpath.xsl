<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:up="http://www.unipublic.unizh.ch/2002/up"
  xmlns:col="http://apache.org/cocoon/lenya/collection/1.0"> 

  <xsl:template match="up:homepage/col:document|up:dossier/col:document|up:newsletter/col:document">
    <col:document id="{@id}">
      <up:teaser xlink:href="{@xlink:href}#xpointer(/xhtml:html/up:teaser)" xlink:show="embed"/>
      <lenya:meta xlink:href="{@xlink:href}#xpointer(/xhtml:html/lenya:meta)" xlink:show="embed"/>
    </col:document>
  </xsl:template>

  <xsl:template match="up:dossiersbox/col:document">
    <col:document id="{@id}">
      <up:teaser xlink:href="{@xlink:href}#xpointer(/up:dossier/up:teaser)" xlink:show="embed"/>
      <up:color xlink:href="{@xlink:href}#xpointer(/up:dossier/up:color)" xlink:show="embed"/>
      <lenya:meta xlink:href="{@xlink:href}#xpointer(/up:dossier/lenya:meta)" xlink:show="embed"/>
    </col:document>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
