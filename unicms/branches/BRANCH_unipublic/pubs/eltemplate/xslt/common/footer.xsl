<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: footer.xsl,v 1.5 2005/01/19 11:00:06 thomas Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
  
  <xsl:template name="footer">
     <xsl:apply-templates select="/document/xhtml:div[@id = 'infomenu']"/>
  </xsl:template>
  
</xsl:stylesheet>
