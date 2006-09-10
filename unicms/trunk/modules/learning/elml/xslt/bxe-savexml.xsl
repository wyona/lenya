<?xml version="1.0" encoding="UTF-8" ?>


<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.elml.ch"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
    xmlns:elml="http://www.elml.ch"
    xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
    xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:dcterms="http://purl.org/dc/terms/"
>


<!-- add back camelCase attributes -->

<xsl:template match="@*">
  <xsl:param name="name">
    <xsl:choose>
      <xsl:when test="name() = 'navtitle'">navTitle</xsl:when>
      <xsl:when test="name() = 'intstatement'">intStatement</xsl:when>
      <xsl:when test="name() = 'targetlesson'">targetLesson</xsl:when>
      <xsl:when test="name() = 'targetlabel'">targetLabel</xsl:when>
      <xsl:when test="name() = 'mimetype'">mimeType</xsl:when>
      <xsl:when test="name() = 'htmlattributes'">HTMLAttributes</xsl:when>
      <xsl:when test="name() = 'glossref'">glossRef</xsl:when>
      <xsl:when test="name() = 'liststyle'">listStyle</xsl:when>
      <xsl:when test="name() = 'metasetupinfo'">metaSetUpInfo</xsl:when>
      <xsl:when test="name() = 'yearonly'">yearOnly</xsl:when>
      <xsl:when test="name() = 'mainentry'">mainEntry</xsl:when>
      <xsl:when test="name() = 'affiliatedto'">affiliatedTo</xsl:when>
      <xsl:when test="name() = 'xsi:nonamespaceschemalocation'">xsi:noNamespaceSchemaLocation</xsl:when>
      <xsl:when test="name() = 'bibid'">bibID</xsl:when>
      <xsl:when test="name() = 'bibidref'">bibIDRef</xsl:when>
      <xsl:when test="name() = 'publicationyear'">publicationYear</xsl:when>
      <xsl:when test="name() = 'publicationplace'">publicationPlace</xsl:when>
      <xsl:when test="name() = 'titleofcontribution'">titleOfContribution</xsl:when>
      <xsl:when test="name() = 'pagenr'">pageNr</xsl:when>
      <xsl:when test="name() = 'journaltitle'">journalTitle</xsl:when>
      <xsl:when test="name() = 'volumenr'">volumeNr</xsl:when>
      <xsl:when test="name() = 'newspapertitle'">newspaperTitle</xsl:when>
      <xsl:when test="name() = 'daymonth'">dayMonth</xsl:when>
      <xsl:when test="name() = 'proceedingstitle'">proceedingsTitle</xsl:when>
      <xsl:when test="name() = 'dateplace'">datePlace</xsl:when>
      <xsl:when test="name() = 'reportnr'">reportNr</xsl:when>
      <xsl:when test="name() = 'productionplace'">productionPlace</xsl:when>
      <xsl:when test="name() = 'productionorganisation'">productionOrganisation</xsl:when>
      <xsl:when test="name() = 'downloadurl'">downloadUrl</xsl:when>
      <xsl:when test="name() = 'accesseddate'">accessedDate</xsl:when>
      <xsl:when test="name() = 'daymonthyear'">dayMonthYear</xsl:when>
      <xsl:when test="name() = 'discussionlist'">discussionList</xsl:when>
      <xsl:when test="name() = 'emailsender'">emailSender</xsl:when>
      <xsl:when test="name() = 'emailrecipient'">emailRecipient</xsl:when>
      <xsl:when test="name() = 'originallanguage'">originalLanguage</xsl:when>
      <xsl:when test="name() = 'creationdate'">creationDate</xsl:when>
      <xsl:when test="name() = 'modificationdate'">modificationDate</xsl:when>
      <xsl:when test="name() = 'cssclass'">cssClass</xsl:when> 
      <xsl:otherwise>
         <xsl:value-of select="name()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:attribute name="{$name}">
    <xsl:value-of select="."/>
  </xsl:attribute>
</xsl:template>


<xsl:template match="elml:lesson | elml:unit">
  <xsl:copy>
    <xsl:attribute name="lenya:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:attribute name="dc:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:attribute name="dcterms:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:attribute name="elml:dummy">FIXME:keepNamespace</xsl:attribute>
    
    <xsl:attribute name="title">
      <xsl:value-of select="xhtml:h1"/>
    </xsl:attribute>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="lenya:meta"/>
    <xsl:apply-templates select="elml:body/*"/>
    <xsl:apply-templates select="elml:bibliography"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="dc:title">
  <xsl:choose>
    <xsl:when test="/*/xhtml:h1">
      <dc:title>
        <xsl:value-of select="/*/xhtml:h1"/>
      </dc:title>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="elml:selfAssessment[not(parent::*)]">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="lenya:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:attribute name="dc:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:attribute name="dcterms:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:attribute name="elml:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:if test="xhtml:h1">
      <xsl:attribute name="title">
        <xsl:value-of select="xhtml:h1"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="lenya:meta"/>
    <xsl:apply-templates select="elml:body/*"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="elml:summary[not(parent::*)]">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="lenya:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:attribute name="dc:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:attribute name="dcterms:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:attribute name="elml:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:if test="xhtml:h1">
      <xsl:attribute name="title"> 
        <xsl:value-of select="xhtml:h1"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="lenya:meta"/>
    <xsl:apply-templates select="elml:body/*"/>
  </xsl:copy>
