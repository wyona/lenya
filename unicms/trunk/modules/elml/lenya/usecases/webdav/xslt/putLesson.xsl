<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:elml="http://www.elml.ch"
  xmlns="http://www.elml.ch" 
  xmlns:dcterms="http://purl.org/dc/terms/" 
  xmlns:dc="http://purl.org/dc/elements/1.1/" 
>

  <xsl:param name="creator"/>
  <xsl:param name="creationdate"/>

  <xsl:template match="/*">
    <xsl:copy>
      <xsl:attribute name="lenya:dummy">FIXME:keepNamespace</xsl:attribute>
      <xsl:attribute name="elml:dummy">FIXME:keepNamespace</xsl:attribute>
      <xsl:attribute name="dc:dummy">FIXME:keepNamespace</xsl:attribute>
      <xsl:attribute name="dcterms:dummy">FIXME:keepNamespace</xsl:attribute>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="*"/>
    </xsl:copy>
  </xsl:template> 

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
