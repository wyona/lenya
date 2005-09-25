<?xml version="1.0" encoding="ISO-8859-1" ?>

<!-- $Id: includeAssetMetaData.xsl,v 1.4 2004/06/23 16:07:25 edith Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:session="http://apache.org/cocoon/session/1.0"
  >

  <xsl:param name="version"/>
  <xsl:param name="fontsize"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$version = 'simple'">
        <session:createcontext name="version"/>
        <session:setxml context="version" path="/">simple</session:setxml>
      </xsl:when>
      <xsl:when test="$version= 'standard'">
        <session:deletecontext name="version"/>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="$fontsize = 'big'">
        <session:createcontext name="font"/>
        <session:setxml context="font" path="/size">big</session:setxml>
      </xsl:when>
      <xsl:when test="$fontsize = 'normal'">
        <session:deletecontext name="font"/>
      </xsl:when>
    </xsl:choose>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template> 

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
