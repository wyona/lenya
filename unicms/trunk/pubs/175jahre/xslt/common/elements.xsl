<?xml version="1.0" encoding="utf-8"?>

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
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
>


  <xsl:param name="root" />
  <xsl:param name="documentid" />
  <xsl:param name="contextprefix" />
  <xsl:param name="rendertype" />


  <xsl:template match="lenya:asset-dot[@class='image']">
    <a href="{@href}"> 
      <img alt="Insert Identity" src="{$contextprefix}/lenya/images/util/uploadimage.gif" />  
    </a>&#160;
  </xsl:template>

  <xsl:template match="lenya:asset-dot[@class='floatImage']">
    <a href="{@href}">
      float
    </a>&#160;
  </xsl:template>

  <xsl:template match="lenya:asset-dot[@class='delete']">
    <a href="{@href}">
      <img alt="Insert Identity" src="{$imageprefix}/icons/delete.gif" />
    </a>&#160;
  </xsl:template>

  <xsl:template match="lenya:asset-dot[@class='asset']">
    <a href="{@href}">
      <img alt="Insert Asset" src="{$contextprefix}/lenya/images/util/uploadasset.gif" />
    </a>&#160; 
  </xsl:template>


  <xsl:template match="dc:title">
    <h1><xsl:apply-templates/></h1>
  </xsl:template>


  <xsl:template match="xhtml:iframe">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="$querystring">
          <xsl:choose>
            <xsl:when test="contains(@src,'?')">
              <xsl:attribute name="src"><xsl:value-of select="@src" />&amp;<xsl:value-of select="$querystring" /></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="src"><xsl:value-of select="@src" />?<xsl:value-of select="$querystring" /></xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="src"><xsl:value-of select="@src" /></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*[name() != 'src']" />
      <xsl:apply-templates/><xsl:comment/>
    </xsl:copy> 
  </xsl:template>


  <xsl:template match="xhtml:p[(parent::xhtml:body or parent::unizh:description) and $rendertype = 'imageupload']">
    <!-- unizh:description -> 'person' doctype -->
    <xsl:variable name="fulltext" select="normalize-space(.)" />

    <xsl:choose>
      <xsl:when test="ancestor::unizh:newsitem and (($fulltext = '') or ($fulltext = '&#160;'))">
          <xsl:copy>
            <xsl:apply-templates select="@*|*[not(self::lenya:asset-dot)]|text()" />
          </xsl:copy>
      </xsl:when>

      <xsl:when test="xhtml:object[@float = 'true']">
        <div class="objectContainer">
          <xsl:copy>
            <xsl:apply-templates select="@*|*[not(self::lenya:asset-dot)]|text()" />
          </xsl:copy>
          <xsl:if test="lenya:asset-dot">
            <br class="floatclear" />
            <hr/>
            <xsl:apply-templates select="lenya:asset-dot" />
            <br/>
            <br/>
          </xsl:if>
        </div>
      </xsl:when>

      <xsl:when test="preceding-sibling::*[1]/@float = 'true'">
        <div class="objectContainer">
          <xsl:apply-templates select="preceding-sibling::*[1]" mode="objectElement" />
          <xsl:apply-templates select="@*|*[not(self::lenya:asset-dot)]|text()" />
          <xsl:if test="lenya:asset-dot">
            <br class="floatclear" />
            <hr/>
            <xsl:apply-templates select="lenya:asset-dot" />
            <br/>
            <br/>
          </xsl:if>
        </div>
      </xsl:when>

      <xsl:otherwise>
        <div class="objectContainer">
          <xsl:copy>
            <xsl:apply-templates select="@*|*[not(self::lenya:asset-dot)]|text()" />
          </xsl:copy>
          <xsl:if test="lenya:asset-dot">
            <br class="floatclear" />
            <hr/>
            <xsl:apply-templates select="lenya:asset-dot" />
            <br/>
            <br/>
          </xsl:if>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="xhtml:p[parent::unizh:lead and $rendertype = 'imageupload']">
    <xsl:copy>
      <xsl:apply-templates select="*[not(self::lenya:asset-dot)]|text()" />
      <br/>
      <xsl:apply-templates select="lenya:asset-dot" />
    </xsl:copy>
  </xsl:template>


  <xsl:template match="lenya:asset[$rendertype = 'imageupload']">
    <a class="download" href="{lenya:asset-dot/@href}">
      <xsl:value-of select="text()" />
    </a>
    <br/>
  </xsl:template>


  <xsl:template match="lenya:asset[(parent::xhtml:body or parent::unizh:description) and $rendertype = 'imageupload']">
    <!-- unizh:description -> 'person' doctype -->
    <a class="download" href="{lenya:asset-dot[1]/@href}">
      <xsl:value-of select="text()" />
    </a>
    <br/>
    <xsl:if test="lenya:asset-dot[2]">
      <hr/>
      <xsl:apply-templates select="lenya:asset-dot[2]" />
      <br/>
      <br/>
    </xsl:if>
  </xsl:template>


  <xsl:template match="xhtml:a[ normalize-space( @href ) != '' and text() ]">
    <a href="{@href}" __bxe_id="{@__bxe_id}">
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="(starts-with(@href, 'http://') or starts-with(@href, 'https://')) and not(contains(@href, '.unizh.ch')) and not(contains(@href, '.uzh.ch'))">
            <xsl:text>www</xsl:text>
          </xsl:when>
          <xsl:when test="(starts-with(@href, 'http://') or starts-with(@href, 'https://')) and ((contains(@href, '.unizh.ch')) or (contains(@href, '.uzh.ch')))">
            <xsl:text>uzh</xsl:text>
          </xsl:when>
          <xsl:when test="starts-with(@href, 'itpc://')">
            <xsl:text>podcast</xsl:text>
          </xsl:when>
          <xsl:when test="/document/unizh:ancestors/unizh:ancestor[1]/@href = @href">
            <xsl:text>back</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>internal</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates select="@*|node()" />
    </a>
  </xsl:template>


  <xsl:template match="xhtml:a[ normalize-space( @href ) != '' and text() and ancestor::unizh:teaser and not( parent::unizh:teaser ) ]">
    <a href="{@href}" __bxe_id="{@__bxe_id}">
      <xsl:apply-templates select="@*|node()" />
    </a>
  </xsl:template>


  <xsl:template match="xhtml:a[ normalize-space( @href ) = '' and @name != '' ]">
    <a name="{@name}" class="namedanchor" />
    <xsl:apply-templates />
  </xsl:template>


  <xsl:template match="xhtml:a[ starts-with( @href, 'mailto:' ) ]">
    <script language="javascript">
      <xsl:comment>
           var mailtouser = "<xsl:value-of select="substring-before(@href , '@')" />"; 
           var hostname = "<xsl:value-of select="substring-after(@href, '@')" />"; 
           var linktext = "<xsl:value-of select="." />";
           <![CDATA[ 
             document.write("<a href=" + mailtouser + "@" + hostname + " class='mailto'>" + linktext + "</a>");
           ]]>
      </xsl:comment>
    </script>
  </xsl:template>


  <xsl:template match="xhtml:a">
    <xsl:apply-templates />
  </xsl:template>


  <xsl:template match="unizh:attention">
    <span class="attention">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <xsl:template match="unizh:related-content">
    <xsl:apply-templates/><xsl:comment/>
  </xsl:template>


  <xsl:template match="unizh:teaser[ancestor::unizh:homepage4cols]">
    <div class="teaser">
      <h3>
        <xsl:choose>
          <xsl:when test="xhtml:a">
            <xsl:attribute name="class">
              <xsl:text>linked</xsl:text>
              <xsl:choose>
                <xsl:when test="contains( xhtml:a/@href, 'news' )">
                  <xsl:text> lime</xsl:text>
                </xsl:when>
                <xsl:when test="contains( xhtml:a/@href, 'ueber' )">
                  <xsl:text> cyan</xsl:text>
                </xsl:when>
                <xsl:when test="contains( xhtml:a/@href, 'agenda' )">
                  <xsl:text> amethyst</xsl:text>
                </xsl:when>
                <xsl:when test="contains( xhtml:a/@href, 'veranstaltungen' )">
                  <xsl:text> magenta</xsl:text>
                </xsl:when>
                <xsl:when test="contains( xhtml:a/@href, 'fakultaeten' )">
                  <xsl:text> emerald</xsl:text>
                </xsl:when>
                <xsl:when test="contains( xhtml:a/@href, 'ausstellungen' )">
                  <xsl:text> pumpkin</xsl:text>
                </xsl:when>
                <xsl:when test="contains( xhtml:a/@href, 'blog' )">
                  <xsl:text> marine</xsl:text>
                </xsl:when>
              </xsl:choose>
            </xsl:attribute>
            <a href="{xhtml:a/@href}">
              <xsl:value-of select="unizh:title" />
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="unizh:title" />
          </xsl:otherwise>
        </xsl:choose>
      </h3>
      <xsl:choose>
        <xsl:when test="xhtml:object">
          <xsl:apply-templates select="xhtml:object" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="unizh:title/lenya:asset-dot" />
          <xsl:apply-templates select="xhtml:p" />
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>


  <xsl:template match="unizh:teaser">
    <div class="teaser">
      <h3><xsl:value-of select="unizh:title" /><xsl:comment/></h3>
      <xsl:if test="xhtml:object">
        <xsl:apply-templates select="xhtml:object" />
      </xsl:if>
      <xsl:apply-templates select="unizh:title/lenya:asset-dot" />
      <xsl:apply-templates select="xhtml:p" />
      <xsl:apply-templates select="lenya:asset" />
      <xsl:apply-templates select="xhtml:a" />
      <xsl:apply-templates select="lenya:asset-dot" />
    </div>
  </xsl:template>


  <xsl:template match="unizh:links">
    <div class="links">
      <h3>
        <xsl:choose>
          <xsl:when test="unizh:title/@href">
            <xsl:attribute name="class">
              <xsl:text>linked</xsl:text>
              <xsl:if test="unizh:title/@class">
                <xsl:text> </xsl:text>
                <xsl:value-of select="unizh:title/@class" />
              </xsl:if>
            </xsl:attribute>
            <a href="{unizh:title/@href}">
              <xsl:value-of select="unizh:title" />
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="unizh:title/@class" />
            <xsl:value-of select="unizh:title" />
          </xsl:otherwise>
        </xsl:choose>
      </h3>

      <!-- show image upload icon when in insert image mode -->
      <xsl:apply-templates select="unizh:title/*" />

      <xsl:if test="xhtml:object">
        <xsl:apply-templates select="xhtml:object" />
      </xsl:if>
      <xsl:apply-templates select="xhtml:p" />
      <ul>
        <xsl:for-each select="xhtml:a">
          <li>
            <xsl:apply-templates select="." />
          </li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>

  
  <xsl:template match="xhtml:body//xhtml:h2 | unizh:description//xhtml:h2">
    <!-- unizh:description -> 'person' doctype -->
    <h2 __bxe_id="{@__bxe_id}">
      <xsl:if test="@class">
        <xsl:copy-of select="@class" />
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
    <xsl:param name="input" />
    <xsl:param name="substr" />
    <xsl:variable name="temp" select="substring-after($input, $substr)" />
    <xsl:choose>
      <xsl:when test="$substr and contains($temp, $substr)">
        <xsl:call-template name="substring-after-last">
          <xsl:with-param name="input" select="$temp" />
          <xsl:with-param name="substr" select="$substr" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$temp" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="lenya:asset">
    <xsl:variable name="extent">
      <xsl:value-of select="dc:metadata/dc:extent" />
    </xsl:variable>
    <xsl:variable name="suffix">
      <xsl:call-template name="substring-after-last">
        <xsl:with-param name="input" select="@src" />
        <xsl:with-param name="substr">.</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <div class="asset">
      <xsl:text> </xsl:text>
      <a class="download" href="{$nodeid}/{@src}">
        <xsl:value-of select="text()" /><xsl:comment/>
      </a>
      (<xsl:value-of select="format-number($extent div 1024, '#.#')" />KB, <img src="{$imageprefix}/icons/{$suffix}.gif" alt="{text()}" title="{text()}" />)
    </div>
    <xsl:if test="(parent::xhtml:body or parent::unizh:description) and not(following-sibling::*[1][name() = 'lenya:asset'])">
      <!-- unizh:description -> 'person' doctype -->
      <br/>
    </xsl:if>
  </xsl:template>


  <xsl:template match="unizh:toc">
    <p>
      <xsl:for-each select="../*">
        <xsl:if test="self::xhtml:h2">
          <a class="internal" href="#{position()}">
            <xsl:apply-templates select="self::xhtml:h2/unizh:attention | self::xhtml:h2/*[name() != 'unizh:attention']/text() | self::xhtml:h2/text()" />
          </a>
          <br/>
        </xsl:if>
      </xsl:for-each>
    </p>
  </xsl:template>


  <xsl:template match="unizh:toplink">
    <div class="topnav"><a href="#top">top</a></div>  
  </xsl:template>


  <xsl:template match="unizh:level" />


  <xsl:template match="unizh:level[ancestor::unizh:newsitem]">
    <div class="level">
      <h3>Weitere Meldungen</h3>
      <ul>
        <xsl:apply-templates select="level:node"/>
      </ul>
    </div>
  </xsl:template>


  <xsl:template match="level:node">
    <xsl:variable name="fulltext" select="normalize-space(*/*/xhtml:body/xhtml:p)"/>
    <xsl:choose>
      <xsl:when test="not(($fulltext = '') or ($fulltext = '&#160;'))">
        <li>
          <a class="block" href="{$contextprefix}{@href}"><xsl:value-of select="descendant::dc:title"/></a>
        </li>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="xhtml:h2[ancestor::index:child]" mode="anchor" /> 


  <xsl:template match="unizh:children[ancestor::unizh:news]">
    <xsl:choose>
      <xsl:when test="index:child">
        <xsl:for-each select="index:child">
          <xsl:variable name="creationdate" select="*/*/lenya:meta/dcterms:created" />
          <div class="datetime">
            <xsl:choose>
              <xsl:when test="string-length($creationdate) &lt; '25'">
                <i18n:date pattern="EEE, d. MMM yyyy HH:mm" src-locale="en" src-pattern="d. MMM yyyy HH:mm" value="{$creationdate}" />
              </xsl:when>
              <xsl:otherwise>
                <i18n:date pattern="EEE, d. MMM yyyy HH:mm" src-locale="en" src-pattern="EEE MMM d HH:mm:ss zzz yyyy" value="{$creationdate}" />
              </xsl:otherwise>
            </xsl:choose>
          </div>
          <h2>
            <xsl:value-of select="*/*/lenya:meta/dc:title" />
          </h2>
          <xsl:apply-templates select="*/*/unizh:short/xhtml:p" />
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        - Noch kein Eintrag erfasst - <br/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="xhtml:p[parent::unizh:short]">
    <xsl:choose>

      <xsl:when test="xhtml:object[@float = 'true']">
        <xsl:choose>
          <xsl:when test="ancestor::unizh:children">
            <div class="objectContainer separated">
              <xsl:apply-templates select="xhtml:object" mode="objectElement">
                <xsl:with-param name="src">
                  <xsl:choose>
                    <xsl:when test="starts-with(xhtml:object/@data, 'http')">
                      <xsl:value-of select="xhtml:object/@data" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="concat($contextprefix, substring-before(../../../../@href, '.html'), '/', xhtml:object/@data)" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:with-param>
              </xsl:apply-templates>
              <xsl:apply-templates select="text()" />
              <xsl:text> </xsl:text>
              <xsl:call-template name="moreLink" />
            </div>
          </xsl:when>
          <xsl:when test="ancestor::unizh:newsitem">
            <div class="objectContainer editview" id="short">
              <xsl:apply-templates select="xhtml:object" mode="objectElement" />
              <xsl:apply-templates select="text()" />
              <br class="floatclear" />
            </div>
          </xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="preceding-sibling::*[1]/@float = 'true'">
        <xsl:choose>
          <xsl:when test="ancestor::unizh:children">
            <div class="objectContainer separated">
              <xsl:apply-templates select="preceding-sibling::*[1]" mode="objectElement">
                <xsl:with-param name="src">
                  <xsl:choose>
                    <xsl:when test="starts-with(../*/@data, 'http')">
                      <xsl:value-of select="../*/@data" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="concat($contextprefix, substring-before(../../../../@href, '.html'), '/', ../*/@data)" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:with-param>
              </xsl:apply-templates>
              <xsl:apply-templates/>
              <xsl:text> </xsl:text>
              <xsl:call-template name="moreLink" />
            </div>
          </xsl:when>
          <xsl:when test="ancestor::unizh:newsitem">
            <div class="objectContainer editview" id="short">
              <xsl:apply-templates select="preceding-sibling::*[1]" mode="objectElement" />
              <xsl:apply-templates/>
              <br class="floatclear" />
            </div>
          </xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="ancestor::unizh:children">
            <xsl:copy>
              <xsl:attribute name="class">separated</xsl:attribute>
              <xsl:apply-templates/>
              <xsl:text> </xsl:text>
              <xsl:call-template name="moreLink" />
            </xsl:copy>
          </xsl:when>
          <xsl:when test="ancestor::unizh:newsitem">
            <div class="editview" id="short">
              <xsl:apply-templates/>
            </div>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>


  <xsl:template name="moreLink">
    <xsl:variable name="fulltext" select="normalize-space(../../xhtml:body/xhtml:p)" />
    <xsl:if test="$area = 'authoring'">
      <a class="internal right_aligned" href="{$contextprefix}{../../../../@href}"><i18n:text>edit_item</i18n:text></a>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="../xhtml:a">
        <a href="{../xhtml:a/@href}">
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="(starts-with(../xhtml:a/@href, 'http://') or starts-with(../xhtml:a/@href, 'https://')) and not(contains(../xhtml:a/@href, '.unizh.ch')) and not(contains(../xhtml:a/@href, '.uzh.ch'))">
                <xsl:text>www</xsl:text>
              </xsl:when>
              <xsl:when test="(starts-with(../xhtml:a/@href, 'http://') or starts-with(../xhtml:a/@href, 'https://')) and ((contains(../xhtml:a/@href, '.unizh.ch') ) or (contains(../xhtml:a/@href, '.uzh.ch')))">
                <xsl:text>uzh</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>internal</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <i18n:text>more</i18n:text>
        </a>
      </xsl:when>
      <xsl:when test="not(($fulltext = '') or ($fulltext = '&#160;'))">
        <a class="internal" href="{$contextprefix}{../../../../@href}"><i18n:text>more</i18n:text></a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$area = 'authoring'">
          &#160;
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="xhtml:a[parent::unizh:short]">
    <a class="internal" href="{@href}"><i18n:text>more</i18n:text></a>
  </xsl:template>


  <xsl:template match="xhtml:p[(parent::xhtml:body or parent::unizh:description) and ($rendertype != 'imageupload')]">
    <!-- unizh:description -> 'person' doctype -->
    <xsl:choose>
      <!-- news intro -->
      <xsl:when test="ancestor::unizh:news and ( position() = 1 )">
        <xsl:copy>
          <xsl:attribute name="class">separated</xsl:attribute>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:when>

      <xsl:when test="xhtml:object[@float = 'true']">
        <div class="objectContainer">
          <xsl:apply-templates/>
          <br class="floatclear" />
        </div>
      </xsl:when>

      <xsl:when test="preceding-sibling::*[1]/@float = 'true'">
        <div class="objectContainer" __bxe_id="{@__bxe_id}">
          <xsl:apply-templates select="preceding-sibling::*[1]" mode="objectElement" />
          <xsl:apply-templates />
          <br class="floatclear" />
        </div>
      </xsl:when>

      <xsl:otherwise>
        <p __bxe_id="{@__bxe_id}">
          <xsl:apply-templates/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


   <xsl:template match="unizh:children[ancestor::unizh:team]">
    <xsl:choose>
      <xsl:when test="index:child">
        <xsl:for-each select="index:child">
          <div class="teamBlock">
            <div class="teamImg">
              <xsl:apply-templates select="*/unizh:person/xhtml:object" />
            </div>
            <div class="teamText">
              <p>
                <b>
                  <xsl:if test="*/unizh:person/unizh:academictitle != ''">
                    <xsl:value-of select="*/unizh:person/unizh:academictitle" />&#160;
                  </xsl:if>
                  <xsl:value-of select="*/unizh:person/unizh:firstname" />&#160;
                  <xsl:value-of select="*/unizh:person/unizh:lastname" />&#160;
                </b>
                <br/>
                <xsl:value-of select="*/unizh:person/unizh:position" /><br/>
                <xsl:if test="*/unizh:person/unizh:email !=''">
                  <xsl:text>Mail: </xsl:text>
                  <a>
                    <xsl:attribute name="href">
                      <xsl:text>mailto:</xsl:text>
                      <xsl:value-of select="*/unizh:person/unizh:email" />
                    </xsl:attribute>
                    <xsl:attribute name="class">internal</xsl:attribute>
                    <xsl:value-of select="*/unizh:person/unizh:email" />
                  </a>
                  <br />
                </xsl:if>
                <a class="internal" href="{$contextprefix}{@href}"><i18n:text>more</i18n:text></a>
              </p>
            </div>
            <div class="floatleftclear"><xsl:comment/></div>
          </div>
          <div class="solidline">
            <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1" />
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
    <xsl:apply-templates select="index:child" />
  </xsl:template>

