<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 

  <xsl:param name="publicationName"/>
  <xsl:param name="publicationMaster"/>

  <xsl:template match="property">
    <xsl:choose>
      <xsl:when test="@name='export.expression'">
        <property value="/lenya/{$publicationName}/live" name="{@name}"/>
      </xsl:when>
	  <xsl:when test="@name='mail.mailhost'">
		<property value="mailhost.uzh.ch" name="{@name}"/>
	  </xsl:when>
	  <xsl:when test="@name='notification.from'">
		<property value="{$publicationMaster}" name="{@name}"/>
	  </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()|comment()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*|node()|comment()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()|comment()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
