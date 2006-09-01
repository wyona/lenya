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
      <img alt="Insert Identity" src="{$contextprefix}/lenya/images/util/uploadimage.gif"/>  
    </a>&#160;
  </xsl:template>

  <xsl:template match="lenya:asset-dot[@class='floatImage']">
    <a href="{@href}">
      float
    </a>&#160;
  </xsl:template>


  <xsl:template match="lenya:asset-dot[@class='delete']">
    <a href="{@href}">
      <img alt="Insert Identity" src="{$imageprefix}/icons/delete.gif"/>
    </a>&#160;
  </xsl:template>

  <xsl:template match="lenya:asset-dot[@class='asset']">
    <a href="{@href}">
      <img alt="Insert Asset" src="{$contextprefix}/lenya/images/util/uploadasset.gif"/>
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
          <xsl:choose>
            <xsl:when test="contains(@src,'?')">
              <xsl:attribute name="src"><xsl:value-of select="@src"/>&amp;<xsl:value-of select="$querystring"/></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="src"><xsl:value-of select="@src"/>?<xsl:value-of select="$querystring"/></xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
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

    <xsl:variable name="fulltext" select="normalize-space(.)"/>
    <xsl:choose>
      <xsl:when test="ancestor::unizh:newsitem and (($fulltext = '') or ($fulltext = '&#160;'))">
          <xsl:copy>
            <xsl:apply-templates select="@*|*[not(self::lenya:asset-dot)]|text()"/>
          </xsl:copy>
      </xsl:when>

      <xsl:when test="xhtml:object[@float = 'true']">
        <div class="upload_block">
          <xsl:copy>
            <xsl:apply-templates select="@*|*[not(self::lenya:asset-dot)]|text()"/>
          </xsl:copy>
          <xsl:if test="lenya:asset-dot">
              <br class="floatclear"/>
            <hr/>
            <xsl:apply-templates select="lenya:asset-dot"/>
            <br/>
            <br/>
          </xsl:if>
        </div>
      </xsl:when>

      <xsl:when test="preceding-sibling::*[1]/@float = 'true'">
        <div class="upload_block">
          <xsl:apply-templates select="preceding-sibling::*[1]" mode="preprocess"/>
          <xsl:copy>
            <xsl:apply-templates select="@*|*[not(self::lenya:asset-dot)]|text()"/>
          </xsl:copy>
          <xsl:if test="lenya:asset-dot">
              <br class="floatclear"/>
            <hr/>
            <xsl:apply-templates select="lenya:asset-dot"/>
            <br/>
            <br/>
          </xsl:if>
        </div>
      </xsl:when>

      <xsl:otherwise>
        <div class="upload_block">
          <xsl:copy>
            <xsl:apply-templates select="@*|*[not(self::lenya:asset-dot)]|text()"/>
          </xsl:copy>
          <xsl:if test="lenya:asset-dot">
              <br class="floatclear"/>
            <hr/>
            <xsl:apply-templates select="lenya:asset-dot"/>
            <br/>
            <br/>
          </xsl:if>
        </div>
      </xsl:otherwise>
    </xsl:choose>
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


  <xsl:template match="xhtml:a[@href != '']">
    <a href="{@href}">
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="starts-with(@href, 'http://') and not(contains(@href, '.unizh.ch'))">
            <xsl:text>extern</xsl:text>
          </xsl:when>
          <xsl:otherwise>
             <xsl:text>arrow</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:copy-of select="@target"/>
      <xsl:apply-templates/><xsl:comment/>
    </a>
  </xsl:template>


  <xsl:template match="xhtml:a[ancestor::unizh:teaser and parent::xhtml:p]">
    <a href="{@href}">
      <xsl:copy-of select="@target"/>
      <xsl:value-of select="text()"/>
      <xsl:comment/>
    </a>
  </xsl:template>


  <xsl:template match="xhtml:a[normalize-space(.) = '' and @name != '']">
    <a name="{@name}" class="namedanchor"><xsl:comment/></a>
  </xsl:template>


  <xsl:template match="xhtml:a[(@name != '') and (not(@href) or (@href = ''))]">
    <xsl:copy>
      <xsl:attribute name="class">
        <xsl:text>namedanchor</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!--
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
  -->

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
        <xsl:apply-templates select="unizh:title/lenya:asset-dot"/>
        <xsl:apply-templates select="xhtml:p"/>
        <xsl:for-each select="lenya:asset">
          <xsl:apply-templates select="."/>
        </xsl:for-each>
        <xsl:for-each select="xhtml:a">
          <a href="{@href}">
            <xsl:attribute name="class">
              <xsl:choose>
                <xsl:when test="starts-with(@href, 'http://') and not(contains(@href, '.unizh.ch'))">
                  <xsl:text>extern</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                   <xsl:text>arrow</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:copy-of select="@target"/>
            <xsl:apply-templates/>
          </a>
          <br/>
        </xsl:for-each> 
        <xsl:apply-templates select="lenya:asset-dot"/>
      </div> 
    </div>
  </xsl:template>


  <xsl:template match="unizh:teaser[parent::unizh:column]">
    <xsl:choose>
      <xsl:when test="preceding-sibling::* or ../../unizh:lead/xhtml:object or ../../unizh:lead/xhtml:p/descendant-or-self::*[text()]">
        <div class="solidlinemitmargin">
          <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="solidline">
          <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
    <div class="kleintitel">
      <xsl:value-of select="unizh:title"/>
    </div>
    <xsl:apply-templates select="unizh:title/lenya:asset-dot"/> 
    <xsl:choose>
      <xsl:when test="xhtml:object">
        <xsl:apply-templates select="xhtml:object"/>
      </xsl:when>
      <xsl:otherwise>
        <div class="dotline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  /></div>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="xhtml:p"/>
    <xsl:for-each select="lenya:asset">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    <xsl:for-each select="xhtml:a">
      <a class="arrow" href="{@href}"><xsl:value-of select="."/></a><br/>
    </xsl:for-each>
    <xsl:apply-templates select="lenya:asset-dot"/>
    <div class="dotlinemitmargin"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  /></div>
  </xsl:template>


  <xsl:template match="unizh:links">
    <xsl:choose>
      <xsl:when test="preceding-sibling::* or ../../unizh:lead/xhtml:object or ../../unizh:lead/xhtml:p/descendant-or-self::*[text()]">
        <div class="solidlinemitmargin">
          <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="solidline">
          <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
    <div class="kleintitel">
      <xsl:value-of select="unizh:title"/>
    </div>
    <xsl:apply-templates select="unizh:title/lenya:asset-dot"/>
    <xsl:choose>
      <xsl:when test="xhtml:object">
        <xsl:apply-templates select="xhtml:object"/>
      </xsl:when>
      <xsl:otherwise>
        <div class="dotline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  /></div>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="xhtml:p"/>
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
  </xsl:template>


  <xsl:template match="unizh:contcol1[parent::unizh:homepage or parent::unizh:homepage4cols]">
    <div class="contcol1" bxe_xpath="/{$document-element-name}/unizh:contcol1">
      <xsl:apply-templates/><xsl:comment/>
    </div>
  </xsl:template>


  <xsl:template match="unizh:quicklinks">
      <div class="quicklinks" id="quicklink">
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
          <xsl:text> </xsl:text>
          <a class="download" href="{$nodeid}/{@src}">
            <xsl:value-of select="text()"/><xsl:comment/>
          </a>
          (<xsl:value-of select="format-number($extent div 1024, '#.#')"/>KB, <img src="{$imageprefix}/icons/{$suffix}.gif" alt="{text()}" title="{text()}"/>)
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
          <a class="arrow" href="#{position()}">
            <xsl:apply-templates select="self::xhtml:h2/unizh:attention | self::xhtml:h2/*[name() != 'unizh:attention']/text() | self::xhtml:h2/text()"/>
          </a>
          <br/>
        </xsl:if>
      </xsl:for-each>
    </p>
  </xsl:template>
  

  <xsl:template match="unizh:toplink">
    <div class="topnav"><a href="#top">top</a></div>  
  </xsl:template>

 
  <xsl:template match="xhtml:h2[ancestor::index:child]" mode="anchor"/> 
 
  <xsl:template match="unizh:children[descendant::unizh:newsitem | descendant::unizh:person]">
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
            <br/>
            <xsl:if test="$area = 'authoring'">
              <a class="arrow_right_aligned" href="{$contextprefix}{@href}"><i18n:text>edit_item</i18n:text></a>
            </xsl:if>
            <xsl:variable name="fulltext" select="normalize-space(*/*/xhtml:body/xhtml:p)"/>
            <xsl:choose>
              <xsl:when test="*/*/unizh:short/xhtml:a">
                <a class="arrow" href="{*/*/unizh:short/xhtml:a/@href}"><i18n:text>more</i18n:text></a>
              </xsl:when>
              <xsl:when test="not(($fulltext = '') or ($fulltext = '&#160;'))">
                <a class="arrow" href="{$contextprefix}{@href}"><i18n:text>more</i18n:text></a>
              </xsl:when>
              <xsl:otherwise/>
            </xsl:choose>
          </p>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        - Noch kein Eintrag erfasst - <br/> 
      </xsl:otherwise>
    </xsl:choose>
    <br/>
  </xsl:template>


  <xsl:template match="xhtml:p[parent::unizh:short]">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="xhtml:a[parent::unizh:short]">
    <br/>
    <a class="arrow" href="{@href}"><i18n:text>more</i18n:text></a>
  </xsl:template>


  <xsl:template match="xhtml:p[parent::xhtml:body and ($rendertype != 'imageupload')]">
    <xsl:choose>
      <xsl:when test="xhtml:object[@float = 'true']">
        <div class="img_block">
          <xsl:copy>
            <xsl:apply-templates/>
          </xsl:copy>
          <br class="floatclear"/>
        </div>
      </xsl:when>

      <xsl:when test="preceding-sibling::*[1]/@float = 'true'">
        <div class="img_block">
          <xsl:apply-templates select="preceding-sibling::*[1]" mode="preprocess"/>
          <xsl:copy>
            <xsl:apply-templates/>
          </xsl:copy>
          <br class="floatclear"/>
        </div>
      </xsl:when>

      <xsl:otherwise>
          <xsl:copy>
            <xsl:apply-templates/>
          </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
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
                <a class="arrow" href="{$contextprefix}{@href}"><i18n:text>more</i18n:text></a>
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

