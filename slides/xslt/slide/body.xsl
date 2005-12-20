<?xml version="1.0" encoding="iso-8859-1"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:s="http://www.oscom.org/2002/SlideML/0.9/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<!--
	xmlns="http://www.w3.org/1999/xhtml"
-->

<xsl:output method="html" encoding="iso-8859-1"/>
 

<xsl:template match="s:slide">
<font face="verdana">
<table border="0">
<tr>
<td valign="top">
<img src="../images/wyona_klein.gif" alt="Wyona"/>
<!--
<img src="../images/apache_lenya.png" alt="Apache Lenya"/>
-->
<!--
<img src="../images/lenya_org.gif" alt="lenya.org"/>
-->
<!--
<img src="../images/logo.gif" alt="OSCOM 2"/>
-->
</td>
<td valign="middle">
&#160;
<!--
<img src="../images/cocoon.gif"/>
-->
<!--
<img src="../images/title.gif"/>
-->
</td>
<td>
&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
</td>
<td valign="top">

<xsl:variable name="previous-id"><xsl:value-of select="preceding-sibling::s:slide[position() = 1]/@id"/></xsl:variable>
<xsl:variable name="next-id"><xsl:value-of select="following-sibling::s:slide[position() = 1]/@id"/></xsl:variable>

<xsl:if test="not(/s:slideset/show-only-one-slide)">
<!-- PREVIOUS | NEXT -->
<xsl:if test="preceding-sibling::s:slide">
<!--
<xsl:value-of select="$previous-id"/>
-->
<a href="#{$previous-id}"><img src="../images/left.gif" border="0"/></a>
<!--
<xsl:apply-templates select="preceding-sibling::s:slide[position() = 1]" mode="previous"/>
-->
</xsl:if>
<!--
<xsl:if test="preceding-sibling::s:slide and following-sibling::s:slide">
-->
&#160;|&#160;<a href="{$presentation}.html#toc">ToC</a>&#160;|&#160;<a href="{$presentation}-slide-{@id}.html">HTML</a>&#160;|&#160;
<!--
</xsl:if>
-->
<xsl:if test="following-sibling::s:slide">
<a href="#{$next-id}"><img src="../images/right.gif" border="0"/></a>
<!--
<xsl:value-of select="$next-id"/>
-->
<!--
<xsl:apply-templates select="following-sibling::s:slide[position() = 1]" mode="next"/>
-->
</xsl:if>
<!-- /PREVIOUS | NEXT -->
</xsl:if>

<xsl:if test="/s:slideset/show-only-one-slide">
<!-- PREVIOUS | NEXT -->
<xsl:if test="preceding-sibling::s:slide">
<xsl:apply-templates select="preceding-sibling::s:slide[position() = 1]" mode="previous"/>
</xsl:if>
&#160;| <a href="{$presentation}.html">ToC</a> |&#160;
<xsl:if test="following-sibling::s:slide">
<xsl:apply-templates select="following-sibling::s:slide[position() = 1]" mode="next"/>
</xsl:if>
<!-- /PREVIOUS | NEXT -->
</xsl:if>

</td>
</tr>
</table>

<font color="#cc9933" face="verdana, sans-serif">
<h1><xsl:value-of select="s:title"/></h1>
</font>
<xsl:apply-templates select="s:content"/>

<xsl:call-template name="footer"/>
</font>
</xsl:template>





<xsl:template match="s:content">
<font size="+2" face="verdana, sans-serif">
<xsl:apply-templates/>


<!--
<xsl:copy-of select="*"/>
-->
<!--
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:apply-templates/>
	</xsl:copy>
-->
</font>
</xsl:template>








