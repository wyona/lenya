<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: xhtml-standard.xsl,v 1.11 2005/01/17 09:15:14 thomas Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:uz="http://unizh.ch"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  exclude-result-prefixes="xhtml lenya dc unizh uz"
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
  <xsl:include href="../common/breadcrumb.xsl"/>
  <xsl:include href="../common/elements.xsl"/>
  <xsl:include href="../common/footer.xsl"/>


  <xsl:template match="document">
    <xsl:apply-templates select="content/*"/>
  </xsl:template>
  
  
  <xsl:template match="content/*">
    <html>
        
      <xsl:call-template name="html-head"/>
        
      <body>
        <div id="page">
          <a name="top"/>

          <table cellspacing="1" cellpadding="0" border="0" width="800">
            
            <xsl:call-template name="topnavbar"/>
            
            <tr>
              <td class="breadcrumb" colspan="3" width="800"><br />
                <xsl:call-template name="breadcrumb"/>
              </td>
            </tr>
            
            <tr>
              <td width="187" height="40"><img height="40" width="187" src="{$imageprefix}/1.gif" alt=" "/></td>
              <td width="413" height="40"><img height="40" width="413" src="{$imageprefix}/1.gif" alt=" "/></td>
              <td width="200" height="40"><img height="40" width="200" src="{$imageprefix}/1.gif" alt=" "/></td>
            </tr>
            
            <tr id="body">
              <xsl:variable name="columns" select="@unizh:columns"/>
              <xsl:choose>
                <xsl:when test="$columns = '2'">
                  <xsl:call-template name="two-columns"/>
                </xsl:when>
                <xsl:when test="$columns = '3'">
                  <xsl:call-template name="three-columns"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="one-column"/>
                </xsl:otherwise>
              </xsl:choose>   
            </tr>
            
            <xsl:call-template name="footer"/>
            
          </table>
        </div>
      </body>
    </html>
  </xsl:template>
  

<xsl:template name="one-column">
  <td colspan="3" valign="top" width="1000" align="left">
    <xsl:apply-templates select="$content/lenya:meta/dc:title"/>
    <div>
      <xsl:if test="$rendertype = 'edit'">
        <xsl:attribute name="bxe_xpath">/xhtml:<xsl:value-of select="$document-element-name"/>/xhtml:body</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="$content/xhtml:body/node()"/>
    </div>
  </td>
</xsl:template>

  
<xsl:template name="two-columns">
  <td id="navigation" valign="top" width="187">
    <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
  </td>
  <td colspan="2" width="613" valign="top" align="left">
    <div class="content2cols">
      <xsl:apply-templates select="$content/lenya:meta/dc:title"/>
      <div>
        <xsl:if test="$rendertype = 'edit'">
          <xsl:attribute name="bxe_xpath">/xhtml:<xsl:value-of select="$document-element-name"/>/xhtml:body</xsl:attribute>
        </xsl:if>
        <xsl:apply-templates select="$content/xhtml:body/node()"/>
      </div>
    </div>
  </td>
</xsl:template>
  

<xsl:template name="three-columns">
  <td id="navigation" valign="top" width="187">
    <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
  </td>
  <td width="413" valign="top" align="left">
    <div class="content3cols">
      <xsl:apply-templates select="$content/unizh:identity"/>
      <xsl:choose>
        <xsl:when test="$content/unizh:slogan">            
          <xsl:apply-templates select="$content/unizh:slogan"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$content/lenya:meta/dc:title"/>
        </xsl:otherwise>
      </xsl:choose>
      <div>
        <xsl:choose>
          <xsl:when test="$document-element-name = 'homepage'">
            <xsl:attribute name="bxe_xpath">/unizh:homepage/xhtml:body</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="bxe_xpath">/xhtml:<xsl:value-of select="$document-element-name"/>/xhtml:body</xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="$content/xhtml:body/node()"/>
      </div>
    </div>
  </td>
  <td valign="top" width="200" align="left">
    <div class="highlights">
      <xsl:apply-templates select="$content/unizh:logo"/>
      <div>
        <xsl:choose>
          <xsl:when test="$document-element-name = 'homepage'">
            <xsl:attribute name="bxe_xpath">/unizh:homepage/unizh:highlights</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="bxe_xpath">/xhtml:<xsl:value-of select="$document-element-name"/>/unizh:highlights</xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="$content/unizh:highlights"/>
      </div>
    </div>
  </td>
</xsl:template>

  
<xsl:template match="@*|node()" priority="-1">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
