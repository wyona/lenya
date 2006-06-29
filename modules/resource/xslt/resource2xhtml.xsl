<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: xhtml-standard.xsl,v 1.44 2004/12/14 11:00:41 josias Exp $ -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:mobi="http://mobi.ch/homepage/1.0"
  xmlns:media="http://apache.org/lenya/pubs/default/media/1.0"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:dcterms="http://purl.org/dc/terms/"
  exclude-result-prefixes="xhtml lenya mobi dc">
  
  <xsl:import href="fallback://lenya/modules/mediatype/xslt/common/mimetype.xsl"/>
  <xsl:include href="fallback://lenya/modules/xhtml/xslt/helper-object.xsl"/>
  <xsl:param name="root"/> <!-- the URL up to (including) the area -->
  <xsl:param name="documentId"/>
  <xsl:param name="context-prefix" select="''"/>
  <xsl:param name="language"/>
  <xsl:param name="document-type"/>
  <xsl:param name="documentParent"/>
  <xsl:param name="title"/>
  <xsl:variable name="imageprefix"
    select="concat($context-prefix,'/modules/mediatype')"/>
  <xsl:variable name="nodeid"
    select="concat($context-prefix,$root,$documentParent)"/>
  
  <xsl:template match="/">
    <xhtml:div id="body">
      <xsl:apply-templates select="//lenya:meta" mode="media"/>
    </xhtml:div>
  </xsl:template>
    
  <xsl:template match="lenya:meta" mode="media">
    
    <xsl:variable name="mediaName" select="concat($documentId, '.', lenya:internal/lenya:extension)"/>
    
    <xsl:variable name="mediaURI">
      <xsl:value-of select="$root"/>
      <xsl:value-of select="$mediaName"/>
    </xsl:variable>
    
    <xsl:variable name="size">
      <xsl:choose>
        <xsl:when test="lenya:custom/lenya:media-extent = ''">??</xsl:when>
        <xsl:otherwise><xsl:value-of
            select="format-number(lenya:custom/lenya:media-extent div 1024, '#,###.##')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <table width="500" cellpadding="2" cellspacing="0" border="0" bgcolor="#f2f2f2"
      style="border-width:1pt;border-color:#d6d6d6;border-style:line">
      <tr>
        <td> <a href="{$mediaURI}" target="_new">
          <xsl:call-template name="icon">
            <xsl:with-param name="mimetype"
              select="lenya:custom/lenya:media-format"/>
            <xsl:with-param name="imageprefix" select="$imageprefix"/>
          </xsl:call-template> </a>
        </td>
        <td><h1><i18n:text>Resource Document</i18n:text></h1></td>
      </tr>
      <tr>
        <td><i><i18n:text>Title</i18n:text>:</i></td>
        <td><strong><xsl:value-of select="lenya:dc/dc:title"/></strong></td>
      </tr>
      <tr>
        <td><i><i18n:text>Description</i18n:text>:</i></td>
        <td><xsl:value-of select="lenya:dc/dc:description"/></td>
      </tr>
      <tr>
        <td><i><i18n:text>Content</i18n:text>:</i></td>
        <td><a href="{$mediaURI}" target="_new"><xsl:value-of select="$mediaName"/>
          </a></td>
      </tr>
      <tr>
        <td><i><i18n:text>Size</i18n:text>:</i></td>
        <td><xsl:value-of select="$size"/> KB</td>
      </tr>
      <tr>
        <td><i><i18n:text>MimeType</i18n:text>:</i></td>
        <td><xsl:value-of select="lenya:custom/lenya:media-format"/></td>
      </tr>
      <xsl:if test="lenya:custom/lenya:media-width != ''">
        <tr>
          <td><i><i18n:text>Dimension</i18n:text>:</i></td>
          <td><xsl:value-of select="lenya:custom/lenya:media-width"/>x
            <xsl:value-of select="lenya:custom/lenya:media-height"/></td>
        </tr>
      </xsl:if>
      <tr>
        <td colspan="2"><i><i18n:text>Preview</i18n:text>:</i><br/><br/>
        <div align="center">
          <xsl:call-template name="preview">
            <xsl:with-param name="mimetype"
              select="lenya:custom/lenya:media-format"/>
            <xsl:with-param name="mediaURI" select="$mediaURI"/>
          </xsl:call-template><br/><br/>
        </div>
        </td>
      </tr>
    </table>

  </xsl:template>
  
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
