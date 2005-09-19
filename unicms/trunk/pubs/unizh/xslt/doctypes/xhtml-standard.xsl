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
        <xsl:comment>
          <xsl:choose>
            <xsl:when test="$rendertype = 'big'">
              @import url("<xsl:value-of select="$contextprefix"/>/unizh/authoring/css/big.css");
            </xsl:when>
            <xsl:otherwise>
              @import url("<xsl:value-of select="$contextprefix"/>/unizh/authoring/css/main.css");
            </xsl:otherwise>
          </xsl:choose>
        </xsl:comment>
      </style>
    </head>
    <body>
      <div class="bodywidth">
        <a name="top"><xsl:comment/></a>
        <xsl:apply-templates select="/document/xhtml:div[@id = 'breadcrumb']"/>
        <!-- header -->
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

        <xsl:apply-templates select="/document/xhtml:div[@id = 'toolnav']"/>

        <!-- menu -->
        <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
         <xsl:apply-templates select="*/unizh:quicklinks"/> 
        <!-- teasers -->
        <div class="contcol2">
          <div class="relatedbox">
            <xsl:if test="*/unizh:related-content/*">
              <div bxe_xpath="/{$document-element-name}/unizh:related-content">
                <xsl:apply-templates select="*/unizh:related-content"/> 
              </div>
            </xsl:if> 
          </div>
          <!-- body --> 
          <div class="contentarea">
	    <div class="content">
              <xsl:if test="not($document-element-name = 'unizh:homepage4cols')">
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
                  <div bxe_xpath="/{$document-element-name}/xhtml:body" class="bxecontent">
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
            <div class="topnav"><a href="#top">top</a></div>
            <div class="solidline"><img src="/lenya/unizh/authoring/images/1.gif" alt="separation line" width="1" height="1" border="0" /></div>
            <div id="footer">&#169; 2005 Universit&#228;t Z&#252;rich | <a href="{/document/xhtml:div[@id = 'footnav']/xhtml:div[@id = 'impressum']/@href}"><xsl:value-of select="/document/xhtml:div[@id = 'footnav']/xhtml:div[@id = 'impressum']"/></a></div>
          </div>
        </div> 
      </div>
    </body>
  </html>
</xsl:template>
 

<xsl:template match="unizh:column[1]">
  <div class="content1">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="unizh:column[2]">
  <div class="content2">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="unizh:lead">
  <xsl:apply-templates/>
  <p>&#160;</p>
</xsl:template>

<xsl:template match="unizh:links">
  <div class="solidline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  /></div>
  <ul class="linknav">
    <li>
      <a href="{unizh:title/@href}">
        <img src="{$imageprefix}/arrow2.gif" alt="icon arrow" width="13" height="14"  />
        <b><xsl:value-of select="unizh:title"/></b>
      </a>
      <div class="dotline">
        <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  />
      </div>
    </li>
    <xsl:for-each select="xhtml:a">
      <li>
        <a href="{@href}">
          <img src="{$imageprefix}/arrow2.gif" alt="icon arrow" width="13" height="14"  />
          <xsl:value-of select="."/>
        </a>
        <div class="dotline">
          <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  />
        </div>
      </li>
    </xsl:for-each>
  </ul>
  <p>&#160;</p>
</xsl:template>



<xsl:template match="xhtml:div[@id = 'servicenav']">
  <div id="servicenavpos">
    <xsl:for-each select="xhtml:div[position() &lt; last()]">
      <a href="{@href}"><xsl:value-of select="."/></a> 
      <xsl:if test="position() &lt; last()">|</xsl:if>
    </xsl:for-each>
    <form id="formsearch" action="" method="post" enctype="text/plain">
      <div class="servieceform"> 
        <input type="text" name="searchtext"/>
      </div>
      <div class="servieceform">
        <a href="javascript:document.forms['formsearch'].submit();">Suche</a>
      </div>
    </form>
  </div> 
</xsl:template>

<xsl:template match="xhtml:div[@id = 'toolnav']">
  <div id="toolnav">
      <a href="{xhtml:div[@id = 'language']/@href}"><xsl:value-of select="xhtml:div[@id = 'language']"/></a> |
      <a href="{xhtml:div[@id = 'print']/@href}"><img src="/lenya/unizh/authoring/images/icon_print.gif" alt="icon print link " width="10" height="10" border="0" /></a> |
      <a href="#"><img src="/lenya/unizh/authoring/images/icon_bigfont.gif" alt="icon bigfont link" border="0" width="16" height="10"/></a> | 
      <a href="{xhtml:div[@id = 'pda']/@href}"><img src="/lenya/unizh/authoring/images/icon_pda.gif" alt="icon pda link" width="14" height="10" border="0" /></a>
  </div>
</xsl:template>


<xsl:template match="xhtml:div[@id = 'menu']">
  <div id="secnav"> 
    <div class="solidline">
      <img src="/lenya/unizh/authoring/images/1.gif" alt="separation line" width="1" height="1" border="0" />
    </div>
    <ul>
      <xsl:apply-templates select="xhtml:div"/>
    </ul>
  </div>
</xsl:template>


<xsl:template match="xhtml:div[ancestor::xhtml:div[@id = 'menu']]">
  <li>
    <a href="{@href}">
      <xsl:if test="@current = 'true'">
        <xsl:attribute name="class">activ</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="text()"/>
    </a>
    <xsl:if test="xhtml:div">
      <ul>
        <xsl:apply-templates select="xhtml:div"/>
      </ul>
    </xsl:if>
    <xsl:if test="parent::xhtml:div[@id = 'menu']">
      <div class="dotline">
        <img src="/lenya/unizh/authoring/images/1.gif" alt="separation line" width="1" height="1" border="0" />
      </div>
    </xsl:if>
  </li>
</xsl:template>


<xsl:template match="unizh:quicklinks">
  <div id="col1">
    <div bxe_xpath="/{$document-element-name}/unizh:quicklinks">
      <div class="solidline">
        <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  />
      </div>
      <p class="titel"><xsl:value-of select="@label"/></p>
      <div class="dotlinelead">
        <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  />
      </div>
      <xsl:for-each select="unizh:quicklink">
        <xsl:apply-templates select="xhtml:p"/>
        <ul>
          <xsl:for-each select="xhtml:a">
            <li>
              <a href="{@href}"><xsl:value-of select="."/></a>
            </li>
          </xsl:for-each>
        </ul>
        <div class="dotline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  /></div>
      </xsl:for-each> 
    </div>
  </div>
</xsl:template>


<xsl:template match="xhtml:div[@id = 'tabs']">
  <div id="primarnav"><xsl:comment/>
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
