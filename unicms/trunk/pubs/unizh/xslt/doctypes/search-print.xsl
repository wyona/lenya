<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: xhtml-standard.xsl,v 1.11 2005/01/17 09:15:14 thomas Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:uz="http://unizh.ch"
  >
  
  <xsl:param name="contextprefix"/>
  <xsl:param name="area"/>
  <xsl:param name="rendertype"/>
  <xsl:param name="defaultlanguage"/>
  <xsl:param name="language"/>
  <xsl:param name="nodeid"/>
  <xsl:param name="fontsize"/>
  <xsl:param name="querystring"/>
  <xsl:param name="querySubString">
     <xsl:value-of select="substring-after($querystring, '=')"/>
  </xsl:param>

  <xsl:include href="../doctypes/variables.xsl"/>
  <xsl:include href="../common/html-head-print.xsl"/>
  <xsl:include href="../common/header-print.xsl"/>
  <xsl:include href="../common/footer-print.xsl"/>
  <xsl:include href="../common/navigation.xsl"/>
  <xsl:include href="../common/elements.xsl"/> 
  <xsl:include href="../common/object.xsl"/>

  <xsl:template match="document">
    <xsl:apply-templates select="content"/>
  </xsl:template>


  <xsl:template match="content"> 
    <html>
      <xsl:call-template name="html-head"/>
      <body>
        <div class="bodywidth">
          <div class="imgunilogo">
            <img src="{$localsharedresources}/images/logo_print_{$language}.gif" alt="unizh logo" width="148" height="35" border="0" />
          </div>
          <xsl:apply-templates select="/document/xhtml:div[@id = 'breadcrumb']"/>
          <div class="dotline"><img src="{$imageprefix}/dot_line540.gif" alt="line" width="540" height="1"/></div>
          <xsl:call-template name="header"/>
          <div class="dotline"><img src="{$imageprefix}/dot_line540.gif" alt="line" width="540" height="1"  /></div>
          <div class="content">
            <h1>
             <xsl:value-of select="*/lenya:meta/dc:title"/> nach 
             <xsl:choose>
               <xsl:when test="contains($querystring,'&amp;')">
                  <xsl:value-of select="substring-before($querySubString, '&amp;')"/>
	       </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$querySubString"/>
	       </xsl:otherwise>
	     </xsl:choose>
            </h1>
            <p>&#160;</p>
              <!-- <xsl:apply-templates select="/document/xhtml:form[@id = 'search']"/> -->
              <xsl:apply-templates select="/document/xhtml:div[@id = 'exception']"/>
              <xsl:apply-templates select="/document/xhtml:div[@id = 'results']"/>
              <xsl:apply-templates select="/document/xhtml:div[@id = 'pages']"/>
          </div>
          <xsl:call-template name="footer-print"/>
        </div>
        <br/>
      </body> 
    </html>
  </xsl:template>


 <xsl:template match="xhtml:div[@id = 'results']">
    <h2><xsl:value-of select="xhtml:h1"/></h2>
    <xsl:for-each select="xhtml:p/xhtml:ul/xhtml:li">
      <div class="solidlinelist">
        <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
      </div>
      <a href="{xhtml:a/@href}"><xsl:value-of select="xhtml:a"/></a><br/>
      <xsl:value-of select="xhtml:span[@class = 'excerpt']"/>
      <p>
        <span class="urltext"><xsl:value-of select="xhtml:a/@href"/></span>
      </p>
    </xsl:for-each>
  </xsl:template>



  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template> 
  
</xsl:stylesheet>
