<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
    xmlns:elt="http://www.unizh.ch/elt/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
>

 <!--  body -->
  <xsl:attribute-set name="body">
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="text-align">justify</xsl:attribute>
  </xsl:attribute-set>


  <!--  paragraphs -->
  <xsl:attribute-set name="p">
    <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
  </xsl:attribute-set>


  <!-- titles -->
  <xsl:attribute-set name="h1">
    <xsl:attribute name="font-size">20pt</xsl:attribute>
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="space-after">14pt</xsl:attribute>
    <!-- <xsl:attribute name="break-before">page</xsl:attribute> -->
    <xsl:attribute name="border-after-style">solid</xsl:attribute>
    <xsl:attribute name="border-after-width">1pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="h2">
    <xsl:attribute name="font-size">16pt</xsl:attribute>
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="space-before">19pt</xsl:attribute>
    <xsl:attribute name="space-after">5pt</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="h3">
    <xsl:attribute name="font-size">13pt</xsl:attribute>
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="space-before">14pt</xsl:attribute>
    <xsl:attribute name="space-after">5pt</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
  </xsl:attribute-set>


  <!-- content transformation -->
  <xsl:template match="/xhtml:html">
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
      <fo:layout-master-set>
        <fo:simple-page-master master-name="page"
            page-height="297mm" 
            page-width="210mm"
            margin-top="10mm" 
            margin-bottom="10mm" 
            margin-left="10mm" 
            margin-right="10mm">
          <fo:region-before extent="5cm"/>
          <fo:region-body margin-top="6cm" margin-bottom="2cm"/>
          <fo:region-after extent="1.5cm"/>
        </fo:simple-page-master>
      </fo:layout-master-set>

      <fo:page-sequence master-reference="page" initial-page-number="auto">
        <fo:static-content flow-name="xsl-region-before">
          <fo:table width="100%">
            <fo:table-column column-width="12cm"/>
            <fo:table-column/>
            <fo:table-body>
              <fo:table-row>
                <fo:table-cell>
                  <fo:external-graphic src="url('http://localhost:8080/lenya/eltemplate/authoring/images/Logo_mini.gif')" height="1.8cm"/>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block>
                    Schweizerisches Obligationenrecht 
                  </fo:block>
                  <fo:block>
                   Besonderer Teil 
                  </fo:block>
                  <fo:block>Skriptum und web based training
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </fo:table-body>
          </fo:table>
          <fo:table width="100%">
            <fo:table-column column-width="4cm"/>
            <fo:table-column/>
            <fo:table-body>
              <fo:table-row>
                <fo:table-cell/>
                <fo:table-cell>
                  <fo:block font-size="24pt">
                    Obligationenrecht INTERAKTIV
                  </fo:block>
                  <fo:block>
                    von Prof. Dr. Claire Huguenin, Universit&#228;t Z&#252;rich
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </fo:table-body>
          </fo:table>
        </fo:static-content>
        <fo:static-content flow-name="xsl-region-after">
          <fo:block font-size="9pt" space-after="3mm" text-align="center">
            <xsl:apply-templates select="//elt:disclaimer/text()"/>
          </fo:block>
          <fo:block text-align="center" font-size="10pt">
            - <fo:page-number/> -
          </fo:block> 
        </fo:static-content>
        <fo:flow flow-name="xsl-region-body">
          <fo:block xsl:use-attribute-sets="body">
          <xsl:apply-templates select="lenya:meta/dc:title"/>
            <fo:table table-layout="fixed">
              <fo:table-column column-width="10cm"/>
              <fo:table-column column-width="1cm"/>
              <fo:table-column column-width="8cm"/>
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block>
                      <fo:block>
                        <xsl:if test="//elt:referenced-doc">
                          <xsl:attribute name="font-weight">bold</xsl:attribute>
                        </xsl:if>
                        <xsl:apply-templates select="xhtml:body"/>
                      </fo:block>
                      <fo:block space-after="10mm"/>
                      <xsl:apply-templates select="//elt:footnote"/>
                      <fo:block space-after="10mm"/>
                      <xsl:for-each select="//elt:referenced-doc[contains(@href, 'Literatur')]">
                        <fo:block xsl:use-attribute-sets="h3">
                          Literatur
                        </fo:block>
                        <fo:block>
                          <xsl:apply-templates select="xhtml:html/xhtml:body/*"/>
                        </fo:block>
                      </xsl:for-each>
                      <xsl:for-each select="//elt:referenced-doc[contains(@href, 'Entscheide')]">
                        <fo:block xsl:use-attribute-sets="h3">
                         Bundesgerichtsentscheide
                        </fo:block>
                        <fo:block>
                          <xsl:apply-templates select="xhtml:html/xhtml:body/xhtml:div[@id = 'bge-toc']/*"/>
                        </fo:block>
                      </xsl:for-each>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell/>
                  <fo:table-cell>
                   <fo:block>
                     <xsl:apply-templates select="//elt:referenced-docs/elt:referenced-doc[contains(@href, 'Gesetzestexte')]/unizh:popup"/> 
                   </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
          </fo:block>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  

  <xsl:template match="xhtml:body">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- paragraphs -->
  <xsl:template match="xhtml:p">
    <fo:block xsl:use-attribute-sets="p">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="xhtml:br">
    <fo:block/>
  </xsl:template>

  <xsl:template match="xhtml:div">
   <fo:block space-before="3mm">
     <xsl:apply-templates/>
   </fo:block>
  </xsl:template>

  <xsl:template match="lenya:meta/dc:title">
    <fo:block xsl:use-attribute-sets="h1">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="xhtml:h2">
    <fo:block xsl:use-attribute-sets="h2">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="xhtml:h3">
    <fo:block xsl:use-attribute-sets="h3">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="xhtml:ul | xhtml:ol">
    <fo:list-block space-before="3mm" space-after="3mm" start-indent="3mm">
      <xsl:apply-templates/>
    </fo:list-block>
  </xsl:template>

  <xsl:template match="xhtml:li[parent::xhtml:ul]">
    <fo:list-item>
      <fo:list-item-label>
        <fo:block>&#8226;</fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="7mm">
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <xsl:template match="xhtml:li[parent::xhtml:ol]">
    <fo:list-item>
      <fo:list-item-label>
        <fo:block><xsl:value-of select="position() div 2"/>.</fo:block><!-- FIXME: yields 2,4,6 ?? -->
      </fo:list-item-label>
      <fo:list-item-body start-indent="7mm">
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>


  <xsl:template match="elt:footnote-reference">
    <xsl:variable name="idref"><xsl:value-of select="@idref"/></xsl:variable>
    <xsl:variable name="index">
      <xsl:for-each select="//elt:footnote">
        <xsl:if test="@id = $idref">
          <xsl:value-of select="position()"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:apply-templates/>
    (<xsl:value-of select="$index"/>)
  </xsl:template>

  <xsl:template match="elt:footnote">
    <fo:leader leader-length="100%" leader-pattern="dots"/>
    <fo:block font-size="10pt">
      (<xsl:value-of select="position()"/>)
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

 
  <xsl:template match="elt:cross-reference">
    <xsl:apply-templates select="text()"/>
  </xsl:template>
  
  <xsl:template match="elt:referenced-doc[contains(@href, 'Gesetzestexte')]/unizh:popup">
    <fo:block background-color="#eeeeee" space-after="3mm" padding="3mm 3mm 3mm 3mm">
      <xsl:apply-templates select="lenya:meta/dc:title"/>
        <xsl:apply-templates select="xhtml:body/*"/>
    </fo:block>
  </xsl:template>


  <xsl:template match="elt:referenced-docs/elt:referenced-doc/unizh:popup/lenya:meta/dc:title">
    <fo:block>
      <xsl:value-of select="."/>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="elt:disclaimer">

  </xsl:template>
 
</xsl:stylesheet>

