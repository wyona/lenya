<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml"
    xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint"
    xmlns:o="urn:schemas-microsoft-com:office:office"
    exclude-result-prefixes="w wx o">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:template match="w:wordDocument">
    <html xmlns="http://www.w3.org/1999/xhtml" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0">
      <head>
        <title>
          <xsl:value-of select="o:DocumentProperties/o:Title"/>
        </title>
      </head>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>

  <!-- Convert the w:body element to either a <div> elements or nothing -->
  <xsl:template match="w:body">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Convert <wx:sub-section> elements to <div> elements or nothing -->
  <xsl:template match="wx:sub-section">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Convert <w:p> paragraphs to <p> paragraphs -->
  <xsl:template match="w:p">
    <p>
      <xsl:apply-templates mode="p"/>
    </p>
  </xsl:template>
  
  <!-- turn a run with the "Heading1" character style into <h1> -->
  <xsl:template match="w:p[w:pPr/w:pStyle/@w:val='Heading1']">
    <h1>
      <xsl:copy-of select="w:r/w:t/text()"/>
    </h1>
  </xsl:template>
  
  <!-- turn a run with the "Heading2" character style into <h2> -->
  <xsl:template match="w:p[w:pPr/w:pStyle/@w:val='Heading2']">
    <h2>
      <xsl:copy-of select="w:r/w:t/text()"/>
    </h2>
  </xsl:template>
  
  <!-- turn a run with the "Heading3" character style into <h3> -->
  <xsl:template match="w:p[w:pPr/w:pStyle/@w:val='Heading3']">
    <h3>
      <xsl:copy-of select="w:r/w:t/text()"/>
    </h3>
  </xsl:template>
  
  <!-- turn a run with the "Heading4" character style into <h4> -->
  <xsl:template match="w:p[w:pPr/w:pStyle/@w:val='Heading4']">
    <h4>
      <xsl:copy-of select="w:r/w:t/text()"/>
    </h4>
  </xsl:template>
  
  <!-- turn a run with the "Heading5" character style into <h5> -->
  <xsl:template match="w:p[w:pPr/w:pStyle/@w:val='Heading5']">
    <h5>
      <xsl:copy-of select="w:r/w:t/text()"/>
    </h5>
  </xsl:template>
  
  <!-- turn a run with the "Heading6" character style into <h6> -->
  <xsl:template match="w:p[w:pPr/w:pStyle/@w:val='Heading6']">
    <h6>
      <xsl:copy-of select="w:r/w:t/text()"/>
    </h6>
  </xsl:template>

  <!-- Don't copy text nodes except when explicitly requested (see below) -->
  <xsl:template match="text()"/>
  <xsl:template match="text()" mode="p"/>

  <!-- default behavior for text runs; copy the text through -->
  <xsl:template match="w:r" mode="p">
    <xsl:copy-of select="w:t/text()"/>
  </xsl:template>
  
  <!-- turn a run with the "Emphasis" character style into <emphasis> -->
  <xsl:template match="w:r[w:rPr/w:rStyle/@w:val='Emphasis']"
      mode="p">
    <em>
      <xsl:copy-of select="w:t/text()"/>
    </em>
  </xsl:template>

  <!-- turn a run with the "Strong" character style into <strong> -->
  <xsl:template match="w:r[w:rPr/w:rStyle/@w:val='Strong']"
      mode="p">
    <strong>
      <xsl:copy-of select="w:t/text()"/>
    </strong>
  </xsl:template>

  <!-- Turn a w:hlink element into an HTML-style hyperlink -->
  <xsl:template match="w:hlink" mode="p">
    <a href="{@w:dest}">
      <xsl:apply-templates mode="p"/>
    </a>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
