<?xml version="1.0" encoding="UTF-8" ?>


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
  xmlns:index="http://apache.org/cocoon/lenya/documentindex/1.0"
  xmlns:level="http://apache.org/cocoon/lenya/documentlevel/1.0"
  xmlns:ci="http://apache.org/cocoon/include/1.0"
  xmlns:xi="http://www.w3.org/2001/XInclude"
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
<xsl:param name="publication-id"/>

<xi:include href="../doctypes/variables.xsl#xpointer(/*/*)"/>
<xsl:template match="/">

<html>
  <head>
    <title>
      Apache Lenya |
      <xsl:value-of select="$publicationid"/> |
      <xsl:value-of select="$area"/> |
      <xsl:value-of select="$nodeid"/>.html |
       <xsl:value-of select="**/lenya:meta/dc:title"/>
     </title>
     <script src="/lenya/menu/menu.js" type="text/javascript"><xsl:comment/> </script>
     <style type="text/css">
        @import url("<xsl:value-of select="$root"/><xsl:value-of select="$publication-id"/>/authoring/content-neutron.css");
        @import url("<xsl:value-of select="$root"/><xsl:value-of select="$publication-id"/>/authoring/css/institute.css");
      </style>
      <script src="{$root}unizh/authoring/javascript/uni.js" type="text/javascript"> </script>
  </head>
    
  <body>
    <div class="bodywidth">
      <a href="#navigation" title="Zur Navigation springen" accesskey="1"><xsl:comment/></a>
      <a href="#content" title="Zum Inhalt springen" accesskey="2"><xsl:comment/></a>
      <a name="top"><xsl:comment/></a>
      <div id="breadcrumbnav"><a href="http://www.unizh.ch">Universität Zürich</a>
       &gt;<a href="#"><xsl:value-of select="$publicationid"/></a>
      </div>
     
     <div id="headerarea">
       <div style="float:right;width:195px;">
         <div class="imgunilogo"><a href="http://www.unizh.ch">
           <img height="45" width="180" alt="unizh logo" src="{$root}{$publication-id}/authoring/images/logo_de.gif" /></a>
         </div>
         <div class="imginstitute">
           <img height="45" width="180" alt="institute's picture" src="{$root}{$publication-id}/authoring/images/key-visual.jpg" />
         </div>
       </div>
       <div id="headertitelpos">
         <div id="servicenavpos">
           <a accesskey="0" href="#">Home</a>
           <label for="formsearch">:</label>
           <form method="get" action="" id="formsearch">
             <div class="serviceform"><input accesskey="5" name="queryString" type="text" /></div>
             <div class="serviceform"><a href="javascript:document.forms['formsearch'].submit();">go!</a></div>
           </form>
         </div>
         <div>
           <h2>
             <xsl:choose>
               <xsl:when test="**/unizh:header">
                 <xsl:value-of select="**/unizh:header/unizh:superscription"/>
               </xsl:when>
               <xsl:otherwise>
                Universität Zürich   
               </xsl:otherwise>
			</xsl:choose>
           </h2>
         </div>
         <h1>
           <span>
             <a href="#">
               <xsl:choose>
                 <xsl:when test="**/unizh:header">
                   <xsl:value-of select="**/unizh:header/unizh:heading"/>
                 </xsl:when>
                 <xsl:otherwise>
                   <xsl:value-of select="$publicationid"/>
                 </xsl:otherwise>
               </xsl:choose>
             </a>
           </span>
         </h1>
       </div>
     </div> 
     <div class="floatclear"><xsl:comment/></div>
     
     <div id="primarnav"><xsl:comment/></div>
     <div class="floatclear"><xsl:comment/></div>
     <div class="endheaderline">
        <img height="1" width="1" alt="separation line" src="{$root}unizh/authoring/images/1.gif" />
     </div> 
      <div id="toolnav">
        <div class="icontextpos">
          <div id="icontext"><xsl:comment/></div>
        </div>
        <a onmouseover="changeIcontext('Diese Seite drucken')" onmouseout="changeIcontext('')" onClick="window.open('index_de.print.html', '', 'width=700,height=700,menubar=yes,scrollbars')" href="#">
          <img height="10" width="10" alt="Diese Seite drucken" src="{$root}unizh/authoring/images/icon_print.gif" />
        </a> |
        <a href="?fontsize=big" onmouseover="changeIcontext('Schrift grösser/kleiner')" onmouseout="changeIcontext('')" id="switchFontSize">
          <img height="9" width="18" alt="Schrift grösser/kleiner" src="{$root}unizh/authoring/images/icon_bigfont.gif" />
        </a> |
        <a onmouseover="changeIcontext('PDA-optimierte Ansicht')" onmouseout="changeIcontext('')" href="?version=simple">
          <img height="9" width="18" alt="PDA-optimierte Ansicht" src="{$root}unizh/authoring/images/icon_pda.gif" />
        </a>
      </div>
      <div class="floatclear"><xsl:comment/></div> 
      <div id="col1">
        <div id="secnav">
          <a name="navigation" accesskey="1"><xsl:comment/></a>
          <div class="solidline">
            <img height="1" width="1" alt="separation line" src="{$root}unizh/authoring/images/1.gif" />
          </div>
          <ul>
            <li>
              <a href="#">Menu Item</a>
              <div class="dotline">
                <img height="1" width="1" alt="separation line" src="{$root}unizh/authoring/images/1.gif" />
              </div>
            </li>
            <li>
              <a href="#">Menu Item</a>
              <div class="dotline">
                <img height="1" width="1" alt="separation line" src="{$root}unizh/authoring/images/1.gif" />
              </div>
            </li>
          </ul>
        </div>
      </div>
      <div class="contcol2">
        <div class="relatedbox">
          <div class="relatedboxborder">
            <xsl:apply-templates select="*/unizh:related-content"/> 
          </div>
        </div>
        <div class="contentarea">
          <a class="namedanchor" name="content" accesskey="2"><xsl:comment/></a>
          <div class="content">
            <h1>
              <div><xsl:value-of select="//dc:title"/><xsl:comment/></div>
            </h1>
            <div>
             <xsl:apply-templates select="//xhtml:body/*"/> 
            </div>
          </div>
            <div class="footermargintop"><xsl:comment/></div>
            <div class="topnav"><a href="#top">top</a></div>
            <div class="solidline">
              <img height="1" width="1" alt="separation line" src="{$root}unizh/authoring/images/1.gif" />
            </div>
            <div id="footer">© 2005 Universität Zürich | <a href="" /><xsl:comment/></div>
          </div>
        </div> 
      </div>
    </body>  
  </html> 
</xsl:template>

<xi:include href="../common/elements.xsl#xpointer(/*/*)"/>


</xsl:stylesheet> 
