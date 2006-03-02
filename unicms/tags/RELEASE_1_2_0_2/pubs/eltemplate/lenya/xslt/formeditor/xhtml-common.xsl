<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
>

<xsl:template match="xhtml:body">
  <node name="Body" />
  <xsl:apply-templates mode="body"/>
  <!--<xsl:call-template name="appendmenu"><xsl:with-param name="path">/*/xhtml:body</xsl:with-param></xsl:call-template>-->
</xsl:template>



<xsl:template name="insertbeforemenu">
  <xsl:param name="path"/>
  <xsl:variable name="nsxhtml">namespace=&quot;http://www.w3.org/1999/xhtml&quot;</xsl:variable>
  <insert-before select="{$path}[@tagID='{@tagID}']">
    <element name="Paragraph" xupdate="&lt;xupdate:insert-before select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:p&quot; {$nsxhtml}&gt;New Paragraph&lt;/xupdate:element&gt;&lt;/xupdate:insert-before&gt;"/>
    <element name="Table" xupdate="&lt;xupdate:insert-before select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:table&quot; {$nsxhtml}&gt;&lt;tr&gt;&lt;td&gt;New Table&lt;/td&gt;&lt;/tr&gt;&lt;xupdate:attribute name=&quot;class&quot;&gt;basic&lt;/xupdate:attribute&gt;&lt;/xupdate:element&gt;&lt;/xupdate:insert-before&gt;"/>
    <element name="Unordered List" xupdate="&lt;xupdate:insert-before select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:ul&quot; {$nsxhtml}&gt;&lt;li&gt;New Unordered List&lt;/li&gt;&lt;xupdate:attribute name=&quot;class&quot;&gt;type1&lt;/xupdate:attribute&gt;&lt;/xupdate:element&gt;&lt;/xupdate:insert-before&gt;"/>
    <element name="Ordered List" xupdate="&lt;xupdate:insert-before select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:ol&quot; {$nsxhtml}&gt;&lt;li&gt;New Ordered List&lt;/li&gt;&lt;xupdate:attribute name=&quot;class&quot;&gt;type1&lt;/xupdate:attribute&gt;&lt;/xupdate:element&gt;&lt;/xupdate:insert-before&gt;"/>
    <element name="Headline 2" xupdate="&lt;xupdate:insert-before select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:h2&quot; {$nsxhtml}&gt;New Headline 2&lt;/xupdate:element&gt;&lt;/xupdate:insert-before&gt;"/>
    <element name="Headline 3" xupdate="&lt;xupdate:insert-before select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:h3&quot; {$nsxhtml}&gt;New Headline 3&lt;/xupdate:element&gt;&lt;/xupdate:insert-before&gt;"/>
    <element name="Headline 4" xupdate="&lt;xupdate:insert-before select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:h4&quot; {$nsxhtml}&gt;New Headline 4&lt;/xupdate:element&gt;&lt;/xupdate:insert-before&gt;"/>
  </insert-before>
</xsl:template>



<xsl:template name="insertmenu">
  <xsl:param name="path"/>
  <xsl:variable name="nsxhtml">namespace=&quot;http://www.w3.org/1999/xhtml&quot;</xsl:variable>
  <xsl:variable name="nsunizh">namespace=&quot;http://unizh.ch/doctypes/elements/1.0&quot;</xsl:variable>
  <insert-after select="{$path}[@tagID='{@tagID}']">
    <element name="Paragraph" xupdate="&lt;xupdate:insert-after select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:p&quot; {$nsxhtml}&gt;New Paragraph&lt;/xupdate:element&gt;&lt;/xupdate:insert-after&gt;"/>
    <element name="Table" xupdate="&lt;xupdate:insert-after select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:table&quot; {$nsxhtml}&gt;&lt;tr&gt;&lt;td&gt;New Table&lt;/td&gt;&lt;/tr&gt;&lt;xupdate:attribute name=&quot;class&quot;&gt;basic&lt;/xupdate:attribute&gt;&lt;/xupdate:element&gt;&lt;/xupdate:insert-after&gt;"/>
    <element name="Unordered List" xupdate="&lt;xupdate:insert-after select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:ul&quot; {$nsxhtml}&gt;&lt;li&gt;New Unordered List&lt;/li&gt;&lt;xupdate:attribute name=&quot;class&quot;&gt;type1&lt;/xupdate:attribute&gt;&lt;/xupdate:element&gt;&lt;/xupdate:insert-after&gt;"/>
    <element name="Ordered List" xupdate="&lt;xupdate:insert-after select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:ol&quot; {$nsxhtml}&gt;&lt;li&gt;New Ordered List&lt;/li&gt;&lt;xupdate:attribute name=&quot;class&quot;&gt;type1&lt;/xupdate:attribute&gt;&lt;/xupdate:element&gt;&lt;/xupdate:insert-after&gt;"/>
    <element name="Headline 2" xupdate="&lt;xupdate:insert-after select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:h2&quot; {$nsxhtml}&gt;New Headline 2&lt;/xupdate:element&gt;&lt;/xupdate:insert-after&gt;"/>
    <element name="Headline 3" xupdate="&lt;xupdate:insert-after select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:h3&quot; {$nsxhtml}&gt;New Headline 3&lt;/xupdate:element&gt;&lt;/xupdate:insert-after&gt;"/>
    <element name="Headline 4" xupdate="&lt;xupdate:insert-after select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;xhtml:h4&quot; {$nsxhtml}&gt;New Headline 4&lt;/xupdate:element&gt;&lt;/xupdate:insert-after&gt;"/>
    <element name="Table of Contents" xupdate="&lt;xupdate:insert-after select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;unizh:toc&quot; {$nsunizh}&gt;&lt;/xupdate:element&gt;&lt;/xupdate:insert-after&gt;"/>
    <element name="Children" xupdate="&lt;xupdate:insert-after select=&quot;{$path}[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;unizh:children&quot; {$nsunizh}&gt;&lt;/xupdate:element&gt;&lt;/xupdate:insert-after&gt;"/>
  </insert-after>
</xsl:template>


<xsl:template match="xhtml:p" mode="body">
  <xsl:call-template name="insertbeforemenu"><xsl:with-param name="path">/*/xhtml:body/xhtml:p</xsl:with-param></xsl:call-template>
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
</xsl:template>


