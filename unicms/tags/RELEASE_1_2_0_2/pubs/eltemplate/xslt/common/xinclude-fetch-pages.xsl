<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: xinclude-fetch-pages.xsl,v 1.3 2005/03/29 08:29:20 thomas Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns:xi="http://www.w3.org/2001/XInclude"  
  xmlns:tree="http://apache.org/cocoon/lenya/sitetree/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:param name="export"/>
  <xsl:param name="port"/>

  <xsl:template match="/tree:site">
    <pages>
      <xsl:apply-templates/>
    </pages>
  </xsl:template>

  <xsl:template match="tree:node">
      <page href="{@href}" name="@name">
        <xi:include href="http://localhost:{$port}{@href}?export={$export}"/>
      </page>
    <xsl:apply-templates select="tree:node"/>
  </xsl:template>
  
</xsl:stylesheet>
