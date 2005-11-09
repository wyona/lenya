<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: elements.xsl,v 1.79 2005/01/17 09:15:15 thomas Exp $ -->
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:index="http://apache.org/cocoon/lenya/documentindex/1.0"
  xmlns:level="http://apache.org/cocoon/lenya/documentlevel/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" 
  xmlns:uz="http://unizh.ch"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:ci="http://apache.org/cocoon/include/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1">
 
  <xsl:param name="root"/>
  <xsl:param name="documentid"/>
  <xsl:param name="contextprefix"/>
  <xsl:param name="rendertype"/>
 
  <xsl:template match="lenya:asset-dot[@class='image']">
    <a href="{@href}"> 
      <img alt="Insert Identity" border="0" src="{$contextprefix}/lenya/images/util/uploadimage.gif"/>  
    </a>&#160;
  </xsl:template>

   <xsl:template match="lenya:asset-dot[@class='image']">
    <a href="{@href}">
      <img alt="Insert Identity" border="0" src="{$contextprefix}/lenya/images/util/uploadimage.gif"/>
    </a>&#160;
  </xsl:template>

  <xsl:template match="lenya:asset-dot[@class='floatImage']">
    <a href="{@href}">
      float
    </a>&#160;
  </xsl:template>


  <xsl:template match="lenya:asset-dot[@class='delete']">
    <a href="{@href}">
      <img alt="Insert Identity" border="0" src="{$imageprefix}/icons/delete.gif"/>
    </a>&#160;
  </xsl:template>

  <xsl:template match="lenya:asset-dot[@class='asset']">
    <a href="{@href}">
      <img alt="Insert Asset" border="0" src="{$contextprefix}/lenya/images/util/uploadasset.gif"/>
    </a>&#160; 
  </xsl:template>
 
 
  <xsl:template match="dc:title">
    <h1>
      <xsl:if test="$rendertype = 'edit'">
        <xsl:attribute name="bxe_xpath">/xhtml:<xsl:value-of select="$document-element-name"/>/lenya:meta/dc:title</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </h1>
  </xsl:template>


  <xsl:template match="xhtml:iframe">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="$querystring">
	  <xsl:attribute name="src"><xsl:value-of select="@src"/>?<xsl:value-of select="$querystring"/></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
	  <xsl:attribute name="src"><xsl:value-of select="@src"/></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*[name() != 'src']"/>
      <xsl:apply-templates/><xsl:comment/>
    </xsl:copy> 
  </xsl:template>


  <xsl:template match="unizh:sitemap">
    <xsl:variable name="sitemap-nodes" select="count(descendant::unizh:node)"/>
    <xsl:variable name="center" select="descendant::unizh:node[round($sitemap-nodes div 2)]"/>
    <div class="content1">
      <xsl:apply-templates select="unizh:node[not(preceding-sibling::unizh:node[descendant-or-self::unizh:node = $center])]"/>
    </div>
    <div class="content2"> 
      <xsl:apply-templates select="unizh:node[preceding-sibling::unizh:node[descendant-or-self::unizh:node = $center]]"/>
    </div>
  </xsl:template>


  <xsl:template match="unizh:node[parent::unizh:sitemap]">
    <div class="navtitel">
      <a href="{$contextprefix}{@href}"><xsl:value-of select="unizh:title"/></a>
    </div>
    <div class="solidline">
      <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
    </div>
    <ul class="sitemap">
      <xsl:apply-templates select="unizh:node" mode="firstlevel"/>
      <xsl:comment/>
    </ul>
    <div>&#160;</div>
  </xsl:template>


  <xsl:template match="unizh:node" mode="firstlevel">
    <li>
      <a href="{$contextprefix}{@href}"><xsl:value-of select="unizh:title"/></a>
      <xsl:if test="unizh:node">
        <ul>
          <xsl:apply-templates select="unizh:node"/>
        </ul>
      </xsl:if>
    </li>
    <div class="dotline">
      <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
    </div>
  </xsl:template>


  <xsl:template match="unizh:node">
     <li>
      <a href="{$contextprefix}{@href}"><xsl:value-of select="unizh:title"/></a>
      <xsl:if test="unizh:node">
        <ul>
          <xsl:apply-templates select="unizh:node"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>



  <xsl:template match="xhtml:p[parent::xhtml:body and $rendertype = 'imageupload']">
    <xsl:copy>
      <xsl:apply-templates select="@*|*[not(self::lenya:asset-dot)]|text()"/>
      <xsl:if test="lenya:asset-dot">
        <hr/>
        <xsl:apply-templates select="lenya:asset-dot"/>
        <br/>
        <br/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="xhtml:p[parent::unizh:lead and $rendertype = 'imageupload']">
    <xsl:copy>
      <xsl:apply-templates select="*[not(self::lenya:asset-dot)]|text()"/>
      <br/>
      <xsl:apply-templates select="lenya:asset-dot"/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="lenya:asset[$rendertype = 'imageupload']">
    <a class="download" href="{lenya:asset-dot/@href}">
      <xsl:value-of select="text()"/>
    </a>
    <br/>
  </xsl:template>


  <xsl:template match="lenya:asset[parent::xhtml:body and $rendertype = 'imageupload']">
    <a class="download" href="{lenya:asset-dot[1]/@href}">
      <xsl:value-of select="text()"/>
    </a>
    <br/>
    <xsl:if test="lenya:asset-dot[2]">
      <hr/>
      <xsl:apply-templates select="lenya:asset-dot[2]"/>
      <br/>
      <br/>
    </xsl:if>
  </xsl:template>


  <xsl:template match="xhtml:a">
    <a class="arrow" href="{@href}">
      <xsl:copy-of select="@target"/>
      <xsl:apply-templates/>
    </a>
  </xsl:template>


  <xsl:template match="xhtml:a[ancestor::unizh:teaser and parent::xhtml:p]">
    <a href="{@href}">
      <xsl:copy-of select="@target"/>
      <xsl:value-of select="text()"/>
    </a>
  </xsl:template>


  <xsl:template match="xhtml:a[normalize-space(.) = '' and @name != '']">
    <a name="{@name}"/><xsl:comment/>
  </xsl:template>

  
  <xsl:template match="xhtml:a[starts-with(@href, 'mailto:')]">
    <script language="javascript">
      <xsl:comment>
           var mailtouser = "<xsl:value-of select="substring-before(@href , '@')"/>"; 
           var hostname = "<xsl:value-of select="substring-after(@href, '@')"/>"; 
           var linktext = "<xsl:value-of select="."/>";
           <![CDATA[ 
             document.write("<a href=" + mailtouser + "@" + hostname + ">" + linktext + "</a>");
           ]]>
      </xsl:comment> 
    </script>
  </xsl:template>


  <xsl:template match="unizh:attention">
    <span class="attention">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <xsl:template match="unizh:related-content">
    <xsl:apply-templates/><xsl:comment/>
  </xsl:template>


  <xsl:template match="unizh:teaser">
    <div class="relatedboxborder">
      <div class="relatedboxcont">
        <xsl:if test="xhtml:object">
          <xsl:apply-templates select="xhtml:object"/>
          <br/>
        </xsl:if>
        <b><xsl:value-of select="unizh:title"/><xsl:comment/></b><br/>
        <xsl:apply-templates select="xhtml:p"/>
        <xsl:for-each select="lenya:asset">
          <xsl:apply-templates select="."/>
        </xsl:for-each>
        <xsl:for-each select="xhtml:a">
          <a class="arrow" href="{@href}"><xsl:value-of select="."/></a><br/>
        </xsl:for-each> 
        <xsl:apply-templates select="lenya:asset-dot"/>
        <xsl:apply-templates select="unizh:title/lenya:asset-dot"/>
      </div> 
    </div>
  </xsl:template>


  <xsl:template match="unizh:teaser[parent::unizh:column]">
    <div class="solidline">
      <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  />
    </div>
    <p class="titel"><xsl:value-of select="unizh:title"/></p>
    <div class="dotlinelead">
      <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  />
    </div>
    <xsl:if test="xhtml:object">
      <xsl:apply-templates select="xhtml:object"/>
    </xsl:if>
    <xsl:apply-templates select="xhtml:p"/>
    <xsl:for-each select="lenya:asset">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    <xsl:for-each select="xhtml:a">
      <a class="arrow" href="{@href}"><xsl:value-of select="."/></a><br/>
    </xsl:for-each>
    <xsl:apply-templates select="lenya:asset-dot"/>
    <xsl:apply-templates select="unizh:title/lenya:asset-dot"/> 
    <div class="dotlinemitmargin"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  /></div>
  </xsl:template>


  <xsl:template match="unizh:links[unizh:title/@href != '']">
    <div class="solidline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  /></div>
    <ul class="linknav">
      <li>
        <b><a href="{unizh:title/@href}"><xsl:value-of select="unizh:title"/></a></b>
      </li>
      <div class="dotline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  /></div>
      <xsl:for-each select="xhtml:a">
        <li>
          <a href="{@href}">
            <xsl:value-of select="."/>
          </a>
          <div class="dotline">
            <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  />
          </div>
        </li>
      </xsl:for-each>
    </ul>
    <br/>
  </xsl:template>


  <xsl:template match="unizh:links">
    <div class="solidline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  /></div>
    <div class="titel">
      <xsl:value-of select="unizh:title"/>
    </div>
    <div class="dotline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  /></div>
    <ul class="linknav">
      <xsl:for-each select="xhtml:a">
        <li>
          <a href="{@href}">
            <xsl:value-of select="."/>
          </a>
          <div class="dotline">
            <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  />
          </div>
        </li>
      </xsl:for-each>
    </ul>
    <br/>
  </xsl:template>


  <xsl:template match="unizh:contcol1[parent::unizh:homepage or parent::unizh:homepage4cols]">
    <div class="contcol1" id="col1" bxe_xpath="/{$document-element-name}/unizh:contcol1">
      <xsl:apply-templates/><xsl:comment/>
    </div>
  </xsl:template>

  <xsl:template id="col1" match="unizh:contcol1">
    <div class="contcol1" id="col1">
      <xsl:apply-templates/><xsl:comment/>
    </div>
  </xsl:template>


  <xsl:template match="unizh:quicklinks">
      <div class="quicklinks">
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
  </xsl:template>


  <xsl:template match="unizh:rss-reader[parent::unizh:related-content]">
    <xsl:variable name="items" select="@items"/>

    <div class="relatedboxborder">
      <div class="relatedboxcont">
         <xsl:choose>
           <xsl:when test="xhtml:rss/xhtml:channel">

             <xsl:if test="@image = 'true' and xhtml:rss/xhtml:channel/xhtml:image">
               <xsl:variable name="imageheight">
                 <xsl:choose>
                   <xsl:when test="xhtml:rss/xhtml:channel/xhtml:image/xhtml:height &lt; 100">
                     <xsl:value-of select="xhtml:rss/xhtml:channel/xhtml:image/xhtml:height"/>
                   </xsl:when>
                   <xsl:otherwise>64</xsl:otherwise>
                 </xsl:choose>
               </xsl:variable>
               <xsl:variable name="imagewidth">
                 <xsl:choose>
                   <xsl:when test="xhtml:rss/xhtml:channel/xhtml:image/xhtml:width &lt; 156">
                     <xsl:value-of select="xhtml:rss/xhtml:channel/xhtml:image/xhtml:width"/>
                   </xsl:when>
                   <xsl:otherwise>100</xsl:otherwise>
                 </xsl:choose>
               </xsl:variable>
               <img src="{xhtml:rss/xhtml:channel/xhtml:image/xhtml:url}" height="{$imageheight}" width="{$imagewidth}"/><br/>
             </xsl:if>

             <div class="titel"><xsl:value-of select="xhtml:rss/xhtml:channel/xhtml:title"/></div>
             <div class="titel">&#160;</div>
             <div class="dotline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  /><xsl:comment/></div>
             <xsl:for-each select="xhtml:rss/xhtml:channel/xhtml:item">
               <xsl:if test="$items = '' or position() &lt;= $items">
                 <a class="rss" href="{xhtml:link}"><xsl:value-of select="xhtml:title"/></a>
                 <xsl:if test="position() &lt; $items">
                   <div class="dotline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/><xsl:comment/></div>
                 </xsl:if>
               </xsl:if>
             </xsl:for-each>
           </xsl:when>
           <xsl:otherwise>
            --
           </xsl:otherwise>
         </xsl:choose>
      </div>
    </div>
  </xsl:template>


  <xsl:template match="unizh:rss-reader[parent::xhtml:body]">
    <xsl:variable name="items" select="@items"/>
       <h2><xsl:value-of select="xhtml:rss/xhtml:channel/xhtml:title"/></h2>
       <xsl:for-each select="xhtml:rss/xhtml:channel/xhtml:item">
         <xsl:if test="$items = '' or position() &lt;= $items">
           <div class="solidline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1" /></div>
           <h2><xsl:value-of select="xhtml:title"/>&#160;
           <span class="lead"><xsl:value-of select="xhtml:pubDate"/></span></h2>
           <p><xsl:apply-templates select="xhtml:description"/>
           <a class="arrow" href="{xhtml:link}">Weiter</a><br/>
           <br/>
           </p>
         </xsl:if>
       </xsl:for-each>
       <xsl:if test="not(xhtml:rss/xhtml:channel/xhtml:item)">
         <p> -- </p>
       </xsl:if>
  </xsl:template> 

  
  <xsl:template match="xhtml:body//xhtml:h2">
    <h2>
      <xsl:if test="@class">
        <xsl:copy-of select="@class"/>
      </xsl:if>
      <xsl:apply-templates/>
      <xsl:choose>
        <xsl:when test="xhtml:a">
          <a class="namedanchor" name="{xhtml:a/@name}"><xsl:comment/></a>
        </xsl:when>
        <xsl:otherwise>
          <a class="namedanchor" name="{position()}"><xsl:comment/></a>
        </xsl:otherwise>
      </xsl:choose>
    </h2>
  </xsl:template>
  
  <xsl:template name="substring-after-last">
    <xsl:param name="input"/>
    <xsl:param name="substr"/>
    <xsl:variable name="temp" select="substring-after($input, $substr)"/>
    <xsl:choose>
      <xsl:when test="$substr and contains($temp, $substr)">
        <xsl:call-template name="substring-after-last">
          <xsl:with-param name="input" select="$temp"/>
          <xsl:with-param name="substr" select="$substr"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$temp"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>




 

 <xsl:template match="lenya:asset">
   <xsl:variable name="extent">
     <xsl:value-of select="dc:metadata/dc:extent"/>
   </xsl:variable>
   <xsl:variable name="suffix">
     <xsl:call-template name="substring-after-last">
       <xsl:with-param name="input" select="@src"/>
       <xsl:with-param name="substr">.</xsl:with-param>
     </xsl:call-template>
   </xsl:variable>
   <xsl:choose>
     <xsl:when test="$suffix = 'swf'">
       <xsl:variable name="width">
         <xsl:choose>
           <xsl:when test="@size != ''"><xsl:value-of select="substring-before(@size, 'x')"/></xsl:when>
           <xsl:otherwise>500</xsl:otherwise>
         </xsl:choose> 
       </xsl:variable>
       <xsl:variable name="height">
         <xsl:choose>
           <xsl:when test="@size != ''"><xsl:value-of select="substring-after(@size, 'x')"/></xsl:when>
           <xsl:otherwise>400</xsl:otherwise>
         </xsl:choose>
       </xsl:variable>
       <object width="{$width}" height="{$height}">
         <param name="movie" value="{$nodeid}/{@src}"/><embed src="{$nodeid}/{@src}" width="{$width}" height="{$height}" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"></embed>
       </object>
      </xsl:when>
      <xsl:otherwise>
        <div class="asset">
          <a href="{$nodeid}/{@src}">
            <img alt="" border="0" height="16" src="{$imageprefix}/icons/default.gif" width="16" align="left"/>
          </a>
          <xsl:text> </xsl:text>
          <a class="download" href="{$nodeid}/{@src}">
            <xsl:value-of select="text()"/><xsl:comment/>
          </a>
          (<xsl:value-of select="format-number($extent div 1024, '#.#')"/>KB)
        </div>
        <xsl:if test="parent::xhtml:body and not(following-sibling::*[1][name() = 'lenya:asset'])">
          <br/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

    
  <xsl:template match="unizh:toc">
    <p>
      <xsl:for-each select="../*">
        <xsl:if test="self::xhtml:h2">
          <a class="arrow" href="#{position()}"><xsl:value-of select="."/></a><br/>
        </xsl:if>
      </xsl:for-each>
    </p>
  </xsl:template>
  
  
  <xsl:template match="xhtml:h2[ancestor::index:child]" mode="anchor"/> 
 
  <xsl:template match="unizh:children[descendant::unizh:newsitem | descendant::unizh:collection | descendant::unizh:person]">
    <xsl:apply-templates select="index:child"/>
  </xsl:template>

  <xsl:template match="unizh:level">
    <xsl:apply-templates select="level:node"/>
  </xsl:template>

  <xsl:template match="level:node">
    <a class="arrow" href="{$contextprefix}{@href}"><xsl:value-of select="descendant::dc:title"/></a><br/>
  </xsl:template>

  <xsl:template match="xhtml:div[@id='link-to-parent']">
    <p>
      <xhtml:a class="back" href="{@href}"><xsl:value-of select="."/></xhtml:a>
    </p>
  </xsl:template> 


  <xsl:template match="unizh:children[ancestor::unizh:news]">
    <xsl:if test="preceding-sibling::xhtml:object">
      <br class="floatclear"/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="index:child">
        <xsl:for-each select="index:child">
          <xsl:variable name="creationdate" select="*/*/lenya:meta/dcterms:created"/>
          <div class="solidline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1" /></div>
	  <h2><xsl:value-of select="*/*/lenya:meta/dc:title"/>&#160;
             <span class="lead">
             <xsl:choose>
               <xsl:when test="string-length($creationdate) &lt; '25'">
                 <i18n:date pattern="EEE, d. MMM yyyy HH:mm" src-locale="en" src-pattern="d. MMM yyyy HH:mm" value="{$creationdate}"/>
               </xsl:when>
               <xsl:otherwise>
                 <i18n:date pattern="EEE, d. MMM yyyy HH:mm" src-locale="en" src-pattern="EEE MMM d HH:mm:ss zzz yyyy" value="{$creationdate}"/>
               </xsl:otherwise>
             </xsl:choose>
             </span>
          </h2>
          <p>
            <xsl:apply-templates select="*/*/unizh:short/xhtml:object"/>
            <xsl:apply-templates select="*/*/unizh:short/xhtml:p"/>
            <xsl:choose>
              <xsl:when test="*/*/xhtml:body/xhtml:p != '&#160;'">
                <a class="arrow" href="{$contextprefix}{@href}">Weiter</a><br/>
              </xsl:when>
              <xsl:otherwise>
                <a class="arrow" href="{*/*/unizh:short/xhtml:a/@href}">
                  <xsl:value-of select="*/*/unizh:short/xhtml:a"/>
                </a>
                <xsl:if test="$area = 'authoring'">
                  |  <a class="arrow" href="{$contextprefix}{@href}">Edit View...</a><br/>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
            <br/>
          </p>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        - Noch kein Eintrag erfasst - <br/> 
      </xsl:otherwise>
    </xsl:choose>
    <br/>
  </xsl:template>


   <xsl:template match="unizh:children[ancestor::unizh:team]">
    <xsl:choose>
      <xsl:when test="index:child">
        <xsl:for-each select="index:child">
          <div class="teamBlock">
            <div class="teamImg">
              <xsl:apply-templates select="*/unizh:person/xhtml:object"/>
            </div>
            <div class="teamText">
              <p>
                <b>
                  <xsl:if test="*/unizh:person/unizh:academictitle != ''">
                    <xsl:value-of select="*/unizh:person/unizh:academictitle"/>&#160;
                  </xsl:if>
                  <xsl:value-of select="*/unizh:person/unizh:firstname"/>&#160;
                  <xsl:value-of select="*/unizh:person/unizh:lastname"/>&#160;
                </b>
                <br/>
                <xsl:value-of select="*/unizh:person/unizh:position"/><br/>
                Mail: <xsl:value-of select="*/unizh:person/unizh:email"/><br/>
                <a href="{$contextprefix}{@href}">Mehr...</a>
              </p>
            </div>
            <div class="floatleftclear"><xsl:comment/></div>
          </div>
          <div class="solidline">
            <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
          </div>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <p> <br /> - Noch kein Eintrag erfasst - </p>
      </xsl:otherwise>
    </xsl:choose>
    <br/>
  </xsl:template>


  <xsl:template match="unizh:children">
    <xsl:apply-templates select="index:child"/>
  </xsl:template>
  
   <xsl:template match="index:child[descendant::unizh:newsitem]">
    <h3>
      <xsl:apply-templates select="descendant::lenya:meta/dc:title"/>
    </h3>
    <br/>
    <xsl:apply-templates mode="collection" select="descendant::unizh:lead"/>
    <a href="{$contextprefix}{@href}">Mehr...</a>
  </xsl:template>

  <xsl:template match="index:child[descendant::unizh:publication | descendant::unizh:event]">
    <h3>
      <xsl:apply-templates select="descendant::lenya:meta/dc:title"/>
    </h3>
    <br/>
    <xsl:apply-templates mode="collection" select="descendant::lenya:meta/dc:description"/>
    <a href="{$contextprefix}{@href}">Mehr...</a>
  </xsl:template>


  <xsl:template match="unizh:lead">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="index:child">
    <p>
      <xsl:apply-templates mode="index" select="descendant::lenya:meta/dc:title">
        <xsl:with-param name="href">
          <xsl:value-of select="@href"/>
        </xsl:with-param>
      </xsl:apply-templates>
      <xsl:if test="../@abstracts = 'true'">
        <br/>
        <xsl:apply-templates mode="index" select="descendant::lenya:meta/dc:description"/>
      </xsl:if>
    </p>
  </xsl:template>

 
  <xsl:template match="dc:title" mode="index">
    <xsl:param name="href"/>
    <a class="arrow" href="{$contextprefix}{$href}">
      <xsl:value-of select="."/>
    </a>
  </xsl:template>
  
  <xsl:template match="dc:description" mode="index">
    <xsl:value-of select="."/>
  </xsl:template>
 
  <xsl:template match="dc:description" mode="collection">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="xhtml:table[@class = 'ornate']">
    <xsl:variable name="cols">
      <xsl:value-of select="count(xhtml:tr[1]/xhtml:td[not(@colspan)]) + sum (xhtml:tr[1]/xhtml:td/@colspan)"/>
    </xsl:variable>
    <div class="solidlinetable">
      <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
    </div>
    <xsl:copy>
      <xsl:attribute name="width">100%</xsl:attribute>
      <xsl:for-each select="xhtml:tr">
        <tr>
          <xsl:apply-templates select="xhtml:td"/>
        </tr>
        <tr>
          <td colspan="{$cols}" align="left">
            <div class="dotline">
              <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
            </div>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="xhtml:table[@class = 'grid']">
    <xsl:copy>
      <xsl:copy-of select="@class"/>
      <xsl:attribute name="width">100%</xsl:attribute>
        <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="xhtml:textarea">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>&#160;
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
