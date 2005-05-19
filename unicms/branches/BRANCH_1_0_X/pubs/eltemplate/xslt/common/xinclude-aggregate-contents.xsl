<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: xinclude-aggregate-contents.xsl,v 1.1 2004/12/15 13:30:00 thomas Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns:xi="http://www.w3.org/2001/XInclude"  
  xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:template match="/nav:site">
    <pages>
      <xsl:apply-templates/>
    </pages>
  </xsl:template>

  <xsl:template match="nav:node">
    <xsl:variable name="path">
      content/<xsl:value-of select="substring-before(substring-after(@href, 'eltemplate/'), '.html')"/>/index_de.xml
    </xsl:variable>

    <page href="{@href}" name="{@id}">
      <xi:include href="{normalize-space($path)}"/>
    </page>
    <xsl:apply-templates select="nav:node"/>
  </xsl:template>
  
</xsl:stylesheet>
