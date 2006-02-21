<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    >
    
    <xsl:template match="/">
     <xsl:apply-templates/> 
    </xsl:template>

    <xsl:template match="xhtml:p">
     <xsl:text>&#10;</xsl:text><xsl:value-of select="normalize-space(text())"/><xsl:text>&#10;</xsl:text>
    </xsl:template>

    <xsl:template match="xhtml:h1|xhtml:h2|xhtml:h3">
     <xsl:text>&#10;</xsl:text><xsl:value-of select="normalize-space(text())"/><xsl:text>&#10;</xsl:text>
    </xsl:template> 
    
    <xsl:template match="node()" priority="-1">
      <xsl:apply-templates select="node()"/>        
    </xsl:template>
    
</xsl:stylesheet> 
