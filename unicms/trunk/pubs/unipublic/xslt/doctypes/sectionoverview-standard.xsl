<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:up="http://www.unipublic.unizh.ch/2002/up"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  exclude-result-prefixes="xhtml lenya dc"
  >
  
  <xsl:import href="variables.xsl"/>
  
  <xsl:param name="root"/> <!-- the URL up to (including) the area -->
  <xsl:param name="contextprefix"/>
  
  <xsl:param name="documentid"/>
  <xsl:param name="nodeid"/>
  
  <xsl:param name="language"/>
  <xsl:param name="defaultlanguage"/>
  <xsl:param name="languages"/>
  
  <xsl:param name="completearea"/>
  <xsl:param name="area"/>
  
  <xsl:param name="rendertype"/>
  
  <xsl:param name="lastmodified"/>
  

  <xsl:include href="../common/html-head.xsl"/>
  <xsl:include href="../common/header.xsl"/>
  <xsl:include href="../common/elements.xsl"/>
  <xsl:include href="../common/footer.xsl"/>

  <xsl:variable name="sectionLabel"><xsl:value-of select="/document/xhtml:div[@id='menu']/xhtml:div[@class='menublock-selected-1']/xhtml:div[@class='menublock-selected-2']/xhtml:div[@class='menuitem-2']/a/img/@alt"/></xsl:variable>
  <xsl:variable name="rest"><xsl:value-of select="substring-after($documentid,'/')"/></xsl:variable>
  <xsl:variable name="channel"><xsl:value-of select="substring-before($rest,'/')"/></xsl:variable>
  <xsl:variable name="rest2"><xsl:value-of select="substring-after($rest,'/')"/></xsl:variable>
  <xsl:variable name="section"><xsl:value-of select="substring-before($rest2,'/')"/></xsl:variable>
  
  <xsl:template match="document">
    <html>
      <xsl:call-template name="html-head"/>        
      <body>
        <div id="main">
          <xsl:call-template name="topnavbar"/>
          <table cellspacing="0" cellpadding="0" border="0" width="585">
            <tr>
              <td id="navigation" align="right" valign="top" width="135">
                <xsl:apply-templates select="xhtml:div[@id = 'menu']"/>
              </td>
              <td id="overview" colspan="2" width="450" valign="top">
                <img src="{$imageprefix}/r_{$section}.gif" border="0" alt="{$sectionLabel}"/>
                <xsl:apply-templates select="xhtml:div[@id='years-navigation']"/>
                <xsl:apply-templates select="xhtml:div[@id='section-overview']"/>
              </td>
            </tr>
            <!-- Footer -->         
            <tr>
              <td width="135"></td>
              <td width="5"></td>
              <td width="445">
                <xsl:call-template name="footer">
                  <xsl:with-param name="footer_date" select="xhtml:div[@id='section-overview']/xhtml:div[@class='tsr-title'][1]/lenya:meta/dcterms:dateCopyrighted" />
                </xsl:call-template>
              </td>
            </tr>
          </table>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="xhtml:div[@id='section-overview']">
    <table cellspacing="0" cellpadding="0" border="0" width="450" valign="top">
      <td width="5" valign="top" bgcolor="white"><img src="{$imageprefix}/spacer.gif" width="5" alt=" " /></td>
      <td width="445" bgcolor="white" valign="top" class="tsr-text">
        <br/>
        <xsl:for-each select="xhtml:div[@class='tsr-title']">
          <xsl:choose>
            <xsl:when test="lenya:meta/dcterms:issued!=''">
            </xsl:when>
            <xsl:otherwise>
              <!--copy first the articles which weren't already published-->
              <xsl:apply-templates select="."/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="xhtml:div[@class='tsr-title']">
          <!-- sort by the publish date the articles which were already published--> 
          <xsl:sort select="substring(lenya:meta/dcterms:issued,1,4)" data-type="number" order="descending"/> <!-- year  -->
          <xsl:sort select="substring(lenya:meta/dcterms:issued,6,2)" data-type="number" order="descending"/> <!-- month -->
          <xsl:sort select="substring(lenya:meta/dcterms:issued,9,2)" data-type="number" order="descending"/> <!-- day   -->
          <xsl:sort select="substring(lenya:meta/dcterms:issued,12,2)" data-type="number" order="descending"/> <!-- hour  -->
          <xsl:sort select="substring(lenya:meta/dcterms:issued,15,2)" data-type="number" order="descending"/> <!-- min -->
          <xsl:sort select="substring(lenya:meta/dcterms:issued,17,2)" data-type="number" order="descending"/> <!-- s   -->
          <xsl:if test="lenya:meta/dcterms:issued!=''">
            <xsl:apply-templates select="."/>
          </xsl:if>
        </xsl:for-each>
      </td>             
    </table> 
  </xsl:template>

  <xsl:template match="xhtml:div[@class='tsr-title']">
    <p>
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="xhtml:a/@href"/>
        </xsl:attribute>
        <xhtml:div class="tsr-title">
          <xsl:value-of select="lenya:meta/dc:title"/>
        </xhtml:div>
      </a>
      <xsl:choose>
        <xsl:when test="up:teaser/xhtml:div[@class='tsr-text']!=''">
          <xsl:value-of select="up:teaser/xhtml:div[@class='tsr-text']"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="lenya:meta/dc:description"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="lenya:meta/dcterms:issued!=''">
          (<xsl:apply-templates select="lenya:meta/dcterms:issued" mode="section"/>)
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$area = 'authoring'">
            <br/><font size="-2" color="#ff0000">Noch nie publiziert</font>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </p>
  </xsl:template>

  <xsl:template match="xhtml:div[@id='years-navigation']">
    <!-- Drawing dynamic sub-navigation for the years 2002 and after (according to sitetree.xml) -->
    <xsl:apply-templates select="./*"/>
    <!-- Static years 1999-2001  -->
    <a href="http://www.unipublic.unizh.ch/{$channel}/{$section}/2001/"><img alt="2001" src="{$imageprefix}/jahr/2001_aus.gif" height="13" width="39" border="0" /></a>
    <a href="http://www.unipublic.unizh.ch/{$channel}/{$section}/2000/"><img alt="2000" src="{$imageprefix}/jahr/2000_aus.gif" height="13" width="39" border="0" /></a>
    <a href="http://www.unipublic.unizh.ch/{$channel}/{$section}/1999/"><img alt="1999" src="{$imageprefix}/jahr/1999_aus.gif" height="13" width="39" border="0" /></a>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
