<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:elml="http://www.elml.ch"  
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:fo="http://www.w3.org/1999/XSL/Format" 
  xmlns:fox="http://xml.apache.org/fop/extensions"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  >

  <xsl:import href="biblio_harvard.xsl"/>
  <xsl:import href="metadata_elml.xsl"/> 

  <xsl:param name="role"/>
  <xsl:param name="author"/>
  <xsl:param name="publisher"/>
  <xsl:param name="online-url"/>
  <xsl:param name="date"/>
  <xsl:param name="lang"/>

  <xsl:param name="page-height">297mm</xsl:param>
  <xsl:param name="page-width">210mm</xsl:param>
  <xsl:param name="body-alignment">justify</xsl:param>

  <xsl:param name="pagebreak_level">unit</xsl:param>
  <xsl:param name="chapter_numbers"/>


  <xsl:param name="body-font-family">Baskerville</xsl:param>
  <xsl:param name="fontsize">11pt</xsl:param>
  <xsl:param name="lineheight">13pt</xsl:param>
  <xsl:param name="fontsize_title">16pt</xsl:param>
  <xsl:param name="fontweight_title">bold</xsl:param>
  <xsl:param name="lineheight_title">28pt</xsl:param>
  <xsl:param name="block-space-after">10pt</xsl:param>
  <xsl:param name="legendratio">0.8</xsl:param>
  <xsl:param name="converter_pixel_mm">0.3</xsl:param>

  <!-- Labels -->

  <xsl:param name="label_metaSetUpInfo"/>
  <xsl:param name="label_anon">Anonymous</xsl:param>
  <xsl:param name="label_notanimage">Keine Druckfassung für Bild oder Animation verfügbar.</xsl:param>
  <xsl:param name="label_download"/>


  <xsl:param name="optional_units"/>
  <xsl:param name="name_optionalunits_text">Keine Pflichtlektuere</xsl:param>



  <xsl:template match="elml:lesson">
  <fo:root font-family="{$body-font-family}">
    <fo:layout-master-set>
      <fo:simple-page-master master-name="default-page" page-height="{$page-height}" page-width="{$page-width}" margin-top="10mm" margin-bottom="10mm" margin-left="10mm" margin-right="10mm">
        <fo:region-body margin-top="20mm" margin-bottom="20mm"/>
        <fo:region-before extent="20mm"/>
        <fo:region-after extent="15mm"/>
      </fo:simple-page-master>
    </fo:layout-master-set>

    <fo:page-sequence master-reference="default-page" initial-page-number="auto">
      <fo:static-content flow-name="xsl-region-before">
         <fo:table table-layout="fixed" width="100%">
          <fo:table-column/>
          <fo:table-column/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell font-size="inherited-property-value(&apos;font-size&apos;) - 2pt" padding="0pt">
                <fo:block>
                  <fo:inline>
                    <xsl:value-of select="$publisher"/>
                  </fo:inline>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell font-size="inherited-property-value(&apos;font-size&apos;) - 2pt" padding="0pt" text-align="right">
                <fo:block>
                  <xsl:value-of select="@title"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
        <fo:block color="black" space-before.optimum="-8pt">
          <fo:leader leader-length="100%" leader-pattern="rule" rule-thickness="1pt"/>
        </fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-footnote-separator">
        <fo:block>
          <fo:leader leader-pattern="rule" leader-length="30%" rule-thickness="0.5pt" rule-style="solid" color="black" display-align="before"/>
        </fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after" display-align="after">
        <fo:table table-layout="fixed" width="100%">
          <fo:table-column/>
          <fo:table-column column-width="50pt"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell padding="0pt" number-columns-spanned="2" display-align="center">
                <fo:block color="black" space-before.optimum="-8pt">
                  <fo:leader leader-length="100%" leader-pattern="rule" rule-thickness="0.5pt"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row>
              <fo:table-cell font-size="inherited-property-value(&apos;font-size&apos;) - 2pt" padding="0pt" border-style="solid" border-width="1pt" border-color="white" display-align="center">
                <fo:block>
                  <fo:inline>
                    <xsl:value-of select="$date"/>
                    <xsl:if test="$online-url">
                      <xsl:text> - </xsl:text>
                      Online: <xsl:value-of select="$online-url"/>
                    </xsl:if>
                  </fo:inline>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell font-size="inherited-property-value(&apos;font-size&apos;) - 2pt" padding="0pt" text-align="right" width="150pt">
                <fo:block>
                  <fo:page-number/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </fo:static-content>

      <fo:flow flow-name="xsl-region-body" text-align="{$body-alignment}" font-size="{$fontsize}" line-height="{$lineheight}">
        <xsl:call-template name="coverpage"/>
        <fo:block id="content" break-before="page"/>
        <!-- FIXME: add elml:toc -->
        <xsl:call-template name="generate_Title"/>
        <xsl:apply-templates select="elml:*"/>
      </fo:flow>
    </fo:page-sequence>
  </fo:root>
</xsl:template>


<xsl:template name="authors">
  <xsl:param name="str"/>
  <fo:block>
    <xsl:choose>
      <xsl:when test="contains($str, ',')">
        <xsl:value-of select="substring-before($str, ',')"/>
        <xsl:call-template name="authors">
          <xsl:with-param name="str" select="substring-after($str, ',')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$str"/>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

