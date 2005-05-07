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
>

  <xsl:param name="contextPath" select="string('/lenya')"/>

  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:value-of select="document/header/title"/></title>
      </head>
      <body>
        <p>
          <xsl:apply-templates select="document/body/*"/>
        </p>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="section">
    <xsl:choose> <!-- stupid test for the hirachy deep -->
      <xsl:when test="../../../section">
        <h5><xsl:value-of select="title"/></h5>
      </xsl:when>
      <xsl:when test="../../section">
        <h4><xsl:value-of select="title"/></h4>
      </xsl:when>
      <xsl:when test="../section">
        <h3><xsl:value-of select="title"/></h3>
      </xsl:when>
      <xsl:otherwise>
        <h2>OTHERWISE<xsl:value-of select="title"/></h2>
      </xsl:otherwise>
    </xsl:choose>
    <p>
      <xsl:apply-templates select="*[name()!='title']"/>
    </p>
  </xsl:template>

  <xsl:template match="source">
    <div style="background: #b9d3ee; border: thin; border-color: black; border-style: solid; padding-left: 0.8em; 
                padding-right: 0.8em; padding-top: 0px; padding-bottom: 0px; margin: 0.5ex 0px; clear: both;">
      <pre>
        <xsl:value-of select="."/>
      </pre>
    </div>
  </xsl:template>
 
  <xsl:template match="link">
    <a href="{@href}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>
 
  <xsl:template match="strong">
    <b>
      <xsl:apply-templates/>
    </b>
  </xsl:template>
 
  <xsl:template match="anchor">
    <a name="{@name}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>
 
  <xsl:template match="para">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="*|@*|node()|text()" priority="-1">
    <xsl:copy><xsl:apply-templates select="*|@*|node()|text()"/></xsl:copy>
  </xsl:template>

</xsl:stylesheet>
