<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: xhtml-print.xsl,v 1.1 2004/11/23 07:51:44 thomas Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:uz="http://unizh.ch"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  exclude-result-prefixes="xhtml lenya dc unizh uz"
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
  
  <xsl:param name="rendertype"/>
  
  <xsl:param name="lastmodified"/>

  <xsl:include href="../common/html-head.xsl"/>
  <xsl:include href="../common/header.xsl"/>
  <xsl:include href="../common/breadcrumb.xsl"/>
  <xsl:include href="../common/elements.xsl"/>
  <xsl:include href="../common/footer.xsl"/>


  <xsl:template match="document">
    <xsl:apply-templates select="content/*"/>
  </xsl:template>
  
  
  <xsl:template match="content/*">
    <html>
        
      <xsl:call-template name="html-head"/>
        
      <body>
        <div class="printview">
          
          <a href="http://www.unizh.ch/index.html"><img src="{$imageprefix}/logo_60{$languagesuffix}.gif" 
               alt="university_zurich" border="0" i18n:attr="alt"/></a>
          
          <p class="navon"><xsl:call-template name="breadcrumb"/></p>
          <p class="navon"><img height="1" width="100%" src="{$imageprefix}/999999.gif" alt=" "/></p>
          
          <xsl:variable name="columns" select="@unizh:columns"/>
          <xsl:choose>
            
            <xsl:when test="$columns = '2'">            
              <div class="dc-title" bxe_xpath="/xhtml:{$document-element-name}/lenya:meta/dc:title" />
              <br />
              <xsl:apply-templates select="lenya:meta/dc:title"/>
              <xsl:apply-templates select="xhtml:body/node()"/>
            </xsl:when>

            <xsl:when test="$columns = '3'">            
              <div class="dc-title" bxe_xpath="/xhtml:{$document-element-name}/lenya:meta/dc:title" />
              <br />
              <xsl:apply-templates select="lenya:meta/dc:title"/>
              <xsl:apply-templates select="xhtml:body/node()"/>
              <img height="1" width="100%" src="{$imageprefix}/999999.gif" alt=" "/>
              <br/><br/>
              <xsl:apply-templates select="unizh:highlights" mode="print"/>
            </xsl:when>
            
            <xsl:otherwise>
              <div class="dc-title" bxe_xpath="/xhtml:{$document-element-name}/lenya:meta/dc:title" />
              <br />
              <div bxe_xpath="/xhtml:{$document-element-name}/xhtml:body">
                <xsl:apply-templates select="lenya:meta/dc:title"/>
                <xsl:apply-templates select="xhtml:body/node()"/>
              </div>
            </xsl:otherwise>
            
          </xsl:choose>   
          
          <xsl:call-template name="footer-print"/>
        
        </div>
      </body>
    </html>
  </xsl:template>
  
  
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
