<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
  xmlns="http://www.w3.org/1999/xhtml"
>


  <xsl:template match="nav:site">
    <div id="servicenav">
      <xsl:apply-templates select="descendant-or-self::nav:node[@basic-url = 'news/media']" />
      <xsl:apply-templates select="descendant-or-self::nav:node[@basic-url = 'ueber/partner']" />
      <xsl:apply-templates select="descendant-or-self::nav:node[@id = 'contact']" />
      <xsl:apply-templates select="descendant-or-self::nav:node[@id = 'search']" />
    </div>
  </xsl:template>


  <xsl:template match="nav:node">
    <div id="{@id}" href="{@href}"><xsl:value-of select="nav:label" /></div>
  </xsl:template>

</xsl:stylesheet>

