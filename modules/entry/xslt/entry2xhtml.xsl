<?xml version="1.0" encoding="iso-8859-1"?>
<!--
  Copyright 1999-2004 The Apache Software Foundation

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->

<!-- $Id: body.xsl 370528 2006-01-19 16:29:50Z michi $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:echo="http://purl.org/atom/ns#"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:ent="http://www.purl.org/NET/ENT/1.0/"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
>

  <xsl:template match="/">
    <xhtml:div id="body" bxe_xpath="//*[local-name()='entry']">
      <!--<xsl:apply-templates select="//lenya:meta" mode="media"/>-->
      <xsl:apply-templates />
    </xhtml:div>
  </xsl:template>
  
<xsl:template match="echo:entry">
  <xhtml:div class="dateline"><xsl:value-of select="echo:issued"/></xhtml:div>
  <xsl:apply-templates select="echo:title"><xsl:with-param name="id" select="echo:id"/></xsl:apply-templates>
  <xsl:apply-templates select="echo:summary"/>
  <xsl:apply-templates select="echo:content"/>
  <xhtml:br />
  <xhtml:p class="issued">
  <strong>Posted <xsl:apply-templates select="echo:author"/> at <xsl:value-of select="echo:issued"/>&#160;|&#160;<xsl:call-template name="permalink"><xsl:with-param name="id" select="echo:id"/></xsl:call-template></strong>
  </xhtml:p>
</xsl:template>


<xsl:template match="echo:title">
  <xhtml:div class="title"><xsl:value-of select="."/></xhtml:div>
</xsl:template>


<xsl:template match="echo:summary">
  <xhtml:em><xsl:copy-of select="node()"/></xhtml:em>
</xsl:template>

<xsl:template match="echo:content[@type='application/xhtml+xml']">
  <xsl:copy-of select="."/>	
</xsl:template>

<xsl:template match="echo:content">
<xhtml:p>
  <xsl:apply-templates/>
</xhtml:p>
</xsl:template>

<xsl:template match="echo:author">
by
<xsl:choose>
<xsl:when test="echo:homepage">
<a href="{echo:homepage}"><xsl:value-of select="echo:name"/></a>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="echo:name"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="permalink">
  <a href="index.html">Permalink</a>
</xsl:template>

<xsl:template match="*[namespace-uri() = '']">
  <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:element>
</xsl:template>
 
</xsl:stylesheet>  
