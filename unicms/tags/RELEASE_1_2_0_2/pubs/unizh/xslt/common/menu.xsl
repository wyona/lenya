<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: xhtml-standard.xsl,v 1.11 2005/01/17 09:15:14 mike Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  >
  

  <xsl:template match="xhtml:div[@id = 'menu']" mode="tabs">

    <xsl:variable name="subhomepage" select="descendant::*[@doctype = 'unizh:homepage']"/>
  <!-- there could be several subhome pages - the last is the deepest -->
    <xsl:variable name="deepestSubhomepage" select="$subhomepage[last()]"/>
    <xsl:variable name="deepestSubhomepageType" select="$deepestSubhomepage/@subhomepageType"/>

      <xsl:choose>
  <!-- either there is no subhomepage or it is a 'homepage_clone' -->
        <xsl:when test="not($deepestSubhomepageType) or ($deepestSubhomepageType = 'homepage_clone')">

          <xsl:if test="count(xhtml:div) &gt; 0">
            <table cellspacing="1" cellpadding="0" border="1" width="100%" class="ornate">
              <tr>
  <!-- top level entries BELOW homepage -->
                <xsl:apply-templates select="xhtml:div[@level != '0']" mode="tabs"/>
              </tr>
            </table>
          </xsl:if>

        </xsl:when>
        <xsl:when test="$deepestSubhomepageType = 'full_subhome'">

          <xsl:if test="$deepestSubhomepage/node()">
            <table cellspacing="1" cellpadding="0" border="1" width="100%" class="ornate">
              <tr>
                <xsl:apply-templates select="$deepestSubhomepage/node()" mode="tabs"/>
              </tr>
            </table>
          </xsl:if>

        </xsl:when>
        <xsl:when test="$deepestSubhomepageType = 'lean_subhome'"/>
        <xsl:otherwise/>
      </xsl:choose>

  </xsl:template>
  


  <xsl:template match="xhtml:div" mode="tabs">

    <xsl:choose>
      <xsl:when test="@current = 'true'">
        <td> <xsl:value-of select="@label"/> </td>
      </xsl:when>
      <xsl:otherwise>
        <td> <a href="{@href}"> <xsl:value-of select="@label"/> </a> </td>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  


  <xsl:template match="xhtml:div[@id = 'menu']" mode="menu_for_tabs">

    <xsl:variable name="subhomepage" select="descendant::*[@doctype = 'unizh:homepage']"/>
  <!-- there could be several subhome pages - the last is the deepest -->
    <xsl:variable name="deepestSubhomepage" select="$subhomepage[last()]"/>
    <xsl:variable name="deepestSubhomepageType" select="$deepestSubhomepage/@subhomepageType"/>

    <xsl:copy>
     <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <xsl:choose>

  <!-- there is no subhomepage -->
        <xsl:when test="not($deepestSubhomepageType)">
          <xsl:apply-templates select="." mode="print">
            <xsl:with-param name="print_header" select="'false'"/>
            <xsl:with-param name="data_start_level" select="'2'"/>
          </xsl:apply-templates>
        </xsl:when>

        <xsl:when test="($deepestSubhomepageType = 'homepage_clone') and ($deepestSubhomepage/@level = '1')">
          <xsl:apply-templates select="$deepestSubhomepage" mode="print">
            <xsl:with-param name="print_header" select="'false'"/>
            <xsl:with-param name="data_start_level" select="'2'"/>
          </xsl:apply-templates>
        </xsl:when>

        <xsl:when test="$deepestSubhomepageType = 'homepage_clone'">
          <xsl:apply-templates select="$deepestSubhomepage" mode="print">
            <xsl:with-param name="print_header" select="'true'"/>
            <xsl:with-param name="data_start_level" select="$deepestSubhomepage/@level + 1"/>
          </xsl:apply-templates>
        </xsl:when>

        <xsl:when test="$deepestSubhomepageType = 'full_subhome'">
          <xsl:apply-templates select="$deepestSubhomepage" mode="print">
            <xsl:with-param name="print_header" select="'false'"/>
            <xsl:with-param name="data_start_level" select="$deepestSubhomepage/@level + 2"/>
          </xsl:apply-templates>
        </xsl:when>

        <xsl:when test="$deepestSubhomepageType = 'lean_subhome'">
          <xsl:apply-templates select="$deepestSubhomepage" mode="print">
            <xsl:with-param name="print_header" select="'false'"/>
            <xsl:with-param name="data_start_level" select="$deepestSubhomepage/@level + 1"/>
          </xsl:apply-templates>
        </xsl:when>

        <xsl:otherwise/>
      </xsl:choose>
     </table>
    </xsl:copy>

  </xsl:template>

  

  <xsl:template match="xhtml:div[@id = 'menu']" mode="menu_only">

    <xsl:variable name="subhomepage" select="descendant::*[@doctype = 'unizh:homepage']"/>
  <!-- there could be several subhome pages - the last is the deepest -->
    <xsl:variable name="deepestSubhomepage" select="$subhomepage[last()]"/>
    <xsl:variable name="deepestSubhomepageType" select="$deepestSubhomepage/@subhomepageType"/>

    <xsl:copy>
     <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <xsl:choose>

  <!-- there is no subhomepage; -->
        <xsl:when test="not($deepestSubhomepageType)">
          <xsl:apply-templates select="." mode="print">
            <xsl:with-param name="print_header" select="'true'"/>
            <xsl:with-param name="data_start_level" select="'1'"/>
          </xsl:apply-templates>
        </xsl:when>

        <xsl:when test="$deepestSubhomepageType = 'homepage_clone'">
          <xsl:apply-templates select="$deepestSubhomepage" mode="print">
            <xsl:with-param name="print_header" select="'true'"/>
            <xsl:with-param name="data_start_level" select="$deepestSubhomepage/@level + 1"/>
          </xsl:apply-templates>
        </xsl:when>

        <xsl:when test="$deepestSubhomepageType = 'full_subhome'">
          <xsl:apply-templates select="$deepestSubhomepage" mode="print">
            <xsl:with-param name="print_header" select="'false'"/>
            <xsl:with-param name="data_start_level" select="$deepestSubhomepage/@level + 1"/>
          </xsl:apply-templates>
        </xsl:when>

        <xsl:when test="$deepestSubhomepageType = 'lean_subhome'">
          <xsl:apply-templates select="$deepestSubhomepage" mode="print">
            <xsl:with-param name="print_header" select="'false'"/>
            <xsl:with-param name="data_start_level" select="$deepestSubhomepage/@level + 1"/>
          </xsl:apply-templates>
        </xsl:when>

        <xsl:otherwise/>
      </xsl:choose>
     </table>
    </xsl:copy>

  </xsl:template>
  


  <xsl:template match="xhtml:div" mode="print">

    <xsl:param name="print_header"/>
    <xsl:param name="data_start_level"/>

    <xsl:choose>
      <xsl:when test="($print_header = 'true') and @level and (@level = $data_start_level - 1)">

	<tr>
	  <td class="publtitle">
            <a href="{@href}"> <xsl:value-of select="@label"/> </a>
