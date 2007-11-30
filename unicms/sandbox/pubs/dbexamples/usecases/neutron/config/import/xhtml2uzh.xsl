<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns="http://www.w3.org/1999/xhtml"
>


  <xsl:template match="xhtml:b">
    <b>
      <xsl:apply-templates/>
    </b>
  </xsl:template>

  <xsl:template match="xhtml:i">
    <i>
      <xsl:apply-templates/>
    </i>
  </xsl:template>

  <xsl:template match="xhtml:big">
    <big>
      <xsl:apply-templates/>
    </big>
  </xsl:template>

  <xsl:template match="xhtml:small">
    <small>
      <xsl:apply-templates/>
    </small>
  </xsl:template>

  <xsl:template match="xhtml:em">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>

  <xsl:template match="xhtml:strong">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>


  <xsl:template match="xhtml:code">
    <code>
      <xsl:apply-templates/>
    </code>
  </xsl:template>

  <xsl:template match="xhtml:q">
    <q>
      <xsl:apply-templates/>
    </q>
  </xsl:template>


  <xsl:template match="xhtml:sub">
    <sub>
      <xsl:apply-templates/>
    </sub>
  </xsl:template>

  <xsl:template match="xhtml:sup">
    <sup>
      <xsl:apply-templates/>
    </sup>
  </xsl:template>


  <xsl:template match="xhtml:p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="xhtml:br">
    <xsl:if test="parent::p">
      <br>
        <xsl:apply-templates/>
      </br> 
    </xsl:if>
  </xsl:template>

  <xsl:template match="xhtml:h1">
    <h1>
      <xsl:apply-templates/>
    </h1>
  </xsl:template>


  <xsl:template match="xhtml:h2">
    <h2>
      <xsl:apply-templates/>
    </h2>
  </xsl:template>


  <xsl:template match="xhtml:h3">
    <h3>
      <xsl:apply-templates/>
    </h3>
  </xsl:template>


  <xsl:template match="xhtml:h4">
    <h4>
      <xsl:apply-templates/>
    </h4>
  </xsl:template>

   <xsl:template match="xhtml:h5">
    <h5>
      <xsl:apply-templates/>
    </h5>
  </xsl:template>

  <xsl:template match="xhtml:h6">
    <h6>
      <xsl:apply-templates/>
    </h6>
  </xsl:template>


  <xsl:template match="xhtml:table">
    <table class="grid">
      <xsl:for-each select="xhtml:tr|xhtml:tbody/xhtml:tr">
        <tr>
          <xsl:for-each select="xhtml:td">
            <td rowspan="{@rowspan}" colspan="{@colspan}"><xsl:apply-templates/></td>
          </xsl:for-each>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>


  <xsl:template match="xhtml:ul">
    <ul type="1">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>


  <xsl:template match="xhtml:ol">
    <ol type="1">
     <xsl:apply-templates/>
    </ol>
  </xsl:template>


  <xsl:template match="xhtml:li">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

 
  <xsl:template match="xhtml:a">
    <a href="{@href}"><xsl:apply-templates/></a>
  </xsl:template>


  <xsl:template match="text()">
    <xsl:copy-of select="."/>
  </xsl:template>


</xsl:stylesheet>
