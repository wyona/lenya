<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: dossiersoverview-standard.xsl,v 1.3 2004/12/22 10:00:13 edith Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:up="http://www.unipublic.unizh.ch/2002/up"
  exclude-result-prefixes="xhtml lenya dc"
  >
  
  <xsl:import href="variables.xsl"/>
  
  <xsl:param name="root"/> <!-- the URL up to (including) the area -->
  <xsl:param name="contextprefix"/>
  
  <xsl:param name="documentid"/>
  <xsl:param name="nodeid"/>
  
  <xsl:param name="language"/>
  <xsl:param name="defaultlanguage"/>
  <xsl:param name="languages"/>
  
  <xsl:param name="completearea"/>
  <xsl:param name="area"/>
  
  <xsl:param name="rendertype"/>
  
  <xsl:param name="lastmodified"/>
  

  <xsl:include href="../common/html-head.xsl"/>
  <xsl:include href="../common/header.xsl"/>
  <xsl:include href="../common/elements.xsl"/>
  <xsl:include href="../common/footer.xsl"/>

  <xsl:template match="document">
    <html>
      <xsl:call-template name="html-head"/>        
      <body text="black" link="#333399" alink="#CC0000" vlink="#666666" bgcolor="#F5F5F5" background="{$imageprefix}/bg.gif">
        <div align="center">
          <xsl:call-template name="topnavbar"/>
          <table cellspacing="0" cellpadding="0" border="0" width="585" >

            <tr>
              <td align="right" width="186"/>
              <td colspan="2" width="399">
                <xsl:apply-templates select="xhtml:div[@id='years-navigation']"/>
              </td>
            </tr>
            <tr>
              <td valign="top" align="right" width="186" >
                <img height="28" alt="" src="{$imageprefix}/dossiers/doss_rub_title.gif" width="112" border="0"/>
                <table width="100%" border="0" cellspacing="0" cellpadding="5" bgcolor="#CCCCCC">
                  <tr>
                    <td class="rel-text">Alle Artikel zu einem Thema finden Sie versammelt in unseren Dossiers.</td>
                  </tr>
                </table>
              </td>
              <td colspan="2" class="art-text" valign="top" style="background-color:white;" width="399">
                <xsl:apply-templates select="xhtml:div[@id='dossiers-overview']"/>
             </td>
            </tr>
            <xsl:call-template name="footer"/>
          </table>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="xhtml:div[@id='dossiers-overview']">
    <table width="399" border="0" cellspacing="0" cellpadding="0">
      <xsl:apply-templates select="xhtml:div[@class='tsr-title']" mode ="dossiers"/>
    </table>
  </xsl:template>

  <xsl:template match="xhtml:div[@class='tsr-title']" mode ="dossiers">
    <xsl:variable name="color"><xsl:value-of select="up:color"/></xsl:variable>
    <xsl:variable name="id"><xsl:value-of select="up:dossier-id"/></xsl:variable>
    
    <!-- Layout has two columns that are built by drawing <tr> or not  -->
    <xsl:if test="position() mod 2">
      <xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
    </xsl:if>
    <td valign="top" width="199">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" >
        <tr>
          <td valign="top" style="background-color:{$color}">
            <a>
              <xsl:attribute name="href"><xsl:value-of select="./xhtml:a/@href"/></xsl:attribute>
              <img border="0" width="80" height="60">
                <xsl:attribute name="src"><xsl:value-of select="$nodeid"/>/<xsl:value-of select="$id"/>/<xsl:value-of select="./up:teaser/xhtml:p/xhtml:object/@data"/>
                </xsl:attribute>
                <xsl:attribute name="alt"><xsl:value-of select="./up:teaser/xhtml:p/xhtml:object/@alt"/></xsl:attribute>
              </img>
            </a>
          </td>
        </tr>
        <tr>
          <td class="tsr-text" valign="top" width="199">
            <div class="tsr-title">
              <a>
                <xsl:attribute name="href"><xsl:value-of select="./xhtml:a/@href"/></xsl:attribute>
                <xsl:value-of select="lenya:meta/dc:title" />
              </a>
            </div>
            <br/>
            <xsl:choose>
              <xsl:when test="up:teaser/xhtml:div[@class='tsr-text']!=''">
                <xsl:value-of select="./up:teaser/xhtml:div[@class='tsr-text']"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="./lenya:meta/dc:description"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </table>
    </td>
    <td/>
    <xsl:if test="position() mod 2">
      <td width="1" bgcolor="white">
        <img src="{$imageprefix}/spacer.gif" alt="" height="10" width="1" border="0"/>
      </td>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="not(position() mod 2)">
        <xsl:text disable-output-escaping="yes">&lt;/tr&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="(position()=last())">
        <xsl:text disable-output-escaping="yes">&lt;/tr&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="xhtml:div[@class='years-navigation']">
    <xsl:apply-templates/> 
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
