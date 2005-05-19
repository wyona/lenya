<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../../../../../xslt/search/search-and-results.xsl"/>

<xsl:param name="unizh.pubId" select="'roger'"/>
<xsl:param name="context-prefix"/>
<xsl:param name="area"/>

<xsl:variable name="areaRootPath" select="concat($context-prefix, '/', $unizh.pubId, '/', $area)"/>

<xsl:template match="/">
<html>
<head>
<meta name="generator" content="HTML Tidy, see www.w3.org" />
<meta http-equiv="content-type"
content="text/html;charset=iso-8859-1" />
<title>Universit&#228;t Z&#252;rich - Suchen</title>
<link type="text/css" href="{$context-prefix}/unizh/{$area}/css/main.css" rel="stylesheet" media="screen" />
<script language="JavaScript" src="css/script.js"
type="text/javascript">
</script>

<script language="javascript" type="text/javascript">
<!--
 link3.src = "{$areaRootPath}/images/ro_dl_on.gif"        //Bildquelle der aktiven Rubrik festlegen
// -->
</script>
</head>
<body>
<div align="center"><a id="top" name="top"></a> 

<p><!-- Haupttabelle -->
</p>

<table cellspacing="0" cellpadding="0" border="0" width="600">
<tr>
<td colspan="2" width="800"><!-- Suchformular -->
<form action="http://www.google.com/u/unizh" method="get" name="sa">
<input type="hidden" name="domains" value="unizh.ch" />
<input type="hidden" name="sitesearch" value="unizh.ch" /> 
<!-- Kopftabelle -->
 

<table width="100%" border="0" cellspacing="0" cellpadding="0"
bgcolor="#666699">
<tr>
<td bgcolor="#f5f5f5" align="left" width="40" height="10"><img
src="{$areaRootPath}/images/1.gif" alt="" height="10" width="41"
border="0" /></td>
<td rowspan="2" valign="top" bgcolor="#999966" width="150"><a
href="http://www.unipublic.unizh.ch/"
onmouseover="bildwechsel('x');" onmouseout="bildreset();"><img
src="{$areaRootPath}/images/oliv_unipublic_s.gif" alt="unipublic" width="150"
height="28" align="top" border="0" name="bildx" /></a></td>
<td valign="middle" bgcolor="#f5f5f5" align="right" width="394"
height="10"><img src="{$areaRootPath}/images/1.gif" alt="" height="10"
width="394" border="0" /></td>
<td bgcolor="#f5f5f5" height="10"><img src="{$areaRootPath}/images/1.gif" alt=""
height="10" width="195" border="0" /></td>
</tr>

<tr>
<td valign="top" bgcolor="#999966" align="left" width="40">
<nobr><img height="17" width="3" src="{$areaRootPath}images/1.gif" alt=" "
align="top" /><a href="http://www.unizh.ch/index.html"><img
src="{$areaRootPath}/images/oliv_home.gif" alt="Home" align="top" border="0"
height="17" width="31" /></a><img src="{$areaRootPath}/images/oliv_strich.gif"
alt="|" align="top" /></nobr></td>
<td bgcolor="#999966" valign="top" align="right" width="394">
<nobr><a
href='../../ssi_services/%3c!--#echo var="translation"--&gt;'><img
src="{$areaRootPath}/images/oliv_en.gif" alt="Index" align="top" border="0" />
</a><img src="{$areaRootPath}/images/oliv_strich.gif" alt="|" align="top" /><a
href="3cols/print.html"><img src="{$areaRootPath}/images/oliv_print.gif"
alt="Printview" align="top" border="0" /></a><img
src="{$areaRootPath}/images/oliv_strich.gif" alt="|" align="top" /><a
href="http://www.unizh.ch/info/adressen/kontakt.html"><img
src="{$areaRootPath}/images/oliv_kontakt.gif" alt="Kontakt" align="top"
border="0" /></a><img src="{$areaRootPath}/images/oliv_strich.gif" alt="|"
align="top" /><a href="http://www.search.unizh.ch/index.html"><img
src="{$areaRootPath}/images/oliv_suchen.gif" alt="Suchen" align="top"
border="0" /></a><img height="17" width="3" src="{$areaRootPath}/images/1.gif"
alt=" " align="top" /><input type="text" name="q" size="14" /><img
height="17" width="3" src="{$areaRootPath}/images/1.gif" alt=" "
align="top" /><input src="{$areaRootPath}/images/oliv_go.gif" type="image"
align="top" border="0" name="sa2" /></nobr></td>
<td bgcolor="#f5f5f5">&#160;</td>
</tr>

<tr>
<td width="40" height="50">&#160;</td>
<td colspan="2" align="right" width="544" height="50" valign="top">
<a href="http://www.unizh.ch/index.html"><img height="29"
width="235" src="{$areaRootPath}/images/unilogoklein.gif"
alt="Universit&#228;t Z&#252;rich" border="0" /></a></td>
<td height="50">&#160;</td>
</tr>
</table>

