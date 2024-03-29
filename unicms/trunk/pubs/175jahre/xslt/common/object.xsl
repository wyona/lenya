<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:index="http://apache.org/cocoon/lenya/documentindex/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" xmlns:uz="http://unizh.ch"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>


  <xsl:param name="documentid" />
  <xsl:param name="nodeid" />
  <xsl:param name="contextprefix" />
  <xsl:param name="rendertype" />


  <!-- objects in tables get a default width of 100px -->
  <xsl:template match="xhtml:object[ancestor::xhtml:table]">
    <xsl:apply-templates select="." mode="objectElement">
      <xsl:with-param name="width-default" select="100" />
    </xsl:apply-templates>
  </xsl:template>


  <!-- objects in left column go straight out, no caption, no objectElement -->
  <xsl:template match="xhtml:object[parent::unizh:contcol1]">
    <xsl:call-template name="object">
      <xsl:with-param name="width">188</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <!-- no caption for objects in rel con teaser either -->
  <xsl:template match="xhtml:object[parent::unizh:teaser and ancestor::unizh:related-content]">
    <xsl:call-template name="object">
      <xsl:with-param name="width">168</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <!-- same for partner object -->
  <xsl:template match="xhtml:object[parent::unizh:partner and ancestor::unizh:related-content]">
    <xsl:call-template name="object">
      <xsl:with-param name="width">168</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <!-- the width of teaser images in content columns depends on the type of column -->
  <xsl:template match="xhtml:object[parent::unizh:teaser and ancestor::unizh:column]">
    <xsl:variable name="width">
      <xsl:choose>
        <xsl:when test="ancestor::unizh:column[@double = 'true']">
          <xsl:value-of select="392" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="188" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="object">
      <xsl:with-param name="width" select="$width" />
    </xsl:call-template>
  </xsl:template>


  <!-- the width of images in linklists also depends on the type of column -->
  <xsl:template match="xhtml:object[parent::unizh:links]">
    <xsl:variable name="width">
      <xsl:choose>
        <xsl:when test="ancestor::unizh:column[@double = 'true']">
          <xsl:value-of select="392" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="188" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="object">
      <xsl:with-param name="width" select="$width" />
    </xsl:call-template>
  </xsl:template>


  <!-- lead image can only be full width or one column width -->
  <xsl:template match="xhtml:object[parent::unizh:lead]">
    <xsl:variable name="width">
      <xsl:choose>
        <xsl:when test="( $numColumns + $numDoubles ) = 2">
          <xsl:choose>
            <xsl:when test="not(following-sibling::xhtml:p) or not(following-sibling::xhtml:p/descendant-or-self::*[text()])">
              <xsl:value-of select="392" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="188" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="( $numColumns + $numDoubles ) = 3">
          <xsl:choose>
            <xsl:when test="not(following-sibling::xhtml:p) or not(following-sibling::xhtml:p/descendant-or-self::*[text()])">
              <xsl:value-of select="596" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="188" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="not(following-sibling::xhtml:p) or not(following-sibling::xhtml:p/descendant-or-self::*[text()])">
              <xsl:value-of select="800" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="188" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="object">
      <xsl:with-param name="width" select="$width" />
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="xhtml:object[parent::unizh:person]">
    <xsl:choose>
      <xsl:when test="not(@data)">
        <xsl:call-template name="object">
          <xsl:with-param name="src" select="concat($imageprefix, '/default_head.gif')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="ancestor::index:child">
            <xsl:choose>
              <xsl:when test="contains(../../../@href, '_')">
                <xsl:call-template name="object">
                  <xsl:with-param name="src" select="concat($contextprefix, substring-before(../../../@href, '_'), '/', @data)" />
                  <xsl:with-param name="width">100</xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="object">
                  <xsl:with-param name="src" select="concat($contextprefix, substring-before(../../../@href, '.html'), '/', @data)" />
                  <xsl:with-param name="width">100</xsl:with-param>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="object">
              <xsl:with-param name="width">100</xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose> 
  </xsl:template>


  <!-- this template filters float objects, which are to be called from their following siblings -->
  <xsl:template match="xhtml:object[(ancestor::xhtml:body or ancestor::unizh:description) and not(parent::unizh:short) and not(parent::unizh:teaser) and not(parent::unizh:links) and not(parent::unizh:lead) and not(ancestor::xhtml:table) and not(parent::unizh:person)]">
    <!-- unizh:description -> 'person' doctype -->
    <xsl:choose>
      <xsl:when test="(@float='true') and (name(following-sibling::*[1]) = 'p' or name(following-sibling::*[1]) = 'xhtml:p')" />
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="objectElement" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- wrap object element in xhtml div to enable floating, caption. call this template for all content objects -->
  <xsl:template match="xhtml:object" mode="objectElement">
    <xsl:param name="width-default" select="188" />
    <xsl:param name="hideCaption" />
    <xsl:param name="src" />
    <xsl:variable name="width">
      <xsl:call-template name="width-attribute">
        <xsl:with-param name="width-default" select="$width-default" />
      </xsl:call-template>
    </xsl:variable>
    <div>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="( (@float = 'true') and (name(following-sibling::*[1]) = 'p' or name(following-sibling::*[1]) = 'xhtml:p' or parent::xhtml:p) )">
            <xsl:choose>
              <xsl:when test="@align = 'right'">
                <xsl:text>objectFloat right</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>objectFloat left</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>objectBlock</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="style">
        <xsl:text>width:</xsl:text><xsl:value-of select="$width" /><xsl:text>px;</xsl:text>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="$src">
          <xsl:call-template name="object">
            <xsl:with-param name="width">
              <xsl:value-of select="$width" />
            </xsl:with-param>
            <xsl:with-param name="src">
              <xsl:value-of select="$src" />
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="object">
            <xsl:with-param name="width">
              <xsl:value-of select="$width" />
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$hideCaption != 'true' and (((xhtml:div[@class = 'caption']) and (xhtml:div[@class = 'caption'] != '')) or (@popup = 'true'))">
        <div>
          <xsl:if test="((xhtml:div[@class = 'caption']) and (xhtml:div[@class = 'caption'] != ''))">
            <xsl:value-of select="xhtml:div" />
            <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:if test="@popup = 'true'">
            <xsl:choose>
              <xsl:when test="starts-with(@data, 'http')">
                <a href="#" onClick="window.open('{@data}', 'Image')">(+)</a>
              </xsl:when>
              <xsl:otherwise>
                <a href="#" onClick="window.open('{$nodeid}/{@data}', 'Image', 'width={dc:metadata/lenya:meta/lenya:width},height={dc:metadata/lenya:meta/lenya:height}')">(+)</a>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </div>
      </xsl:if>
    </div>
  </xsl:template>


  <!-- this template should handle all objects -->
  <xsl:template name="object">
    <xsl:param name="width" />
    <xsl:param name="height" select="@height" />
    <xsl:param name="src">
      <xsl:choose>
        <xsl:when test="starts-with(@data, 'http')">
          <xsl:value-of select="@data" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($nodeid, '/', @data)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:param name="href" select="@href" />
    <xsl:param name="autoplay" select="@autoplay" />
    <xsl:param name="controller" select="@controller" />
    <xsl:variable name="alt">
      <xsl:choose>
        <xsl:when test="@title != ''">
          <xsl:value-of select="@title" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="dc:metadata/dc:title" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="suffix">
      <xsl:call-template name="substring-after-last">
        <xsl:with-param name="input" select="$src" />
        <xsl:with-param name="substr">.</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$suffix = 'mov' or $suffix = 'mp4' or $suffix = 'm4v'">
        <xsl:call-template name="objectQuickTimeVideo">
          <xsl:with-param name="width" select="$width" />
          <xsl:with-param name="height">
            <xsl:choose>
              <xsl:when test="$controller = 'false'">
                <xsl:value-of select="$height" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$height + 16" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="src" select="$src" />
          <xsl:with-param name="type">
            <xsl:choose>
              <xsl:when test="@type != ''">
                <xsl:value-of select="@type" />
              </xsl:when>
              <xsl:when test="$suffix = 'mov'">
                <xsl:text>video/quicktime</xsl:text>
              </xsl:when>
              <xsl:when test="$suffix = 'mp4'">
                <xsl:text>video/mp4</xsl:text>
              </xsl:when>
              <xsl:when test="$suffix = 'm4v'">
                <xsl:text>video/x-m4v</xsl:text>
              </xsl:when>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="controller" select="$controller" />
          <xsl:with-param name="autoplay" select="$autoplay" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$suffix = 'wmv' or $suffix = 'asf'">
        <xsl:call-template name="objectWindowsMediaVideo">
          <xsl:with-param name="width" select="$width" />
          <xsl:with-param name="height">
            <xsl:choose>
              <xsl:when test="$controller = 'false'">
                <xsl:value-of select="$height" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$height + 46" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="src" select="$src" />
          <xsl:with-param name="type">
            <xsl:choose>
              <xsl:when test="@type != ''">
                <xsl:value-of select="@type" />
              </xsl:when>
              <xsl:when test="$suffix = 'wmv'">
                <xsl:text>video/x-ms-wmv</xsl:text>
              </xsl:when>
              <xsl:when test="$suffix = 'asf'">
                <xsl:text>video/x-ms-asf</xsl:text>
              </xsl:when>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="controller" select="$controller" />
          <xsl:with-param name="autoplay" select="$autoplay" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$suffix = 'rm'">
        <xsl:call-template name="objectRealMediaVideo">
          <xsl:with-param name="width" select="$width" />
          <xsl:with-param name="height" select="$height" />
          <xsl:with-param name="src" select="$src" />
          <xsl:with-param name="type">
            <xsl:choose>
              <xsl:when test="@type != ''">
                <xsl:value-of select="@type" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>application/vnd.rn-realmedia</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="controller" select="$controller" />
          <xsl:with-param name="autoplay" select="$autoplay" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$suffix = 'swf' or starts-with(@data, 'http://www.youtube.com/')">
        <xsl:call-template name="objectShockwaveFlash">
          <xsl:with-param name="width" select="$width" />
          <xsl:with-param name="height" select="$height" />
          <xsl:with-param name="src" select="$src" />
          <xsl:with-param name="type">
            <xsl:choose>
              <xsl:when test="@type != ''">
                <xsl:value-of select="@type" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>application/x-shockwave-flash</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="controller" select="$controller" />
          <xsl:with-param name="autoplay" select="$autoplay" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$suffix = 'mp3' or $suffix = 'm4a'">
        <xsl:call-template name="objectQuickTimeAudio">
          <xsl:with-param name="width" select="$width" />
          <xsl:with-param name="height" select="$height" />
          <xsl:with-param name="src" select="$src" />
          <xsl:with-param name="type">
            <xsl:choose>
              <xsl:when test="@type != ''">
                <xsl:value-of select="@type" />
              </xsl:when>
              <xsl:when test="$suffix = 'mp3'">
                <xsl:text>audio/mpeg</xsl:text>
              </xsl:when>
              <xsl:when test="$suffix = 'm4a'">
                <xsl:text>audio/x-m4a</xsl:text>
              </xsl:when>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="controller" select="$controller" />
          <xsl:with-param name="autoplay" select="$autoplay" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="objectImage">
          <xsl:with-param name="width" select="$width" />
          <xsl:with-param name="height" select="$height" />
          <xsl:with-param name="src" select="$src" />
          <xsl:with-param name="href" select="$href" />
          <xsl:with-param name="alt" select="$alt" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template> 


  <xsl:template name="objectImage">
    <xsl:param name="width" />
    <xsl:param name="height" />
    <xsl:param name="src" />
    <xsl:param name="href" />
    <xsl:param name="alt" />

    <xsl:choose>
      <xsl:when test="$rendertype = 'imageupload'">
        <a href="{lenya:asset-dot/@href}">
          <img src="{$src}" alt="{$alt}">
            <xsl:if test="$width">
              <xsl:attribute name="width">
                <xsl:value-of select="$width" />
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="$height">
              <xsl:attribute name="height">
                <xsl:value-of select="$height" />
              </xsl:attribute>
            </xsl:if>
          </img>
        </a>
      </xsl:when>
      <xsl:when test="$href != ''">
        <a href="{$href}">
          <img __bxe_id="{@__bxe_id}" src="{$src}" alt="{$alt}">
            <xsl:if test="$width">
              <xsl:attribute name="width">
                <xsl:value-of select="$width" />
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="$height">
              <xsl:attribute name="height">
                <xsl:value-of select="$height" />
              </xsl:attribute>
            </xsl:if>
          </img>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <img __bxe_id="{@__bxe_id}" src="{$src}" alt="{$alt}">
          <xsl:if test="$width">
            <xsl:attribute name="width">
              <xsl:value-of select="$width" />
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="$height">
            <xsl:attribute name="height">
              <xsl:value-of select="$height" />
            </xsl:attribute>
          </xsl:if>
        </img>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="objectQuickTimeVideo">
    <xsl:param name="width" />
    <xsl:param name="height" />
    <xsl:param name="src" />
    <xsl:param name="type" />
    <xsl:param name="autoplay" />
    <xsl:param name="controller" />
    <object classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" codebase="http://www.apple.com/qtactivex/qtplugin.cab">
      <xsl:attribute name="width">
        <xsl:value-of select="$width" />
      </xsl:attribute>
      <xsl:attribute name="height">
        <xsl:value-of select="$height" />
      </xsl:attribute>
      <param name="type">
        <xsl:attribute name="value">
          <xsl:value-of select="$type" />
        </xsl:attribute>
      </param>
      <param name="src">
        <xsl:attribute name="value">
          <xsl:value-of select="$src" />
        </xsl:attribute>
      </param>
      <param name="autoplay">
        <xsl:attribute name="value">
          <xsl:choose>
            <xsl:when test="$autoplay = 'true'">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </param>
      <param name="controller">
        <xsl:attribute name="value">
          <xsl:choose>
            <xsl:when test="$controller = 'false'">false</xsl:when>
            <xsl:otherwise>true</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </param>
      <embed pluginspage="http://www.apple.com/quicktime/download/">
        <xsl:attribute name="type">
          <xsl:value-of select="$type" />
        </xsl:attribute>
        <xsl:attribute name="src">
          <xsl:value-of select="$src" />
        </xsl:attribute>
        <xsl:attribute name="width">
          <xsl:value-of select="$width" />
        </xsl:attribute>
        <xsl:attribute name="height">
          <xsl:value-of select="$height" />
        </xsl:attribute>
        <xsl:attribute name="autoplay">
          <xsl:choose>
            <xsl:when test="$autoplay = 'true'">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="controller">
          <xsl:choose>
            <xsl:when test="$controller = 'false'">false</xsl:when>
            <xsl:otherwise>true</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </embed>
    </object>
  </xsl:template>


  <xsl:template name="objectWindowsMediaVideo">
    <xsl:param name="width" />
    <xsl:param name="height" />
    <xsl:param name="src" />
    <xsl:param name="type" />
    <xsl:param name="autoplay" />
    <xsl:param name="controller" />
    <object classid="clsid:6BF52A52-394A-11d3-B153-00C04F79FAA6" codebase="http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=x,x,x,x">
      <xsl:attribute name="width">
        <xsl:value-of select="$width" />
      </xsl:attribute>
      <xsl:attribute name="height">
        <xsl:value-of select="$height" />
      </xsl:attribute>
      <param name="type">
        <xsl:attribute name="value">
          <xsl:value-of select="$type" />
        </xsl:attribute>
      </param>
      <param name="url">
        <xsl:attribute name="value">
          <xsl:value-of select="$src" />
        </xsl:attribute>
      </param>
      <param name="autostart">
        <xsl:attribute name="value">
          <xsl:choose>
            <xsl:when test="$autoplay = 'true'">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </param>
      <param name="uimode">
        <xsl:attribute name="value">
          <xsl:choose>
            <xsl:when test="$controller = 'false'">none</xsl:when>
            <xsl:otherwise>mini</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </param>
      <param name="showcontrols">
        <xsl:attribute name="value">
          <xsl:choose>
            <xsl:when test="$controller = 'false'">false</xsl:when>
            <xsl:otherwise>true</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </param>
      <embed pluginspage="http://www.microsoft.com/windows/windowsmedia/">
        <xsl:attribute name="type">
          <xsl:value-of select="$type" />
        </xsl:attribute>
        <xsl:attribute name="src">
          <xsl:value-of select="$src" />
        </xsl:attribute>
        <xsl:attribute name="width">
          <xsl:value-of select="$width" />
        </xsl:attribute>
        <xsl:attribute name="height">
          <xsl:value-of select="$height" />
        </xsl:attribute>
        <xsl:attribute name="autostart">
          <xsl:choose>
            <xsl:when test="$autoplay = 'true'">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="uimode">
          <xsl:choose>
            <xsl:when test="$controller = 'false'">none</xsl:when>
            <xsl:otherwise>mini</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="showcontrols">
          <xsl:choose>
            <xsl:when test="$controller = 'false'">false</xsl:when>
            <xsl:otherwise>true</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </embed>
    </object>
  </xsl:template>


  <xsl:template name="objectRealMediaVideo">
    <xsl:param name="width" />
    <xsl:param name="height" />
    <xsl:param name="src" />
    <xsl:param name="type" />
    <xsl:param name="autoplay" />
    <xsl:param name="controller" />
    <object classid="clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA" id="RAOCX01">
      <xsl:attribute name="width">
        <xsl:value-of select="$width" />
      </xsl:attribute>
      <xsl:attribute name="height">
        <xsl:value-of select="$height" />
      </xsl:attribute>
      <param name="type">
        <xsl:attribute name="value">
          <xsl:value-of select="$type" />
        </xsl:attribute>
      </param>
      <param name="src">
        <xsl:attribute name="value">
          <xsl:value-of select="$src" />
        </xsl:attribute>
      </param>
      <param name="autostart">
        <xsl:attribute name="value">
          <xsl:choose>
            <xsl:when test="$autoplay = 'true'">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </param>
      <param name="controls" value="imagewindow" />
      <param name="console" value="delta" />
      <embed>
        <xsl:attribute name="type">
          <xsl:value-of select="$type" />
        </xsl:attribute>
        <xsl:attribute name="src">
          <xsl:value-of select="$src" />
        </xsl:attribute>
        <xsl:attribute name="width">
          <xsl:value-of select="$width" />
        </xsl:attribute>
        <xsl:attribute name="height">
          <xsl:value-of select="$height" />
        </xsl:attribute>
        <xsl:attribute name="autostart">
          <xsl:choose>
            <xsl:when test="$autoplay = 'true'">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="controls">imagewindow</xsl:attribute>
        <xsl:attribute name="console">delta</xsl:attribute>
      </embed>
    </object>
    <xsl:choose>
      <xsl:when test="$controller = 'false'" />
      <xsl:otherwise>
        <object width="416" height="26" classid="clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA" id="RAOCX02">
          <xsl:attribute name="width">
            <xsl:value-of select="$width" />
          </xsl:attribute>
          <xsl:attribute name="height">
            <xsl:value-of select="26" />
          </xsl:attribute>
          <param name="controls" value="controlpanel" />
          <param name="console" value="delta" />
          <embed>
            <xsl:attribute name="src">
              <xsl:value-of select="$src" />
            </xsl:attribute>
            <xsl:attribute name="controls">controlpanel</xsl:attribute>
            <xsl:attribute name="console">delta</xsl:attribute>
            <xsl:attribute name="width">
              <xsl:value-of select="$width" />
            </xsl:attribute>
            <xsl:attribute name="height">
              <xsl:value-of select="26" />
            </xsl:attribute>
          </embed>
        </object>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="objectShockwaveFlash">
    <xsl:param name="width" />
    <xsl:param name="height" />
    <xsl:param name="src" />
    <xsl:param name="type" />
    <xsl:param name="autoplay" />
    <xsl:param name="controller" />
    <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">
      <xsl:attribute name="width">
        <xsl:value-of select="$width" />
      </xsl:attribute>
      <xsl:attribute name="height">
        <xsl:value-of select="$height" />
      </xsl:attribute>
      <param name="type">
        <xsl:attribute name="value">
          <xsl:value-of select="$type" />
        </xsl:attribute>
      </param>
      <param name="movie">
        <xsl:attribute name="value">
          <xsl:value-of select="$src" />
        </xsl:attribute>
      </param>
      <embed pluginspage="http://www.adobe.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash">
        <xsl:attribute name="type">
          <xsl:value-of select="$type" />
        </xsl:attribute>
        <xsl:attribute name="src">
          <xsl:value-of select="$src" />
        </xsl:attribute>
        <xsl:attribute name="width">
          <xsl:value-of select="$width" />
        </xsl:attribute>
        <xsl:attribute name="height">
          <xsl:value-of select="$height" />
        </xsl:attribute>
      </embed>
    </object>
  </xsl:template>


  <xsl:template name="objectQuickTimeAudio">
    <xsl:param name="width" />
    <xsl:param name="height" />
    <xsl:param name="src" />
    <xsl:param name="type" />
    <xsl:param name="autoplay" />
    <xsl:param name="controller" />
    <object classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" codebase="http://www.apple.com/qtactivex/qtplugin.cab">
      <xsl:attribute name="width">
        <xsl:value-of select="$width" />
      </xsl:attribute>
      <xsl:attribute name="height">
        <xsl:value-of select="16" />
      </xsl:attribute>
      <param name="type">
        <xsl:attribute name="value">
          <xsl:value-of select="$type" />
        </xsl:attribute>
      </param>
      <param name="src">
        <xsl:attribute name="value">
          <xsl:value-of select="$src" />
        </xsl:attribute>
      </param>
      <param name="autoplay">
        <xsl:attribute name="value">
          <xsl:choose>
            <xsl:when test="$autoplay = 'true'">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </param>
      <param name="controller">
        <xsl:attribute name="value">
          <xsl:value-of select="'true'" />
        </xsl:attribute>
      </param>
      <embed pluginspage="http://www.apple.com/quicktime/download/">
        <xsl:attribute name="type">
          <xsl:value-of select="$type" />
        </xsl:attribute>
        <xsl:attribute name="src">
          <xsl:value-of select="$src" />
        </xsl:attribute>
        <xsl:attribute name="width">
          <xsl:value-of select="$width" />
        </xsl:attribute>
        <xsl:attribute name="height">
          <xsl:value-of select="16" />
        </xsl:attribute>
        <xsl:attribute name="autoplay">
          <xsl:choose>
            <xsl:when test="$autoplay = 'true'">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="controller">
          <xsl:value-of select="'true'" />
        </xsl:attribute>
      </embed>
    </object>
  </xsl:template>


  <xsl:template name="width-attribute">
    <xsl:param name="width-default" />
    <xsl:choose>
      <xsl:when test="not( @width ) or ( @width = '' ) or contains( @width, 'px' )">
        <xsl:value-of select="$width-default" />
      </xsl:when>
      <xsl:when test="( /document/content/*/@unizh:columns = 1 ) and ( @width > 800 )">
        <xsl:text>800</xsl:text>
      </xsl:when>
      <xsl:when test="( /document/content/*/@unizh:columns = 2 ) and ( @width > 596 )">
        <xsl:text>596</xsl:text>
      </xsl:when>
      <xsl:when test="( ( /document/content/*/@unizh:columns = 3 ) or ( /document/content/unizh:homepage ) ) and ( @width > 392 )">
        <xsl:text>392</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@width" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
