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
          <div id="col1">
            <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
            <xsl:apply-templates select="/document/unizh:contcol1"/>
          </div>
          <div class="contcol2">
            <div class="content">
              <h1> 
                <div bxe_xpath="/{document-element-name}/lenya:meta/dc:title">
                  <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
                </div>
              </h1>
              <xsl:apply-templates select="/document/xhtml:form[@id = 'search']"/>
              <xsl:apply-templates select="/document/xhtml:div[@id = 'exception']"/>
              <xsl:apply-templates select="/document/xhtml:div[@id = 'results']"/>
              <xsl:apply-templates select="/document/xhtml:div[@id = 'pages']"/>
            </div>
            <xsl:call-template name="footer"/>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="xhtml:div[@id = 'toolnav']">
    <div id="toolnav">
      <div class="icontextpos">
        <div id="icontext">&#160;</div>
      </div>
      <xsl:for-each select="xhtml:div[@class='language']">
        <a href="{@href}"><xsl:value-of select="translate(., 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/></a> |
      </xsl:for-each>
      <a href="#" onClick="window.open('{xhtml:div[@id = 'print']/@href}?{$querystring}', '', 'width=700,height=700,menubar=yes,scrollbars')" onmouseout="changeIcontext('')" onmouseover="changeIcontext('{xhtml:div[@id = 'print']}')"><img src="{$imageprefix}/icon_print.gif" alt="{xhtml:div[@id = 'print']}" width="10" height="10" border="0" /></a> |
      <a onmouseout="changeIcontext('')" onmouseover="changeIcontext('{xhtml:div[@id = 'fontsize']}')">
        <xsl:attribute name="id">switchFontSize</xsl:attribute>
        <img src="{$imageprefix}/icon_bigfont.gif" alt="{xhtml:div[@id = 'fontsize']}" border="0" width="18" height="9"/></a> |
      <a href="{xhtml:div[@id = 'simpleview']/@href}" onmouseout="changeIcontext('')" onmouseover="changeIcontext('{xhtml:div[@id = 'simpleview']}')"><img src="{$imageprefix}/icon_pda.gif" alt="{xhtml:div[@id = 'simpleview']}" width="18" height="9" border="0" /></a>
    </div>
    <div class="floatclear"><xsl:comment/></div>
  </xsl:template>

  <xsl:template match="xhtml:form[@id = 'search']">
    <form id="formsearchcontent">
      <div class="searchtextblock">
        <input class="searchfield" type="text" name="queryString" value="{xhtml:input[@name='queryString']/@value}"/>
        <input class="submitbutton" type="submit" name="sa">
          <xsl:attribute name="value">
            <xsl:choose>
              <xsl:when test="$language = 'de'">Suchen</xsl:when>
              <xsl:otherwise>Search</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </input> 
      </div>
      <div>
        <a href="http://www.google.com/u/unizh?hl=de&amp;ie=ISO-8859-1&amp;domains=unizh.ch&amp;q={xhtml:input[@name='queryString']/@value}&amp;btnG=Suche&amp;sitesearch=unizh.ch" >
         <xsl:choose>
           <xsl:when test="$language = 'de'">Suchen auf "www.unizh.ch"</xsl:when>
           <xsl:otherwise>Search domain "www.unizh.ch"</xsl:otherwise>
         </xsl:choose>
         </a>
      </div>
      
      <!-- <xsl:apply-templates select="xhtml:input[@name = 'publication-id']"/>  -->
      <xsl:apply-templates select="xhtml:input[@type = 'hidden']"/>
      <div class="endheaderline">
        <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
      </div>
    </form>
  </xsl:template>


  <xsl:template match="xhtml:input[@type = 'radio' and @name = 'publication-id']">
    <div class="searchoptionblock">
      <input class="searchoption" type="radio" name="{@name}" value="{@value}">
        <xsl:if test="@checked">
           <xsl:attribute name="checked">checked</xsl:attribute>
        </xsl:if>
      </input>
      <xsl:value-of select="."/>
    </div>
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


  <xsl:template match="xhtml:div[@id = 'exception']">
    <xsl:value-of select="."/>
  </xsl:template>


  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template> 
  
</xsl:stylesheet>
