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

<!-- $Id: body.xsl 42703 2004-03-13 12:57:53Z gregor $ -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
                xmlns:error="http://apache.org/cocoon/error/2.0"
>
 
<xsl:output version="1.0" indent="yes"/>

<xsl:template name="body">
  <xsl:apply-templates select="html/body" mode="xhtml"/>
</xsl:template>

<xsl:template match="body">
  <xsl:copy-of select="*"/>
</xsl:template>

<xsl:template name="html-title">
Home - OSCOM - Open Source Content Management
</xsl:template>

<xsl:template name="admin-url">
<xsl:param name="prefix"/>
<a class="breadcrumb"><xsl:attribute name="href"><xsl:value-of select="$prefix"/>/index.html</xsl:attribute>Apache Lenya
</a>
</xsl:template>


<xsl:template match="p">
 <p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="a">
<a href="{@href}"><xsl:apply-templates/></a>
</xsl:template>

<xsl:template match="error:notify">
  EXCEPTION
</xsl:template>
 
</xsl:stylesheet>  
