<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: nav2manifest.xsl,v 1.2 2005/03/29 08:28:40 thomas Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns:xi="http://www.w3.org/2001/XInclude"  
  xmlns:tree="http://apache.org/cocoon/lenya/sitetree/1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:imscp="http://www.imsglobal.org/xsd/imscp_v1p1">


 <xsl:param name="pubid-live"/>  

 <xsl:template match="/tree:site">
    <imscp:manifest xmlns:imsmd="http://www.imsglobal.org/xsd/imsmd_v1p2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" identifier="MANIFEST-{generate-id()}" xsi:schemaLocation="http://www.imsglobal.org/xsd/imscp_v1p1 imscp_v1p1.xsd http://www.imsglobal.org/xsd/imsmd_v1p2 imsmd_v1p2p2.xsd" version ="FIXME:datetime" xml:base="/">
      <imscp:metadata>
      </imscp:metadata>
      <imscp:organizations>
        <imscp:organization identifier="OR-Interaktiv">
          <imscp:title>Obligationenrecht Interaktiv</imscp:title>
          <imscp:item identifier="{generate-id()}" identifierref="index.html">
            <imscp:title><xsl:value-of select="tree:node[@id = 'index']/tree:label"/></imscp:title>
          </imscp:item>
          <xsl:apply-templates select="tree:node[@visibleinnav = 'true' and position() != last()]/tree:node" mode="organisation"/>
        </imscp:organization>
      </imscp:organizations>
      <imscp:resources>
        <xsl:apply-templates select="tree:node" mode="resource"/>
      </imscp:resources>
    </imscp:manifest>
  </xsl:template>

  <xsl:template match="tree:node" mode="organisation">
    <xsl:variable name="document-id">
      <xsl:choose>
        <xsl:when test="count(ancestor::tree:node) = 2 and tree:node">
          <xsl:value-of select="substring-after(tree:node/@href, $pubid-live)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="substring-after(@href, $pubid-live)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <imscp:item identifier="{generate-id()}" identifierref="{$document-id}">
      <imscp:title><xsl:value-of select="@id"/></imscp:title>
        <xsl:if test="count(ancestor::tree:node) &lt; 2">
          <xsl:apply-templates select="tree:node" mode ="organisation"/>
        </xsl:if>
    </imscp:item> 
  </xsl:template>

  <xsl:template match="tree:node" mode="resource">
    <imscp:resource identifier="{substring-after(@href, $pubid-live)}" type="webcontent" href="{substring-after(@href, $pubid-live)}"/>
    <xsl:apply-templates select="tree:node" mode="resource"/>
  </xsl:template>
  
</xsl:stylesheet>
