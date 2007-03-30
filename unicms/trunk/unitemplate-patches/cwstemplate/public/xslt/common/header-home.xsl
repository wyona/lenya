<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: header.xsl,v 1.40 2005/03/09 11:11:13 peter Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:unizh="http://uzh.ch/doctypes/elements/1.0" 
>


  <xsl:template name="header-home">
    <div id="headerarea">
      <div id="uniLogoPos"><a href="http://www.uzh.ch"><img src="{$localsharedresources}/images/logo_large_{$language}.png" alt="uzh logo" /></a></div>
        <div id="visuals">
          <div class="imgunilogo">
            <div id="imguniarea"><xsl:comment/></div>
          </div>
          <div class="imginstitute">
            <img src="{$localsharedresources}/images/key-visual_0.jpg" alt="key visual" width="180" height="45" id="key-visual" />
          </div>
        </div>
        <div id="headertitelpos">
          <xsl:apply-templates select="/document/xhtml:div[@id = 'servicenav']"/>
        </div>
        <div class="floatclear"><xsl:comment/></div>
        <!-- first level tabs -->
        <xsl:apply-templates select="/document/xhtml:div[@id = 'tabs']"/>
      </div>
  </xsl:template>

</xsl:stylesheet>
