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
            <xsl:choose>
              <xsl:when test="$document-element-name = 'unizh:person'">
                <xsl:call-template name="person"/>
              </xsl:when>
              <xsl:otherwise>
                <h1>
                  <xsl:value-of select="*/lenya:meta/dc:title"/>
                </h1>
                <p>&#160;</p>
                <xsl:apply-templates select="*/xhtml:body/*"/>
              </xsl:otherwise>
            </xsl:choose>
          </div>
          <div class="dotline"><img src="{$imageprefix}/dot_line540.gif" alt="line" width="540" height="1"/></div>
          <xsl:apply-templates select="*/unizh:related-content/unizh:teaser"/>
          <xsl:apply-templates select="*/xhtml:body/unizh:column/unizh:teaser"/>
          <xsl:call-template name="footer-print"/>
        </div>
        <br/>
      </body> 
    </html>
  </xsl:template>


  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template> 
  
  <xsl:template name="person">
    <div class="teamBlock">
      <div class="teamImg">
        <xsl:apply-templates select="unizh:person/xhtml:object"/>
      </div>
      <div class="teamText">
        <p>
          <b>
            <span bxe_xpath="/{$document-element-name}/unizh:academictitle">
              <xsl:if test="unizh:person/unizh:academictitle !=''">
                <xsl:value-of select="unizh:person/unizh:academictitle"/>&#160;
              </xsl:if>
            </span>
            <span bxe_xpath="/{$document-element-name}/unizh:firstname">
              <xsl:value-of select="unizh:person/unizh:firstname"/>&#160;
            </span>
            <span bxe_xpath="/{$document-element-name}/unizh:lastname">
              <xsl:value-of select="unizh:person/unizh:lastname"/>
            </span>
          </b>
          <br/>
          <span bxe_xpath="/{$document-element-name}/unizh:position">
            <xsl:value-of select="unizh:person/unizh:position"/>
          </span>
          <br/>
          Tel.: 
          <span bxe_xpath="/{$document-element-name}/unizh:phone">
            <xsl:value-of select="unizh:person/unizh:phone"/>
          </span>
          <br/>
          Mail: 
          <span bxe_xpath="/{$document-element-name}/unizh:email">
            <xsl:value-of select="unizh:person/unizh:email"/>
          </span>
        </p>
      </div>
      <div class="floatleftclear"><xsl:comment/></div>
    </div>
    <div class="solidline">
      <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
    </div>
    <div bxe_xpath="/{$document-element-name}/unizh:description">
      <xsl:apply-templates select="unizh:person/unizh:description"/>
    </div>
  </xsl:template>

</xsl:stylesheet>
