<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" version="1.0">

<xsl:template name="html-head">
  <head>
    <xsl:if test="$area = 'live'">
      <xsl:attribute name="profile">http://dublincore.org/documents/dcq-html/</xsl:attribute>
      <link rel="schema.dc" href="http://purl.org/dc/elements/1.1/"/>
      <link rel="schema.dcterms" href="http://purl.org/dc/terms/"/>
    </xsl:if>
    <title>UZH - <xsl:value-of select="/document/content/*/unizh:header/unizh:heading"/> - <xsl:value-of select="*/lenya:meta/dc:title"/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
    <xsl:if test="$area = 'live'">
      <meta name="dc:title" content="{/document/content/*/lenya:meta/dc:title}"/>
      <meta name="dc:subject" content="{/document/content/*/lenya:meta/dc:subject}"/>
      <meta name="dc:description" content="{/document/content/*/lenya:meta/dc:description}"/>
      <meta name="dc:publisher" content="{/document/content/*/lenya:meta/dc:publisher}"/>
      <meta name="dc:date" content="{$lastmodified}"/>
      <meta name="dc:language" content="{/document/content/*/lenya:meta/dc:language}"/>
      <meta name="dc:rights" content="{/document/content/*/lenya:meta/dc:rights}"/>
    </xsl:if>
    <link rel="neutron-introspection" type="application/neutron+xml" href="?lenya.usecase=neutron&amp;lenya.step=introspect"/>
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
        <xsl:value-of select="$localsharedresources"/>
        <xsl:text>/css/institute.css</xsl:text>
      </xsl:attribute>
    </link>
    <xsl:if test="$document-element-name = 'unizh:news'">
      <link rel="alternate" type="application/rss+xml" title="{/document/content/unizh:news/lenya:meta/dc:title}" href="{$nodeid}.rss.xml"/> 
    </xsl:if>
    <xsl:if test="descendant::unizh:map">
      <script type="text/javascript">
        <xsl:attribute name="src">
          <xsl:text>http://maps.google.com/maps?file=api&amp;v=2&amp;key=</xsl:text>
          <xsl:choose>
            <xsl:when test="$area = 'live'">
              <xsl:value-of select="descendant::unizh:map[1]/@key"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$googleKeyAuthoring"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </script>
    </xsl:if>
    <script type="text/javascript" src="{$contextprefix}/unizh/authoring/javascript/uni.js"/>
    <xsl:if test="descendant::unizh:map">
      <script type="text/javascript">
        <xsl:text>//</xsl:text>
        <xsl:comment>
          <xsl:text>[CDATA[
          </xsl:text>
          <xsl:text>var maps = [</xsl:text>
          <xsl:for-each select="descendant::unizh:map">
            <xsl:call-template name="mapData"/>
            <xsl:if test="not(position()=last())">
              <xsl:text>,</xsl:text>
            </xsl:if>
          </xsl:for-each>
          <xsl:text>];</xsl:text>
          <![CDATA[
          window.onload=function(){
            GMultiMapload(maps);
          }
          window.onunload=function(){
            GUnload();
          }
          ]]>
          <xsl:text>//]]</xsl:text>
        </xsl:comment>
      </script>
    </xsl:if>
  </head>
</xsl:template>

</xsl:stylesheet>
