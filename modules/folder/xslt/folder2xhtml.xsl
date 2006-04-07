<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml" xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0">

  <xsl:param name="chosenlanguage"/>
  <xsl:param name="context-prefix"/>
  <xsl:param name="root"/>

  <xsl:template match="nav:fragment">
    <div id="body">
      <ul>
        <xsl:apply-templates select="nav:node"/>
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="nav:node">
    <li>
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="$context-prefix"/><xsl:value-of select="$root"/>/<xsl:value-of select="@href"/>
        </xsl:attribute>
        <xsl:apply-templates select="nav:label"/>
      </a>
    </li>
  </xsl:template>

  <xsl:template match="nav:label">
    <xsl:choose>
      <xsl:when test="@xml:lang = $chosenlanguage">
        <xsl:value-of select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
        <xsl:text>&#160;</xsl:text>
        <xsl:text>[</xsl:text>
        <xsl:value-of select="@xml:lang"/>
        <xsl:text>]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
