<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"   
>


  <xsl:template match="unizh:rss-reader">
    <unizh:rss-reader url="{@url}" items="{@items}" image="{@image}" link="{@link}" itemDescription="{@itemDescription}" itemImage="{@itemImage}">
      <unizh:title><xsl:value-of select="unizh:title"/></unizh:title>
      <cinclude:includexml ignoreErrors="true">
        <xsl:choose>
          <xsl:when test="starts-with(@url, 'http://')">
            <cinclude:src><xsl:value-of select="@url"/></cinclude:src>
          </xsl:when>
          <xsl:otherwise>
            <cinclude:src>cocoon:/include-rss/<xsl:value-of select="@url"/></cinclude:src>
          </xsl:otherwise>
        </xsl:choose>
      </cinclude:includexml> 
    </unizh:rss-reader>
  </xsl:template>


  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
