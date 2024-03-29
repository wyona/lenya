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

<!-- $Id: form-layout.xsl,v 1.4 2005/03/09 14:48:51 jann Exp $ -->

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:page="http://apache.org/cocoon/lenya/cms-page/1.0"
>

<xsl:import href="../../../../../../xslt/authoring/edit/form-layout.xsl"/>

<xsl:param name="nodeid"/>

<xsl:template match="node[@name = 'Body']" mode="nodes">
<tr>
<td valign="top" style="border-color: #000000;border-width: 1px"><xsl:apply-templates select="action"/><xsl:if test="not(action)">&#160;</xsl:if>
<xsl:apply-templates select="@select"/>
</td>
<td  valign="top" style="border-color: #000000;border-width: 1px"><h3><a name="body"><xsl:apply-templates select="@name"/></a></h3></td>
<td  valign="middle" align="right" style="border-color: #000000;border-width: 1px"><a href="#rc"><input type="button" value="GoTo Related Content Area" name="insert-after" style="color: #FFFFFF; background-color: #3300CC"/></a></td>
</tr>
</xsl:template>

<xsl:template match="node[@name = 'Related Content']" mode="nodes">
<tr>
<td valign="top" style="border-color: #ccccff;border-width: 3px"><xsl:apply-templates select="action"/><xsl:if test="not(action)">&#160;</xsl:if>
<xsl:apply-templates select="@select"/>
</td>
<td valign="top" style="border-color:#ccccff;border-width: 3px"><h3><a name="rc"><xsl:apply-templates select="@name"/></a></h3></td>
<td  valign="middle" align="right" style="border-color: #000000;border-width: 1px"><a href="#body"><input type="button" value="GoTo Body Area" name="insert-after" style="color: #FFFFFF; background-color: #3300CC"/></a></td>
</tr>
</xsl:template>

<xsl:template match="content">
    <xsl:choose>
      <xsl:when test="$edit = ../@select">
        <!-- TODO: what about "input" field ... -->
        <input type="hidden" name="namespaces"><xsl:attribute name="value"><xsl:apply-templates select="textarea" mode="namespaces" /></xsl:attribute></input>
        <xsl:copy-of select="div"/>
        <xsl:apply-templates select="textprefix"/>
        <xsl:apply-templates select="textarea"/>
        <xsl:copy-of select="input"/>
        <br/>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:choose>
            <xsl:when test="(../@name='Object')">
              <img src="{$nodeid}/{input/@value}"/>
              <!--
              Image: <xsl:value-of select="div"/>
              -->
              <br/>
              Caption: <xsl:value-of select="textarea/node()"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="textprefix/node()"/> 
              <xsl:value-of select="input/@value"/>
              <xsl:copy-of select="textarea/node()"/> 
            </xsl:otherwise>
          </xsl:choose>
        </p>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:copy-of select="text() | select"/>
  </xsl:template>

  <xsl:template match="textprefix">
      <br/>
        <xsl:copy-of select="text()"/>
  </xsl:template>
  
</xsl:stylesheet>  
