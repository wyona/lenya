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
            <xsl:for-each select="/document/xhtml:div[@id = 'toolnav']/xhtml:div[@class='language']">
              | <a href="{@href}"><xsl:value-of select="translate(., 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/></a> 
            </xsl:for-each>
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
            <xsl:apply-templates select="/document/xhtml:form[@id = 'search']"/>
	    <xsl:apply-templates select="/document/xhtml:div[@id = 'results']"/>
            <p>&#160;</p>
            <xsl:apply-templates select="*/xhtml:body/*"/> 
            <br/> 
          </div>
          <div class="line"><xsl:comment/></div>
          <xsl:if test="not(/document/content/xhtml:html[@unizh:columns = 1 or @unizh:columns = 2])">
            <xsl:apply-templates select="*/unizh:related-content"/>
          </xsl:if>
          <div class="topnav"><a href="#top">top</a></div>
          <div class="footermargintop"><xsl:comment/></div>
          <div class="solidline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/></div>
          <div id="footer"><a href="">Hilfe</a> | <a href="sitemap.htm">Sitemap</a> | <a href="">Kontakt</a></div>  
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="xhtml:form[@id = 'search']">
    <form id="formsearchcontent">
      <div class="searchtextblock">
        <input type="hidden" name="version" value="simple"/>
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

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template> 
  
</xsl:stylesheet>
