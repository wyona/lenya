<?xml version="1.0" encoding="UTF-8"?>


<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:index="http://apache.org/cocoon/lenya/documentindex/1.0"
  xmlns:level="http://apache.org/cocoon/lenya/documentlevel/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" 
  xmlns:uz="http://unizh.ch"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:ci="http://apache.org/cocoon/include/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
>


  <xsl:include href="../../../unizh/xslt/common/elements.xsl"/>


<!-- define new templates -->

  <!-- banner is only for extended publication related contents -->
  <xsl:template match="unizh:banner">
    <div class="banner">
      <xsl:apply-templates select="xhtml:object"/>
    </div>
  </xsl:template>


  <!-- emergency message in fourth column -->
  <xsl:template name="emergency">
    <xsl:comment>emergency message</xsl:comment>
    <xsl:comment>#if expr="\"$REMOTE_ADDR\" = /130.60./"</xsl:comment>
    <xsl:comment>#include virtual="/admin/notfallhinweis/emergency.txt"</xsl:comment>
    <xsl:comment>#endif</xsl:comment>
    <xsl:comment>end emergency message</xsl:comment>
  </xsl:template>


<!-- overwrite included templates -->

</xsl:stylesheet>
