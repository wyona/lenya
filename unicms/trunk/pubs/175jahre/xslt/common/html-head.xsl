<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
>


<xsl:template name="html-head">
  <head>
    <xsl:if test="$area = 'live'">
      <xsl:attribute name="profile">http://dublincore.org/documents/dcq-html/</xsl:attribute>
      <link rel="schema.dc" href="http://purl.org/dc/elements/1.1/"/>
      <link rel="schema.dcterms" href="http://purl.org/dc/terms/"/>
    </xsl:if>
    <title>175 Jahre Universität Zürich</title>
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
    <link rel="shortcut icon" type="image/vnd.microsoft.icon">
      <xsl:attribute name="href"><xsl:value-of select="$localsharedresources"/><xsl:text>/images/favicon.ico</xsl:text></xsl:attribute>
    </link>
    <link rel="stylesheet" type="text/css" media="screen">
      <xsl:attribute name="href">
        <xsl:value-of select="$localsharedresources"/>
        <xsl:text>/css/main.css</xsl:text>
      </xsl:attribute>
    </link>
    <xsl:if test="$document-element-name = 'unizh:homepage4cols' or $document-element-name = 'unizh:project' or $document-element-name = 'unizh:project4cols'">
      <link rel="stylesheet" type="text/css" media="screen">
        <xsl:attribute name="href">
          <xsl:value-of select="$localsharedresources"/>
          <xsl:text>/css/home.css</xsl:text>
        </xsl:attribute>
      </link>
    </xsl:if>
    <xsl:if test="$document-element-name = 'unizh:homepage4cols'">
      <link rel="stylesheet" type="text/css" media="screen">
        <xsl:attribute name="href">
          <xsl:value-of select="$localsharedresources"/>
          <xsl:text>/css/index.css</xsl:text>
        </xsl:attribute>
      </link>
    </xsl:if>
    <xsl:if test="$nodeid != 'index'">
      <link rel="stylesheet" type="text/css" media="screen">
        <xsl:attribute name="href">
          <xsl:value-of select="$localsharedresources"/>
          <xsl:choose>
            <xsl:when test="$nodeid = 'news' or /document/unizh:ancestors/unizh:ancestor[@basic-url = 'news']">
              <xsl:text>/css/news.css</xsl:text>
            </xsl:when>
            <xsl:when test="$nodeid = 'ueber' or /document/unizh:ancestors/unizh:ancestor[@basic-url = 'ueber']">
              <xsl:text>/css/ueber.css</xsl:text>
            </xsl:when>
            <xsl:when test="$nodeid = 'agenda' or /document/unizh:ancestors/unizh:ancestor[@basic-url = 'agenda']">
              <xsl:text>/css/agenda.css</xsl:text>
            </xsl:when>
            <xsl:when test="$nodeid = 'veranstaltungen' or /document/unizh:ancestors/unizh:ancestor[@basic-url = 'veranstaltungen']">
              <xsl:text>/css/veranstaltungen.css</xsl:text>
            </xsl:when>
            <xsl:when test="$nodeid = 'fakultaeten' or /document/unizh:ancestors/unizh:ancestor[@basic-url = 'fakultaeten']">
              <xsl:text>/css/fakultaeten.css</xsl:text>
            </xsl:when>
            <xsl:when test="$nodeid = 'ausstellungen' or /document/unizh:ancestors/unizh:ancestor[@basic-url = 'ausstellungen']">
              <xsl:text>/css/ausstellungen.css</xsl:text>
            </xsl:when>
            <xsl:when test="$nodeid = 'blog' or /document/unizh:ancestors/unizh:ancestor[@basic-url = 'blog']">
              <xsl:text>/css/blog.css</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:attribute>
      </link>
    </xsl:if>
    <xsl:if test="$document-element-name = 'unizh:news'">
      <link rel="alternate" type="application/rss+xml" title="{/document/content/unizh:news/lenya:meta/dc:title}" href="{$nodeid}.rss.xml"/> 
    </xsl:if>
    <xsl:if test="descendant::unizh:map">
      <script type="text/javascript">
        <xsl:attribute name="src">
          <xsl:text>http://maps.google.com/maps?file=api&amp;v=2&amp;key=</xsl:text>
          <xsl:choose>
            <xsl:when test="$area = 'live'">
              <xsl:value-of select="$googleKeyLive"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$googleKeyAuthoring"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </script>
    </xsl:if>
    <script type="text/javascript">
      <xsl:attribute name="src">
        <xsl:value-of select="$localsharedresources" />
        <xsl:text>/javascript/uni.js</xsl:text>
      </xsl:attribute>
    </script>
    <xsl:if test="descendant::unizh:map">
      <script type="text/javascript">
        <!-- this ought to be //<![CDATA[ -->
        <xsl:text>//![CDATA[
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
      </script>
    </xsl:if>
  </head>
</xsl:template>

</xsl:stylesheet>
