<?xml version="1.0"?>
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

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
>

<xsl:template match="/">
  <html>
  <xsl:copy-of select="/page/xhtml:html/xhtml:head"/>
    <body>
    <p>
    <xsl:apply-templates select="/page/navigation/bread-crumbs"/>
    <xsl:apply-templates select="/page/navigation-exception"/>
    </p>
  <xsl:copy-of select="/page/xhtml:html/xhtml:body/*"/>
    </body>
  </html>
</xsl:template>

<xsl:template match="bread-crumbs">
Bread Crumbs:
<xsl:for-each select="crumb">
  <xsl:choose>
  <xsl:when test="position() = last()">
    <xsl:value-of select="."/>
  </xsl:when>
  <xsl:otherwise>
    <a href="{@path}"><xsl:value-of select="."/></a> &gt;&gt;
  </xsl:otherwise>
  </xsl:choose>
</xsl:for-each>
</xsl:template>

<xsl:template match="navigation-exception">
  EXCEPTION: <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="*|@*|node()|text()" priority="-1">
  <xsl:copy><xsl:apply-templates select="*|@*|node()|text()"/></xsl:copy>
</xsl:template>

</xsl:stylesheet>
