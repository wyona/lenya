<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: header.xsl,v 1.40 2005/03/09 11:11:13 peter Exp $ -->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
                xmlns="http://www.w3.org/1999/xhtml" 
                xmlns:dc="http://purl.org/dc/elements/1.1/" 
                xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" 
                xmlns:uz="http://unizh.ch" 
                xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                >
                
  <!-- includes the default CSS stylesheet -->
  <xsl:template name="include-css">
    <link rel="stylesheet" type="text/css" href="{$contextprefix}/unizh/authoring/css/main.css" media="screen"/>
    <link rel="stylesheet" type="text/css" href="{$contextprefix}/unizh/authoring/css/print.css" media="print"/>
  </xsl:template>
  
  
  <xsl:template match="uz:section[@id != /document/uz:unizh/uz:section]" mode="javascript">
    link<xsl:value-of select="position()"/> = new Image();
    link<xsl:value-of select="position()"/>.src = "<xsl:value-of select="$imageprefix"/>/ro_<xsl:value-of select="@img"/>_off<xsl:value-of select="$languagesuffix"/>.gif";
    link<xsl:value-of select="position()"/>a = new Image();
    link<xsl:value-of select="position()"/>a.src = "<xsl:value-of select="$imageprefix"/>/ro_<xsl:value-of select="@img"/>_on<xsl:value-of select="$languagesuffix"/>.gif";
  </xsl:template>
  
  
  <xsl:template match="uz:section[@id = /document/uz:unizh/uz:section]" mode="javascript">
    var currentSection = <xsl:value-of select="position()"/>;
  </xsl:template>
  
    
  <xsl:template name="include-js">
	<script language="javascript" type="text/javascript">
  <![CDATA[
<!-- 
//JavaSript Universitaet Zuerich unicms_version 030703

//antiframe
//if (top.frames.length > 0) {top.location.href = self.location;}

// Bilder laden
linkx = new Image(); linkx.src = "]]><xsl:value-of select="$imageprefix"/><![CDATA[/oliv_unipublic_s.gif"; linkxa = new Image();linkxa.src = "]]><xsl:value-of select="$imageprefix"/><![CDATA[/oliv_unipublic_w.gif";
]]><xsl:apply-templates select="$sections/uz:section" mode="javascript"/><![CDATA[

function bildwechsel (aa) {
	bildreset ();
	document.images["bild" + aa].src = eval("link" + aa + "a.src");
}

function bildreset () {
	if(document.images["bildx"]) document.images["bildx"].src = linkx.src;
	for (i = 1; i < 8; i++) {
	  if (i != currentSection) {
		  document.images["bild" + i].src = eval("link" + i + ".src");
		}
	}
}
-->
]]>
	</script>
  </xsl:template>


  <!-- includes meta headers -->
  <xsl:template name="meta-headers">
    <meta name="keywords" content="{$content/lenya:meta/dc:subject}"/>
    <meta name="description" content="{$content/lenya:meta/dc:description}"/>
  </xsl:template>

  <xsl:template name="language-link">  
    <xsl:choose>
      <xsl:when test="$language='en'">
        <xsl:choose>
          <xsl:when test="contains($languages,'de')">      
            <a>
              <!-- FIXME: This only works with a very specific DocumentToPathMapper -->
              <xsl:attribute name="href"><xsl:value-of select="$nodeid"/>.html</xsl:attribute>
              <img src="{$imageprefix}/oliv_de.gif" alt="Deutsch" align="top" border="0" />
            </a>
          </xsl:when>
          <xsl:otherwise>
            <img src="{$imageprefix}/oliv_de_inactive.gif" alt="Deutsch" align="top" border="0" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="contains($languages,'en')">
            <a>
              <!-- FIXME: This only works with a very specific DocumentToPathMapper -->
              <xsl:attribute name="href"><xsl:value-of select="$nodeid"/>_en.html</xsl:attribute>
              <img src="{$imageprefix}/oliv_en.gif" alt="English" align="top" border="0" />
            </a>
          </xsl:when>
          <xsl:otherwise>
            <img src="{$imageprefix}/oliv_en_inactive.gif" alt="English" align="top" border="0" />
          </xsl:otherwise> 
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="topnavbar">
    
    <xsl:param name="printview" select="'true'"/> <!-- true | false -->
    <xsl:param name="type" select="'wide'"/> <!-- wide | narrow -->
    
    <xsl:variable name="width">
      <xsl:choose>
        <xsl:when test="$type = 'wide'">800</xsl:when>
        <xsl:when test="$type = 'narrow'">585</xsl:when>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="column-3">
      <xsl:choose>
        <xsl:when test="$type = 'wide'">394</xsl:when>
        <xsl:when test="$type = 'narrow'">350</xsl:when>
      </xsl:choose>
    </xsl:variable>
      
    <xsl:variable name="column-1" select="40"/>
    <xsl:variable name="column-2" select="150"/>
    <xsl:variable name="column-4" select="$width - $column-1 - $column-2 - $column-3"/>
    
    <tr id="topnavbar">
      <td colspan="3">
        <!-- Suchformular -->
        <form action="http://www.google.com/u/unizh" method="get" name="sa">
          <input type="hidden" name="domains" value="unizh.ch" />
          <input type="hidden" name="sitesearch" value="unizh.ch" />
          <!-- Kopftabelle -->
          <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#666699">
            <tr>
              <td bgcolor="#f5f5f5" align="left" width="{$column-1}" height="10">
                <img src="{$imageprefix}/1.gif" alt="" height="10" width="{$column-1}" border="0" />
              </td>
              <td rowspan="2" valign="top" bgcolor="#999966" width="{$column-2}">
                <a href="http://www.unipublic.unizh.ch/" onmouseover="bildwechsel('x');" onmouseout="bildreset();">
                  <img src="{$imageprefix}/oliv_unipublic_s.gif" alt="unipublic" width="{$column-2}" height="28" align="top" border="0" name="bildx" />
                </a>
              </td>
              <td valign="middle" bgcolor="#f5f5f5" align="right" width="{$column-3}" height="10">
                <img src="{$imageprefix}/1.gif" alt="" height="10" width="{$column-3}" border="0" />
              </td>
              <td bgcolor="#f5f5f5" height="10" width="{$column-4}">
                <img src="{$imageprefix}/1.gif" alt="" height="10" width="{$column-4}" border="0" />
              </td>
			  <td bgcolor="#f5f5f5" height="10" width="80%" />
            </tr>
            <tr>
              <td valign="top" bgcolor="#999966" align="left">
                <span style="white-space: nowrap">
                  <img height="17" width="3" src="{$imageprefix}/1.gif" alt=" " align="top" />
                  <a> 
                  <xsl:choose>
                     <xsl:when test="$language='en'">
                      <xsl:attribute name="href">http://www.unizh.ch/index.en.html</xsl:attribute>
                     </xsl:when>
                     <xsl:otherwise>
                      <xsl:attribute name="href">http://www.unizh.ch/index.html</xsl:attribute>                         
                     </xsl:otherwise>
                   </xsl:choose>
                    <img src="{$imageprefix}/oliv_home.gif" alt="Home" align="top" border="0" height="17" width="31" />
                  </a>
                  <img src="{$imageprefix}/oliv_strich.gif" alt=" " align="top" />
                </span>
              </td>
              <td bgcolor="#999966" valign="top" align="right">
                <span style="white-space: nowrap">
                  <xsl:call-template name="language-link"/>
                  <img src="{$imageprefix}/oliv_strich.gif" alt=" " align="top" />
                  
                  <xsl:if test="$printview = 'true'">
                    <a href="{$nodeid}{$documentlanguagesuffix}.print.html">
                      <img src="{$imageprefix}/oliv_print.gif" alt="print_view" align="top" border="0" i18n:attr="alt"/>
                    </a>
                    <img src="{$imageprefix}/oliv_strich.gif" alt=" " align="top" />
                  </xsl:if>
                  
                  <a> 
                  <xsl:choose>
                     <xsl:when test="$language='en'">
                      <xsl:attribute name="href">http://www.unizh.ch/info/adressen/kontakt.en.html</xsl:attribute>
                     </xsl:when>
                     <xsl:otherwise>
                      <xsl:attribute name="href">http://www.unizh.ch/info/adressen/kontakt.html</xsl:attribute>                         
                     </xsl:otherwise>
                   </xsl:choose>
                    <img src="{$imageprefix}/oliv_kontakt{$languagesuffix}.gif" alt="contact" align="top" border="0" i18n:attr="alt"/>
                  </a>
                  <img src="{$imageprefix}/oliv_strich.gif" alt=" " align="top" />
                  <a> 
                  <xsl:choose>
                     <xsl:when test="$language='en'">
                      <xsl:attribute name="href">http://www.search.unizh.ch/index.en.html</xsl:attribute>
                     </xsl:when>
                     <xsl:otherwise>
                      <xsl:attribute name="href">http://www.search.unizh.ch/index.html</xsl:attribute>                         
                     </xsl:otherwise>
                   </xsl:choose>
                    <img src="{$imageprefix}/oliv_suchen{$languagesuffix}.gif" alt="search" align="top" border="0" i18n:attr="alt"/>
                  </a>
                  <img height="17" width="3" src="{$imageprefix}/1.gif" alt=" " align="top" />
                  <input type="text" name="q" size="14" />
                  <img height="17" width="3" src="{$imageprefix}/1.gif" alt=" " align="top" />
                  <input src="{$imageprefix}/oliv_go.gif" type="image" align="top" name="sa2" style="border: 0px"/>
                </span>
              </td>
              <td bgcolor="#f5f5f5"><img src="{$imageprefix}/1.gif" alt=" "/></td>
              <td bgcolor="#f5f5f5" />
            </tr>
            <tr>
              <td height="50"><img src="{$imageprefix}/1.gif" alt=" "/></td>
              <td colspan="2" align="right" valign="top">
                  <a> 
                  <xsl:choose>
                     <xsl:when test="$language='en'">
                      <xsl:attribute name="href">http://www.unizh.ch/index.en.html</xsl:attribute>
                     </xsl:when>
                     <xsl:otherwise>
                      <xsl:attribute name="href">http://www.unizh.ch/index.html</xsl:attribute>                         
                     </xsl:otherwise>
                   </xsl:choose>
                  <img height="29" width="235" src="{$imageprefix}/unilogoklein{$languagesuffix}.gif" alt="university_zurich" border="0" i18n:attr="alt"/>
                </a>
              </td>
              <td><img src="{$imageprefix}/1.gif" alt=" "/></td>
            <td/>
            </tr>
            <tr bgcolor="#f5f5f5">
		<td colspan="4" bgcolor="#666666"><img src="{$imageprefix}/1.gif" alt=" " height="30"/>
                  <a href="{/document/unizh:header/unizh:title/@href}"><font color="white" size="14px">
                    <xsl:value-of select="/document/unizh:header/unizh:title"/>
                  </font></a>
                </td>
            </tr>
          </table>
          <!-- Ende Kopftabelle -->
        </form>
      </td>
    </tr>
  </xsl:template>
  
  
  <xsl:template match="uz:section[@id != /document/uz:unizh/uz:section]" mode="link">
    <a href="http://www.unizh.ch/{@id}/" onmouseover="bildwechsel({position()});" onmouseout="bildreset();">
      <img src="{$imageprefix}/ro_{@img}_off{$languagesuffix}.gif"
           alt="section_{@id}"
           border="0"
           name="bild{position()}"
           i18n:attr="alt"/>
    </a>
    <xsl:if test="position() != last()"><img src="{$imageprefix}/1.gif" alt=" " width="4" height="10" /></xsl:if>
  </xsl:template>
  
  
  <xsl:template match="uz:section[@id = /document/uz:unizh/uz:section]" mode="link">
    <a href="http://www.unizh.ch/{@id}/">
      <img src="{$imageprefix}/ro_{@img}_on{$languagesuffix}.gif"
           alt="section_{@id}"
           border="0"
           name="bild{position()}"
           i18n:attr="alt"/>
    </a>
    <xsl:if test="position() != last()"><img src="{$imageprefix}/1.gif" alt=" " width="4" height="10" /></xsl:if>
  </xsl:template>
  
</xsl:stylesheet>


