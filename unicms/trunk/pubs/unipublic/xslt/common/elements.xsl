<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: elements.xsl,v 1.22 2004/12/21 15:53:46 edith Exp $ -->
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:col="http://apache.org/cocoon/lenya/collection/1.0"
  xmlns:up="http://www.unipublic.unizh.ch/2002/up"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
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
        <xsl:when test="$insertWhat = 'teaser'">
          <a href="?lenya.usecase=asset&amp;lenya.step=showscreen&amp;insert=true&amp;insertimage=true&amp;assetXPath={$trimmedElementPath}&amp;insertWhere={$insertWhere}&amp;insertTemplate=insertImg.xml">
            Upload Image
          </a>
        </xsl:when>
        <xsl:when test="$insertWhat = 'newteaser'">
          <a href="?lenya.usecase=asset&amp;lenya.step=showscreen&amp;insert=true&amp;insertimage=true&amp;assetXPath={$trimmedElementPath}&amp;insertWhere={$insertWhere}&amp;insertTemplate=insertImg.xml&amp;insertReplace=true">
            Change Image
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

  <xsl:template match="dcterms:issued">
    <xsl:variable name="date"><xsl:value-of select="."/></xsl:variable>
    <xsl:if test="$date!=''">
      <div class="art-date">
        <i18n:date src-pattern="yyyy-MM-dd HH:mm:ss" src-locale="en" value="{$date}"/> 
      </div>
    </xsl:if> 
  </xsl:template>

  <xsl:template match="dcterms:issued" mode="section">
    <xsl:variable name="date"><xsl:value-of select="."/></xsl:variable>
    <xsl:if test="$date!=''">
      <i18n:date src-pattern="yyyy-MM-dd HH:mm:ss" src-locale="en" value="{$date}"/> 
    </xsl:if> 
  </xsl:template>

  <xsl:template match="dc:subject">
    <div class="art-pretitle"><xsl:apply-templates/></div>
  </xsl:template>
  
  <xsl:template match="dc:title">
    <div class="art-title1"><xsl:apply-templates/></div>
  </xsl:template>

  <xsl:template match="dc:title" mode="tsr-title">
    <div class="tsr-title"><xsl:apply-templates/></div>
  </xsl:template>

  <xsl:template match="dc:description">
    <div class="art-lead"><xsl:apply-templates/></div>
  </xsl:template>
  
  <xsl:template match="dc:description" mode="front">
    <div class="tsr-text"><xsl:apply-templates/> </div>
  </xsl:template>
  
  <xsl:template match="dc:creator">
    <div class="art-author"><xsl:apply-templates/></div>
  </xsl:template>
  
  <xsl:template match="up:teaser" mode="isReferencedBy">
    <xsl:choose>
      <xsl:when test="./up:name">
      </xsl:when>
      <xsl:otherwise>
        <table width="187" border="0" cellspacing="0" cellpadding="0">
          <xsl:if test="not(../../preceding-sibling::dcterms:isReferencedBy)">
            <tr>
              <td align="right">
                <a href="{$root}/dossiers{$documentlanguagesuffix}.html">
                  <img src="{$imageprefix}/dossiers/doss_rub_title.gif" alt="Dossiers" height="28" width="112" border="0" />
                </a>
              </td>
            </tr>
          </xsl:if>
          <tr>
            <td bgcolor="{up:color}">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td valign="top" width="80"><a href="{$root}{@doc-id}{$documentlanguagesuffix}.html"><img src="{$root}{@doc-id}/{up:image}" alt="" width="80" height="60" border="0" /></a></td>
                  <td valign="top" width="8"><img src="{$imageprefix}/spacer.gif" alt=" " width="8" height="10" border="0" /></td>
                  <td class="dos-title1" valign="top"></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td bgcolor="white">
              <table border="0" cellspacing="8" cellpadding="0" bgcolor="white">
                <tr>
                  <td class="rel-text"><span class="rel-title"><a href="{$root}{@doc-id}{$documentlanguagesuffix}.html"><xsl:value-of select="dc:title" /></a></span><br/>
                    <xsl:choose>
                      <xsl:when test="string(normalize-space(xhtml:div[@class = 'tsr-text']))">
                        <xsl:value-of select="xhtml:div[@class = 'tsr-text']" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="dc:description" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
        <br />
        <img src="{$imageprefix}/spacer.gif" alt=" " width="50" height="15" border="0" /><br />
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  
  <xsl:template match="dc:metadata"/>

  <xsl:template match="up:related-contents" >
    <xsl:if test="up:related-content">
      <table width="180" border="0" cellspacing="0" cellpadding="0">
        <tr valign="top">
          <td width="180">
            <table width="180" border="0" cellspacing="0" cellpadding="0">
              <tr valign="top">
                <td width="180"><img height="19" width="187" src="{$imageprefix}/t_teil7.gif" alt="Muscheln1"/></td>
              </tr>
              <tr valign="top">
                <td width="180" valign="middle" bgcolor="#CCCC99">
                  <xsl:apply-templates select="up:related-content"/>
                </td>
              </tr>
              <tr valign="top">
                 <td width="180"><img height="27" width="181" src="{$imageprefix}/t_teil8.gif" align="right"/></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </xsl:if>
  </xsl:template>

  <xsl:template match="up:related-content">
    <table border="0" cellpadding="0" cellspacing="8" width="100%">
      <xsl:apply-templates select="./up:title"/>
      <xsl:apply-templates select="./up:link"/>
    </table>
  </xsl:template>

  <xsl:template match="up:title"> 
    <tr>
      <td class="rel-title">
        <xsl:apply-templates/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="up:link"> 
    <tr>
      <td class="rel-text">
        <xsl:apply-templates/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="up:tagline"> 
    <xsl:call-template name="asset-dots">
      <xsl:with-param name="insertWhere" select="'before'"/>
    </xsl:call-template>
    <div class="art-author"><xsl:apply-templates/></div>
  </xsl:template>

  <xsl:template match="up:teaser" mode="front">
    <xsl:variable name="documentId"><xsl:value-of select="substring-after(../@id,'/')"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="./xhtml:p/xhtml:object">
        <a href="{$root}{../@id}{$documentlanguagesuffix}.html"> 
          <img border="0">
            <xsl:attribute name="src">
              <xsl:value-of select="$documentId"/>/<xsl:value-of select="./xhtml:p/xhtml:object/@data"/>
            </xsl:attribute>
            <xsl:attribute name="alt"><xsl:value-of select="./xhtml:p/xhtml:object/@alt"/></xsl:attribute>
            <xsl:attribute name="align">right</xsl:attribute>
            <xsl:attribute name="width">80</xsl:attribute>
            <xsl:attribute name="height">60</xsl:attribute>
          </img>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <font color="red"> Attention: no image </font> <br/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="up:teaser">
  </xsl:template>

  <xsl:template match="up:teaser" mode="dossier-image">
      <xsl:apply-templates select="./xhtml:p/xhtml:object" mode="teaser-dossier"/>
        <xsl:if test="$area = 'authoring'">
          <xsl:call-template name="asset-dots">
 	        <xsl:with-param name="insertWhat" select="'newteaser'"/>
            <xsl:with-param name="insertWhere" select="'inside'"/>
          </xsl:call-template>
        </xsl:if>
  </xsl:template>


  <xsl:template match="up:teaser" mode="teaser">
    <xsl:if test="$area = 'authoring'">
      <table cellpadding="1" border="0" width="100%" bgcolor="#cccccc">
        <tr>
          <td>
            <table border="0" width="100%" bgcolor="white">
              <tr>
                <td class="tsr-text" width="40%"><b>Teaser-Image</b></td>
                <td class="tsr-text" widht="60%">
                  <xsl:choose>
                    <xsl:when test="./xhtml:p/xhtml:object">
                      <xsl:apply-templates select="./xhtml:p/xhtml:object" mode="teaser"/>
                        <xsl:call-template name="asset-dots">
 	                      <xsl:with-param name="insertWhat" select="'newteaser'"/>
                          <xsl:with-param name="insertWhere" select="'inside'"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="asset-dots">
 	                      <xsl:with-param name="insertWhat" select="'teaser'"/>
                          <xsl:with-param name="insertWhere" select="'inside'"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="tsr-text"><b>Teaser-Text</b></td>
                <td class="tsr-text">
                  <div bxe_xpath="/xhtml:{$document-element-name}/up:teaser/xhtml:div[@class='tsr-text']">
                    <xsl:value-of select="./xhtml:div[@class='tsr-text']"/>
                  </div>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
      <br/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="xhtml:object" mode="teaser-dossier">
    <img border="0" height="60" width="80" alt="">
      <xsl:attribute name="src">
        <xsl:value-of select="$nodeid"/>/<xsl:value-of select="@data"/>
      </xsl:attribute>
    </img>
  </xsl:template>
  
  <xsl:template match="xhtml:object" mode="teaser">
    <img border="0">
      <xsl:attribute name="src">
        <xsl:value-of select="$nodeid"/>/<xsl:value-of select="@data"/>
      </xsl:attribute>
      <xsl:attribute name="alt">Teaser Image</xsl:attribute>
      <xsl:attribute name="align">middle</xsl:attribute>
    </img>
  </xsl:template>
  
  <xsl:template match="xhtml:object" priority="3">
    <p>&#160;</p>
    <table border="0" cellpadding="0" cellspacing="0" width="250">
      <tr><td>
        <xsl:call-template name="object_link"/>
      </td></tr>
      <tr>
        <td class="img-text"><xsl:value-of select="text()"/><xsl:apply-templates select="dc:metadata/dc:creator" mode="img"/></td>
      </tr>
    </table>
    <p>&#160;</p>
  </xsl:template>
  
  <xsl:template match="dc:creator" mode="img">
    <xsl:if test="text()!=''">
      <span class="img-author"> (Bild: <xsl:value-of select="."/>)</span>
    </xsl:if>
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
              <xsl:value-of select="@title"/>
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
            <xsl:value-of select="@title"/>
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

  <xsl:template match="xhtml:body/xhtml:*">
    <xsl:call-template name="asset-dots">
      <xsl:with-param name="insertWhere" select="'before'"/>
    </xsl:call-template>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="col:document">
    <xsl:variable name="id"><xsl:value-of select="./@id"/></xsl:variable>
    <xsl:variable name="rest"><xsl:value-of select="substring-after($id,'/')"/></xsl:variable>
    <xsl:variable name="channel"><xsl:value-of select="substring-before($rest,'/')"/></xsl:variable>
    <xsl:variable name="rest2"><xsl:value-of select="substring-after($rest,'/')"/></xsl:variable>
    <xsl:variable name="section"><xsl:value-of select="substring-before($rest2,'/')"/></xsl:variable>
    <xsl:if test="position()>=3">
      <table border="0" bordercolor="green" cellpadding="0" cellspacing="0" width="315">
        <tr>
          <td colspan="3" bgcolor="white">
            <a href="{$channel}/{$section}{$documentlanguagesuffix}.html">
              <img src="{$imageprefix}/t_{$section}.gif" width="315" height="13" border="0" alt="{$section}"/>
            </a>
          </td>
        </tr>
        <tr>
          <td bgcolor="white" colspan="3" height="3"><img height="1" alt=" " src="{$imageprefix}/spacer.gif" width="1" border="0" />
          </td>
        </tr>
        <tr>
          <td width="4" bgcolor="white">&#160;</td>
          <td bgcolor="white" class="tsr-text">
            <p>
              <xsl:apply-templates select="up:teaser" mode="front"/>
              <xsl:call-template name="abstract"/>
              (<xsl:apply-templates select="lenya:meta/dcterms:issued" mode="section"/>)
            </p>
          </td>
          <td width="4" bgcolor="white">&#160;</td>
        </tr>
        <tr>
          <td bgcolor="white" colspan="3" height="3"><img height="1" alt=" " src="{$imageprefix}/spacer.gif" width="1" border="0" />
          </td>
        </tr>
      </table>
      <br />
    </xsl:if>
  </xsl:template>
  
  <xsl:template name = "abstract">
    <div class="tsr-title">
      <a href="{$root}{@id}{$documentlanguagesuffix}.html"><xsl:value-of select="lenya:meta/dc:title"/></a>
    </div>
    <xsl:choose>
      <xsl:when test="up:teaser/xhtml:div[@class='tsr-text'] !=''">
        <xsl:apply-templates select="up:teaser/xhtml:div[@class='tsr-text']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="lenya:meta/dc:description" mode="front"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="col:document" mode="top">
    <xsl:call-template name="abstract"/>
    (<xsl:apply-templates select="lenya:meta/dcterms:issued" mode="section"/>)
  </xsl:template>


  <xsl:template match="col:document" mode="dossiersbox">
    <tr>
      <td colspan="2" bgcolor="{up:color}"> 
        <a href="{$root}{@id}{$documentlanguagesuffix}.html">
          <img border="0">
            <xsl:attribute name="src">
              <xsl:value-of select="substring-after(@id,'/')"/>/<xsl:value-of select="up:teaser/xhtml:p/xhtml:object/@data"/>
            </xsl:attribute>
            <xsl:attribute name="alt"><xsl:value-of select="up:teaser/xhtml:p/xhtml:object/@alt"/></xsl:attribute>
            <xsl:attribute name="width">80</xsl:attribute>
            <xsl:attribute name="height">60</xsl:attribute>
          </img>
        </a>
      </td>         
    </tr>    
    <tr>
      <td bgcolor="white">
        <xsl:call-template name="abstract"/> 
      </td>
      <td class="tsr-text" valign="top" bgcolor="white" width="3"><img src="{$imageprefix}/spacer.gif" alt=" " width="3" height="10" border="0" /></td>
    </tr>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
