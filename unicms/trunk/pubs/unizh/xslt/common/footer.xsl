<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: footer.xsl,v 1.10 2004/11/24 11:52:50 jann Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:lenya="http://apache.org/cocoon/lenya/document/1.0"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:template name="footer">
    <tr id="footer">
      <td bgcolor="#f5f5f5" width="187"/>
      <td class="footer" colspan="2" width="813">
        <br/>
        <img alt=" " height="1" src="{$imageprefix}/999999.gif" width="587"/>
        <br/>
        <xsl:call-template name="copyright"/>
      </td>
    </tr>
  </xsl:template>
  
  <xsl:template name="footer-print">
    <br/>
    <img alt=" " height="1" src="{$imageprefix}/999999.gif" width="100%"/>
    <br/>
    <xsl:call-template name="copyright"/>
  </xsl:template>
  
  <xsl:template name="copyright">
    <xsl:variable name="date" select="substring($lastmodified, 1, 10)"/> ©
    <i18n:text>university_zurich</i18n:text>,
    <i18n:date src-pattern="yyyy-MM-dd" value="{$date}"/>,
    <a href="{$root}/impressum{$documentlanguagesuffix}.html"><i18n:text>impressum</i18n:text></a>
  </xsl:template>
  
  <xsl:template name="footer_section">
    <tr id="footer_s">
      <td colspan="4"/>
      <td class="footer_s" colspan="8">
        <br/>
        <img alt=" " height="1" src="{$imageprefix}/999999.gif" width="100%"/>
        <br/>
        <xsl:call-template name="copyright"/>
      </td>
    </tr>
    
  </xsl:template>
  
</xsl:stylesheet>
