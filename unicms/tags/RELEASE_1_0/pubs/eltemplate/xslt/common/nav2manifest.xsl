<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: nav2manifest.xsl,v 1.2 2005/03/29 08:28:40 thomas Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns:xi="http://www.w3.org/2001/XInclude"  
  xmlns:tree="http://apache.org/cocoon/lenya/sitetree/1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:param name="pubid-live"/>  

 <xsl:template match="/tree:site">
    <manifest identifier="Manifest-{generate-id()}" version ="FIXME:datetime" xml:base="/">
      <metadata>
      </metadata>
      <organizations>
        <organization identifier="OR-Interaktiv" identifierref="index.html">
          <title>Obligationenrecht Interaktiv</title>
          <xsl:apply-templates select="tree:node[@visibleinnav = 'true' and position() != last()]/tree:node" mode="organisation"/>
        </organization>
      </organizations>
      <resources>
        <xsl:apply-templates select="tree:node" mode="resource"/>
      </resources>
    </manifest>
  </xsl:template>

  <xsl:template match="tree:node" mode="organisation">
    <xsl:variable name="document-id" select="substring-after(@href, $pubid-live)"/>
    <item identifier="{generate-id()}" identifierref="{$document-id}">
      <title><xsl:value-of select="@id"/></title>
        <xsl:apply-templates select="tree:node" mode ="organisation"/>
    </item> 
  </xsl:template>

  <xsl:template match="tree:node" mode="resource">
    <resource identifier="{substring-after(@href, $pubid-live)}" type="webcontent" href="{substring-after(@href, $pubid-live)}"/>
    <xsl:apply-templates select="tree:node" mode="resource"/>
  </xsl:template>
  
</xsl:stylesheet>