<!-- Ende Kopftabelle -->
</form>
</td>
</tr>

<tr>
<td class="navon" colspan="2" width="800"><br />
 &#160;<a href="http://www.unizh.ch/">Uni Z&#252;rich</a> &gt;
Suchen</td>
</tr>

<tr>
<td width="187" height="40"><img height="40" width="187"
src="{$areaRootPath}/images/1.gif" alt=" " /></td>
<td width="613" height="40"><img height="40" width="613"
src="{$areaRootPath}/images/1.gif" alt=" " /></td>
</tr>

<tr><!-- Erste Spalte -->
<td valign="top" width="187"><!-- Anfang Navigationstabelle -->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="publtitelcel">
<div class="publtitel"><a href="index.html"><span
class="publtitel"><span
class="publtitelcolor">SUCHEN</span></span></a></div>
</td>
</tr>

<tr>
<td class="navoff">&#160;</td>
</tr>

<tr>
<td class="navon">
<div class="nlevel1">Internetsuche</div>
</td>
</tr>

<tr>
<td class="navoff">
<div class="nlevel1"><a
href="(EmptyReference!)">Notf&#228;lle/St&#246;rungen
Universit&#228;t Z&#252;rich</a></div>
</td>
</tr>

<tr>
<td class="navoff">
<div class="nlevel1"><a
href="/services/search/opt_2.php?suche=">Telefonbuch der
Universit&#228;t Z&#252;rich</a></div>
</td>
</tr>

<tr>
<td class="navoff">
<div class="nlevel1"><a href="(EmptyReference!)">Telefonbuch der
ETH Z&#252;rich</a></div>
</td>
</tr>

<tr>
<td class="navoff">
<div class="nlevel1"><a
href="(EmptyReference!)">tel.search.ch</a></div>
</td>
</tr>

<tr>
<td class="navoff">
<div class="nlevel1"><a href="(EmptyReference!)">Weisse Seiten
(CH)</a></div>
</td>
</tr>

<tr>
<td class="navoff">
<div class="nlevel1"><a href="(EmptyReference!)">Gelbe Seiten
(CH)</a></div>
</td>
</tr>
</table>

<!-- Ende Navigationstabelle --></td>
<!-- Zweite Spalte -->
<td class="content2cols" width="613">
<h1>Internetsuche</h1>

<form>
<table border="0" cellspacing="0" cellpadding="1" width="100%">


<tr>
<td class="formtable" colspan="3" width="314">
<input type="text" name="queryString" size="50" maxlength="255" value="{/search-and-results/search/query-string}" class="monospace" />
</td>
<td class="formtable"><input type="submit" name="sa" value="Suchen" /><xsl:text>&#160;&#160;</xsl:text>


<!-- Choose between SIMPLE and ADVANCED search -->
<xsl:choose>
<xsl:when test="/search-and-results/search/request-parameters/unizh.type">
<a href="lucene?queryString={/search-and-results/search/query-string}&amp;publication-id={$unizh.pubId}&amp;{$unizh.pubId}.fields.contents">weniger Optionen</a>
<input type="hidden" name="unizh.type" value="advanced" />
</xsl:when>
<xsl:otherwise>
<a href="lucene?unizh.type=advanced&amp;queryString={/search-and-results/search/query-string}&amp;publication-id={$unizh.pubId}&amp;dummy-index-id.fields=contents">mehr Optionen</a>
<input type="hidden" name="publication-id" value="{$unizh.pubId}" />
<input type="hidden" name="{$unizh.pubId}.fields" value="contents" />
</xsl:otherwise>
</xsl:choose>
</td>
</tr>


<xsl:if test="/search-and-results/search/request-parameters/unizh.type">
<tr>
<td class="formtable" valign="top" width="90">Suchen in:</td>
<td class="formtable" valign="top" width="100">
  <select name="dummy-index-id.fields">
    <option value="contents">
      <xsl:if test="/search-and-results/search/fields/field[1]='contents'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      Volltext
    </option>
    <option value="title">
      <xsl:if test="/search-and-results/search/fields/field[1]='title'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      Titel
    </option>
    <option value="keywords">
      <xsl:if test="/search-and-results/search/fields/field[1]='keywords'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      Keywords
    </option>
  </select>

<!--
 <input type="checkbox" name="dummy-index-id.fields.contents" checked="checked" /> Text<br />
 <input type="checkbox" name="dummy-index-id.fields.title" checked="checked" /> Titel<br />
 <input type="checkbox" name="dummy-index-id.fields.keywords" checked="checked" /> Keywords
