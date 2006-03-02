<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  
  >

  <xsl:template match="unizh:related-content">
    <xsl:choose>
      <xsl:when test="@link != ''">
        <unizh:related-content>
          <unizh:teaser>
            <unizh:title>Warnung!</unizh:title>
            <xhtml:p>
              Sie verweisen auf ein related-content-Element, welches wiederum auf ein anderes 
              related-content-Element verweist. Bitte verweisen Sie direkt auf die Inhalte, welche Sie anzeigen moechten.
            </xhtml:p>
          </unizh:teaser>
        </unizh:related-content>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="unizh:teaser">
    <xsl:choose>
      <xsl:when test="@link != ''">
        <unizh:teaser>
          <unizh:title>Warnung!</unizh:title>
            <xhtml:p>
              Sie verweisen auf einen Teaser, welcher wiederum auf einen Teaser verweist. 
              Bitte verweisen Sie direkt auf die Inhalte, welche Sie anzeigen moechten.
            </xhtml:p>
          </unizh:teaser>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
          </xsl:copy>
        </xsl:otherwise>
    </xsl:choose>
  </xsl:template> 


  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
