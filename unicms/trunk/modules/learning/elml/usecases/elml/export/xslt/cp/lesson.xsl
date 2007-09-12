<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: elml-standard.xsl 22112 2007-01-24 16:11:35Z thomas $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:uz="http://unizh.ch"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:elml="http://www.elml.ch"
  >
  
  <xsl:param name="root"/>
  <xsl:param name="contextprefix"/>
  <xsl:param name="area"/>
  <xsl:param name="rendertype"/>
  <xsl:param name="defaultlanguage"/>
  <xsl:param name="language"/>
  <xsl:param name="nodeid"/>
  <xsl:param name="fontsize"/>
  <xsl:param name="querystring"/>
  <xsl:param name="creationdate"/>


  <xsl:param name="pagebreak_level"><xsl:value-of select="//elml:pagebreak_level"/></xsl:param>
  <xsl:param name="current_section"/> 
  <xsl:param name="current_label"/>
  <xsl:param name="header_heading"/>
  <xsl:param name="header_superscription"/>
  <xsl:param name="omit_header"/>


  <xsl:include href="../../../../../../unizh/xslt/doctypes/variables.xsl"/>
  <xsl:include href="html-head.xsl"/>
  <xsl:include href="header.xsl"/>
  <xsl:include href="footer.xsl"/> 
  <xsl:include href="../../../../../../unizh/xslt/common/elml.xsl"/> 
  <xsl:include href="../../../../../../unizh/xslt/common/biblio_harvard.xsl"/>

  <xsl:template match="document">
    <xsl:apply-templates select="content"/>
  </xsl:template>


  <xsl:template match="content"> 
    <html>
      <xsl:call-template name="html-head"/> 
      <body>
        <div>
          <a accesskey="2" title="Zum Inhalt springen" href="#content"><xsl:comment/></a>
          <a name="top"><xsl:comment/></a>
          <xsl:if test="$omit_header != 'true'">
            <xsl:call-template name="header"/> 
              <br/>
              <br/>
          </xsl:if>
          <xsl:call-template name="content"/>
        </div>
      </body>
    </html>
  </xsl:template>


  <xsl:template name="content">
    <div >
      <div class="relatedbox">
        <xsl:comment/>&#160;
      </div>
      <div class="contentarea">
        <a accesskey="2" name="content" class="namedanchor"><xsl:comment/></a>
        <div class="blacontent">
          <xsl:choose>
            <xsl:when test="$pagebreak_level = 'unit'">
              <xsl:call-template name="section-content"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="lesson-content"/>
            </xsl:otherwise>
          </xsl:choose>
        </div>
        <xsl:call-template name="footer"/> 
      </div>
    </div>
  </xsl:template>


  <xsl:template name="lesson-content">
     <h1>
       <xsl:choose>
         <xsl:when test="/document/content/unizh:lessonEnvelope/elml:lesson/@title">
           <xsl:value-of select="/document/content/unizh:lessonEnvelope/elml:lesson/@title"/>
         </xsl:when>
         <xsl:otherwise>
           <xsl:value-of select="/document/content/unizh:lessonEnvelope/lenya:meta/dc:title"/>
         </xsl:otherwise>
       </xsl:choose>
     </h1>
     <xsl:apply-templates select="/document/content/unizh:lessonEnvelope/elml:lesson/*[not(self::elml:context) and not(self::elml:metadata)]"/>
  </xsl:template>

  <xsl:template name="section-content">

    <xsl:choose>
      <xsl:when test="$current_section = 'unit'">
        <h1>
          <xsl:value-of select="//elml:unit[@label = $current_label]/@title"/>
        </h1>
        <xsl:apply-templates select="//elml:unit[@label = $current_label]"/>
      </xsl:when>
      <xsl:when test="$current_section = 'furtherReading'">
        <h1><xsl:value-of select="//elml:messagebundle/elml:msg[@name = 'name_furtherReading']"/></h1>
        <xsl:apply-templates select="//elml:lesson/elml:furtherReading"/>
      </xsl:when>
      <xsl:when test="$current_section = 'selfAssessment'">
        <h1><xsl:value-of select="//elml:messagebundle/elml:msg[@name = 'name_selfAssessment']"/></h1>
        <xsl:apply-templates select="//elml:lesson/elml:selfAssessment"/>
      </xsl:when>
      <xsl:when test="$current_section = 'summary'">
        <h1><xsl:value-of select="//elml:messagebundle/elml:msg[@name = 'name_summary']"/></h1>
        <xsl:apply-templates select="//elml:lesson/elml:summary"/>
      </xsl:when>
      <xsl:when test="$current_section = 'glossary'">
        <h1><xsl:value-of select="//elml:messagebundle/elml:msg[@name = 'name_glossary']"/></h1>
        <xsl:apply-templates select="//elml:lesson/elml:glossary"/>
      </xsl:when> 
      <xsl:when test="$current_section = 'bibliography'">
        <h1><xsl:value-of select="//elml:messagebundle/elml:msg[@name = 'name_bibliography']"/></h1>
        <xsl:apply-templates select="//elml:lesson/elml:bibliography"/>
      </xsl:when>
      <xsl:otherwise>
        <h1>
           <xsl:choose>
             <xsl:when test="/document/content/unizh:lessonEnvelope/elml:lesson/@title">
               <xsl:value-of select="/document/content/unizh:lessonEnvelope/elml:lesson/@title"/>
             </xsl:when>
             <xsl:otherwise>
               <xsl:value-of select="/document/content/unizh:lessonEnvelope/lenya:meta/dc:title"/>
             </xsl:otherwise>
           </xsl:choose>
         </h1>
         <xsl:apply-templates select="/document/content/unizh:lessonEnvelope/elml:lesson/*[not(self::elml:unit) and not(self::elml:selfAssessment) and not(self::elml:furtherReading) and not(self::elml:summary) and not(self::elml:glossary) and not(self::elml:bibliography) and not(self::elml:context)]"/>
      </xsl:otherwise>
    </xsl:choose>  
  </xsl:template> 

  <xsl:template match="elml:metadata"/>


  <xsl:template match="elml:link">
    <xsl:variable name="targetLabel" select="@targetLabel"/> 
    <xsl:variable name="targetNode" select="//*[@label = $targetLabel]"/>
    <xsl:variable name="uri">
      <xsl:choose>
        <xsl:when test="$targetNode[self::elml:unit]">
          <xsl:value-of select="$targetNode/@label"/>.html
        </xsl:when>
        <xsl:when test="$targetNode[ancestor::elml:unit]">
          <xsl:value-of select="//elml:unit[descendant::* = $targetNode]/@label"/>.html#<xsl:value-of select="$targetNode/@label"/>
        </xsl:when>
        <xsl:when test="$targetNode[self::elml:selfAssessment]">
           selfAssessment.html
        </xsl:when>
        <xsl:when test="$targetNode[ancestor::elml:selfAssessment]">
            selfAssessment.html#<xsl:value-of select="$targetNode/@label"/>
        </xsl:when>
        <xsl:when test="$targetNode[self::elml:summary]">
             summary.html
        </xsl:when>
        <xsl:when test="$targetNode[ancestor::elml:summary]">
             summary.html#<xsl:value-of select="$targetNode/@label"/>
        </xsl:when>
        <xsl:otherwise>
         #<xsl:value-of select="$targetNode/@label"/>
        </xsl:otherwise>

      </xsl:choose>
    </xsl:variable>
    <a href="{$uri}"><xsl:apply-templates/></a>
  </xsl:template>







</xsl:stylesheet>
