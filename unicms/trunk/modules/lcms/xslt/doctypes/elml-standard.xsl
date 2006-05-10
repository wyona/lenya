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
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:elml="http://www.elml.ch"
  >
  
  <xsl:param name="root"/>
  <xsl:param name="contextprefix"/>
  <xsl:param name="area"/>
  <xsl:param name="rendertype"/>
  <xsl:param name="defaultlanguage"/>
  <xsl:param name="language"/>
  <xsl:param name="nodeid"/>
  <xsl:param name="fontsize"/>
  <xsl:param name="querystring"/>
  <xsl:param name="creationdate"/>

  <xsl:include href="../doctypes/variables.xsl"/>
  <xsl:include href="../common/html-head.xsl"/>
  <xsl:include href="../common/header.xsl"/>
  <xsl:include href="../common/footer.xsl"/>
  <xsl:include href="../common/navigation.xsl"/>
  <xsl:include href="../common/elements.xsl"/> 
  <xsl:include href="../common/object.xsl"/> 

  <xsl:include href="../common/elml.xsl"/>


  <xsl:template match="document">
    <xsl:apply-templates select="content"/>
  </xsl:template>


  <xsl:template match="content"> 
    <html>
      <xsl:call-template name="html-head"/>
      <body>
        <div class="bodywidth">
          <a accesskey="1" title="Zur Navigation springen" href="#navigation"><xsl:comment/></a>
          <a accesskey="2" title="Zum Inhalt springen" href="#content"><xsl:comment/></a>
          <a name="top"><xsl:comment/></a>
          <xsl:apply-templates select="/document/xhtml:div[@id = 'breadcrumb']"/>
          <xsl:call-template name="header"/>
          <xsl:apply-templates select="/document/xhtml:div[@id = 'toolnav']"/>
          <xsl:call-template name="content"/>
        </div>
      </body>
    </html>
  </xsl:template>


  <xsl:template name="content">
    <div id="col1">
      <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
      <xsl:apply-templates select="*/unizh:contcol1"/>
    </div>
    <div class="contcol2">
      <div class="content">
        <a accesskey="2" name="content" class="namedanchor"><xsl:comment/></a>
        <div class="content">
          <h1>
            <xsl:choose>
              <xsl:when test="/document/content/*/@title">
                <div bxe_xpath="/*/xhtml:h1">
                  <xsl:value-of select="/document/content/*/@title"/>
                </div>
              </xsl:when>
              <xsl:otherwise>
                <div bxe_xpath="/*/lenya:meta/dc:title">
                  <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
                </div>
              </xsl:otherwise>
            </xsl:choose>
          </h1> 
          <div bxe_xpath="/*/elml:body">
            <xsl:apply-templates select="/document/content/*"/> 
          </div> 
        </div>
        <xsl:call-template name="footer"/> 
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
