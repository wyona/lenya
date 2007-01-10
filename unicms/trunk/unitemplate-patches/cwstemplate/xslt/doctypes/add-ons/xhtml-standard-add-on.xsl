<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: xhtml-standard-add-on.xsl, v 1.00 2006/11/20 17:00:00 mike Exp $ -->

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


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
          <xsl:choose>
            <xsl:when test="$document-element-name='xhtml:html'">
              <xsl:choose>
                <xsl:when test="xhtml:html[@unizh:columns = '1']">
                  <xsl:call-template name="one-column"/>
                </xsl:when>
                <xsl:when test="xhtml:html[@unizh:columns = '2']">
                  <xsl:call-template name="two-columns"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="three-columns"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="$document-element-name = 'unizh:overview'">
              <xsl:call-template name="overview"/>
            </xsl:when> 
            <xsl:when test="$document-element-name = 'unizh:homepage'">
              <xsl:call-template name="homepage"/>
            </xsl:when>
            <xsl:when test="$document-element-name = 'unizh:portal'">
              <xsl:call-template name="portal"/>
            </xsl:when>
            <xsl:when test="$document-element-name = 'unizh:homepage4cols'">
              <xsl:call-template name="homepage4columns"/>
            </xsl:when>
            <xsl:when test="$document-element-name = 'unizh:news'">
              <xsl:call-template name="three-columns"/>
            </xsl:when>
            <xsl:when test="$document-element-name = 'unizh:newsitem'">
              <xsl:call-template name="newsitem"/>
            </xsl:when> 
            <xsl:when test="$document-element-name = 'unizh:team'">
              <xsl:call-template name="three-columns"/>
            </xsl:when>
            <xsl:when test="$document-element-name = 'unizh:person'">
              <xsl:call-template name="person"/>
            </xsl:when>
            <xsl:when test="$document-element-name = 'unizh:list'">
              <xsl:call-template name="three-columns"/>
            </xsl:when>
            <xsl:when test="$document-element-name = 'unizh:redirect'">
              <xsl:call-template name="redirect"/>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </body>
    </html>
  </xsl:template>


  <xsl:template name="portal">
    <div id="col1">
      <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
      <xsl:apply-templates select="*/unizh:contcol1"/>
      <xsl:comment/>
    </div>
    <div class="contcol2">
      <div class="relatedbox" bxe_xpath="/{$document-element-name}/unizh:related-content">
        <xsl:apply-templates select="*/unizh:related-content"/><xsl:comment/>
      </div>
      <xsl:apply-templates select="/document/xhtml:div[@id = 'orthonav']"/>
      <div class="contentarea">
        <a accesskey="2" name="content" class="namedanchor"><xsl:comment/></a>
        <div class="content">
          <xsl:apply-templates select="*/xhtml:body/*"/>
        </div>
        <xsl:call-template name="footer"/>
      </div>
    </div>
  </xsl:template>


</xsl:stylesheet>
