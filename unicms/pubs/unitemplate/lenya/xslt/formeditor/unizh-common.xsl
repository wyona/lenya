<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
>


<xsl:template match="unizh:highlights">
  <node name="Highlights">
  <!-- <action><delete value="true" name="&lt;xupdate:remove select=&quot;/*/unizh:highlights[@tagID='{@tagID}']&quot;/&gt;"/></action> -->
  </node>
  <xsl:apply-templates select="unizh:highlight"/>
  <node name="Highlight">
    <action><insert name="&lt;xupdate:append select=&quot;/*/unizh:highlights[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;unizh:highlight&quot; namespace=&quot;http://unizh.ch/doctypes/elements/1.0&quot;&gt;&lt;unizh:highlight-title xmlns:unizh=&quot;http://unizh.ch/doctypes/elements/1.0&quot;&gt;New title&lt;/unizh:highlight-title&gt;&lt;xhtml:p xmlns:xhtml=&quot;http://www.w3.org/1999/xhtml&quot;&gt;New content&lt;/xhtml:p&gt;&lt;/xupdate:element&gt;&lt;/xupdate:append&gt;"/></action>
  </node>
</xsl:template>


<xsl:template match="unizh:highlight">
  <node name="Highlight">
    <action><delete name="&lt;xupdate:remove select=&quot;/*/unizh:highlights/unizh:highlight[@tagID='{@tagID}']&quot;/&gt;"/></action>
  </node>
  <xsl:if test="not(unizh:highlight-title)">
    <node name="Highlight-title">
      <action><insert name="&lt;xupdate:append child=&quot;1&quot; select=&quot;/*/unizh:highlights/unizh:highlight[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;unizh:highlight-title&quot; namespace=&quot;http://unizh.ch/doctypes/elements/1.0&quot;&gt;New title&lt;/xupdate:element&gt;&lt;/xupdate:append&gt;"/></action>
    </node>
  </xsl:if>
  <xsl:apply-templates select="unizh:highlight-title"/>
  <xsl:apply-templates select="*" mode="highlight"/>
</xsl:template>


<xsl:template match="unizh:highlight-title">
  <node name="Title" select="/*/unizh:highlights/unizh:highlight/unizh:highlight-title[@tagID='{@tagID}']"> 
    <action><delete name="&lt;xupdate:remove select=&quot;//unizh:highlights/unizh:highlight/unizh:highlight-title[@tagID='{@tagID}']&quot;/&gt;"/></action>
    <content><input type="text" name="&lt;xupdate:update select=&quot;//unizh:highlights/unizh:highlight/unizh:highlight-title[@tagID='{@tagID}']&quot;&gt;" size="40"><xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute></input></content>
  </node>
  <xsl:call-template name="inserthighlightmenu"><xsl:with-param name="path">//unizh:highlights/unizh:highlight/unizh:highlight-title</xsl:with-param></xsl:call-template>
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
    <element name="Paragraph" xupdate="&lt;xupdate:insert-after select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:p&quot; {$nsxhtml}&gt;New Paragraph&lt;/xupdate:element&gt;&lt;/xupdate:insert-after&gt;"/>
    <element name="Headline 2" xupdate="&lt;xupdate:insert-after select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:h2&quot; {$nsxhtml}&gt;New Headline 2&lt;/xupdate:element&gt;&lt;/xupdate:insert-after&gt;"/>
    <element name="Headline 3" xupdate="&lt;xupdate:insert-after select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:h3&quot; {$nsxhtml}&gt;New Headline 3&lt;/xupdate:element&gt;&lt;/xupdate:insert-after&gt;"/>
    <element name="Headline 4" xupdate="&lt;xupdate:insert-after select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:h4&quot; {$nsxhtml}&gt;New Headline 4&lt;/xupdate:element&gt;&lt;/xupdate:insert-after&gt;"/>
  </insert-after>
</xsl:template>


<xsl:template name="insertbeforehighlightmenu">
  <xsl:param name="path"/>
  <xsl:variable name="nsxhtml">namespace=&quot;http://www.w3.org/1999/xhtml&quot;</xsl:variable>
  <xsl:variable name="nsunizh">namespace=&quot;http://unizh.ch/doctypes/elements/1.0&quot;</xsl:variable>
  <insert-before select="{$path}[@tagID='{@tagID}']">
    <element name="Paragraph" xupdate="&lt;xupdate:insert-before select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:p&quot; {$nsxhtml}&gt;New Paragraph&lt;/xupdate:element&gt;&lt;/xupdate:insert-before&gt;"/>
    <element name="Headline 2" xupdate="&lt;xupdate:insert-before select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:h2&quot; {$nsxhtml}&gt;New Headline 2&lt;/xupdate:element&gt;&lt;/xupdate:insert-before&gt;"/>
    <element name="Headline 3" xupdate="&lt;xupdate:insert-before select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:h3&quot; {$nsxhtml}&gt;New Headline 3&lt;/xupdate:element&gt;&lt;/xupdate:insert-before&gt;"/>
    <element name="Headline 4" xupdate="&lt;xupdate:insert-before select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:h4&quot; {$nsxhtml}&gt;New Headline 4&lt;/xupdate:element&gt;&lt;/xupdate:insert-before&gt;"/>
  </insert-before>
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


