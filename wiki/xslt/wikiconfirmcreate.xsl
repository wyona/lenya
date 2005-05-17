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
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:req="http://apache.org/cocoon/request/2.0"
>

  <xsl:param name="parentid"/>

  <xsl:template match="/">
    <xsl:variable name="nodename"><xsl:value-of select="/req:request/req:requestParameters/req:parameter[@name='path']/req:value/text()"/></xsl:variable>
    <html>
    <body>
      Do you really want to create this page?
      <form method="POST" action="?lenya.usecase=wikicreate&amp;lenya.step=create">
        <input type="hidden" name="childtype" value="branch"/>
        <!--<input type="hidden" name="childtype" value="leaf"/>-->
        <!-- NOTE: This is quite a hack, because the Lenya creator API does not forward the parentid to the creator as a separate parameter, but only as part of the parent dir! -->
        <input type="hidden" name="childid" value="{$parentid}{$nodename}"/>
        <!--<input type="hidden" name="parentid" value="{$parentid}"/>-->
        <input type="hidden" name="doctype" value="wiki"/>
	<p>
        ID: <xsl:value-of select="$nodename"/><br/>
        Name: <input type="text" name="childname" value="New Wiki Page"/><br/>
	</p>
        <input type="submit" name="create" value="YES"/>
        <input type="submit" name="cancel" value="cancel"/>
      </form>
    </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
