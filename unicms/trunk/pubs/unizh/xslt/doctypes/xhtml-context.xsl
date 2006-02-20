<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: xhtml-standard.xsl,v 1.11 2005/01/17 09:15:14 thomas Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  >
  
  <xsl:param name="root"/>
  <xsl:param name="contextprefix"/>
  <xsl:param name="area"/>
  <xsl:param name="rendertype"/>
  <xsl:param name="defaultlanguage"/>
  <xsl:param name="language"/>
  <xsl:param name="nodeid"/>
  <xsl:param name="fontsize"/>
  <xsl:param name="querystring"/>
  <xsl:param name="creationdate"/>

  <xsl:include href="../doctypes/variables.xsl"/>
  <xsl:include href="../common/footer.xsl"/>
  <xsl:include href="../common/navigation.xsl"/>


  <xsl:template match="document">
    <xsl:apply-templates select="content"/>
  </xsl:template>


  <xsl:template match="content">
    <xsl:choose>
      <xsl:when test="$rendertype = 'bc'">
        <xsl:apply-templates select="/document/xhtml:div[@id = 'breadcrumb']"/>
      </xsl:when>
      <xsl:when test="$rendertype = 'menu'">
        <div id="col1">
          <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']"/>
        </div>
      </xsl:when>
      <xsl:when test="$rendertype = 'tabs'">
        <xsl:apply-templates select="/document/xhtml:div[@id = 'tabs']"/>
      </xsl:when>
      <xsl:when test="$rendertype = 'views'">
        <xsl:apply-templates select="/document/xhtml:div[@id = 'orthonav']"/>
      </xsl:when>
      <xsl:when test="$rendertype = 'utilities'">
        <xsl:apply-templates select="/document/xhtml:div[@id = 'servicenav']"/>
      </xsl:when>
      <xsl:when test="$rendertype = 'devices'">
        <xsl:apply-templates select="/document/xhtml:div[@id = 'toolnav']"/>
      </xsl:when>
      <xsl:when test="$rendertype = 'footer'">
        <xsl:call-template name="footer"/>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template> 
  
</xsl:stylesheet>
