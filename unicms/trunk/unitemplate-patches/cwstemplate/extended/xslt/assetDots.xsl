<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: footer.xsl, v 1.00 2006/11/20 17:00:00 mike Exp $ -->

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

  <xsl:import href="../../unizh/xslt/assetDots.xsl"/>

  <xsl:template match="unizh:teaser[$rendertype = 'imageupload'] | unizh:rss-reader[parent::unizh:related-content and $rendertype = 'imageupload'] | xhtml:object[parent::unizh:related-content and $rendertype = 'imageupload']">
    <br/>
    <xsl:call-template name="asset-dot">
      <xsl:with-param name="insertWhat">image</xsl:with-param>
      <xsl:with-param name="insertWhere">before</xsl:with-param>
    </xsl:call-template>
    <br/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
    <br/>

    <xsl:if test="not(following-sibling::*)">
      <br/>
      <xsl:call-template name="asset-dot">
        <xsl:with-param name="insertWhat">image</xsl:with-param>
        <xsl:with-param name="insertWhere">after</xsl:with-param>
      </xsl:call-template>
      <br/>
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
