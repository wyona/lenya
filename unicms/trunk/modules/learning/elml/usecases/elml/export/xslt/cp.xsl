<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id:cp.xsl 14018 2006-06-08 20:54:03Z thomas $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
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
  <xsl:param name="superscription"/>
  <xsl:param name="heading"/>

  <xsl:variable name="imageprefix" select="concat($contextprefix, '/unizh/authoring/images')"/>
  <xsl:variable name="localsharedresources" select="concat(substring-before($root, $area), 'authoring')"/>
  <xsl:include href="../../../../../unizh/xslt/doctypes/variables.xsl"/>
  <xsl:include href="../../../../../unizh/xslt/common/elml.xsl"/>
  <xsl:include href="../../../../../unizh/xslt/common/elements.xsl"/>
  <xsl:include href="../../../../../unizh/xslt/common/elml-object.xsl"/>

  <xsl:template match="document">
    <xsl:apply-templates select="content"/>
  </xsl:template>


  <xsl:template match="content"> 
    <html>
      <head>
        <title>UZH - <xsl:value-of select="/document/content/*/unizh:header/unizh:heading"/> - <xsl:value-of select="*/lenya:meta/dc:title"/>
        </title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
        <link rel="stylesheet" type="text/css" href="{$contextprefix}/unizh/authoring/css/main.css"/>
        <link rel="stylesheet" type="text/css" href="{$localsharedresources}/css/institute.css"/>
        <script type="text/javascript" src="{$contextprefix}/unizh/authoring/javascript/uni.js"/>
        <script xmlns:xhtml="http://www.w3.org/1999/xhtml" src="{$contextprefix}/unizh/authoring/javascript/elml.js" type="text/javascript"/>
      </head>
      <body>
        <div class="bodywidth">
          <a accesskey="1" title="Zur Navigation springen" href="#navigation"><xsl:comment/></a>
          <a accesskey="2" title="Zum Inhalt springen" href="#content"><xsl:comment/></a>
          <a name="top"><xsl:comment/></a>
          <!--      <div id="headerarea">
            <div style="float:right;width:195px;">
              <div class="imgunilogo">
                <a href="http://www.unizh.ch">
                  <img src="{$localsharedresources}/images/logo_{$language}.gif" alt="unizh logo" width="180" height="45" border="0" /> 
                </a>
              </div>
              <div class="imginstitute">
                <img src="{$localsharedresources}/images/key-visual.jpg" alt="institute's picture" width="180" height="45" border="0" /> 
              </div>
            </div>
            <div id="headertitelpos">
              <div id="servicenavpos">&#160;</div>
              <h2>
                <xsl:value-of select="$superscription"/>
              </h2>
              <h1>
                <xsl:value-of select="$heading"/>
              </h1>
            </div>
          </div>
          <div class="floatclear"><xsl:comment/></div>
          <div id="primarnav">&#160;</div>
          <div class="floatclear"><xsl:comment/></div>
          <div class="endheaderline">
            <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
          </div> -->
          <div id="toolnav">
            <div class="icontextpos">&#160;
              <div id="icontext">&#160;</div> 
            </div>
          </div>
          <div class="floatclear"><xsl:comment/></div>
          <xsl:call-template name="content"/>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="content">
    <a accesskey="2" name="content" class="namedanchor"><xsl:comment/></a>
    <h1>
      <xsl:choose>
        <xsl:when test="/document/content/*/@title">
          <xsl:value-of select="/document/content/*/@title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
        </xsl:otherwise>
      </xsl:choose>
    </h1> 
    <xsl:apply-templates select="/document/content/*"/> 
    <!-- <xsl:call-template name="footer"/> -->
  </xsl:template>

</xsl:stylesheet>