<!--  
   <xsl:template match="index:child[descendant::unizh:newsitem]">
    <h3>
      <xsl:apply-templates select="descendant::lenya:meta/dc:title" />
    </h3>
    <br/>
    <xsl:apply-templates mode="collection" select="descendant::unizh:lead" />
    <a class="internal" href="{$contextprefix}{@href}"><i18n:text>more</i18n:text></a>
  </xsl:template>
-->

  <xsl:template match="unizh:lead[parent::xhtml:body]">
    <xsl:choose>
      <xsl:when test="xhtml:p/descendant-or-self::*[text()]">
        <div class="leadblock">
          <p __bxe_id="{xhtml:p/@__bxe_id}">
            <xsl:if test="xhtml:object">
              <xsl:apply-templates select="xhtml:object" />
            </xsl:if>
            <xsl:apply-templates select="xhtml:p/child::node()" />
          </p>
        </div>
      </xsl:when>
      <xsl:when test="xhtml:object">
        <div class="leadblock">
          <xsl:apply-templates select="xhtml:object" />
        </div>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="unizh:lead">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="index:child">
    <p>
      <xsl:apply-templates mode="index" select="descendant::lenya:meta/dc:title">
        <xsl:with-param name="href">
          <xsl:value-of select="@href" />
        </xsl:with-param>
      </xsl:apply-templates>
      <xsl:if test="../@abstracts = 'true'">
        <br/>
        <xsl:apply-templates mode="index" select="descendant::lenya:meta/dc:description" />
      </xsl:if>
    </p>
  </xsl:template>


  <xsl:template match="dc:title" mode="index">
    <xsl:param name="href" />
    <a class="internal" href="{$contextprefix}{$href}">
      <xsl:value-of select="." />
    </a>
  </xsl:template>

  <xsl:template match="dc:description" mode="index">
    <xsl:value-of select="." />
  </xsl:template>

  <xsl:template match="dc:description" mode="collection">
    <xsl:value-of select="." />
  </xsl:template>


  <xsl:template match="xhtml:table[@class = 'basic']">
    <xsl:copy>
      <xsl:attribute name="class">basic</xsl:attribute>
      <xsl:attribute name="cellspacing">0</xsl:attribute>
      <xsl:attribute name="cellpadding">0</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="xhtml:table[@class = 'ornate']">
    <xsl:copy>
      <xsl:attribute name="class">ornate</xsl:attribute>
      <xsl:attribute name="cellspacing">0</xsl:attribute>
      <xsl:attribute name="cellpadding">0</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="xhtml:table[@class = 'grid']">
    <xsl:copy>
      <xsl:attribute name="class">grid</xsl:attribute>
      <xsl:attribute name="cellspacing">0</xsl:attribute>
      <xsl:attribute name="cellpadding">0</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="xhtml:table[@class = 'striped']">
    <xsl:copy>
      <xsl:attribute name="class">striped</xsl:attribute>
      <xsl:attribute name="cellspacing">0</xsl:attribute>
      <xsl:attribute name="cellpadding">0</xsl:attribute>
      <xsl:for-each select="xhtml:tr">
        <xsl:copy>
          <xsl:if test="( position() div 2 ) != round( position() div 2 )">
            <xsl:attribute name="class">odd</xsl:attribute>
          </xsl:if>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="xhtml:textarea">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />&#160;
    </xsl:copy>
  </xsl:template>


  <!-- create div to represent google map -->
  <xsl:template match="unizh:map">
    <div class="map">
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()" />
      </xsl:attribute>
      <xsl:attribute name="style">
        <xsl:choose>
          <xsl:when test="ancestor::unizh:related-content">
            <xsl:text>width: 188px; height: 188px</xsl:text>
          </xsl:when>
          <xsl:when test="/document/content/*/@unizh:columns = 1">
            <xsl:text>width: 800px; height: 500px</xsl:text>
          </xsl:when>
          <xsl:when test="/document/content/*/@unizh:columns = 2">
            <xsl:text>width: 596px; height: 400px</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>width: 392px; height: 300px</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text></xsl:text>
      </xsl:attribute>
      <noscript>JavaScript must be enabled in order for you to use Google Maps.</noscript>
    </div>
  </xsl:template>


  <!-- create javascript array for google map API from unizh:map element (called from html-head.xsl) -->
  <xsl:template name="mapData">
    <xsl:text>{</xsl:text>
    <xsl:text>"id":"</xsl:text><xsl:value-of select="generate-id()" /><xsl:text>",</xsl:text>
    <xsl:text>"center":{"lat":</xsl:text><xsl:value-of select="@lat" /><xsl:text>,"lng":</xsl:text><xsl:value-of select="@lng" /><xsl:text>},</xsl:text>
    <xsl:text>"scale":</xsl:text><xsl:value-of select="@scale" /><xsl:text>,</xsl:text>
    <xsl:text>"type":</xsl:text>
    <xsl:choose>
      <xsl:when test="@type">
        <xsl:choose>
          <xsl:when test="@type = 'hybrid'">
            <xsl:text>G_HYBRID_MAP</xsl:text>
          </xsl:when>
          <xsl:when test="@type = 'satellite'">
            <xsl:text>G_SATELLITE_MAP</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>G_NORMAL_MAP</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>G_NORMAL_MAP</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>,</xsl:text>
    <xsl:choose>
      <xsl:when test="ancestor::unizh:related-content">
        <xsl:text>"control":"small",</xsl:text>
        <xsl:text>"typeControl":false,</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>"control":"large",</xsl:text>
        <xsl:text>"typeControl":true,</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>"markers":[</xsl:text>
    <xsl:for-each select="unizh:marker">
      <xsl:call-template name="markerData" />
      <xsl:if test="not(position()=last())">
        <xsl:text>,</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>]</xsl:text>
    <xsl:text>}</xsl:text>
  </xsl:template>


  <xsl:template name="markerData">
    <xsl:variable name="iconImage">
      <xsl:choose>
        <xsl:when test="../@numbered and ../@numbered='true' and (position() &lt; 11)">
          <xsl:text>marker</xsl:text><xsl:value-of select="position()" /><xsl:text>.png</xsl:text>
        </xsl:when>
        <xsl:otherwise>marker.png</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:text>{</xsl:text>
    <xsl:text>"lat":</xsl:text><xsl:value-of select="@lat" /><xsl:text>,</xsl:text>
    <xsl:text>"lng":</xsl:text><xsl:value-of select="@lng" /><xsl:text>,</xsl:text>
    <xsl:text>"label":"</xsl:text><xsl:apply-templates select="node()" /><xsl:text>",</xsl:text>
    <xsl:text>"icon":{</xsl:text>
    <xsl:text>"image":"</xsl:text><xsl:value-of select="$imageprefix" /><xsl:text>/</xsl:text><xsl:value-of select="$iconImage" /><xsl:text>",</xsl:text>
    <xsl:text>"shadow":"</xsl:text><xsl:value-of select="$imageprefix" /><xsl:text>/shadow50.png",</xsl:text>
    <xsl:text>"imageSize":{"width":20,"height":34},</xsl:text>
    <xsl:text>"shadowSize":{"width":37,"height":34},</xsl:text>
    <xsl:text>"iconAnchor":{"x":9,"y":34},</xsl:text>
    <xsl:text>"infoWindowAnchor":{"x":9,"y":2},</xsl:text>
    <xsl:text>"infoShadowAnchor":{"x":18,"y":25}</xsl:text>
    <xsl:text>}</xsl:text>
    <xsl:text>}</xsl:text>
  </xsl:template>


  <xsl:template match="unizh:partner">
    <div class="partner">
      <h3><xsl:value-of select="unizh:title" /><xsl:comment/></h3>
      <xsl:apply-templates select="xhtml:object" />
      <xsl:apply-templates select="lenya:asset-dot" />
    </div>
  </xsl:template>


  <xsl:template match="unizh:partner[ancestor::unizh:homepage4cols]">
    <div class="partner">
      <xsl:if test="unizh:title">
        <h3><xsl:value-of select="unizh:title/text()" /></h3>
      </xsl:if>
      <xsl:for-each select="xhtml:object">
        <xsl:call-template name="objectImage">
          <xsl:with-param name="width" select="dc:metadata/lenya:meta/lenya:width" />
          <xsl:with-param name="height" select="dc:metadata/lenya:meta/lenya:height" />
          <xsl:with-param name="src">
            <xsl:choose>
              <xsl:when test="starts-with(@data, 'http')">
                <xsl:value-of select="@data" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat($nodeid, '/', @data)" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="href" select="@href" />
          <xsl:with-param name="alt" select="dc:metadata/dc:title" />
        </xsl:call-template>
      </xsl:for-each>
    </div>
  </xsl:template>


  <xsl:template match="unizh:calendar">
    <table class="calendar" cellpadding="0" cellspacing="0">
      <tr>
        <th colspan="2"><xsl:value-of select="unizh:title/text()" /></th>
      </tr>
      <xsl:for-each select="unizh:row">
        <tr>
          <xsl:if test="( position() div 2 ) != round( position() div 2 )">
            <xsl:attribute name="class">odd</xsl:attribute>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="( @label ) and ( node() )">
              <td>
                <xsl:value-of select="@label" />
              </td>
              <td class="data" __bxe_id="{@__bxe_id}">
                <xsl:apply-templates />
              </td>
            </xsl:when>
            <xsl:when test=" @label ">
              <td colspan="2">
                <xsl:value-of select="@label" />
              </td>
            </xsl:when>
            <xsl:when test=" node() ">
              <td colspan="2" class="remarks" __bxe_id="{@__bxe_id}">
                <xsl:apply-templates />
              </td>
            </xsl:when>
          </xsl:choose>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>


  <!-- BXE 2 needs this template -->
  <xsl:template match="text()">
    <xsl:value-of select="."/>
  </xsl:template>


  <!-- BXE 2 needs this template -->
  <xsl:template match="@*">
    <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
  </xsl:template>

</xsl:stylesheet>
