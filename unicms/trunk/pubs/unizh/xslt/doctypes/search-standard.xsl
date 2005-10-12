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


  <xsl:template match="xhtml:form[@id = 'search']">
    <form id="formsearchcontent">
      <div class="searchtextblock">
        <input class="searchfield" type="text" name="queryString" value="{xhtml:input[@name='queryString']/@value}"/>
        <input class="submitbutton" type="submit" name="sa" value="{xhtml:input[@name='sa']/@value}"/> 
      </div>
      <xsl:apply-templates select="xhtml:input[@name = 'publication-id']"/>
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
    <h1><xsl:apply-templates select="xhtml:h1"/></h1>
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
