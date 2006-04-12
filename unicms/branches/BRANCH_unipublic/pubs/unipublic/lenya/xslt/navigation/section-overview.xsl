<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="nav">

<xsl:import href="../../../../../xslt/navigation/menu.xsl"/>
    
<xsl:param name="root"/>

<xsl:template match="nav:site">
   <div id="years-navigation">
     <xsl:apply-templates select="nav:node/nav:node[descendant-or-self::nav:node[@current = 'true']]/nav:node" mode="section"/>
   </div>
   <div id="section-overview">
     <xsl:apply-templates select="nav:node/nav:node/nav:node/nav:node[ancestor-or-self::nav:node[@current = 'true']]" mode="articles"/>
   </div>
</xsl:template>

<xsl:template match="nav:node" mode="section">
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

<xsl:template match="nav:node" mode="articles">
  <xsl:call-template name="articles"/>
</xsl:template>

<xsl:template name="articles">
  <div class="tsr-title">
    <a href="{@href}"><xsl:apply-templates select="nav:label"/></a>
      <xi:include href="/{@basic-url}" xpointer="/*[local-name() = 'html' and namespace-uri() = 'http://www.w3.org/1999/xhtml']/*[local-name() = 'teaser' and namespace-uri() = 'http://www.unipublic.unizh.ch/2002/up']"/> 
      <xi:include href="/{@basic-url}" xpointer="/*[local-name() = 'html' and namespace-uri() = 'http://www.w3.org/1999/xhtml']/*[local-name() = 'meta' and namespace-uri() = 'http://apache.org/cocoon/lenya/page-envelope/1.0']"/>
  </div>
</xsl:template>

</xsl:stylesheet> 

