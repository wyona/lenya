<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: sitetree2unizhindex.xsl,v 1.2 2004/01/06 12:39:06 gregor Exp $ -->

<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tree="http://apache.org/cocoon/lenya/sitetree/1.0"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    exclude-result-prefixes="tree"
    >

<xsl:param name="url"/>
<xsl:param name="chosenlanguage"/>
<xsl:param name="defaultlanguage"/>
    
<xsl:variable name="path-to-context"><xsl:call-template name="create-path-to-context"/></xsl:variable>
  
<xsl:template name="create-path-to-context">
  <xsl:param name="local-url" select="$url"/>
  <xsl:if test="contains($local-url, '/')">
    <xsl:text/>../<xsl:call-template name="create-path-to-context">
      <xsl:with-param name="local-url" select="substring-after($local-url, '/')"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<xsl:template match="tree:site">

  <div id="unizh:children">
    <xsl:copy-of select="@label"/> 
    <xsl:apply-templates/>
  </div>

</xsl:template>    

<!--
Apply nodes recursively
-->
<xsl:template match="tree:node">

  <!-- basic url of parent node -->
  <xsl:param name="previous-url" select="''"/>
  
  <nav:node>
  
    <xsl:copy-of select="@id"/>
  
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
    
    <!-- suffix - only when @href is not present -->
  
    <xsl:variable name="suffix">
      <xsl:if test="not(@href)">
         <xsl:choose>
            <xsl:when test="tree:label[lang($chosenlanguage)]">
      	       <xsl:text/>_<xsl:value-of select="$chosenlanguage"/><xsl:text/>
            </xsl:when>
            <xsl:otherwise>
      	       <xsl:text/>_<xsl:value-of select="$defaultlanguage"/><xsl:text/>
            </xsl:otherwise>
          </xsl:choose>	
          <xsl:text>.</xsl:text>
          <xsl:choose>
            <xsl:when test="@suffix">
              <xsl:text/><xsl:value-of select="@suffix"/><xsl:text/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>html</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
      </xsl:if>
    </xsl:variable>
    
    <xsl:attribute name="suffix"><xsl:value-of select="$suffix"/></xsl:attribute>
    <xsl:attribute name="basic-url"><xsl:value-of select="$previous-url"/><xsl:value-of select="@id"/></xsl:attribute>
    <xsl:attribute name="href">
      <xsl:text/>
      <xsl:value-of select="$path-to-context"/><xsl:text/>
      <xsl:value-of select="$basic-url"/><xsl:text/>
      <xsl:value-of select="$suffix"/><xsl:text/>
    </xsl:attribute>
    
    <xsl:apply-templates>
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
