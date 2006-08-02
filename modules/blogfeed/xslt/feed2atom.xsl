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
<xsl:stylesheet  xmlns:blog="http://apache.org/cocoon/blog/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" version="1.0">
  <xsl:param name="url"/>
  <xsl:template match="/">
    <xsl:apply-templates select="blog:overview"/>
  </xsl:template>
  <xsl:template match="blog:overview">
    <echo:feed xmlns:echo="http://purl.org/atom/ns#" xmlns="http://www.w3.org/1999/xhtml" version="0.3" xml:lang="en">
      <echo:title><xsl:value-of select="@title"/> </echo:title>
      <echo:link href="{$url}" rel="alternate" type="text/xml"/>
      <echo:updated><xsl:value-of select="@modified"/></echo:updated>
      <xsl:apply-templates select=".//blog:entry"/>
    </echo:feed>
  </xsl:template>
  <xsl:template match="blog:entry">
    <xi:include href="lenyadoc:/en/{@docid}"/>
  </xsl:template>
</xsl:stylesheet>
