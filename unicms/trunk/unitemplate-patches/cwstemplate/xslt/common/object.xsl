<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: object.xsl, v 1.00 2006/11/20 17:00:00 mike Exp $ -->

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="../../../unizh/xslt/common/object.xsl"/>

  <xsl:template match="xhtml:object[parent::unizh:related-content]">
    <xsl:call-template name="object">
      <xsl:with-param name="width">160</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
