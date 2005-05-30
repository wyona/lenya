<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  >


  <xsl:template match="unizh:rss-reader">
    <unizh:rss-reader items="{@numberOfItems}">
      <title><xsl:value-of select="."/></title>
      <cinclude:includexml ignoreErrors="true">
        <cinclude:src><xsl:value-of select="@url"/></cinclude:src>
      </cinclude:includexml>
    </unizh:rss-reader>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
