<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
>

<xsl:template match="unizh:related-content">
  <node name="Related Content">
  <!-- <action><delete value="true" name="&lt;xupdate:remove select=&quot;/*/unizh:related-content[@tagID='{@tagID}']&quot;/&gt;"/></action> -->
  </node>
  <xsl:apply-templates select="unizh:teaser"/>
  <xsl:apply-templates select="unizh:rss-reader"/>
  <node name="Teaser">
    <action><insert name="&lt;xupdate:append select=&quot;/*/unizh:related-content[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;unizh:teaser&quot; namespace=&quot;http://unizh.ch/doctypes/elements/1.0&quot;&gt;&lt;unizh:title xmlns:unizh=&quot;http://unizh.ch/doctypes/elements/1.0&quot;&gt;Title&lt;/unizh:title&gt;&lt;xhtml:p xmlns:xhtml=&quot;http://www.w3.org/1999/xhtml&quot;&gt;Teaser text&lt;/xhtml:p&gt;&lt;/xupdate:element&gt;&lt;/xupdate:append&gt;"/></action>
  </node>
</xsl:template>


<xsl:template match="unizh:teaser">
  <node name="Teaser">
    <action><delete name="&lt;xupdate:remove select=&quot;/*/unizh:related-content/unizh:teaser[@tagID='{@tagID}']&quot;/&gt;"/></action>
  </node>
  <xsl:if test="not(unizh:title)">
    <node name="Teaser-title">
      <action><insert name="&lt;xupdate:append child=&quot;1&quot; select=&quot;/*/unizh:related-content/unizh:teaser[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;unizh:title&quot; namespace=&quot;http://unizh.ch/doctypes/elements/1.0&quot;&gt;New title&lt;/xupdate:element&gt;&lt;/xupdate:append&gt;"/></action>
    </node>
  </xsl:if>
  <xsl:apply-templates select="unizh:title"/>
  <xsl:apply-templates select="*" mode="teaser"/>
  <xsl:call-template name="inserthighlightmenu"><xsl:with-param name="path">//unizh:related-content/unizh:teaser</xsl:with-param></xsl:call-template>
</xsl:template>

<xsl:template match="unizh:rss-reader">
  <node name="RSS Feed">
    <action><delete name="&lt;xupdate:remove select=&quot;/*/unizh:related-content/unizh:rss-reader[@tagID='{@tagID}']&quot;/&gt;"/></action>
  </node>
<node name="rss url" select="/*/unizh:related-content/unizh:rss-reader[@tagID='{@tagID}']"> 
    <content><input type="text" name="&lt;xupdate:update select=&quot;//unizh:related-content/unizh:rss-reader[@tagID='{@tagID}']/@url&quot;&gt;" size="40"><xsl:attribute name="value"><xsl:value-of select="@url"/></xsl:attribute></input></content>
  </node>
  <node name="Number of items" select="/*/unizh:related-content/unizh:rss-reader[@tagID='{@tagID}']"> 
    <content><input type="text" name="&lt;xupdate:update select=&quot;//unizh:related-content/unizh:rss-reader[@tagID='{@tagID}']/@items&quot;&gt;" size="40"><xsl:attribute name="value"><xsl:value-of select="@items"/></xsl:attribute></input></content>
  </node><node name="Image">
    <content>
      Load appropriate image: 
      <xsl:choose>
        <xsl:when test="@image">
          <select name="&lt;xupdate:update select=&quot;/*/unizh:related-content/unizh:rss-reader[@tagID='{@tagID}']/@image&quot;&gt;">
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
          <select name="&lt;xupdate:insert select=&quot;/*/unizh:related-content/unizh:rss-reader[@tagID='{@tagID}']/@image&quot;&gt;">
            <option value="true">true</option>
            <option value="false" selected="selected">false</option>
          </select>
        </xsl:otherwise>
      </xsl:choose>
    </content>
  </node>
</xsl:template>


<xsl:template match="unizh:title">
  <node name="Title" select="/*/unizh:related-content/unizh:teaser/unizh:title[@tagID='{@tagID}']"> 
    <content><input type="text" name="&lt;xupdate:update select=&quot;//unizh:related-content/unizh:teaser/unizh:title[@tagID='{@tagID}']&quot;&gt;" size="40"><xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute></input></content>
  </node>
</xsl:template>


<xsl:template match="unizh:slogan">
  <node name="Slogan" select="/*/unizh:slogan[@tagID='{@tagID}']">
    <content><input type="text" name="&lt;xupdate:update select=&quot;/*/unizh:slogan[@tagID='{@tagID}']&quot;&gt;" size="40"><xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute></input></content>
  </node>