<xsl:template name="coverpage">

  <fo:table table-layout="fixed" start-indent="({$page-width} - (({$page-width} * 80) div 100) ) div 2" end-indent="({$page-width} - (({$page-width} * 80) div 100) ) div 2" text-align="center" width="100%">
    <fo:table-column column-width="proportional-column-width(1)"/>
    <fo:table-body>
      <fo:table-row>
        <fo:table-cell height="50pt"/>
      </fo:table-row>
      <fo:table-row>
        <fo:table-cell border-style="solid" border-width="1pt" border-color="white" padding="3pt" display-align="center">
          <fo:block>
            <fo:block padding="3pt">
              <fo:block>
                <fo:block text-align="center">
                   <fo:block>
                     <fo:block font-size="{$fontsize}*2.5" font-weight="{$fontweight_title}" line-height="{$lineheight}*3">
                         <xsl:value-of select="/elml:lesson/@title"/>
                     </fo:block>
                     <fo:block font-size="{$fontsize}*1.5" font-weight="normal" line-height="{$lineheight}*2.5">
                       <fo:block>
                         <xsl:call-template name="authors">
                           <xsl:with-param name="str" select="$author"/>
                         </xsl:call-template>
                         <xsl:for-each select="/elml:lesson/elml:metadata/elml:lessonInfo/elml:lifecycle/elml:contribute/elml:person/@name">
                           <fo:block>
                             <fo:leader leader-pattern="space"/>
                             <!-- <xsl:value-of select="."/> -->
                           </fo:block>
                         </xsl:for-each>
                       </fo:block>
                     </fo:block>
                   </fo:block>
                 </fo:block>
               </fo:block>
             </fo:block>
           </fo:block>
         </fo:table-cell>
       </fo:table-row>
     </fo:table-body>
   </fo:table>
</xsl:template>


<xsl:template name="generate_Title">
  <xsl:param name="factor">
    <xsl:choose>
      <xsl:when test="local-name()='lesson'">
        <xsl:text>1.4</xsl:text>
      </xsl:when>
      <xsl:when test="local-name()='unit' or local-name()='glossary' or local-name()='index' or local-name()='bibliography' or local-name()='metadata' ">
        <xsl:text>1.2</xsl:text>
      </xsl:when>
      <xsl:when test="local-name()='learningObject'">
        <xsl:text>1.0</xsl:text>
      </xsl:when>
      <xsl:when test="local-name()='clarify' or local-name()='look' or local-name()='act'">
        <xsl:text>1.0</xsl:text>
      </xsl:when>
      <xsl:when test="local-name()='entry' or local-name()='goals' or local-name()='summary' or local-name()='selfAssessment' or local-name()='furtherReading'">
        <xsl:choose>
          <xsl:when test="local-name(parent::*)='lesson'">
            <xsl:text>1.0</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>1.0</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:param>
  <fo:block font-size="{$fontsize}*{$factor}" line-height="{$lineheight}*{$factor}" space-after.optimum="{$lineheight}*0.5" font-weight="{$fontweight_title}" keep-with-next.within-page="always" text-align="left">
    <xsl:choose>
      <xsl:when test="$pagebreak_level='lo' and (local-name()='learningObject' or local-name()='unit')">
        <xsl:attribute name="break-before">
          <xsl:text>page</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$pagebreak_level='unit' and local-name()='unit'">
        <xsl:attribute name="break-before">
          <xsl:text>page</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$pagebreak_level='lesson' and local-name() = 'lesson'">
        <xsl:attribute name="break-before">
          <xsl:text>page</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="local-name() = 'glossary'">
        <xsl:attribute name="break-before">
          <xsl:text>page</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="local-name() = 'bibliography'">
        <xsl:attribute name="break-before">
          <xsl:text>page</xsl:text>
        </xsl:attribute>
      </xsl:when>
       <xsl:when test="local-name() = 'furtherReading' and parent::*[local-name() = 'lesson']">
        <xsl:attribute name="break-before">
          <xsl:text>page</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="space-before.optimum">
          <xsl:value-of select="$lineheight"/>
          <xsl:text>*(</xsl:text>
          <xsl:value-of select="$factor"/>
          <xsl:text>-0.5)</xsl:text>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$chapter_numbers = 'yes'">
      <xsl:call-template name="chapter_numbers"/><xsl:text> </xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@title">
        <xsl:value-of select="@title"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="lenya:meta/dc:title"/>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>


<xsl:template name="chapter_numbers">
  <xsl:if test="local-name() = 'unit' or local-name() = 'learningObject'">
    <xsl:number level="multiple" from="elml:lesson" format="1.2.3" count="*[local-name()='unit' or local-name() = 'learningObject']"/>
  </xsl:if>
</xsl:template>



