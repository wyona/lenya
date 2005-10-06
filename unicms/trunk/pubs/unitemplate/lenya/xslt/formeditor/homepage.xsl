<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
>

<xsl:import href="../../../../../xslt/authoring/edit/form.xsl"/>

<xsl:import href="xhtml-common.xsl"/>
<xsl:import href="unizh-common.xsl"/>

<xsl:template match="unizh:homepage">
<node name="Metadata"/>
<node name="Title" select="/unizh:homepage/lenya:meta/dc:title[@tagID='{lenya:meta/dc:title/@tagID}']">
  <content><input type="text" name="&lt;xupdate:update select=&quot;/unizh:homepage/lenya:meta/dc:title[@tagID='{lenya:meta/dc:title/@tagID}']&quot;&gt;" size="40"><xsl:attribute name="value"><xsl:value-of select="lenya:meta/dc:title"/></xsl:attribute></input></content>
</node>
<node name="DC Description" select="/unizh:homepage/lenya:meta/dc:description[@tagID='{lenya:meta/dc:description/@tagID}']">
  <content>
    <textarea name="&lt;xupdate:update select=&quot;/unizh:homepage/lenya:meta/dc:description[@tagID='{lenya:meta/dc:description/@tagID}']&quot;&gt;" cols="40" rows="5">
      <xsl:copy-of select="lenya:meta/dc:description/node()"/>
    </textarea>
  </content>
</node>
<node/>
<xsl:apply-templates select="xhtml:body"/>
<node/>
<xsl:apply-templates select="unizh:related-content"/>

</xsl:template>

</xsl:stylesheet>  
