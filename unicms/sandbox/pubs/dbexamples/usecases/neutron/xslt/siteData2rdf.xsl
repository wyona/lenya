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
    xmlns:dir="http://apache.org/cocoon/directory/2.0">

<xsl:param name="areaBaseURL"/>
<xsl:param name="internalURIPrefix"/>
<xsl:param name="publicationID"/>
<xsl:param name="languages"/>
<xsl:param name="defaultlanguage"/>  


<xsl:template match="/sitedata">
  <RDF>
    <Description about="{$areaBaseURL}/site.rdf" map:root="{$areaBaseURL}/" map:defaultLanguage="de" dc:name="{$publicationID}"/>
    <xsl:call-template name="create-resources"/>
    <xsl:call-template name="create-navigation"/>
    <xsl:copy-of select="/sitedata/dir:directory"/>
  </RDF>
</xsl:template>


<xsl:template name="create-resources">

  <!-- Documents -->

  <xsl:for-each select="descendant::tree:node">

    <xsl:variable name="documentID">
      <xsl:for-each select="ancestor-or-self::tree:node">
        <xsl:value-of select="concat('/', @id)"/>
      </xsl:for-each>
    </xsl:variable>

    <xsl:for-each select="tree:label">
      <xsl:variable name="fileName">
        <xsl:choose>
          <xsl:when test="@xml:lang = $defaultlanguage">
            <xsl:value-of select="concat(@id, '.html')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('_', @xml:lang, '.html')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="url" select="concat($areaBaseURL, $documentID, $fileName)"/>
      <xsl:variable name="internalURI" select="concat($internalURIPrefix, $documentID, $fileName)"/>

      <map:resource about="{$url}" dc:name="{.}" map:internalURI="{$internalURI}" dc:language="{@xml:lang}" dc:format="text/html"/> 
    </xsl:for-each>     
  </xsl:for-each> 

  <!-- Assets -->

  <xsl:for-each select="//map:asset"> 
    <map:resource about="{concat($areaBaseURL, @path)}" map:internalURI="{concat($internalURIPrefix, @path)}" dc:name="{@name}" dc:title="{dc:metadata/dc:title}" dc:format="{dc:metadata/dc:format}"/>

  </xsl:for-each>

</xsl:template>


<xsl:template name="create-navigation">

  <xsl:call-template name="create-container-props"/>

  <map:navigation about="{$areaBaseURL}/">
    <map:childNodes>
      <Seq>
        <xsl:for-each select="tree:site/tree:node">
          <xsl:variable name="url">
            <xsl:value-of select="$areaBaseURL"/>
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
    <xsl:variable name="documentID">
      <xsl:for-each select="ancestor-or-self::tree:node">
        <xsl:value-of select="concat('/', @id)"/>
      </xsl:for-each>
    </xsl:variable>


   <xsl:variable name="url" select="concat($areaBaseURL, $documentID)"/>

    <map:node about="{$url}" dc:name="{@id}">
      <map:resources>
        <Bag>
          <xsl:for-each select="tree:label">
            <xsl:variable name="url">
              <xsl:value-of select="$areaBaseURL"/>
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

          <!-- Assets -->
          <xsl:for-each select="//map:asset[@refID = $documentID]">
            <li resource="{concat($areaBaseURL, $documentID, '/', @name)}"/>
          </xsl:for-each>   
        </Bag>
      </map:resources>

      <xsl:if test="tree:node">
        <map:childNodes>
          <Seq>
            <xsl:for-each select="tree:node">
              <xsl:variable name="url">
                <xsl:value-of select="$areaBaseURL"/>
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
