<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
>

<xsl:import href="../../../../../xslt/authoring/edit/form.xsl"/>
<xsl:import href="unizh-common.xsl"/>

<xsl:template match="unizh:news">
<node name="Title" select="/unizh:news/lenya:meta/dc:title[@tagID='{lenya:meta/dc:title/@tagID}']">
  <content><input type="text" name="&lt;xupdate:update select=&quot;/unizh:news/lenya:meta/dc:title[@tagID='{lenya:meta/dc:title/@tagID}']&quot;&gt;" size="40"><xsl:attribute name="value"><xsl:value-of select="lenya:meta/dc:title"/></xsl:attribute></input></content>
</node>


<xsl:apply-templates select="xhtml:body"/>

<xsl:choose>
   <xsl:when test="@unizh:columns = '3'">
      <xsl:apply-templates select="unizh:related-content"/>
   </xsl:when>
   <xsl:otherwise/>
</xsl:choose>   

</xsl:template>

<xsl:template match="xhtml:body">
  <node name="Body"/>
  <xsl:apply-templates mode="body"/> -->
</xsl:template>

<xsl:template name="insertbeforemenu">
  <xsl:param name="path"/>
  <xsl:variable name="nsxhtml">namespace=&quot;http://www.w3.org/1999/xhtml&quot;</xsl:variable>
  <xsl:variable name="nsunizh">namespace=&quot;http://unizh.ch/doctypes/elements/1.0&quot;</xsl:variable>
  <insert-before select="{$path}[@tagID='{@tagID}']">
    <element name="Paragraph" xupdate="&lt;xupdate:insert-before select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:p&quot; {$nsxhtml}&gt;New Paragraph&lt;/xupdate:element&gt;&lt;/xupdate:insert-before&gt;"/>
  </insert-before>
</xsl:template>

<xsl:template name="insertmenu">
  <xsl:param name="path"/>
  <xsl:variable name="nsxhtml">namespace=&quot;http://www.w3.org/1999/xhtml&quot;</xsl:variable>
  <xsl:variable name="nsunizh">namespace=&quot;http://unizh.ch/doctypes/elements/1.0&quot;</xsl:variable>
  <insert-after select="{$path}[@tagID='{@tagID}']">
    <element name="Paragraph" xupdate="&lt;xupdate:insert-after select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:p&quot; {$nsxhtml}&gt;New Paragraph&lt;/xupdate:element&gt;&lt;/xupdate:insert-after&gt;"/>
  </insert-after>
</xsl:template>


<xsl:template match="xhtml:p" mode="body">
  <xsl:if test="not(preceding-sibling::*)">
  <xsl:call-template name="insertbeforemenu"><xsl:with-param name="path">/*/xhtml:body/xhtml:p</xsl:with-param></xsl:call-template>
  </xsl:if>
  <xsl:choose >
    <xsl:when test="xhtml:object">
      <xsl:apply-templates select="xhtml:object" mode="body"/>
    </xsl:when>
    <xsl:otherwise>
      <node name="Paragraph" select="/*/xhtml:body/xhtml:p[@tagID='{@tagID}']">
        <action><delete name="&lt;xupdate:remove select=&quot;/*/xhtml:body/xhtml:p[@tagID='{@tagID}']&quot;/&gt;"/></action>
        <content>
          <textarea name="&lt;xupdate:update select=&quot;/*/xhtml:body/xhtml:p[@tagID='{@tagID}']&quot;&gt;" cols="60" rows="30">
            <xsl:copy-of select="node()"/>
          </textarea>
        </content>
      </node>
    </xsl:otherwise>
  </xsl:choose>
<!--  <xsl:call-template name="insertmenu"><xsl:with-param
  name="path">/*/xhtml:body/xhtml:p</xsl:with-param></xsl:call-template> -->
</xsl:template>

</xsl:stylesheet>  
