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
      <div style="float:right;width:195px;">
        <div class="imgunilogo">
          <img src="{$imageprefix}/logo.jpg" alt="unizh logo" width="180" height="45" border="0" />
        </div>
        <div class="imginstitute">
          <img src="{$imageprefix}/uniimg.jpg" alt="uni picture" width="180" height="45" border="0" />
        </div>
      </div>
      <div id="headertitelpos">
        <xsl:apply-templates select="/document/xhtml:div[@id = 'servicenav']"/>
        <xsl:choose>
          <xsl:when test="$document-element-name = 'unizh:homepage' or $document-element-name = 'unizh:homepage4cols'">
            <h2>
              <div bxe_xpath="/{$document-element-name}/unizh:header/unizh:superscription">
                <xsl:value-of select="/document/content/*/unizh:header/unizh:superscription"/>
              </div>
            </h2>
            <h1>
              <div bxe_xpath="/{$document-element-name}/unizh:header/unizh:heading">
                <xsl:value-of select="/document/content/*/unizh:header/unizh:heading"/>
              </div>
            </h1>
          </xsl:when>
          <xsl:otherwise>
            <h2>
              <xsl:value-of select="/document/content/*/unizh:header/unizh:superscription"/>
            </h2>
            <h1>
              <xsl:value-of select="/document/content/*/unizh:header/unizh:heading"/>
            </h1>
          </xsl:otherwise> 
        </xsl:choose>
      </div>
    </div>
    <div class="floatclear"><xsl:comment/></div>
    <!-- tabs -->
    <xsl:apply-templates select="/document/xhtml:div[@id = 'tabs']"/>
    <div class="floatclear"><xsl:comment/></div>
    <div class="endheaderline">
      <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1" border="0" />
    </div>
  </xsl:template>

</xsl:stylesheet>