<xsl:template match="s:slide" mode="previous">
<!--
<a href="#{@id}"><img src="../images/left.gif" border="0"/></a>
-->
<a href="{$presentation}-slide-{@id}.html"><img src="../images/left.gif" border="0"/></a>
</xsl:template>
<xsl:template match="s:slide" mode="next">
<!--
<a href="#{@id}"><img src="../images/right.gif" border="0"/></a>
-->
<a href="{$presentation}-slide-{@id}.html"><img src="../images/right.gif" border="0"/></a>
</xsl:template>



<xsl:template name="footer">
<p>
<!--
<a href="mailto:{/s:slideset/s:metadata/s:author/s:email}"><xsl:value-of select="/s:slideset/s:metadata/s:author/s:name"/></a>, Distributed Content Management using P2P, OSCOM Berkeley 2002
-->
<a href="mailto:{/s:slideset/s:metadata/s:author/s:email}"><xsl:value-of select="/s:slideset/s:metadata/s:author/s:name"/></a>, <xsl:value-of select="/s:slideset/s:metadata/s:title"/>, <xsl:value-of select="/s:slideset/s:metadata/s:confgroup/s:conftitle"/>
</p>
</xsl:template>



<xsl:template match="source">
  <div align="left">
    <table cellspacing="0" cellpadding="0" border="0">
      <tr>
        <td bgcolor="#0086b2" width="1" height="1">
          <img src="../images/void.gif" width="1" height="1" vspace="0" hspace="0" border="0"/>
        </td>
        <td bgcolor="#0086b2" width="15" height="1">
          <img src="../images/void.gif" width="1" height="1" vspace="0" hspace="0" border="0"/>
        </td>
        <td bgcolor="#0086b2" height="1">
          <img src="../images/void.gif" width="1" height="1" vspace="0" hspace="0" border="0"/>
        </td>
        <td bgcolor="#0086b2" width="15" height="1">
          <img src="../images/void.gif" width="1" height="1" vspace="0" hspace="0" border="0"/>
        </td>
        <td bgcolor="#0086b2" width="1" height="1">
          <img src="../images/void.gif" width="1" height="1" vspace="0" hspace="0" border="0"/>
        </td>
      </tr>

      <tr>
        <td bgcolor="#0086b2" width="1">
           <img src="../images/void.gif" width="1" height="1" vspace="0" hspace="0" border="0"/>
        </td>
        <td bgcolor="#ffffff" width="15" height="1">
          <img src="../images/void.gif" width="1" height="1" vspace="0" hspace="0" border="0"/>
        </td>
        <td bgcolor="#ffffff">
            <pre><xsl:apply-templates/></pre>
        </td>
        <td bgcolor="#ffffff" width="15" height="1">
          <img src="../images/void.gif" width="1" height="1" vspace="0" hspace="0" border="0"/>
        </td>
        <td bgcolor="#0086b2" width="1">
          <img src="../images/void.gif" width="1" height="1" vspace="0" hspace="0" border="0"/>
        </td>
      </tr>


      <tr>
        <td bgcolor="#0086b2" width="1" height="1">
          <img src="../images/void.gif" width="1" height="1" vspace="0" hspace="0" border="0"/>
        </td>
        <td bgcolor="#0086b2" width="15" height="1">
          <img src="../images/void.gif" width="1" height="1" vspace="0" hspace="0" border="0"/>
        </td>
        <td bgcolor="#0086b2" height="1">
          <img src="../images/void.gif" width="1" height="1" vspace="0" hspace="0" border="0"/>
        </td>
        <td bgcolor="#0086b2" width="15" height="1">
          <img src="../images/void.gif" width="1" height="1" vspace="0" hspace="0" border="0"/>
        </td>
        <td bgcolor="#0086b2" width="1" height="1">
          <img src="../images/void.gif" width="1" height="1" vspace="0" hspace="0" border="0"/>
        </td>
      </tr>
    </table>
  </div>
</xsl:template>

<xsl:template match="ol">
<ul>
<xsl:apply-templates/>
</ul>
</xsl:template>

  <xsl:template match="* | @*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>



</xsl:stylesheet>
