<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: cp-export.xsl,v 1.3 2005/03/29 08:28:40 thomas Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:zip="http://apache.org/cocoon/zip-archive/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
  <xsl:param name="pubid-live"/>
  <xsl:param name="pubid-authoring"/>

  <xsl:template match="/site">
    <zip:archive>
      <xsl:apply-templates/>
    </zip:archive>
  </xsl:template>

  <xsl:template match="pages">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="manifest">
    <zip:entry name="imsmanifest.xml" serializer="xml">
      <xsl:copy>
        <xsl:apply-templates/>
      </xsl:copy>
    </zip:entry>
  </xsl:template>


  <xsl:template match="page">
      <xsl:variable name="zip-filepath" select="substring-after(@href, $pubid-live)"/>
      <zip:entry name="{$zip-filepath}" serializer="html">
        <xsl:apply-templates/>
      </zip:entry>
  </xsl:template>

  <xsl:template match="dir:directory">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dir:file">
    <zip:entry name="{../@name}/{@name}" src="resources/shared/{../@name}/{@name}"/>
  </xsl:template>

  <!-- css -->
  
  <xsl:template match="dir:file[../@name = 'css']">
    <xsl:if test="contains(@name, '.xml')">
      <zip:entry name="{../@name}/{substring-before(@name, '.xml')}.css" src="resources/shared/{../@name}/{@name}"/>  
    </xsl:if>

  </xsl:template>


  <xsl:template match="@href[parent::xhtml:link]">
    <xsl:variable name="page-path" select="substring-after(ancestor::*[name() = 'page']/@href, $pubid-live)"/>
    <xsl:attribute name="href">
      <xsl:variable name="subdir" select="substring-after($page-path, '/')"/>
      <xsl:if test="$subdir != ''">../<xsl:variable name="subdir-2" select="substring-after($subdir, '/')"/><xsl:if test="$subdir-2 != ''">../<xsl:variable name="subdir-3" select="substring-after($subdir-2, '/')"/><xsl:if test="$subdir-3 != ''">../</xsl:if>
        </xsl:if>
      </xsl:if>
      <xsl:value-of select="substring-after(., $pubid-authoring)"/>
    </xsl:attribute>
  </xsl:template> 


  <xsl:template match="@src[parent::xhtml:img]">
    <xsl:variable name="page-path" select="substring-after(ancestor::*[name() = 'page']/@href, $pubid-live')"/>
    <xsl:attribute name="src">
      <xsl:variable name="subdir" select="substring-after($page-path, '/')"/>
      <xsl:if test="$subdir != ''">../<xsl:variable name="subdir-2" select="substring-after($subdir, '/')"/><xsl:if test="$subdir-2 != ''">../<xsl:variable name="subdir-3" select="substring-after($subdir-2, '/')"/><xsl:if test="$subdir-3 != ''">../</xsl:if>
        </xsl:if>
      </xsl:if>
      <xsl:value-of select="substring-after(., $pubid-authoring)"/>
    </xsl:attribute>
  </xsl:template> 

  <xsl:template match="@src[parent::xhtml:script]">
    <xsl:variable name="page-path" select="substring-after(ancestor::*[name() = 'page']/@href, $pubid-live)"/>
    <xsl:attribute name="src">
      <xsl:variable name="subdir" select="substring-after($page-path, '/')"/>
      <xsl:if test="$subdir != ''">../<xsl:variable name="subdir-2" select="substring-after($subdir, '/')"/><xsl:if test="$subdir-2 != ''">../<xsl:variable name="subdir-3" select="substring-after($subdir-2, '/')"/><xsl:if test="$subdir-3 != ''">../</xsl:if>
        </xsl:if>
      </xsl:if>
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>



  <xsl:template match="@href[parent::xhtml:a]">
    <xsl:variable name="page-path" select="substring-after(ancestor::*[name() = 'page']/@href, $pubid-live)"/>
    <xsl:attribute name="href">
      <xsl:variable name="subdir" select="substring-after($page-path, '/')"/>
      <xsl:if test="$subdir != ''">../<xsl:variable name="subdir-2" select="substring-after($subdir, '/')"/><xsl:if test="$subdir-2 != ''">../<xsl:variable name="subdir-3" select="substring-after($subdir-2, '/')"/><xsl:if test="$subdir-3 != ''">../</xsl:if>
        </xsl:if>
      </xsl:if>
      <xsl:value-of select="substring-after(., $pubid-live)"/>
    </xsl:attribute>
  </xsl:template>


 <xsl:template match="@value[parent::xhtml:option]">
    <xsl:variable name="page-path" select="substring-after(ancestor::*[name() = 'page']/@href, $pubid-live)"/>
    <xsl:attribute name="value">
      <xsl:variable name="subdir" select="substring-after($page-path, '/')"/>
      <xsl:if test="$subdir != ''">../<xsl:variable name="subdir-2" select="substring-after($subdir, '/')"/><xsl:if test="$subdir-2 != ''">../<xsl:variable name="subdir-3" select="substring-after($subdir-2, '/')"/><xsl:if test="$subdir-3 != ''">../</xsl:if>
        </xsl:if>
      </xsl:if>
      <xsl:value-of select="substring-after(., $pubid-live)"/>
    </xsl:attribute>
  </xsl:template>

 

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
 
</xsl:stylesheet>
