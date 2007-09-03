<?xml version="1.0" encoding="UTF-8"?>


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
    <meta name="dc:title" content="{/document/content/*/lenya:meta/dc:title}"/>
    <meta name="dc:subject" content="{/document/content/*/lenya:meta/dc:subject}"/>
    <meta name="dc:description" content="{/document/content/*/lenya:meta/dc:description}"/>
    <meta name="dc:publisher" content="{/document/content/*/lenya:meta/dc:publisher}"/>
    <meta name="dc:language" content="{/document/content/*/lenya:meta/dc:language}"/>
    <meta name="dc:rights" content="{/document/content/*/lenya:meta/dc:rights}"/>
    <link rel="neutron-introspection" type="application/neutron+xml" href="?lenya.usecase=neutron&amp;lenya.step=introspect"/>
    <link rel="shortcut icon" type="image/vnd.microsoft.icon">
      <xsl:attribute name="href"><xsl:value-of select="$localsharedresources"/><xsl:text>/images/favicon.ico</xsl:text></xsl:attribute>
    </link>
    <!-- CSS must be included at this point in order to be available for editor, will be replaced in cachePostProcessing.xsl -->
    <link rel="stylesheet" type="text/css">
      <xsl:attribute name="href">
        <xsl:value-of select="$contextprefix"/>
        <xsl:choose>
          <xsl:when test="contains($fontsize, 'big') and not(contains($fontsize, 'normal'))">
            <xsl:text>/unizh/authoring/css/big.css</xsl:text>
          </xsl:when>
          <xsl:when test="contains($fontsize, 'normal')">
            <xsl:text>/unizh/authoring/css/main.css</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>/unizh/authoring/css/main.css</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </link>
    <link rel="stylesheet" type="text/css">
      <xsl:attribute name="href">
        <xsl:value-of select="$localsharedresources"/><xsl:text>/css/extended.css</xsl:text>
      </xsl:attribute>
    </link>
    <link rel="stylesheet" type="text/css">
      <xsl:attribute name="href">
        <xsl:value-of select="$localsharedresources"/><xsl:text>/css/public.css</xsl:text>
      </xsl:attribute>
    </link>
    <link rel="stylesheet" type="text/css">
      <xsl:attribute name="href">
        <xsl:value-of select="$localsharedresources"/><xsl:text>/css/institute.css</xsl:text>
      </xsl:attribute>
    </link>
    <xsl:if test="$document-element-name = 'unizh:homepage4cols' or $document-element-name = 'unizh:homepage'">
      <link rel="stylesheet" type="text/css">
        <xsl:attribute name="href">
          <xsl:value-of select="$localsharedresources"/><xsl:text>/css/home.css</xsl:text>
        </xsl:attribute>
      </link>
    </xsl:if>
    <script type="text/javascript" src="{$contextprefix}/unizh/authoring/javascript/uni.js"/>
    <script type="text/javascript" src="{$localsharedresources}/javascript/institute.js"/>
    <xsl:if test="$document-element-name = 'unizh:news'">
      <link rel="alternate" type="application/rss+xml" title="{/document/content/unizh:news/lenya:meta/dc:title}" href="{$nodeid}.rss.xml"/> 
    </xsl:if>
  </head>
</xsl:template>

</xsl:stylesheet>
