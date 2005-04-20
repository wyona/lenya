<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: footer.xsl,v 1.4 2004/12/23 13:45:15 thomas Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:template name="footer">
    <xsl:param name="footer_date" />
    <div align="left">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><br/>
            <a href="#topofpage"><img src="{$imageprefix}/top.gif" alt="top" width="40" height="13" border="0" /></a>
          </td>
        </tr>
        <tr>
          <td bgcolor="#666666" height="1"><img src="{$imageprefix}/spacer.gif" alt="top" width="40" height="1" border="0" /></td>
        </tr>
        <tr>
          <td><font size="1">&#169;<i18n:text>university_zurich</i18n:text>,
                <xsl:if test="$footer_date and not($footer_date = '')">
                  <i18n:date src-pattern="yyyy-MM-dd" value="{$footer_date}"/>,
                </xsl:if>   
                <a href="http://www.unipublic.unizh.ch/ssi_unipublic/impressum.html">Impressum</a></font>
          </td>
        </tr>
      </table>
    </div>
  </xsl:template>

</xsl:stylesheet>
