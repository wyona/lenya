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

  <xsl:param name="documentid"/>

  <xsl:template name="header">
    <div id="headerarea">
      <div style="float:right;width:195px;">
        <div class="imgunilogo">
          <a href="http://www.unizh.ch">
            <img src="{$localsharedresources}/images/logo_{$language}.gif" alt="unizh logo" width="180" height="45" />
          </a>
        </div>
        <div class="imginstitute">
          <xsl:choose>
            <xsl:when test="starts-with($documentid, '/forschung')">
              <img src="{$localsharedresources}/images/kv-forschung.jpg" alt="theme picture" width="180" height="45" />
            </xsl:when>
            <xsl:when test="starts-with($documentid, '/organisation')">
              <img src="{$localsharedresources}/images/kv-organisation.jpg" alt="theme picture" width="180" height="45" />
            </xsl:when>
            <xsl:when test="starts-with($documentid, '/portrait')">
              <img src="{$localsharedresources}/images/kv-portrait.jpg" alt="theme picture" width="180" height="45" />
            </xsl:when>
            <xsl:when test="starts-with($documentid, '/services')">
              <img src="{$localsharedresources}/images/kv-services.jpg" alt="theme picture" width="180" height="45" />
            </xsl:when>
            <xsl:when test="starts-with($documentid, '/studium')">
              <img src="{$localsharedresources}/images/kv-studium.jpg" alt="theme picture" width="180" height="45" />
            </xsl:when>
            <xsl:otherwise>
              <img src="{$localsharedresources}/images/key-visual.jpg" alt="theme picture" width="180" height="45" />
            </xsl:otherwise>
          </xsl:choose>
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
    <xsl:if test="/document/xhtml:div[@id = 'sub-tabs']">
      <div class="floatclear"><xsl:comment/></div>
      <xsl:apply-templates select="/document/xhtml:div[@id = 'sub-tabs']"/>
    </xsl:if>
    <div class="floatclear"><xsl:comment/></div>
    <div class="endheaderline">
      <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
    </div>
  </xsl:template>


</xsl:stylesheet>
