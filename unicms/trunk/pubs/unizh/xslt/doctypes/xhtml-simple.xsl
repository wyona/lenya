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

  <xsl:include href="../doctypes/variables.xsl"/>
  <xsl:include href="../common/html-head-simple.xsl"/>
  <xsl:include href="../common/header-simple.xsl"/>
  <xsl:include href="../common/footer.xsl"/>
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
          <a name="top"><xsl:comment/></a>
          <div id="simplenav"> 
            Universit&#228;t Z&#252;rich | 
            <a href="?version=standard">Grafik-Version</a>
          </div>
          <div class="line"><xsl:comment/></div> 
          <xsl:apply-templates select="/document/xhtml:div[@id = 'breadcrumb']"/>
          <xsl:call-template name="header"/>
          <div class="line"><xsl:comment/></div>
          <xsl:apply-templates select="/document/xhtml:div[@id = 'simplenav']"/> 
          <div class="line"><xsl:comment/></div>
          <div class="content">
            <h1>
              <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
            </h1>
            <p>&#160;</p>
            <xsl:apply-templates select="*/xhtml:body/*"/> 
            <br/> 
          </div>
          <div class="line"><xsl:comment/></div>
          <xsl:apply-templates select="*/unizh:related-content"/>
          <div class="topnav"><a href="#top">top</a></div>
          <div class="footermargintop"><xsl:comment/></div>
          <div class="solidline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/></div>
          <div id="footer"><a href="">Hilfe</a> | <a href="sitemap.htm">Sitemap</a> | <a href="">Kontakt</a></div>  
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
