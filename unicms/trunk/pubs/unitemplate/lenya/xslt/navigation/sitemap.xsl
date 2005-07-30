<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="nav"
    >
   
<xsl:import href="node_attrs.xsl"/>


<xsl:template match="nav:site">

  <xsl:variable name="current_nodes_language" select="//nav:node[@current = 'true']/nav:label/@xml:lang"/>

  <div id="sitemap">

  <div id="alphabetically">
    <xsl:for-each select="//nav:node">
      <xsl:sort select="nav:label" order="ascending"/>
      <div>
      <!-- the user can select if she wants the sitemap to start at the homepage or at the current page;
           this selection can be done here more easily than in elements.xsl   -->
        <xsl:attribute name="currents_child">
          <xsl:value-of select="ancestor-or-self::*[@current = 'true']/@current"/>
        </xsl:attribute>
      <!-- the same is valid for the language selection -->
        <xsl:attribute name="same_language">
          <xsl:value-of select="nav:label/@xml:lang = $current_nodes_language"/>
        </xsl:attribute>
      <xsl:apply-templates select="." mode="node_attrs"/>
      </div>
    </xsl:for-each>
  </div>

  <div id="by_topic">
    <xsl:apply-templates select="nav:node"/>
  </div>

  </div>

</xsl:template>


<xsl:template match="nav:node">

  <xsl:variable name="current_nodes_language" select="//nav:node[@current = 'true']/nav:label/@xml:lang"/>

  <div>
      <!-- the user can select if she wants the sitemap to start at the homepage or at the current page;
           this selection can be done here more easily than in elements.xsl   -->
    <xsl:attribute name="currents_child">
      <xsl:value-of select="ancestor-or-self::*[@current = 'true']/@current"/>
    </xsl:attribute>
      <!-- the same is valid for the language selection -->
    <xsl:attribute name="same_language">
      <xsl:value-of select="nav:label/@xml:lang = $current_nodes_language"/>
    </xsl:attribute>
    <xsl:apply-templates select="." mode="node_attrs"/>
  </div>

  <xsl:apply-templates select="nav:node"/>

</xsl:template>


</xsl:stylesheet> 
