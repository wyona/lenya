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

<!-- $Id: aggregate.xsl 370528 2006-01-19 16:29:50Z michi $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:blog="http://apache.org/cocoon/blog/1.0"	
>

<xsl:template match="/">
<xsl:apply-templates select="feed"/>
</xsl:template>

<xsl:template match="feed">
<feed xmlns:echo="http://purl.org/atom/ns#" xmlns="http://purl.org/atom/ns#" version="{echo:feed/@version}">
<xsl:copy-of select="echo:feed/echo:title"/>
<xsl:copy-of select="echo:feed/echo:subtitle"/>
<xsl:copy-of select="echo:feed/echo:link"/>
<xsl:copy-of select="echo:feed/echo:modified"/>
<xsl:copy-of select="echo:entry"/>
</feed>
<xsl:copy-of select="blog:overview"/>
</xsl:template>
 
</xsl:stylesheet>  
