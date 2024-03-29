<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: html-head.xsl 23232 2007-03-13 08:49:44Z thomas $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" version="1.0">

<xsl:template name="html-head">
  <head>
    <title>UZH - <xsl:value-of select="/document/content/*/unizh:header/unizh:heading"/> - <xsl:value-of select="*/lenya:meta/dc:title"/>
    </title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
    <link rel="neutron-introspection" type="application/neutron+xml" href="?lenya.usecase=neutron&amp;lenya.step=introspect"/>

    <xsl:choose>
      <xsl:when test="contains($fontsize, 'big') and not(contains($fontsize, 'normal'))">
        <link rel="stylesheet" type="text/css" href="{$contextprefix}/unizh/authoring/css/big.css"/>
      </xsl:when>
      <xsl:otherwise>
        <link rel="stylesheet" type="text/css" href="{$contextprefix}/unizh/authoring/css/main.css"/>   
      </xsl:otherwise>
    </xsl:choose>
    <link rel="stylesheet" type="text/css" href="{$localsharedresources}/unizh/authoring/css/institute.css"/>
    <link rel="stylesheet" type="text/css" href="{$contextprefix}/unizh/authoring/css/elml.css"/>

    <script type="text/javascript" src="{$contextprefix}/unizh/authoring/javascript/uni.js"/>
<script xmlns:xhtml="http://www.w3.org/1999/xhtml" src="{$contextprefix}/unizh/authoring/javascript/elml.js" type="text/javascript"/>
    <xsl:if test="$document-element-name = 'unizh:news'">
      <link rel="alternate" type="application/rss+xml" title="{/document/content/unizh:news/lenya:meta/dc:title}" href="{$nodeid}.rss.xml"/> 
    </xsl:if>
  </head>
</xsl:template>

</xsl:stylesheet>
