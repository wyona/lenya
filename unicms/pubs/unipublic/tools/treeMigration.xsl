<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://apache.org/cocoon/lenya/sitetree/1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 

<xsl:template match="tree">
  <site label="Authoring">
    <xsl:apply-templates/>
  </site>  
</xsl:template>

<xsl:template match="branch">
  <xsl:choose>
    <xsl:when test="@doctype='Front'">
      <node id="index">
        <xsl:attribute name="visibleinnav">false</xsl:attribute>
        <label xml:lang="de">Unipublic</label>
      </node>
      <xsl:apply-templates select="branch"/>
    </xsl:when>
    <xsl:when test="@relURI='1013' and ../@relURI='2003' and ../../@relURI='wirtschaft'">
    </xsl:when>
    <xsl:when test="@relURI='test_wyona' and ../@relURI='2003' and ../../@relURI='wirtschaft'">
    </xsl:when>
    <xsl:when test="@relURI='2' and ../@relURI='2003' and ../../@relURI='gesundheit'">
    </xsl:when>
    <xsl:when test="@relURI='test' and ../@relURI='2004' and ../../@relURI='umwelt'">
    </xsl:when>
    <xsl:when test="@relURI='wyona_test' and ../@relURI='2003' and ../../@relURI='portraits'">
    </xsl:when>
    <xsl:when test="@relURI='test' and ../@relURI='2004' and ../../@relURI='uni-news'">
    </xsl:when>
    <xsl:when test="@relURI='0864' and ../@relURI='2004' and ../../@relURI='uni-news'">
    </xsl:when>
    <xsl:otherwise>
      <node>
        <xsl:if test="@doctype='Article'or @doctype='Year'or @doctype='Dossier'">
          <xsl:attribute name="visibleinnav">false</xsl:attribute>
        </xsl:if>     
        <xsl:attribute name="id">
          <xsl:value-of select="@relURI"/>
        </xsl:attribute>
        <label>
          <xsl:attribute name="xml:lang"><xsl:text>de</xsl:text></xsl:attribute>
          <xsl:value-of select="@menuName"/>
        </label>
        <xsl:apply-templates select="branch"/>
      </node>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet> 
