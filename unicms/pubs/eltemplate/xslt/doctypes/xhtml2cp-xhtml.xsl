<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: xhtml2cp-xhtml.xsl,v 1.2 2005/03/08 14:42:43 thomas Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:elt="http://www.unizh.ch/elt/1.0"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  exclude-result-prefixes="xhtml lenya dc unizh"
  >
  
  <xsl:import href="variables.xsl"/>
  
  <xsl:param name="root"/> 
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


  <xsl:template match="/site">
    <site>
      <xsl:apply-templates/>
    </site>
  </xsl:template>
  
  <xsl:variable name="popup-window">
    <xsl:choose>
      <xsl:when test="starts-with($documentid, '/Gesetzestexte')">true</xsl:when>
	  <xsl:otherwise>false</xsl:otherwise>
	</xsl:choose>
  </xsl:variable>
 
  <xsl:template match="/site/pages/page/xhtml:html">
    <xsl:choose>
      <xsl:when test="$popup-window = 'true'">
        <xsl:call-template name="popup-window"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="main-window"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="main-window">
    <html>
        
      <head>
        <title>
          <xsl:value-of select="lenya:meta/dc:title"/>
        </title>
        <xsl:call-template name="include-css"/>
        <xsl:call-template name="meta-headers"/>
        <xsl:call-template name="include-js"/>
      </head>
        
      <body>
        <div align="center" class="cmsbody">
          <a name="top"/>

          <table cellspacing="0" cellpadding="0" border="0" width="1000">
            <tr>
              <td colspan="2">
                <xsl:call-template name="header"/>
              </td>
            </tr>			
            <tr id="body">
              <td id="navigation" valign="top" with="250">
                was:menu
              </td>
              <td valign="top" width="750">
                <table border="0" width="750">
                  <tr>
                    <td width="500">
                      <div class="content">
                        <xsl:apply-templates select="lenya:meta/dc:title"/>
                        <xsl:apply-templates select="xhtml:body"/>
                      </div>
                    </td>
                    <td valign="top" width="250">
                      <div id="notesDiv"/>
                    </td>
                  </tr>
                </table>
              </td>   
            </tr>
            <tr>
              <td valign="top">was: menu
              </td>
              <td class="footer" valign="top">
                <div id="footer">
                  <xsl:apply-templates select="elt:lernpfad"/>
                  <xsl:call-template name="footer"/>
                </div>
              </td>
            </tr>
          </table>
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template name="popup-window">
    <html>
        
      <xsl:call-template name="html-head"/>
 
      <body>
        <div>
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="$area = 'live'">popuplive</xsl:when>
              <xsl:otherwise>popupauthoring</xsl:otherwise>	
            </xsl:choose>
          </xsl:attribute>
          <xsl:apply-templates select="lenya:meta/dc:title"/>
          <xsl:apply-templates select="xhtml:body"/>
        </div>
      </body>
    </html>
  </xsl:template>
   
  
  <xsl:template match="xhtml:body">
	<xsl:apply-templates select="xhtml:div[@id = 'pulldownmenu']"/>
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

 
  <xsl:template match="xhtml:div[@class = 'note']">
    <div class="note" id="{@id}">
      <div> 
        <p><xsl:apply-templates/></p>
	  </div>
    </div>

  </xsl:template>
  
  <xsl:template match="xhtml:a[@class = 'note']">
	<a href="javascript:toggleLayer('{@href}','visible')" onMouseOver="toggleLayer('{@href}','visible')" onMouseOut="toggleLayer('{@href}','hidden')"><xsl:value-of select="."/></a>
  </xsl:template>


  <xsl:template match="xhtml:a[@class = 'popup']">
    <xsl:choose>
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
