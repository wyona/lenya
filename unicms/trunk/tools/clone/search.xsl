<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 

  <xsl:param name="publicationName"/>
  <xsl:param name="templatePublication"/>

  <xsl:template match="base-url | scope-url">
    <xsl:apply-templates select="@href"/>
  </xsl:template>

  <xsl:template match="uri-list | htdocs-dump-dir | index-dir">
    <xsl:apply-templates select="@src"/>
  </xsl:template>

  <xsl:template match="@href | @src">
     <xsl:variable name="attrValue">
       <xsl:value-of select="substring-before(.,$templatePublication)"/>
       <xsl:value-of select="$publicationName"/>
       <xsl:value-of select="substring-after(.,$templatePublication)"/>
     </xsl:variable>
     <xsl:element name="{name(..)}">
       <xsl:attribute name="{name()}">
         <xsl:value-of select="$attrValue"/>
       </xsl:attribute>
     </xsl:element>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