</xsl:template>

    
<xsl:template match="*[local-name()='toc']" mode="body">
  <node name="Table of Contents">
    <action><delete name="&lt;xupdate:remove select=&quot;/*/unizh:toc[@tagID='{@tagID}']&quot;/&gt;"/></action>
  </node>
  <xsl:call-template name="insertmenu"><xsl:with-param name="path">/*/xhtml:body/unizh:toc</xsl:with-param></xsl:call-template>
</xsl:template>


<xsl:template name="inserthighlightmenu">
  <xsl:param name="path"/>
  <xsl:variable name="nsxhtml">namespace=&quot;http://www.w3.org/1999/xhtml&quot;</xsl:variable>
  <xsl:variable name="nsunizh">namespace=&quot;http://unizh.ch/doctypes/elements/1.0&quot;</xsl:variable>
  <insert-after select="{$path}[@tagID='{@tagID}']">
    <element name="New Teaser" xupdate="&lt;xupdate:insert-after select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;unizh:teaser&quot; namespace=&quot;http://unizh.ch/doctypes/elements/1.0&quot;&gt;&lt;unizh:title xmlns:unizh=&quot;http://unizh.ch/doctypes/elements/1.0&quot;&gt;New title&lt;/unizh:title&gt;&lt;xhtml:p xmlns:xhtml=&quot;http://www.w3.org/1999/xhtml&quot;&gt;New content&lt;/xhtml:p&gt;&lt;/xupdate:element&gt;&lt;/xupdate:insert-after&gt;"/>
   <element name="New RSS-Feed" xupdate="&lt;xupdate:insert-after select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;unizh:rss-reader&quot; {$nsunizh}&gt;&lt;xupdate:attribute name=&quot;image&quot;&gt;false&lt;/xupdate:attribute&gt;&lt;xupdate:attribute name=&quot;items&quot;&gt;3&lt;/xupdate:attribute&gt;&lt;xupdate:attribute name=&quot;url&quot;&gt;empty&lt;/xupdate:attribute&gt;#rss-reader&lt;/xupdate:element&gt;&lt;/xupdate:insert-after&gt;"/>
  </insert-after>
</xsl:template>

<xsl:template match="*[local-name()='children']" mode="body">
  <node name="Children">
    <action><delete name="&lt;xupdate:remove select=&quot;/*/xhtml:body/unizh:children[@tagID='{@tagID}']&quot;/&gt;"/></action>
  <!--
  </node>
  <node name="Abstracts" select="/*/xhtml:table[@tagID='{@tagID}']/@abstracts">
  -->
    <content>
      Abstracts: 
      <xsl:choose>
        <xsl:when test="@abstracts">
          <select name="&lt;xupdate:update select=&quot;/*/xhtml:body/unizh:children[@tagID='{@tagID}']/@abstracts&quot;&gt;">
            <xsl:choose>
              <xsl:when test="@abstracts = 'true'">
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
          <select name="&lt;xupdate:insert select=&quot;/*/xhtml:body/unizh:children[@tagID='{@tagID}']/@abstracts&quot;&gt;">
            <option value="true">true</option>
            <option value="false" selected="selected">false</option>
          </select>
        </xsl:otherwise>
      </xsl:choose>
    </content>
  </node>
  <xsl:call-template name="insertmenu"><xsl:with-param name="path">/*/xhtml:body/unizh:children</xsl:with-param></xsl:call-template>
</xsl:template>


<xsl:template match="xhtml:p" mode="teaser">
  <xsl:choose>
    <xsl:when test="xhtml:object">
      <xsl:apply-templates select="xhtml:object" mode="teaser"/>
    </xsl:when>
    <xsl:otherwise>
      <node name="Paragraph" select="//unizh:related-content/unizh:teaser/xhtml:p[@tagID='{@tagID}']">
        <action><delete value="true" name="&lt;xupdate:remove select=&quot;//unizh:related-content/unizh:teaser/xhtml:p[@tagID='{@tagID}']&quot;/&gt;"/></action>
        <content><textarea name="&lt;xupdate:update select=&quot;//unizh:related-content/unizh:teaser/xhtml:p[@tagID='{@tagID}']&quot;&gt;" cols="40" size="5"><xsl:value-of select="."/></textarea></content>
      </node>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="xhtml:object" mode="teaser">
  <node name="Object" select="//unizh:related-content/unizh:teaser/xhtml:p/xhtml:object[@tagID='{@tagID}']">
    <action><delete name="&lt;xupdate:remove select=&quot;/*/unizh:related-content/unizh:teaser/xhtml:p/xhtml:object[@tagID='{@tagID}']&quot;/&gt;"/></action>
    <content>
      <div><xsl:value-of select="@data"/></div>
      <textarea name="&lt;xupdate:update select=&quot;/*/unizh:related-content/unizh:teaser/xhtml:p/xhtml:object[@tagID='{@tagID}']&quot;&gt;" cols="40" size="3"><xsl:value-of select="."/></textarea>
    </content>
  </node>
</xsl:template>


<xsl:template match="lenya:asset" mode="teaser">
  <node name="Asset">
    <action>
      <delete name="&lt;xupdate:remove select=&quot;//unizh:related-content/unizh:teaser/lenya:asset[@tagID='{@tagID}']&quot;/&gt;"/>
    </action>
    <content>
      <input type="text" name="&lt;xupdate:update select=&quot;//unizh:related-content/unizh:teaser/lenya:asset[@tagID='{@tagID}']&quot;&gt;" size="60">
        <xsl:attribute name="value">
           <xsl:value-of select="@src"/>
        </xsl:attribute>
      </input>
    </content>
  </node>
</xsl:template>

</xsl:stylesheet>  
