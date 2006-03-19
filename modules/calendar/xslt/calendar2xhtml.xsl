<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
>


<xsl:template match="calendar">
<div id="body">
<h1>CALENDAR of <xsl:value-of select="@user"/></h1>
<h2>Contents</h2>
<xsl:for-each select="year">
  <b><xsl:value-of select="@value"/></b><br/>
  <xsl:for-each select="month">
    <a href="#{@name}{../@value}"><xsl:value-of select="@name"/>&#160;<xsl:value-of select="../@value"/></a><br/>
  </xsl:for-each>
  <br/>
</xsl:for-each>

<xsl:apply-templates select="year"/>
</div>
</xsl:template>

<xsl:template match="year">
<h2>YEAR <xsl:value-of select="@value"/></h2>
  <xsl:apply-templates select="month"/>
</xsl:template>

<xsl:template match="month">
<a name="{@name}{../@value}"/>
<h3>MONTH <xsl:value-of select="@name"/><xsl:text> </xsl:text><xsl:value-of select="../@value"/></h3>
<table>
<tr>
<td align="left"><b>Day</b></td>
<td>&#160;</td>
<td><b>Hour</b></td>
<td>&#160;</td>
<td align="left"><b>Description</b></td>
</tr>
  <xsl:apply-templates select="entry"/>
</table>
</xsl:template>

<xsl:template match="entry">
<tr>
<td valign="top"><xsl:value-of select="@day"/>&#160;<xsl:value-of select="@name"/></td>
<td>&#160;</td>
<td valign="top"><xsl:value-of select="@hour"/></td>
<td>&#160;</td>
<td valign="top"><xsl:value-of select="."/></td>
</tr>
</xsl:template>

</xsl:stylesheet>
