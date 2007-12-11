<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:uz="http://unizh.ch"
  >


  <xsl:param name="contextprefix"/>
  <xsl:param name="area"/>
  <xsl:param name="rendertype"/>
  <xsl:param name="defaultlanguage"/>
  <xsl:param name="language"/>
  <xsl:param name="nodeid"/>
  <xsl:param name="fontsize"/>
  <xsl:param name="querystring"/>
  <xsl:param name="servername"/>
  <xsl:param name="proxy-url-live"/>

  <xsl:include href="../doctypes/variables.xsl"/>
  <xsl:include href="../common/html-head.xsl"/>
  <xsl:include href="../common/header.xsl"/>
  <xsl:include href="../common/footer.xsl"/>
  <xsl:include href="../common/navigation.xsl"/>
  <xsl:include href="../common/elements.xsl"/> 
  <xsl:include href="../common/object.xsl"/> 

  <xsl:variable name="temp" select="substring-after($servername, 'http://')"/>
  <xsl:variable name="hostname" select="substring-before($temp, '/index.html')"/>


  <xsl:template match="document">
    <xsl:apply-templates select="content"/>
  </xsl:template>


  <xsl:template match="content"> 
    <html>
      <xsl:call-template name="html-head"/>
      <body>
        <div class="bodywidth">
          <a accesskey="1" title="Zur Navigation springen" href="#navigation" />
          <a accesskey="2" title="Zum Inhalt springen" href="#content" />
          <a name="top" />
          <xsl:call-template name="header" />
          <xsl:choose>
            <xsl:when test="*/unizh:contcol1/*">
              <div id="col1">
                <xsl:apply-templates select="*/unizh:contcol1/*" />
              </div>
            </xsl:when>
            <xsl:otherwise>
              <div id="col1">
                <xsl:comment />
              </div>
            </xsl:otherwise>
          </xsl:choose>
          <div class="contcol2">
            <a accesskey="2" name="content"><xsl:comment /></a>
            <xsl:if test="string-length(/document/content/*/lenya:meta/dc:title) &gt; 0">
              <h1><xsl:value-of select="/document/content/*/lenya:meta/dc:title" /></h1>
            </xsl:if>
            <xsl:apply-templates select="/document/xhtml:form[@id = 'search']"/>
            <xsl:apply-templates select="/document/xhtml:div[@id = 'exception']"/>
            <xsl:apply-templates select="/document/xhtml:div[@id = 'results']"/>
            <xsl:apply-templates select="/document/xhtml:div[@id = 'pages']"/>
          </div>
          <xsl:call-template name="footer"/>
        </div>
      </body>
    </html>
  </xsl:template>


  <xsl:template match="xhtml:form[@id = 'search']">
    <div class="searchtextblock">
      <form id="searchbox_009347054195260226203:hahgnjx1tks" action="{$proxy-url-live}" accept-charset="UTF-8">
        <input type="hidden" name="cx" value="009347054195260226203:hahgnjx1tks" />
        <input name="q" type="text" size="40"/>
        <input type="submit" name="sa" value="Search" />
        <input type="hidden" name="cof" value="FORID:11" /><br />
        <input id="custom" name="sitesearch" value="{$hostname}" checked="true" type="radio"/><label for="custom"><xsl:value-of select="$hostname"/></label>
        <input id="custom" name="sitesearch" value="*.uzh.ch" type="radio"/><label for="custom"> UZH Search</label>
      </form>
      <script type="text/javascript" src="http://www.google.com/coop/cse/brand?form=searchbox_009347054195260226203%3Ahahgnjx1tks"></script>
      <a href="http://www.google.com" target="_blank"><img src="{$imageprefix}/poweredby_FFFFFF.gif" align="right"/></a>
    </div>

    <!-- Google Search Result Snippet Begins -->
    <div id="results_009347054195260226203:hahgnjx1tks"><xsl:comment /></div>
      <script type="text/javascript">
         var googleSearchIframeName = "results_009347054195260226203:hahgnjx1tks";
         var googleSearchFormName = "searchbox_009347054195260226203:hahgnjx1tks";
         var googleSearchFrameWidth = 596;
         var googleSearchFrameborder = 0;
         var googleSearchDomain = "www.google.com";
         var googleSearchPath = "/cse";
      </script>
      <script type="text/javascript" src="http://www.google.com/afsonline/show_afs_search.js"></script>
    <!-- Google Search Result Snippet Ends -->

  </xsl:template>


  <xsl:template match="xhtml:div[@id = 'exception']">
    <xsl:value-of select="."/>
  </xsl:template>


  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template> 
  
</xsl:stylesheet>
