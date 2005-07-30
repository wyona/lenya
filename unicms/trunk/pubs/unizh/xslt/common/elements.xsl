<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: elements.xsl,v 1.79 2005/01/17 09:15:15 thomas Exp $ -->
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:index="http://apache.org/cocoon/lenya/documentindex/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" xmlns:uz="http://unizh.ch"
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
    <h1>
      <xsl:if test="$rendertype = 'edit'">
        <xsl:attribute name="bxe_xpath">/xhtml:<xsl:value-of select="$document-element-name"/>/lenya:meta/dc:title</xsl:attribute>
      </xsl:if>
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
    <p class="slogan">
      <xsl:choose>
        <xsl:when test="$document-element-name = 'homepage'">
           <xsl:attribute name="bxe_xpath">/unizh:homepage/unizh:slogan</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="bxe_xpath">/xhtml:<xsl:value-of select="$document-element-name"/>/unizh:slogan</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates/>
    </p>
   </xsl:template>
   
  
  <xsl:template match="unizh:sitemap">

    <xsl:variable name="group" select="@group"/>

    <xsl:variable name="depth">
      <xsl:choose>
        <xsl:when test="@depth">
          <xsl:value-of select="@depth"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="99"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="show">
      <xsl:choose>
        <xsl:when test="@show">
          <xsl:value-of select="@show"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'any_language'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="not(@group) or (@group = 'no_grouping')">
        <xsl:apply-templates select="/document/xhtml:div[@id = 'sitemap']/xhtml:div[@id = 'by_topic']" mode="no_grouping">
          <xsl:with-param name="base" select="@base"/>
          <xsl:with-param name="depth" select="$depth"/>
          <xsl:with-param name="show" select="$show"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="/document/xhtml:div[@id = 'sitemap']/xhtml:div[@id = $group]">
          <xsl:with-param name="base" select="@base"/>
          <xsl:with-param name="depth" select="$depth"/>
          <xsl:with-param name="show" select="$show"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'alphabetically']">

    <xsl:param name="base"/>
    <xsl:param name="depth"/>
    <xsl:param name="show"/>

    <xsl:variable name="current_nodes_level" select="*[@current = 'true']/@level"/>

    <xsl:choose>
      <xsl:when test="not($base) or ($base = 'root') or ($current_nodes_level = 0)">
  <!-- (above, the last restriction) the homepage should always be treated in 'root' mode - thus considering its siblings as its children -->

        <xsl:for-each select="*[(@level &lt; $depth) and ((@same_language = 'true') or ($show = 'any_language'))]">

  <!-- relying upon the position to generate the group headers obliges us not to exclude any more nodes;
       if we would do that, an entry in the list might miss its group header (when it belongs to the same group
       as its (excluded) predecessor); that's why the above selection must contain all remaining restrictions  -->

          <xsl:variable name="precedent_pos" select="position() - 1"/>
          <xsl:if test="(position() = 1) or (substring(., 1, 1) != substring(../*[$precedent_pos], 1, 1))">
            <h3> <a name="{substring(., 1, 1)}"> <xsl:value-of select="substring(., 1, 1)"/> </a> </h3> 
          </xsl:if>

          <p> <a href="{@href}"> <xsl:value-of select="."/> </a> </p>
        </xsl:for-each>

      </xsl:when>
      <xsl:otherwise>

        <xsl:for-each select="*[(@currents_child = 'true') and (@level &lt; $current_nodes_level + $depth) and ((@same_language = 'true') or ($show = 'any_language'))]">
          <xsl:variable name="precedent_pos" select="position() - 1"/>

          <xsl:if test="(position() = 1) or (substring(., 1, 1) != substring(../*[$precedent_pos], 1, 1))">
            <h3> <a name="{substring(., 1, 1)}"> <xsl:value-of select="substring(., 1, 1)"/> </a> </h3> 
          </xsl:if>

          <p> <a href="{@href}"> <xsl:value-of select="."/> </a> </p>
        </xsl:for-each>

      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'by_topic']">

    <xsl:param name="base"/>
    <xsl:param name="depth"/>
    <xsl:param name="show"/>

    <xsl:variable name="current_nodes_level" select="*[@current = 'true']/@level"/>

    <xsl:choose>
      <xsl:when test="not($base) or ($base = 'root') or ($current_nodes_level = 0)">
  <!-- (above, the last restriction) the homepage should always be treated in 'root' mode - thus considering its siblings as its children -->

        <xsl:for-each select="*[(@level &lt; $depth) and ((@same_language = 'true') or ($show = 'any_language'))]">

  <!-- relying upon the position to generate the group headers obliges us not to exclude any more nodes;
       if we would do that, an entry in the list might miss its group header (when it belongs to the same group
       as its (excluded) predecessor); that's why the above selection must contain all remaining restrictions  -->

          <xsl:choose>
            <xsl:when test="(@level = 0) or (@level = 1)">
              <h3> <a name="{.}"> <xsl:value-of select="."/> </a> </h3>
            </xsl:when>
            <xsl:otherwise>
              <p> <a href="{@href}"> <xsl:value-of select="."/> </a> </p>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>

      </xsl:when>
      <xsl:otherwise>

        <xsl:for-each select="*[(@currents_child = 'true') and (@level &lt; $current_nodes_level + $depth) and ((@same_language = 'true') or ($show = 'any_language'))]">
          <xsl:choose>
            <xsl:when test="@level &lt; $current_nodes_level + 2">
              <h3> <a name="{.}"> <xsl:value-of select="."/> </a> </h3>
            </xsl:when>
            <xsl:otherwise>
              <p> <a href="{@href}"> <xsl:value-of select="."/> </a> </p>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>

      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'by_topic']" mode="no_grouping">

    <xsl:param name="base"/>
    <xsl:param name="depth"/>

    <xsl:for-each select="*">
      <xsl:choose>
        <xsl:when test="not($base) or ($base = 'root') or (@currents_child = 'true')">
          <p> <a href="{@href}"> <xsl:value-of select="."/> </a> </p>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:for-each>

  </xsl:template>


  <xsl:template match="xhtml:p[xhtml:object]" priority="3">     
    <xsl:if test="node()[not(self::xhtml:object) and normalize-space() != '']">
      <xsl:for-each select="node()">
        <xsl:choose>
          <xsl:when test="not(self::xhtml:object)">
            <xsl:apply-templates select="."/>
          </xsl:when>
          <xsl:otherwise>
            <p></p>
            <xsl:apply-templates select="self::xhtml:object"/>
            <p></p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:if>
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
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="unizh:highlight">
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
  </xsl:template>
 
  <xsl:template match="unizh:rss-reader">
    <xsl:variable name="items" select="@items"/>
    <table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td style="background-color: #669; color: #fff"><xsl:value-of select="xhtml:title"/></td>
      </tr>
      <tr>
        <td style="background-color: #ddd">
          <xsl:for-each select="rss/channel/item">
            <xsl:if test="$items = '' or position() &lt;= $items">
              <a target="_blank" href="{link}"><xsl:value-of select="title"/></a><br/>
              <!-- <xsl:value-of select="description"/><br/>-->
            </xsl:if>
          </xsl:for-each> 
          <xsl:if test="not(rss/channel/item)">
            --
          </xsl:if>
         </td>
      </tr>
    </table>
  </xsl:template>

 
  <xsl:template match="unizh:highlights" mode="print">
    <div class="highlights">
      <xsl:for-each select="unizh:highlight">
        <div class="highlight{(position()-1) mod 3}">
          <xsl:apply-templates/>
          <!-- Dots for asset upload -->
          <xsl:call-template name="asset-dots">
            <xsl:with-param name="insertWhere" select="'inside'"/>
          </xsl:call-template>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>
  
  <xsl:template match="unizh:highlight-title">
    <p class="highlight-title">
      <xsl:apply-templates/>
    </p>
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
  
  <xsl:template match="xhtml:body//xhtml:h2">
    <h2>
      <a name="{.}"/>
      <xsl:apply-templates/>
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
    <xsl:call-template name="asset-dots"/>
   </xsl:template>
    
  <xsl:template match="unizh:toc">
    <ul class="anchors">
      <!-- this assumes 2 things: each h2 has a corresponding anchor, and that
      anchor has the same name as the h2. The anchor is set by the template
      xhtml:body/xhtml:h2, which should be called before -->
      <xsl:apply-templates mode="anchor" select="//xhtml:h2[ancestor::xhtml:body]"/>
    </ul>
  </xsl:template>
  
  <xsl:template match="xhtml:h2[ancestor::xhtml:body]" mode="anchor">
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
  
</xsl:stylesheet>
