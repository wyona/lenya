<?xml version="1.0" encoding="UTF-8" ?>


<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://relaxng.org/ns/structure/1.0"
    xmlns:rng="http://relaxng.org/ns/structure/1.0"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
>


<xsl:template match="rng:grammar">
  <grammar ns="http://www.elml.ch"
         xmlns="http://relaxng.org/ns/structure/1.0"
         xmlns:elml="http://www.elml.ch"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
         xmlns:dc="http://purl.org/dc/elements/1.1/"
         xmlns:dcterms="http://purl.org/dc/terms/"
         xmlns:xhtml="http://www.w3.org/1999/xhtml"
         >
     <xsl:apply-templates/>
  </grammar>
</xsl:template>


<!-- BXE: missing support for camelCase attribute values -->

<xsl:template match="rng:attribute">
  <attribute name="{translate(@name, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')}">
    <xsl:apply-templates/>
  </attribute>
</xsl:template>

<xsl:template match="rng:element[@name = 'lesson']">

  <element name="lesson">
    <ref name="schemaLocation"/>
    <ref name="LessonLabelReq"/>
    <ref name="NavTitleImp"/>
    <attribute name="lenya:dummy"><text/></attribute>
    <attribute name="dc:dummy"><text/></attribute>
    <attribute name="dcterms:dummy"><text/></attribute>
    <ref name="lenya.meta"/>
    <element name="xhtml:h1">
      <text/>
    </element>
    <element name="body">
      <interleave>
        <optional>
          <ref name="entry"/>
        </optional>
        <optional>
          <ref name="goals"/>
        </optional>
      </interleave>
    </element>
    <optional>
      <element name="metadata">
        <ref name="MetaDataType"/>
      </element>
    </optional>
  </element>
</xsl:template>


<xsl:template match="rng:element[@name = 'unit']">
  <element name="unit">
    <ref name="LabelReq"/>
    <ref name="TitleReq"/>
    <ref name="NavTitleImp"/>
    <attribute name="lenya:dummy"><text/></attribute>
    <attribute name="dc:dummy"><text/></attribute>
    <attribute name="dcterms:dummy"><text/></attribute>
    <ref name="lenya.meta"/>
    <element name="xhtml:h1"><text/></element>
    <element name="body">
      <interleave>
        <optional>
          <ref name="entry"/>
        </optional>
        <optional>
          <ref name="goals"/>
        </optional>
      </interleave>
      <oneOrMore>
        <ref name="learningObject"/>
      </oneOrMore>
      <zeroOrMore>
        <choice>
          <ref name="selfAssessment"/>
          <ref name="summary"/>
        </choice>
      </zeroOrMore>
      <optional>
        <ref name="furtherReading"/>
      </optional>
    </element>
  </element>
</xsl:template> 

<xsl:template match="rng:element[@name = 'furtherReading' and ancestor::rng:include]">
  <element name="furtherReading">
    <attribute name="lenya:dummy"><text/></attribute>
    <attribute name="dc:dummy"><text/></attribute>
    <attribute name="dcterms:dummy"><text/></attribute>
    <ref name="lenya.meta"/>
    <ref name="SortingImp"/>
    <element name="body">
      <oneOrMore>
        <ref name="resItem"/>
      </oneOrMore>
    </element>
  </element>
</xsl:template>

<xsl:template match="rng:element[@name = 'selfAssessment' and ancestor::rng:include]">
  <element name="selfAssessment">
    <ref name="NavTitleImp"/>
    <ref name="MetaSetUpInfoReq"/>
    <ref name="LabelImp"/>
    <ref name="TitleImp"/>
    <attribute name="lenya:dummy"><text/></attribute>
    <attribute name="dc:dummy"><text/></attribute>
    <attribute name="dcterms:dummy"><text/></attribute>
    <ref name="lenya.meta"/>
    <optional>
      <element name="xhtml:h1"><text/></element>
    </optional>
    <element name="body">
      <zeroOrMore>
        <choice>
          <ref name="lenya.asset"/>
          <ref name="column"/>
          <ref name="table"/>
          <ref name="list"/>
          <ref name="box"/>
          <ref name="term"/>
          <ref name="multimedia"/>
          <ref name="formatted"/>
          <ref name="popup"/>
          <ref name="link"/>
          <ref name="citation"/>
          <ref name="newLine"/>
          <ref name="paragraph"/>
          <ref name="indexItem"/>
          <text/>
        </choice>
      </zeroOrMore>
    </element>
  </element>