<!--  
   <xsl:template match="index:child[descendant::unizh:newsitem]">
    <h3>
      <xsl:apply-templates select="descendant::lenya:meta/dc:title"/>
    </h3>
    <br/>
    <xsl:apply-templates mode="collection" select="descendant::unizh:lead"/>
    <a class="arrow" href="{$contextprefix}{@href}"><i18n:text>more</i18n:text></a>
  </xsl:template>
-->

  <xsl:template match="unizh:lead[parent::xhtml:body]">
    <xsl:choose>
      <xsl:when test="xhtml:object or (xhtml:p/descendant-or-self::*[text()])">
        <div class="leadblock" bxe_xpath="/{$document-element-name}/xhtml:body/unizh:lead">
          <xsl:apply-templates/>
        </div>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
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
      <xsl:value-of select="count(xhtml:tr[1]/xhtml:td [not(@colspan)]) + count(xhtml:tr[1]/xhtml:th [not(@colspan)]) + sum (xhtml:tr[1]/xhtml:td/@colspan) + sum (xhtml:tr[1]/xhtml:th/@colspan)"/>
    </xsl:variable>
    <div class="solidlinetable">
      <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
    </div> 
    <xsl:if test="xhtml:caption">
      <div class="tabletitel">
        <xsl:value-of select="xhtml:caption"/>
      </div>
      <div class="dotline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1" /></div>
    </xsl:if>
    <xsl:copy>
      <xsl:attribute name="width">100%</xsl:attribute>
      <xsl:for-each select="xhtml:tr">
        <tr>
          <xsl:apply-templates select="xhtml:td | xhtml:th"/>
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


  <xsl:template match="xhtml:table[@class = 'striped']">
    <xsl:copy>
      <xsl:copy-of select="@class"/>
      <xsl:attribute name="width">100%</xsl:attribute>
      <xsl:for-each select="xhtml:tr">
        <xsl:variable name="eins"><xsl:value-of select="position()"/></xsl:variable>
        <xsl:copy>
          <xsl:if test="($eins div 2) = round($eins div 2)">
            <xsl:attribute name="class">strip</xsl:attribute>
          </xsl:if>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="xhtml:textarea">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>&#160;
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