</xsl:template> 

<xsl:template match="elml:furtherReading[not(parent::*)]">
  <xsl:copy>
    <xsl:attribute name="lenya:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:attribute name="dc:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:attribute name="dcterms:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:attribute name="elml:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="lenya:meta"/>
    <xsl:apply-templates select="elml:body/*"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="elml:glossary">
  <xsl:copy>
    <xsl:attribute name="lenya:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:attribute name="dc:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:attribute name="dcterms:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:attribute name="elml:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="lenya:meta"/>
    <xsl:apply-templates select="elml:body/*"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="elml:bibliography">
  <xsl:copy>
    <xsl:attribute name="lenya:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:attribute name="dc:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:attribute name="dcterms:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:attribute name="elml:dummy">FIXME:keepNamespace</xsl:attribute>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="lenya:meta"/>
    <xsl:apply-templates select="elml:body/*"/>
  </xsl:copy>
</xsl:template>


<xsl:template match="elml:learningObject | elml:entry | elml:clarify | elml:look | elml:act | elml:selfAssessment[parent::*] | elml:summary[parent::*]">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:if test="xhtml:h2">
      <xsl:attribute name="title">
        <xsl:value-of select="xhtml:h2"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template>


<xsl:template match="elml:definition">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="term">
      <xsl:value-of select="elml:term"/>
    </xsl:attribute>
    <xsl:apply-templates select="elml:def/node()"/>
  </xsl:copy>
</xsl:template>


<xsl:template match="xhtml:h1"/>
<xsl:template match="xhtml:h2"/>
<xsl:template match="xhtml:h3"/>

<xsl:template match="xhtml:p">
  <paragraph>
    <xsl:choose>
      <xsl:when test="preceding-sibling::*[name() = 'xhtml:h3' and position() = 1]">
        <xsl:attribute name="title">
          <xsl:value-of select="preceding-sibling::*[name() ='xhtml:h3' and position() = 1]"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="@title">
          <xsl:copy-of select="@title"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="@*|node()"/>
  </paragraph>
</xsl:template>

<xsl:template match="xhtml:br">
  <newLine/>
</xsl:template>

 
<xsl:template match="xhtml:strong">
  <formatted style="bold">
    <xsl:apply-templates/>
  </formatted>
</xsl:template>


<xsl:template match="xhtml:em">
  <formatted style="italic">
    <xsl:apply-templates/>
  </formatted>
</xsl:template>


<xsl:template match="xhtml:u">
  <formatted style="underline">
    <xsl:apply-templates/>
  </formatted>
</xsl:template>


<xsl:template match="xhtml:strike">
  <formatted style="crossedOut">
    <xsl:apply-templates/>
  </formatted>
</xsl:template>

<xsl:template match="xhtml:span[@class = 'lowercase']">
  <formatted style="lowerCase">
    <xsl:apply-templates/>
  </formatted>
</xsl:template>

<xsl:template match="xhtml:span[@class = 'uppercase']">
  <formatted style="upperCase">
    <xsl:apply-templates/>
  </formatted>
</xsl:template>

<xsl:template match="xhtml:code">
  <formatted style="code">
    <xsl:apply-templates/>
  </formatted>
</xsl:template>


<xsl:template match="xhtml:sup">
  <formatted style="superscript">
    <xsl:apply-templates/>
  </formatted>
</xsl:template>


<xsl:template match="xhtml:sub">
  <formatted style="subscript">
    <xsl:apply-templates/>
  </formatted>
</xsl:template>


<xsl:template match="xhtml:table">
  <table>
    <xsl:apply-templates select="@*[not(name() = 'class')]"/>
    <xsl:apply-templates/>
  </table>
</xsl:template>

<xsl:template match="xhtml:tr">
  <tablerow>
    <xsl:apply-templates select="@*|node()"/>
  </tablerow>
</xsl:template>

<xsl:template match="xhtml:td">
  <tabledata>
    <xsl:apply-templates select="@*|node()"/>
  </tabledata>
</xsl:template>

<xsl:template match="xhtml:th">
  <tableheading>
    <xsl:apply-templates select="@*|node()"/>
  </tableheading>
</xsl:template>


<xsl:template match="xhtml:ul">
  <list listStyle="unordered">
    <xsl:apply-templates/>
  </list>
</xsl:template>


<xsl:template match="xhtml:ol">
  <list listStyle="ordered">
    <xsl:apply-templates/>
  </list>
</xsl:template>

<xsl:template match="xhtml:li">
  <item>
    <xsl:apply-templates/>
  </item>
</xsl:template>


<xsl:template match="elml:term">
  <elml:term icon="{@icon}" glossRef="{.}"/>
</xsl:template>



<xsl:template match="node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet> 
