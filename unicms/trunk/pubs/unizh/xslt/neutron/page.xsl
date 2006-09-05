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
        @import url("http://localhost:8888/unitemplate/authoring/content-neutron.css");
        @import url("http://localhost:8888/unitemplate/authoring/css/institute.css");
      </style>
      <script src="http://localhost:8888/unizh/authoring/javascript/uni.js" type="text/javascript"> </script>
  </head>
    
  <body>
    <div class="bodywidth">
      <a href="#navigation" title="Zur Navigation springen" accesskey="1"><xsl:comment/></a>
      <a href="#content" title="Zum Inhalt springen" accesskey="2"><xsl:comment/></a>
      <a name="top"><xsl:comment/></a>
      <xsl:apply-templates select="/xhtml:document/xhtml:div[@id = 'breadcrumb']"/>
     
     <div id="headerarea">
       <div style="float:right;width:195px;">
         <div class="imgunilogo"><a href="http://www.unizh.ch">
           <img height="45" width="180" alt="unizh logo" src="{$localsharedresources}/images/logo_de.gif" /></a>
         </div>
         <div class="imginstitute">
           <img height="45" width="180" alt="institute's picture" src="{$localsharedresources}/images/key-visual.jpg" />
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
        <img height="1" width="1" alt="separation line" src="{$imageprefix}/1.gif" /> 
     </div>
     <!-- FIXME: fix toolnav code for mozilla --> 
     <div id="toolnav">
       <div class="icontextpos">
         <div id="icontext"> <xsl:comment/></div>
       </div>
       <a href="/unitemplate/authoring/index_en.html">EN</a> |
       <a href="#">
         <img height="10" width="10" alt="Diese Seite drucken" src="{$imageprefix}/icon_print.gif" />
       </a> |
       <a href="?fontsize=big">
         <img height="9" width="18" alt="Schrift grösser/kleiner" src="{$imageprefix}/icon_bigfont.gif" />
       </a> |
       <a href="#">
         <img height="9" width="18" alt="PDA-optimierte Ansicht" src="{$imageprefix}/icon_pda.gif" />
       </a>
     </div>
     
      <div class="floatclear"><xsl:comment/></div> 
      <div id="col1">
        <xsl:apply-templates select="/xhtml:document/xhtml:div[@id = 'menu']"/>
      </div>
      <div class="contcol2">
        <div class="relatedbox">
          <xsl:apply-templates select="/xhtml:document/xhtml:content/*/unizh:related-content"/> 
        </div>
        <div class="contentarea">
          <a class="namedanchor" name="content" accesskey="2"><xsl:comment/></a>
          <div class="content">
            <h1>
              <div><xsl:value-of select="/xhtml:document/xhtml:content/*/lenya:meta/dc:title"/><xsl:comment/></div>
            </h1>
            <div>
             <xsl:apply-templates select="/xhtml:document/xhtml:content/*/xhtml:body/*"/> 
            </div>
          </div>
            <div class="footermargintop"><xsl:comment/></div>
            <div class="topnav"><a href="#top">top</a></div>
            <div class="solidline">
              <img height="1" width="1" alt="separation line" src="http://localhost:8888/unizh/authoring/images/1.gif" />
            </div>
            <div id="footer">© 2005 Universität Zürich | <a href="" /><xsl:comment/></div>
          </div>
        </div> 
      </div>
    </body>  
  </html> 
</xsl:template>


</xsl:stylesheet> 
