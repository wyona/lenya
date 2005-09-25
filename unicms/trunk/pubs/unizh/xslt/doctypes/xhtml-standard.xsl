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
  <xsl:include href="../common/elements.xsl"/>
  <xsl:include href="../common/html-head.xsl"/>
  <xsl:include href="../common/footer.xsl"/>
  <xsl:include href="../common/header.xsl"/>
  <xsl:include href="../common/navigation.xsl"/> 

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
          <xsl:choose>
            <xsl:when test="$document-element-name='xhtml:html'">
              <xsl:choose>
                <xsl:when test="xhtml:html/@unizh:columns = '1'">
                  <xsl:call-template name="one-column"/>
                </xsl:when>
                <xsl:when test="xhtml:html/@unizh:columns = '2'">
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
            <xsl:when test="$document-element-name = 'unizh:homepage4cols'">
              <xsl:call-template name="homepage4columns"/>
            </xsl:when>
            <xsl:when test="$document-element-name = 'unizh:news'">
              <xsl:call-template name="three-columns"/>
            </xsl:when>
            <xsl:when test="$document-element-name = 'unizh:newsitem'">
              <xsl:call-template name="newsitem"/>
            </xsl:when> 
            <xsl:when test="$document-element-name = 'unizh:people'">
              <xsl:call-template name="three-columns"/>
            </xsl:when>
            <xsl:when test="$document-element-name = 'unizh:person'">
              <xsl:call-template name="person"/>
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


  <xsl:template name="one-column">
  </xsl:template>


  <xsl:template name="two-columns">
    <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
    <div class="contcol2">
      <div class="content">
        <h1>
          <div bxe_xpath="/{document-element-nem}/lenya:meta/dc:title">
            <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
          </div>
        </h1>
        <p>&#160;</p>
        <div bxe_xpath="/{$document-element-name}/xhtml:body">
          <xsl:apply-templates select="*/xhtml:body/*"/>
          <br/>
        </div>
      </div>
      <xsl:call-template name="footer"/>
    </div>
  </xsl:template>


  <xsl:template name="three-columns">
    <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
    <div class="contcol2">
      <div class="relatedbox">
        <div bxe_xpath="/{$document-element-name}/unizh:related-content">
          <xsl:apply-templates select="*/unizh:related-content"/>
        </div>
      </div>
      <div class="contentarea">
        <div class="content">
          <h1>
            <div bxe_xpath="/{document-element-nem}/lenya:meta/dc:title">
              <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
            </div>
          </h1>
          <p>&#160;</p>
          <div bxe_xpath="/{$document-element-name}/xhtml:body">
            <xsl:apply-templates select="*/xhtml:body/*"/>
          </div>
        </div>
        <xsl:call-template name="footer"/>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="overview">
    <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
    <div class="contcol2">
      <div class="relatedbox">
        <div bxe_xpath="/{$document-element-name}/unizh:related-content">
          <xsl:apply-templates select="*/unizh:related-content"/>
        </div>
      </div>
      <div class="contentarea">
        <div class="content">
          <h1>
            <div bxe_xpath="/{document-element-nem}/lenya:meta/dc:title">
              <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
            </div>
          </h1>
          <p>&#160;</p>
          <xsl:apply-templates select="*/xhtml:body/*"/>
        </div>
        <xsl:call-template name="footer"/>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="homepage">
    <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
    <xsl:apply-templates select="*/unizh:quicklinks"/>
    <div class="contcol2">
      <div class="relatedbox">
        <div bxe_xpath="/{$document-element-name}/unizh:related-content">
          <xsl:apply-templates select="*/unizh:related-content"/>
        </div>
      </div>
      <div class="contentarea">
        <div class="content">
          <h1>
            <div bxe_xpath="/{document-element-nem}/lenya:meta/dc:title">
              <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
            </div>
          </h1>
          <p>&#160;</p>
          <div bxe_xpath="/{$document-element-name}/xhtml:body">
            <xsl:apply-templates select="*/xhtml:body/*"/>
          </div>
        </div>
        <xsl:call-template name="footer"/>
      </div>
    </div>
  </xsl:template>

 
  <xsl:template name="homepage4columns">
    <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
    <xsl:apply-templates select="*/unizh:quicklinks"/>
    <div class="contcol2">
      <div class="relatedbox">
        <div bxe_xpath="/{$document-element-name}/unizh:related-content">
          <xsl:apply-templates select="*/unizh:related-content"/>
        </div>
      </div>
      <div class="contentarea">
        <div class="content">
          <xsl:apply-templates select="*/xhtml:body/*"/>
        </div>
        <xsl:call-template name="footer"/>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="newsitem">
    <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
    <div class="contcol2">
      <div class="relatedbox">
        <div bxe_xpath="/{$document-element-name}/unizh:related-content">
          <xsl:apply-templates select="unizh:newsitem/unizh:related-content"/>
        </div> 
      </div> 
      <div class="contentarea">
        <div class="content">
          <p class="lead"><xsl:value-of select="unizh:newsitem/lenya:meta/dcterms:created"/></p> 
          <h2>
            <div bxe_xpath="/{document-element-nem}/lenya:meta/dc:title">
              <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
            </div>
          </h2>
          <h3><xsl:value-of select="unizh:newsitem/lenya:meta/dc:creator"/></h3>
          <p>&#160;</p>
          <xsl:if test="$area = 'authoring'">
            <div class="editview" bxe_xpath="/unizh:newsitem/unizh:short" id="short">
              <xsl:apply-templates select="unizh:newsitem/unizh:short/*"/>
            </div>
            <br class="floatclear"/>
          </xsl:if>
          <div bxe_xpath="/{$document-element-name}/xhtml:body">
            <xsl:apply-templates select="*/xhtml:body/*"/>
            <p>&#160;</p>
            <xsl:apply-templates select="/document/xhtml:div[@id = 'link-to-parent']"/>
            <div class="solidline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1" /></div>
            <xsl:apply-templates select="*/unizh:level"/>
          </div>
        </div>
        <xsl:call-template name="footer"/>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="person">
    <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
    <div class="contcol2">
      <!-- <div class="relatedbox">
        <div bxe_xpath="/{$document-element-name}/unizh:related-content">
          <xsl:apply-templates select="*/unizh:related-content"/>
        </div>
      </div> -->
      <div class="contentarea">
        <div class="content">
          <h1>
            <div bxe_xpath="/{document-element-nem}/lenya:meta/dc:title">
              <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
            </div>
          </h1>
          Vorname:
          <div bxe_xpath="/{$document-element-name}/unizh:firstname">
            <xsl:value-of select="unizh:person/unizh:firstname"/>
          </div>
          <br/>
          Nachname:
          <div bxe_xpath="/{$document-element-name}/unizh:lastname">
            <xsl:value-of select="unizh:person/unizh:lastname"/>
          </div>
          <br/>
          Grad:
          <div bxe_xpath="/{$document-element-name}/unizh:academictitle">
            <xsl:value-of select="unizh:person/unizh:academictitle"/>
          </div>
          <br/>
          Funktion:
          <div bxe_xpath="/{$document-element-name}/unizh:position">
            <xsl:value-of select="unizh:person/unizh:position"/>
          </div>
          <br/>
          Unit:
          <div bxe_xpath="/{$document-element-name}/unizh:unit">
            <xsl:value-of select="unizh:person/unizh:unit"/>
          </div>
          <br/>
          Email:
          <div bxe_xpath="/{$document-element-name}/unizh:email">
            <xsl:value-of select="unizh:person/unizh:email"/>
          </div>
          <br/>
          Homepage:
          <div bxe_xpath="/{$document-element-name}/unizh:url">
            <xsl:value-of select="unizh:person/unizh:url"/>
          </div>
          <br/>
          Bemerkungen:
          <div bxe_xpath="/{$document-element-name}/unizh:remarks">
            <xsl:value-of select="unizh:person/unizh:remarks"/>
          </div>
          <p>&#160;</p>
        </div>
        <xsl:call-template name="footer"/>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="redirect">
    <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
    <div class="contcol2">
      <div class="contentarea">
        <div class="content">
          <h1>
            <div bxe_xpath="/{document-element-nem}/lenya:meta/dc:title">
              <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
            </div>
          </h1>
          <p>&#160;</p>
          <xsl:apply-templates select="*/xhtml:body/*"/>
        </div>
        <xsl:call-template name="footer"/>
      </div>
    </div>
  </xsl:template>



  <xsl:template match="unizh:column[1]">
    <div class="content1" bxe_xpath="/{$document-element-name}/xhtml:body/unizh:column[1]">
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="unizh:column[2]">
    <div class="content2" bxe_xpath="/{$document-element-name}/xhtml:body/unizh:column[2]">
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template> 
  
</xsl:stylesheet>
