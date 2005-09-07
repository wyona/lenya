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
        @import url("/lenya/unizh/authoring/css/main.css");
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
            <div id="servicenavpos">
              <form action="">
                <a href="">Home</a> | 
                <a href="">Kontakt</a> | 
                <a href="">Sitemap</a> 
                <input type="text" name="" /> 
                <a href="">Suche</a>
              </form>
            </div>
            <!-- header -->
            <div class="headtitelmargintop"><xsl:comment/></div>
            <h2><xsl:value-of select="/document/unizh:header/unizh:superscription"/></h2>
            <h1><xsl:value-of select="/document/unizh:header/unizh:heading"/></h1>
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
        <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/> 
        <!-- teasers -->
        <div class="contcol2">
          <div class="relatedbox">
            <div id="toolnav">
              <a href="">English</a> | 
              <a href=""><img src="/lenya/unizh/authoring/images/icon_print.gif" alt="icon print link " width="10" height="10" border="0" /></a> | 
              <a href=""><img src="/lenya/unizh/authoring/images/icon_lupe.gif" alt="icon lupe link" width="10" height="11" border="0" /></a>
            </div> 
            <xsl:apply-templates select="*/unizh:highlights/unizh:highlight"/> 
          </div>
          <!-- body --> 
          <div class="contentarea">
          <div class="contmargintop"><xsl:comment/></div>
	    <div class="content">
              <xsl:apply-templates select="*/xhtml:body/*"/>
            </div>
            <!-- footer -->
            <div class="footermargintop"><xsl:comment/></div>
            <div class="solidline"><img src="/lenya/unizh/authoring/images/1.gif" alt="separation line" width="1" height="1" border="0" /></div>
            <div id="footer">&#169; 2005 Universitt Zich | <a href="">Impressum</a></div>
          </div>
        </div> 
      </div>
    </body>
  </html>
</xsl:template>
 
 
<xsl:template match="xhtml:div[@id = 'menu']"> 
  <!--  <a href="{@href}"> <xsl:value-of select="@label"/> </a> -->
  <div id="secnav">
    <div class="contmargintop"><xsl:comment/></div>
    <div class="solidline"><img src="/lenya/unizh/authoring/images/1.gif" alt="separation line" width="1" height="1" border="0" /></div>
    <ul>
      <xsl:apply-templates select="xhtml:div" mode="menu"/>
    </ul>
  </div>        
</xsl:template>

 
<xsl:template match="xhtml:div" mode="menu">
  <li>
    <a href="{@href}"><xsl:value-of select="."/></a>
    <div class="dotline">
      <img src="/lenya/unizh/authoring/images/1.gif" alt="separation line" width="1" height="1" border="0" />
    </div>
  </li>
  <xsl:apply-templates select="xhtml:div" mode="menu"/>
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
    <xsl:for-each select="xhtml:div">
       <a href="{@href}"><xsl:value-of select="."/></a> 
       <xsl:if test="position &lt; last()">&gt;</xsl:if>
    </xsl:for-each>
  </div> 
</xsl:template>

<xsl:template match="@*|node()" priority="-1">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template> 

</xsl:stylesheet>
