<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:up="http://www.unipublic.unizh.ch/2002/up"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:dcterms="http://purl.org/dc/terms/">


<!-- Insert teaser of referencing docs. Currently used by dossiers only. -->

<xsl:template match="dcterms:isReferencedBy">
  <xsl:if test="string(normalize-space(.))">
    <xsl:copy>
      <xsl:variable name="doc-id"><xsl:value-of select="."/></xsl:variable>
      <up:dossier>
        <up:teaser doc-id="{$doc-id}"> 
          <xi:include href="{$doc-id}" xpointer="/*[local-name() = 'dossier']/*[local-name() = 'color']"><xi:fallback><up:name><xsl:value-of select="$doc-id"/></up:name></xi:fallback></xi:include>
          <xi:include href="{$doc-id}" xpointer="/*[local-name() = 'dossier']/*[local-name() = 'meta']/*[local-name() = 'title']"><xi:fallback><up:name><xsl:value-of select="$doc-id"/></up:name></xi:fallback></xi:include>
          <xi:include href="{$doc-id}" xpointer="/*[local-name() = 'dossier']/*[local-name() = 'meta']/*[local-name() = 'description']"><xi:fallback><up:name><xsl:value-of select="$doc-id"/></up:name></xi:fallback></xi:include>
          <xi:include href="{$doc-id}" xpointer="/*[local-name() = 'dossier']/*[local-name() = 'teaser']/*[local-name() = 'div']"><xi:fallback><up:name><xsl:value-of select="$doc-id"/></up:name></xi:fallback></xi:include>
          <up:image><xi:include href="{$doc-id}" xpointer="/*[local-name() = 'dossier' and namespace-uri() = 'http://www.unipublic.unizh.ch/2002/up']/*[local-name() = 'teaser']/*[local-name() = 'p']/*[local-name() = 'object']/@data"><xi:fallback><up:name><xsl:value-of select="$doc-id"/></up:name></xi:fallback></xi:include></up:image>
        </up:teaser>
      </up:dossier>
    </xsl:copy>
  </xsl:if>
</xsl:template>

<xsl:template match="/ |@* | node()">
  <xsl:copy>
    <xsl:apply-templates select="@* | node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>

