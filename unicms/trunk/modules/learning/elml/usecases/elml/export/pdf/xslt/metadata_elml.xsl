<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:elml="http://www.elml.ch" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes" xmlns:fox="http://xml.apache.org/fop/extensions">
	<xsl:template match="elml:metadata">
		<!--*****
		<xsl:if test="(@role='student') or (@role=$role) or (not (@role))">
			<xsl:call-template name="elml:generate_Title"/>
			<fo:block>Metadata is only shown in the online version.</fo:block>
			</xsl:if> *****-->
	</xsl:template>
</xsl:stylesheet>
