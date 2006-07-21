<?xml version="1.0" encoding="iso-8859-1"?>
	<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="iso-8859-1" />

<xsl:template match="/">
<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
		<title>Universität Zürich</title>
		<script language="JavaScript"><!--
//antiframe
if (top.frames.length > 0) {top.location.href = self.location;}

// CSS Triage

if (navigator.appVersion.indexOf ('Win') >= 0) {
   seite = 'http://www.unizh.ch/css_uni/win.css';
   document.write('<link rel="stylesheet" type="text/css" href="'+seite+'">');
}
// -->
		</script>
		<link rel="stylesheet" type="text/css" href="http://www.unizh.ch/css_uni/mac.css" />
	<link rel="stylesheet" type="text/css" href="http://www.unizh.ch/news/rss/css/rss.css" />		
</head>

<body background="img/bg.gif" bgcolor="#f5f5f5">
			<!--START head.html-->
<meta http-equiv="content-type" content="text/html;charset=iso-8859-1" />
<div align="center">
	<form action="http://www.unizh.ch/cgi-bin/unisearch" method="post">
		<input type="hidden" value="www.unipublic.unizh.ch" name="url" />
			<table width="585" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="middle" bgcolor="#999966" width="142"><img src="http://www.unizh.ch/img_uni/spacer.gif" alt=" " width="3" height="20" border="0" /><a href="http://www.unizh.ch/"><img src="http://www.unizh.ch/img_uni/oliv_home.gif" alt="Home" border="0" height="17" width="31" /></a></td>
					<td colspan="2" align="right" valign="middle" bgcolor="#999966" width="410"> <a href="http://www.unizh.ch/news/agenda/ssi/impressum.php"><img src="http://www.unizh.ch/img_uni/oliv_kontakt.gif" alt="Kontakt" border="0" height="17" width="41" align="middle" /></a><img src="/img_uni/oliv_strich.gif" alt="|" height="17" width="7" align="middle" /><img src="http://www.unizh.ch/img_uni/oliv_unipublic_suchen.gif" alt="Suchen" height="17" width="79" align="middle" /><input type="text" name="keywords" size="18" /> <img src="http://www.unizh.ch/img_uni/oliv_go.gif" type="image" border="0" name="search4" align="middle" height="17" width="28" /></td>

					<td valign="middle" bgcolor="#f5f5f5" width="57"> </td>
				</tr>
				<tr>
					<td bgcolor="#666699" width="142"><img src="http://www.unizh.ch/news/img_unipublic/spacer.gif" alt=" " width="10" height="39" border="0" /></td>
					<td valign="bottom" bgcolor="#666699" width="96"></td>
					<td align="right" valign="top" bgcolor="#666699" width="290"><a href="http://www.unizh.ch/"><img src="http://www.unizh.ch/img_uni/unilogoklein.gif" alt="Universität Zürich" width="235" height="29" border="0" /></a></td>
					<td bgcolor="#666699" width="57"></td>
				</tr>
				<tr>
					<td width="142"></td>
					<td valign="top" width="96"></td>
					<td width="290"></td>
					<td width="57"></td>
				</tr>
			</table>
		</form>
</div>
	<!--ENDE head.html-->
<center>
		<table width="585" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
				<td bgcolor="white" align="left" height="39"><img src="http://www.unizh.ch/news/img_unipublic/spacer.gif" alt=" " width="10" height="39" border="0" /></td></tr>
			<tr valign="top">
				<td bgcolor="white" align="left" height="20"><h2>
				
				<xsl:apply-templates select="rss/channel" />
				</h2></td></tr>
			<tr valign="top">
				<td bgcolor="white" class="lauftext"><span class="boldtext">Hinweis:</span> Dies ist eine browserunterstützte Anzeige des RSS-Feeds. Wenn Sie den Feed in einem Feed-Reader anzeigen lassen wollen, kopieren Sie die Adresse im Adressfeld des Browsers in Ihren Feed-Reader.<br /><br /><hr size="1" />
				</td>
			</tr>
			<tr valign="top">
				<td bgcolor="white" align="left">
				<xsl:apply-templates select="rss/channel/item" />
		</td>
	</tr>
</table>
</center>
 </body></html>

</xsl:template>

<xsl:template match="rss/channel">
<a><xsl:attribute name="href"><xsl:value-of select="link" /></xsl:attribute>
 	<xsl:value-of select="title" /></a>
</xsl:template>


<xsl:template match="item">
	<p>
   <xsl:apply-templates />
 </p>
</xsl:template>

<xsl:template match="item">
  <div><a><xsl:attribute name="href"><xsl:value-of select="link" /></xsl:attribute>
 	<xsl:value-of select="title" />
 </a></div>
 <xsl:apply-templates select="description" />
</xsl:template>

<xsl:template match="description">
<div class="lauftext"><xsl:value-of select="." /></div>
<hr size="1" />
<br />
</xsl:template>

<xsl:template match="pubDate">
</xsl:template>

</xsl:stylesheet>