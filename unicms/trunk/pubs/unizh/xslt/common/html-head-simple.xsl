<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  >

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
    <style type="text/css">
      <xsl:comment>
        @import url("<xsl:value-of select="$contextprefix"/>/unizh/authoring/css/simple.css");
      </xsl:comment>
    </style>
  </head>
</xsl:template>


</xsl:stylesheet>
