<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 

  <xsl:param name="publicationName"/>
  <xsl:param name="templatePublication"/>

  <xsl:template match="base-url | scope-url">
    <xsl:element name="{name(..)}">
      <xsl:attribute name="{name()}">
	<xsl:call-template name="replace">
	  <xsl:with-param name="textinput" select="@href"/>
	</xsl:call-template>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="uri-list | htdocs-dump-dir | index-dir">
    <xsl:element name="{name(..)}">
      <xsl:attribute name="{name()}">
	<xsl:call-template name="replace">
	  <xsl:with-param name="textinput" select="@src"/>
	</xsl:call-template>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="robots/@src">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="replace">
    <xsl:param name="textinput"/>
    <xsl:choose>
      <xsl:when test="contains($textinput,$templatePublication)">
	
	<xsl:value-of select=
		      "concat(substring-before($textinput,$templatePublication),
		       $publicationName)"/>
	<xsl:call-template name="replace">
	  <xsl:with-param name="textinput" 
			  select="substring-after($textinput,$templatePublication)"/>
	  <xsl:with-param name="templatePublication" select="$templatePublication"/>
	  <xsl:with-param name="publicationName" 
			  select="$publicationName"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$textinput"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
    
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
