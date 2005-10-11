<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
>

<xsl:import href="../../../../../xslt/authoring/edit/form.xsl"/>

<xsl:import href="xhtml-common.xsl"/>
<xsl:import href="unizh-common.xsl"/>

<xsl:template match="unizh:homepage">
<node name="Metadata"/>
<node name="Title" select="/unizh:homepage/lenya:meta/dc:title[@tagID='{lenya:meta/dc:title/@tagID}']">
  <content><input type="text" name="&lt;xupdate:update select=&quot;/unizh:homepage/lenya:meta/dc:title[@tagID='{lenya:meta/dc:title/@tagID}']&quot;&gt;" size="40"><xsl:attribute name="value"><xsl:value-of select="lenya:meta/dc:title"/></xsl:attribute></input></content>
</node>
<node name="DC Description" select="/unizh:homepage/lenya:meta/dc:description[@tagID='{lenya:meta/dc:description/@tagID}']">
  <content>
    <textarea name="&lt;xupdate:update select=&quot;/unizh:homepage/lenya:meta/dc:description[@tagID='{lenya:meta/dc:description/@tagID}']&quot;&gt;" cols="40" rows="5">
      <xsl:copy-of select="lenya:meta/dc:description/node()"/>
    </textarea>
  </content>
</node>
<node/>
<xsl:apply-templates select="xhtml:body"/>
<xsl:apply-templates select="rss-reader"/>
<node/>
<xsl:apply-templates select="unizh:related-content"/>

</xsl:template>

<xsl:template match="unizh:rss-reader" mode="body">
  <node name="RSS Feed" select="/*/unizh:rss-reader[@tagID='{@tagID}']">
    <action><delete name="&lt;xupdate:remove select=&quot;/*/unizh:rss-reader[@tagID='{@tagID}']&quot;/&gt;"/></action>
      <content>
        <textarea name="&lt;xupdate:update select=&quot;//unizh:rss-reader[@tagID='{@tagID}']/@url&quot;&gt;" cols="60">
           <xsl:value-of select="@url"/>
        </textarea>
     </content>
  </node>
  <node name="RSS: Number of items" select="/*/unizh:rss-reader[@tagID='{@tagID}']/@items"> 
    <content><input type="text" name="&lt;xupdate:update select=&quot;//unizh:rss-reader[@tagID='{@tagID}']/@items&quot;&gt;" size="40"><xsl:attribute name="value"><xsl:value-of select="@items"/></xsl:attribute></input></content>
  </node>
  <node name="RSS: Image">
    <content>
      Load appropriate image: 
      <xsl:choose>
        <xsl:when test="@image">
          <select name="&lt;xupdate:update select=&quot;/*/unizh:rss-reader[@tagID='{@tagID}']/@image&quot;&gt;">
            <xsl:choose>
              <xsl:when test="@image = 'true'">
                <option value="true" selected="selected">true</option>
                <option value="false">false</option>
              </xsl:when>
              <xsl:otherwise>
                <option value="true">true</option>
                <option value="false" selected="selected">false</option>
              </xsl:otherwise>
            </xsl:choose>
          </select>
        </xsl:when>
        <xsl:otherwise>
          <select name="&lt;xupdate:insert select=&quot;/*/unizh:rss-reader[@tagID='{@tagID}']/@image&quot;&gt;">
            <option value="true">true</option>
            <option value="false" selected="selected">false</option>
          </select>
        </xsl:otherwise>
      </xsl:choose>
    </content>
  </node>
<xsl:call-template name="insertmenu"><xsl:with-param name="path">/*/xhtml:body/unizh:rss-reader</xsl:with-param></xsl:call-template>
</xsl:template>
</xsl:stylesheet>  
