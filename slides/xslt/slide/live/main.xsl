<?xml version="1.0"?> 

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="html" indent="yes" encoding="ISO-8859-1"/>

<xsl:template match="/">
<HTML>
<HEAD>
  <TITLE><xsl:value-of select="Slide/Meta/Title"/></TITLE>
</HEAD>
<BODY BGCOLOR="#ffffff">
<TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0">
<TR>
  <TD COLSPAN="2" HEIGHT="10">
    &#160;
  </TD>
</TR>
<TR>
  <TD VALIGN="top" colspan="2">
<!--
    <IMG SRC="../images/wyona_klein.gif" ALT="Wyona"/>
-->
    <IMG SRC="../images/apache_lenya.png" ALT="Apache Lenya"/>
<!--
    <IMG SRC="../images/lenya_org.gif" ALT="lenya.org"/>
-->
  </TD>
</TR>
<TR>
  <TD ALIGN="right" VALIGN="bottom" colspan="2">
    <xsl:apply-templates select="Slide/Navigation"/>
  </TD>
</TR>
<TR>
  <TD COLSPAN="2" HEIGHT="20">
    &#160;
  </TD>
</TR>
<TR>
  <TD COLSPAN="2" VALIGN="top">
    <xsl:apply-templates select="Slide/Content"/>
    <xsl:apply-templates select="Slide/Contents"/>
  </TD>
</TR>
<TR>
  <TD COLSPAN="2" VALIGN="top">
    &#160;<BR/><HR/>
  </TD>
</TR>
<TR>
  <TD COLSPAN="2">
    <FONT SIZE="-1">
    <A><xsl:attribute name="HREF"><xsl:value-of select="Slide/Meta/Author/Webpage"/></xsl:attribute><xsl:value-of select="Slide/Meta/Author/FirstName"/>&#160;<xsl:value-of select="Slide/Meta/Author/LastName"/></A>&#160;&#160;<xsl:value-of select="Slide/Meta/Occasion"/>&#160;&#160;<xsl:apply-templates select="Slide/Meta/Date"/>
    </FONT>
  </TD>
</TR>
</TABLE>
</BODY>
</HTML>
</xsl:template>

<xsl:template match="Navigation">
  <xsl:apply-templates select="Previous"/>&#160;<xsl:apply-templates select="Next"/>&#160;<a href="index.html">contents</a>
</xsl:template>

<xsl:template match="Content">
  <H1><FONT FACE="Geneva, Arial"><xsl:value-of select="./Title"/></FONT></H1>
  <xsl:for-each select="./Images/Image">
    <IMG><xsl:attribute name="SRC">../images/<xsl:value-of select="HRef"/></xsl:attribute></IMG>
  </xsl:for-each>
  <UL>
  <xsl:for-each select="./Points/Point">
    <LI>
    <xsl:apply-templates select="."/>
    </LI>
  </xsl:for-each>
  </UL>
  
  <xsl:apply-templates select="Document"/>
</xsl:template>

<xsl:template match="Previous">
  <a><xsl:attribute name="href"><xsl:value-of select="."/>.html</xsl:attribute>previous</a>&#160;|
</xsl:template>

<xsl:template match="Next">
  <a><xsl:attribute name="href"><xsl:value-of select="."/>.html</xsl:attribute>next</a>&#160;|
</xsl:template>

<xsl:template match="Keywords">
  <FONT SIZE="+2" FACE="Geneva, Arial"><xsl:apply-templates/></FONT><BR/>&#160;
</xsl:template>

<xsl:template match="Comments">
  <!--<P><xsl:apply-templates/></P>-->
</xsl:template>

<xsl:template match="Date">
  <xsl:value-of select="Year"/>&#160;<xsl:value-of select="Month/@Name"/>&#160;<xsl:value-of select="Day"/>
</xsl:template>

<xsl:template match="Contents">
  <H1><FONT FACE="Geneva, Arial">Contents</FONT></H1>
  <FONT SIZE="+2" FACE="Geneva, Arial">
  <UL>
  <xsl:for-each select="./Slide">
    <LI>
    <A><xsl:attribute name="HREF"><xsl:value-of select="./Id"/>.html</xsl:attribute><xsl:apply-templates select="./Title"/></A><BR/>&#160;
    </LI>
  </xsl:for-each>
  </UL>
  </FONT>
</xsl:template>

<xsl:template match="Document">
  <P>
  <TABLE CELLPADDING="10" WIDTH="600">
    <TR>
      <TD BGCOLOR="#dddddd">
      &#060;?xml version="1.0"?&#062;
      <BR/>
      <xsl:apply-templates/>
      </TD>
    </TR>
  </TABLE>
  </P>
</xsl:template>

<xsl:template match="Element">
  <BR/>&#060;<xsl:value-of select="./@Name"/>
  <xsl:for-each select="./Attribute">
    &#160;<xsl:value-of select="./@Name"/>="<xsl:value-of select="."/>"
  </xsl:for-each>&#062;

  <xsl:apply-templates/>

  &#060;/<xsl:value-of select="./@Name"/>&#062;
</xsl:template>

<xsl:template match="EmptyElement">
  <BR/>&#060;<xsl:value-of select="./@Name"/>
  <xsl:for-each select="./Attribute">
    &#160;<xsl:value-of select="./@Name"/>="<xsl:value-of select="."/>"
  </xsl:for-each>/&#062;
</xsl:template>

<xsl:template match="Attribute">
</xsl:template>

</xsl:stylesheet>
