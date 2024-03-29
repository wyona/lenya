<?xml version="1.0" encoding="UTF-8"?>
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
<!--
  Build the Eclipse .classpath file from a list of path items
  (see "eclipse-project" target in build.xml)
  
  $Id: make-classpath.xsl 377700 2006-02-14 11:30:02Z andreas $
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output indent="yes" method="xml"/>
  <xsl:param name="exportlib"/>
  <xsl:param name="lenyaProjectName"/>
  
  <xsl:strip-space elements="*"/>

  <xsl:template match="/data">
    <classpath>

      <!-- 1. source dirs -->
      <xsl:for-each select="src-dirs/item">
        <!-- alphabetical sorting, complete path -->
        <xsl:sort select="."/>
        <classpathentry kind="src" path="{.}"/>
      </xsl:for-each>
          
      <!-- 2. libraries -->
      <xsl:for-each select="libs/item">
        <!-- alphabetical sorting, only file name -->
        <!-- heavy calculation, but here's the logic:
             1. returns the string after 4 slashes (4 is the max (blocks)),
                returns empty string if string does not contain 4 slashes
             2. ... 3 slashes ...
             3. ... 2 slashes ... (the minimum) -->
        <xsl:sort select="concat(substring-after(substring-after(substring-after(substring-after(., '/'), '/'), '/'), '/'),
                                                 substring-after(substring-after(substring-after(., '/'), '/'), '/'),
                                                                 substring-after(substring-after(., '/'), '/'))"/>
        <classpathentry exported="{$exportlib}" kind="lib" path="{.}"/>
      </xsl:for-each>

      <!-- 3. JRE runtime -->
	<classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER"/>
     
      <!-- 4. output directory
           Build in a separate dir since Eclipse is confused
           by classes compiled externally by Sun's Javac -->
      <classpathentry kind="output" path="{output}"/>

      <!-- 5. Dependance on Lenya. There needs to be a Lenya 1.4-dev eclipse project -->
      <classpathentry kind="src" path="/{$lenyaProjectName}"/>

    </classpath>
  </xsl:template>

</xsl:stylesheet>
