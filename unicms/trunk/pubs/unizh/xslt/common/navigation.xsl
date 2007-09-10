<?xml version="1.0" encoding="UTF-8"?>


<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml" 
>
  <xsl:param name="publicationid"/>
  <xsl:param name="servername"/>

  <xsl:template match="xhtml:div[@id = 'orthonav']">
    <xsl:if test="*">
      <div id="orthonav">
       <span class="spacer"> </span>
        <xsl:variable name="itemNr" select="count(*)"/>
        <xsl:for-each select="*">
          <xsl:choose>
            <xsl:when test="@href">
              <a href="{@href}" class="active"> <xsl:value-of select="."/> </a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="@current = 'true'">
                  <a href="#" class="current"><xsl:value-of select="."/></a>
                </xsl:when>
                <xsl:otherwise>
                  <a class="inactive"> <xsl:value-of select="."/> </a>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="position() != $itemNr">&#160;&#160;</xsl:if>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'servicenav']">
    <div id="servicenavpos">
      <xsl:apply-templates />
    </div>
  </xsl:template>


  <xsl:template match="xhtml:div[parent::xhtml:div[@id = 'servicenav']]">
    <xsl:if test="(position() &gt; 1) and (@id != 'search')">
      <xsl:text> | </xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@id='search'">
        <xsl:choose>
          <xsl:when test="$publicationid = 'id'">      
            <label for="formsearch">Suchen:</label>  
            <form id="formsearch" action="http://www.id.uzh.ch/search/search.jsp" method="get" accept-charset="UTF-8">
               <div class="serviceform">
                  <input type="text" name="query" accesskey="5" />
               </div>
               <div class="serviceform">
                  <a href="javascript:document.forms['formsearch'].submit();">go!</a>
               </div>
            </form>
          </xsl:when>
          <xsl:otherwise>
<!--
   The following switch is necessary to prevent that the id for the form tag i.e. searchbox_0093470....
   occurs twice on the search page. See:  ../doctypes/search-standard.xsl. The form id is used by a 
   javascript provided by google.