<xsl:template match="xhtml:p" mode="highlight">
  <xsl:if test="not(preceding-sibling::*)">
    <xsl:call-template name="insertbeforehighlightmenu"><xsl:with-param name="path">//unizh:highlights/unizh:highlight/xhtml:p</xsl:with-param>
    </xsl:call-template>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="xhtml:object">
      <xsl:apply-templates select="xhtml:object" mode="highlight"/>
    </xsl:when>
    <xsl:otherwise>
      <node name="Paragraph" select="//unizh:highlights/unizh:highlight/xhtml:p[@tagID='{@tagID}']">
        <action><delete value="true" name="&lt;xupdate:remove select=&quot;//unizh:highlights/unizh:highlight/xhtml:p[@tagID='{@tagID}']&quot;/&gt;"/></action>
        <content><textarea name="&lt;xupdate:update select=&quot;//unizh:highlights/unizh:highlight/xhtml:p[@tagID='{@tagID}']&quot;&gt;" cols="40" size="5"><xsl:value-of select="."/></textarea></content>
      </node>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="inserthighlightmenu"><xsl:with-param name="path">//unizh:highlights/unizh:highlight/xhtml:p</xsl:with-param></xsl:call-template>
</xsl:template>


<xsl:template match="xhtml:object" mode="highlight">
  <node name="Object" select="//unizh:highlights/unizh:highlight/xhtml:p/xhtml:object[@tagID='{@tagID}']">
    <action><delete name="&lt;xupdate:remove select=&quot;/*/unizh:highlights/unizh:highlight/xhtml:p/xhtml:object[@tagID='{@tagID}']&quot;/&gt;"/></action>
    <content>
      <div><xsl:value-of select="@data"/></div>
      <textarea name="&lt;xupdate:update select=&quot;/*/unizh:highlights/unizh:highlight/xhtml:p/xhtml:object[@tagID='{@tagID}']&quot;&gt;" cols="40" size="3"><xsl:value-of select="."/></textarea>
    </content>
  </node>
</xsl:template>


<xsl:template match="xhtml:h2" mode="highlight">
  <xsl:if test="not(preceding-sibling::*)">
    <xsl:call-template name="insertbeforehighlightmenu"><xsl:with-param name="path">//unizh:highlights/unizh:highlight/xhtml:h2</xsl:with-param>
    </xsl:call-template>
  </xsl:if>
  <node name="Headline 2" select="//unizh:highlights/unizh:highlight/xhtml:h2[@tagID='{@tagID}']">
    <action><delete value="true" name="&lt;xupdate:remove select=&quot;//unizh:highlights/unizh:highlight/xhtml:h2[@tagID='{@tagID}']&quot;/&gt;"/></action>
    <content><textarea name="&lt;xupdate:update select=&quot;//unizh:highlights/unizh:highlight/xhtml:h2[@tagID='{@tagID}']&quot;&gt;" cols="40" size="5"><xsl:value-of select="."/></textarea></content>
  </node>
  <xsl:call-template name="inserthighlightmenu"><xsl:with-param name="path">//unizh:highlights/unizh:highlight/xhtml:h2</xsl:with-param></xsl:call-template>
</xsl:template>


<xsl:template match="xhtml:h3" mode="highlight">
  <xsl:if test="not(preceding-sibling::*)">
    <xsl:call-template name="insertbeforehighlightmenu"><xsl:with-param name="path">//unizh:highlights/unizh:highlight/xhtml:h3</xsl:with-param>
    </xsl:call-template>
  </xsl:if>
  <node name="Headline 3" select="//unizh:highlights/unizh:highlight/xhtml:h3[@tagID='{@tagID}']">
    <action><delete value="true" name="&lt;xupdate:remove select=&quot;//unizh:highlights/unizh:highlight/xhtml:h3[@tagID='{@tagID}']&quot;/&gt;"/></action>
    <content><textarea name="&lt;xupdate:update select=&quot;//unizh:highlights/unizh:highlight/xhtml:h3[@tagID='{@tagID}']&quot;&gt;" cols="40" size="5"><xsl:value-of select="."/></textarea></content>
  </node>
  <xsl:call-template name="inserthighlightmenu"><xsl:with-param name="path">//unizh:highlights/unizh:highlight/xhtml:h3</xsl:with-param></xsl:call-template>
</xsl:template>


<xsl:template match="xhtml:h4" mode="highlight">
  <xsl:if test="not(preceding-sibling::*)">
    <xsl:call-template name="insertbeforehighlightmenu"><xsl:with-param name="path">//unizh:highlights/unizh:highlight/xhtml:h4</xsl:with-param>
    </xsl:call-template>
  </xsl:if>
  <node name="Headline 4" select="//unizh:highlights/unizh:highlight/xhtml:h4[@tagID='{@tagID}']">
    <action><delete value="true" name="&lt;xupdate:remove select=&quot;//unizh:highlights/unizh:highlight/xhtml:h4[@tagID='{@tagID}']&quot;/&gt;"/></action>
    <content><textarea name="&lt;xupdate:update select=&quot;//unizh:highlights/unizh:highlight/xhtml:h4[@tagID='{@tagID}']&quot;&gt;" cols="40" size="5"><xsl:value-of select="."/></textarea></content>
  </node>
  <xsl:call-template name="inserthighlightmenu"><xsl:with-param name="path">//unizh:highlights/unizh:highlight/xhtml:h4</xsl:with-param></xsl:call-template>
</xsl:template>


<xsl:template match="lenya:asset" mode="highlight">
  <node name="Asset">
    <action>
      <delete name="&lt;xupdate:remove select=&quot;//unizh:highlights/unizh:highlight/lenya:asset[@tagID='{@tagID}']&quot;/&gt;"/>
    </action>
    <content>
      <input type="text" name="&lt;xupdate:update select=&quot;//unizh:highlights/unizh:highlight/lenya:asset[@tagID='{@tagID}']&quot;&gt;" size="60">
        <xsl:attribute name="value">
           <xsl:value-of select="@src"/>
        </xsl:attribute>
      </input>
    </content>
  </node>
</xsl:template>

</xsl:stylesheet>  
