<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: dossier-standard.xsl,v 1.9 2004/12/22 10:01:15 edith Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"  
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:up="http://www.unipublic.unizh.ch/2002/up"
  xmlns:col="http://apache.org/cocoon/lenya/collection/1.0"
  exclude-result-prefixes="xhtml lenya dc up"
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

  <xsl:param name="parent-url"/>

  <xsl:include href="../common/html-head.xsl"/>
  <xsl:include href="../common/header.xsl"/>
  <xsl:include href="../common/elements.xsl"/>
  <xsl:include href="../common/footer.xsl"/>

  <xsl:variable name="content" select="/up:dossier"/>
  
  <xsl:template match="up:dossier">
    <html>
      <xsl:call-template name="html-head"/>
      <body text="black" link="#333399" alink="#CC0000" vlink="#666666" bgcolor="#F5F5F5" background="{$imageprefix}/bg.gif">
        <div align="center">

          <xsl:call-template name="topnavbar"/>
          <table cellspacing="0" cellpadding="0" border="0" width="585">
            <tr>
              <td valign="top" align="right" width="187" rowspan="2">
                <a href="{$root}/{$parent-url}{$documentlanguagesuffix}.html"><img height="28" alt="" src="{$imageprefix}/dossiers/doss_rub_title.gif" width="112" border="0"
/></a>
                <div bxe_xpath="/up:dossier/up:related-contents">
                  <xsl:apply-templates select="up:related-contents"/>
                </div>
              </td>
              <xsl:call-template name="dossier-head"/>
            </tr>
            <tr>
              <td valign="top" width="10" bgcolor="white">&#160;</td>
              <td valign="top" width="388" bgcolor="white" class="tsr-text">
                <br/>
                <div bxe_xpath="/up:dossier/lenya:meta/dc:description">
                  <xsl:apply-templates select="lenya:meta/dc:description" />
                </div>
         
                <xsl:for-each select="col:document">
                  <xsl:choose>
                    <xsl:when test="lenya:meta/dcterms:issued!=''">
                    </xsl:when>
                    <xsl:otherwise>
                      <!--copy first the articles which weren't already published-->
                      <xsl:apply-templates select="." mode="dossier"/>
                   </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
                <xsl:for-each select="col:document">
                  <!-- sort by the publish date the articles which were already published--> 
                  <xsl:sort select="substring(lenya:meta/dcterms:issued,1,4)" data-type="number" order="descending"/> <!-- year  -->
                  <xsl:sort select="substring(lenya:meta/dcterms:issued,6,2)" data-type="number" order="descending"/> <!-- month -->
                  <xsl:sort select="substring(lenya:meta/dcterms:issued,9,2)" data-type="number" order="descending"/> <!-- day   -->
                  <xsl:sort select="substring(lenya:meta/dcterms:issued,12,2)" data-type="number" order="descending"/> <!-- hour  -->
                  <xsl:sort select="substring(lenya:meta/dcterms:issued,15,2)" data-type="number" order="descending"/> <!-- min -->
                  <xsl:sort select="substring(lenya:meta/dcterms:issued,17,2)" data-type="number" order="descending"/> <!-- s   -->
                  <xsl:if test="lenya:meta/dcterms:issued!=''">
                    <xsl:apply-templates select="." mode="dossier"/>
                  </xsl:if>
               </xsl:for-each>
         
                <xsl:if test="$area = 'authoring'">
                  <table cellpadding="1" border="0" width="100%" bgcolor="#cccccc">
                    <tr><td>
                      <table cellpadding="3" border="0" width="100%" bgcolor="white">
                        <tr>
                          <td class="tsr-text"><b>Dossier-Farbe (Hex-Code)</b></td>
                          <td class="tsr-text">
                            <div bxe_xpath="/up:dossier/up:color">
                              <xsl:value-of select="up:color" />
                            </div> 
                          </td>
                        </tr>
                        <tr>
                          <td class="tsr-text"><b>Teaser-Text</b></td>
                          <td class="tsr-text">
                          <div bxe_xpath="/up:dossier/up:teaser/xhtml:div[@class='tsr-text']">
                            <xsl:value-of select="up:teaser/xhtml:div[@class='tsr-text']"/>
                          </div>  
                          </td>
                        </tr>
                      </table>
                    </td></tr>
                  </table>
                </xsl:if>

              </td>
            </tr>
            <xsl:call-template name="footer"/>
          </table>
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="col:document" mode="dossier">
    <p>
      <a href="{$root}{@id}{$documentlanguagesuffix}.html"> 
        <img border="0" src="{$root}{@id}/{up:teaser/xhtml:p/xhtml:object/@data}" height="60" width="80" align="right" >
          <xsl:attribute name="alt"><xsl:value-of select="./@alt"/></xsl:attribute>
        </img>
      </a>
      <a href="{$root}{@id}{$documentlanguagesuffix}.html"><xsl:apply-templates select="lenya:meta/dc:title" mode="tsr-title"/></a>
      <xsl:choose>
        <xsl:when test="up:teaser/xhtml:div[@class='tsr-text']!=''">
          <xsl:value-of select="up:teaser/xhtml:div[@class='tsr-text']"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="lenya:meta/dc:description"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="lenya:meta/dcterms:issued!=''">
          (<xsl:apply-templates select="lenya:meta/dcterms:issued" mode="section"/>)
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$area = 'authoring'">
            <br/><font size="-2" color="#ff0000">Noch nie publiziert</font>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <br clear="all" />
    </p>
  </xsl:template>

  <!-- Draws Dossier title and teaser image  -->
  <xsl:template name="dossier-head">
    <td valign="top" width="398" bgcolor="{up:color}" colspan="2">
      <table cellspacing="0" cellpadding="0" width="398" bgcolor="{up:color}" border="0" bordercolor="blue">
        <tbody>
          <tr height="28">
            <td align="left" width="402" colspan="2" height="28">&#160;&#160;&#160;&#160;&#160;
              <a href="{$root}/{$parent-url}{$documentlanguagesuffix}.html"><img height="5" alt="Alle Dossiers" src="{$imageprefix}/dossiers/doss_nav_list.gif" width="94" border="0"/></a>
            </td>
          </tr>
          <tr>
            <td align="left" width="90" class="rel-text">
              <xsl:apply-templates select="up:teaser" mode="dossier-image"/>
            </td>
            <td class="dos-title1" valign="top" width="308">Dossier:<br/>
              <div bxe_xpath="/up:dossier/lenya:meta/dc:title">
                <xsl:apply-templates select="lenya:meta/dc:title"/>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </td>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