</xsl:template>

<xsl:template match="rng:element[@name = 'selfAssessment' and not(ancestor::rng:include)]">
  <element name="selfAssessment">
    <ref name="NavTitleImp"/>
    <ref name="MetaSetUpInfoReq"/>
    <ref name="LabelImp"/>
    <ref name="TitleImp"/>
    <optional>
      <element name="xhtml:h2"><text/></element>
    </optional>
    <zeroOrMore>
      <choice>
        <ref name="lenya.asset"/>
        <ref name="column"/>
        <ref name="table"/>
        <ref name="list"/>
        <ref name="box"/>
        <ref name="term"/>
        <ref name="multimedia"/>
        <ref name="popup"/>
        <ref name="link"/>
        <ref name="citation"/>
        <ref name="paragraph"/>
      </choice>
    </zeroOrMore>
  </element>
</xsl:template>

<xsl:template match="rng:element[@name = 'entry']">
  <element name="entry">
    <ref name="LabelImp"/>
    <ref name="NavTitleImp"/>
    <ref name="TitleImp"/>
    <optional>
      <element name="xhtml:h2">
        <text/>
      </element>
    </optional>
    <zeroOrMore>
      <choice>
        <ref name="lenya.asset"/>
        <ref name="column"/>
        <ref name="table"/>
        <ref name="list"/>
        <ref name="box"/>
        <ref name="term"/>
        <ref name="multimedia"/>
        <ref name="popup"/>
        <ref name="link"/>
        <ref name="citation"/>
        <ref name="paragraph"/>
      </choice>
    </zeroOrMore>
  </element>
</xsl:template>

<xsl:template match="rng:element[@name = 'learningObject']">
  <element name="learningObject">
    <ref name="LabelImp"/>
    <ref name="NavTitleImp"/>
    <ref name="TitleImp"/>
    <optional>
      <element name="xhtml:h2">
        <text/>
      </element>
    </optional>
    <oneOrMore>
      <choice>
        <ref name="clarify"/>
        <ref name="look"/>
        <ref name="act"/>
      </choice>
    </oneOrMore>
  </element>
</xsl:template>

<xsl:template match="rng:element[@name = 'glossary']">
  <element name="glossary">
    <attribute name="lenya:dummy"><text/></attribute>
    <attribute name="dc:dummy"><text/></attribute>
    <attribute name="dcterms:dummy"><text/></attribute>
    <ref name="lenya.meta"/>
    <element name="body">
      <oneOrMore>
        <ref name="definition"/>
      </oneOrMore>
      <empty/>
    </element>
  </element>
</xsl:template>


<xsl:template match="rng:element[@name = 'definition']">
  <element name="definition">
    <ref name="BibIDRefImp"/>
    <element name="term">
      <text/>
    </element>
    <element name="def">
      <zeroOrMore>
        <choice>
          <ref name="list"/>
          <ref name="term"/>
          <ref name="multimedia"/>
          <ref name="formatted"/>
          <ref name="link"/>
          <ref name="citation"/>
          <ref name="newLine"/>
          <ref name="paragraph"/>
          <ref name="indexItem"/>
          <text/>
        </choice>
      </zeroOrMore>
    </element>
  </element>
</xsl:template>


