<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:wp="http://unizh.ch/doctypes/webperls/1.0" 
  exclude-result-prefixes="wp">
  
  <xsl:template match="wp:webperls">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="wp:webperls/xhtml:div">
    <xhtml:div class="webperlen">
    <table border="0" cellpadding="2" cellspacing="0">
      <tr>
        <td width="125" class="webperlen">
          <span style="color: #333333">
            <xsl:value-of select="wp:title"/>
          </span>
        </td>
      </tr>
      <xsl:for-each select="wp:webperl">
        <tr>
          <td>
            <img height="1" width="131" src="{$imageprefix}/strich_weiss.gif" alt=""/>
          </td>
        </tr>
        <tr>
          <td class="webperlen">
            <img height="7" width="7" src="{$imageprefix}/t_perle.gif" alt=""/>
            <xsl:apply-templates select="."/>
          </td>
        </tr>
      </xsl:for-each>
      <tr>
        <td>
          <img height="1" width="125" src="{$imageprefix}/white.gif" alt=""/>
        </td>
      </tr>
      <tr>
        <td class="webperlen">
          <img height="7" width="7" src="{$imageprefix}/t_perle.gif" alt=""/>
          <xsl:text>&#160;</xsl:text>
          <img height="7" width="7" src="{$imageprefix}/t_perle.gif" alt=""/>
          <xsl:text>&#160;</xsl:text>
          <img height="7" width="7" src="{$imageprefix}/t_perle.gif" alt=""/>
          <xsl:text>&#160;</xsl:text>
          <a href="{@id}">weitere Perlen ...</a>
        </td>
      </tr>
    </table>
    </xhtml:div>
  </xsl:template>
  
  
  <xsl:template match="wp:webperl">
    <xsl:apply-templates select="wp:title" mode="webperl"/>
    <xsl:apply-templates select="wp:byline" mode="webperl"/>
  </xsl:template>
  
  
  <xsl:template match="wp:title" mode="webperl">
    <xsl:text>&#160;</xsl:text>
    <a href="{@href}">
      <xsl:value-of select="."/>
    </a>
    <br/>
  </xsl:template>
  
  
  <xsl:template match="wp:byline" mode="webperl">
    <xsl:value-of select="."/>
  </xsl:template>
  
  
</xsl:stylesheet>
