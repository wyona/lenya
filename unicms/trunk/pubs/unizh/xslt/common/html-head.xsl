<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" version="1.0">

<xsl:template name="html-head">
  <head profile="http://dublincore.org/documents/dcq-html/">
    <link rel="schema.dc" href="http://purl.org/dc/elements/1.1/"/>
    <link rel="schema.dcterms" href="http://purl.org/dc/terms/"/>
    <title>UZH - <xsl:value-of select="/document/content/*/unizh:header/unizh:heading"/> - <xsl:value-of select="*/lenya:meta/dc:title"/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
    <meta name="dc:title" content="{/document/content/*/lenya:meta/dc:title}"/>
    <meta name="dc:creator" content="{/document/content/*/lenya:meta/dc:creator}"/>
    <meta name="dc:subject" content="{/document/content/*/lenya:meta/dc:subject}"/>
    <meta name="dc:description" content="{/document/content/*/lenya:meta/dc:description}"/>
    <meta name="dc:publisher" content="{/document/content/*/lenya:meta/dc:publisher}"/>
    <meta name="dc:language" content="{/document/content/*/lenya:meta/dc:language}"/>
    <meta name="dc:rights" content="{/document/content/*/lenya:meta/dc:rights}"/>
    <link rel="neutron-introspection" type="application/neutron+xml" href="?lenya.usecase=neutron&amp;lenya.step=introspect"/>
    <style type="text/css">
      <xsl:comment>
        <xsl:choose>
          <xsl:when test="contains($fontsize, 'big') and not(contains($fontsize, 'normal'))">
            @import url("<xsl:value-of select="$contextprefix"/>/unizh/authoring/css/big.css");
          </xsl:when>
          <xsl:otherwise>
            @import url("<xsl:value-of select="$contextprefix"/>/unizh/authoring/css/main.css");
          </xsl:otherwise>
        </xsl:choose>
        @import url("<xsl:value-of select="$localsharedresources"/>/css/institute.css");
      </xsl:comment>
    </style>
    <xsl:if test="$document-element-name = 'unizh:news'">
      <link rel="alternate" type="application/rss+xml" title="{/document/content/unizh:news/lenya:meta/dc:title}" href="{$nodeid}.rss.xml"/> 
    </xsl:if>
    <xsl:if test="descendant::unizh:map">
      <script type="text/javascript">
        <xsl:attribute name="src">
          <xsl:text>http://maps.google.com/maps?file=api&amp;v=2&amp;key</xsl:text>
          <xsl:value-of select="descendant::unizh:map[1]/@key"/>
        </xsl:attribute>
      </script>
    </xsl:if>
    <script type="text/javascript" src="{$contextprefix}/unizh/authoring/javascript/uni.js"/>
    <xsl:if test="descendant::unizh:map">
      <script type="text/javascript">
        <xsl:comment>
          <xsl:text>var maps = [</xsl:text>
          <xsl:for-each select="descendant::unizh:map">
            <xsl:call-template name="mapData"/>
            <xsl:if test="not(position()=last())">
              <xsl:text>,</xsl:text>
            </xsl:if>
          </xsl:for-each>
          <xsl:text>];</xsl:text>
        </xsl:comment>
      </script>
    </xsl:if>
  </head>
</xsl:template>

</xsl:stylesheet>
