<?xml version="1.0"?>

<!--
        $Id: sitetree2tree.xsl,v 1.2 2004/11/17 14:36:45 andreas Exp $
        Converts a sitetree into a javascript array suitable for the tree widget.
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:s="http://apache.org/cocoon/lenya/navigation/1.0">
    
<xsl:import href="../../../../../xslt/info/sitetree2tree.xsl"/>

<xsl:template name="getLabel">
  <xsl:if test="not(parent::s:node) and @id='index'">
  <xsl:text>&lt;span style='font-weight: bold'&gt;&#160;</xsl:text>
  </xsl:if>
  
  <xsl:choose>
    <xsl:when test="s:label[lang($chosenlanguage)]">
      <xsl:call-template name="escape-characters">
        <xsl:with-param name="input" select="s:label[lang($chosenlanguage)]"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="s:label[lang($defaultlanguage)]">
      <xsl:call-template name="escape-characters">
        <xsl:with-param name="input" select="s:label[lang($defaultlanguage)]"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="escape-characters">
        <xsl:with-param name="input" select="s:label"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>	

  <xsl:if test="not(parent::s:node) and @id='index'">
  <xsl:text>&#160;&lt;/span&gt;</xsl:text>
  </xsl:if>
</xsl:template>


</xsl:stylesheet> 
