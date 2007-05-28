<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
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
      <xsl:attribute name="xhtml:dummy">FIXME:keepNamespace</xsl:attribute>
      <xsl:attribute name="elml:dummy">FIXME:keepNamespace</xsl:attribute>
      <xsl:attribute name="dc:dummy">FIXME:keepNamespace</xsl:attribute>
      <xsl:attribute name="dcterms:dummy">FIXME:keepNamespace</xsl:attribute>
      <xsl:copy-of select="@*[not(name() = 'xsi:noNamespaceSchemaLocation')]"/>
      <xsl:text>
      </xsl:text>
      <lenya:meta>
        <xsl:text>
        </xsl:text>
        <dc:title>Allgemeine Dokumenttypen (xhtml)</dc:title>
        <xsl:text>
         </xsl:text>
        <dc:description> </dc:description>
        <xsl:text>
        </xsl:text>
        <dc:creator>admin1 (Administrator)</dc:creator>
        <xsl:text>
        </xsl:text>
        <dc:subject/>
        <xsl:text>
        </xsl:text>
        <dc:publisher>UniversitA$t ZA1/4rich</dc:publisher>
        <xsl:text>
        </xsl:text>
        <dcterms:created>Wed Oct 19 14:50:12 CEST 2005</dcterms:created>
        <xsl:text>
        </xsl:text>
        <dcterms:issued>date of publication</dcterms:issued>
        <xsl:text>
        </xsl:text>
        <dc:language>de</dc:language>
        <xsl:text>
        </xsl:text>
        <dc:rights>UniversitA$t ZA1/4rich</dc:rights>
        <xsl:text>
        </xsl:text>
      </lenya:meta>
      <xsl:text>
      </xsl:text>
      <xsl:apply-templates select="*"/>
    </xsl:copy>
  </xsl:template> 


  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