<xsl:template match="elml:unit">
  <xsl:param name="display"> 
    <xsl:call-template name="display"/>
  </xsl:param> 
  <xsl:if test="$display='yes'">
    <xsl:call-template name="generate_Title"/>
    <xsl:if test="local-name(.)='unit' and contains($optional_units, @label)">
      <fo:block border-style="solid" border-width="0.5pt" background-color="lightgrey" padding="3pt" margin="0pt">
         <xsl:value-of select="$name_optionalunits_text"/> 
      </fo:block>
    </xsl:if>
    <xsl:apply-templates select="elml:*"/>
  </xsl:if> 
</xsl:template>

<xsl:template match="elml:learningObject">
  <xsl:call-template name="generate_Title"/>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="elml:clarify | elml:look | elml:act">
  <xsl:if test="@title">
    <xsl:call-template name="generate_Title"/>
  </xsl:if>
  <xsl:if test="@metaSetUpInfo and not(@metaSetUpInfo ='none') and not(@metaSetUpInfo='nothing') and ($role='tutor')">
    <fo:block border-style="solid" border-color="red" border-width="0.5pt" background-color="lightgrey" padding="3pt" margin="5pt">
      <fo:inline color="red" font-weight="bold">
        <xsl:value-of select="$label_metaSetUpInfo"/>
      </fo:inline>
      <xsl:value-of select="@metaSetUpInfo"/>
    </fo:block>
  </xsl:if>
  <xsl:apply-templates select="elml:*"/>
</xsl:template>


<xsl:template match="elml:entry">
  <xsl:if test="@title">
    <xsl:call-template name="generate_Title"/>
  </xsl:if>
  <xsl:apply-templates select="elml:*"/>
</xsl:template>


<xsl:template match="elml:goals">
  <fo:list-block provisional-distance-between-starts="7mm" provisional-label-separation="2mm" start-indent="2mm" space-before.optimum="4pt" space-after.optimum="4pt">
    <xsl:for-each select="elml:lObjective">
      <xsl:if test="(@role='student') or (@role=$role) or (not (@role))">
        <fo:list-item>
          <fo:list-item-label end-indent="label-end()">
            <fo:block font-family="Courier" font-size="{$fontsize}*1.5" line-height="{$lineheight}" padding-before="2pt">&#x2022;</fo:block>
          </fo:list-item-label>
          <fo:list-item-body start-indent="body-start()">
            <fo:block>
              <xsl:value-of select="."/>
            </fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </xsl:if>
    </xsl:for-each>
  </fo:list-block>
</xsl:template>


<xsl:template match="elml:selfAssessment">
  <xsl:call-template name="generate_Title"/>
  <xsl:if test="(@metaSetUpInfo) and (not(@metaSetUpInfo ='none')) and (not(@metaSetUpInfo='nothing')) and ($role='tutor')">
    <fo:block border-style="solid" border-color="red" border-width="0.5pt" background-color="lightgrey" padding="3pt" margin="5pt">
      <fo:inline color="red" font-weight="bold">
        <xsl:value-of select="$label_metaSetUpInfo"/>
      </fo:inline>
      <xsl:value-of select="@metaSetUpInfo"/>
    </fo:block>
  </xsl:if>
  <xsl:apply-templates select="elml:*"/>
</xsl:template>


<xsl:template match="elml:summary">
  <xsl:call-template name="generate_Title"/>
  <xsl:apply-templates select="elml:*"/>
</xsl:template>

<xsl:template match="elml:glossary">
  <xsl:param name="display">
    <xsl:call-template name="display"/> 
  </xsl:param>
  <xsl:if test="$display='yes'">
    <xsl:call-template name="generate_Title"/>
    <xsl:apply-templates select="elml:*">
      <xsl:sort select="@term" order="ascending" lang="{$lang}"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>


<xsl:template match="elml:definition">
  <xsl:param name="term"/>
  <fo:block font-style="italic">
    <xsl:if test="not($term)">
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$term">
        <xsl:value-of select="$term"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@term"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>: </xsl:text>
  </fo:block>
  <fo:block start-indent="15pt">
    <xsl:apply-templates/>
    <xsl:call-template name="BibliographyRef"/>
  </fo:block>
</xsl:template>

<xsl:template match="elml:definition" mode="icon">
  <xsl:param name="term"/>
  <fo:block font-style="italic">
    <xsl:if test="not($term)">
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$term">
        <xsl:value-of select="$term"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@term"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>: </xsl:text>
  </fo:block>
  <fo:block start-indent="15pt">
    <xsl:apply-templates/>
    <xsl:call-template name="BibliographyRef"/>
  </fo:block>
</xsl:template>



