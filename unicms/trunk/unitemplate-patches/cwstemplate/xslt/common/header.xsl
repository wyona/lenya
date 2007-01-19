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

  <xsl:param name="publicationid"/>
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
            <xsl:when test="starts-with($documentid, '/research')">
              <img src="{$localsharedresources}/images/kv_research.jpg" alt="theme picture" width="180" height="45" />
            </xsl:when>
            <xsl:when test="starts-with($documentid, '/organization')">
              <img src="{$localsharedresources}/images/kv_organization.jpg" alt="theme picture" width="180" height="45" />
            </xsl:when>
            <xsl:when test="starts-with($documentid, '/portrait')">
              <img src="{$localsharedresources}/images/kv_portrait.jpg" alt="theme picture" width="180" height="45" />
            </xsl:when>
            <xsl:when test="starts-with($documentid, '/services')">
              <img src="{$localsharedresources}/images/kv_services.jpg" alt="theme picture" width="180" height="45" />
            </xsl:when>
            <xsl:when test="starts-with($documentid, '/studies')">
              <img src="{$localsharedresources}/images/kv_studies.jpg" alt="theme picture" width="180" height="45" />
            </xsl:when>
            <xsl:otherwise>
              <img src="{$localsharedresources}/images/key-visual.jpg" alt="theme picture" width="180" height="45" />
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </div>
      <div id="headertitelpos">
        <xsl:apply-templates select="/document/xhtml:div[@id = 'servicenav']"/>
        <xsl:choose>
          <xsl:when test="$publicationid = 'public'"/>
          <xsl:when test="$document-element-name = 'unizh:homepage' or $document-element-name = 'unizh:homepage4cols'">
            <h1>
              <span bxe_xpath="/{$document-element-name}/unizh:header/unizh:heading">
                <a href="{/document/xhtml:div[@id = 'servicenav']/xhtml:div[@id = 'home']/@href}">
                  <xsl:value-of select="/document/content/*/unizh:header/unizh:heading"/>
                </a>
              </span>
            </h1>
          </xsl:when>
          <xsl:otherwise>
            <h1>
              <a href="{/document/xhtml:div[@id = 'servicenav']/xhtml:div[@id = 'home']/@href}">
                <xsl:value-of select="/document/content/*/unizh:header/unizh:heading"/>
              </a>
            </h1>
          </xsl:otherwise> 
        </xsl:choose>
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