<xsl:template match="xhtml:table" mode="body">
  <!-- NOTE: attribute could also be edited separately -->
  <!--
  <node name="Table Class" select="/*/xhtml:body/xhtml:table[@tagID='{@tagID}']/@class">
    <content>
      <textarea name="&lt;xupdate:update select=&quot;/*/xhtml:body/xhtml:table[@tagID='{@tagID}']/@class&quot;&gt;" cols="60" rows="2">
        <xsl:value-of select="@class"/>
      </textarea>
    </content>
  </node>
  -->
  <xsl:call-template name="insertbeforemenu"><xsl:with-param name="path">/*/xhtml:body/xhtml:table</xsl:with-param></xsl:call-template>
  
  <node name="Table" select="/*/xhtml:body/xhtml:table[@tagID='{@tagID}']">
    <action><delete name="&lt;xupdate:remove select=&quot;/*/xhtml:body/xhtml:table[@tagID='{@tagID}']&quot;/&gt;"/></action>
    <content>
      <textarea name="&lt;xupdate:update-parent select=&quot;/*/xhtml:body/xhtml:table[@tagID='{@tagID}']&quot;&gt;" cols="60" rows="30">
        <xsl:copy-of select="."/>
      </textarea>
    </content>
  </node>
</xsl:template>


<xsl:template match="xhtml:ul" mode="body">
  <xsl:call-template name="insertbeforemenu"><xsl:with-param name="path">/*/xhtml:body/xhtml:ul</xsl:with-param></xsl:call-template>
  
  <node name="Unordered List" select="/*/xhtml:body/xhtml:ul[@tagID='{@tagID}']">
    <action><delete name="&lt;xupdate:remove select=&quot;/*/xhtml:body/xhtml:ul[@tagID='{@tagID}']&quot;/&gt;"/></action>
    <content>
      <textarea name="&lt;xupdate:update select=&quot;/*/xhtml:body/xhtml:ul[@tagID='{@tagID}']&quot;&gt;" cols="60" rows="30">
        <xsl:copy-of select="node()"/>
      </textarea>
    </content>
  </node>
</xsl:template>


<xsl:template match="xhtml:ol" mode="body">
  <xsl:call-template name="insertbeforemenu"><xsl:with-param name="path">/*/xhtml:body/xhtml:ol</xsl:with-param></xsl:call-template>
  
  <node name="Ordered List" select="/*/xhtml:body/xhtml:ol[@tagID='{@tagID}']">
    <action><delete name="&lt;xupdate:remove select=&quot;/*/xhtml:body/xhtml:ol[@tagID='{@tagID}']&quot;/&gt;"/></action>
    <content>
      <textarea name="&lt;xupdate:update select=&quot;/*/xhtml:body/xhtml:ol[@tagID='{@tagID}']&quot;&gt;" cols="60" rows="30">
        <xsl:copy-of select="node()"/>
      </textarea>
    </content>
  </node>
</xsl:template>


