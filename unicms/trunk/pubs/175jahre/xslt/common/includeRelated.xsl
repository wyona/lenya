<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
>


  <xsl:param name="area"/>

  <xsl:template match="unizh:related-content">
    <xsl:choose>
      <xsl:when test="@link != ''">
        <cinclude:includexml ignoreErrors="true">
          <cinclude:src>cocoon:/include-related/<xsl:value-of select="substring-after(@link, $area)"/></cinclude:src>
        </cinclude:includexml> 
      </xsl:when>
      <xsl:otherwise>
        <unizh:related-content>
          <xsl:apply-templates/>
        </unizh:related-content>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="unizh:teaser">
     <xsl:choose>
      <xsl:when test="@link != '' and @name != ''">
        <cinclude:includexml ignoreErrors="true">
          <cinclude:src>cocoon:/include-teaser/<xsl:value-of select="@name"/><xsl:value-of select="substring-after(@link, $area)"/></cinclude:src>
        </cinclude:includexml>   
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template> 


  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
