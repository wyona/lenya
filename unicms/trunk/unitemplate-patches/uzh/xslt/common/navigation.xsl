<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: navigation.xsl, v 1.00 2006/11/20 17:00:00 mike Exp $ -->

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="../../../unizh/xslt/common/navigation.xsl"/>

  <xsl:template match="xhtml:div[@id = 'sub-tabs']">
    <div id="secnavOben">
      <xsl:for-each select="xhtml:div">
        <a href="{@href}">
          <xsl:if test="@current = 'true'">
            <xsl:attribute name="class">activ</xsl:attribute>
          </xsl:if>
          <xsl:value-of select="text()"/>
        </a>
        <xsl:if test="position() &lt; last()">
          <div class="linkseparator">|</div>
        </xsl:if>
      </xsl:for-each>
      <xsl:comment/>
    </div>
  </xsl:template>


</xsl:stylesheet>
