<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: header.xsl,v 1.40 2005/03/09 11:11:13 peter Exp $ -->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
                xmlns="http://www.w3.org/1999/xhtml" 
                xmlns:dc="http://purl.org/dc/elements/1.1/" 
                xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" 
                xmlns:uz="http://unizh.ch" 
                xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                >
                

  <xsl:template name="header">
    <div id="headerarea">
      <xsl:choose>
        <xsl:when test="$document-element-name = 'unizh:homepage'">
          <h2>
            <xsl:value-of select="/document/content/unizh:homepage/unizh:header/unizh:superscription"/>
          </h2>
          <h1>
            <xsl:value-of select="/document/content/unizh:homepage/unizh:header/unizh:heading"/>
          </h1>
        </xsl:when>
        <xsl:when test="$document-element-name = 'unizh:homepage4cols'">
          <h2>
            <xsl:value-of select="/document/content/unizh:homepage4cols/unizh:header/unizh:superscription"/>
          </h2>
          <h1>
            <xsl:value-of select="/document/content/unizh:homepage4cols/unizh:header/unizh:heading"/>
          </h1>
        </xsl:when>
        <xsl:otherwise>
          <h2>
            <xsl:value-of select="/document/unizh:header/unizh:superscription"/>
          </h2>
          <h1>
            <xsl:value-of select="/document/unizh:header/unizh:heading"/>
          </h1>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

</xsl:stylesheet>


