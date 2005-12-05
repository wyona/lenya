<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: menu.xsl,v 1.5 2005/12/05 15:29:24 mike.unizh Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="nav"
    >


<xsl:param name="chosenlanguage"/>
<xsl:param name="root"/>
   

<xsl:template match="nav:site">
  <xsl:if test="contains($root, '/id/') or contains($root, '/idsandbox/')">
    <xhtml:div id="orthonav">
      <xsl:apply-templates select="//nav:node[@current = 'true']"/>
    </xhtml:div>
  </xsl:if>
</xsl:template>


<xsl:template match="nav:node">
  <xsl:choose>
    <xsl:when test="starts-with(@basic-url,'xhtml') and $chosenlanguage != 'en'">
      <xsl:call-template name="orthonav">
        <xsl:with-param name="languages">de,st,ma,do,it</xsl:with-param>
        <xsl:with-param name="labels">Alle,Studierende,Mitarbeitende,Dozierende,IT-Verantwortliche</xsl:with-param>
        <xsl:with-param name="other-languages" select="@other-languages"/>
        <xsl:with-param name="basic-url" select="@basic-url"/>
      </xsl:call-template> 
    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:template>


<xsl:template name="orthonav">

  <xsl:param name="languages"/>
  <xsl:param name="labels"/>
  <xsl:param name="other-languages"/>
  <xsl:param name="basic-url"/>

  <xsl:choose>
    <xsl:when test="contains($languages, ',')">

      <xsl:call-template name="orthonav">
        <xsl:with-param name="languages">
          <xsl:value-of select="substring-before($languages, ',')"/>
        </xsl:with-param>
        <xsl:with-param name="labels">
          <xsl:value-of select="substring-before($labels, ',')"/>
        </xsl:with-param>
        <xsl:with-param name="other-languages" select="$other-languages"/>
        <xsl:with-param name="basic-url" select="$basic-url"/>
      </xsl:call-template> 

      <xsl:call-template name="orthonav">
        <xsl:with-param name="languages">
          <xsl:value-of select="substring-after($languages, ',')"/>
        </xsl:with-param>
        <xsl:with-param name="labels">
          <xsl:value-of select="substring-after($labels, ',')"/>
        </xsl:with-param>
        <xsl:with-param name="other-languages" select="$other-languages"/>
        <xsl:with-param name="basic-url" select="$basic-url"/>
      </xsl:call-template> 

    </xsl:when>
    <xsl:when test="$languages != ''">

      <xsl:call-template name="orthonav-item">
        <xsl:with-param name="language">
          <xsl:value-of select="$languages"/>
        </xsl:with-param>
        <xsl:with-param name="label">
          <xsl:value-of select="$labels"/>
        </xsl:with-param>
        <xsl:with-param name="other-languages" select="$other-languages"/>
        <xsl:with-param name="basic-url" select="$basic-url"/>
      </xsl:call-template> 

    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>

</xsl:template>


<xsl:template name="orthonav-item">

  <xsl:param name="language"/>
  <xsl:param name="label"/>
  <xsl:param name="other-languages"/>
  <xsl:param name="basic-url"/>

  <xhtml:div>
    <xsl:if test="$language = $chosenlanguage">
      <xsl:attribute name="current">true</xsl:attribute>
    </xsl:if>

    <xsl:if test="contains($other-languages, $language)">
      <xsl:attribute name="href">
        <xsl:value-of select="$root"/>
        <xsl:value-of select="$basic-url"/>

        <xsl:choose>
          <xsl:when test="$language = 'de'"/>
          <xsl:otherwise>
            <xsl:value-of select="concat('_', $language)"/>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:value-of select="'.html'"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:value-of select="$label"/>
  </xhtml:div>

</xsl:template>


</xsl:stylesheet> 
