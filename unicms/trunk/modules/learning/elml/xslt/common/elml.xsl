<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id$ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:elml="http://www.elml.ch"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:level="http://apache.org/cocoon/lenya/documentlevel/1.0" 
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  >

  <xsl:template match="lenya:meta"/>
  <xsl:template match="unizh:header"/>

  <xsl:template match="elml:lesson">
    <xsl:if test="@label">
      <a name="{@label}"><xsl:comment/></a>
    </xsl:if>
    <xsl:apply-templates select="*[not(self::unizh:header or self::elml:metadata or self::lenya:meta)]"/>
  </xsl:template>

  <xsl:template match="elml:entry">
    <xsl:if test="@label">
      <a name="{@label}"><xsl:comment/></a>
    </xsl:if>
    <xsl:if test="@title">
      <h2><xsl:value-of select="@title"/></h2>
    </xsl:if>
    <div>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="elml:goals">
    <div>
     <xsl:if test="@intStatement">
       <xsl:value-of select="@intStatement"/>
     </xsl:if>
     <xsl:choose>
       <xsl:when test="@presentation = 'table'">
         <table class="grid">
           <xsl:for-each select="elml:lObjective">
             <tr>
               <td><xsl:apply-templates/></td>
             </tr>
           </xsl:for-each>
         </table>
       </xsl:when>
       <xsl:otherwise>
         <ul>
            <xsl:for-each select="elml:lObjective">
              <li><xsl:apply-templates/></li>
            </xsl:for-each>
         </ul>
       </xsl:otherwise>
     </xsl:choose> 
    </div>
  </xsl:template>

  <xsl:template match="elml:lObjective">
    <xsl:value-of select="."/>
  </xsl:template>


  <xsl:template match="elml:unit">
    <div>
      <xsl:if test="@label">
        <a name="{@label}"><xsl:comment/></a>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="elml:learningObject">
    <xsl:if test="@label">
      <a name="{@label}"><xsl:comment/></a>
    </xsl:if>
    <h2><xsl:value-of select="@title"/></h2>
    <div>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="elml:clarify">
    <xsl:if test="@label">
      <a name="{@label}"><xsl:comment/></a>
    </xsl:if>
    <xsl:if test="@title">
      <h2><xsl:value-of select="@title"/></h2>
    </xsl:if>
    <div>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="elml:look">
    <xsl:if test="@label">
      <a name="{@label}"><xsl:comment/></a>
    </xsl:if>
    <xsl:if test="@title">
      <h2><xsl:value-of select="@title"/></h2>
    </xsl:if>
    <div>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="elml:act">
    <xsl:if test="@label">
      <a name="{@label}"><xsl:comment/></a>
    </xsl:if>
    <xsl:if test="@title">
      <h2><xsl:value-of select="@title"/></h2>
    </xsl:if>
    <div>
      <xsl:apply-templates/>  <!-- metaSetUpInfo in tutor view -->
    </div>
  </xsl:template>


  <xsl:template match="elml:selfAssessment">
    <div>
      <xsl:if test="@label">
        <a name="{@label}"><xsl:comment/></a>
      </xsl:if>
      <xsl:if test="@title and parent::elml:unit">
        <h2><xsl:value-of select="@title"/></h2>
      </xsl:if>
      <xsl:apply-templates/> <!-- metaSetUpInfo in tutor view -->
    </div>
  </xsl:template>

  <xsl:template match="elml:summary">
    <div>
      <xsl:if test="@label">
        <a name="{@label}"><xsl:comment/></a>
      </xsl:if>
      <xsl:if test="@title and parent::elml:unit">
        <h2><xsl:value-of select="@title"/></h2>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
 
  <xsl:template match="elml:furtherReading">
    <ul>
      <xsl:for-each select="elml:resItem">
        <xsl:variable name="id" select="@bibIDRef"/>
        <xsl:choose>
          <xsl:when test="@sorting='off'">
            <xsl:apply-templates select="/document/unizh:level/level:node/*/elml:bibliography/*[@bibID=$id]">
              <xsl:with-param name="comment" select="text()"/>
              <xsl:with-param name="furtherReading" select="@bibIDRef"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="/document/unizh:level/level:node/*/elml:bibliography/*[@bibID=$id]">
              <xsl:with-param name="comment" select="text()"/>
                <xsl:with-param name="furtherReading" select="@bibIDRef"/>
              <xsl:sort select="@author" order="ascending" lang="de"/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="."/>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template match="elml:glossary">
    <div>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="elml:definition">
    <div>
      <a name="{@term}"><xsl:comment/></a>
      <b><xsl:value-of select="@term"/></b>: 
      <xsl:apply-templates/>
      <xsl:call-template name="BibliographyRef"/>
    </div>
  </xsl:template>

  <xsl:template match="elml:term">
    <xsl:variable name="glossRef" select="@glossRef"/>
    <xsl:variable name="glossPageUrl" select="concat($contextprefix, /document/unizh:level/level:node[*/elml:glossary]/@href)"/>
    <xsl:variable name="definition" select="/document/unizh:level/level:node/*/elml:glossary/elml:definition[@term = $glossRef]/text()"/>
    <!-- <xsl:if test="@icon">
      <img src="{$imageprefix}/icons/{@icon}.gif"/>
    </xsl:if> -->
    <xsl:choose>
      <xsl:when test="preceding-sibling::*[1][text()]">
        <p>
          <b><xsl:value-of select="$glossRef"/><xsl:comment/></b>:
          <xsl:apply-templates select="$definition"/>
        </p>
      </xsl:when>
      <xsl:otherwise>
          <a href="{concat($glossPageUrl, '#', $glossRef)}" alt="{$definition}" title="{$definition}"><xsl:value-of select="$glossRef"/></a>
      </xsl:otherwise>
    </xsl:choose> 
  </xsl:template>


  <!-- further elements -->

  <xsl:template match="elml:column">
    <xsl:if test="@label">
      <a name="{@label}"><xsl:comment/></a>
    </xsl:if>
    <table border="0" width="100%">
      <tr>
        <xsl:apply-templates/>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="elml:columnLeft">
     <!-- eventually add support for align, width, height, unit -->
     <td>
       <xsl:call-template name="Alignment"/>
       <xsl:apply-templates/>
     </td>
  </xsl:template>

  <xsl:template match="elml:columnMiddle">
     <!-- eventually add support for align, width, height, unit -->
     <td>
       <xsl:call-template name="Alignment"/>
       <xsl:apply-templates/>
     </td>
  </xsl:template>

  <xsl:template match="elml:columnRight">
     <!-- eventually add support for align, width, height, unit -->
     <td>
       <xsl:call-template name="Alignment"/>
       <xsl:apply-templates/>
     </td>
  </xsl:template>

  <xsl:template match="elml:table">
    <!-- eventually add support for width, height, units -->
    <xsl:if test="@label">
      <a name="{@label}"><xsl:comment/></a>
    </xsl:if>
    <xsl:if test="@icon">
      <img src="{$imageprefix}/icons/{@icon}.gif"/>
    </xsl:if>
    <xsl:if test="@title">
      <xsl:value-of select="@title"/>
    </xsl:if>
    <table border="0" width="100%" class="grid">
        <xsl:apply-templates/>
    </table>
    <xsl:if test="@legend">
      <xsl:value-of select="@legend"/>
      <xsl:call-template name="BibliographyRef"/>
      <br/>
      <br/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="elml:tablerow">
    <tr>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>

  <xsl:template match="elml:tableheading">
    <!-- eventually add support for align, width, height, units -->
    <th>
      <xsl:call-template name="Alignment"/>
      <xsl:if test="@rowspan">
        <xsl:attribute name="rowspan"><xsl:value-of select="@rowspan"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="@colspan">
        <xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </th>
  </xsl:template>

  <xsl:template match="elml:tabledata">
    <td>
      <xsl:call-template name="Alignment"/>
      <xsl:if test="@rowspan">
        <xsl:attribute name="rowspan"><xsl:value-of select="@rowspan"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="@colspan">
        <xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </td>
  </xsl:template>

  <xsl:template match="elml:list">
    <xsl:if test="@label">
      <a name="{@label}"><xsl:comment/></a>
    </xsl:if>
    <xsl:if test="@icon">
      <img src="{$imageprefix}/icons/{@icon}.gif"/>
    </xsl:if>
    <xsl:if test="@title">
      <h2><xsl:value-of select="@title"/></h2>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@listStyle = 'ordered'">
        <ol>
          <xsl:apply-templates/>
        </ol>
      </xsl:when>
      <xsl:otherwise>
        <ul>
          <xsl:apply-templates/>
        </ul>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="BibliographyRef"/>
  </xsl:template>

  <xsl:template match="elml:item">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <xsl:template match="elml:box">
    <xsl:if test="@label">
      <a name="{@label}"><xsl:comment/></a>
    </xsl:if>
    <table border="0" width="100%" bgcolor="#dedede">
      <tr>
        <xsl:if test="@icon">
          <td>
            <img src="{$imageprefix}/icons/{@icon}.gif"/>
          </td>
        </xsl:if>
        <td>
          <xsl:if test="@title">
            <b><xsl:value-of select="@title"/></b><br/>
          </xsl:if>
          <xsl:apply-templates/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="indexItem">
    <xsl:choose>
      <xsl:when test="@mainEntry = 'yes'">
        <b><xsl:apply-templates/></b>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="elml:formatted">
    <xsl:choose>
      <xsl:when test="@style = 'bold'">
        <b><xsl:apply-templates/></b>
      </xsl:when>
      <xsl:when test="@style = 'italic'">
        <i><xsl:apply-templates/></i>
      </xsl:when>
      <xsl:when test="@style = 'underlined'">
        <u><xsl:apply-templates/></u>
      </xsl:when>
      <xsl:when test="@style = 'crossedOut'">
        <s><xsl:apply-templates/></s>
      </xsl:when>
      <xsl:when test="@style = 'upperCase'">
        <span style="text-transform:uppercase"><xsl:apply-templates/></span>
      </xsl:when>
      <xsl:when test="@style = 'lowerCase'">
        <span style="text-transform:lowercase"><xsl:apply-templates/></span>
      </xsl:when>
      <xsl:when test="@style = 'subscript'">
        <sub><xsl:apply-templates/></sub>
      </xsl:when>
      <xsl:when test="@style = 'superscript'">
        <sup><xsl:apply-templates/></sup>
      </xsl:when>
      <xsl:when test="@style = 'code'">
        <code><xsl:apply-templates/></code>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="elml:popup">
    <xsl:variable name="varname">
      <xsl:text>solution</xsl:text>
      <xsl:value-of select="generate-id()"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@icon">
        <table cellpadding="0" cellspacing="0" border="0" width="100%" class="content_table">
          <!-- <xsl:call-template name="Label"/> -->
            <tr>
              <td width="40" align="left" valign="top">
                <img src="{$imageprefix}/icons/{@icon}.gif"/>
              </td>
              <td valign="top">
              <div id="{$varname}" class="popupTitle">
                <xsl:attribute name="onclick">
                  <xsl:text>onBlock('</xsl:text>
                  <xsl:value-of select="$varname"/>
                  <xsl:text>')</xsl:text>
                </xsl:attribute>
                <h3>
                  <xsl:if test="@title">
                    <xsl:value-of select="@title"/>
                  </xsl:if>
                </h3>
                <p>(Mausklick um Loesung ein bzw. wieder auszublenden)</p>
              </div>
              <div id="{$varname}text" class="popupText" style="display: none;  background-color: #cccccc;">
                <xsl:if test="@title">
                  <xsl:attribute name="title">
                    <xsl:value-of select="@title"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:attribute name="onclick">
                  <xsl:text>off('</xsl:text>
                    <xsl:value-of select="$varname"/>
                  <xsl:text>')</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates/>
              </div>
            </td>
          </tr>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <div id="{$varname}" class="popupTitle">
          <xsl:attribute name="onclick">
            <xsl:text>onBlock('</xsl:text>
            <xsl:value-of select="$varname"/>
            <xsl:text>')</xsl:text>
          </xsl:attribute>
          <xsl:if test="@title">
            <h3><xsl:value-of select="@title"/></h3>
          </xsl:if>
          <p>
            <!-- <xsl:call-template name="Label"/> -->(Mausklick um Loesung ein bzw. wieder auszublenden)
          </p>
        </div>
        <div id="{$varname}text" style="display: none; background-color: #cccccc;">
          <xsl:if test="@title">
            <xsl:attribute name="title">
              <xsl:value-of select="@title"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:attribute name="onclick">
            <xsl:text>off('</xsl:text>
            <xsl:value-of select="$varname"/>
            <xsl:text>')</xsl:text>
          </xsl:attribute>
          <xsl:apply-templates/>
        </div>
      </xsl:otherwise>
     </xsl:choose> 
  </xsl:template>

  <xsl:template match="elml:link">
    <xsl:choose>
      <xsl:when test="@uri">
        <a href="{@uri}"><xsl:apply-templates/></a>
      </xsl:when>
      <xsl:otherwise>
        <a href="#{@targetLabel}"><xsl:apply-templates/><xsl:comment/></a>
      </xsl:otherwise> 
    </xsl:choose> 
  </xsl:template>


  <xsl:template match="elml:citation">
    "<i><xsl:apply-templates/><xsl:comment/></i>"
     <xsl:call-template name="BibliographyRef"/> 
  </xsl:template>


  <xsl:template match="elml:newLine">
    <br/>
    <xsl:if test="@space = 'long'">
    <br/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="elml:paragraph">
    <xsl:if test="@label">
      <a name="{@label}"><xsl:comment/></a>
    </xsl:if>
    
      <xsl:choose>
        <xsl:when test="@icon">
          <p>
          <table border="0">
            <tr>
              <td><img src="{$imageprefix}/icons/{@icon}.gif"/></td>
              <td><xsl:apply-templates/></td>
            </tr>
          </table>
          </p>
        </xsl:when>
        <xsl:otherwise>
          <p>
            <xsl:apply-templates/>
          </p>
        </xsl:otherwise>
      </xsl:choose>
    
  </xsl:template>



  <!-- Named templates --> 

  <xsl:template name="Legend">
    <xsl:if test="@legend or @bibIDRef">
      <div class="legend">
        <xsl:value-of select="@legend"/>
        <xsl:call-template name="BibliographyRef"/>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="Label">
    <!-- FIXME: Add support for labels -->
  </xsl:template>


  <xsl:template name="WidthHeight">
    <xsl:if test="@width">
      <xsl:attribute name="width">
        <xsl:value-of select="@width"/>
        <xsl:if test="@units='percent'">
          <xsl:text>%</xsl:text>
        </xsl:if>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="(@type='quicktime' or @type='mpeg' or @type='realone') and  not(@width)">
      <xsl:attribute name="width">128</xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="(@type='quicktime' or @type='mpeg' or @type='realone') and not(@height)">
        <xsl:attribute name="height">
          <xsl:value-of select="16"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="(@type='quicktime' or @type='mpeg' or @type='realone') and @height">
        <xsl:if test="not(@units='percent')">
          <xsl:attribute name="height">
            <xsl:value-of select="number(@height) + 16"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:when>
      <xsl:when test="@height">
        <xsl:attribute name="height">
          <xsl:value-of select="@height"/>
          <xsl:if test="@units='percent'">
            <xsl:text>%</xsl:text>
          </xsl:if>
        </xsl:attribute>   
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <!-- Asset Handling -->

 
  <xsl:template match="elml:multimedia">
    <xsl:if test="not(@visible='print')"><!-- check inline multimedia in original source for good -->
      <table cellpadding="0" cellspacing="2" border="0" width="100%" class="content_table">
        <tr>
          <xsl:if test="@icon">
            <td width="40" align="left" valign="top">
              <img src="{$imageprefix}/icons/{@icon}.gif" width="30" height="30" align="left" title="{@icon}" alt="{@icon}" class="icon"/>
            </td>
          </xsl:if>
          <td>
            <xsl:if test="not(@icon)">
              <xsl:attribute name="colspan">2</xsl:attribute>
            </xsl:if>
            <xsl:call-template name="Alignment">
              <xsl:with-param name="istd">yes</xsl:with-param>
            </xsl:call-template>
            <xsl:choose>
              <xsl:when test="$rendertype = 'imageupload'">
                <xsl:variable name="trimmedElementPath">
                  <xsl:for-each select="(ancestor-or-self::*)">
                    <xsl:call-template name="compute-path"/>
                  </xsl:for-each>
                </xsl:variable>
                <a href="?lenya.usecase=asset&amp;lenya.step=showscreen&amp;insert=true&amp;insertimage=true&amp;assetXPath={$trimmedElementPath}&amp;insertWhere=after&amp;insertTemplate=insertMultimedia.xml&amp;insertReplace=true">
                  <xsl:call-template name="MultimediaShow"/>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="MultimediaShow"/>
              </xsl:otherwise>
            </xsl:choose>
         </td>
        </tr>
        <xsl:if test="@legend or @bibIDRef">
          <tr>
            <xsl:if test="@icon">
              <td width="40" align="left" valign="top"/>
            </xsl:if>
            <td>
              <xsl:if test="not(@icon)">
                <xsl:attribute name="colspan">2</xsl:attribute>
              </xsl:if>
              <xsl:call-template name="Alignment">
                <xsl:with-param name="istd">yes</xsl:with-param>
              </xsl:call-template>
              <xsl:call-template name="Legend"/>
            </td>
          </tr>
        </xsl:if>
      </table>
    </xsl:if>
  </xsl:template>


  <xsl:template name="MultimediaAttributes">
    <xsl:call-template name="WidthHeight"/>
    <xsl:call-template name="Alignment"/>
      <xsl:if test="@legend">
        <xsl:attribute name="title">
          <xsl:value-of select="@legend"/>
        </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="MultimediaShow">
    <xsl:param name="pathMultimedia">
      <xsl:choose>
        <xsl:when test="@thumbnail">
          <xsl:value-of select="@thumbnail"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($nodeid, '/', @src)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:param name="pathMultimediaSource">
      <xsl:value-of select="$nodeid"/>/<xsl:value-of select="@src"/>
    </xsl:param>
    <xsl:choose>
      <xsl:when test="@thumbnail">
        <a href="{$pathMultimediaSource}" target="_blank">
        <xsl:call-template name="Image">
          <xsl:with-param name="pathMultimedia">
            <xsl:value-of select="$pathMultimedia"/>
          </xsl:with-param>
        </xsl:call-template>
       </a>
     </xsl:when>
     <xsl:when test="@type">
       <xsl:choose>
         <xsl:when test="@type='gif' or @type='jpeg' or @type='png'">
           <xsl:call-template name="Image">
             <xsl:with-param name="pathMultimedia">
               <xsl:value-of select="$pathMultimedia"/>
             </xsl:with-param>
           </xsl:call-template>
         </xsl:when>
         <xsl:when test="@type='flash'">
           <xsl:call-template name="Flash">
             <xsl:with-param name="pathMultimedia">
               <xsl:value-of select="$pathMultimedia"/>
             </xsl:with-param>
           </xsl:call-template>
         </xsl:when>
         <xsl:when test="@type='quicktime'">
           <xsl:call-template name="Quicktime">
             <xsl:with-param name="pathMultimedia">
               <xsl:value-of select="$pathMultimedia"/>
             </xsl:with-param>
           </xsl:call-template>
         </xsl:when>
         <xsl:when test="@type='mpeg'">
           <xsl:call-template name="MPEG">
             <xsl:with-param name="pathMultimedia">
               <xsl:value-of select="$pathMultimedia"/>
             </xsl:with-param>
           </xsl:call-template>
         </xsl:when>
         <xsl:when test="@type='svg'">
           <xsl:call-template name="SVG">
             <xsl:with-param name="pathMultimedia">
               <xsl:value-of select="$pathMultimedia"/>
             </xsl:with-param>
           </xsl:call-template>
         </xsl:when>
         <xsl:when test="@type='applet'">
           <xsl:call-template name="Applet">
             <xsl:with-param name="pathMultimedia">
               <xsl:value-of select="$pathMultimedia"/>
             </xsl:with-param>
           </xsl:call-template>
         </xsl:when>
         <xsl:when test="@type='vrml'">
           <xsl:call-template name="VRML">
             <xsl:with-param name="pathMultimedia">
               <xsl:value-of select="$pathMultimedia"/>
             </xsl:with-param>
           </xsl:call-template>
         </xsl:when>
         <xsl:when test="@type='x3d'">
           <xsl:call-template name="X3D">
             <xsl:with-param name="pathMultimedia">
               <xsl:value-of select="$pathMultimedia"/>
             </xsl:with-param>
           </xsl:call-template>
         </xsl:when>
         <xsl:when test="@type='realone'">
           <xsl:call-template name="RealOne">
             <xsl:with-param name="pathMultimedia">
               <xsl:value-of select="$pathMultimedia"/>
             </xsl:with-param>
           </xsl:call-template>
         </xsl:when>
         <xsl:when test="@type='mathml'">
           <xsl:copy-of select="child::*"/>
         </xsl:when>
         <xsl:when test="@type='div'">
           <xsl:copy-of select="."/>
         </xsl:when>
       </xsl:choose>
     </xsl:when>
   </xsl:choose>
   <xsl:if test="$rendertype = 'imageupload'">
      <xsl:call-template name="assetUpload">
        <xsl:with-param name="insertReplace">true</xsl:with-param>
        <xsl:with-param name="insertWhere">after</xsl:with-param>
      </xsl:call-template>
   </xsl:if>
  </xsl:template>


  <xsl:template name="Image">
    <xsl:param name="pathMultimedia"/>
    <img>
      <xsl:call-template name="Label"/>
        <xsl:attribute name="src">
        <xsl:value-of select="$pathMultimedia"/>
      </xsl:attribute>
      <xsl:call-template name="MultimediaAttributes"/>
      <xsl:attribute name="border">0</xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:value-of select="@legend"/>
      </xsl:attribute>
    </img>
  </xsl:template>


  <xsl:template name="Flash">
    <xsl:param name="pathMultimedia"/>
    <object classid="CLSID:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0">
    <xsl:call-template name="Label"/>
    <xsl:call-template name="MultimediaAttributes"/>
    <param name="movie">
      <xsl:attribute name="value">
        <xsl:value-of select="$pathMultimedia"/>
      </xsl:attribute>
     </param>
     <param name="quality" value="best"/>
     <param name="scale" value="exactfit"/>
     <param name="menu" value="true"/>
     <param name="play" value="true"/> 
     <embed pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" quality="best" scale="exactfit" menu="true" play="true">
       <xsl:call-template name="Label"/>
       <xsl:attribute name="src">
         <xsl:value-of select="$pathMultimedia"/>
       </xsl:attribute>
       <xsl:call-template name="MultimediaAttributes"/>
     </embed>
   </object>
  </xsl:template>

  <xsl:template name="Quicktime">
    <xsl:param name="pathMultimedia"/>
      <object classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" codebase="http://www.apple.com/qtactivex/qtplugin.cab">
        <xsl:call-template name="Label"/>
        <xsl:call-template name="MultimediaAttributes"/>
        <param name="src">
          <xsl:attribute name="value">
            <xsl:value-of select="$pathMultimedia"/>
          </xsl:attribute>
        </param>
        <param name="kioskmode" value="false"/>
        <param name="autoplay" value="true"/>
        <param name="controller" value="true"/>
        <embed autoplay="true" controller="true" pluginspage="http://www.apple.com/quicktime/download/" type="video/quicktime" kioskmode="false">
           <xsl:call-template name="Label"/>
           <xsl:attribute name="src">
             <xsl:value-of select="$pathMultimedia"/>
           </xsl:attribute>
           <xsl:call-template name="MultimediaAttributes"/>
         </embed>
       </object>
     </xsl:template>

   <xsl:template name="MPEG">
     <xsl:param name="pathMultimedia"/>
       <object classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" codebase="http://www.apple.com/qtactivex/qtplugin.cab">
     <xsl:call-template name="Label"/>
     <xsl:call-template name="MultimediaAttributes"/>
       <param name="src">
         <xsl:attribute name="value">
           <xsl:value-of select="$pathMultimedia"/>
         </xsl:attribute>
       </param>
       <param name="autostart" value="true"/>
       <param name="autoplay" value="true"/>
       <param name="controller" value="true"/>
       <embed autoplay="true" controller="true" pluginspage="http://www.apple.com/quicktime/download/" type="audio/mpeg" autostart="true">
        <xsl:call-template name="Label"/>
          <xsl:attribute name="src">
            <xsl:value-of select="$pathMultimedia"/>
          </xsl:attribute>
          <xsl:call-template name="MultimediaAttributes"/>
        </embed>
      </object> 
    </xsl:template>

  <xsl:template name="RealOne">
    <xsl:param name="pathMultimedia"/>
    <object classid="clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA">
      <xsl:call-template name="Label"/>
      <xsl:call-template name="MultimediaAttributes"/>
        <param name="src">
          <xsl:attribute name="value">
            <xsl:value-of select="$pathMultimedia"/>
          </xsl:attribute>
        </param>
        <param name="autostart" value="true"/>
        <param name="controls" value="ImageWindow"/>
          <embed pluginspage="http://www.real.com/" type="audio/x-pn-realaudio-plugin" controls="ImageWindow" autostart="true">
          <xsl:call-template name="Label"/>
          <xsl:attribute name="src">
            <xsl:value-of select="$pathMultimedia"/>
          </xsl:attribute>
          <xsl:call-template name="MultimediaAttributes"/>
          </embed>
        </object>
    </xsl:template>

  <xsl:template name="VRML">
    <xsl:param name="pathMultimedia"/>
    <object classid="CLSID:4B6E3013-6E45-11D0-9309-0020AFE05CC8  CLSID:86A88967-7A20-11d2-8EDA-00600818EDB1 CLSID:06646724-BCf3-11D0-9518-00C04FC2DD79">
      <xsl:call-template name="Label"/>
      <xsl:call-template name="MultimediaAttributes"/>
      <param name="src">
        <xsl:attribute name="value">
          <xsl:value-of select="$pathMultimedia"/>
        </xsl:attribute>
      </param>
      <embed>
        <xsl:call-template name="Label"/>
          <xsl:attribute name="src">
            <xsl:value-of select="$pathMultimedia"/>
          </xsl:attribute>
        <xsl:call-template name="MultimediaAttributes"/>
       </embed>
     </object>
  </xsl:template>

  <xsl:template name="SVG">
    <xsl:param name="pathMultimedia"/>
    <object>
      <xsl:call-template name="Label"/>
      <xsl:call-template name="MultimediaAttributes"/>
      <param name="src">
        <xsl:attribute name="value">
          <xsl:value-of select="$pathMultimedia"/>
        </xsl:attribute>
      </param>
      <embed type="image/svg+xml" pluginspage="http://www.adobe.com/svg/viewer/install/">
        <xsl:call-template name="Label"/>
        <xsl:attribute name="src">
          <xsl:value-of select="$pathMultimedia"/>
        </xsl:attribute>
        <xsl:call-template name="MultimediaAttributes"/>
      </embed>
    </object>
  </xsl:template>

  <xsl:template name="X3D">
    <xsl:param name="pathMultimedia"/>
    <object classid="clsid:918B202D-8E8F-4649-A70B-E9B178FEDC58">
      <xsl:call-template name="Label"/>
      <xsl:call-template name="MultimediaAttributes"/>
      <param name="src">
        <xsl:attribute name="value">
          <xsl:value-of select="$pathMultimedia"/>
        </xsl:attribute>
      </param>
      <embed type="model/x3d+xml" pluginspage="http://www.web3d.org/applications/tools/viewers_and_browsers/">
        <xsl:call-template name="Label"/>
        <xsl:attribute name="src">
          <xsl:value-of select="$pathMultimedia"/>
        </xsl:attribute>
         <xsl:call-template name="MultimediaAttributes"/>
       </embed>
     </object>
   </xsl:template>
  
  <xsl:template name="Applet">
    <xsl:param name="pathMultimedia"/>
    <applet>
      <xsl:call-template name="Label"/>
      <xsl:attribute name="code">
        <xsl:value-of select="$pathMultimedia"/>
      </xsl:attribute>
      <xsl:call-template name="MultimediaAttributes"/>
      <xsl:attribute name="alt">
        <xsl:value-of select="@legend"/>
      </xsl:attribute>
    </applet>
  </xsl:template>
 
  
  <xsl:template name="Alignment">
    <xsl:param name="istd"/>
      <xsl:choose>
        <xsl:when test="($istd='yes') or (name()='elml:tableheading') or (name()='elml:tabledata') or (name()='elml:columnLeft') or (name()='elml:columnRight') or (name()='elml:columnMiddle')">
          <xsl:choose>
            <xsl:when test="(@align='top') or (@align='texttop')">
              <xsl:attribute name="align">left</xsl:attribute>
              <xsl:attribute name="valign">top</xsl:attribute>
            </xsl:when>
            <xsl:when test="(@align='middle') or (@align='absmiddle')">
              <xsl:attribute name="align">left</xsl:attribute>
              <xsl:attribute name="valign">middle</xsl:attribute>
            </xsl:when>
            <xsl:when test="@align='center'">
              <xsl:attribute name="align">center</xsl:attribute>
              <xsl:attribute name="valign">top</xsl:attribute>
              <xsl:attribute name="style">text-align: center</xsl:attribute>
            </xsl:when>
            <xsl:when test="(@align='bottom') or (@align='absbottom')">
              <xsl:attribute name="align">left</xsl:attribute>
              <xsl:attribute name="valign">bottom</xsl:attribute>
            </xsl:when>
            <xsl:when test="(@align='justify')">
              <xsl:attribute name="align">justify</xsl:attribute>
              <xsl:attribute name="valign">top</xsl:attribute>
              <xsl:attribute name="style">text-align: justify</xsl:attribute>
            </xsl:when>
            <xsl:when test="(@align='right')">
              <xsl:attribute name="align">right</xsl:attribute>
              <xsl:attribute name="valign">top</xsl:attribute>
              <xsl:attribute name="style">text-align: right</xsl:attribute>
            </xsl:when>
          <xsl:otherwise>
          <xsl:attribute name="align">left</xsl:attribute>
          <xsl:attribute name="valign">top</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when> 
    <xsl:when test="@align='center' and name(.)='elml:multimedia'">
      <xsl:attribute name="align">middle</xsl:attribute>
    </xsl:when>
    <xsl:when test="@align">
      <xsl:attribute name="align">
        <xsl:value-of select="@align"/>
      </xsl:attribute>
     </xsl:when>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="assetUpload">
    <xsl:param name="insertWhat"/>
    <xsl:param name="insertWhere"/>
    <xsl:param name="insertReplace"/>

    <xsl:variable name="trimmedElementPath">
      <xsl:for-each select="(ancestor-or-self::*)">
        <xsl:call-template name="compute-path"/>
      </xsl:for-each>
    </xsl:variable>

    <xsl:call-template name="asset-dot">
      <xsl:with-param name="type">
        <xsl:value-of select="$insertWhat"/>
      </xsl:with-param>
      <xsl:with-param name="href">
        <xsl:choose>
          <xsl:when test="$insertWhat = 'asset'">
            ?lenya.usecase=asset&amp;lenya.step=showscreen&amp;insert=true&amp;insertimage=false&amp;assetXPath=<xsl:value-of select="$trimmedElementPath"/>&amp;insertWhere=<xsl:value-of select="$insertWhere"/>&amp;insertTemplate=insertAsset.xml&amp;insertReplace=<xsl:value-of select="$insertReplace"/>
          </xsl:when>
          <xsl:otherwise>
            ?lenya.usecase=asset&amp;lenya.step=showscreen&amp;insert=true&amp;insertimage=false&amp;assetXPath=<xsl:value-of select="$trimmedElementPath"/>&amp;insertWhere=<xsl:value-of select="$insertWhere"/>&amp;insertTemplate=insertMultimedia.xml&amp;insertReplace=<xsl:value-of select="$insertReplace"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="asset-dot">
    <xsl:param name="href"/>
    <xsl:param name="type"/>
    <xsl:choose>
      <xsl:when test="$type = 'image'">
        <a href="{$href}">
          <img alt="Insert Identity" border="0" src="{$contextprefix}/lenya/images/util/uploadimage.gif"/>
        </a>&#160;
      </xsl:when>
      <xsl:otherwise>
        <a href="{$href}">
          <img alt="Insert Identity" border="0" src="{$contextprefix}/lenya/images/util/uploadasset.gif"/>
        </a>&#160;
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="elml:paragraph[$rendertype = 'imageupload']">
     <p>
        <xsl:apply-templates select="@*|node()"/>
     </p>
     <p>
     <xsl:call-template name="assetUpload">
       <xsl:with-param name="insertWhat">image</xsl:with-param>
       <xsl:with-param name="insertWhere">after</xsl:with-param>
     </xsl:call-template>
     <xsl:call-template name="assetUpload">
       <xsl:with-param name="insertWhat">asset</xsl:with-param>
       <xsl:with-param name="insertWhere">after</xsl:with-param>
     </xsl:call-template>
     </p>
  </xsl:template>
     

  <xsl:template name="compute-path">
    <xsl:if test="not(self::document | self::content)"> <!-- FIXME: metadata, header -->
      <xsl:text>/</xsl:text>
      <xsl:text>*</xsl:text>
      <xsl:if test="name() != 'html' and name() != 'xhtml:html'">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="1+count(preceding-sibling::*[not(self::unizh:header)])"/>
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:template>


  <!-- bibliography -->

  <xsl:template match="elml:bibliography">
    <div>
      <xsl:for-each select="*[not(self::lenya:meta) and not(self::unizh:header)]">
        <a name="{position()}"><xsl:comment/></a>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template name="BibliographyRef">

    <xsl:param name="name_anon">Unknown</xsl:param>   

    <xsl:if test="@bibIDRef">
      <xsl:variable name="id" select="@bibIDRef"/>
      <xsl:variable name="bibNode" select="/document/unizh:level/level:node/*/elml:bibliography/*[@bibID=$id]"/>
      <xsl:variable name="position">
        <xsl:for-each select="$bibNode/../*">
            <xsl:if test="@bibID = $id">
              <xsl:value-of select="position() - 1"/>
            </xsl:if>
          </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="author">
        <xsl:choose>
          <xsl:when test="$bibNode/@author">
            <xsl:value-of select="$bibNode/@author"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$name_anon"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:text> </xsl:text>
      <xsl:if test="not(@yearOnly='yes')">
        <xsl:text>(</xsl:text>
      </xsl:if>


      <!-- FIXME: add link when pagebreak set to unit  -->
      <a target="_top" class="bibLink">
        <xsl:attribute name="href">
          <xsl:value-of select="concat($contextprefix, /document/unizh:level/level:node[*/elml:bibliography]/@href, '#', $position)"/>
        </xsl:attribute>
        <xsl:choose>
          <xsl:when test="contains($author, ',')">
            <xsl:value-of select="substring-before($author, ',')"/>
            <xsl:if test="contains(substring-after($author, ','), ',')">
              <xsl:text> et al.</xsl:text>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$author"/>
          </xsl:otherwise>
        </xsl:choose>
      </a>
      <xsl:if test="$bibNode/@publicationYear or @pageNr">
        <xsl:text> </xsl:text>
        <xsl:if test="@yearOnly='yes'">
          <xsl:text>(</xsl:text>
        </xsl:if>
        <xsl:value-of select="$bibNode/@publicationYear"/>
        <xsl:if test="@pageNr">
          <xsl:text>, p. </xsl:text>
          <xsl:value-of select="@pageNr"/>
        </xsl:if>
      </xsl:if>
      <xsl:if test="$bibNode/@publicationYear or @pageNr or not(@yearOnly='yes')">
        <xsl:text>)</xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
