<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: xhtml-standard.xsl,v 1.22 2005/03/29 12:25:10 thomas Exp $ -->
    
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:elt="http://www.unizh.ch/elt/1.0"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  exclude-result-prefixes="xhtml lenya dc unizh"
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
  
  <xsl:param name="lastmodified"/>

  <xsl:param name="rendertype"/>

  <xsl:param name="export"/>

  <xsl:include href="../common/html-head.xsl"/>
  <xsl:include href="../common/header.xsl"/>
  <xsl:include href="../common/elements.xsl"/>
  <xsl:include href="../common/footer.xsl"/>


  <xsl:template match="document">
    <xsl:apply-templates select="content/*"/>
  </xsl:template>
  
  <xsl:variable name="enable-pdf">
    <xsl:choose>
      <xsl:when test="starts-with($documentid, '/Lektionen/Kauf/') or starts-with($documentid, '/Lernpfad/Entscheide')">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

 
  <xsl:template match="xhtml:html">
    <xsl:choose>
      <xsl:when test="$export= 'cp'">
         <xsl:call-template name="cp-export"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="standard"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="standard">
    <html> 
      <xsl:call-template name="html-head"/>
      <body>
        <div align="center" class="cmsbody">
          <a name="top"/>
          <table id="layout" cellpadding="0" cellspacing="2"  border="0" width="1000">
            <tr>
              <td colspan="2">
                <xsl:call-template name="header"/>
              </td>
            </tr>			
            <tr id="body">
              <td id="navigation" valign="top" with="233">
                <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
                <br/>&#160;
              </td>
              <td valign="top" width="767">
                <table border="0" width="767">
                  <tr>
                    <td width="1" height="350"><img src="{$imageprefix}/1.gif" width="1" height="350"/></td>
                    <td width="516" valign="top">
                      <div class="content">
                        <xsl:apply-templates select="$content/lenya:meta/dc:title"/>
                        <div bxe_xpath="/xhtml:{$document-element-name}/xhtml:body">
                          <xsl:apply-templates select="xhtml:body"/>
		          <xsl:if test="$enable-pdf = 'true'">
                            <div align="right">
                              <a href="{$nodeid}_de.pdf">Download PDF <img src="images/pdf.gif" alt="Download als PDF" border="0"/></a>
                            </div>
                          </xsl:if>
                          <xsl:apply-templates select="$content/elt:footnotes"/>
                        </div>
                        <xsl:if test="//elt:footnotes">
                          <div bxe_xpath="/xhtml:{$document-element-name}/elt:footnotes" class="footnotes"/>
                        </xsl:if>
                      </div>
                    </td>
                    <td valign="top" width="250">
                      <div id="tooltips"/>
                    </td>
                  </tr>
                </table>
              </td>   
            </tr>
            <tr>
              <td valign="top" class="infomenuindex">
                <xsl:value-of select="/document/xhtml:div[@id = 'infomenu']/@title"/>
              </td>
              <td class="footer" valign="top">
                <xsl:if test="//elt:lernpfad">
	          <div bxe_xpath="/xhtml:{$document-element-name}/elt:lernpfad" class="lernpfad">
                    <xsl:apply-templates select="$content/elt:lernpfad"/>
                  </div>
                </xsl:if>
                <xsl:call-template name="footer"/>
              </td>
            </tr>
            <tr>
              <td>
                <div class="hideme">
                  <xsl:apply-templates select="$content/elt:footnotes/elt:footnote[@rendertype = 'tooltip']"/>
                </div>
              </td>
            </tr>
          </table>
        </div>
      </body>
    </html>
  </xsl:template>
  
  
  <xsl:template name="cp-export">
    <html>
      <xsl:call-template name="html-head"/>
      <body>
        <div align="center" class="cmsbody">
          <a name="top"/>
          <table cellspacing="" cellpadding="0" border="0" width="750">
            <tr>
              <td>
                <xsl:call-template name="cp-header"/>
              </td>
            </tr>
            <tr id="body">
              <td valign="top" width="750">
                <table border="0" width="750" height="320">
                  <tr>
                    <td width="1" height="350"><img src="{$imageprefix}/1.gif" width="1" height="350"/></td>
                    <td width="500" valign="top">
                      <div class="content">
                        <xsl:apply-templates select="$content/lenya:meta/dc:title"/>
                        <xsl:apply-templates select="xhtml:body"/>
                        <xsl:apply-templates select="$content/elt:footnotes"/>
                      </div>
                    </td>
                    <td valign="top" width="250">
                      <div id="tooltips"/>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr>
              <td class="footer" valign="top">
                <div id="footer">
                  <xsl:apply-templates select="$content/elt:lernpfad"/>
                  <xsl:call-template name="footer"/>
                </div>
              </td>
            </tr>
            <tr>
              <td>
                <div class="hideme">
                  <xsl:apply-templates select="$content/elt:footnotes/elt:footnote[@rendertype = 'tooltip']"/>
                </div>
              </td>
            </tr>
          </table>
        </div>
      </body>
    </html>
  </xsl:template>

  
  <xsl:template match="xhtml:body">
    <xsl:apply-templates select="/document/xhtml:div[@id = 'pulldownmenu']"/>
    <xsl:apply-templates/>
  </xsl:template>
  
 
  <xsl:template match="elt:lernpfad">
    <xsl:for-each select="xhtml:a">
      <xsl:apply-templates select="self::*"/>
      <xsl:if test="position() != last()">
        &#160;|&#160;
      </xsl:if>
    </xsl:for-each>
    <br/>
    <br/>
  </xsl:template>


  <xsl:template match="elt:footnotes">
    <xsl:if test="elt:footnote[@rendertype = 'footnote']"><hr/></xsl:if>
    <xsl:for-each select="elt:footnote[@rendertype = 'footnote']">
      <span class="footnote-text">
        <sup><xsl:value-of select="position()"/></sup>
        &#160;<xsl:apply-templates/>
      </span><br/>
    </xsl:for-each>
  </xsl:template>
 

  <xsl:template match="elt:footnote[@rendertype = 'tooltip']">
    <div class="tooltip" id="{@id}">
      <div> 
        <p><xsl:apply-templates/></p>
      </div>
    </div>
  </xsl:template>

 
  <xsl:template match="elt:footnote-reference">
    <xsl:variable name="idref"><xsl:value-of select="@idref"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="//elt:footnote[@id = $idref and @rendertype='footnote']">
        <xsl:value-of select="."/>
        <xsl:for-each select="//elt:footnote[@rendertype = 'footnote']">
          <xsl:if test="@id = $idref"><sup><xsl:value-of select="position()"/></sup></xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
	<a href="#" onClick="toggleLayer('{@idref}','visible')" onMouseOver="toggleLayer('{@idref}','visible')" onMouseOut="toggleLayer('{@idref}','hidden')"><xsl:value-of select="."/></a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="xhtml:a[@target = 'popup']">
  
    <xsl:choose>
      <xsl:when test="$export = 'cp'">
        <a href="{@href}?olatraw=true" target="_blank" onClick="window.open(this.href, 'popup', 'width=450,height=450'); return false">
          <xsl:value-of select="."/>
        </a>
      </xsl:when>
      <xsl:when test="$area = 'live'">
        <a href="{@href}" target="_blank" onClick="window.open(this.href, 'popup', 'width=450,height=450'); return false">
          <xsl:value-of select="."/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a href="{@href}"><xsl:value-of select="."/></a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>  
  
<xsl:template match="@*|node()" priority="-1">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
