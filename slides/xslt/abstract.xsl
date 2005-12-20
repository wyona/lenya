<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet
	version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:s="http://www.oscom.org/2002/SlideML/0.9/"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<xsl:output method="html" encoding="iso-8859-1"
		doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"/>
 
<!-- Copyright by OSCOM, Author: Roger Fischer -->	

<xsl:template match="/">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<xsl:comment>Abstract Template, Copyright by OSCOM, Author: Roger Fischer</xsl:comment>	
	<title>Abstracts</title>
	<!-- uri's maybe to change by Eric -->
	<xsl:comment>uri's maybe to change by Eric</xsl:comment>
	<link rel="stylesheet" href="site.css" />
	<script type="text/javascript" src="script.js"></script>
	<meta name = "DC.Title"   content = "{normalize-space(s:slideset/s:metadata/s:title)}"/>
	
	<xsl:choose>
		<xsl:when test="s:slideset/s:metadata/s:authorgroup">
			<xsl:element name="meta">
			<xsl:attribute name="name">DC.Creator</xsl:attribute>
			<xsl:attribute name="content"> 
				<xsl:for-each select="s:slideset/s:metadata/s:authorgroup/s:author">
 					<xsl:choose>
						<xsl:when test="position() = last()">
							<xsl:value-of select="normalize-space(./text())"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="normalize-space(current()/text())"/>
							<xsl:text>, </xsl:text> 
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:attribute>
			</xsl:element>
		</xsl:when>
		<xsl:otherwise>
		<meta name = "DC.Creator" content = "{normalize-space(s:slideset/s:metadata/s:author/text())}"/>
		</xsl:otherwise>
	</xsl:choose>
	<meta name = "DC.Subject" content = "OSCOM, Open Source CMS, {s:slideset/s:metadata/dc:subject}"/>
	<meta name = "DC.Date" content = "{s:slideset/s:metadata/dc:date}"/>
	<meta name = "DC.Rights" content = "{s:slideset/s:metadata/dc:rights}"/>
	<meta name = "DC.Format" content = "text/html"/>
	<meta name = "DC.Language" content = "en"/>
	<meta name = "DC.Type"  content = "presentation abstract"/>
</head>

<body>
	
	<div id="top">
		<!-- filled in by Eric -->
		<xsl:comment>filled in by Eric</xsl:comment>
	</div>
	
	<div id="nav">
		<!-- filled in by Eric -->
		<xsl:comment>filled in by Eric</xsl:comment>
	</div>
 	
	<div id="contents">
	<xsl:apply-templates select="s:slideset/s:metadata"/>
	<p></p>

	</div>


 
<div id="footer">
 copyright &#169; 2002 <a href="http://www.oscom.org">oscom.org</a> | design by <a href="http://www.smokinggun.com">sg</a>
 </div>
&#160;
	
</body>
</html>
</xsl:template>

<xsl:template match="s:metadata">

<h3 xmlns="http://www.w3.org/1999/xhtml"><xsl:value-of select="s:title"/><br/>
	<xsl:if test="s:subtitle">
	<b><xsl:value-of select="s:subtitle"/></b>
	</xsl:if>	
</h3>
	
	<xsl:choose>
		<xsl:when test="s:authorgroup">
			<p 	xmlns="http://www.w3.org/1999/xhtml">
			<xsl:for-each select="s:authorgroup/s:author">
				<xsl:choose>
					<xsl:when test="s:email">
				<a href="mailto:{normalize-space(s:email)}" title="{normalize-space(./text())}">
				<xsl:value-of select="./text()"/></a><xsl:text>, </xsl:text>  
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="./text()"/><xsl:text>, </xsl:text>  
					</xsl:otherwise>
				</xsl:choose>
					<xsl:choose>
						<xsl:when test="s:orgname/@href">
							<a href="{normalize-space(s:orgname/@href)}" target="_blank" title="{normalize-space(s:orgname)}">
							<xsl:value-of select="s:orgname"/></a>
						</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="s:orgname"/>
					</xsl:otherwise>
				</xsl:choose>
				<br/>
			</xsl:for-each>
			</p>
		</xsl:when>
		<xsl:otherwise>
			<!-- only one author -->
			<p 	xmlns="http://www.w3.org/1999/xhtml">
				<xsl:choose>
					<xsl:when test="s:email">
				<a href="mailto:{normalize-space(s:author/s:email)}" title="{normalize-space(s:author/text())}">
				<xsl:value-of select="normalize-space(s:author/text())"/></a><xsl:text>, </xsl:text>  
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(s:author/text())"/><xsl:text>, </xsl:text>  
					</xsl:otherwise>
				</xsl:choose>
			<xsl:choose>
				<xsl:when test="s:author/s:orgname/@href">
					<a href="{normalize-space(s:author/s:orgname/@href)}" target="_blank" title="{normalize-space(s:author/s:orgname)}">
					<xsl:value-of select="s:author/s:orgname"/></a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="s:author/s:orgname"/>
				</xsl:otherwise>
			</xsl:choose>
			</p>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:apply-templates select="s:abstract"/>
</xsl:template>

<xsl:template match="xhtml:code | xhtml:p | xhtml:em | xhtml:strong | xhtml:br | xhtml:a | xhtml:ul | xhtml:ol | xhtml:li | xhtml:img | xhtml:table | xhtml:tr | xhtml:td">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:apply-templates/>
	</xsl:copy>
</xsl:template>

</xsl:stylesheet>