<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
>

<xsl:import href="../../../../../xslt/authoring/edit/form.xsl"/>
<xsl:import href="unizh-common.xsl"/>
<xsl:import href="xhtml-common.xsl"/>

<xsl:template match="unizh:section">
<node name="Title" select="/unizh:section/lenya:meta/dc:title[@tagID='{lenya:meta/dc:title/@tagID}']">
  <content><input type="text" name="&lt;xupdate:update select=&quot;/unizh:section/lenya:meta/dc:title[@tagID='{lenya:meta/dc:title/@tagID}']&quot;&gt;" size="40"><xsl:attribute name="value"><xsl:value-of select="lenya:meta/dc:title"/></xsl:attribute></input></content>
</node>


<node name="FIRST COLUMN" />
<xsl:apply-templates select="unizh:column[@id='1']/unizh:highlights/unizh:highlight"/>
<xsl:apply-templates select="unizh:column[@id='1']/unizh:grouplist/unizh:group"/>

<node name="SECOND COLUMN" />
<xsl:apply-templates select="unizh:column[@id='2']/unizh:grouplist/unizh:group"/>

<node name="THIRD COLUMN" />
<xsl:apply-templates select="unizh:column[@id='3']/unizh:grouplist/unizh:group"/>
</xsl:template>

<xsl:template match="unizh:group">
<node name="Group">
  <action><delete name="&lt;xupdate:remove select=&quot;/unizh:section/unizh:column/unizh:grouplist/unizh:group[@tagID='{@tagID}']&quot;/&gt;"/></action>
</node>
<node name="Group Title" select="/unizh:section/unizh:column/unizh:grouplist/unizh:group/unizh:head/unizh:title[@tagID='{unizh:head/unizh:title/@tagID}']">
  <content><input type="text" name="&lt;xupdate:update select=&quot;/unizh:section/unizh:column/unizh:grouplist/unizh:group/unizh:head/unizh:title[@tagID='{unizh:head/unizh:title/@tagID}']&quot;&gt;" size="40"><xsl:attribute name="value"><xsl:value-of select="unizh:head/unizh:title"/></xsl:attribute></input></content>
</node>
<node name="Group URL" select="/unizh:section/unizh:column/unizh:grouplist/unizh:group/unizh:head/unizh:link[@tagID='{unizh:head/unizh:link/@tagID}']">
  <content><input type="text" name="&lt;xupdate:update select=&quot;/unizh:section/unizh:column/unizh:grouplist/unizh:group/unizh:head/unizh:link[@tagID='{unizh:head/unizh:link/@tagID}']&quot;&gt;" size="40"><xsl:attribute name="value"><xsl:value-of select="unizh:head/unizh:link"/></xsl:attribute></input></content>
</node>

<xsl:for-each select="unizh:entrylist/unizh:entry">
<node name="Entry">
  <action><delete name="&lt;xupdate:remove select=&quot;/unizh:section/unizh:column/unizh:grouplist/unizh:group/unizh:entrylist/unizh:entry[@tagID='{@tagID}']&quot;/&gt;" value="true"/></action>
</node>
<node name="Entry Title" select="/unizh:section/unizh:column/unizh:grouplist/unizh:group/unizh:entrylist/unizh:entry/unizh:title[@tagID='{unizh:title/@tagID}']">
  <content><input type="text" name="&lt;xupdate:update select=&quot;/unizh:section/unizh:column/unizh:grouplist/unizh:group/unizh:entrylist/unizh:entry/unizh:title[@tagID='{unizh:title/@tagID}']&quot;&gt;" size="40"><xsl:attribute name="value"><xsl:value-of select="unizh:title"/></xsl:attribute></input></content>
</node>
<node name="Entry URL" select="/unizh:section/unizh:column/unizh:grouplist/unizh:group/unizh:entrylist/unizh:entry/unizh:link[@tagID='{unizh:link/@tagID}']">
  <content><input type="text" name="&lt;xupdate:update select=&quot;/unizh:section/unizh:column/unizh:grouplist/unizh:group/unizh:entrylist/unizh:entry/unizh:link[@tagID='{unizh:link/@tagID}']&quot;&gt;" size="40"><xsl:attribute name="value"><xsl:value-of select="unizh:link"/></xsl:attribute></input></content>
</node>

<node name="Entry">
  <action><insert name="&lt;xupdate:insert-after select=&quot;/unizh:section/unizh:column/unizh:grouplist/unizh:group/unizh:entrylist/unizh:entry[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;unizh:entry&quot; namespace=&quot;http://unizh.ch/doctypes/elements/1.0&quot;&gt;&lt;unizh:title xmlns:unizh=&quot;http://unizh.ch/doctypes/elements/1.0&quot;&gt;New title&lt;/unizh:title&gt;&lt;unizh:link xmlns:unizh=&quot;http://unizh.ch/doctypes/elements/1.0&quot;&gt;http://www.unizh.ch&lt;/unizh:link&gt;&lt;/xupdate:element&gt;&lt;/xupdate:insert-after&gt;"/></action>
</node>
</xsl:for-each>

<node name="Group">
  <action><insert name="&lt;xupdate:insert-after select=&quot;/unizh:section/unizh:column/unizh:grouplist/unizh:group[@tagID='{@tagID}']&quot;&gt;&lt;xupdate:element name=&quot;unizh:group&quot; namespace=&quot;http://unizh.ch/doctypes/elements/1.0&quot;&gt;&lt;unizh:head xmlns:unizh=&quot;http://unizh.ch/doctypes/elements/1.0&quot;&gt;&lt;unizh:title xmlns:unizh=&quot;http://unizh.ch/doctypes/elements/1.0&quot;&gt;New group title&lt;/unizh:title&gt;&lt;unizh:link xmlns:unizh=&quot;http://unizh.ch/doctypes/elements/1.0&quot;&gt;http://www.unizh.ch&lt;/unizh:link&gt;&lt;/unizh:head&gt;&lt;unizh:entrylist  xmlns:unizh=&quot;http://unizh.ch/doctypes/elements/1.0&quot;&gt;&lt;unizh:entry xmlns:unizh=&quot;http://unizh.ch/doctypes/elements/1.0&quot;&gt;&lt;unizh:title xmlns:unizh=&quot;http://unizh.ch/doctypes/elements/1.0&quot;&gt;New entry title&lt;/unizh:title&gt;&lt;unizh:link xmlns:unizh=&quot;http://unizh.ch/doctypes/elements/1.0&quot;&gt;http://www.unizh.ch&lt;/unizh:link&gt;&lt;/unizh:entry&gt;&lt;/unizh:entrylist&gt;&lt;/xupdate:element&gt;&lt;/xupdate:insert-after&gt;"/></action>
</node>
</xsl:template>

</xsl:stylesheet>