<xsl:template match="rng:element[@name = 'bibliography']">
  <element name="bibliography">
    <attribute name="lenya:dummy"><text/></attribute>
    <attribute name="dc:dummy"><text/></attribute>
    <attribute name="dcterms:dummy"><text/></attribute>
    <ref name="SortingImp"/>
    <ref name="lenya.meta"/>
    <element name="body">
      <oneOrMore>
        <choice>
          <ref name="book"/>
          <ref name="contributionInBook"/>
          <ref name="journalArticle"/>
          <ref name="newspaperArticle"/>
          <ref name="map"/>
          <ref name="conferencePaper"/>
          <ref name="publicationCorporateBody"/>
          <ref name="thesis"/>
          <ref name="patent"/>
          <ref name="videoFilmBroadcast"/>
          <ref name="websites"/>
          <ref name="eJournals"/>
          <ref name="mailLists"/>
          <ref name="personalMail"/>
          <ref name="cdRom"/>
        </choice>
      </oneOrMore>
    </element>
  </element>
</xsl:template> 


<xsl:template match="rng:group">  <!-- unsupported group node -->
  <oneOrMore>
    <xsl:apply-templates/>
  </oneOrMore>
</xsl:template>


<!-- elml2xhtml mapping -->

<xsl:template match="rng:element[@name = 'paragraph']">
  <element name="xhtml:p">
    <xsl:apply-templates/>
  </element>
</xsl:template> 

<xsl:template match="rng:element[@name = 'newLine']">
  <element name="xhtml:br">
    <xsl:apply-templates/>
  </element>
</xsl:template>

<xsl:template match="rng:element[@name = 'table']">
  <element name="xhtml:table">
    <attribute name="class"><value>elml</value></attribute>
    <xsl:apply-templates/>
  </element>
</xsl:template>

<xsl:template match="rng:element[@name = 'tablerow']">
  <element name="xhtml:tr">
    <xsl:apply-templates/>
  </element>
</xsl:template>

<xsl:template match="rng:element[@name = 'tabledata']">
  <element name="xhtml:td">
    <xsl:apply-templates/>
  </element>
</xsl:template>

<xsl:template match="rng:element[@name = 'tableheading']">
  <element name="xhtml:th">
    <xsl:apply-templates/>
  </element>
</xsl:template>

<xsl:template match="rng:element[@name = 'list']">
  <choice>
    <element name="xhtml:ol">
      <xsl:apply-templates/>
    </element>
    <element name="xhtml:ul">
      <xsl:apply-templates/>
    </element>
  </choice>
</xsl:template>

<xsl:template match="rng:element[@name = 'item']">
  <element name="xhtml:li">
    <xsl:apply-templates/>
  </element>
</xsl:template>

<xsl:template match="rng:element[@name = 'formatted']">
  <choice>
    <element name="xhtml:em">
      <choice>
        <ref name="formatted"/>
        <text/>
      </choice>
    </element>
    <element name="xhtml:strong">
      <choice>
        <ref name="formatted"/>
        <text/>
      </choice> 
    </element>
    <element name="xhtml:strike">
      <choice>
        <ref name="formatted"/>
        <text/>
      </choice>
    </element>
    <element name="xhtml:code">
      <choice>
        <ref name="formatted"/>
        <text/>
      </choice>
    </element>
    <element name="xhtml:span">
      <attribute name="class"><text/></attribute>
      <choice>
        <ref name="formatted"/>
        <text/>
      </choice>
    </element>
    <element name="xhtml:u">
      <choice>
        <ref name="formatted"/>
        <text/>
      </choice> 
    </element>
    <element name="xhtml:sub">
      <choice>
        <ref name="formatted"/>
        <text/>
      </choice> 
    </element>
    <element name="xhtml:sup">
      <choice>
        <ref name="formatted"/>
        <text/>
      </choice> 
    </element>
  </choice>
</xsl:template>


<xsl:template match="rng:element[@name = 'link']">
  <element name="xhtml:a">
    <xsl:apply-templates/>
  </element>
</xsl:template>


<xsl:template match="rng:element[@name = 'term']">
  <element name="term">
    <optional>
      <attribute name="icon">
        <text/>
      </attribute>
    </optional>
    <text/>
  </element>
</xsl:template>


<xsl:template match="rng:element[@name = 'multimedia']">
  <element name="xhtml:object">
    <attribute name="data">
      <text/>
    </attribute>
    <attribute name="type">
      <text/>
    </attribute>
  </element>
</xsl:template> 



<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet> 
