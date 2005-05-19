<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns="http://www.w3.org/1999/xhtml"
      xmlns:xhtml="http://www.w3.org/1999/xhtml"
      xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
      xmlns:dc="http://purl.org/dc/elements/1.1/"
      xmlns:dcterms="http://purl.org/dc/terms/"
      xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
      xmlns:up="http://www.unipublic.unizh.ch/2002/up" 
      dc:dummy="FIXME:keepNamespace" dcterms:dummy="FIXME:keepNamespace"
      lenya:dummy="FIXME:keepNamespace" xhtml:dummy="FIXME:keepNamespace"> 

<xsl:param name="resourcePath"/>

<xsl:template match="NewsML">
  <html>

    <lenya:meta>
      <dc:title>
        <xsl:value-of select="NewsItem/NewsComponent/ContentItem/DataContent/nitf/body/body.head/hedline/hl1/."/>
      </dc:title>
      <dc:description>
        <xsl:value-of select="NewsItem/NewsComponent/ContentItem/DataContent/nitf/body/body.head/abstract/."/>
      </dc:description>
      <dc:subject>
        <xsl:value-of select="NewsItem/NewsComponent/ContentItem/DataContent/nitf/body/body.head/spitzmarke/."/>
      </dc:subject>
      <dc:creator>
        <xsl:value-of select="NewsItem/NewsComponent/ContentItem/DataContent/nitf/body/body.head/byline/."/>
      </dc:creator>
      <dc:publisher>Universit??t Z??rich</dc:publisher>
      <dcterms:created>
        <!--Article of old system has no creation date-->   
      </dcterms:created>
      <dcterms:dateCopyrighted>
        <xsl:value-of select="NewsItem/NewsManagement/RevisionDate/@year"/><xsl:text>-</xsl:text>
        <xsl:value-of select="NewsItem/NewsManagement/RevisionDate/@month"/><xsl:text>-</xsl:text>
        <xsl:value-of select="NewsItem/NewsManagement/RevisionDate/@day"/>
      </dcterms:dateCopyrighted>
      <dcterms:issued>
        <xsl:value-of select="NewsItem/NewsComponent/ContentItem/DataContent/nitf/body/body.head/dateline/story.date/@norm"/>
      </dcterms:issued>
      <dcterms:isReferencedBy>
        <xsl:if test="NewsItem/NewsComponent/ContentItem/DataContent/nitf/body/body.head/dossier/@id">
          <xsl:text>/dossiers/</xsl:text><xsl:value-of select="NewsItem/NewsComponent/ContentItem/DataContent/nitf/body/body.head/dossier/@id"/>
        </xsl:if>  
      </dcterms:isReferencedBy>
      <dc:language>de</dc:language>
      <dc:rights>Universit??t Z??rich</dc:rights>
      <dcterms:hasVersion>
        <xsl:value-of select="NewsItem/Identification/NewsIdentifier/RevisionId/."/>
      </dcterms:hasVersion>
    </lenya:meta>
    <up:related-contents  xmlns:up="http://www.unipublic.unizh.ch/2002/up">
      <xsl:apply-templates select="NewsItem/NewsComponent/ContentItem/DataContent/related-content/block" mode="RelatedContent"/>
    </up:related-contents>
    <xsl:call-template name="teaser"/>
    <body>
      <xsl:apply-templates select="NewsItem/NewsComponent/ContentItem/DataContent/nitf"/>
    </body>
  </html>  
</xsl:template>

<xsl:template name="teaser">
  <up:teaser xmlns:up="http://www.unipublic.unizh.ch/2002/up">
    <xsl:apply-templates select = "NewsItem/NewsComponent/ContentItem/DataContent/nitf/body/body.head/media"/>
    <div class="tsr-text"><xsl:value-of select="NewsItem/NewsComponent/ContentItem/DataContent/nitf/body/body.head/teasertext" /></div>
  </up:teaser>
</xsl:template>

<xsl:template match="block" mode="RelatedContent">
  <up:related-content  xmlns:up="http://www.unipublic.unizh.ch/2002/up">
    <up:title xmlns:up="http://www.unipublic.unizh.ch/2002/up"><xsl:value-of select="title"/></up:title>
    <xsl:apply-templates select="item" mode="RelatedContent"/>
  </up:related-content>
</xsl:template>

<xsl:template match="item" mode="RelatedContent">
  <up:link>
    <xsl:apply-templates/>
  </up:link>
</xsl:template>

<xsl:template match="ulink">
  <a href="{@url}"><xsl:apply-templates/></a>
</xsl:template>

<xsl:template match="nitf">
  <xsl:apply-templates select="head"/>   
  <xsl:apply-templates select="body"/> 
</xsl:template>

<xsl:template match="body"> 
  <xsl:apply-templates select="body.content"/> 
  <xsl:apply-templates select="body.end"/> 
</xsl:template>

<xsl:template match="head">
  <xsl:apply-templates select="headline"/> 
</xsl:template>

<xsl:template match="body.content">
  <xsl:apply-templates select="block"/> 
</xsl:template>

<xsl:template match="block">
  <xsl:apply-templates select="p | media | hl2"/>
</xsl:template>

<xsl:template match="p">
  <p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="bold">
<b><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="hl2">
  <div class="art-title3"><xsl:apply-templates/></div><br />
</xsl:template>

<!--<xsl:template match="media/@media-type[text()='image']">-->
<xsl:template match="media">
  <xsl:variable name="source" select="media-reference/@source"/>
  
  <xhtml:p xmlns:xhtml="http://www.w3.org/1999/xhtml">
    <xhtml:object xmlns:xhtml="http://www.w3.org/1999/xhtml">
      <xsl:attribute name="data">
        <xsl:value-of select="media-reference/@source"/>
      </xsl:attribute>
      <xsl:attribute name="type">
        <xsl:value-of select="@media-type"/>
      </xsl:attribute>
<!--Fixme-->      
      <xsl:attribute name="href"></xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="media-reference/@alternate-text"/>
      </xsl:attribute>
      <xsl:attribute name="author">
        <xsl:apply-templates select="up:authorline|authorline" xmlns:up="http://www.unipublic.unizh.ch/2002/up"/>
      </xsl:attribute>
      <xsl:value-of select="media-caption"/>
    </xhtml:object>
  </xhtml:p>
</xsl:template>

<xsl:template match="up:authorline|authorline" xmlns:up="http://www.unipublic.unizh.ch/2002/up">
  <xsl:value-of select="."/>
</xsl:template>

<!-- List Templates -->
<xsl:template match="itemizedlist">
  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>

<xsl:template match="listitem | bxlistitem">
  <li><xsl:apply-templates/></li>
</xsl:template>

<!-- Table Templates -->
<xsl:template match="informaltable">
  <table width="100%" border="0" cellspacing="1" cellpadding="2" bgcolor="white">
    <xsl:apply-templates/>
  </table>
</xsl:template>

<xsl:template match="tgroup">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="tbody">
  <xsl:copy><xsl:apply-templates/></xsl:copy>
</xsl:template>

<xsl:template match="row">
  <tr><xsl:apply-templates/></tr>
</xsl:template>

<xsl:template match="entry">
  <td class="rel-text" bgcolor="#cccccc"><xsl:apply-templates/></td>
</xsl:template>

<xsl:template match="body.end">
  <xsl:apply-templates/> 
</xsl:template>

<xsl:template match="tagline">
  <div class="art-author">
      <xsl:apply-templates/> 
  </div>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet> 
