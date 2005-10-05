<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: elements.xsl,v 1.79 2005/01/17 09:15:15 thomas Exp $ -->
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:index="http://apache.org/cocoon/lenya/documentindex/1.0"
  xmlns:level="http://apache.org/cocoon/lenya/documentlevel/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" xmlns:uz="http://unizh.ch"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:ci="http://apache.org/cocoon/include/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
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

  
  <xsl:template match="unizh:identity">
    <xsl:choose>
      <xsl:when test="@data != 'empty'"> 
        <div class="identity">
          <img border="0" height="80" width="100%">
            <xsl:attribute name="src">
              <xsl:value-of select="$nodeid"/>/<xsl:value-of select="@data"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
              <xsl:value-of select="@alt"/>
            </xsl:attribute>
          </img>
          <xsl:apply-templates select="lenya:asset-dot"/>
        </div>
      </xsl:when> 
      <xsl:otherwise>
        <xsl:apply-templates select="lenya:asset-dot"/>
      </xsl:otherwise>
    </xsl:choose> 
  </xsl:template>
  
  
  <xsl:template match="unizh:sitemap">
    <xsl:apply-templates/>
  </xsl:template> 


  <xsl:template match="unizh:node[parent::unizh:sitemap]">
    <div class="navtitel">
      <a href="{@href}"><xsl:value-of select="unizh:title"/></a>
    </div>
    <div class="solidline">
      <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
    </div>
    <ul>
      <xsl:apply-templates select="unizh:node"/>
      <xsl:comment/>
    </ul>
    <div>&#160;</div>
  </xsl:template>


  <xsl:template match="unizh:node[ancestor::unizh:sitemap and not(parent::unizh:sitemap)]">
    <li>
      <a href="{@href}"><xsl:value-of select="unizh:title"/></a>
      <div class="dotline">
        <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
      </div>
      <xsl:apply-templates select="unizh:node"/>
    </li>
  </xsl:template>


  <xsl:template match="xhtml:p[parent::xhtml:body and $rendertype = 'imageupload']">
    <xsl:copy>
      <xsl:apply-templates select="*[not(self::lenya:asset-dot)]|text()"/>
      <hr>
        <xsl:if test="preceding-sibling::xhtml:object[@float = 'true']">
          <xsl:attribute name="class">floatclear</xsl:attribute>
        </xsl:if>
      </hr>
      <xsl:apply-templates select="lenya:asset-dot"/>
      <br/>
      <br/>
    </xsl:copy>
  </xsl:template> 

  <xsl:template match="xhtml:p[parent::unizh:lead and $rendertype = 'imageupload']">
    <xsl:copy>
      <xsl:apply-templates select="*[not(self::lenya:asset-dot)]|text()"/>
      <br/>
      <xsl:apply-templates select="lenya:asset-dot"/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="xhtml:object[$rendertype = 'imageupload' and (ancestor::xhtml:body or parent::unizh:short or parent::unizh:person)]">
    <div>
      <xsl:if test="@float = 'true' or @popup = 'true'">
        <xsl:attribute name="class">imgTextfluss</xsl:attribute>
      </xsl:if>
      <a href="{lenya:asset-dot/@href}">
        <img src="{$nodeid}/{@data}">
          <xsl:attribute name="width">
            <xsl:choose>
              <xsl:when test="parent::unizh:short">
                100
              </xsl:when>
              <xsl:when test="@float = 'true'">
                204
              </xsl:when>
              <xsl:when test="@popup = 'true'">
                204
              </xsl:when>
              <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </img> 
      </a>
      <xsl:if test="@popup = 'true' or @float = 'true' and not(ancestor::unizh:news or parent::unizh:short)">
        <p class="legende">
          <xsl:value-of select="xhtml:div[@class = 'caption']"/><xsl:comment/>
        </p>
      </xsl:if>
    </div>
    <xsl:if test="@popup = 'true' and not(@float = 'true')">
      <br class="floatclear"/>
    </xsl:if>
  </xsl:template>


  <xsl:template match="xhtml:object[$rendertype = 'imageupload' and ancestor::unizh:teaser]">
    <a href="{lenya:asset-dot/@href}">
      <img src="{$nodeid}/{@data}" height="110" width="160"/>
    </a>
  </xsl:template>

  <xsl:template match="xhtml:object[$rendertype = 'imageupload' and ancestor::unizh:teaser and ancestor::unizh:column]">
    <a href="{lenya:asset-dot/@href}">
      <img src="{$nodeid}/{@data}" height="130" width="195"/>
    </a>
  </xsl:template>

  <xsl:template match="xhtml:object[$rendertype = 'imageupload' and parent::unizh:lead]">
    <a href="{lenya:asset-dot/@href}">
      <img src="{$nodeid}/{@data}" height="140" width="210"/>
    </a>
  </xsl:template>

  <xsl:template match="lenya:asset[$rendertype = 'imageupload']">
    <a class="download" href="{lenya:asset-dot/@href}">
      <xsl:value-of select="text()"/>
    </a>
  </xsl:template>


  <xsl:template match="xhtml:object[parent::unizh:person]">
    <xsl:choose>
      <xsl:when test="not(@data)">
        <img src="{$imageprefix}/default_head.jpg"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="ancestor::index:child">
            <xsl:choose>
              <xsl:when test="contains(../../../@href, '_')">
                <img src="{$contextprefix}{substring-before(../../../@href, '_')}/{@data}"/>
              </xsl:when>
              <xsl:otherwise>
                <img src="{$contextprefix}{substring-before(../../../@href, '.html')}/{@data}"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <img src="{$nodeid}/{@data}" width="100"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="xhtml:object[$rendertype = 'imageupload' and parent::unizh:person and not(ancestor::index:child)]">
    <a href="{lenya:asset-dot/@href}">
      <xsl:choose>
        <xsl:when test="not(@data)">
          <img src="{$imageprefix}/default_head.jpg"/>
        </xsl:when>
        <xsl:otherwise>
          <img src="{$nodeid}/{@data}" width="100"/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>

 
  <xsl:template match="xhtml:object">
    <xsl:choose>
      <xsl:when test="@float = 'true'">
        <div class="imgTextfluss">
          <xsl:call-template name="object_link">
            <xsl:with-param name="float">true</xsl:with-param>
          </xsl:call-template>
          <xsl:if test="not(ancestor::unizh:news) and not(parent::unizh:short)">
            <p class="legende">
              <xsl:value-of select="xhtml:div[@class = 'caption']"/><xsl:comment/>
              <xsl:if test="@popup = 'true'">
                <a href="#" onClick="window.open('{$nodeid}/{@data}', 'Image', 'width={@width},height={@height}')">(+)</a>
              </xsl:if>
            </p>
          </xsl:if>
        </div>
      </xsl:when>
      <xsl:when test="@popup = 'true' and not (@float = 'true')">
        <div class="imgTexfluss"> 
          <xsl:call-template name="object_link">
            <xsl:with-param name="popup">true</xsl:with-param>
          </xsl:call-template>
          <div class="legende">
            <xsl:value-of select="xhtml:div[@class = 'caption']"/><xsl:comment/>
              <a href="#" onClick="window.open('{$nodeid}/{@data}', 'Image', 'width={@width},height={@height}')">(+)</a>
          </div>
        </div>
        <br class="floatclear"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="xhtml:div[@class = 'caption']">
            <div class="imgMitLegende">
              <xsl:call-template name="object_link"/>
              <div class="legende"> 
                <xsl:value-of select="xhtml:div[@class = 'caption']"/><xsl:comment/>
              </div>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="object_link"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose> 
  </xsl:template>
  
 
  <xsl:template name="object_link">
    <xsl:param name="float"/>
    <xsl:param name="popup"/>
    <xsl:choose>
      <xsl:when test="@href != ''">
        <a href="{@href}">
          <img>
            <xsl:attribute name="src">
              <xsl:value-of select="$nodeid"/>/<xsl:value-of select="@data"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
              <xsl:choose>
                <xsl:when test="@title != ''">
                  <xsl:value-of select="@title"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="dc:metadata/dc:title"/>                    
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="($float = 'true' or $popup = 'true') and not(parent::unizh:short or parent::unizh:teaser)">
                <xsl:attribute name="width">204</xsl:attribute>
              </xsl:when>
              <xsl:when test="ancestor::unizh:news">
                <xsl:attribute name="height">120</xsl:attribute>
              </xsl:when> 
              <xsl:when test="ancestor::unizh:short">
                <xsl:attribute name="width">100</xsl:attribute>
                <xsl:attribute name="height">64</xsl:attribute>
              </xsl:when>
              <xsl:when test="parent::unizh:teaser and ancestor::unizh:column">
                <xsl:attribute name="width">195</xsl:attribute>
                <xsl:attribute name="height">130</xsl:attribute>
              </xsl:when>
              <xsl:when test="parent::unizh:teaser">
                <xsl:attribute name="width">156</xsl:attribute>
                <xsl:attribute name="height">100</xsl:attribute>
              </xsl:when>
              <xsl:when test="parent::unizh:lead">
                <xsl:attribute name="width">200</xsl:attribute>
                <xsl:attribute name="height">140</xsl:attribute>
              </xsl:when>
              <xsl:when test="ancestor::xhtml:table">
                <xsl:attribute name="width">100</xsl:attribute>
              </xsl:when>
              <xsl:when test="@width = '415'">
                <xsl:attribute name="width">415</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="width">204</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
          </img>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <img>
          <xsl:attribute name="src">
            <xsl:value-of select="$nodeid"/>/<xsl:value-of select="@data"/>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:choose>
              <xsl:when test="@title != ''">
                <xsl:value-of select="@title"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="dc:metadata/dc:title"/>                    
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="($float = 'true' or $popup = 'true') and not(parent::unizh:short or parent::unizh:teaser)">
              <xsl:attribute name="width">204</xsl:attribute>
            </xsl:when>
            <xsl:when test="ancestor::unizh:news and not(parent::unizh:short)">
              <xsl:attribute name="height">120</xsl:attribute>
            </xsl:when>
            <xsl:when test="ancestor::unizh:short">
              <xsl:attribute name="width">100</xsl:attribute>
              <xsl:attribute name="height">64</xsl:attribute>
            </xsl:when> 
            <xsl:when test="parent::unizh:teaser and ancestor::unizh:column">
              <xsl:attribute name="width">195</xsl:attribute>
              <xsl:attribute name="height">130</xsl:attribute>
            </xsl:when>
            <xsl:when test="parent::unizh:teaser">
              <xsl:attribute name="width">156</xsl:attribute>
              <xsl:attribute name="height">100</xsl:attribute>
            </xsl:when>
            <xsl:when test="parent::unizh:lead">
              <xsl:attribute name="width">200</xsl:attribute>
              <xsl:attribute name="height">140</xsl:attribute>
            </xsl:when>
            <xsl:when test="ancestor::xhtml:table and @width != ''">
              <xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="ancestor::xhtml:table">
              <xsl:attribute name="width">100</xsl:attribute>
            </xsl:when>
            <xsl:when test="@width = '415'">
              <xsl:attribute name="width">415</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="width">204</xsl:attribute>
            </xsl:otherwise> 
          </xsl:choose>
        </img>
      </xsl:otherwise>
    </xsl:choose> 
  </xsl:template>


  <xsl:template match="xhtml:a">
    <a class="arrow" href="{@href}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="xhtml:a[normalize-space(.) = '' and @name != '']">
    <a name="{@name}"/><xsl:comment/>
  </xsl:template>



  <xsl:template match="unizh:attention">
    <span class="attention">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <xsl:template match="unizh:related-content">
    <xsl:apply-templates/>
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
          <xsl:apply-templates select="."/><br/>
        </xsl:for-each>
        <xsl:for-each select="xhtml:a">
          <a class="arrow" href="{@href}"><xsl:value-of select="."/></a><br/>
        </xsl:for-each> 
        <xsl:apply-templates select="lenya:asset-dot"/>
        <xsl:apply-templates select="unizh:title/lenya:asset-dot"/>
      </div> 
    </div>
    <p>&#160;</p>
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
      <xsl:apply-templates select="."/><br/>
    </xsl:for-each>
    <xsl:for-each select="xhtml:a">
      <a class="arrow" href="{@href}"><xsl:value-of select="."/></a><br/>
    </xsl:for-each>
    <xsl:apply-templates select="lenya:asset-dot"/>
    <xsl:apply-templates select="unizh:title/lenya:asset-dot"/> 
    <div class="dotlinemitmargin"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  /></div>
    <p>&#160;</p>
  </xsl:template>

   <xsl:template match="unizh:lead">
      <div class="lead">
        <xsl:apply-templates/>
      </div>
      <p>&#160;</p>
   </xsl:template>  


   <xsl:template match="unizh:links">
    <div class="solidline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  /></div>
    <ul class="linknav">
      <li>
        <a href="{unizh:title/@href}">
          <b><xsl:value-of select="unizh:title"/></b>
        </a>
        <div class="dotline">
          <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  />
        </div>
      </li>
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
    <p>&#160;</p>
  </xsl:template>


  <xsl:template match="unizh:quicklinks">
    <div id="col1">
      <div class="quicklinks" bxe_xpath="/{$document-element-name}/unizh:quicklinks">
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


  <xsl:template match="unizh:highlight">
    <div class="relatedboxborder">
      <div class="relatedboxcont">
        <xsl:apply-templates/>
        <a class="arrow" href="">weiter</a>
        <xsl:apply-templates select="lenya:asset-dot"/>
      </div>
    </div>
  </xsl:template>

 
  <xsl:template match="unizh:highlights" mode="print">
    <div class="highlights">
      <xsl:for-each select="unizh:highlight">
        <div class="highlight{(position()-1) mod 3}">
          <xsl:apply-templates/>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template> 
  
  <xsl:template match="unizh:highlight-title">
    <b><xsl:apply-templates/></b>
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
                   <xsl:otherwise>100</xsl:otherwise>
                 </xsl:choose>
               </xsl:variable>
               <xsl:variable name="imagewidth">
                 <xsl:choose>
                   <xsl:when test="xhtml:rss/xhtml:channel/xhtml:image/xhtml:width &lt; 156">
                     <xsl:value-of select="xhtml:rss/xhtml:channel/xhtml:image/xhtml:width"/>
                   </xsl:when>
                   <xsl:otherwise>156</xsl:otherwise>
                 </xsl:choose>
               </xsl:variable>
               <img src="{xhtml:rss/xhtml:channel/xhtml:image/xhtml:url}" height="{$imageheight}" width="{$imagewidth}"/><br/>
             </xsl:if>

             <div class="titel"><xsl:value-of select="xhtml:rss/xhtml:channel/xhtml:title"/></div>
             <div class="titel">&#160;</div>
             <div class="rssdotline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  /><xsl:comment/></div>
             <xsl:for-each select="xhtml:rss/xhtml:channel/xhtml:item">
               <xsl:if test="$items = '' or position() &lt;= $items">
                 <a class="rss" href="{xhtml:link}"><xsl:value-of select="xhtml:title"/></a>
                 <xsl:if test="position() &lt; $items">
                   <div class="rssdotline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/><xsl:comment/></div>
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
    <p>&#160;</p> 
  </xsl:template>


  <xsl:template match="unizh:rss-reader[parent::xhtml:body]">
    <xsl:variable name="items" select="@items"/>
       <h2><xsl:value-of select="xhtml:rss/xhtml:channel/xhtml:title"/></h2>
       <xsl:for-each select="xhtml:rss/xhtml:channel/xhtml:item">
         <xsl:if test="$items = '' or position() &lt;= $items">
           <div class="solidline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1" /></div>
           <h2><xsl:value-of select="xhtml:title"/>&#160;
           <span class="lead"><xsl:value-of select="xhtml:pubDate"/></span></h2>
           <p><xsl:apply-templates select="xhtml:description"/></p>
           <a class="arrow" href="{xhtml:link}">weiter</a>
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
      <xsl:value-of select="."/>
      <xsl:choose>
        <xsl:when test="xhtml:a">
          <a class="namedanchor" name="{xhtml:a/@name}"><xsl:comment/></a>
        </xsl:when>
        <xsl:otherwise>
          <a class="namedanchor" name="{.}" id="{.}"><xsl:comment/></a>
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
        <!-- <a href="{$nodeid}/{@src}">
          <img alt="" border="0" height="16"
            src="{$imageprefix}/icons/default.gif" width="16" align="left"/>
        </a>
        <xsl:text> </xsl:text>-->
        <a class="download" href="{$nodeid}/{@src}">
          <xsl:value-of select="text()"/>
        </a>
        (<xsl:value-of select="format-number($extent div 1024, '#.#')"/>KB)
        <xsl:apply-templates select="lenya:asset-dot"/> 
  </xsl:template>
    
  <xsl:template match="unizh:toc">
    <ul class="anchors">
      <!-- this assumes 2 things: each h2 has a corresponding anchor, and that
      anchor has the same name as the h2. The anchor is set by the template
      xhtml:body/xhtml:h2, which should be called before -->
      <xsl:apply-templates mode="anchor" select="../xhtml:h2[ancestor::xhtml:body]"/>
    </ul>
  </xsl:template>
  
  <xsl:template match="xhtml:h2[ancestor::xhtml:body]" mode="anchor">
    <li>
      <a href="#{.}">
        <xsl:value-of select="."/>
      </a>
    </li>
  </xsl:template>
  
  <xsl:template match="xhtml:h2[ancestor::index:child]" mode="anchor"/> 
 
  <xsl:template match="unizh:children[descendant::unizh:newsitem | descendant::unizh:collection | descendant::unizh:team]">
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
    <xsl:choose>
      <xsl:when test="index:child">
        <xsl:for-each select="index:child">
          <div class="solidline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1" /></div>
          <h2><xsl:value-of select="*/*/lenya:meta/dc:title"/>&#160;<span class="lead"><xsl:value-of select="*/*/lenya:meta/dcterms:created"/></span></h2> 
          <p>
            <xsl:apply-templates select="*/*/unizh:short/xhtml:object"/>
            <xsl:apply-templates select="*/*/unizh:short/xhtml:p"/>
            <xsl:choose>
              <xsl:when test="*/*/xhtml:body/xhtml:p != '&#160;'">
                <a class="arrow" href="{$contextprefix}{@href}">Weiter</a>
              </xsl:when>
              <xsl:otherwise>
                <a class="arrow" href="{*/*/unizh:short/xhtml:a/@href}">
                  <xsl:value-of select="*/*/unizh:short/xhtml:a"/>
                </a>
                <xsl:if test="$area = 'authoring'">
                  |  <a class="arrow" href="{$contextprefix}{@href}">Edit View...</a>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </p>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <p> <br /> - Noch kein Eintrag erfasst - </p>
      </xsl:otherwise>
    </xsl:choose>
    <br/>
  </xsl:template>

  <xsl:template match="unizh:children[ancestor::unizh:collection]">
    <xsl:choose>
      <xsl:when test="index:child">
        <xsl:for-each select="index:child">
          <h2><xsl:value-of select="*/*/lenya:meta/dc:title"/></h2>
          <p>
            <xsl:apply-templates select="*/*/unizh:abstract/*"/>
            <br/>
            <a href="{$contextprefix}{@href}">Mehr...</a>
          </p>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <p> <br /> - Noch kein Eintrag erfasst - </p>
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
                  <xsl:value-of select="*/unizh:person/unizh:academictitle"/>&#160;
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
    <xsl:if test="index:child">
      <ul class="children">
        <xsl:apply-templates select="index:child"/>
      </ul>
    </xsl:if>
  </xsl:template>
  
   <xsl:template match="index:child[descendant::unizh:newsitem]">
    <h3>
      <xsl:apply-templates select="descendant::lenya:meta/dc:title"/>
    </h3>
    <br/>
    <xsl:apply-templates mode="collection" select="descendant::unizh:lead"/>
    <a href="{$contextprefix}{@href}">mehr</a>
  </xsl:template>

  <xsl:template match="index:child[descendant::unizh:publication | descendant::unizh:event]">
    <h3>
      <xsl:apply-templates select="descendant::lenya:meta/dc:title"/>
    </h3>
    <br/>
    <xsl:apply-templates mode="collection" select="descendant::lenya:meta/dc:description"/>
    <a href="{$contextprefix}{@href}">mehr</a>
  </xsl:template>


  <xsl:template match="unizh:lead">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="index:child">
    <li>
      <xsl:apply-templates mode="index" select="descendant::lenya:meta/dc:title">
        <xsl:with-param name="href">
          <xsl:value-of select="@href"/>
        </xsl:with-param>
      </xsl:apply-templates>
      <xsl:if test="../@abstracts = 'true'">
        <br/>
        <xsl:apply-templates mode="index" select="descendant::lenya:meta/dc:description"/>
      </xsl:if>
    </li>
  </xsl:template>

 
  <xsl:template match="dc:title" mode="index">
    <xsl:param name="href"/>
    <a href="{$contextprefix}{$href}">
      <xsl:value-of select="."/>
    </a>
  </xsl:template>
  
  <xsl:template match="dc:description" mode="index">
    <xsl:value-of select="."/>
  </xsl:template>
 
  <xsl:template match="dc:description" mode="collection">
    <xsl:value-of select="."/>
  </xsl:template>


  <xsl:template match="xhtml:textarea">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>&#160;
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
