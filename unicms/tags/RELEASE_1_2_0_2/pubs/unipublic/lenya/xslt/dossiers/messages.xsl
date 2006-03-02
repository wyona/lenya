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

<xsl:template match="/dossier">
  <page:page>
    <page:title>Assign Article to Dossier</page:title>
    <page:body>
      <div class="lenya-box">
        <div class="lenya-box-title">Assign Article to Dossier</div>
        <div class="lenya-box-body">
          <table class="lenya-table-noborder">
            <xsl:choose>
              <xsl:when test="./message">
                <xsl:apply-templates select="./message"/>
              </xsl:when>
              <xsl:otherwise>
                <tr><td>Please go back to the article</td></tr> 
              </xsl:otherwise>
            </xsl:choose>
          	<tr>
   		      <td/>
              <td>
          		<br/>
                  <button type="submit" onClick="location.href='{$requestUri}';">Back to the article</button>
              </td>
            </tr>
          </table>
        </div>
      </div>
    </page:body>
  </page:page>
</xsl:template>

<xsl:template match="message">
  <tr>
    <td>  
      <xsl:apply-templates/>
    </td>
  </tr>
</xsl:template>
  
<xsl:template match="*"/>

</xsl:stylesheet>