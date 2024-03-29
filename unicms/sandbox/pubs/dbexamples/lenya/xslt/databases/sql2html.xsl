<?xml version="1.0"?>
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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:template name="generateJavascript">
   <script language="javascript">
   <xsl:comment>
    function init()
   {
	var Table1Sorter = new TSorter;
	Table1Sorter.init('dbTable');
   }
   window.onload = init;
   </xsl:comment>
   </script>
  </xsl:template>

  <xsl:template match="sql:rowset">
  <xsl:call-template name="generateJavascript"/>
   <xsl:choose>
    <xsl:when test="ancestor::sql:rowset">
     <tr>
      <td>
       <table border="1">
        <xsl:apply-templates/>
       </table>
      </td>
     </tr>
    </xsl:when>
    <xsl:otherwise>
     <table class="grid" id="dbTable">
       <thead>
       <tr>
	 <xsl:for-each select="./sql:row[1]/sql:*">
	   <th class="descend"><xsl:value-of select="local-name()"/></th>
	 </xsl:for-each>
       </tr>
       </thead>
       <tbody>
       <xsl:apply-templates/>
       </tbody>
     </table>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:template>

  <xsl:template match="sql:row">
   <tr>
    <xsl:apply-templates select="sql:*"/>
   </tr>
  </xsl:template>

  <xsl:template match="sql:*">
   <td><xsl:value-of select="."/></td>  
  </xsl:template>
 
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
