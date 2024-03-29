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

<!-- $Id: sitetree2nav.xsl 158907 2005-03-24 10:19:14Z michi $ -->

<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tree="http://apache.org/cocoon/lenya/sitetree/1.0"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    exclude-result-prefixes="tree"
    >

<xsl:param name="url"/>
<xsl:param name="root"/>
<xsl:param name="chosenlanguage"/>
<xsl:param name="defaultlanguage"/>
    
<xsl:variable name="path-to-context"><xsl:call-template name="create-path-to-context"/></xsl:variable>
<!--
  <xsl:variable name="root" select="$path-to-context"/>
-->
  
<xsl:template name="create-path-to-context">
  <xsl:param name="local-url" select="$url"/>
  <xsl:if test="contains($local-url, '/')">
    <xsl:text/>../<xsl:call-template name="create-path-to-context">
      <xsl:with-param name="local-url" select="substring-after($local-url, '/')"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="tree:fragment">
  <nav:fragment>
    <xsl:copy-of select="@*"/> 
    <xsl:choose>
      <xsl:when test="@base">
         <xsl:apply-templates>
          <xsl:with-param name="previous-url" select="concat(substring-after(@base, '/'), '/')"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </nav:fragment>
</xsl:template>


<xsl:template match="tree:site">

  <nav:site url="{$root}{$url}">
    <xsl:copy-of select="@*"/> 
    <xsl:apply-templates/>
  </nav:site>

</xsl:template>


<!--
Resolves the existing language of a node, preferrably
the default language.
-->
<xsl:template name="resolve-existing-language">
  <xsl:choose>
    <xsl:when test="tree:label[lang($chosenlanguage)]"><xsl:value-of select="$chosenlanguage"/></xsl:when>
    <xsl:when test="tree:label[lang($defaultlanguage)]"><xsl:value-of select="$defaultlanguage"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="tree:label/@xml:lang"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="other-languages">
  <xsl:attribute name="other-languages">
    <xsl:for-each select="tree:label[@xml:lang != $chosenlanguage]/@xml:lang">
      <xsl:value-of select="."/>
      <xsl:if test="position() != last()">,</xsl:if>
    </xsl:for-each>
  </xsl:attribute>
</xsl:template>


<!--
Apply nodes recursively
-->
<xsl:template match="tree:node[not(@visible = 'false')]">

  <!-- basic url of parent node -->
  <xsl:param name="previous-url" select="''"/>
  
  <xsl:variable name="existinglanguage">
    <xsl:call-template name="resolve-existing-language"/>
  </xsl:variable>
  
  <nav:node>
  
    <xsl:copy-of select="@id"/>
    <xsl:copy-of select="@visibleinnav"/>
    <xsl:copy-of select="@protected"/>
    <xsl:copy-of select="@folder"/>
  
    <!-- basic url - for all nodes -->
  
    <xsl:variable name="basic-url">
      <xsl:text/>
      <xsl:choose>
        <xsl:when test="@href">
          <xsl:value-of select="@href"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$previous-url"/><xsl:value-of select="@id"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>  

    <xsl:call-template name="other-languages"/>

    <xsl:variable name="language-suffix">
      <xsl:text>_</xsl:text><xsl:value-of select="$existinglanguage"/>
    </xsl:variable>
    
    <xsl:variable name="canonical-language-suffix">
      <xsl:choose>
        <xsl:when test="$existinglanguage != '' and $defaultlanguage != $existinglanguage">
          <xsl:value-of select="$language-suffix"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- no suffix for default language -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <!-- suffix - only when @href is not present -->
    
    <xsl:variable name="suffix">
      <xsl:if test="not(@href)">
        <xsl:text>.</xsl:text>
        <xsl:choose>
          <xsl:when test="@suffix">
            <xsl:value-of select="@suffix"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>html</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:variable>
    
    <xsl:attribute name="suffix"><xsl:value-of select="$suffix"/></xsl:attribute>
    <xsl:attribute name="basic-url"><xsl:value-of select="$previous-url"/><xsl:value-of select="@id"/></xsl:attribute>
    <xsl:attribute name="language-suffix"><xsl:value-of select="$canonical-language-suffix"/></xsl:attribute>
    
    <xsl:variable name="canonical-url">
      <xsl:text/>
      <xsl:value-of select="$basic-url"/><xsl:text/>
      <xsl:value-of select="$canonical-language-suffix"/><xsl:text/>
      <xsl:value-of select="$suffix"/><xsl:text/>
    </xsl:variable>
    
    <xsl:variable name="non-canonical-url">
      <xsl:text/>
      <xsl:value-of select="$basic-url"/><xsl:text/>
      <xsl:value-of select="$language-suffix"/><xsl:text/>
      <xsl:value-of select="$suffix"/><xsl:text/>
    </xsl:variable>
    
    <xsl:if test="$url = $canonical-url or $url = $non-canonical-url">
      <xsl:attribute name="current">true</xsl:attribute>
    </xsl:if>
    
    <xsl:attribute name="href">
      <xsl:choose>
        <xsl:when test="@href">
          <xsl:value-of select="@href"/>
        </xsl:when>
        <xsl:otherwise>
	  <xsl:value-of select="concat($root, $canonical-url)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    
    <xsl:choose>
      <xsl:when test="tree:label[lang($existinglanguage)]">
        <xsl:apply-templates select="tree:label[lang($existinglanguage)]">
         <xsl:with-param name="previous-url" select="concat($basic-url, '/')"/>
        </xsl:apply-templates>      	  	    
      </xsl:when>
      <xsl:otherwise>
       <xsl:apply-templates select="tree:label[1]">
         <xsl:with-param name="previous-url" select="concat($basic-url, '/')"/>
       </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
         
    <xsl:apply-templates select="tree:node">
      <xsl:with-param name="previous-url" select="concat($basic-url, '/')"/>
    </xsl:apply-templates>
    
  </nav:node>
</xsl:template>


<xsl:template match="tree:label">
  <nav:label>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </nav:label>
</xsl:template>

<xsl:template match="@*|node()" priority="-1">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet> 
