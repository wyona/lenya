<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: aggregate-xhtml.xsl,v 1.1 2004/12/13 09:33:46 thomas Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns:xi="http://www.w3.org/2001/XInclude"  
  xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:template match="/nav:site">
    <site>
      <xsl:apply-templates/>
    </site>
  </xsl:template>

  <xsl:template match="nav:node">
      <page href="{@href}" name="@name">
        <xi:include href="http://localhost:8888{@href}"/>
      </page>
    <xsl:apply-templates select="nav:node"/>
  </xsl:template>
  
</xsl:stylesheet>
