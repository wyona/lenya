<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: xhtml-standard.xsl,v 1.11 2005/01/17 09:15:14 thomas Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:uz="http://unizh.ch"
  >
  
  <xsl:param name="contextprefix"/>
  <xsl:param name="area"/>
  <xsl:param name="rendertype"/>
  <xsl:param name="defaultlanguage"/>
  <xsl:param name="language"/>
  <xsl:param name="nodeid"/>

  <xsl:include href="../doctypes/variables.xsl"/>
  <xsl:include href="../common/elements.xsl"/> 

  <xsl:template match="document">
    <xsl:apply-templates select="content"/>
  </xsl:template>
  
<xsl:template match="content"> 
  <html>
    <head>
      <title><xsl:value-of select="*/lenya:meta/dc:title"/></title>
      <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
      <style type="text/css">
        @import url("<xsl:value-of select="$contextprefix"/>/unizh/authoring/css/main.css");
      </style>
    </head>
    <body>
      <div class="bodywidth">
        <xsl:apply-templates select="/document/xhtml:div[@id = 'breadcrumb']"/>
        <div id="headerarea">
          <div style="float:right;width:195px;">
            <div class="imgunilogo">
              <img src="/lenya/unizh/authoring/images/logo.jpg" alt="unizh logo" width="180" height="45" border="0" />
            </div>
            <div class="imginstitute">
              <img src="/lenya/unizh/authoring/images/uniimg.jpg" alt="uni picture" width="180" height="45" border="0" />
            </div>
          </div>
          <div id="headertitelpos">
            <xsl:apply-templates select="/document/xhtml:div[@id = 'servicenav']"/>
            <!-- header -->
            <div class="headtitelmargintop"><xsl:comment/></div>
            <xsl:choose>
              <xsl:when test="$document-element-name = 'unizh:homepage'">
                <h2>
                  <div bxe_xpath="/unizh:homepage/unizh:header/unizh:superscription">
                    <xsl:value-of select="/document/content/unizh:homepage/unizh:header/unizh:superscription"/>
                  </div>
                </h2>  
                <h1>
                  <div bxe_xpath="/unizh:homepage/unizh:header/unizh:heading">
                    <xsl:value-of select="/document/content/unizh:homepage/unizh:header/unizh:heading"/>
                  </div>
                </h1>
              </xsl:when>
              <xsl:otherwise>
                <h2>
                  <xsl:value-of select="/document/unizh:header/unizh:superscription"/>
                </h2>
                <h1>
                  <xsl:value-of select="/document/unizh:header/unizh:heading"/>
                </h1> 
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </div>
        <div class="floatclear"><xsl:comment/></div>
        <!-- tabs -->
        <xsl:apply-templates select="/document/xhtml:div[@id = 'tabs']"/>
	<div class="floatclear"><xsl:comment/></div>		
	<div class="endheaderline">
          <img src="/lenya/unizh/authoring/images/1.gif" alt="separation line" width="1" height="1" border="0" />
        </div>
        <!-- menu -->
         <div id="secnav">
           <div class="contmargintop"><xsl:comment/></div>
           <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
           <xsl:apply-templates select="*/unizh:quicklinks"/> 
         </div>
        <!-- teasers -->
        <div class="contcol2">
          <div class="relatedbox">
            <xsl:apply-templates select="/document/xhtml:div[@id = 'toolnav']"/>
            <xsl:if test="*/unizh:related-content/*">
              <div bxe_xpath="/{$document-element-name}/unizh:related-content">
                <xsl:apply-templates select="*/unizh:related-content"/> 
              </div>
            </xsl:if> 
          </div>
          <!-- body --> 
          <div class="contentarea">
          <div class="contmargintop"><xsl:comment/></div>
	    <div class="content">
              <xsl:if test="not($document-element-name = 'unizh:homepage')">
                <h1>
                  <div bxe_xpath="/{document-element-nem}/lenya:meta/dc:title">
                    <xsl:value-of select="/document/content/*/lenya:meta/dc:title"/>
                  </div>
                </h1>
                <p>&#160;</p>
              </xsl:if>
              <xsl:if test="$document-element-name = 'unizh:newsitem' and $area = 'authoring'">
                <div bxe_xpath="/{$document-element-name}/unizh:short">
                  <p>
                   <xsl:value-of select="unizh:newsitem/unizh:short/unizh:text"/>
                   <br/>
                   <xsl:if test="not(*/xhtml:body/*)">
                     <xsl:apply-templates select="unizh:newsitem/unizh:short/xhtml:a"/> 
                   </xsl:if>
                  </p>
                  <br/> 
                </div> 
              </xsl:if>
              <xsl:if test="/document/unizh:ancestors/unizh:ancestor[1][unizh:collection]">
                <div bxe_xpath="/{$document-element-name}/unizh:abstract"/>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="$document-element-name = 'unizh:person'">
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
                  <br/>
                </xsl:when>
                <xsl:otherwise>
                  <div bxe_xpath="/{$document-element-name}/xhtml:body">
                    <xsl:apply-templates select="*/xhtml:body/*"/>
                    <br/>
                    <xsl:apply-templates select="/document/xhtml:div[@id = 'link-to-parent']"/>
                    <xsl:apply-templates select="*/unizh:level"/>
                  </div>
                </xsl:otherwise>
              </xsl:choose> 
            </div>
            <!-- footer -->
            <div class="footermargintop"><xsl:comment/></div>
            <div class="solidline"><img src="/lenya/unizh/authoring/images/1.gif" alt="separation line" width="1" height="1" border="0" /></div>
            <div id="footer">&#169; 2005 Universit&#228;t Z&#252;rich | <a href="{/document/xhtml:div[@id = 'footnav']/xhtml:div[@id = 'impressum']/@href}"><xsl:value-of select="/document/xhtml:div[@id = 'footnav']/xhtml:div[@id = 'impressum']"/></a></div>
          </div>
        </div> 
      </div>
    </body>
  </html>
