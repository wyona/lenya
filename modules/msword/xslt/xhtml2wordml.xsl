<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml"
  xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint"
  exclude-result-prefixes="xhtml">

  <!-- Create the root element for this WordprocessingML document -->
  <xsl:template match="xhtml:html">
    <xsl:processing-instruction name="mso-application">
      <xsl:text>progid="Word.Document"</xsl:text>
    </xsl:processing-instruction>
    <w:wordDocument>
      <xsl:attribute name="xml:space">preserve</xsl:attribute>
      <xsl:copy-of select="$styles-element"/>
      <w:docPr>
        <!-- This only works if you're using Word 2003 standalone or
             Office 2003 Professional -->
        <w:useXSLTWhenSaving/>
        <w:saveThroughXSLT w:xslt="wordml2xhtml.xsl"/>
        <w:documentProtection w:formatting="on" w:enforcement="on"/>
      </w:docPr>
      <w:body>
        <xsl:apply-templates/>
      </w:body>
    </w:wordDocument>
  </xsl:template>

  <!-- Convert <h1> to "Heading 1" paragraph -->
  <xsl:template match="xhtml:h1">
    <w:p>
      <w:pPr>
        <w:pStyle w:val="Heading1"/>
      </w:pPr>
      <xsl:apply-templates/>
    </w:p>
  </xsl:template>
  
  <!-- Convert <h2> to "Heading 2" paragraph -->
  <xsl:template match="xhtml:h2">
    <w:p>
      <w:pPr>
        <w:pStyle w:val="Heading2"/>
      </w:pPr>
      <xsl:apply-templates/>
    </w:p>
  </xsl:template>
  
  <!-- Convert <h3> to "Heading 3" paragraph -->
  <xsl:template match="xhtml:h3">
    <w:p>
      <w:pPr>
        <w:pStyle w:val="Heading3"/>
      </w:pPr>
      <xsl:apply-templates/>
    </w:p>
  </xsl:template>
  
  <!-- Convert <h4> to "Heading 4" paragraph -->
  <xsl:template match="xhtml:h4">
    <w:p>
      <w:pPr>
        <w:pStyle w:val="Heading4"/>
      </w:pPr>
      <xsl:apply-templates/>
    </w:p>
  </xsl:template>
  
  <!-- Convert <h5> to "Heading 5" paragraph -->
  <xsl:template match="xhtml:h5">
    <w:p>
      <w:pPr>
        <w:pStyle w:val="Heading5"/>
      </w:pPr>
      <xsl:apply-templates/>
    </w:p>
  </xsl:template>
  
  <!-- Convert <h6> to "Heading 6" paragraph -->
  <xsl:template match="xhtml:h6">
    <w:p>
      <w:pPr>
        <w:pStyle w:val="Heading6"/>
      </w:pPr>
      <xsl:apply-templates/>
    </w:p>
  </xsl:template>

  <!-- Convert <p> elements to regular Word paragraphs ("Normal" style) -->
  <xsl:template match="xhtml:p">
    <w:p>
      <xsl:apply-templates/>
    </w:p>
  </xsl:template>

  <!-- Don't automatically copy text nodes. Do explicit value-of's instead -->
  <xsl:template match="text()"/>

  <!-- For plain para or title text, just create a run of unformatted text -->
  <xsl:template match="xhtml:p/text() | xhtml:h1/text() | xhtml:h2/text() | xhtml:h3/text()
   | xhtml:h4/text() | xhtml:h5/text() | xhtml:h6/text()">
    <w:r>
      <w:t>
        <xsl:value-of select="."/>
      </w:t>
    </w:r>
  </xsl:template>

  <!-- For text in <emphasis>, apply the "Emphasis" character style -->
  <xsl:template match="xhtml:em/text()">
    <w:r>
      <w:rPr>
        <w:rStyle w:val="Emphasis"/>
      </w:rPr>
      <w:t>
        <xsl:value-of select="."/>
      </w:t>
    </w:r>
  </xsl:template>

  <!-- For text in <strong>, apply the "Strong" character style -->
  <xsl:template match="xhtml:strong/text()">
    <w:r>
      <w:rPr>
        <w:rStyle w:val="Strong"/>
      </w:rPr>
      <w:t>
        <xsl:value-of select="."/>
      </w:t>
    </w:r>
  </xsl:template>

  <!-- Turn the HTML-style <a> tag to the <w:hlink> hyperlink tag -->
  <xsl:template match="xhtml:a">
    <w:hlink w:dest="{@href}">
      <xsl:apply-templates/>
    </w:hlink>
  </xsl:template>

  <!-- For text in <a>, apply the "Hyperlink" character style -->
  <xsl:template match="xhtml:a/text()">
    <w:r>
      <w:rPr>
        <w:rStyle w:val="Hyperlink"/>
      </w:rPr>
      <w:t>
        <xsl:value-of select="."/>
      </w:t>
    </w:r>
  </xsl:template>

  <!-- Copy of all the style definitions used in this document -->
  <xsl:variable name="styles-element">
    <w:styles>
      <w:versionOfBuiltInStylenames w:val="4"/>
      <w:latentStyles w:defLockedState="on" w:latentStyleCount="156">
        <w:lsdException w:name="Normal" w:locked="off"/>
        <w:lsdException w:name="heading 1" w:locked="off"/>
        <w:lsdException w:name="heading 2" w:locked="off"/>
        <w:lsdException w:name="heading 3" w:locked="off"/>
        <w:lsdException w:name="heading 4" w:locked="off"/>
        <w:lsdException w:name="heading 5" w:locked="off"/>
        <w:lsdException w:name="heading 6" w:locked="off"/>
        <w:lsdException w:name="heading 7" w:locked="off"/>
        <w:lsdException w:name="heading 8" w:locked="off"/>
        <w:lsdException w:name="heading 9" w:locked="off"/>
        <w:lsdException w:name="Default Paragraph Font" w:locked="off"/>
        <w:lsdException w:name="Hyperlink" w:locked="off"/>
        <w:lsdException w:name="Strong" w:locked="off"/>
        <w:lsdException w:name="Emphasis" w:locked="off"/>
        <w:lsdException w:name="HTML Top of Form" w:locked="off"/>
        <w:lsdException w:name="HTML Bottom of Form" w:locked="off"/>
        <w:lsdException w:name="Normal Table" w:locked="off"/>
        <w:lsdException w:name="No List" w:locked="off"/>
      </w:latentStyles>
      <w:style w:type="paragraph" w:default="on" w:styleId="Normal">
        <w:name w:val="Normal"/>
        <w:rsid w:val="00664EF3"/>
        <w:pPr>
          <w:spacing w:after="360"/>
        </w:pPr>
        <w:rPr>
          <wx:font wx:val="Times New Roman"/>
          <w:sz w:val="24"/>
          <w:sz-cs w:val="24"/>
          <w:lang w:val="EN-US" w:fareast="EN-US" w:bidi="AR-SA"/>
        </w:rPr>
      </w:style>
      <w:style w:type="paragraph" w:styleId="Heading1">
        <w:name w:val="heading 1"/>
        <wx:uiName wx:val="Heading 1"/>
        <w:basedOn w:val="Normal"/>
        <w:next w:val="Normal"/>
        <w:rsid w:val="00664EF3"/>
        <w:pPr>
          <w:pStyle w:val="Heading1"/>
          <w:keepNext/>
          <w:spacing w:before="240" w:after="60"/>
          <w:outlineLvl w:val="0"/>
        </w:pPr>
        <w:rPr>
          <w:rFonts w:ascii="Arial" w:h-ansi="Arial" w:cs="Arial"/>
          <wx:font wx:val="Arial"/>
          <w:b/>
          <w:b-cs/>
          <w:kern w:val="32"/>
          <w:sz w:val="32"/>
          <w:sz-cs w:val="32"/>
        </w:rPr>
      </w:style>
      <w:style w:type="paragraph" w:styleId="Heading2">
        <w:name w:val="heading 2"/>
        <wx:uiName wx:val="Heading 2"/>
        <w:basedOn w:val="Normal"/>
        <w:next w:val="Normal"/>
        <w:rsid w:val="00664EF3"/>
        <w:pPr>
          <w:pStyle w:val="Heading2"/>
          <w:keepNext/>
          <w:spacing w:before="240" w:after="60"/>
          <w:outlineLvl w:val="1"/>
        </w:pPr>
        <w:rPr>
          <w:rFonts w:ascii="Arial" w:h-ansi="Arial" w:cs="Arial"/>
          <wx:font wx:val="Arial"/>
          <w:b/>
          <w:b-cs/>
          <w:i/>
          <w:i-cs/>
          <w:sz w:val="28"/>
          <w:sz-cs w:val="28"/>
        </w:rPr>
      </w:style>
      <w:style w:type="paragraph" w:styleId="Heading3">
        <w:name w:val="heading 3"/>
        <wx:uiName wx:val="Heading 3"/>
        <w:basedOn w:val="Normal"/>
        <w:next w:val="Normal"/>
        <w:rsid w:val="00664EF3"/>
        <w:pPr>
          <w:pStyle w:val="Heading3"/>
          <w:keepNext/>
          <w:spacing w:before="240" w:after="60"/>
          <w:outlineLvl w:val="2"/>
        </w:pPr>
        <w:rPr>
          <w:rFonts w:ascii="Arial" w:h-ansi="Arial" w:cs="Arial"/>
          <wx:font wx:val="Arial"/>
          <w:b/>
          <w:b-cs/>
          <w:sz w:val="26"/>
          <w:sz-cs w:val="26"/>
        </w:rPr>
      </w:style>
      <w:style w:type="character" w:default="on" w:styleId="DefaultParagraphFont">
        <w:name w:val="Default Paragraph Font"/>
        <w:semiHidden/>
      </w:style>
      <w:style w:type="table" w:default="on" w:styleId="TableNormal">
        <w:name w:val="Normal Table"/>
        <wx:uiName wx:val="Table Normal"/>
        <w:semiHidden/>
        <w:rPr>
          <wx:font wx:val="Times New Roman"/>
        </w:rPr>
        <w:tblPr>
          <w:tblInd w:w="0" w:type="dxa"/>
          <w:tblCellMar>
            <w:top w:w="0" w:type="dxa"/>
            <w:left w:w="108" w:type="dxa"/>
            <w:bottom w:w="0" w:type="dxa"/>
            <w:right w:w="108" w:type="dxa"/>
          </w:tblCellMar>
        </w:tblPr>
      </w:style>
      <w:style w:type="list" w:default="on" w:styleId="NoList">
        <w:name w:val="No List"/>
        <w:semiHidden/>
      </w:style>
      <w:style w:type="character" w:styleId="Emphasis">
        <w:name w:val="Emphasis"/>
        <w:basedOn w:val="DefaultParagraphFont"/>
        <w:rsid w:val="00664EF3"/>
        <w:rPr>
          <w:i/>
          <w:i-cs/>
        </w:rPr>
      </w:style>
      <w:style w:type="character" w:styleId="Strong">
        <w:name w:val="Strong"/>
        <w:basedOn w:val="DefaultParagraphFont"/>
        <w:rsid w:val="00664EF3"/>
        <w:rPr>
          <w:b/>
          <w:b-cs/>
        </w:rPr>
      </w:style>
      <w:style w:type="character" w:styleId="Hyperlink">
        <w:name w:val="Hyperlink"/>
        <w:basedOn w:val="DefaultParagraphFont"/>
        <w:rsid w:val="00664EF3"/>
        <w:rPr>
          <w:color w:val="0000FF"/>
          <w:u w:val="single"/>
        </w:rPr>
      </w:style>
    </w:styles>
  </xsl:variable>
  
  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>

</xsl:stylesheet>
