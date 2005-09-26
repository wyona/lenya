<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:index="http://apache.org/cocoon/lenya/documentindex/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  
  >

  <xsl:param name="element"/>

  <xsl:param name="name"/>


  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$element = 'unizh:related-content'">
        <xsl:choose>
          <xsl:when test="*/unizh:related-content">
            <xsl:apply-templates select="*/unizh:related-content"/>
          </xsl:when>
          <xsl:otherwise>
            <unizh:related-content/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="*/unizh:related-content/unizh:teaser[@name = $name]">
            <xsl:apply-templates select="*/unizh:related-content/unizh:teaser[@name = $name]"/>
          </xsl:when>
          <xsl:otherwise>
            <unizh:teaser>
              <unizh:title>Fehler</unizh:title>
              <xhtml:p>Teaser not found.</xhtml:p>
            </unizh:teaser>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
