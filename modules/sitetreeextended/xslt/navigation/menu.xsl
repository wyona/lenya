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

<!-- $Id: menu.xsl 42703 2004-03-13 12:57:53Z gregor $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="nav"
    >
    
<xsl:import href="fallback://lenya/modules/sitetree/xslt/navigation/menu.xsl"/>    

<xsl:param name="area"/>

<xsl:template match="nav:fragment">
    <xsl:apply-templates select="nav:site"/>
</xsl:template>

<xsl:template name="item-default">
<xsl:if test="not(($area = 'live') and (@protected = 'true'))">
      <div class="menuitem-{count(ancestor-or-self::nav:node)} {@resourcetype}">
        <a href="{@href}"><xsl:apply-templates select="nav:label"/></a>
      </div>
  </xsl:if>  
</xsl:template>
    
<xsl:template name="item-selected">
  <div class="menuitem-selected-{count(ancestor-or-self::nav:node)} {@resourcetype}">
    <xsl:apply-templates select="nav:label"/>
  </div>
</xsl:template>

</xsl:stylesheet> 
