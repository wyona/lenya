<?xml version="1.0" encoding="UTF-8" ?>
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

<!-- $Id: xhtml2xhtml.xsl 201776 2005-06-25 18:25:26Z gregor $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:wiki="http://apache.org/cocoon/wiki/1.0"
    xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    >

<xsl:param name="rendertype" select="''"/>
<xsl:param name="nodeid"/>

<xsl:template match="/">
  <div id="body">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="wiki:wiki">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="wiki:WikiBody">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="wiki:Paragraph">
  <p>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="wiki:Title">
  <h1>
    <xsl:apply-templates/>
  </h1>
</xsl:template>

<xsl:template match="wiki:MainTitle">
  <h2>
    <xsl:apply-templates/>
  </h2>
</xsl:template>

<xsl:template match="wiki:MainMainTitle">
  <h3>
    <xsl:apply-templates/>
  </h3>
</xsl:template>

<xsl:template match="wiki:Bold">
  <b>
    <xsl:apply-templates/>
  </b>
</xsl:template>

<xsl:template match="wiki:Italic">
  <i>
    <xsl:apply-templates/>
  </i>
</xsl:template>

<xsl:template match="wiki:Underline">
  <u>
    <xsl:apply-templates/>
  </u>
</xsl:template>

<xsl:template match="wiki:ForceNewline">
  <br/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="wiki:BList">
</xsl:template>

<xsl:template match="wiki:NList">
</xsl:template>

<xsl:template match="wiki:Table">
</xsl:template>

<xsl:template match="wiki:Hrule">
  <hr/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="wiki:Link">
<xsl:choose>
    <xsl:when test="@label">
        <a href="{@href}"><xsl:value-of select="@label"/></a>
    </xsl:when>
    <xsl:otherwise>
    <a href="{@href}"><xsl:value-of select="@href"/></a>
    </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="wiki:Text">
  <xsl:value-of select="@value"/>
</xsl:template>

<xsl:template match="wiki:PlainText">
  <xsl:value-of select="@value"/>
</xsl:template>

<xsl:template match="wiki:Plain">
  <pre>
    <xsl:apply-templates/>
  </pre>
</xsl:template>
	
</xsl:stylesheet> 
