<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:elt="http://www.unizh.ch/elt/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:param name="area"/>
  <xsl:param name="language"/>
 

  <xsl:template match="xhtml:html">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <elt:referenced-docs>
        <xsl:for-each select="//xhtml:a[contains(@href, 'Gesetzestexte')]">
           <xsl:variable name="path"><xsl:value-of select="substring-before(substring-after(@href, $area), '.')"/></xsl:variable>
           <xsl:if test="not(@href = preceding::xhtml:a/@href)">
             <elt:referenced-doc href="{@href}">
               <cinclude:include ignoreErrors="true" src="content/{$area}{$path}/index_{$language}.xml"/></elt:referenced-doc>
           </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="//elt:lernpfad/xhtml:a[contains(@href, 'Literatur')]">
           <xsl:variable name="path"><xsl:value-of select="substring-before(substring-after(@href, $area), '.')"/></xsl:variable>
           <elt:referenced-doc href="{@href}">
             <cinclude:include ignoreErrors="true" src="content/{$area}{$path}/index_{$language}.xml"/>
           </elt:referenced-doc>
        </xsl:for-each>
        <xsl:for-each select="//elt:lernpfad/xhtml:a[contains(@href, 'Entscheide')]">
           <xsl:variable name="path"><xsl:value-of select="substring-before(substring-after(@href, $area), '.')"/></xsl:variable>
           <elt:referenced-doc href="{@href}">
             <cinclude:include ignoreErrors="true"  src="content/{$area}{$path}/index_{$language}.xml"/>
           </elt:referenced-doc>
        </xsl:for-each>
      </elt:referenced-docs>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