</xsl:template>
 

<xsl:template match="xhtml:div[@id = 'servicenav']">
  <div id="servicenavpos">
    <form action="">
      <xsl:for-each select="xhtml:div[position() &lt; last()]">
        <a href="{@href}"><xsl:value-of select="."/></a> 
        <xsl:if test="position() &lt; last()">|</xsl:if>
      </xsl:for-each>
      <input type="text" name=""><xsl:comment/></input>
      <a href="">Suche</a>
    </form>
  </div> 
</xsl:template>

<xsl:template match="xhtml:div[@id = 'toolnav']">
  <div id="toolnav">
      <a href="{xhtml:div[@id = 'language']/@href}"><xsl:value-of select="xhtml:div[@id = 'language']"/></a> |
      <a href="{xhtml:div[@id = 'print']/@href}"><img src="/lenya/unizh/authoring/images/icon_print.gif" alt="icon print link " width="10" height="10" border="0" /></a> |
      <a href=""><img src="/lenya/unizh/authoring/images/icon_lupe.gif" alt="icon lupe link" width="10" height="11" border="0" /></a>
  </div>
</xsl:template>


<xsl:template match="xhtml:div[@id = 'menu']"> 
  <!--  <a href="{@href}"> <xsl:value-of select="@label"/> </a> -->
    <div class="solidline"><img src="/lenya/unizh/authoring/images/1.gif" alt="separation line" width="1" height="1" border="0" /></div>
    <ul>
      <xsl:apply-templates select="xhtml:div" mode="menu"/>
    </ul>
</xsl:template>

<xsl:template match="unizh:quicklinks">
  <!--  <a href="{@href}"> <xsl:value-of select="@label"/> </a> -->
  <div class="solidline"><img src="/lenya/unizh/authoring/images/1.gif" alt="separation line" width="1" height="1" border="0" /></div>
  <div bxe_xpath="/{$document-element-name}/unizh:quicklinks"><xsl:comment/>
    <xsl:for-each select="xhtml:a">
      <a class="arrow" href="{@href}"><xsl:value-of select="."/></a><br/>
    </xsl:for-each>
  </div>
</xsl:template>

 
<xsl:template match="xhtml:div" mode="menu">
  <li>
    <a href="{@href}">
      <xsl:if test="@current = 'true'">
        <xsl:attribute name="class">activ</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="text()"/>
    </a>
    <xsl:if test="xhtml:div">
      <ul>
        <xsl:apply-templates select="xhtml:div" mode="menu"/>
      </ul>
    </xsl:if>
    <xsl:if test="parent::xhtml:div[@id = 'menu']">
      <div class="dotline">
        <img src="/lenya/unizh/authoring/images/1.gif" alt="separation line" width="1" height="1" border="0" />
      </div>
    </xsl:if>
  </li>
</xsl:template>
  
<xsl:template match="xhtml:div[@id = 'tabs']">
  <div id="primarnav">
    <xsl:for-each select="xhtml:div">
      <a href="{@href}"> <xsl:value-of select="@label"/> </a>
      <xsl:if test="position() &lt; last()">
        <div class="linkseparator">|</div>
      </xsl:if>
    </xsl:for-each>
  </div>
</xsl:template>

<xsl:template match="xhtml:div[@id = 'breadcrumb']">
  <div id="breadclamnav">
    <a href="{@root}"><xsl:value-of select="@label"/></a>  
    <xsl:for-each select="xhtml:div">
       &gt; <a href="{@href}"><xsl:value-of select="."/></a> 
    </xsl:for-each>
  </div> 
</xsl:template>

<xsl:template match="@*|node()" priority="-1">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template> 

</xsl:stylesheet>
