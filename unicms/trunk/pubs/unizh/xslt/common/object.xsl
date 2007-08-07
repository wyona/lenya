<?xml version="1.0" encoding="UTF-8"?>


<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:index="http://apache.org/cocoon/lenya/documentindex/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" xmlns:uz="http://unizh.ch"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
  <xsl:param name="documentid"/>
  <xsl:param name="nodeid"/>
  <xsl:param name="contextprefix"/>
  <xsl:param name="rendertype"/>


  <!-- objects in tables get a default width of 100px -->
  <xsl:template match="xhtml:object[ancestor::xhtml:table]">
    <xsl:apply-templates select="." mode="objectElement">
      <xsl:with-param name="width-default" select="100"/>
    </xsl:apply-templates>
  </xsl:template>


  <!-- objects in left column go straight out, no caption, no objectElement -->
  <xsl:template match="xhtml:object[parent::unizh:contcol1]">
    <xsl:call-template name="object">
      <xsl:with-param name="width">165</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <!-- no caption for objects in rel con teaser either -->
  <xsl:template match="xhtml:object[parent::unizh:teaser and ancestor::unizh:related-content]">
    <xsl:call-template name="object">
      <xsl:with-param name="width">160</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <!-- the width of teaser images in content columns depends on the number of columns -->
  <xsl:template match="xhtml:object[parent::unizh:teaser and ancestor::unizh:column]">
    <xsl:variable name="width">
      <xsl:choose>
        <xsl:when test="$numColumns = 3">
          <xsl:value-of select="171"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="178"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="object">
      <xsl:with-param name="width" select="$width"/>
    </xsl:call-template>
  </xsl:template>


  <!-- the width of images in linklists also depends on the number of columns -->
  <xsl:template match="xhtml:object[parent::unizh:links]">
    <xsl:variable name="width">
      <xsl:choose>
        <xsl:when test="$numColumns = 3">
          <xsl:value-of select="191"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="198"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="object">
      <xsl:with-param name="width" select="$width"/>
    </xsl:call-template>
  </xsl:template>


  <!-- lead image can only be full width or one column width -->
  <xsl:template match="xhtml:object[parent::unizh:lead]">
    <xsl:variable name="width">
      <xsl:choose>
        <xsl:when test="$numColumns = 3">
          <xsl:choose>
            <xsl:when test="not(following-sibling::xhtml:p) or not(following-sibling::xhtml:p/descendant-or-self::*[text()])">
              <xsl:value-of select="605"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="191"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="not(following-sibling::xhtml:p) or not(following-sibling::xhtml:p/descendant-or-self::*[text()])">
              <xsl:value-of select="416"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="198"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="object">
      <xsl:with-param name="width" select="$width"/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="xhtml:object[parent::unizh:person]">
    <xsl:choose>
      <xsl:when test="not(@data)">
        <xsl:call-template name="object">
          <xsl:with-param name="src" select="concat($imageprefix, '/default_head.gif')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="ancestor::index:child">
            <xsl:choose>
              <xsl:when test="contains(../../../@href, '_')">
                <xsl:call-template name="object">
                  <xsl:with-param name="src" select="concat($contextprefix, substring-before(../../../@href, '_'), '/', @data)"/>
                  <xsl:with-param name="width">100</xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="object">
                  <xsl:with-param name="src" select="concat($contextprefix, substring-before(../../../@href, '.html'), '/', @data)"/>
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
  <xsl:template match="xhtml:object[ancestor::xhtml:body and not(parent::unizh:short) and not(parent::unizh:teaser) and not(parent::unizh:links) and not(parent::unizh:lead) and not(ancestor::xhtml:table) and not(parent::unizh:person)]">
    <xsl:choose>
      <xsl:when test="(@float='true') and (name(following-sibling::*[1]) = 'p' or name(following-sibling::*[1]) = 'xhtml:p')"/>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="objectElement"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- wrap object element in xhtml div to enable floating, caption. call this template for all content objects -->
  <xsl:template match="xhtml:object" mode="objectElement">
    <xsl:param name="width-default" select="204"/>
    <xsl:param name="hideCaption"/>
    <xsl:param name="src"/>
    <xsl:variable name="width">
      <xsl:call-template name="width-attribute">
        <xsl:with-param name="width-default" select="$width-default"/>
      </xsl:call-template>
    </xsl:variable>
    <div>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="( (@float = 'true') and (name(following-sibling::*[1]) = 'p' or name(following-sibling::*[1]) = 'xhtml:p') )">
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
        <xsl:text>width:</xsl:text><xsl:value-of select="$width"/><xsl:text>px;</xsl:text>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="$src">
          <xsl:call-template name="object">
            <xsl:with-param name="width">
              <xsl:value-of select="$width"/>
            </xsl:with-param>
            <xsl:with-param name="src">
              <xsl:value-of select="$src"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="object">
            <xsl:with-param name="width">
              <xsl:value-of select="$width"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$hideCaption != 'true' and (((xhtml:div[@class = 'caption']) and (xhtml:div[@class = 'caption'] != '')) or (@popup = 'true'))">
        <div>
          <xsl:value-of select="xhtml:div[@class = 'caption']"/>
          <xsl:if test="@popup = 'true'">
            <a href="#" onClick="window.open('{$nodeid}/{@data}', 'Image', 'width={dc:metadata/lenya:meta/lenya:width},height={dc:metadata/lenya:meta/lenya:height}')">(+)</a>
          </xsl:if>
        </div>
      </xsl:if>
    </div>
  </xsl:template>


  <xsl:template name="object">

    <xsl:param name="width"/>
    <xsl:param name="height"/>
    <xsl:param name="src">
      <xsl:choose>
        <xsl:when test="starts-with(@data, 'http')">
          <xsl:value-of select="@data"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($nodeid, '/', @data)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:param name="href" select="@href"/>
    <xsl:variable name="alt">
      <xsl:choose>
        <xsl:when test="@title != ''">
          <xsl:value-of select="@title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="dc:metadata/dc:title"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$rendertype = 'imageupload'">
        <a href="{lenya:asset-dot/@href}">
          <img src="{$src}" alt="{$alt}">
            <xsl:if test="$width">
              <xsl:attribute name="width">
                <xsl:value-of select="$width"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="$height">
              <xsl:attribute name="height">
                <xsl:value-of select="$height"/>
              </xsl:attribute>
            </xsl:if>
          </img>
        </a>
      </xsl:when>
      <xsl:when test="$href != ''">
        <a href="{$href}">
          <img src="{$src}" alt="{$alt}">
            <xsl:if test="$width">
              <xsl:attribute name="width">
                <xsl:value-of select="$width"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="$height">
              <xsl:attribute name="height">
                <xsl:value-of select="$height"/>
              </xsl:attribute>
            </xsl:if>
          </img>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <img src="{$src}" alt="{$alt}">
          <xsl:if test="$width">
            <xsl:attribute name="width">
              <xsl:value-of select="$width"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="$height">
            <xsl:attribute name="height">
              <xsl:value-of select="$height"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="$width = 415">
            <xsl:attribute name="class">fullimg</xsl:attribute>
          </xsl:if>
        </img>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template> 


  <xsl:template name="width-attribute">
    <xsl:param name="width-default"/>
    <xsl:choose>
      <xsl:when test="not(@width) or (@width = '') or contains(@width, 'px')">
        <xsl:value-of select="$width-default"/>
      </xsl:when>
      <xsl:when test="(/document/content/xhtml:html/@unizh:columns = 1) and (@width > 800)">
        <xsl:text>800</xsl:text>
      </xsl:when>
      <xsl:when test="(/document/content/xhtml:html/@unizh:columns = 2) and (@width > 615)">
        <xsl:text>615</xsl:text>
      </xsl:when>
      <xsl:when test="(/document/content/xhtml:html/@unizh:columns = 3) and (@width > 416)">
        <xsl:text>416</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@width"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
