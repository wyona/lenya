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

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
>
 
<xsl:output version="1.0" indent="yes" encoding="ISO-8859-1"/>

<xsl:template name="html-title">
XHTML
</xsl:template>

<xsl:template name="admin-url">
Introspection to the rescue
</xsl:template>

<xsl:template name="body">
  <xsl:apply-templates select="xhtml:html"/>
</xsl:template>

<xsl:template match="xhtml:html">
  <xsl:copy-of select="xhtml:body/node()"/>
</xsl:template>
 
</xsl:stylesheet>  
