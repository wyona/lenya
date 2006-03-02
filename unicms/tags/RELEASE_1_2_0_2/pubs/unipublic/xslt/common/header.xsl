<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
                xmlns="http://www.w3.org/1999/xhtml" 
                xmlns:dc="http://purl.org/dc/elements/1.1/" 
                xmlns:up="http://www.unipublic.unizh.ch/2002/up"
                xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" 
                xmlns:uz="http://unizh.ch" 
                xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                >
                
  <!-- includes the default CSS stylesheet -->
  <xsl:template name="include-css">
    <link rel="stylesheet" type="text/css" href="{$contextprefix}/unipublic/authoring/css/main.css" media="screen"/>
    <link rel="stylesheet" type="text/css" href="{$contextprefix}/unipublic/authoring/css/unipublic.mac.css" media="screen"/>
  </xsl:template>

  <xsl:template name="include-js">
    <script type="text/javascript" language="JavaScript">
      <xsl:comment>
<!--antiframe-->
if (top.frames.length &#62; 0) {top.location.href = self.location;}
<!-- CSS Triage-->
if (navigator.appVersion.indexOf ('Win') &#62;= 0) {
   seite = '{$contextprefix}/unipublic/authoring/css/unipublic.win.css';
   document.write('&#60;link rel="stylesheet" type="text/css" href="'+seite+'"&#62;');
}

<!-- Abo Window -->
function aboWindow() {
        newWind = open("http://www.unizh.ch/news/newsletter_abo.html","Display","toolbar=no,statusbar=no,height=280,width=225");
}

      </xsl:comment>
    </script>
  </xsl:template>

  <!-- includes the special style for the homepage -->
  <xsl:template name="include-homepage-style">
    <style type="text/css">
      <xsl:comment>
         body{ text-align: left; font-size: 12px; font-family: Verdana, Arial, Helvetica; background-color: #ffffff; color:#333333; link:#333399; alink:#CC0000; vlink:#666666; background-color:#F5F5F5; background-image:
 url("images/bg.gif")}
        .tsr-title {font-weight: bold; font-size: 10px; font-family: Geneva, Verdana, Helvetica, Arial, Swiss, "Nu Sans Regular"; text-transform: uppercase }
        .tsr-text { font-size: 10px; font-family: Geneva, Verdana, Helvetica, Arial, Swiss, "Nu Sans Regular" }
      </xsl:comment>
    </style>
  </xsl:template>

  <xsl:template name="topnavbar">
    <xsl:param name="is-front" />
  <form action="http://www.unizh.ch/cgi-bin/unisearch" method="post">
    <input type="hidden" value="www.unipublic.unizh.ch" name="url"/>
    <a id="topofpage" name="topofpage">&#160;</a>
    <table width="585" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td valign="middle" bgcolor="#999966" width="142">
          <img src="{$imageprefix}/spacer.gif" alt=" " width="3" height="20" border="0"/>
          <a href="http://www.unizh.ch/">
            <img src="{$imageprefix}/head/home.gif" alt="Home" border="0" height="17" width="31"/>
          </a>
        </td>
        <td colspan="2" align="right" valign="middle" bgcolor="#999966">&#160;<a href="http://www.unipublic.unizh.ch/ssi_unipublic/impressum.html">
            <img src="{$imageprefix}/head/kontakt.gif" alt="Kontakt" border="0" height="17" width="41" align="middle"/>
          </a>
          <img src="{$imageprefix}/head/strich.gif" alt="|" height="17" width="7" align="middle"/>
          <img src="{$imageprefix}/head/up_suchen.gif" alt="Suchen" height="17" width="79" align="middle"/>
          <input type="text" name="keywords" size="18"/>
          <input src="{$imageprefix}/head/go.gif" type="image" name="search4" align="middle"/>
        </td>
        <td valign="middle" bgcolor="#F5F5F5" width="57">&#160;</td>
      </tr>
      <tr>
        <td bgcolor="#666699" width="142">
          <img src="{$imageprefix}/spacer.gif" alt=" " width="10" height="39" border="0"/>
        </td>
        <td valign="bottom" bgcolor="#666699" width="96">
          <xsl:choose>
            <xsl:when test = " $documentid = '/index'">
              <img src="{$imageprefix}/head/uplogo_oben.gif" alt="unipublic" width="96" height="21" border="0"/>
            </xsl:when>
            <xsl:otherwise>
              <a href="{$root}/index.html/"><img src="{$imageprefix}/head/uplogo_oben.gif" alt="unipublic" width="96" height="21" border="0"/></a>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td align="right" valign="top" bgcolor="#666699" width="290">
          <a href="http://www.unizh.ch/">
            <img src="{$imageprefix}/head/uni_zh.gif" alt="Universit&#228;t Z&#252;rich" width="235" height="29" border="0"/>
          </a>
        </td>
        <td bgcolor="#666699" width="57"/>
      </tr>
      <tr>
        <td width="142"/>
        <td valign="top" width="96">
          <xsl:choose>
            <xsl:when test = " $documentid = '/index' ">
              <img src="{$imageprefix}/head/uplogo_unten.gif" alt="unipublic" width="96" height="29" border="0"/>
            </xsl:when>
            <xsl:otherwise>
              <a href="{$root}/index.html"><img src="{$imageprefix}/head/uplogo_unten.gif" alt="unipublic" width="96" height="29" border="0"/></a>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td width="290"/>
        <td width="57"/>
      </tr>
    </table>
  </form>
  </xsl:template>
  
</xsl:stylesheet>


