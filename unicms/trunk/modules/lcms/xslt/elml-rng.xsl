<?xml version="1.0" encoding="UTF-8" ?>


<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://relaxng.org/ns/structure/1.0"
    xmlns:rng="http://relaxng.org/ns/structure/1.0"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
>


<xsl:template match="rng:grammar">
  <grammar ns="http://unizh.ch/doctypes/elml/1.0"
         xmlns="http://relaxng.org/ns/structure/1.0"
         xmlns:elml="http://unizh.ch/doctypes/elml/1.0"
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
      <ref name="noNamespaceSchemaLocation"/>
      <ref name="LessonLabelReq"/>
      <ref name="NavTitleImp"/>
      <attribute name="lenya:dummy"><text/></attribute>
      <attribute name="dc:dummy"><text/></attribute>
      <attribute name="dcterms:dummy"><text/></attribute>
      <ref name="lenya.meta"/>
      <element name="xhtml:h1">
        <text/>
      </element>
      <element name="elml:body"><!-- non-standard, needed for bxe editing area selection -->
        <oneOrMore>
          <choice>
            <ref name="entry"/>
            <ref name="goals"/>
          </choice>
        </oneOrMore>
        <oneOrMore>
          <ref name="unit"/>
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
        <optional>
          <ref name="glossary"/>
        </optional>
        <optional>
          <ref name="bibliography"/>
        </optional>
      </element>
      <optional>
        <element name="metadata">
          <ref name="MetaDataType"/>
        </element>
      </optional>
        <!-- Keys -->
    </element>
</xsl:template>


<xsl:template match="rng:define[@name='TitleReq']">
  <define name="TitleReq">
    <element name="xhtml:h2">
      <text/>
    </element>
  </define>
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
