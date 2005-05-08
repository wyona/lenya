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
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:chaperon="http://chaperon.sourceforge.net/schema/text/1.0"
  >

  <xsl:param name="docid" select="'not specified'"/>
  <xsl:param name="language" select="'not specified'"/>
  <xsl:param name="message" />


  


  <xsl:template match="/">
    <html>
    <head>
      <title>Edit Document</title>
      </head>
      <body>

	<div class="lenya-box">
	  <div class="lenya-box-title">Information</div>
	  <div class="lenya-box-body">
	    
	    <table class="lenya-table-noborder">
	      <tr>
		<td class="lenya-entry-caption"><i18n:text>Document&#160;ID</i18n:text>:</td>
		<td><xsl:value-of select="$docid"/></td>
	      </tr>
	      <tr>
		<td class="lenya-entry-caption"><i18n:text>Source</i18n:text>:</td>
		<td><xsl:value-of select="/chaperon:text/@source"/></td>
	      </tr>
	      <tr>
		<td class="lenya-entry-caption"><i18n:text>Language</i18n:text>:</td>
		<td><xsl:value-of select="$language"/></td>
	      </tr>

	      <xsl:if test="$message">
		<tr>
		  <td valign="top" class="lenya-entry-caption">
		    <span class="lenya-error"><i18n:text>Message</i18n:text>:</span>
		  </td>
		  <td>
		    <font color="red">
		      <xsl:value-of select="$message" />
		    </font>
		    <br /><br />
		    (Check log files for more details: lenya/WEB-INF/logs/*)</td>
		</tr>
	      </xsl:if>
	    </table>
	    
	  </div>
	</div>
	
	
        <div class="lenya-box">

          <div class="lenya-box-body">
            <ul>
              <li>!!! A very large title</li>
              <li>!! A large title</li>
              <li>! A title</li>
              <li>* A list item</li>
              <li>[A link]</li>
            </ul>
          </div>

        </div>

        <div class="lenya-box">
          <div class="lenya-box-body">
            <form name="hugo" method="POST" action="?lenya.usecase=wikiedit&amp;lenya.step=close">
	    <!--
            <form name="hugo" method="POST" enctype="multipart/form-data" action="">
              <input type="hidden" name="lenya.usecase" value="wikiedit"/>
              <input type="hidden" name="lenya.step" value="close"/>
	      -->
              <table border="0">
                <tr>
                  <td align="left">
                    <input type="submit" value="Save" name="save" />
                    <input type="submit" value="Cancel" name="cancel" />
                  </td>
                </tr>
                <tr>
                  <td>
                    <textarea name="content" cols="80" rows="80">
                      <xsl:apply-templates/>
                    </textarea>
                  </td>
                </tr>
                <tr>
                  <td align="left">
                    <input type="submit" value="Save" name="save" />
                    <input type="submit" value="Cancel" name="cancel" />
                  </td>
                </tr>
              </table>
            </form>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
