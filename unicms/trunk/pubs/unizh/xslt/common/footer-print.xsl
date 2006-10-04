<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: footer.xsl,v 1.10 2004/11/24 11:52:50 jann Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 

  <xsl:param name="lastmodified"/>
  <xsl:variable name="date" select="substring($lastmodified, 1, 10)"/>

  <xsl:template name="footer-print">
    <div class="footermargintop"><xsl:comment/></div>
    <div id="footer">&#169;&#160;<xsl:value-of select="/document/content/*/lenya:meta/dc:rights"/>
      | <i18n:date src-pattern="yyyy-MM-dd" value="{$date}"/>
      <xsl:variable name="publisher" select="/document/content/*/lenya:meta/dc:publisher"/>
      <xsl:if test="($publisher != '') and ($publisher != /document/content/*/lenya:meta/dc:rights)">
        <xsl:choose>
          <xsl:when test="contains($publisher, '@')">
            <script language="javascript">
              <xsl:comment>
                   var mailuser = "<xsl:value-of select="substring-before($publisher, '@')"/>";
                   var hostname = "<xsl:value-of select="substring-after($publisher, '@')"/>";
                   <![CDATA[
                     document.write(" | " + mailuser + "&#64;" + hostname);
                   ]]>
              </xsl:comment>
            </script>
          </xsl:when>
          <xsl:otherwise>
            | <xsl:value-of select="$publisher"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </div>
  </xsl:template>
  
</xsl:stylesheet>
