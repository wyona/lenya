<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>


  <xsl:param name="lastmodified" />
  <xsl:variable name="date" select="substring($lastmodified, 1, 10)" />

  <xsl:template name="footer">
    <div id="footer">
      <xsl:if test="$document-element-name != 'unizh:homepage4cols'">
        <xsl:apply-templates select="/document/xhtml:div[@id = 'breadcrumb']" />
      </xsl:if>
      <div id="credits">
        &#169;&#160;<xsl:value-of select="/document/content/*/lenya:meta/dc:rights" />
        | <i18n:date src-pattern="yyyy-MM-dd" value="{$date}" />
        <xsl:if test="/document/xhtml:div[@id = 'footnav']/xhtml:div[@id = 'impressum']">
          | 
          <a href="{/document/xhtml:div[@id = 'footnav']/xhtml:div[@id = 'impressum']/@href}">
            <xsl:value-of select="/document/xhtml:div[@id = 'footnav']/xhtml:div[@id = 'impressum']" />
          </a>
        </xsl:if>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