-->
</td>
<td class="formtable" align="right" valign="top" width="120">
Suchbereich:&#160;
</td>
<td class="formtable" valign="top">
 <input type="radio" name="publication-id" value="unizh"><xsl:if test="/search-and-results/search/publication-id = 'unizh'"><xsl:attribute name="checked">true</xsl:attribute></xsl:if></input>www.unizh.ch<br />
 <!-- FIXME: default should be the publication specific radio turned on -->
 <input type="radio" name="publication-id" value="{$unizh.pubId}"><xsl:if test="/search-and-results/search/publication-id = $unizh.pubId"><xsl:attribute name="checked">true</xsl:attribute></xsl:if></input>www.<xsl:value-of select="$unizh.pubId"/>.unizh.ch<br />
<!--
 <input type="radio" name="publication-id" value="{$unizh.pubId}"><xsl:if test="not(/search-and-results/search/publication-id)"><xsl:attribute name="checked">true</xsl:attribute></xsl:if></input>www.<xsl:value-of select="$unizh.pubId"/>.unizh.ch<br />
-->
<!--
 <input type="radio" name="publication-id" value="{$unizh.pubId}"><xsl:if test="/search-and-results/search/publication-id = $unizh.pubId | not(/search-and-results/search/publication-id)"><xsl:attribute name="checked">true</xsl:attribute></xsl:if></input>www.<xsl:value-of select="$unizh.pubId"/>.unizh.ch<br />
-->


<!--
 <input type="radio" name="sitesearch" value="folder" />
 <input type="text" name="range" size="26" maxlength="255" value="/ordnername" class="monospace" />
-->
</td>
</tr>
</xsl:if>
</table>


</form>

<xsl:apply-templates select="/search-and-results/search/exception"/>

<p>
<xsl:apply-templates select="/search-and-results/results"/>
</p>


</td>
<!-- Dritte Spalte --></tr>

<tr>
<td width="187"></td>
<!-- Fusszeile -->
<td class="footer" width="613"><br />
 <img height="1" width="587" src="{$areaRootPath}/images/999999.gif"
alt=" " /><br />
 &#169; Universit&#228;t Z&#252;rich, 
<!--#config timefmt="%d.%m.%Y"--><!--#echo var="LAST_MODIFIED"-->,
<a href="/impressum.html" target="_blank">Impressum</a></td>
</tr>
</table>
</div>
</body>
</html>
</xsl:template>



<xsl:template match="results">
  <h2>Suchresultate f&#252;r '<xsl:value-of select="../search/publication-name"/>'</h2>
  <xsl:choose>
    <xsl:when test="hits">
<p>
  <xsl:value-of select="pages/page[@type='current']/@start"/> - <xsl:value-of select="pages/page[@type='current']/@end"/> von <xsl:value-of select="@total-hits"/> Resultaten
</p>

<ul class="type2">
      <xsl:apply-templates select="hits/hit"/>
</ul>
    </xsl:when>
    <xsl:otherwise>
      <p>Sorry, <b>nothing</b> found!</p>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="pages"/>
</xsl:template>


<xsl:template match="hit">
  <xsl:choose>
    <xsl:when test="path">
      <li>File: <xsl:value-of select="path"/></li>
    </xsl:when>
    <xsl:when test="uri">
<li><xsl:if test="mime-type = 'application/pdf'">[PDF] </xsl:if>
<a><xsl:attribute name="href"><xsl:value-of select="/search-and-results/search/publication-prefix"/><xsl:value-of select="normalize-space(uri)"/></xsl:attribute><xsl:apply-templates select="title"/></a><xsl:apply-templates select="no-title"/><br />
<span class="searchresult">
<xsl:apply-templates select="excerpt"/><xsl:apply-templates select="no-excerpt"/><br />
<a><xsl:attribute name="href"><xsl:value-of select="/search-and-results/search/publication-prefix"/><xsl:value-of select="normalize-space(uri)"/></xsl:attribute><xsl:value-of select="/search-and-results/search/publication-prefix"/><xsl:apply-templates select="uri"/></a>
<br /><br />
</span>
</li>
    </xsl:when>
    <xsl:otherwise>
      <li>Neither PATH nor URL</li>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template match="pages">
<p>
Resultatseiten
<xsl:apply-templates select="page[@type='previous']" mode="previous"/>
<xsl:for-each select="page">
  <xsl:choose>
    <xsl:when test="@type='current'">
      <xsl:value-of select="position()"/>
    </xsl:when>
    <xsl:otherwise>
      <a href="{$uriName}?publication-id={../../../search/publication-id}&amp;queryString={../../../search/query-string}&amp;sortBy={../../../search/sort-by}&amp;start={@start}&amp;end={@end}"><xsl:value-of select="position()"/></a>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text> </xsl:text>
</xsl:for-each>
<xsl:apply-templates select="page[@type='next']" mode="next"/>
</p>
</xsl:template>

</xsl:stylesheet>
