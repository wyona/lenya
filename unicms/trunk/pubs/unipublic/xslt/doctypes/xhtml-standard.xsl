<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: xhtml-standard.xsl,v 1.12 2004/12/22 10:03:18 edith Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"  
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:uz="http://unizh.ch"
  xmlns:up="http://www.unipublic.unizh.ch/2002/up"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  exclude-result-prefixes="xhtml lenya dc up"
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

  <xsl:variable name="rest"><xsl:value-of select="substring-after($documentid,'/')"/></xsl:variable>
  <xsl:variable name="channel"><xsl:value-of select="substring-before($rest,'/')"/></xsl:variable>
  <xsl:variable name="rest2"><xsl:value-of select="substring-after($rest,'/')"/></xsl:variable>
  <xsl:variable name="section"><xsl:value-of select="substring-before($rest2,'/')"/></xsl:variable>

  <xsl:template match="document">
    <xsl:apply-templates select="content/*"/>
  </xsl:template>
  
  <xsl:template match="content/*">
    <html>
      <xsl:call-template name="html-head"/>
      <body>
        <div id="main">

          <xsl:call-template name="topnavbar"/>

          <table cellspacing="0" cellpadding="0" border="0" width="585">
            <tr>
              <td width="187"></td>
              <td colspan="2">
                <a href="../../{$section}{$documentlanguagesuffix}.html"><img height="13" src="{$imageprefix}/r_{$section}.gif" alt="{$section}" border="0"/></a>
              </td>
            </tr>

            <tr>
              <td valign="top" width="187">

                <xsl:apply-templates select="$content/lenya:meta/dcterms:isReferencedBy/up:dossier/up:teaser" mode="isReferencedBy"/>
                <div bxe_xpath="/xhtml:{$document-element-name}/up:related-contents">
                  <xsl:apply-templates select="$content/up:related-contents"/>
                </div>
              </td>


              <td width="5" bgcolor="white" valign="top">&#160;</td>
              <td valign="top" bgcolor="white" width="393" class="art-text">
                <xsl:apply-templates select="$content/up:teaser" mode="teaser"/>
                <xsl:apply-templates select="$content/lenya:meta/dcterms:issued"/>
                <div bxe_xpath="/xhtml:{$document-element-name}/lenya:meta/dc:subject"> 
                  <xsl:apply-templates select="$content/lenya:meta/dc:subject"/>
                </div> 
                <div bxe_xpath="/xhtml:{$document-element-name}/lenya:meta/dc:title" class="art-title1"> 
                  <xsl:apply-templates select="$content/lenya:meta/dc:title"/>
                </div>
                <div bxe_xpath="/xhtml:{$document-element-name}/lenya:meta/dc:description"  class="art-lead">
                  <xsl:apply-templates select="$content/lenya:meta/dc:description"/>
                </div>
                <div bxe_xpath="/xhtml:html/lenya:meta/dc:creator">
                  <xsl:apply-templates select="$content/lenya:meta/dc:creator"/>
                </div>
                <div bxe_xpath="/xhtml:{$document-element-name}/xhtml:body">
                  <xsl:apply-templates select="$content/xhtml:body/node()"/>
                </div>
              </td>

           </tr>
           <xsl:call-template name="footer"/>
          </table>
        </div>
      </body>
    </html>
  </xsl:template>
  

<xsl:template match="@*|node()" priority="-1">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>

