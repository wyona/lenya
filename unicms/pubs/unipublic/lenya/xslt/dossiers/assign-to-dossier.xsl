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

<xsl:stylesheet version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"    
  xmlns:page="http://apache.org/cocoon/lenya/cms-page/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  >

    
<xsl:param name="requestUri"/>

<xsl:template match="/">
  <page:page>
    <page:title>Assign Article to Dossier</page:title>
    <page:body>
      <div class="lenya-box">
        <div class="lenya-box-title">Assign Article to Dossier</div>
        <div class="lenya-box-body">
          <form method="get" action="{$requestUri}">
            <input type="hidden" name="lenya.usecase" value="assigndossier"/>
            <input type="hidden" name="lenya.step" value="select"/>
            <input type="hidden" name="document-id" value="{dossier-list/document-id}"/>
            <input type="hidden" name="document-language" value="{dossier-list/document-language}"/>
            <input type="hidden" name="user-id" value="{dossier-list/user-id}"/>
            <input type="hidden" name="workflow-event" value="{dossier-list/workflow-event}"/>
            <input type="hidden" name="ip-address" value="{dossier-list/ip-address}"/>
            <input type="hidden" name="role-ids" value="{dossier-list/role-ids}"/>
          

            <table class="lenya-table-noborder">
              <xsl:apply-templates select="dossier-list/dossier"/>
            	<tr>
       		    <td/>
                <td>
          		  <br/>
                  <input type="submit" value="Select"/>&#160;
                  <input type="button" onClick="location.href='{$requestUri}';" value="Cancel"/>
                </td>
              </tr>
            </table>

          </form>
        </div>
      </div>
    </page:body>
  </page:page>
</xsl:template>

  <xsl:template match="dossier">
    <xsl:variable name="dossierId"><xsl:value-of select="./@id"/></xsl:variable>
    <xsl:variable name="num"><xsl:value-of select="position()"/></xsl:variable>
    <xsl:variable name="paramName"><xsl:value-of select="concat('dossier-id_',$num)"/></xsl:variable>
    <tr>
      <td>  
      <input type="checkbox" name="{$paramName}" value="{$dossierId}">
        <xsl:choose>
          <xsl:when test="@selected = 'true'">
            <xsl:attribute name="checked"/>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </input>
      &#160;<strong><xsl:value-of select="."/></strong>
      <xsl:if test="$dossierId != 'none'">
        (<xsl:value-of select="$dossierId"/>)
      </xsl:if>
    </td>
  </tr>
  </xsl:template>
  
<xsl:template match="*"/>

</xsl:stylesheet>