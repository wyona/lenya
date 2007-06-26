<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Copyright 1999-2004 The Apache Software Foundation

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->

<!-- $Id: sitetree2rdf.xsl 158907 2005-03-24 10:19:14Z michi $ -->

<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tree="http://apache.org/cocoon/lenya/sitetree/1.0"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:map="http://lenya.apache.org/sitemap/"
    >

<xsl:param name="baseurl"/>
<xsl:param name="languages"/>
<xsl:param name="defaultlanguage"/>  

<xsl:template match="/">
  <xsl:apply-templates select="tree:site"/>
</xsl:template>

<xsl:template match="tree:site">
  <RDF>
    <Description about="{$baseurl}/site.rdf" map:root="{$baseurl}/" map:defaultLanguage="de" dc:name="Unitemplate Sitemap"/>
    <xsl:call-template name="create-resources"/>
    <xsl:call-template name="create-navigation"/>
  </RDF>
</xsl:template>


<xsl:template name="create-resources">

  <xsl:for-each select="descendant::tree:node">
    <xsl:for-each select="tree:label">
      <xsl:variable name="url">
        <xsl:value-of select="$baseurl"/>
        <xsl:for-each select="ancestor::tree:node">
          <xsl:value-of select="concat('/', @id)"/>
        </xsl:for-each>
        <xsl:choose>
          <xsl:when test="@xml:lang = $defaultlanguage">
            <xsl:value-of select="concat(@id, '.html')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('_', @xml:lang, '.html')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <map:resource about="{$url}" dc:name="{.}" dc:language="{@xml:lang}"/>
    </xsl:for-each>     
  </xsl:for-each>

</xsl:template>


<xsl:template name="create-navigation">

  <xsl:call-template name="create-container-props"/>

  <map:navigation about="{$baseurl}/">
    <map:childNodes>
      <Seq>
        <xsl:for-each select="tree:node">
          <xsl:variable name="url">
            <xsl:value-of select="$baseurl"/>
            <xsl:for-each select="ancestor-or-self::tree:node">
              <xsl:value-of select="concat('/', @id)"/>
            </xsl:for-each>
          </xsl:variable>
          <li rdf:resource="{$url}"/>
        </xsl:for-each>
      </Seq>
    </map:childNodes>
  </map:navigation>
</xsl:template>

<xsl:template name="create-container-props">
  
  <xsl:for-each select="descendant::tree:node">
    <xsl:variable name="url">
      <xsl:value-of select="$baseurl"/>
      <xsl:for-each select="ancestor-or-self::tree:node">
        <xsl:value-of select="concat('/', @id)"/>
      </xsl:for-each>
    </xsl:variable>

    <map:node about="{$url}" dc:name="{@id}">
      <map:resources>
        <Bag>
          <xsl:for-each select="tree:label">
            <xsl:variable name="url">
              <xsl:value-of select="$baseurl"/>
              <xsl:for-each select="ancestor-or-self::tree:node">
                <xsl:value-of select="concat('/', @id)"/>
              </xsl:for-each>
              <xsl:choose>
                <xsl:when test="@xml:lang = $defaultlanguage">
                  <xsl:value-of select="concat(@id, '.html')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat(@id, '_', @xml:lang, '.html')"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <li resource="{$url}"/>
          </xsl:for-each>
        </Bag>
      </map:resources>

      <xsl:if test="tree:node">
        <map:childNodes>
          <Seq>
            <xsl:for-each select="tree:node">
              <xsl:variable name="url">
                <xsl:value-of select="$baseurl"/>
                <xsl:for-each select="ancestor-or-self::tree:node">
                  <xsl:value-of select="concat('/', @id)"/>
                </xsl:for-each>
              </xsl:variable>
              <li rdf:resource="{$url}"/>
            </xsl:for-each>
          </Seq>
        </map:childNodes>
      </xsl:if>
    </map:node>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet> 
