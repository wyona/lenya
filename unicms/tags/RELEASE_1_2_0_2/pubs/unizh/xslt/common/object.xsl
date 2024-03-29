<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: elements.xsl,v 1.79 2005/01/17 09:15:15 thomas Exp $ -->
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


  <xsl:template match="xhtml:object[@width != '']">
    <xsl:call-template name="object">
      <xsl:with-param name="width">
        <xsl:choose>
          <xsl:when test="/document/content/xhtml:html/@unizh:columns = 1">
            <xsl:choose>
              <xsl:when test="@width > 800">
                <xsl:text>800</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@width"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="/document/content/xhtml:html/@unizh:columns = 2">                  
            <xsl:choose>
              <xsl:when test="@width > 615">
                <xsl:text>615</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@width"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="@width > 415">
            <xsl:text>415</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@width"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="xhtml:object[@width != '' and xhtml:div[@class = 'caption']]">
    <table border="0" cellpadding="0" cellspacing="0" class="imgMitLegende">
      <tr>
        <td class="flexibleimage">
          <xsl:call-template name="object">
            <xsl:with-param name="width">
              <xsl:choose>
                <xsl:when test="/document/content/xhtml:html/@unizh:columns = 1">
                  <xsl:choose>
                    <xsl:when test="@width > 800">
                      <xsl:text>800</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="@width"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="/document/content/xhtml:html/@unizh:columns = 2"> 
                  <xsl:choose>
                    <xsl:when test="@width > 615">
                      <xsl:text>615</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="@width"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="@width > 415">
                  <xsl:text>415</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@width"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
      <tr>
        <td>
          <div class="legende">
            <xsl:value-of select="xhtml:div[@class = 'caption']"/><xsl:comment/>
          </div>
        </td>
      </tr>
    </table>
  </xsl:template>


  <xsl:template match="xhtml:object">
    <div class="imgTextfluss">
      <xsl:call-template name="object">
         <xsl:with-param name="width">204</xsl:with-param> 
      </xsl:call-template>
      <xsl:if test="xhtml:div[@class = 'caption']">
        <div class="legende">
          <xsl:value-of select="xhtml:div[@class = 'caption']"/><xsl:comment/>
          <xsl:if test="@popup = 'true'">
            <a href="#" onClick="window.open('{$nodeid}/{@data}', 'Image', 'width={@width},height={@height}')">(+)</a>
          </xsl:if>
        </div>
      </xsl:if>
    </div>
    <br class="floatclear"/>
  </xsl:template>


  <xsl:template match="xhtml:object[@float = 'true']">
    <div class="imgTextfluss">
      <xsl:call-template name="object">
        <xsl:with-param name="width">204</xsl:with-param>
      </xsl:call-template>
      <div class="legende">
        <xsl:value-of select="xhtml:div[@class = 'caption']"/><xsl:comment/>
        <xsl:if test="@popup = 'true'">
          <a href="#" onClick="window.open('{$nodeid}/{@data}', 'Image', 'width={@width},height={@height}')">(+)</a>
        </xsl:if>
      </div>
    </div>
  </xsl:template>


  <xsl:template match="xhtml:object[@popup = 'true' and not(@float = 'true')]">
    <div class="imgTextfluss">
      <xsl:call-template name="object">
        <xsl:with-param name="width">204</xsl:with-param>
      </xsl:call-template>
      <div class="legende">
        <xsl:value-of select="xhtml:div[@class = 'caption']"/><xsl:comment/>
        <a href="#" onClick="window.open('{$nodeid}/{@data}', 'Image', 'width={@width},height={@height}')">(+)</a>
      </div>
    </div>
    <br class="floatclear"/>
  </xsl:template>


  <xsl:template match="xhtml:object[ancestor::xhtml:table]">
    <xsl:choose>
      <xsl:when test="xhtml:div[@class = 'caption']"> <!-- deprecated -->
        <table width="100" border="0" cellpadding="0" cellspacing="0" class="imgMitLegende">
          <tr>
            <td class="flexibleimage">
              <xsl:call-template name="object">
                <xsl:with-param name="width" select="@width"/>
              </xsl:call-template>
            </td>
          </tr>
          <tr>
            <td>
              <div class="legende">
                <xsl:apply-templates select="xhtml:div[@class = 'caption']"/><xsl:comment/>
              </div>
            </td>
          </tr>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="@width != ''">
            <xsl:call-template name="object">
              <xsl:with-param name="width" select="@width"/>
            </xsl:call-template>
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


  <xsl:template match="xhtml:object[parent::unizh:teaser and ancestor::unizh:related-content]">
    <xsl:call-template name="object">
      <xsl:with-param name="width">160</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="xhtml:object[parent::unizh:teaser and ancestor::unizh:column]">
    <xsl:call-template name="object">
      <xsl:with-param name="width">198</xsl:with-param>
      <xsl:with-param name="height">64</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="xhtml:object[parent::unizh:contcol1]">
    <xsl:call-template name="object">
      <xsl:with-param name="width">160</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="xhtml:object[parent::unizh:lead]">
    <xsl:call-template name="object">
      <xsl:with-param name="width">198</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="xhtml:object[ancestor::unizh:news]">
    <div class="imgTextfluss">
      <xsl:call-template name="object">
        <xsl:with-param name="width">204</xsl:with-param>
      </xsl:call-template>
    </div>
  </xsl:template>

  <xsl:template match="xhtml:object[parent::unizh:short]">
    <div class="imgTextfluss">
      <xsl:choose>
	<xsl:when test="ancestor::index:child">
	  <xsl:call-template name="object">
	    <xsl:with-param name="src" select="concat($contextprefix, substring-before(../../../../@href, '.html'), '/', @data)"/>
	    <xsl:with-param name="width">100</xsl:with-param>
	  </xsl:call-template>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:call-template name="object">
	    <xsl:with-param name="width">100</xsl:with-param>
	  </xsl:call-template>
	</xsl:otherwise>
      </xsl:choose>
    </div>
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


  <xsl:template name="object">

    <xsl:param name="width"/>
    <xsl:param name="height"/>
    <xsl:param name="src" select="concat($nodeid, '/', @data)"/>
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

</xsl:stylesheet>
