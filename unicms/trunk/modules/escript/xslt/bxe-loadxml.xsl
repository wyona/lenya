<?xml version="1.0" encoding="UTF-8" ?>


<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://unizh.ch/doctypes/elml/1.0"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
    xmlns:elml="http://unizh.ch/doctypes/elml/1.0"
    xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
>


<xsl:param name="nodeid"/>

<!-- remove camelCase attributes -->

<xsl:template match="@*">
  <xsl:attribute name="{translate(name(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')}">
    <xsl:value-of select="."/>
  </xsl:attribute>
</xsl:template>


<!-- add body element -->

<xsl:template match="elml:lesson">
  <xsl:copy>
    <xsl:apply-templates select="@*[not(name() = 'title')]"/>
    <xsl:apply-templates select="lenya:meta"/>
    <xhtml:h1><xsl:value-of select="@title"/></xhtml:h1>
    <elml:body> <!-- non-standard, needed for bxe editing area selection -->
      <xsl:apply-templates select="*[not(self::lenya:meta or self::elml:metadata)]"/>
    </elml:body>
    <xsl:apply-templates select="elml:metadata"/>
  </xsl:copy>
</xsl:template>

<!-- move title from attribute to element for bxe preview -->

<xsl:template match="elml:unit | elml:learningObject">
  <xsl:copy>
    <xsl:apply-templates select="@*[not(name() = 'title')]"/>
    <xhtml:h2>
      <xsl:value-of select="@title"/>
    </xhtml:h2>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template>


<!-- elml2xhtml mapping -->

<xsl:template match="elml:paragraph">
  <xhtml:p>
    <xsl:apply-templates/>
  </xhtml:p>
</xsl:template> 

<xsl:template match="elml:newLine">
  <xhtml:br/>
</xsl:template>


<xsl:template match="elml:formatted">
  <xsl:choose>
    <xsl:when test="@style = 'italic'">
      <xhtml:em><xsl:apply-templates/></xhtml:em>
    </xsl:when>
    <xsl:when test="@style = 'bold'">
      <xhtml:strong><xsl:apply-templates/></xhtml:strong>
    </xsl:when>
    <xsl:when test="@style = 'crossedOut'">
      <xhtml:strike><xsl:apply-templates/></xhtml:strike>
    </xsl:when>
    <xsl:when test="@style = 'lowerCase'">
      <xhtml:span class="lowercase"><xsl:apply-templates/></xhtml:span>
    </xsl:when>
    <xsl:when test="@style = 'upperCase'">
      <xhtml:span class="uppercase"><xsl:apply-templates/></xhtml:span>
    </xsl:when>  
    <xsl:when test="@style = 'underlined'">
      <xhtml:u><xsl:apply-templates/></xhtml:u>
    </xsl:when>
    <xsl:when test="@style = 'code'">
      <xhtml:code><xsl:apply-templates/></xhtml:code>
    </xsl:when>
    <xsl:when test="@style = 'subscript'">
      <xhtml:sub><xsl:apply-templates/></xhtml:sub>
    </xsl:when>
    <xsl:when test="@style = 'superscript'">
      <xhtml:sup><xsl:apply-templates/></xhtml:sup>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="elml:table">
  <xhtml:table class="elml">
    <xsl:apply-templates select="@*|node()"/>
  </xhtml:table>
</xsl:template>

<xsl:template match="elml:tablerow">
  <xhtml:tr>
    <xsl:apply-templates/>
  </xhtml:tr>
</xsl:template>

<xsl:template match="elml:tabledata">
  <xhtml:td>
    <xsl:apply-templates/>
  </xhtml:td>
</xsl:template>

<xsl:template match="elml:tableheading">
  <xhtml:th>
    <xsl:apply-templates/>
  </xhtml:th>
</xsl:template>

<xsl:template match="elml:list">
  <xsl:choose>
    <xsl:when test="@listStyle = 'ordered'">
      <xhtml:ol>
        <xsl:apply-templates/>
      </xhtml:ol>
    </xsl:when>
    <xsl:otherwise>
      <xhtml:ul>
        <xsl:apply-templates/>
      </xhtml:ul>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="elml:item">
  <xhtml:li>
    <xsl:apply-templates/>
  </xhtml:li>
</xsl:template>


<xsl:template match="elml:link">
  <xhtml:a>
    <xsl:apply-templates select="@*|node()"/>
  </xhtml:a>
</xsl:template>


<xsl:template match="elml:multimedia">
  <xhtml:object data="{$nodeid}/{@src}">
    <xsl:attribute name="type">
      <xsl:choose>
        <xsl:when test="@mimeType = 'jpeg'">
          <xsl:text>image/jpeg</xsl:text>
        </xsl:when>
        <xsl:when test="@mimeType = 'gif'">
          <xsl:text>image/gif</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>
  </xhtml:object>
</xsl:template> 


<xsl:template match="elml:term">
  <elml:term> 
    <xsl:apply-templates select="@icon"/>
    <xsl:value-of select="@glossRef"/>
  </elml:term>
</xsl:template>



<xsl:template match="node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet> 
