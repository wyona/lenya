<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: elements.xsl,v 1.9 2005/02/08 16:08:40 thomas Exp $ -->
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:index="http://apache.org/cocoon/lenya/documentindex/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" xmlns:uz="http://unizh.ch"
  xmlns:elt="http://www.unizh.ch/elt/1.0"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:template name="compute-path">
    <xsl:if test="name() != 'document' and name() != 'content'">
      <xsl:text>/</xsl:text>
      <!--       <xsl:value-of select="name()"/> -->
      <xsl:text>*</xsl:text>
      <!-- FIXME: there is a less hackish way to do this -->
      <xsl:if test="name() != 'html' and name() != 'xhtml:html'">
        <xsl:text>[</xsl:text>
        <!--       <xsl:value-of select="1+count(preceding-sibling::*[name(current()) = name()])"/> -->
        <xsl:value-of select="1+count(preceding-sibling::*)"/>
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="asset-dots">
    <xsl:param name="insertWhere" select="'after'"/>
    <xsl:param name="insertWhat"/>
    <xsl:if test="$area = 'authoring' and $rendertype = 'imageupload'">
      <xsl:variable name="trimmedElementPath">
        <xsl:for-each select="(ancestor-or-self::*)">
          <xsl:call-template name="compute-path"/>
        </xsl:for-each>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$insertWhat = 'identity'">
          <a href="?lenya.usecase=asset&amp;lenya.step=showscreen&amp;insert=true&amp;insertimage=true&amp;assetXPath={$trimmedElementPath}&amp;insertWhere={$insertWhere}&amp;insertTemplate=insertIdentity.xml&amp;insertReplace=true">
            <img align="top" alt="Insert Identity" border="0" src="{$contextprefix}/lenya/images/util/uploadimage.gif"/>
          </a>
        </xsl:when>
        <xsl:when test="$insertWhat = 'logo'">
          <a href="?lenya.usecase=asset&amp;lenya.step=showscreen&amp;insert=true&amp;insertimage=true&amp;assetXPath={$trimmedElementPath}&amp;insertWhere={$insertWhere}&amp;insertTemplate=insertLogo.xml&amp;insertReplace=true">
            <img align="top" alt="Insert Logo" border="0" src="{$contextprefix}/lenya/images/util/uploadimage.gif"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <a href="?lenya.usecase=asset&amp;lenya.step=showscreen&amp;insert=true&amp;insertimage=true&amp;assetXPath={$trimmedElementPath}&amp;insertWhere={$insertWhere}&amp;insertTemplate=insertImg.xml">
            <img align="top" alt="Insert Image" border="0" src="{$contextprefix}/lenya/images/util/uploadimage.gif"/>
          </a>
          <a href="?lenya.usecase=asset&amp;lenya.step=showscreen&amp;insert=true&amp;insertimage=false&amp;assetXPath={$trimmedElementPath}&amp;insertWhere={$insertWhere}&amp;insertTemplate=insertAsset.xml">
            <img align="top" alt="Insert Asset" border="0" src="{$contextprefix}/lenya/images/util/uploadasset.gif"/>
          </a>
          <br/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="dc:title">
    <h1 bxe_xpath="/xhtml:{$document-element-name}/lenya:meta/dc:title">
      <xsl:apply-templates/>
    </h1>
  </xsl:template>

  <xsl:template match="unizh:logo">
     <xsl:choose>
      <xsl:when test="@data != 'empty'"> 
        <div class="logo">
          <img border="0" height="80" width="200">
            <xsl:attribute name="src">
              <xsl:value-of select="$nodeid"/>/<xsl:value-of select="@data"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
              <xsl:value-of select="@alt"/>
            </xsl:attribute>
          </img>
          <xsl:call-template name="asset-dots">
	          <xsl:with-param name="insertWhat" select="'logo'"/>
          </xsl:call-template>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div>
          <xsl:call-template name="asset-dots">
	          <xsl:with-param name="insertWhat" select="'logo'"/>
          </xsl:call-template>
       </div>
      </xsl:otherwise>
    </xsl:choose>
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
      <xsl:call-template name="asset-dots">
	<xsl:with-param name="insertWhat" select="'identity'"/>
      </xsl:call-template>
    </div>
      </xsl:when> 
      <xsl:otherwise>
        <xsl:call-template name="asset-dots">
	          <xsl:with-param name="insertWhat" select="'identity'"/>
        </xsl:call-template>      
   </xsl:otherwise>
   </xsl:choose> 
    
  </xsl:template>
  
  <xsl:template match="unizh:slogan">
    <p bxe_xpath="/xhtml:{$document-element-name}/unizh:slogan" class="slogan">
      <xsl:apply-templates/>
    </p>
   </xsl:template>
  
  <xsl:template match="xhtml:object" priority="3">
    <div align="left">
      <xsl:choose>
        <xsl:when test="normalize-space(text())">
          <table border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td align="left">
                <xsl:call-template name="object_link"/>
              </td>
            </tr>
            <tr>
              <td class="caption">
                <xsl:apply-templates />
              </td>
            </tr>
          </table>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="object_link"/>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>
  
 
  <xsl:template name="object_link">
    <xsl:choose>
      <xsl:when test="@href != ''">
        <a href="{@href}">
          <img border="0">
            <xsl:attribute name="src">
              <xsl:value-of select="$nodeid"/>/<xsl:value-of select="@data"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
              <!-- the overwritten title (stored in @title) has precedence over dc:title -->
              <xsl:choose>
                <xsl:when test="@title != ''">
                  <xsl:value-of select="@title"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="dc:metadata/dc:title"/>                    
                </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
             <xsl:if test="string(@height)">
              <xsl:attribute name="height">
                <xsl:value-of select="@height"/>
              </xsl:attribute>
            </xsl:if> 
            <xsl:if test="string(@width)">
              <xsl:attribute name="width">
                <xsl:value-of select="@width"/>
              </xsl:attribute>
            </xsl:if>         
          </img>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <img border="0">
          <xsl:attribute name="src">
            <xsl:value-of select="$nodeid"/>/<xsl:value-of select="@data"/>
          </xsl:attribute>
          <xsl:attribute name="alt">
              <!-- the overwritten title (stored in @title) has precedence over dc:title -->
              <xsl:choose>
                <xsl:when test="@title != ''">
                  <xsl:value-of select="@title"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="dc:metadata/dc:title"/>                    
                </xsl:otherwise>
                </xsl:choose>
          </xsl:attribute>
          <xsl:if test="string(@height)">
              <xsl:attribute name="height">
                <xsl:value-of select="@height"/>
              </xsl:attribute>
        </xsl:if> 
        <xsl:if test="string(@width)">
              <xsl:attribute name="width">
                <xsl:value-of select="@width"/>
              </xsl:attribute>
        </xsl:if>         
        </img>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="dc:description"/>
  
  <xsl:template match="dc:metadata"/>

  <xsl:template match="unizh:attention">
    <span class="attention">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  <xsl:template match="unizh:highlights">
    <xsl:for-each select="unizh:highlight">
      <table width="100%">
        <tr>
          <td class="highlight{(position()-1) mod 3}">
            <xsl:apply-templates/>
            <!-- Dots for asset upload -->
            <xsl:call-template name="asset-dots">
              <xsl:with-param name="insertWhere" select="'inside'"/>
            </xsl:call-template>
          </td>
        </tr>
      </table>
    </xsl:for-each>
  </xsl:template>
 
  
  <xsl:template match="xhtml:td[not(ancestor::*[@id = 'menu'])]">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:call-template name="asset-dots">
        <xsl:with-param name="insertWhere" select="'inside'"/>
      </xsl:call-template>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="xhtml:body/xhtml:*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
    <xsl:call-template name="asset-dots"/>
  </xsl:template>
  
  <xsl:template match="xhtml:body/xhtml:h2">
    
      <xsl:choose>
        <xsl:when test="@locator">
          <table border="0" width="100%">
            <tr>
              <td>
                <h2>
                  <xsl:apply-templates/>
                </h2>
              </td>
              <td align="right">
                <a name="{@locator}"/>
                <xsl:for-each select="preceding::xhtml:h2[@locator]">
                  <a href="#{@locator}"><xsl:value-of select="@locator"/></a>&#160;
                </xsl:for-each>
                <xsl:value-of select="@locator"/>&#160;
                <xsl:for-each select="following::xhtml:h2[@locator]">
                  <a href="#{@locator}"><xsl:value-of select="@locator"/></a>&#160;
                </xsl:for-each>
              </td>
              <td width="20" align="right">
                <a href="#top"><img src="images/top.gif" border="0"/></a>
              </td>
            </tr>
          </table>
        </xsl:when>
        <xsl:otherwise>
          <h2>
            <a name="{.}"/>
            <xsl:apply-templates/>
          </h2>
        </xsl:otherwise>
     </xsl:choose>
  </xsl:template>
 
  <xsl:template match="//xhtml:h3">
    <h3>
      <xsl:choose>
        <xsl:when test="@locator">
          <div class="locator-heading">
            <span class="heading">
              <xsl:apply-templates/>
            </span>
            <span class="locator-refs">
              <a name="{@locator}"/>
              <xsl:for-each select="preceding::xhtml:h3[@locator]">
                <a href="#{@locator}"><xsl:value-of select="@locator"/></a>&#160;
              </xsl:for-each>
              <xsl:value-of select="@locator"/>&#160;
              <xsl:for-each select="following::xhtml:h3[@locator]">
                <a href="#{@locator}"><xsl:value-of select="@locator"/></a>&#160;
              </xsl:for-each>
            </span>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
     </xsl:choose>
    </h3>
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
          <img alt="" border="0" height="16"
            src="{$imageprefix}/icons/{$suffix}.gif" width="16"/>
        </a>
        <xsl:text> </xsl:text>
        <a href="{$nodeid}/{@src}">
          <xsl:value-of select="text()"/>
        </a>
        (<xsl:value-of select="format-number($extent div 1024, '#.#')"/>KB)
    </div>
    </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="asset-dots"/>
   </xsl:template>
    
  <xsl:template match="unizh:toc">
    <ul class="anchors">
      <!-- this assumes 2 things: each h2 has a corresponding anchor, and that
      anchor has the same name as the h2. The anchor is set by the template
      xhtml:body/xhtml:h2, which should be called before -->
      <xsl:apply-templates mode="anchor" select="//xhtml:h2"/>
    </ul>
  </xsl:template>
  
  <xsl:template match="xhtml:h2" mode="anchor">
    <li>
      <a href="#{.}">
        <xsl:value-of select="."/>
      </a>
    </li>
  </xsl:template>
  
  <xsl:template match="xhtml:h2[(ancestor::index:child)]" mode="anchor"/>
  
  <xsl:template match="unizh:children">
    <ul class="children">
      <xsl:apply-templates select="index:child"/>
    </ul>
  </xsl:template>
  
  <xsl:template match="index:child">
    <xsl:value-of select="descendant::lenya:meta/dc:title"/>
    <xsl:apply-templates select="index:child"/>
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

  <xsl:template match="elt:toc">
    <xsl:apply-templates select="//xhtml:div[@id = 'toc']"/>
  </xsl:template>

  <xsl:template match="elt:disclaimer">
    <span class="disclaimer">
      <xsl:value-of select="."/>
    </span>
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
  
</xsl:stylesheet>
