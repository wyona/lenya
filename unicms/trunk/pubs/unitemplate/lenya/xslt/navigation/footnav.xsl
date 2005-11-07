<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    >
   
 
<xsl:template match="nav:site">
  <div id="footnav">
    <xsl:apply-templates select="nav:node[@id = 'impressum']"/>
  </div>
</xsl:template>


<xsl:template match="nav:node">
  <div id="{@id}" href="{@href}"><xsl:value-of select="nav:label"/></div>
</xsl:template>

</xsl:stylesheet>

