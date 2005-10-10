<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  >


<xsl:import href="../../../../../xslt/search/search-and-results.xsl"/>

<xsl:param name="unizh.pubId" select="'roger'"/>
<xsl:param name="context-prefix"/>
<xsl:param name="area"/>

<xsl:variable name="areaRootPath" select="concat($context-prefix, '/unizh/authoring/images')"/>

<xsl:template match="/">

  <form id="search">
    <input type="text" name="queryString" value="{/search-and-results/search/query-string}"/>
    <input type="submit" name="sa" value="Suchen" />
    <!-- Choose between SIMPLE and ADVANCED search -->
    <xsl:choose>
      <xsl:when test="/search-and-results/search/request-parameters/unizh.type">
        <a id="lessoptions" href="?queryString={/search-and-results/search/query-string}&amp;publication-id={$unizh.pubId}&amp;{$unizh.pubId}.fields.contents">weniger Optionen</a>
        <input type="hidden" name="unizh.type" value="advanced" />
      </xsl:when>
      <xsl:otherwise>
        <a id="moreoptions" href="?unizh.type=advanced&amp;queryString={/search-and-results/search/query-string}&amp;publication-id={$unizh.pubId}&amp;dummy-index-id.fields=contents">mehr Optionen</a>
        <input type="hidden" name="publication-id" value="{$unizh.pubId}" />
        <input type="hidden" name="{$unizh.pubId}.fields" value="contents" />
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="/search-and-results/search/request-parameters/unizh.type">
      <select name="dummy-index-id.fields">
        <option value="contents">
          <xsl:if test="/search-and-results/search/fields/field[1]='contents'">
            <xsl:attribute name="selected">selected</xsl:attribute>
          </xsl:if>
          Volltext
        </option>
        <option value="title">
          <xsl:if test="/search-and-results/search/fields/field[1]='title'">
            <xsl:attribute name="selected">selected</xsl:attribute>
          </xsl:if>
          Titel
        </option>
        <option value="keywords">
          <xsl:if test="/search-and-results/search/fields/field[1]='keywords'">
            <xsl:attribute name="selected">selected</xsl:attribute>
          </xsl:if>
          Keywords
        </option>
      </select>
      <!-- Where to search. Fix this -->
      <input type="radio" name="publication-id" value="unizh">
        <xsl:if test="/search-and-results/search/publication-id = 'unizh'">
          <xsl:attribute name="checked">true</xsl:attribute>
        </xsl:if>
      </input>www.unizh.ch
      <input type="radio" name="publication-id" value="{$unizh.pubId}">
        <xsl:if test="/search-and-results/search/publication-id = $unizh.pubId">
          <xsl:attribute name="checked">true</xsl:attribute>
        </xsl:if>
      </input>www.<xsl:value-of select="$unizh.pubId"/>.unizh.ch
    </xsl:if>
  </form>

  <xsl:apply-templates select="/search-and-results/results"/>
  <xsl:apply-templates select="/search-and-results/search/exception"/>

</xsl:template>


<xsl:template match="results">
  <div id="results">
    <h2>Suchresultate f&#252;r '<xsl:value-of select="../search/publication-name"/>'</h2>
    <p>
      <xsl:choose>
        <xsl:when test="hits">
          <xsl:value-of select="pages/page[@type='current']/@start"/> - <xsl:value-of select="pages/page[@type='current']/@end"/> von <xsl:value-of select="@total-hits"/> Resultate
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
        <span class="searchresult">
          <xsl:apply-templates select="excerpt"/><xsl:apply-templates select="no-excerpt"/>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="/search-and-results/search/publication-prefix"/><xsl:value-of select="normalize-space(uri)"/></xsl:attribute><xsl:value-of select="/search-and-results/search/publication-prefix"/><xsl:apply-templates select="uri"/>
          </a>
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
    <xsl:apply-templates select="page[@type='previous']" mode="previous"/>
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
    <xsl:apply-templates select="page[@type='next']" mode="next"/>
  </div>
</xsl:template>

</xsl:stylesheet>
