<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  >

  <xsl:param name="root"/>

  <xsl:template match="/unizh:redirect/lenya:meta/unizh:redirect-to">
    <html>
      <head>
        <meta http-equiv="refresh" content="0;URL={$root}{@href}"/>
      </head>
    </html>
  </xsl:template>

</xsl:stylesheet>
