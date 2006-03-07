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

<!-- $Id: introspection.xsl 126576 2005-01-27 03:21:21Z gregor $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
>

<xsl:param name="editURL" select="'http://no-such-url'"/>

<xsl:template match="atom:introspection" xmlns:atom="http://purl.org/atom/ns#">
  <introspection xmlns="http://purl.org/atom/ns#">
    <xsl:apply-templates/>
    <edit-entry><xsl:value-of select="$editURL"/></edit-entry>
  </introspection>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
