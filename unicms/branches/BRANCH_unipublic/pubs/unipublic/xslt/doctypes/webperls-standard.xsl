<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: webperls-standard.xsl,v 1.4 2004/12/22 13:53:01 thomas Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:up="http://www.unipublic.unizh.ch/2002/up"
  xmlns:col="http://apache.org/cocoon/lenya/collection/1.0"
  xmlns:service="http://unizh.ch/doctypes/services/1.0"
  xmlns:webperls="http://unizh.ch/doctypes/webperls/1.0"
  exclude-result-prefixes="xhtml service webperls"
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
  
  
  <xsl:include href="../common/services.xsl"/>
  <xsl:include href="../common/webperls.xsl"/>
  <xsl:include href="../common/html-head.xsl"/>
  <xsl:include href="../common/header.xsl"/>
  <xsl:include href="../common/elements.xsl"/>
  <xsl:include href="../common/footer.xsl"/>
  
  <xsl:template match="document">
    <html>
      <xsl:call-template name="html-head"/>
      <body>
        <div id="main">
          <xsl:call-template name="topnavbar"/>
          <table border="0" cellpadding="0" cellspacing="0" width="585" bordercolor="red">
            <tr>
              <td id="navigation" align="right" valign="top" width="135">
                <xsl:apply-templates select="xhtml:div[@id = 'menu']"/>
                <xsl:apply-templates select="up:dossiersbox"/>
              </td>
              <td width="315" valign="top">
                <img height="9" width="19" src="{$imageprefix}/eck.gif"/><img src="{$imageprefix}/spacer.gif" height="21" alt=" "/>
                   <xsl:call-template name="topArticles"/>
                   <br />
                  <xsl:apply-templates select="up:homepage/col:document"/>
              </td>
              <td valign="top" width="135">
                <xsl:apply-templates select="service:Services"/>
                <div bxe_xpath="/webperls:{$document-element-name}">
                  <xsl:apply-templates select="content/webperls:webperls"/>
                </div>
              </td>
            </tr>
          </table>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="topArticles">
    <table cellspacing="1" cellpadding="0" width="315" bgcolor="#CCCC99" border="0" bordercolor="blue">
    <tbody>
      <tr>
        <td width="3" height="1"><img height="1" alt=" " src="{$imageprefix}/spacer.gif" width="1" border="0" /></td>
        <td width="153" height="1"></td>
        <td width="3" height="1"><img height="1" alt=" " src="{$imageprefix}/spacer.gif" width="1" border="0" /></td>
        <td width="153" height="1"></td>
        <td width="3" height="1"><img height="1" alt=" " src="{$imageprefix}/spacer.gif" width="1" border="0" /></td>
      </tr>
      <tr>
        <td width="3" bgcolor="#CCCC99"><img height="1" width="1" src="{$imageprefix}/1.gif"/></td>
        <td align="right" width="153" bgcolor="#CCCC99" valign="bottom">
          <xsl:apply-templates select="up:homepage/col:document[1]/up:teaser" mode="front"/>
        </td>
        <td width="3" bgcolor="#CCCC99"><img height="1" width="1" src="{$imageprefix}/1.gif"/></td>
        <td align="right" width="153" bgcolor="#CCCC99" valign="bottom">
          <xsl:apply-templates select="up:homepage/col:document[2]/up:teaser" mode="front"/>
        </td>
        <td width="3"><img height="1" width="1" src="{$imageprefix}/1.gif"/></td>
      </tr>
      <tr>
        <td width="3"><img height="1" width="1" src="{$imageprefix}/1.gif"/></td>
        <td width="153" valign="top" bgcolor="white" >
          <table cellspacing="0" cellpadding="3" border="0" bordercolor="green">
            <tr>
              <td class="tsr-text">
                <xsl:apply-templates select="up:homepage/col:document[1]" mode="top"/>
              </td>
            </tr>
          </table>
        </td>
        <td width="3"><img height="1" width="1" src="{$imageprefix}/1.gif"/></td>
        <td width="153" valign="top" bgcolor="white" >
          <table cellspacing="0" cellpadding="3" border="0" bordercolor="green">
            <tr>
              <td class="tsr-text">
                <xsl:apply-templates select="up:homepage/col:document[2]" mode="top"/>
              </td>
            </tr>
          </table>
        </td>
        <td width="3"><img height="1" width="1" src="{$imageprefix}/1.gif"/></td>
      </tr>
      <tr height="1">
        <td width="3" height="1"><img height="1" alt=" " src="{$imageprefix}/spacer.gif" width="1" border="0" /></td>
        <td width="153" height="1"><img height="1" alt=" " src="{$imageprefix}/spacer.gif" width="1" border="0" /></td>
        <td width="3" height="1"><img height="1" alt=" " src="{$imageprefix}/spacer.gif" width="1" border="0" /></td>
        <td width="153" height="1"><img height="1" alt=" " src="{$imageprefix}/spacer.gif" width="1" border="0" /></td>
        <td width="3" height="1"><img height="1" alt=" " src="{$imageprefix}/spacer.gif" width="1" border="0" /></td>
      </tr>
     </tbody>
    </table>  
  </xsl:template>


  <xsl:template match="up:dossiersbox">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <xsl:apply-templates select="col:document" mode="dossiersbox"/> 
    </table>
  </xsl:template>


  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
