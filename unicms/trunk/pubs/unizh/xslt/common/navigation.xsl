<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: header.xsl,v 1.40 2005/03/09 11:11:13 peter Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml" 
>
                

  <xsl:template match="xhtml:div[@id = 'orthonav']">
    <xsl:if test="*">
      <div id="orthonav">
       <span class="spacer"> </span>
        <xsl:variable name="itemNr" select="count(*)"/>
        <xsl:for-each select="*">
          <xsl:choose>
            <xsl:when test="@href">
              <a href="{@href}"> <xsl:value-of select="."/> </a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="@current = 'true'">
                  <a href="#" class="active"><xsl:value-of select="."/></a>
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
      <xsl:for-each select="xhtml:div[@id != 'search']">
        <xsl:if test="@id = 'home'">
           <a href="{@href}" accesskey="0"><xsl:value-of select="."/></a> 	
        </xsl:if>
        <xsl:if test="@id = 'contact'">
         <a href="{@href}" accesskey="3"><xsl:value-of select="."/></a> 	
        </xsl:if>
        <xsl:if test="@id = 'sitemap'">
          <a href="{@href}" accesskey="4"><xsl:value-of select="."/></a> 	
        </xsl:if>
       |
      </xsl:for-each>
      <label for="formsearch"><xsl:value-of select="xhtml:div[@id='search']"/>:</label>
      <form id="formsearch" action="{xhtml:div[@id = 'search']/@href}" method="get">
        <div class="serviceform">
          <input type="text" titel="suchen" name="queryString" accesskey="5" />
        </div>
        <div class="serviceform">
          <a href="javascript:document.forms['formsearch'].submit();">go!</a>
        </div>
      </form>
    </div>
  </xsl:template>

  <xsl:template match="xhtml:div[@id = 'toolnav']">
    <div id="toolnav">
      <div class="icontextpos">
        <div id="icontext">&#160;</div>
      </div>
      <xsl:for-each select="xhtml:div[@class='language']">
        <a href="{@href}"><xsl:value-of select="translate(., 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/></a> |
      </xsl:for-each>
      <a href="#" onClick="window.open('{xhtml:div[@id = 'print']/@href}', '', 'width=700,height=700,menubar=yes,scrollbars')" onmouseout="changeIcontext('')" onmouseover="changeIcontext('{xhtml:div[@id = 'print']}')"><img src="{$imageprefix}/icon_print.gif" alt="{xhtml:div[@id = 'print']}" width="10" height="10" border="0" /></a> |
      <a onmouseout="changeIcontext('')" onmouseover="changeIcontext('{xhtml:div[@id = 'fontsize']}')">
        <xsl:attribute name="id">switchFontSize</xsl:attribute>
        <img src="{$imageprefix}/icon_bigfont.gif" alt="{xhtml:div[@id = 'fontsize']}" border="0" width="18" height="9"/></a> |
      <a href="{xhtml:div[@id = 'simpleview']/@href}" onmouseout="changeIcontext('')" onmouseover="changeIcontext('{xhtml:div[@id = 'simpleview']}')"><img src="{$imageprefix}/icon_pda.gif" alt="{xhtml:div[@id = 'simpleview']}" width="18" height="9" border="0" /></a>
    </div>
    <div class="floatclear"><xsl:comment/></div>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'menu']">
    <xsl:variable name="descendants" select="descendant::xhtml:div[descendant-or-self::xhtml:div[@current = 'true']]"/>
    <xsl:variable name="current" select="descendant::xhtml:div[@current = 'true']"/>
    <xsl:variable name="level" select="count($descendants)"/>

    <div id="secnav">
	  <xsl:if test="not(../xhtml:div[@id = 'tabs'])">
	    <a accesskey="1" name="navigation"><xsl:comment/></a>
	  </xsl:if>
      <xsl:apply-templates select="xhtml:div[@class = 'home']"/>
      <xsl:choose>
        <xsl:when test="$level > 2 and $current/xhtml:div">
          <a href="{$descendants[$level - 2]/@href}">[...] <xsl:value-of select="$descendants[$level - 2]/text()"/></a>
        </xsl:when>
        <xsl:when test="$level > 3">
          <a href="{$descendants[$level - 3]/@href}">[...] <xsl:value-of select="$descendants[$level - 3]/text()"/></a>
         </xsl:when>
      </xsl:choose>
      <div class="solidline">
        <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1" border="0" />
      </div>
      <ul>
        <xsl:choose>
          <xsl:when test="$level > 2 and $current/xhtml:div"> 
            <xsl:apply-templates select="$descendants[$level - 1]"/>
          </xsl:when>
          <xsl:when test="$level > 3">
            <xsl:apply-templates select="$descendants[$level - 2]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="xhtml:div[not(@class = 'home')]"/>
          </xsl:otherwise>
        </xsl:choose>
      </ul>
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
      <xsl:if test="xhtml:div">
        <ul>
          <xsl:apply-templates select="xhtml:div"/>
        </ul>
      </xsl:if>
      <xsl:if test="parent::xhtml:div[@id = 'menu']">
        <div class="dotline">
          <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1" border="0" />
        </div>
      </xsl:if>
    </li>
  </xsl:template>


  <xsl:template match="xhtml:div[parent::xhtml:div[@id = 'menu'] and @class = 'home']">
    <div class="navup">
      <a href="{@href}"><xsl:value-of select="."/></a>
    </div>
  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'tabs']">
    <div id="primarnav">
      <a name="navigation"><xsl:comment/></a> 
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
	<a name="navigation"><xsl:comment/></a>
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


