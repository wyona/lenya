<?xml version="1.0" encoding="UTF-8"?>
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

<!-- $Id: publish.xsl 42703 2004-03-13 12:57:53Z gregor $ -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 
<xsl:import href="../../../xslt/util/page-util.xsl"/>

<xsl:param name="title" select="'Publish Document'"/>
<xsl:param name="action" select="'publish'"/>

<xsl:variable name="separator" select="','"/>

<xsl:template match="/">
<html>
  <head>
    <title><xsl:value-of select="$title"/></title>
    <xsl:call-template name="include-css">
      <xsl:with-param name="contextprefix" select="publish/context"/>
    </xsl:call-template>
  </head>
<body>
  <xsl:apply-templates/>
</body>
</html>
</xsl:template>

<xsl:template match="publish">
<p>
<h1><xsl:value-of select="$title"/></h1>
<form action="{$action}">

<input type="hidden" name="sources" value="{sources}"/> <!-- DefaultFilePublisher -->
<input type="hidden" name="uris" value="{uris}"/> <!-- StaticHTMLExporter -->

<input type="hidden" name="properties.publish.sources" value="{sources}"/> <!-- AntTask -->
<input type="hidden" name="properties.export.uris" value="{uris}"/> <!-- AntTask -->

<input type="hidden" name="task-id" value="{task-id}"/>
<!-- FIXME: arbitrary request parameters set within the menubar should be transfered!
<input type="hidden" name="server-port" value="1937"/>
-->

<div class="menu">Do you really want to publish the following source<xsl:text/>
<xsl:if test="contains(sources, $separator)">s</xsl:if>
<xsl:text/>?
</div>
<ul>
  <xsl:call-template name="print-list">
    <xsl:with-param name="list-string" select="sources"/>
  </xsl:call-template>
</ul>
<div class="menu">And do you really want to publish the following uri<xsl:text/>
<xsl:if test="contains(uris, $separator)">s</xsl:if>
<xsl:text/>?
</div>
<ul>
  <xsl:call-template name="print-list">
    <xsl:with-param name="list-string" select="uris"/>
  </xsl:call-template>
</ul>

<input type="submit" value="YES"/>
&#160;&#160;&#160;<input type="button" onClick="location.href='{referer}';" value="Cancel"/>
</form>
</p>
</xsl:template>


</xsl:stylesheet>  
