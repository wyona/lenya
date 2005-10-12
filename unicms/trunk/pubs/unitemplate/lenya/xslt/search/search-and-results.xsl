<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  >



<xsl:param name="unizh.pubId"/>
<xsl:param name="context-prefix"/>
<xsl:param name="area"/>

<xsl:variable name="areaRootPath" select="concat($context-prefix, '/unizh/authoring/images')"/>

<xsl:template match="/">

  <form id="search">
    <input type="text" name="queryString" value="{/search-and-results/search/query-string}"/>
    <input type="submit" name="sa" value="Suchen" />
    <input type="radio" name="publication-id" value="unizh">
      <xsl:if test="/search-and-results/search/publication-id = 'unizh'">
        <xsl:attribute name="checked">true</xsl:attribute>
      </xsl:if>
      www.unizh.ch
    </input>
    <input type="radio" name="publication-id" value="{$unizh.pubId}">
      <xsl:if test="/search-and-results/search/publication-id = $unizh.pubId">
        <xsl:attribute name="checked">true</xsl:attribute>
      </xsl:if>
        www.<xsl:value-of select="$unizh.pubId"/>.unizh.ch
    </input> 
  </form>

  <xsl:apply-templates select="/search-and-results/results"/>
  <xsl:apply-templates select="/search-and-results/search/exception"/>

</xsl:template>


<xsl:template match="results">
  <div id="results">
    <h1>Suchresultate f&#252;r '<xsl:value-of select="../search/publication-name"/>'</h1>
    <p>
      <xsl:choose>
        <xsl:when test="hits">
          Ergebnisse <xsl:value-of select="pages/page[@type='current']/@start"/> - <xsl:value-of select="pages/page[@type='current']/@end"/> von <xsl:value-of select="@total-hits"/> 
          <ul>
            <xsl:apply-templates select="hits/hit"/>
          </ul>
        </xsl:when>
        <xsl:otherwise>
          Sorry, <b>nothing</b> found!
        </xsl:otherwise>
      </xsl:choose>
    </p>
  </div>
  <xsl:apply-templates select="pages"/>
</xsl:template>

<xsl:template match="exception">
  <div id="exception">
    <xsl:value-of select="."/>
  </div>
</xsl:template>


<xsl:template match="hit">
  <xsl:choose>
    <xsl:when test="path">
      <li>File: <xsl:value-of select="path"/></li>
    </xsl:when>
    <xsl:when test="uri">
      <li>
        <xsl:if test="mime-type = 'application/pdf'">[PDF] </xsl:if>
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="/search-and-results/search/publication-prefix"/><xsl:value-of select="normalize-space(uri)"/></xsl:attribute><xsl:apply-templates select="title"/>
        </a>
        <xsl:apply-templates select="no-title"/>
        <span class="excerpt">
          <xsl:apply-templates select="excerpt"/><xsl:apply-templates select="no-excerpt"/>
        </span>
      </li>
    </xsl:when>
    <xsl:otherwise>
      <li>Neither PATH nor URL</li>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="pages">
  <div id="pages">
    Resultatseiten
    <!-- <xsl:apply-templates select="page[@type='previous']" mode="previous"/> -->
    <xsl:for-each select="page">
      <xsl:choose>
        <xsl:when test="@type='current'">
          <xsl:value-of select="position()"/>
        </xsl:when>
        <xsl:otherwise>
          <a href="?publication-id={../../../search/publication-id}&amp;queryString={../../../search/query-string}&amp;sortBy={../../../search/sort-by}&amp;start={@start}&amp;end={@end}"><xsl:value-of select="position()"/></a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <!-- <xsl:apply-templates select="page[@type='next']" mode="next"/> -->
  </div>
</xsl:template>

</xsl:stylesheet>
