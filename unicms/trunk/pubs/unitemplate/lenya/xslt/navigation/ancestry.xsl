<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: breadcrumb.xsl,v 1.1 2004/05/26 10:43:39 gregor Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    exclude-result-prefixes="nav"
    >
    
<xsl:import href="node_attrs.xsl"/>

  <xsl:param name="area"/>
  <xsl:param name="chosenlanguage"/>
  <xsl:param name="defaultlanguage"/>


<xsl:template match="nav:site">
  <div id="ancestry">
    <xsl:apply-templates select="nav:node"/>
  </div>
</xsl:template>


<xsl:template match="nav:site/nav:node[@id='index']"/>


<xsl:template match="nav:node">
 <xsl:if test="descendant-or-self::nav:node[@current = 'true']">
  <div>
   <xsl:apply-templates select="." mode="node_attrs"/>
   <xsl:if test="descendant-or-self::*/@current = 'true'">

    <xsl:variable name="fileURI">
      <xsl:choose>
        <xsl:when test="@language-suffix = ''">
          <xsl:value-of select="concat('cocoon:/xml/', $area, '/', @basic-url, '/index_', $defaultlanguage, '.xml')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('cocoon:/xml/', $area, '/', @basic-url, '/index', @language-suffix, '.xml')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <content>
      <cinclude:includexml ignoreErrors="true">
       <cinclude:src><xsl:value-of select="$fileURI"/></cinclude:src>
      </cinclude:includexml>
    </content>

   </xsl:if>
  </div>
  <xsl:apply-templates select="nav:node"/>
 </xsl:if>
</xsl:template>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet> 
