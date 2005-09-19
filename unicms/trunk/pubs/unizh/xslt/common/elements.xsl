<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: elements.xsl,v 1.79 2005/01/17 09:15:15 thomas Exp $ -->
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
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

    <xsl:variable name="group" select="@group"/>

    <xsl:variable name="grouping_level">
      <xsl:choose>
        <xsl:when test="@grouping_level">
          <xsl:value-of select="@grouping_level"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

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
        <xsl:apply-templates select="/document/xhtml:div[@id = 'sitemap']/xhtml:div[@id = 'alphabetically']" mode="no_grouping">
          <xsl:with-param name="base" select="@base"/>
          <xsl:with-param name="depth" select="$depth"/>
          <xsl:with-param name="grouping_level" select="$grouping_level"/>
          <xsl:with-param name="show" select="$show"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="/document/xhtml:div[@id = 'sitemap']/xhtml:div[@id = $group]">
          <xsl:with-param name="base" select="@base"/>
          <xsl:with-param name="depth" select="$depth"/>
          <xsl:with-param name="grouping_level" select="$grouping_level"/>
          <xsl:with-param name="show" select="$show"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'by_topic']">

    <xsl:param name="base"/>
    <xsl:param name="depth"/>
    <xsl:param name="grouping_level"/>
    <xsl:param name="show"/>

    <xsl:variable name="current_nodes_level" select="*[@current = 'true']/@level"/>

    <xsl:choose>
  <!-- the homepage should always be treated in 'root' mode - thus considering its siblings as its children (last restriction) -->
      <xsl:when test="not($base) or ($base = 'root') or ($current_nodes_level = 0)">

        <h3> <i> (Start) </i> <u> <a name="{*[@level = 0]/@label}"> <xsl:value-of select="*[@level = 0]/@label"/> </a> </u> </h3>

  <!-- identify the groups, see if their nodes fulfill the restrictions, and - if yes - print group header and items -->
        <xsl:for-each select="*[(@level = $grouping_level) and (@level &lt; $depth + 1)]">

          <xsl:variable name="headers-basic-url" select="@basic-url"/>

          <xsl:if test="../*[(@level != 0) and (@level &gt; $grouping_level) and (@level &lt; $depth + 1) and ((@same_language = 'true') or ($show = 'any_language')) and (starts-with(@basic-url, $headers-basic-url))]">
            <h3> <a name="{@label}"> <xsl:value-of select="@label"/> </a> </h3> 
          </xsl:if>

          <xsl:for-each select="../*[(@level != 0) and (@level &gt; $grouping_level) and (@level &lt; $depth + 1) and ((@same_language = 'true') or ($show = 'any_language')) and (starts-with(@basic-url, $headers-basic-url))]">
            <p> <a href="{@href}"> <xsl:value-of select="@label"/> </a> </p>
          </xsl:for-each>

        </xsl:for-each>

      </xsl:when>
      <xsl:otherwise>

        <h3> <i> (Start) </i> <u> <a name="{*[@current = 'true']/@label}"> <xsl:value-of select="*[@current = 'true']/@label"/> </a> </u> </h3>

  <!-- identify the groups, see if their nodes fulfill the restrictions, and - if yes - print group header and items -->
        <xsl:for-each select="*[(@currents_child = 'true') and (@level = $current_nodes_level + $grouping_level) and (@level &lt; $current_nodes_level + $depth + 1)]">

          <xsl:variable name="headers-basic-url" select="@basic-url"/>

          <xsl:if test="../*[(@level != $current_nodes_level) and (@level &gt; $current_nodes_level + $grouping_level) and (@level &lt; $current_nodes_level + $depth + 1) and ((@same_language = 'true') or ($show = 'any_language')) and (starts-with(@basic-url, $headers-basic-url))]">
            <h3> <a name="{@label}"> <xsl:value-of select="@label"/> </a> </h3> 
          </xsl:if>

          <xsl:for-each select="../*[(@level != $current_nodes_level) and (@level &gt; $current_nodes_level + $grouping_level) and (@level &lt; $current_nodes_level + $depth + 1) and ((@same_language = 'true') or ($show = 'any_language')) and (starts-with(@basic-url, $headers-basic-url))]">
            <p> <a href="{@href}"> <xsl:value-of select="@label"/> </a> </p>
          </xsl:for-each>

        </xsl:for-each>

      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'alphabetically']">

    <xsl:param name="base"/>
    <xsl:param name="depth"/>
    <xsl:param name="grouping_level"/>
    <xsl:param name="show"/>

    <xsl:variable name="current_nodes_level" select="*[@current = 'true']/@level"/>

    <xsl:choose>
  <!-- the homepage should always be treated in 'root' mode - thus considering its siblings as its children (last restriction) -->
      <xsl:when test="not($base) or ($base = 'root') or ($current_nodes_level = 0)">

        <h3> <i> (Start) </i> <u> <a name="{*[@level = 0]/@label}"> <xsl:value-of select="*[@level = 0]/@label"/> </a> </u> </h3>

  <!-- traverse ALL nodes, since position() relates to the WHOLE set, not to a subselection -->
        <xsl:for-each select="*">

          <xsl:variable name="precedent_pos" select="position() - 1"/>
          <xsl:variable name="current_letter" select="substring(@label, 1, 1)"/>

  <!-- the group header is written when reaching the FIRST node starting with a new letter -->
          <xsl:if test="(position() = 1) or (substring(., 1, 1) != substring(../*[$precedent_pos], 1, 1))">

  <!-- write header, if there is an entry belonging to this group -->
            <xsl:if test="../*[(substring(@label, 1, 1)= $current_letter) and (@level &lt; $depth + 1) and (@level &gt; $grouping_level)  and ((@same_language = 'true') or ($show = 'any_language'))]">
              <h3> <a name="{$current_letter}"> <xsl:value-of select="$current_letter"/> </a> </h3> 
            </xsl:if>

            <xsl:for-each select="../*[(substring(@label, 1, 1)= $current_letter) and (@level &lt; $depth + 1) and (@level &gt; $grouping_level) and ((@same_language = 'true') or ($show = 'any_language'))]">
              <p> <a href="{@href}"> <xsl:value-of select="@label"/> </a> </p>
            </xsl:for-each>

          </xsl:if>

        </xsl:for-each>

      </xsl:when>
      <xsl:otherwise>

        <h3> <i> (Start) </i> <u> <a name="{*[@current = 'true']/@label}"> <xsl:value-of select="*[@current = 'true']/@label"/> </a> </u> </h3>

  <!-- traverse ALL nodes, since position() relates to the WHOLE set, not to a subselection -->
        <xsl:for-each select="*">

          <xsl:variable name="precedent_pos" select="position() - 1"/>
          <xsl:variable name="current_letter" select="substring(@label, 1, 1)"/>

  <!-- the group header is written when reaching the FIRST node starting with a new letter -->
          <xsl:if test="(position() = 1) or (substring(., 1, 1) != substring(../*[$precedent_pos], 1, 1))">

  <!-- write header, if there is an entry belonging to this group -->
            <xsl:if test="../*[(substring(@label, 1, 1)= $current_letter) and (@currents_child = 'true') and (@level &lt; $current_nodes_level + $depth + 1) and (@level &gt; $current_nodes_level + $grouping_level) and ((@same_language = 'true') or ($show = 'any_language'))]">
              <h3> <a name="{$current_letter}"> <xsl:value-of select="$current_letter"/> </a> </h3> 
            </xsl:if>

            <xsl:for-each select="../*[(substring(@label, 1, 1)= $current_letter) and (@currents_child = 'true') and (@level &lt; $current_nodes_level + $depth + 1) and (@level &gt; $current_nodes_level + $grouping_level) and ((@same_language = 'true') or ($show = 'any_language'))]">
              <p> <a href="{@href}"> <xsl:value-of select="@label"/> </a> </p>
            </xsl:for-each>

          </xsl:if>

        </xsl:for-each>

      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'alphabetically']" mode="no_grouping">

    <xsl:param name="base"/>
    <xsl:param name="depth"/>
    <xsl:param name="grouping_level"/>
    <xsl:param name="show"/>

    <xsl:variable name="current_nodes_level" select="*[@current = 'true']/@level"/>

    <xsl:choose>
  <!-- the homepage should always be treated in 'root' mode - thus considering its siblings as its children (last restriction) -->
      <xsl:when test="not($base) or ($base = 'root') or ($current_nodes_level = 0)">

        <h3> <i> (Start) </i> <u> <a name="{*[@level = 0]/@label}"> <xsl:value-of select="*[@level = 0]/@label"/> </a> </u> </h3>

        <xsl:for-each select="*[(@level &lt; $depth + 1) and (@level &gt; $grouping_level) and ((@same_language = 'true') or ($show = 'any_language'))]">
          <p> <a href="{@href}"> <xsl:value-of select="@label"/> </a> </p>
        </xsl:for-each>

      </xsl:when>
      <xsl:otherwise>

        <h3> <i> (Start) </i> <u> <a name="{*[@current = 'true']/@label}"> <xsl:value-of select="*[@current = 'true']/@label"/> </a> </u> </h3>

        <xsl:for-each select="*[(@currents_child = 'true') and (@level &lt; $current_nodes_level + $depth + 1) and (@level &gt; $current_nodes_level + $grouping_level) and ((@same_language = 'true') or ($show = 'any_language'))]">
          <p> <a href="{@href}"> <xsl:value-of select="@label"/> </a> </p>
        </xsl:for-each>

      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <!-- <xsl:template match="xhtml:p[xhtml:object]" priority="3">     
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
  </xsl:template> -->
  

  <xsl:template match="xhtml:p[ancestor::xhtml:body and $rendertype = 'imageupload']">
    <xsl:copy>
       <xsl:apply-templates select="*[not(self::lenya:asset-dot)]|text()"/>
       <hr/>
       <xsl:apply-templates select="lenya:asset-dot"/>
       <br/>
       <br/>
    </xsl:copy>
  </xsl:template> 

  <xsl:template match="xhtml:object[$rendertype = 'imageupload']">
    <a href="{lenya:asset-dot/@href}">
      <img src="{$nodeid}/{@data}"/>
    </a>
    <xsl:apply-templates select="lenya:asset-dot[@class = 'delete']"/>
  </xsl:template>

  <xsl:template match="lenya:asset[$rendertype = 'imageupload']">
    <a href="{lenya:asset-dot/@href}">
      <img src="{$imageprefix}/icons/default.gif"/>
    </a>
  </xsl:template>

 
  <xsl:template match="xhtml:object">
      <xsl:choose>
        <xsl:when test="normalize-space(text())">
          <xsl:call-template name="object_link"/>
           <xsl:apply-templates />
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="object_link"/>
        </xsl:otherwise>
      </xsl:choose>
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

  <xsl:template match="unizh:attention">
    <span class="attention">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="unizh:quicklinks">
    Quicklinks:<br/>
    <xsl:for-each select="xhtml:a">
      <xsl:apply-templates select="self::xhtml:a"/><br/>
    </xsl:for-each>
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
        <b><xsl:value-of select="unizh:title"/></b><br/>
        <xsl:apply-templates select="xhtml:p"/>
        <xsl:for-each select="lenya:asset">
          <xsl:apply-templates select="."/><br/>
        </xsl:for-each>
        <xsl:for-each select="xhtml:a">
          <a class="arrow" href="{@href}"><xsl:value-of select="."/></a><br/>
        </xsl:for-each> 
        <xsl:apply-templates select="lenya:asset-dot"/> 
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
    <xsl:apply-templates select="xhtml:p"/>
    <xsl:for-each select="lenya:asset">
      <xsl:apply-templates select="."/><br/>
    </xsl:for-each>
    <xsl:for-each select="xhtml:a">
      <a class="arrow" href="{@href}"><xsl:value-of select="."/></a><br/>
    </xsl:for-each>
    <xsl:apply-templates select="lenya:asset-dot"/> 
    <div class="dotlinemitmargin"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  /></div>
    <p>&#160;</p>
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
             <b><xsl:value-of select="xhtml:rss/xhtml:channel/xhtml:title"/></b><br/>
             <xsl:for-each select="xhtml:rss/xhtml:channel/xhtml:item">
               <xsl:if test="$items = '' or position() &lt;= $items">
                 <a target="_blank" href="{xhtml:link}"><xsl:value-of select="xhtml:title"/></a><br/>
                 <xsl:if test="@descriptions = 'true'">
                    <xsl:value-of select="xhtml:description"/><br/>
                 </xsl:if>
               </xsl:if>
             </xsl:for-each>
             <xsl:if test="xhtml:rss/xhtml:channel/xhtml:link">
               <a class="arrow" target="_blank" href="{xhtml:rss/xhtml:channel/xhtml:link}">weiter</a>
             </xsl:if> 
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
       <h2><xsl:value-of select="xhtml:rss/xhtml:channel/xhtml:title"/></h2><br/>
       <xsl:for-each select="xhtml:rss/xhtml:channel/xhtml:item">
          <xsl:if test="$items = '' or position() &lt;= $items">
            <a target="_blank" href="{xhtml:link}"><xsl:value-of select="xhtml:title"/></a><br/>
            <xsl:value-of select="xhtml:description"/><br/>
          </xsl:if>
      </xsl:for-each>
      <xsl:if test="xhtml:rss/xhtml:channel/xhtml:link">
        <a class="arrow" target="_blank" href="{xhtml:rss/xhtml:channel/xhtml:link}">weiter</a>
      </xsl:if> 
      <xsl:if test="not(xhtml:rss/xhtml:channel/xhtml:item)">
        --
      </xsl:if>
  </xsl:template> 



 
  <xsl:template match="xhtml:td[not(ancestor::*[@id = 'menu'])]">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:apply-templates select="lenya:asset-dot"/>
    </xsl:copy>
  </xsl:template>
  
  
  <xsl:template match="xhtml:body//xhtml:h2">
    <h2>
      <a name="{.}" id="{.}"><xsl:comment/></a>
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
        <a href="{$nodeid}/{@src}">
          <img alt="" border="0" height="16"
            src="{$imageprefix}/icons/default.gif" width="16" align="left"/>
        </a>
        <xsl:text> </xsl:text>
        <a href="{$nodeid}/{@src}">
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
  
  <xsl:template match="xhtml:h2[ancestor::index:child]" mode="anchor"/> 
 
  <xsl:template match="unizh:children[descendant::unizh:newsitem | descendant::unizh:collection | descendant::unizh:people]">
    <xsl:apply-templates select="index:child"/>
  </xsl:template>

  <xsl:template match="unizh:level">
    <hr/>
    <xsl:apply-templates select="level:node"/>
  </xsl:template>

  <xsl:template match="level:node">
    <xsl:choose>
      <xsl:when test="concat($root, $documentid, '.html') = concat($contextprefix, @href)">
        <xsl:value-of select="descendant::dc:title"/>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$contextprefix}{@href}"><xsl:value-of select="descendant::dc:title"/></a>
      </xsl:otherwise>
    </xsl:choose>
    <br/> 
  </xsl:template>

  <xsl:template match="xhtml:div[@id='link-to-parent']">
    <xhtml:a href="{@href}"><xsl:value-of select="."/></xhtml:a>
  </xsl:template> 

  <xsl:template match="unizh:children[ancestor::unizh:news]">
    <xsl:choose>
      <xsl:when test="index:child">
        <xsl:for-each select="index:child">
          <h2><xsl:value-of select="*/*/lenya:meta/dc:title"/></h2>
          <p>
            <xsl:value-of select="*/*/unizh:short/unizh:text"/>
            <br/>
            <xsl:choose>
              <xsl:when test="*/*/xhtml:body/xhtml:p != '&#160;'">
                <a href="{$contextprefix}{@href}">Mehr...</a>
              </xsl:when>
              <xsl:otherwise>
                <a href="{*/*/unizh:short/xhtml:a/@href}">
                  <xsl:value-of select="*/*/unizh:short/xhtml:a"/>
                </a>
                <xsl:if test="$area = 'authoring'">
                  |  <a href="{$contextprefix}{@href}">Edit View...</a>
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


   <xsl:template match="unizh:children[ancestor::unizh:people]">
    <xsl:choose>
      <xsl:when test="index:child">
        <xsl:for-each select="index:child">
          <h2>
            <xsl:value-of select="*/*/unizh:academictitle"/> 
            <xsl:value-of select="*/*/unizh:firstname"/>&#160;
            <xsl:value-of select="*/*/unizh:lastname"/>
          </h2>
          <p>
            Funktion: <xsl:value-of select="*/*/unizh:position"/><br/>
            Einheit: <xsl:value-of select="*/*/unizh:unit"/><br/>
            Email: <xsl:value-of select="*/*/unizh:email"/><br/>
            Homepage: <xsl:value-of select="*/*/unizh:url"/><br/>
            <xsl:value-of select="*/*/unizh:remarks"/><br/>
            <xsl:if test="$area = 'authoring'">
              <a href="{$contextprefix}{@href}">Edit View...</a>
            </xsl:if>
          </p>
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

 
</xsl:stylesheet>
