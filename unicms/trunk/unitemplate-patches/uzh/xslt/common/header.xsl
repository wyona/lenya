<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: header.xsl, v 1.00 2006/11/20 17:00:00 mike Exp $ -->

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- no additional templates in original file;
     skip duplicate templates if it should be necessary to include the original file

  <xsl:include href="../../../unizh/xslt/common/header.xsl"/>
-->

  <xsl:template name="header">
    <div id="headerarea">
      <div style="float:right;width:195px;">
        <div class="imgunilogo">
          <a href="http://www.unizh.ch">
            <img src="{$localsharedresources}/images/logo_{$language}.gif" alt="unizh logo" width="180" height="45" />
          </a>
        </div>
        <div class="imginstitute">
          <img src="{$localsharedresources}/images/key-visual.jpg" alt="institute's picture" width="180" height="45" />
        </div>
      </div>
      <div id="headertitelpos">
        <xsl:apply-templates select="/document/xhtml:div[@id = 'servicenav']"/>
      </div>
    </div>
    <div class="floatclear"><xsl:comment/></div>
    <!-- tabs -->
    <xsl:choose>
      <xsl:when test="/document/xhtml:div[@id = 'tabs']">
        <xsl:apply-templates select="/document/xhtml:div[@id = 'tabs']"/>
      </xsl:when>
      <xsl:otherwise>
        <div id="primarnav">&#160;</div>
      </xsl:otherwise>
    </xsl:choose>
    <div class="floatclear"><xsl:comment/></div>
    <div class="endheaderline">
      <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
    </div>
  </xsl:template>


</xsl:stylesheet>
