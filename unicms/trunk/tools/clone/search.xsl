<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 

  <xsl:param name="publicationName"/>
  <xsl:param name="templatePublication"/>

  <xsl:template match="robots/@src">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="@href">
    <xsl:attribute name="{name()}">
      <xsl:call-template name="replace">
	<xsl:with-param name="textinput" select="."/>
      </xsl:call-template>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="@src">
      <xsl:attribute name="{name()}">
	<xsl:call-template name="replace">
	  <xsl:with-param name="textinput" select="."/>
	</xsl:call-template>
      </xsl:attribute>
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
