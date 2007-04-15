<?xml version="1.0" encoding="UTF-8"?>


<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
>


  <xsl:include href="../../../unizh/xslt/common/cachePostProcessing.xsl"/>


<!-- overwrite included templates -->

  <xsl:template match="style[@type = 'text/css']" priority="1">
    <xsl:copy-of select="."/>
  </xsl:template>


  <xsl:template match="unizh:rss-reader" priority="1">
    <unizh:rss-reader url="{@url}" items="{@items}" image="{@image}" link="{@link}" itemDescription="{@itemDescription}" itemImage="{@itemImage}" itemPubdate="{@itemPubdate}">
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


</xsl:stylesheet>
