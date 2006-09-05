<?xml version="1.0" encoding="UTF-8" ?>


<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:elml="http://www.elml.ch"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:uz="http://unizh.ch"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:index="http://apache.org/cocoon/lenya/documentindex/1.0"
  xmlns:level="http://apache.org/cocoon/lenya/documentlevel/1.0"
  xmlns:ci="http://apache.org/cocoon/include/1.0"
  xmlns:xi="http://www.w3.org/2001/XInclude"
>


<xsl:param name="root"/>
<xsl:param name="contextprefix"/>
<xsl:param name="area"/>
<xsl:param name="rendertype"/>
<xsl:param name="defaultlanguage"/>
<xsl:param name="language"/>
<xsl:param name="nodeid"/>
<xsl:param name="fontsize"/>
<xsl:param name="querystring"/>
<xsl:param name="creationdate"/>
<xsl:param name="publicationid"/>

<xi:include href="../doctypes/variables.xsl#xpointer(/*/*)"/>
<xi:include href="elml-page.xsl#xpointer(/*/*)"/>
<xi:include href="../common/navigation.xsl#xpointer(/*/*)"/>
<xi:include href="../common/elml.xsl#xpointer(/*/*)"/>
<xi:include href="../common/elml.xsl#xpointer(/*/*)"/>
<xi:include href="../common/biblio_harvard.xsl#xpointer(/*/*)"/>


 <!-- <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template> -->


</xsl:stylesheet> 
