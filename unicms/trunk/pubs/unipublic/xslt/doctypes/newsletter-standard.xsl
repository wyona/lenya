<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: newsletter-standard.xsl,v 1.7 2004/12/23 13:45:16 thomas Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"  
  xmlns:up="http://www.unipublic.unizh.ch/2002/up"
  xmlns:col="http://apache.org/cocoon/lenya/collection/1.0"
  exclude-result-prefixes="xhtml lenya dc up"
  >
  
  <xsl:import href="variables.xsl"/>

  <xsl:param name="root"/> <!-- the URL up to (including) the area -->
  <xsl:param name="contextprefix"/>
  
  <xsl:param name="documentid"/>
  <xsl:param name="nodeid"/>
  
  <xsl:param name="language"/>
  <xsl:param name="defaultlanguage"/>
  <xsl:param name="languages"/>
  
  <xsl:param name="completearea"/>
  <xsl:param name="area"/>
  
  <xsl:param name="rendertype"/>
  
  <xsl:param name="lastmodified"/>

  <xsl:include href="../common/html-head.xsl"/>
  <xsl:include href="../common/header.xsl"/>
  <xsl:include href="../common/elements.xsl"/>
  <xsl:include href="../common/footer.xsl"/>

  <xsl:template match="document">
    <xsl:apply-templates select="content/*"/>
  </xsl:template>
  
  
  <xsl:template match="content/*">
    <html>
      <xsl:call-template name="html-head"/>
      <body>
        <div id="main">
          <xsl:call-template name="topnavbar"/>
          <table cellspacing="0" cellpadding="0" border="0" width="585">
            <tr>
              <td valign="top" bgcolor="white" class="tsr-text">
                <div style="margin: 30px; font-size:medium">
                  <h1>Newsletter Preview</h1>
                  <table border="0" cellpadding="0" cellspacing="0">
                    <xsl:apply-templates select="up:email/*"/>
                  </table>
                </div>
                <div style="margin: 30px; font-size:medium">
                  <code>
                    <div bxe_xpath="/up:newsletter/lenya:meta/dc:title">
                      <xsl:value-of select="lenya:meta/dc:title"/>
                    </div>
                    <br/>
                    <xsl:call-template name="underline">
                      <xsl:with-param name="title" select="lenya:meta/dc:title"/>
                    </xsl:call-template>
                    <br/>
                    <br/>
                    <div bxe_xpath="/up:newsletter/lenya:meta/dc:description">
                      <xsl:value-of select="lenya:meta/dc:description" />
                    </div>
                    <br/>
                    <br/>
                  </code>
                  <div bxe_xpath="/up:newsletter/col:documents">
                    <xsl:apply-templates select="col:document"/>
                  </div>
                  <xsl:apply-templates select="up:footer" />
                </div>
              </td>
            </tr>  
            <xsl:call-template name="footer_newsletter"/>
          </table>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="col:document">
    <code>
      <xsl:value-of select="lenya:meta/dc:title"/>
      <br/>
      <xsl:call-template name="underline">
        <xsl:with-param name="title" select="lenya:meta/dc:title"/>
      </xsl:call-template>
      <br/>
      <xsl:choose>
        <xsl:when test="up:teaser/xhtml:div[@class='tsr-text']!=''">
          <xsl:value-of select="up:teaser/xhtml:div[@class='tsr-text']"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="lenya:meta/dc:description"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="lenya:meta/dcterms:issued!=''">
          (<xsl:apply-templates select="lenya:meta/dcterms:issued" mode="section"/>)
        </xsl:when>
        <xsl:otherwise>
          <br/>(Noch nie publiziert)
        </xsl:otherwise>
      </xsl:choose>
      <br/>
      Mehr unter:
      <br/>
      <xsl:value-of select="concat('http://www.unipublic.unizh.ch', @id, $documentlanguagesuffix, '.html')"/> 
      <br/>
      <br/>
      <br clear="all" />
    </code>
  </xsl:template>

  <xsl:template match="up:email/up:to">
    <tr>
      <td><strong>To:</strong></td>
      <td>
        <code>
          <div bxe_xpath="/up:newsletter/up:email/up:to">
            <xsl:apply-templates/>
          </div>
        </code>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="up:email/up:cc">
    <tr>
      <td><strong>Cc:</strong></td>
      <td>
        <code>
          <div bxe_xpath="/up:newsletter/up:email/up:to">
            <xsl:apply-templates/>
          </div>
        </code>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="up:email/up:bcc">
    <tr>
      <td><strong>Bcc:</strong></td>
      <td>
        <code>
          <div bxe_xpath="/up:newsletter/up:email/up:bcc">
            <xsl:apply-templates/>
          </div>
        </code>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="up:email/up:subject">
    <tr>
      <td><strong>Subject:&#160;&#160;</strong></td>
      <td>
        <code>
          <div bxe_xpath="/up:newsletter/up:email/up:subject">
            <xsl:apply-templates/>
          </div>
        </code>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="underline">
    <xsl:param name="title"/>
    <xsl:if test="string-length($title) &gt; 0">*<xsl:text/>
      <xsl:call-template name="underline">
        <xsl:with-param name="title" select="substring($title, 2)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="up:footer">
    <code>
      <div bxe_xpath="/up:newsletter/up:footer">
        <xsl:apply-templates/>
      </div>
    </code>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

