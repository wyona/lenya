<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: popup-standard.xsl,v 1.2 2005/03/29 12:39:52 thomas Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:elt="http://www.unizh.ch/elt/1.0"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  exclude-result-prefixes="xhtml lenya dc unizh"
  >
  
  <xsl:import href="variables.xsl"/>
  
  <xsl:param name="root"/> <!-- the URL up to (including) the area -->
  <xsl:param name="contextprefix"/>
  
  <xsl:param name="documentid"/>
  <xsl:param name="nodeid"/>
  
  <xsl:param name="language"/>
  <xsl:param name="defaultlanguage"/>
  <xsl:param name="languages"/>
  
  <xsl:param name="completearea"/>
  <xsl:param name="area"/>
  
  <xsl:param name="lastmodified"/>

  <xsl:param name="rendertype"/>

  <xsl:param name="export"/>

  <xsl:param name="popup"/>

  <xsl:include href="../common/html-head.xsl"/>
  <xsl:include href="../common/header.xsl"/>
  <xsl:include href="../common/elements.xsl"/>
  <xsl:include href="../common/footer.xsl"/>


  <xsl:template match="document">
    <xsl:apply-templates select="content/*"/>
  </xsl:template>
  
  <xsl:variable name="enable-pdf">
    <xsl:choose>
      <xsl:when test="starts-with($documentid, '/Lektionen/Kauf/') or starts-with($documentid, '/Lernpfad/Entscheide')">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

 
  <xsl:template match="unizh:popup">
    <xsl:call-template name="popup-window"/> 
  </xsl:template>
  
  
  <xsl:template name="popup-window">
    <html>
      <xsl:call-template name="html-head"/>
      <body>	
        <xsl:variable name="class">
          <xsl:choose>
            <xsl:when test="$area = 'live'">popuplive</xsl:when>
            <xsl:otherwise>popupauthoring</xsl:otherwise>	
          </xsl:choose>
        </xsl:variable>
        <div class="{$class}">
          <xsl:apply-templates select="$content/lenya:meta/dc:title"/>
          <div bxe_xpath="/unizh:{$document-element-name}/xhtml:body">
            <xsl:apply-templates select="xhtml:body"/>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>
  
  
  <xsl:template match="xhtml:body">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dc:title">
    <h1 bxe_xpath="/unizh:{$document-element-name}/lenya:meta/dc:title">
      <xsl:apply-templates/>
    </h1>
  </xsl:template>

  
<xsl:template match="@*|node()" priority="-1">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
