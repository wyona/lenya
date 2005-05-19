<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet exclude-result-prefixes="xhtml" version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" xmlns:uz="http://unizh.ch"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="variables.xsl"/>
  <xsl:param name="root"/>
  <!-- the URL up to (including) the area -->
  <xsl:param name="contextprefix"/>
  <xsl:param name="language"/>
  <xsl:param name="defaultlanguage"/>
  <xsl:param name="languages"/>
  <xsl:param name="nodeid"/>
  <xsl:param name="lastmodified"/>


  <xsl:include href="../common/html-head.xsl"/>
  <xsl:include href="../common/header.xsl"/>
  <xsl:include href="../common/footer.xsl"/>
 
  <xsl:template match="document">
    <xsl:apply-templates select="content/*"/>
  </xsl:template>
  <xsl:template match="unizh:section">
    <html>
      <xsl:call-template name="html-head"/>
      <body>
        <div id="page">
          <a name="top"/>
          <!-- Haupttabelle -->
          <table border="0" cellpadding="0" cellspacing="0" width="585">
            <xsl:call-template name="topnavbar">
              <xsl:with-param name="type" select="'narrow'"/>
              <xsl:with-param name="printview" select="'false'"/>
            </xsl:call-template>
          </table>
          <table border="0" cellpadding="0" cellspacing="0" width="585">
            <tr height="56">
              <td bgcolor="#F5F5F5" colspan="12">&#160;</td>
            </tr>
            <tr>
              <xsl:apply-templates select="unizh:column[@id = '1']"/>
              <xsl:call-template name="separator"/>
              <xsl:apply-templates select="unizh:column[@id = '2']"/>
              <xsl:call-template name="separator"/>
              <xsl:apply-templates select="unizh:column[@id = '3']"/>
            </tr>
            <xsl:call-template name="footer_section"/>
           </table>
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="unizh:column">
    <td class="navig" valign="top" width="187">
      <table border="0" cellpadding="0" cellspacing="0" width="187">
        <xsl:apply-templates/>
      </table>
    </td> 
  </xsl:template>
  <xsl:template match="unizh:grouplist">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template name="separator">
   <td bgcolor="#F5F5F5" class="navig" width="5">&#160;</td>
    <td bgcolor="#999999" width="1">
      <img alt=" " height="1" src="img_uni/1.gif" width="1"/>
    </td>
    <td bgcolor="#F5F5F5" class="navig" width="5">&#160;</td>
  </xsl:template>
  
  <xsl:template match="unizh:group">
    <xsl:apply-templates select="unizh:head"/>
    <tr valign="top">
      <td class="navig" colspan="2" width="187">
        <span class="navig">
          <br/>
          <xsl:apply-templates select="unizh:entrylist"/>
        </span>
      </td>
    </tr>
    <tr valign="top">
      <td bgcolor="" colspan="2" width="187">&#160;</td>
    </tr>
  </xsl:template>

  <xsl:template match="unizh:head">
    <tr height="17" valign="top">
      <td bgcolor="#666699" class="navig" height="17" width="7">&#160;</td>
      <td bgcolor="#666699" class="navig" height="17" valign="middle" width="180">
        <span class="titel">
          <a class="title_head" href="{unizh:link}">
            <xsl:value-of select="unizh:title"/>             
          </a>
        </span>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="unizh:entrylist">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="unizh:entry">
    <a href="{unizh:link}" class="link">
      <xsl:value-of select="unizh:title"/>
    </a>
    <br/>
  </xsl:template>
  <xsl:template match="unizh:highlights">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="unizh:highlight">
    <tr height="17" valign="top">
      <td bgcolor="#cccc99" class="navig" height="17" width="7">
        <img alt=" " height="1" src="img_uni/1.gif" width="1"/>
      </td>
      <td bgcolor="#cccc99" class="navig" height="17" valign="middle" width="180">
        <span class="titel">
          <xsl:value-of select="unizh:highlight-title"/>
        </span>
      </td>
    </tr> 
    <tr valign="top">
      <td bgcolor="#cccc99" class="navig" width="7">&#160;</td>
      <td bgcolor="#cccc99" class="navig" valign="top" width="180">&#160;</td>
    </tr>
    <tr valign="top">
      <td bgcolor="#cccc99" class="navig" width="7">&#160;</td>
      <td bgcolor="#cccc99" class="navig" valign="top" width="180">
        <xsl:apply-templates mode="translate-to-xhtml" select="*[not(local-name() = 'highlight-title')]"/>
      </td>
    </tr>
    <tr>
      <td bgcolor="#F5F5F5" class="navig" height="17" width="7">
        <img alt=" " height="1" src="img_uni/1.gif" width="1"/>
      </td>
    </tr>
  </xsl:template>
 
  <xsl:template match="*" mode="translate-to-xhtml">
    <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="translate-to-xhtml"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