-->
            <xsl:if test="$nodeid != 'search'">
              <form>
                <xsl:attribute name="id">searchbox_009347054195260226203:hahgnjx1tks</xsl:attribute>
                <xsl:attribute name="action">
                  <xsl:value-of select="@href"/>
                </xsl:attribute>
                <xsl:attribute name="method">get</xsl:attribute>
                <xsl:attribute name="accept-charset">UTF-8</xsl:attribute>
                <input type="hidden" name="cx" value="009347054195260226203:hahgnjx1tks" />
                <input type="hidden" name="cof" value="FORID:11" />
                <input type="hidden" id="custom" name="sitesearch" value="{$servername}"/>
                <div class="serviceform">
                  <input type="text" name="q" accesskey="5" />
                </div>
                <div class="serviceform">
                  <a href="javascript:document.forms['searchbox_009347054195260226203:hahgnjx1tks'].submit();"><xsl:value-of select="text()"/></a>
                </div>
              </form>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <a>
          <xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
          <xsl:attribute name="accesskey">
            <xsl:choose>
              <xsl:when test="@id = 'home'">0</xsl:when>
              <xsl:when test="@id = 'contact'">3</xsl:when>
              <xsl:when test="@id = 'sitemap'">4</xsl:when>
            </xsl:choose>
          </xsl:attribute>
          <xsl:value-of select="text()"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'toolnav']">
    <div id="toolnav">
      <div class="icontextpos">
        <div id="icontext">&#160;</div>
      </div>
      <xsl:choose>
        <xsl:when test="count(xhtml:div[@class='language']) &gt; 1">
          <xsl:for-each select="xhtml:div[@class='language']">
            <a href="{@href}"><xsl:value-of select="translate(., 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/></a>
            <xsl:text> | </xsl:text>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="count(xhtml:div[@class='language']) = 1">
          <a>
            <xsl:attribute name="href"><xsl:value-of select="xhtml:div[@class='language']/@href"/></xsl:attribute>
            <xsl:choose>
              <xsl:when test="xhtml:div[@class='language']/text() = 'de'">Deutsch</xsl:when>
              <xsl:when test="xhtml:div[@class='language']/text() = 'en'">English</xsl:when>
              <xsl:when test="xhtml:div[@class='language']/text() = 'fr'">Français</xsl:when>
              <xsl:when test="xhtml:div[@class='language']/text() = 'it'">Italiano</xsl:when>
              <xsl:otherwise><xsl:value-of select="translate(xhtml:div[@class='language']/text(), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/></xsl:otherwise>
            </xsl:choose>
          </a>
          <xsl:text> | </xsl:text>
        </xsl:when>
      </xsl:choose>
      <a href="#" onClick="window.open('{xhtml:div[@id = 'print']/@href}', '', 'width=700,height=700,menubar=yes,scrollbars')" onmouseout="changeIcontext('')" onmouseover="changeIcontext('{xhtml:div[@id = 'print']}')"><img src="{$imageprefix}/icon_print.gif" alt="{xhtml:div[@id = 'print']}" width="10" height="10" /></a> |
      <a onmouseout="changeIcontext('')" onmouseover="changeIcontext('{xhtml:div[@id = 'fontsize']}')">
        <xsl:attribute name="id">switchFontSize</xsl:attribute>
        <img src="{$imageprefix}/icon_bigfont.gif" alt="{xhtml:div[@id = 'fontsize']}" width="18" height="9"/></a> |
      <a href="{xhtml:div[@id = 'simpleview']/@href}" onmouseout="changeIcontext('')" onmouseover="changeIcontext('{xhtml:div[@id = 'simpleview']}')"><img src="{$imageprefix}/icon_pda.gif" alt="{xhtml:div[@id = 'simpleview']}" width="18" height="9" /></a>
    </div>
    <div class="floatclear"><xsl:comment/></div>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'menu']">
    <xsl:variable name="descendants" select="descendant::xhtml:div[descendant-or-self::xhtml:div[@current = 'true']]"/>
    <xsl:variable name="current" select="descendant::xhtml:div[@current = 'true']"/>
    <xsl:variable name="level" select="count($descendants)"/>

    <xsl:apply-templates select="xhtml:div[@class = 'home']"/>
    <div id="secnav">
      <xsl:if test="not(../xhtml:div[@id = 'tabs'])">
        <a name="navigation" class="namedanchor"><xsl:comment/></a>
      </xsl:if>
      <xsl:if test="$level > 3">
        <a href="{$descendants[$level - 3]/@href}">[...] <xsl:value-of select="$descendants[$level - 3]/text()"/></a>
      </xsl:if>
      <xsl:if test="(descendant::xhtml:div[@current = 'true']) or ($hideChildren != 'true')">
        <ul>
          <xsl:choose>
            <xsl:when test="$level > 3">
              <xsl:apply-templates select="$descendants[$level - 2]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="xhtml:div[not(@class = 'home')]"/>
            </xsl:otherwise>
          </xsl:choose>
        </ul>
      </xsl:if>
      <xsl:comment/>
    </div>
  </xsl:template>


  <xsl:template match="xhtml:div[ancestor::xhtml:div[@id = 'menu']]">
    <li>
      <a href="{@href}">
        <xsl:if test="@current = 'true'">
          <xsl:attribute name="class">activ</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="text()"/>
      </a>
      <xsl:if test="xhtml:div and not((@current = 'true') and ($hideChildren = 'true'))">
        <ul>
          <xsl:apply-templates select="xhtml:div"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>


  <xsl:template match="xhtml:div[parent::xhtml:div[@id = 'menu'] and @class = 'home']">
    <div class="navup">
      <a href="{@href}"><xsl:value-of select="."/><xsl:comment/></a>
    </div>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'tabs']">
    <div id="primarnav">
      <a name="navigation" class="namedanchor"><xsl:comment/></a> 
      <xsl:for-each select="xhtml:div">
        <a href="{@href}">
          <xsl:if test="@current = 'true'">
            <xsl:attribute name="class">activ</xsl:attribute>
          </xsl:if>
          <xsl:value-of select="text()"/>
        </a>
        <xsl:if test="position() &lt; last()">
          <div class="linkseparator">|</div>
        </xsl:if>
      </xsl:for-each>
      &#160;
    </div>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'breadcrumb']">
    <div id="breadcrumbnav">
      <a href="{@root}"><xsl:value-of select="@label"/></a>
      <xsl:for-each select="xhtml:div">
         &gt; <a href="{@href}"><xsl:value-of select="."/></a>
      </xsl:for-each>
    </div>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'simplenav']">
    <div id="primarnav">
      <a name="navigation" class="namedanchor"><xsl:comment/></a>
      <xsl:for-each select="xhtml:div">
        <a href="{@href}"><xsl:value-of select="@label"/></a>
        <xsl:if test="@id = 'up'"><br/></xsl:if>
        <xsl:if test="not(@id = 'up') and position() &lt; last()">
          <div class="linkseparator">|</div>
        </xsl:if>
      </xsl:for-each>
    </div>
  </xsl:template>


</xsl:stylesheet>


