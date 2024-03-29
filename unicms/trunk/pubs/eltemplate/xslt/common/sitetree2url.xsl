<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: sitetree2url.xsl,v 1.1 2005/03/29 12:25:36 thomas Exp $ -->

<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tree="http://apache.org/cocoon/lenya/sitetree/1.0"
    exclude-result-prefixes="tree"
    >

<xsl:param name="url"/>
<xsl:param name="chosenlanguage"/>
<xsl:param name="defaultlanguage"/>
<xsl:param name="root"/>
    
<!--
<xsl:variable name="path-to-context"><xsl:call-template name="create-path-to-context"/></xsl:variable>
<xsl:variable name="root" select="$path-to-context"/>
  
<xsl:template name="create-path-to-context">
  <xsl:param name="local-url" select="$url"/>
  <xsl:if test="contains($local-url, '/')">
    <xsl:text/>../<xsl:call-template name="create-path-to-context">
      <xsl:with-param name="local-url" select="substring-after($local-url, '/')"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>
-->

<xsl:template match="tree:site">

  <tree:site>
    <xsl:copy-of select="@*"/> 
    <xsl:apply-templates/>
  </tree:site>

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



<!--
Apply nodes recursively
-->
<xsl:template match="tree:node">

  <!-- basic url of parent node -->
  <xsl:param name="previous-url" select="''"/>
  
  <xsl:variable name="existinglanguage">
    <xsl:call-template name="resolve-existing-language"/>
  </xsl:variable>
  
  <tree:node>
  
    <xsl:copy-of select="@id"/>
    <xsl:copy-of select="@protected"/>
    <xsl:copy-of select="@visibleinnav"/>
  
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
    
  </tree:node>
</xsl:template>


<xsl:template match="tree:label">
  <tree:label>
  	<xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </tree:label>
</xsl:template>


<xsl:template match="@*|node()" priority="-1">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet> 
