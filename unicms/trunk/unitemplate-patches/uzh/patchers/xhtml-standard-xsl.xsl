<?xml version="1.0" encoding="UTF-8" ?>
<!-- $Id: xhtml-standard-xsl.xsl, v 1.00 2006/11/22 12:00:00 mike Exp $ -->

<stylesheet version="1.0" xmlns="http://www.w3.org/1999/XSL/Transform"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:foo="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsl="http://www.unizh.ch/dummy-ns/"
    exclude-result-prefixes="foo">

  <variable name="newline" select="'&#xa;'"/>

  <template match="foo:stylesheet">
    <value-of select="$newline"/>
    <copy>
      <apply-templates select="@*|node()"/>
      <xsl:include href="add-ons/xhtml-standard-add-on.xsl"/>
      <value-of select="$newline"/>
      <value-of select="$newline"/>
    </copy>
  </template>

  <template match="foo:template">
    <choose>
      <when test="@name='name-of-patched-template'">
      </when>
      <otherwise>
        <copy>
          <apply-templates select="@*|node()"/>
        </copy>
      </otherwise>
    </choose>
  </template>

<!--
  <template match="xhtml:div[(@class='relatedbox') and (ancestor::foo:template/@name='homepage4columns')]">
    <xhtml:div>
      <attribute name="bxe_xpath">/{$document-element-name}/unizh:related-content-extended</attribute>
      <apply-templates select="@*|node()"/>
    </xhtml:div>
  </template>

  <template match="foo:apply-templates[(ancestor::foo:template/@name='homepage4columns') and (@select='*/unizh:related-content')]">
    <foo:apply-templates>
      <attribute name="select">
        <text>*/unizh:related-content-extended</text>
      </attribute>
      <apply-templates select="@*|node()"/>
    </foo:apply-templates>
  </template>
-->

  <template match="@*|node()">
    <copy>
      <apply-templates select="@*|node()"/>
    </copy>
  </template>

</stylesheet> 
