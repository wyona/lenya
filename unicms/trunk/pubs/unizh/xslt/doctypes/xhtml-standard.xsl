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


  <xsl:template name="one-column">
    <xsl:apply-templates select="/document/xhtml:div[@id = 'orthonav']"/>
    <div class="contentarea1col">
    <h1>
      <a accesskey="2" name="content" class="namedanchor"><xsl:comment/></a>
      <div bxe_xpath="/{document-element-}/lenya:meta/dc:title">
        <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
      </div>
    </h1>
    <div bxe_xpath="/{$document-element-name}/xhtml:body">
      <xsl:apply-templates select="*/xhtml:body/*"/>
    </div>
    </div>
  </xsl:template>


  <xsl:template name="two-columns">
    <div id="col1">
      <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
      <xsl:comment/>
    </div>
    <div class="contcol2">
      <xsl:apply-templates select="/document/xhtml:div[@id = 'orthonav']"/>
      <a accesskey="2" name="content" class="namedanchor"><xsl:comment/></a>
      <div class="content">
        <h1>
          <div bxe_xpath="/{$document-element-name}/lenya:meta/dc:title">
            <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
          </div>
        </h1>
        <div bxe_xpath="/{$document-element-name}/xhtml:body">
          <xsl:apply-templates select="*/xhtml:body/*"/>
          <br/>
        </div>
      </div>
      <xsl:call-template name="footer"/>
    </div>
  </xsl:template>


  <xsl:template name="three-columns">
    <div id="col1">
      <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
      <xsl:comment/>
    </div>
    <div class="contcol2">
      <div class="relatedbox" bxe_xpath="/{$document-element-name}/unizh:related-content">
        <xsl:apply-templates select="*/unizh:related-content"/><xsl:comment/>
      </div>
      <xsl:apply-templates select="/document/xhtml:div[@id = 'orthonav']"/>
      <a accesskey="2" name="content" class="namedanchor"><xsl:comment/></a>
      <div class="contentarea">
        <div class="content">
          <h1>
            <div bxe_xpath="/{$document-element-name}/lenya:meta/dc:title">
              <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
            </div>
          </h1>
          <div bxe_xpath="/{$document-element-name}/xhtml:body">
            <xsl:apply-templates select="*/xhtml:body/*"/>
          </div>
        </div>
        <xsl:call-template name="footer"/>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="overview">
    <div id="col1">
      <xsl:if test="unizh:overview[@unizh:menu = 'true']">
        <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
      </xsl:if>
      <xsl:comment/>
    </div>
    <div class="contcol2">
      <div class="relatedbox" bxe_xpath="/{$document-element-name}/unizh:related-content">
        <xsl:apply-templates select="*/unizh:related-content"/><xsl:comment/>
      </div>
      <xsl:apply-templates select="/document/xhtml:div[@id = 'orthonav']"/>
      <div class="contentarea">
        <div class="content">
          <a name="content"><xsl:comment/></a>
          <h1>
            <div bxe_xpath="/{$document-element-name}/lenya:meta/dc:title">
              <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
            </div>
          </h1>
          <xsl:apply-templates select="*/xhtml:body/*"/>
        </div>
        <xsl:call-template name="footer"/>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="homepage">
    <div id="col1">
      <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
      <xsl:apply-templates select="*/unizh:contcol1"/>
    </div>
    <div class="contcol2">
      <div class="relatedbox" bxe_xpath="/{$document-element-name}/unizh:related-content">
        <xsl:apply-templates select="*/unizh:related-content"/><xsl:comment/>
      </div>
      <xsl:apply-templates select="/document/xhtml:div[@id = 'orthonav']"/>
      <div class="contentarea">
        <a accesskey="2" name="content" class="namedanchor"><xsl:comment/></a>
        <div class="content">
          <h1>
            <div bxe_xpath="/{$document-element-name}/lenya:meta/dc:title">
              <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
            </div>
          </h1>
          <div bxe_xpath="/{$document-element-name}/xhtml:body">
            <xsl:apply-templates select="*/xhtml:body/*"/>
          </div>
        </div>
        <xsl:call-template name="footer"/>
      </div>
    </div>
  </xsl:template>

 
  <xsl:template name="homepage4columns">
    <div id="col1">
      <xsl:if test="unizh:homepage4cols[@unizh:menu = 'true']">
        <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
      </xsl:if>
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


  <xsl:template name="newsitem">
    <div id="col1">
      <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
      <xsl:comment/>
    </div>
    <div class="contcol2">
      <div class="relatedbox" bxe_xpath="/{$document-element-name}/unizh:related-content">
        <xsl:apply-templates select="*/unizh:related-content"/><xsl:comment/>
      </div>
      <div class="contentarea">
        <a accesskey="2" name="content" class="namedanchor"><xsl:comment/></a>
        <div class="content">
          <p class="lead">
             <!-- FIXME: just a temporary solution because different time stamps exist for newsitem documents -->
             <xsl:choose>
               <xsl:when test="string-length($creationdate) &lt; '25'">
                 <i18n:date pattern="EEE, d. MMM yyyy HH:mm" src-locale="en" src-pattern="d. MMM yyyy HH:mm" value="{$creationdate}"/> 
               </xsl:when>
               <xsl:otherwise>
                 <i18n:date pattern="EEE, d. MMM yyyy HH:mm" src-locale="en" src-pattern="EEE MMM d HH:mm:ss zzz yyyy" value="{$creationdate}"/>
               </xsl:otherwise>
             </xsl:choose>
          </p>
          <h2>
            <div bxe_xpath="/{$document-element-name}/lenya:meta/dc:title">
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
            <xsl:variable name="fulltext" select="normalize-space(unizh:newsitem/xhtml:body/xhtml:p)"/>
            <xsl:if test="(unizh:newsitem/unizh:short/xhtml:a) and not(($fulltext = '') or ($fulltext = '&#160;'))">
              <h3> <i18n:text>error_newsitem</i18n:text> </h3>
              <br/>
            </xsl:if>
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
    <div id="col1">
      <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
      <xsl:comment/>
    </div>
    <div class="contcol2">
      <!-- <div class="relatedbox">
        <div bxe_xpath="/{$document-element-name}/unizh:related-content">
          <xsl:apply-templates select="*/unizh:related-content"/>
        </div>
      </div> -->
      <div class="contentarea">
        <a accesskey="2" name="content" class="namedanchor"><xsl:comment/></a>
        <div class="content">
          <p>
            <xsl:apply-templates select="/document/xhtml:div[@id = 'link-to-parent']"/>
          </p>
          <div class="solidline">
            <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
          </div>
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
        </div>
        <xsl:call-template name="footer"/>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="unizh:description[parent::unizh:person]">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template name="redirect">
    <div id="col1">
      <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
      <xsl:comment/>
    </div>
    <div class="contcol2">
      <div class="contentarea">
        <div class="content">
          <h1>
            <div bxe_xpath="/{$document-element-name}/lenya:meta/dc:title">
              <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
            </div>
          </h1>
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
