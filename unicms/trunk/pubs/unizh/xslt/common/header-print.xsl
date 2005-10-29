<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: header.xsl,v 1.40 2005/03/09 11:11:13 peter Exp $ -->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns="http://www.w3.org/1999/xhtml" 
                xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" 
                >
                

  <xsl:template name="header">
    <div id="headerarea">
      <h2>
        <xsl:value-of select="/document/content/*/unizh:header/unizh:superscription"/>
      </h2>
      <h1>
        <xsl:value-of select="/document/content/*/unizh:header/unizh:heading"/>
      </h1>
    </div>
  </xsl:template>

</xsl:stylesheet>