<xsl:template match="xhtml:h2" mode="body">
  <xsl:call-template name="insertbeforemenu"><xsl:with-param name="path">/*/xhtml:body/xhtml:h2</xsl:with-param></xsl:call-template>
  
  <node name="Headline 2" select="/*/xhtml:body/xhtml:h2[@tagID='{@tagID}']">
    <action><delete name="&lt;xupdate:remove select=&quot;/*/xhtml:body/xhtml:h2[@tagID='{@tagID}']&quot;/&gt;"/></action>
    <content>
      <textarea name="&lt;xupdate:update select=&quot;/*/xhtml:body/xhtml:h2[@tagID='{@tagID}']&quot;&gt;" cols="60" rows="3">
        <xsl:copy-of select="node()"/>
      </textarea>
    </content>
  </node>
</xsl:template>


<xsl:template match="xhtml:h3" mode="body">
  <xsl:call-template name="insertbeforemenu"><xsl:with-param name="path">/*/xhtml:body/xhtml:h3</xsl:with-param></xsl:call-template>
  
  <node name="Headline 3" select="/*/xhtml:body/xhtml:h3[@tagID='{@tagID}']">
    <action><delete name="&lt;xupdate:remove select=&quot;/*/xhtml:body/xhtml:h3[@tagID='{@tagID}']&quot;/&gt;"/></action>
    <content>
      <textarea name="&lt;xupdate:update select=&quot;/*/xhtml:body/xhtml:h3[@tagID='{@tagID}']&quot;&gt;" cols="60" rows="3">
        <xsl:copy-of select="node()"/>
      </textarea>
    </content>
  </node>
</xsl:template>


<xsl:template match="xhtml:h4" mode="body">
  <xsl:call-template name="insertbeforemenu"><xsl:with-param name="path">/*/xhtml:body/xhtml:h4</xsl:with-param></xsl:call-template>
  
  <node name="Headline 4" select="/*/xhtml:body/xhtml:h4[@tagID='{@tagID}']">
    <action><delete name="&lt;xupdate:remove select=&quot;/*/xhtml:body/xhtml:h4[@tagID='{@tagID}']&quot;/&gt;"/></action>
    <content>
      <textarea name="&lt;xupdate:update select=&quot;/*/xhtml:body/xhtml:h4[@tagID='{@tagID}']&quot;&gt;" cols="60" rows="3">
        <xsl:copy-of select="node()"/>
      </textarea>
    </content>
  </node>
</xsl:template>


<xsl:template match="xhtml:hr" mode="body">
  <xsl:call-template name="insertbeforemenu"><xsl:with-param name="path">/*/xhtml:body/xhtml:hr</xsl:with-param></xsl:call-template>
  
  <node name="Horizontal Rule" select="/*/xhtml:body/xhtml:hr[@tagID='{@tagID}']">
    <action><delete name="&lt;xupdate:remove select=&quot;/*/xhtml:body/xhtml:hr[@tagID='{@tagID}']&quot;/&gt;"/></action>
  </node>
</xsl:template>



<xsl:template match="xhtml:object" mode="body">
  <!--
  <xsl:call-template name="insertbeforemenu"><xsl:with-param name="path">/*/xhtml:body/xhtml:p</xsl:with-param></xsl:call-template>
  -->
  <node name="Object" select="/*/xhtml:body/xhtml:p/xhtml:object[@tagID='{@tagID}']">
    <action><delete name="&lt;xupdate:remove select=&quot;/*/xhtml:body/xhtml:p/xhtml:object[@tagID='{@tagID}']&quot;/&gt;"/></action>
    <content>
      <div><xsl:value-of select="@data"/></div>
      <textarea name="&lt;xupdate:update select=&quot;/*/xhtml:body/xhtml:p/xhtml:object[@tagID='{@tagID}']&quot;&gt;" cols="40" size="3"><xsl:value-of select="."/></textarea>
    </content>
  </node>
</xsl:template>


<xsl:template match="lenya:asset" mode="body">
  <xsl:call-template name="insertbeforemenu"><xsl:with-param name="path">/*/xhtml:body/lenya:asset</xsl:with-param></xsl:call-template>
  
  <node name="Asset">
    <action>
      <delete name="&lt;xupdate:remove select=&quot;/*/xhtml:body/lenya:asset[@tagID='{@tagID}']&quot;/&gt;"/>
    </action>
    <content>
      <input type="text" name="&lt;xupdate:update select=&quot;/*/xhtml:body/lenya:asset[@tagID='{@tagID}']&quot;&gt;" size="60">
        <xsl:attribute name="value">
           <xsl:value-of select="@src"/>
        </xsl:attribute>
      </input>
    </content>
  </node>
</xsl:template>


</xsl:stylesheet>  
