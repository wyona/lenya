<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: html-head.xsl 20549 2006-12-04 12:57:40Z thomas $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
>


<xsl:param name="contextprefix"/>

<xsl:template name="html-head">
  <head>
    <title>UZH - <xsl:value-of select="/document/content/*/unizh:header/unizh:heading"/> - <xsl:value-of select="*/lenya:meta/dc:title"/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
    <link rel="neutron-introspection" type="application/neutron+xml" href="?lenya.usecase=neutron&amp;lenya.step=introspect"/>
    <link rel="shortcut icon" type="image/vnd.microsoft.icon">
      <xsl:attribute name="href"><xsl:value-of select="$localsharedresources"/><xsl:text>/favicon.ico</xsl:text></xsl:attribute>
    </link>
    <style type="text/css">
      <xsl:comment>
        <xsl:text>@import url("</xsl:text><xsl:value-of select="$contextprefix"/><xsl:text>/unizh/authoring/css/main.css");</xsl:text>
        <xsl:text>@import url("</xsl:text><xsl:value-of select="$localsharedresources"/><xsl:text>/css/extended.css");</xsl:text>
        <xsl:text>@import url("</xsl:text><xsl:value-of select="$localsharedresources"/><xsl:text>/css/public.css");</xsl:text>
        <xsl:text>@import url("</xsl:text><xsl:value-of select="$localsharedresources"/><xsl:text>/css/institute.css");</xsl:text>
        <xsl:if test="$document-element-name = 'unizh:homepage4cols' or $document-element-name = 'unizh:homepage'">
          <xsl:text>@import url("</xsl:text><xsl:value-of select="$localsharedresources"/><xsl:text>/css/home.css");</xsl:text>
        </xsl:if>
        <xsl:if test="contains($fontsize, 'big') and not(contains($fontsize, 'normal'))">
          <xsl:text>@import url("</xsl:text><xsl:value-of select="$localsharedresources"/><xsl:text>/css/visibility.css");</xsl:text>
          <xsl:text>@import url("</xsl:text><xsl:value-of select="$localsharedresources"/><xsl:text>/css/visibility_public.css");</xsl:text>
        </xsl:if>
        <xsl:if test="($document-element-name = 'unizh:homepage4cols' or $document-element-name = 'unizh:homepage') and (contains($fontsize, 'big') and not(contains($fontsize, 'normal')))">
          <xsl:text>@import url("</xsl:text><xsl:value-of select="$localsharedresources"/><xsl:text>/css/visibility_home.css");</xsl:text>
        </xsl:if>
      </xsl:comment>
    </style>
    <script type="text/javascript" src="{$contextprefix}/unizh/authoring/javascript/uni.js"/>
    <script type="text/javascript" src="{$localsharedresources}/javascript/institute.js"/>
    <xsl:if test="$document-element-name = 'unizh:news'">
      <link rel="alternate" type="application/rss+xml" title="{/document/content/unizh:news/lenya:meta/dc:title}" href="{$nodeid}.rss.xml"/> 
    </xsl:if>
  </head>
</xsl:template>

</xsl:stylesheet>
