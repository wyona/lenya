<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: header.xsl,v 1.8 2005/03/29 08:28:40 thomas Exp $ -->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
                xmlns="http://www.w3.org/1999/xhtml" 
                xmlns:dc="http://purl.org/dc/elements/1.1/" 
                >
                
  <!-- includes the default CSS stylesheet -->
  <xsl:template name="include-css">
    <link rel="stylesheet" type="text/css" href="{$contextprefix}/eltemplate/authoring/css/main.css" media="screen"/>
  </xsl:template>
    
  <xsl:template name="include-js">
    <script language="javascript" type="text/javascript"  src="javascript/main.js"/>
  </xsl:template>


  <!-- includes meta headers -->
  <xsl:template name="meta-headers">
    <meta name="keywords" content="{$content/lenya:meta/dc:subject}"/>
    <meta name="description" content="{$content/lenya:meta/dc:description}"/>
  </xsl:template>
  
  <xsl:template name="header">
    <table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td>
          <img src="{$imageprefix}/header.gif" width="1000" height="89" border="0"/>
        </td>
    </tr>
    </table>
  </xsl:template>

  <xsl:template name="cp-header">
   <table border="0" cellpadding="0" cellspacing="0">
      <tr id="topnavbar">
        <td>
          <img src="{$imageprefix}/header.gif" width="750" border="0"/>
        </td>
      </tr>
    </table>

  </xsl:template>
   
</xsl:stylesheet>