<!--        <a href="{$contextprefix}/physik/{$area}/{@rel_href}"> <xsl:value-of select="@label"/> </a>  -->
          </td>
	</tr>
	<tr>
	  <td class="navoff">&#160;</td>
	</tr>

      </xsl:when>
      <xsl:when test="(@level &gt; $data_start_level - 1) and (@current = 'true')">

        <xsl:variable name="relativeLevel" select="@level - $data_start_level + 1"/>

        <tr>
          <td class="navon">
            <div class="nlevel{$relativeLevel}">
              <xsl:value-of select="@label"/>
            </div>
          </td>
        </tr>

      </xsl:when>
      <xsl:when test="(@level &gt; $data_start_level - 1)">

        <xsl:variable name="relativeLevel" select="@level - $data_start_level + 1"/>

        <tr>
          <td class="navoff">
            <div class="nlevel{$relativeLevel}">
              <a href="{@href}"> <xsl:value-of select="@label"/> </a>
<!--          <a href="{$contextprefix}/physik/{$area}/{@rel_href}"> <xsl:value-of select="@label"/> </a>  -->
            </div>
          </td>
        </tr>

      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>

    <xsl:apply-templates select="xhtml:div" mode="print">
      <xsl:with-param name="print_header" select="$print_header"/>
      <xsl:with-param name="data_start_level" select="$data_start_level"/>
    </xsl:apply-templates>

  </xsl:template>
  


  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
