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


  <xsl:include href="../doctypes/variables.xsl"/>
  <xsl:include href="../common/html-head.xsl"/>
  <xsl:include href="../common/header.xsl"/>
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
          <xsl:apply-templates select="/document/xhtml:div[@id = 'breadcrumb']"/>
          <xsl:call-template name="header"/>
          <xsl:apply-templates select="/document/xhtml:div[@id = 'toolnav']"/>
          <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
          <div class="contcol2">
            <div class="content">
              <h1>
                <div bxe_xpath="/{document-element-nem}/lenya:meta/dc:title">
                  <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
                </div>
              </h1>
              <xsl:apply-templates select="/document/xhtml:form[@id = 'search']"/>
              <xsl:apply-templates select="/document/xhtml:div[@id = 'exception']"/>
              <xsl:apply-templates select="/document/xhtml:div[@id = 'results']"/>
            </div>
            <xsl:call-template name="footer"/>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>


  <xsl:template match="xhtml:form[@id = 'search']">
    <form>
      <xsl:apply-templates select="xhtml:input[@name = 'queryString']"/>
      <xsl:apply-templates select="xhtml:input[@name = 'sa']"/>
      <br/>
      <xsl:apply-templates select="xhtml:a[@id = 'lessoptions']"/> |
      <xsl:apply-templates select="xhtml:a[@id = 'moreoptions']"/>
      <br/>
      <xsl:apply-templates select="xhtml:input[@type = 'hidden']"/>
      <br/>
      <xsl:apply-templates select="xhtml:select[@name='dummy-index-id.fields']"/>
    </form>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'exception']">
    <xsl:value-of select="."/>
  </xsl:template>


  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template> 
  
</xsl:stylesheet>