<xsl:template name="BibliographyRef">
<!--A template used to generate bibliography references within the lesson, eg. (Negri 2004)-->
  <xsl:if test="@bibIDRef">
    <fo:inline font-variant="small-caps">
      <xsl:variable name="id" select="@bibIDRef"/>
      <xsl:variable name="author">
        <xsl:choose>
          <xsl:when test="/elml:lesson/elml:bibliography/*[@bibID=$id]/@author">
            <xsl:value-of select="/elml:lesson/elml:bibliography/*[@bibID=$id]/@author"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$label_anon"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:text> </xsl:text>
      <xsl:if test="not(@yearOnly='yes')">
        <xsl:text>(</xsl:text>
      </xsl:if>
      <fo:basic-link>
        <xsl:attribute name="internal-destination">
          <xsl:value-of select="concat('id', generate-id(/elml:lesson/elml:bibliography/*[@bibID=$id]))"/>
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
      </fo:basic-link> 
      <xsl:if test="/elml:lesson/elml:bibliography/*[@bibID=$id]/@publicationYear or @pageNr">
        <xsl:text> </xsl:text>
        <xsl:if test="@yearOnly='yes'">
          <xsl:text>(</xsl:text>
        </xsl:if>
        <xsl:value-of select="/elml:lesson/elml:bibliography/*[@bibID=$id]/@publicationYear"/>
          <xsl:if test="@pageNr">
            <xsl:text>, p. </xsl:text>
            <xsl:value-of select="@pageNr"/>
          </xsl:if>
        </xsl:if>
        <xsl:if test="/elml:lesson/elml:bibliography/*[@bibID=$id]/@publicationYear or @pageNr or not(@yearOnly='yes')">
          <xsl:text>)</xsl:text>
        </xsl:if>
     </fo:inline>
   </xsl:if>
</xsl:template>


<xsl:template match="elml:furtherReading">
  <xsl:param name="display">
    <xsl:call-template name="display"/> 
  </xsl:param>
  <xsl:if test="$display='yes'">
    <xsl:call-template name="generate_Title"/>
    <xsl:choose>
      <xsl:when test="@sorting='off'">
        <fo:list-block provisional-distance-between-starts="7mm" provisional-label-separation="2mm" start-indent="2mm" space-before.optimum="4pt" space-after.optimum="4pt">
          <xsl:for-each select="elml:resItem">
            <xsl:apply-templates select="/elml:lesson/elml:bibliography/*[@bibID=current()/@bibIDRef]">
              <xsl:with-param name="comment" select="text()"/>
              <xsl:with-param name="furtherReading" select="@bibIDRef"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </fo:list-block>
      </xsl:when>
      <xsl:when test="@sorting='byYear'">
        <fo:list-block provisional-distance-between-starts="7mm" provisional-label-separation="2mm" start-indent="2mm" space-before.optimum="4pt" space-after.optimum="4pt">
          <xsl:for-each select="elml:resItem">
            <xsl:sort select="/elml:lesson/elml:bibliography/*[@bibID=current()/@bibIDRef]/@publicationYear" order="descending" lang="{$lang}"/>
            <xsl:apply-templates select="/elml:lesson/elml:bibliography/*[@bibID=current()/@bibIDRef]">
              <xsl:with-param name="comment" select="text()"/>
              <xsl:with-param name="furtherReading" select="@bibIDRef"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </fo:list-block>
      </xsl:when>
      <xsl:otherwise>
        <fo:list-block provisional-distance-between-starts="7mm" provisional-label-separation="2mm" start-indent="2mm" space-before.optimum="4pt" space-after.optimum="4pt">
          <xsl:for-each select="elml:resItem">
            <xsl:sort select="/elml:lesson/elml:bibliography/*[@bibID=current()/@bibIDRef]/@author" order="ascending" lang="{$lang}"/>
            <xsl:apply-templates select="/elml:lesson/elml:bibliography/*[@bibID=current()/@bibIDRef]">
              <xsl:with-param name="comment" select="text()"/>
              <xsl:with-param name="furtherReading" select="@bibIDRef"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </fo:list-block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>


<xsl:template match="elml:bibliography">
  <xsl:param name="display">
    <xsl:call-template name="display"/> 
  </xsl:param>
  <xsl:if test="$display='yes'">
    <xsl:call-template name="generate_Title"/>
    <xsl:choose>
      <xsl:when test="@sorting='off'">
        <fo:list-block provisional-distance-between-starts="7mm" provisional-label-separation="2mm" start-indent="2mm" space-before.optimum="4pt" space-after.optimum="4pt">
          <xsl:apply-templates select="elml:*"/>
        </fo:list-block>
      </xsl:when>
      <xsl:when test="@sorting='byYear'">
        <fo:list-block provisional-distance-between-starts="7mm" provisional-label-separation="2mm" start-indent="2mm" space-before.optimum="4pt" space-after.optimum="4pt">
          <xsl:apply-templates select="elml:*">
            <xsl:sort select="@publicationYear" order="descending" lang="{$lang}"/>
          </xsl:apply-templates>
        </fo:list-block>
      </xsl:when>
      <xsl:otherwise>
        <fo:list-block provisional-distance-between-starts="7mm" provisional-label-separation="2mm" start-indent="2mm" space-before.optimum="4pt" space-after.optimum="4pt">
          <xsl:apply-templates>
            <xsl:sort select="@author" order="ascending" lang="{$lang}"/>
          </xsl:apply-templates>
        </fo:list-block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>


<xsl:template match="elml:column">
  <fo:table table-layout="fixed" width="100%" border-style="solid" border-width="1pt" border-color="white">
  <!-- <xsl:call-template name="Label"/> -->
    <fo:table-column>
      <xsl:choose>
        <xsl:when test="elml:columnLeft/@width">
          <xsl:attribute name="column-width">
            <xsl:choose>
              <xsl:when test="elml:columnLeft/@units='percent'">
                <xsl:text>proportional-column-width(</xsl:text>
                <xsl:value-of select="elml:columnLeft/@width"/>
                <xsl:text>)</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="(elml:columnLeft/@width) * $converter_pixel_mm"/>
                <xsl:text>mm</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="column-width">
            <xsl:text>proportional-column-width(1)</xsl:text>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </fo:table-column>
    <xsl:if test="elml:columnMiddle">
      <fo:table-column>
        <xsl:choose>
          <xsl:when test="elml:columnMiddle/@width">
            <xsl:attribute name="column-width">
              <xsl:choose>
                <xsl:when test="elml:columnMiddle/@units='percent'">
                  <xsl:text>proportional-column-width(</xsl:text>
                  <xsl:value-of select="elml:columnMiddle/@width"/>
                  <xsl:text>)</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="(elml:columnMiddle/@width) * $converter_pixel_mm"/>
                  <xsl:text>mm</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="column-width">
              <xsl:text>proportional-column-width(1)</xsl:text>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </fo:table-column>
    </xsl:if>
    <fo:table-column>
      <xsl:choose>
        <xsl:when test="elml:columnRight/@width">
          <xsl:attribute name="column-width">
            <xsl:choose>
              <xsl:when test="elml:columnRight/@units='percent'">
                <xsl:text>proportional-column-width(</xsl:text>
                <xsl:value-of select="elml:columnRight/@width"/>
                <xsl:text>)</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="(elml:columnRight/@width) * $converter_pixel_mm"/>
                <xsl:text>mm</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="column-width">
            <xsl:text>proportional-column-width(1)</xsl:text>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </fo:table-column>
    <fo:table-body>
      <fo:table-row>
        <xsl:choose>
          <xsl:when test="elml:columnLeft/@height">
            <xsl:attribute name="height">
              <xsl:choose>
                <xsl:when test="elml:columnLeft/@units='percent'">
                  <xsl:value-of select="elml:columnLeft/@height"/>
                  <xsl:text>%</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="(elml:columnLeft/@height) * $converter_pixel_mm"/>
                  <xsl:text>mm</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="elml:columnMiddle/@height">
            <xsl:attribute name="height">
              <xsl:choose>
                <xsl:when test="elml:columnMiddle/@units='percent'">
                  <xsl:value-of select="elml:columnMiddle/@height"/>
                  <xsl:text>%</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="(elml:columnMiddle/@height) * $converter_pixel_mm"/>
                  <xsl:text>mm</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="elml:columnRight/@height">
            <xsl:attribute name="height">
              <xsl:choose>
                <xsl:when test="elml:columnRight/@units='percent'">
                  <xsl:value-of select="elml:columnRight/@height"/>
                  <xsl:text>%</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="(elml:columnRight/@height) * $converter_pixel_mm"/>
                  <xsl:text>mm</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates/>
      </fo:table-row>
    </fo:table-body>
  </fo:table>
</xsl:template>


<xsl:template match="elml:columnLeft | elml:columnMiddle | elml:columnRight">
  <fo:table-cell padding="3pt">
    <xsl:call-template name="WidthHeight"/>
    <xsl:call-template name="Alignment"/>
    <fo:block>
      <xsl:call-template name="Alignment"/>
      <xsl:apply-templates/>
    </fo:block>
  </fo:table-cell>
</xsl:template>


<xsl:template name="elml:columncreate">
  <xsl:param name="columnamount"/>
  <fo:table-column>
    <xsl:choose>
      <xsl:when test="@width">
        <xsl:attribute name="column-width">
          <xsl:choose>
            <xsl:when test="@units='percent'">
              <xsl:text>proportional-column-width(</xsl:text>
              <xsl:value-of select="@width"/>
              <xsl:text>)</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="(@width) * $converter_pixel_mm"/>
              <xsl:text>mm</xsl:text>
             </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="column-width">
          <xsl:text>proportional-column-width(1)</xsl:text>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </fo:table-column>
  <xsl:if test="not($columnamount=1)">
    <xsl:call-template name="elml:columncreate">
      <xsl:with-param name="columnamount" select="$columnamount - 1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="elml:icons">
  <fo:table table-layout="fixed" width="100%" border-style="solid" border-width="0.5pt" border-color="white">
    <fo:table-column column-width="40px"/>
    <fo:table-column/>
    <fo:table-body>
      <fo:table-row>
        <fo:table-cell padding="3pt" display-align="before" width="30px">
          <fo:block>
            <fo:external-graphic scaling="uniform" content-height="30px" content-width="30px" height="30px" width="30px">
               <xsl:attribute name="src"><!-- FIXME: Icons -->
                 <xsl:text>/_templates/</xsl:text>
                 <xsl:text>/icons/</xsl:text>
                 <xsl:value-of select="@icon"/>
                 <xsl:text>.gif</xsl:text>
               </xsl:attribute>
             </fo:external-graphic>
           </fo:block>
         </fo:table-cell>
        <fo:table-cell padding="3pt" display-align="before">
          <xsl:apply-templates select="." mode="icon"/>
        </fo:table-cell>
      </fo:table-row>
    </fo:table-body>
  </fo:table>
</xsl:template>


<xsl:template match="elml:table | elml:list | elml:popup | elml:box | elml:paragraph | elml:multimedia">
  <xsl:param name="display">
    <xsl:call-template name="display"/> 
  </xsl:param>
  <xsl:if test="$display='yes'">
    <xsl:call-template name="Title"/>
    <fo:block space-after="{$block-space-after}">
      <xsl:choose>
        <xsl:when test="@icon">
          <xsl:call-template name="elml:icons"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="." mode="icon"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:if>
</xsl:template>


<xsl:template match="elml:table" mode="icon">
  <fo:table table-layout="fixed">
    <xsl:call-template name="Label"/> 
    <xsl:if test="@height">
      <xsl:attribute name="height">
        <xsl:choose>
          <xsl:when test="@units='percent'">
            <xsl:value-of select="@height"/>
            <xsl:text>%</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="(@height) * $converter_pixel_mm"/>
            <xsl:text>mm</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@width">
        <xsl:attribute name="width">
          <xsl:choose>
            <xsl:when test="@units='percent'">
              <xsl:value-of select="@width"/>
              <xsl:text>%</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="(@width) * $converter_pixel_mm"/>
              <xsl:text>mm</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="width">
          <xsl:text>100%</xsl:text>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="elml:tablerow[1]/elml:tableheading">
        <xsl:for-each select="elml:tablerow[1]/elml:tableheading">
          <xsl:choose>
            <xsl:when test="@colspan">
              <xsl:call-template name="elml:columncreate">
                <xsl:with-param name="columnamount" select="@colspan"/>
              </xsl:call-template>
            </xsl:when>
              <xsl:otherwise>
              <xsl:call-template name="elml:columncreate">
                <xsl:with-param name="columnamount" select="1"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="elml:tablerow[1]/elml:tabledata">
          <xsl:choose>
            <xsl:when test="@colspan">
              <xsl:call-template name="elml:columncreate">
                <xsl:with-param name="columnamount" select="@colspan"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="elml:columncreate">
                <xsl:with-param name="columnamount" select="1"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
    <fo:table-body>
      <xsl:apply-templates/>
    </fo:table-body>
  </fo:table>
  <xsl:call-template name="Legend"/>
</xsl:template>


<xsl:template match="elml:tablerow">
  <fo:table-row>
    <xsl:choose>
      <xsl:when test="elml:tableheading[1]/@height">
        <xsl:attribute name="height">
          <xsl:choose>
            <xsl:when test="elml:tableheading[1]/@units='percent'">
              <xsl:value-of select="elml:tableheading[1]/@height"/>
              <xsl:text>%</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="(elml:tableheading[1]/@height) * $converter_pixel_mm"/>
              <xsl:text>mm</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="elml:tabledata[1]/@height">
        <xsl:attribute name="height">
          <xsl:choose>
            <xsl:when test="elml:tabledata[1]/@units='percent'">
              <xsl:value-of select="elml:tabledata[1]/@height"/>
              <xsl:text>%</xsl:text>
            </xsl:when>
           <xsl:otherwise>
             <xsl:value-of select="(elml:tabledata[1]/@height) * $converter_pixel_mm"/>
             <xsl:text>mm</xsl:text>
           </xsl:otherwise>
         </xsl:choose>
       </xsl:attribute>
     </xsl:when>
    </xsl:choose>
    <xsl:apply-templates/>
  </fo:table-row>
</xsl:template>


<xsl:template match="elml:tableheading">
  <fo:table-cell border-style="solid" border-width="0.5pt" border-color="black" font-weight="bold" padding="3pt">
    <xsl:if test="@colspan">
      <xsl:attribute name="number-columns-spanned">
        <xsl:value-of select="@colspan"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@rowspan">
      <xsl:attribute name="number-rows-spanned">
        <xsl:value-of select="@rowspan"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:call-template name="WidthHeight"/>
    <xsl:call-template name="Alignment"/>
    <fo:block>
     <xsl:call-template name="Alignment"/>
      <xsl:apply-templates/>
    </fo:block>
  </fo:table-cell>
</xsl:template>


<xsl:template match="elml:tabledata">
  <fo:table-cell border-style="solid" border-width="0.5pt" border-color="black" padding="3pt">
    <xsl:if test="@colspan">
      <xsl:attribute name="number-columns-spanned">
        <xsl:value-of select="@colspan"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@rowspan">
      <xsl:attribute name="number-rows-spanned">
        <xsl:value-of select="@rowspan"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:call-template name="WidthHeight"/>
    <xsl:call-template name="Alignment"/>
    <fo:block>
      <xsl:call-template name="Alignment"/>
        <xsl:apply-templates/>
     </fo:block>
   </fo:table-cell>
</xsl:template>


<xsl:template match="elml:list" mode="icon">
  <fo:list-block start-indent="inherited-property-value(&apos;start-indent&apos;) + 2mm" provisional-distance-between-starts="7mm" provisional-label-separation="2mm" display-align="before">
    <xsl:call-template name="Label"/> 
    <xsl:apply-templates/>
  </fo:list-block>
  <xsl:call-template name="Legend"/>
</xsl:template>


<xsl:template match="elml:item">
  <fo:list-item>
    <fo:list-item-label end-indent="label-end()">
      <xsl:choose>
        <xsl:when test="../@listStyle='ordered'">
          <fo:block>
            <xsl:number level="single" count="elml:item" format="1."/>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block font-family="Courier" font-size="{$fontsize}*1.5" line-height="{$lineheight}" padding-before="2pt">&#x2022;</fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block>
        <xsl:apply-templates/>
      </fo:block>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>


<xsl:template match="elml:box" mode="icon">
  <fo:block border-style="solid" border-width="1pt" border-color="black" padding="3pt" start-indent="{$lineheight}" end-indent="{$lineheight}" space-after.optimum="{$lineheight}" background-color="lightgrey" margin="2pt">
    <xsl:call-template name="Label"/> 
    <xsl:if test="not(@icon)">
      <xsl:attribute name="space-before.optimum">
        <xsl:value-of select="$lineheight"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>


<xsl:template match="elml:popup">
  <!-- FIXME: add popups -->
</xsl:template>



<xsl:template match="elml:term">

  <xsl:variable name="glossRef" select="@glossRef"/>
  <xsl:variable name="definition" select="/elml:lesson/elml:glossary/elml:definition[@term = $glossRef]/text()"/>
  <xsl:variable name="term" select="/elml:lesson/elml:glossary/elml:definition[@term = $glossRef]/@term"/>
  <xsl:choose>
    <xsl:when test="text()">
      <xsl:value-of select="."/>
      <fo:footnote>
        <fo:inline vertical-align="super" font-size="{$fontsize}*0.6">
          <xsl:number count="elml:term[text()]" level="any"/>
        </fo:inline>
        <fo:footnote-body>
          <fo:block start-indent="0pt" line-height="{$lineheight}*0.8">
            <fo:inline font-size="{$fontsize}*0.6"><xsl:number count="elml:term[text()]" level="any"/></fo:inline>
            <xsl:text> </xsl:text>
            <fo:inline font-size="{$fontsize}*0.8"><xsl:value-of select="$definition"/></fo:inline>
          </fo:block>
        </fo:footnote-body>
      </fo:footnote>
    </xsl:when>
    <xsl:otherwise>
      <fo:block font-style="italic">
        <xsl:value-of select="$term"/>: 
      </fo:block>
      <fo:block start-indent="15pt">
        <xsl:value-of select="$definition"/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="elml:paragraph" mode="icon">
  <fo:block>
    <xsl:call-template name="Label"/> 
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>


<xsl:template match="elml:newLine">
  <xsl:choose>
    <xsl:when test="@space='long'">
      <fo:block/>
      <fo:block/>
    </xsl:when>
    <xsl:otherwise>
      <fo:block/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="elml:formatted">
  <xsl:choose>
    <xsl:when test="@style='bold'">
      <fo:inline font-weight="bold">
        <xsl:value-of select="."/>
      </fo:inline>
    </xsl:when>
    <xsl:when test="@style='subscript'">
      <fo:inline vertical-align="sub">
        <xsl:value-of select="."/>
      </fo:inline>   
    </xsl:when>
    <xsl:when test="@style='superscript'">
      <fo:inline vertical-align="super">
        <xsl:value-of select="."/>
      </fo:inline>
    </xsl:when>
    <xsl:when test="@style='italic'">
      <fo:inline font-style="italic">
        <xsl:value-of select="."/>
      </fo:inline>
    </xsl:when>
    <xsl:when test="@style='underlined'">
      <fo:inline text-decoration="underline">
        <xsl:value-of select="."/>
      </fo:inline>
    </xsl:when>
    <xsl:when test="@style='crossedOut'">
      <fo:inline text-decoration="line-through">
        <xsl:value-of select="."/>
      </fo:inline>
    </xsl:when>
    <xsl:when test="@style='upperCase'">
      <fo:inline>
        <xsl:value-of select="translate(., 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
      </fo:inline>
    </xsl:when>
    <xsl:when test="@style='lowerCase'">
      <fo:inline>
         <xsl:value-of select="translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
      </fo:inline>
    </xsl:when>
    <xsl:when test="@style='code'">
      <fo:inline font-family="Courier" white-space="pre">
        <xsl:value-of select="."/>
      </fo:inline>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text> </xsl:text>
</xsl:template>


<xsl:template match="xhtml:a">
  <!-- FIXME: add anchor support -->
  <xsl:apply-templates/>
</xsl:template>



<xsl:template match="elml:multimedia" mode="icon">
  <xsl:choose>
    <xsl:when test="(@type='gif') or (@type='jpeg') or (@type='png') or @thumbnail">
      <fo:external-graphic scaling="uniform" src="{@src}">
      <xsl:call-template name="Label"/>
      <xsl:call-template name="WidthHeight"/>
      <xsl:call-template name="Alignment"/>
    </fo:external-graphic>
    <xsl:call-template name="Legend"/>
  </xsl:when>
  <xsl:otherwise>
    <fo:block border-style="solid" border-color="#cccccc" border-width="0.5pt" background-color="#dedede" width="100%" margin="0mm" padding="10pt" text-align="center">
      <xsl:call-template name="Label"/> 
      <xsl:value-of select="$label_notanimage"/>
    </fo:block>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="elml:citation">
  <xsl:choose>
    <xsl:when test="not(node())">
      <xsl:call-template name="BibliographyRef"/>
    </xsl:when>
    <xsl:when test="preceding-sibling::*[local-name() = 'paragraph' and position() = 1]">
      <fo:block>
        <xsl:call-template name="Label"/>
        <xsl:choose>
          <xsl:when test="@yearOnly='yes'">
            <xsl:call-template name="BibliographyRef"/>
            <xsl:text> "</xsl:text>
            <fo:inline font-style="italic">
              <xsl:apply-templates/>
            </fo:inline>
            <xsl:text>"</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>"</xsl:text>
            <fo:inline font-style="italic">
              <xsl:apply-templates/>
            </fo:inline>
            <xsl:text>"</xsl:text>
            <xsl:call-template name="BibliographyRef"/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <fo:inline>
      <xsl:call-template name="Label"/> 
        <xsl:choose>
          <xsl:when test="@yearOnly='yes'">
            <xsl:call-template name="BibliographyRef"/>
            <xsl:text> "</xsl:text>
            <fo:inline font-style="italic">
              <xsl:apply-templates/>
            </fo:inline>
            <xsl:text>"</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>"</xsl:text>
            <fo:inline font-style="italic">
              <xsl:apply-templates/>
            </fo:inline>
            <xsl:text>"</xsl:text>
            <xsl:call-template name="BibliographyRef"/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:inline>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="WidthHeight">
  <xsl:choose>
    <xsl:when test="local-name()='multimedia'">
      <xsl:if test="@width">
        <xsl:attribute name="content-width">
          <xsl:choose>
            <xsl:when test="@units='percent'">
              <xsl:value-of select="@width"/>
              <xsl:text>%</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="(@width) * $converter_pixel_mm"/>
              <xsl:text>mm</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="width">
          <xsl:choose>
            <xsl:when test="@units='percent'">
              <xsl:value-of select="@width"/>
              <xsl:text>%</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="(@width) * $converter_pixel_mm"/>
              <xsl:text>mm</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@height">
        <xsl:attribute name="content-height">
          <xsl:choose>
            <xsl:when test="@units='percent'">
              <xsl:value-of select="@height"/>
              <xsl:text>%</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="(@height) * $converter_pixel_mm"/>
              <xsl:text>mm</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="height">
          <xsl:choose>
            <xsl:when test="@units='percent'">
              <xsl:value-of select="@height"/>
              <xsl:text>%</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="(@height) * $converter_pixel_mm"/>
              <xsl:text>mm</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="@width">
        <xsl:attribute name="width">
          <xsl:choose>
            <xsl:when test="@units='percent'">
              <xsl:value-of select="@width"/>
              <xsl:text>%</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="(@width) * $converter_pixel_mm"/>
              <xsl:text>mm</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@height">
        <xsl:attribute name="height">
          <xsl:choose>
            <xsl:when test="@units='percent'">
              <xsl:value-of select="@height"/>
              <xsl:text>%</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="(@height) * $converter_pixel_mm"/>
              <xsl:text>mm</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="Alignment">
  <xsl:if test="@align">
    <xsl:choose>
      <xsl:when test="@align='center'">
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="display-align">center</xsl:attribute>
      </xsl:when>
      <xsl:when test="@align='left'">
        <xsl:attribute name="text-align">start</xsl:attribute>
        <xsl:attribute name="display-align">before</xsl:attribute>
      </xsl:when>
      <xsl:when test="@align='right'">
        <xsl:attribute name="text-align">end</xsl:attribute>
        <xsl:attribute name="display-align">before</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="display-align">before</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
  <xsl:if test="@valign">
    <xsl:attribute name="vertical-align" select="@valign"/>
  </xsl:if>
</xsl:template>


<xsl:template name="Title">
  <xsl:if test="@title">
    <fo:block font-size="{$fontsize_title}" line-height="{$lineheight_title}" font-weight="{$fontweight_title}" space-before.optimum="{$lineheight_title}" keep-with-next.within-page="always">
      <xsl:value-of select="@title"/>
    </fo:block>
  </xsl:if>
</xsl:template>


<xsl:template name="Legend">
  <xsl:if test="@legend or @bibIDRef">
    <fo:block font-size="{$fontsize}*{$legendratio}" line-height="{$lineheight}" space-before.optimum="{$lineheight}" keep-with-previous.within-page="always">
      <fo:inline font-style="italic">
        <xsl:value-of select="@legend"/>
      </fo:inline>
      <xsl:call-template name="BibliographyRef"/>
    </fo:block>
  </xsl:if>
</xsl:template>


<xsl:template name="display">
  <xsl:choose>
    <xsl:when test="(@role='student') or (@role=$role) or (not (@role)) and not(@visible='online') and not(@visible='none')">
      <xsl:text>yes</xsl:text>
    </xsl:when>
    <xsl:otherwise>no</xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="Label">
  <xsl:attribute name="id"> 
    <xsl:value-of select="generate-id()"/>
  </xsl:attribute>
</xsl:template>


</xsl:stylesheet>
