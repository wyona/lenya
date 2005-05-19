<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:up="http://www.unipublic.unizh.ch/2002/up"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="nav">

<xsl:import href="../../../../../xslt/navigation/menu.xsl"/>

<xsl:param name="root"/>
    
<xsl:template match="nav:site">
   <div id="years-navigation">
     <xsl:apply-templates select="nav:node[@id='dossiers']/nav:node"/>
   </div>
   <div id="dossiers-overview">
     <xsl:apply-templates select="nav:node[@id='dossiers']/nav:node[@current = 'true']/nav:node" mode="dossiers"/>
   </div>
</xsl:template>

<xsl:template match="nav:node/nav:node/nav:node"  mode="dossiers">
  <xsl:call-template name="dossiers"/>
</xsl:template>

<xsl:template match="nav:node/nav:node">
  <xsl:call-template name="item"/>
</xsl:template>

<xsl:template name="item-default">
    <a href="{@href}">
      <img src="{$root}images/jahr/{@id}_aus.gif" border="0" alt="{@id}" width="39" height="13" />
    </a>
</xsl:template>
    
<xsl:template name="item-selected">
      <img src="{$root}images/jahr/{@id}_ein.gif" border="0" alt="{@id}" width="39" height="13" />
</xsl:template>

<xsl:template name="dossiers">
  <div class="tsr-title">
    <up:dossier-id><xsl:value-of select="./@id"/></up:dossier-id>
    <a href="{@href}"><xsl:apply-templates select="nav:label"/></a>
      <xi:include href="/{@basic-url}" xpointer="/*[local-name() = 'dossier' and namespace-uri() = 'http://www.unipublic.unizh.ch/2002/up']/*[local-name() = 'teaser' and namespace-uri() = 'http://www.unipublic.unizh.ch/2002/up']"/> 
      <xi:include href="/{@basic-url}" xpointer="/*[local-name() = 'dossier' and namespace-uri() = 'http://www.unipublic.unizh.ch/2002/up']/*[local-name() = 'color' and namespace-uri() = 'http://www.unipublic.unizh.ch/2002/up']"/> 
      <xi:include href="/{@basic-url}" xpointer="/*[local-name() = 'dossier' and namespace-uri() = 'http://www.unipublic.unizh.ch/2002/up']/*[local-name() = 'meta' and namespace-uri() = 'http://apache.org/cocoon/lenya/page-envelope/1.0']"/>
  </div>
</xsl:template>

</xsl:stylesheet> 

