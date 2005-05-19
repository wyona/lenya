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

<!-- $Id: form-layout.xsl,v 1.1 2004/11/22 12:54:46 thomas Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:page="http://apache.org/cocoon/lenya/cms-page/1.0"
  >
  
  <xsl:import href="../../../../../../xslt/authoring/edit/form-layout.xsl"/>

  <xsl:param name="path"/>
  
  <xsl:template match="content">
    <xsl:choose>
      <xsl:when test="$edit = ../@select">
        <!-- TODO: what about "input" field ... -->
        <input type="hidden" name="namespaces"><xsl:attribute name="value"><xsl:apply-templates select="textarea" 
        mode="namespaces" /></xsl:attribute></input>
        <xsl:copy-of select="div"/>
        <xsl:apply-templates select="textarea"/>
        <xsl:copy-of select="input"/>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:choose>
            <xsl:when test="(../@name='Object')">
              <!-- FIXME we need the correct image path
              <img src="{input/@value}"/>
              -->
              Image: <xsl:value-of select="div"/>
              <br/>
              Caption: <xsl:value-of select="textarea/node()"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="input/@value"/>
              <xsl:copy-of select="textarea/node()"/>
            </xsl:otherwise>
          </xsl:choose>
        </p>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:copy-of select="text() | select"/>
  </xsl:template>
  
</xsl:stylesheet>  
