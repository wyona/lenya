<?xml version="1.0" encoding="utf-8"?>

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
   xmlns:index="http://apache.org/cocoon/lenya/documentindex/1.0"
     xmlns:level="http://apache.org/cocoon/lenya/documentlevel/1.0"
      xmlns:tal="http://xml.zope.org/namespaces/tal"
      lenya:dummy="bar"
      xhtml:dummy="bar"
      dc:dummy="bar"
      dcterms:dummy="bar"
      unizh:dummy="bar"
      uz:dummy="bar"
      index:dummy="bar"
      level:dummy="bar"
      i18n:dummy="bar"
      tal:dummy="foo"
>


  <xsl:param name="root" />
  <xsl:param name="contextprefix" />
  <xsl:param name="area" />
  <xsl:param name="rendertype" />
  <xsl:param name="defaultlanguage" />
  <xsl:param name="language" />
  <xsl:param name="nodeid" />
  <xsl:param name="fontsize" />
  <xsl:param name="querystring" />
  <xsl:param name="creationdate" />

  <xsl:include href="variables.xsl" />
  <xsl:include href="../common/html-head.xsl" />
  <xsl:include href="../common/header.xsl" />
  <xsl:include href="../common/footer.xsl" />
  <xsl:include href="../common/navigation.xsl" />
  <xsl:include href="../common/elements.xsl" /> 
  <xsl:include href="../common/object.xsl" /> 
  <xsl:include href="../common/layout-template.xsl" /> 


  <xsl:template match="document">
    <xsl:apply-templates select="content" />
  </xsl:template> 


  <xsl:template match="content"> 
    <html>
      <xsl:call-template name="html-head" />
      <body>
        <div class="bodywidth">
          <a accesskey="1" title="Zur Navigation springen" href="#navigation" />
          <a accesskey="2" title="Zum Inhalt springen" href="#content" />
          <a name="top" />
          <xsl:call-template name="header" />
          <xsl:choose>
            <xsl:when test="$document-element-name='xhtml:html'">
              <xsl:choose>
                <xsl:when test="xhtml:html[@unizh:columns = '1']">
                  <xsl:call-template name="one-column" />
                </xsl:when>
                <xsl:when test="xhtml:html[@unizh:columns = '2']">
                  <xsl:call-template name="two-columns" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="three-columns" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="$document-element-name = 'unizh:homepage4cols'">
              <xsl:call-template name="homepage4columns" />
            </xsl:when>
            <xsl:when test="$document-element-name = 'unizh:overview'">
              <xsl:call-template name="overview" />
            </xsl:when>
            <xsl:when test="$document-element-name = 'unizh:project'">
              <xsl:choose>
                <xsl:when test="xhtml:html[@unizh:columns = '1']">
                  <xsl:call-template name="one-column" />
                </xsl:when>
                <xsl:when test="xhtml:html[@unizh:columns = '2']">
                  <xsl:call-template name="two-columns" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="three-columns" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="$document-element-name = 'unizh:project4cols'">
              <xsl:call-template name="overview" />
            </xsl:when>
            <xsl:when test="$document-element-name = 'unizh:news'">
              <xsl:call-template name="three-columns" />
            </xsl:when>
            <xsl:when test="$document-element-name = 'unizh:newsitem'">
              <xsl:call-template name="newsitem" />
            </xsl:when> 
            <xsl:when test="$document-element-name = 'unizh:team'">
              <xsl:call-template name="three-columns" />
            </xsl:when>
            <xsl:when test="$document-element-name = 'unizh:person'">
              <xsl:call-template name="person" />
            </xsl:when>
                <xsl:when test="$document-element-name = 'unizh:redirect'">
              <xsl:call-template name="redirect" />
            </xsl:when>
            <xsl:otherwise />
          </xsl:choose>
          <xsl:call-template name="footer" />
        </div>
      </body>
    </html>
  </xsl:template>


  <xsl:template name="one-column">
    <a accesskey="2" name="content"><xsl:comment /></a>
    <div class="contentarea1col">
      <xsl:if test="string-length(/document/content/*/lenya:meta/dc:title) &gt; 0">
        <h1><xsl:value-of select="/document/content/*/lenya:meta/dc:title" /></h1>
      </xsl:if>
      <xsl:apply-templates select="*/xhtml:body/*" />
    </div>
  </xsl:template>


  <xsl:template name="two-columns">
    <xsl:choose>
      <xsl:when test="/document/xhtml:div[@id = 'menu']/*">
        <div id="col1">
          <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']" />
        </div>
      </xsl:when>
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
      <xsl:apply-templates select="*/xhtml:body/*" />
    </div>
  </xsl:template>


  <xsl:template name="three-columns">
    <xsl:choose>
      <xsl:when test="/document/xhtml:div[@id = 'menu']/*">
        <div id="col1">
          <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']" />
        </div>
      </xsl:when>
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
      <div class="relatedbox">
        <xsl:apply-templates select="*/unizh:related-content" /><xsl:comment/>
      </div>
      <div class="contentarea">
        <a accesskey="2" name="content"><xsl:comment /></a>
        <xsl:if test="string-length(/document/content/*/lenya:meta/dc:title) &gt; 0">
          <h1><xsl:value-of select="/document/content/*/lenya:meta/dc:title" /></h1>
        </xsl:if>
        <xsl:apply-templates select="*/xhtml:body/*" />
      </div>
    </div>
  </xsl:template>


  <xsl:template name="overview">
    <xsl:choose>
      <xsl:when test="$hideChildren = 'false' and /document/xhtml:div[@id = 'menu']/*">
        <div id="col1">
          <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']" />
        </div>
      </xsl:when>
      <xsl:when test="( $numColumns + $numDoubles ) = 2">
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
      </xsl:when>
    </xsl:choose>
    <div>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="$hideChildren = 'true' and ( $numColumns + $numDoubles ) &gt; 2">contcol2 wide</xsl:when>
          <xsl:otherwise>contcol2</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="( $hideChildren = 'false' and ( $numColumns + $numDoubles ) &lt; 3 ) or ( $hideChildren = 'true' and ( $numColumns + $numDoubles ) &lt; 4 )">
        <div class="relatedbox">
          <xsl:apply-templates select="*/unizh:related-content" />
          <xsl:comment/>
        </div>
      </xsl:if>
      <a accesskey="2" name="content"><xsl:comment /></a>
      <div>
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="( $hideChildren = 'false' and ( $numColumns + $numDoubles ) &lt; 3 ) or ( $hideChildren = 'true' and ( $numColumns + $numDoubles ) &lt; 4 )">contentarea</xsl:when>
            <xsl:otherwise>contentarea wide</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:if test="string-length(/document/content/*/lenya:meta/dc:title) &gt; 0">
          <h1><xsl:value-of select="/document/content/*/lenya:meta/dc:title" /></h1>
        </xsl:if>
        <xsl:apply-templates select="/document/content/*/xhtml:body/unizh:lead"/>
        <xsl:apply-templates select="/document/content/*/xhtml:body/unizh:column[1]" />
        <xsl:apply-templates select="/document/content/*/xhtml:body/unizh:column[2]" />
        <xsl:if test="$hideChildren = 'true' or $numDoubles = 0">
          <xsl:apply-templates select="/document/content/*/xhtml:body/unizh:column[3]" />
        </xsl:if>
        <xsl:if test="$hideChildren = 'true' and $numDoubles = 0">
          <xsl:apply-templates select="/document/content/*/xhtml:body/unizh:column[4]" />
        </xsl:if>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="homepage4columns">
    <div class="contcol2 wide">
      <a accesskey="2" name="content"><xsl:comment /></a>
      <div class="contentarea wide">
        <xsl:if test="string-length(/document/content/*/lenya:meta/dc:title) &gt; 0">
          <h1><xsl:value-of select="/document/content/*/lenya:meta/dc:title" /></h1>
        </xsl:if>
        <xsl:apply-templates select="/document/content/*/xhtml:body/unizh:column[1]" />
        <xsl:apply-templates select="/document/content/*/xhtml:body/unizh:column[2]" />
        <xsl:apply-templates select="/document/content/*/xhtml:body/unizh:column[3]" />
        <xsl:apply-templates select="/document/content/*/xhtml:body/unizh:column[4]" />
      </div>
    </div>
    <xsl:apply-templates select="/document/content/*/unizh:partner" />
  </xsl:template>


  <xsl:template name="newsitem">
    <xsl:choose>
      <xsl:when test="/document/xhtml:div[@id = 'menu']/*">
        <div id="col1">
          <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']" />
        </div>
      </xsl:when>
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
      <div class="relatedbox">
        <xsl:apply-templates select="*/unizh:related-content" /><xsl:comment/>
      </div>
      <div class="contentarea">
        <a accesskey="2" name="content"><xsl:comment /></a>
        <div class="datetime">
           <!-- FIXME: just a temporary solution because different time stamps exist for newsitem documents -->
           <xsl:choose>
             <xsl:when test="string-length($creationdate) &lt; '25'">
               <i18n:date pattern="EEE, d. MMM yyyy HH:mm" src-locale="en" src-pattern="d. MMM yyyy HH:mm" value="{$creationdate}" /> 
             </xsl:when>
             <xsl:otherwise>
               <i18n:date pattern="EEE, d. MMM yyyy HH:mm" src-locale="en" src-pattern="EEE MMM d HH:mm:ss zzz yyyy" value="{$creationdate}" />
             </xsl:otherwise>
           </xsl:choose>
        </div>
        <xsl:if test="string-length(/document/content/*/lenya:meta/dc:title) &gt; 0">
          <h1><xsl:value-of select="/document/content/*/lenya:meta/dc:title" /></h1>
        </xsl:if>
        <xsl:variable name="creator" select="unizh:newsitem/lenya:meta/dc:creator" />
        <xsl:choose>
          <xsl:when test="$creator = ''" />
          <xsl:otherwise>
            <h3><xsl:value-of select="$creator" /></h3>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$area = 'authoring'">
          <xsl:apply-templates select="unizh:newsitem/unizh:short/xhtml:p" />
          <xsl:variable name="fulltext" select="normalize-space(unizh:newsitem/xhtml:body/xhtml:p)" />
          <xsl:if test="(unizh:newsitem/unizh:short/xhtml:a) and not(($fulltext = '') or ($fulltext = '&#160;'))">
            <h3> <i18n:text>error_newsitem</i18n:text> </h3>
            <br/>
          </xsl:if>
        </xsl:if>
        <xsl:apply-templates select="*/xhtml:body/*" />
      </div>
    </div>
  </xsl:template>


  <xsl:template name="person">
    <xsl:choose>
      <xsl:when test="/document/xhtml:div[@id = 'menu']/*">
        <div id="col1">
          <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']" />
        </div>
      </xsl:when>
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
      <div class="contentarea">
        <a accesskey="2" name="content"><xsl:comment /></a>
        <p>
          <xsl:apply-templates select="/document/xhtml:div[@id = 'link-to-parent']" />
        </p>
        <div class="solidline">
          <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1" />
        </div>
        <div class="teamBlock">
          <div class="teamImg">
            <xsl:apply-templates select="unizh:person/xhtml:object" />
          </div>
          <div class="teamText">
            <p>
              <b>
                <span>
                  <xsl:if test="unizh:person/unizh:academictitle !=''">
                    <xsl:value-of select="unizh:person/unizh:academictitle" />&#160;
                  </xsl:if>
                </span>
                <span>
                  <xsl:value-of select="unizh:person/unizh:firstname" />&#160;
                </span>
                <span>
                  <xsl:value-of select="unizh:person/unizh:lastname" />
                </span>
              </b>
              <br/>
              <span>
                <xsl:value-of select="unizh:person/unizh:position" />
              </span>
              <br/>
              Tel.: 
              <span>
                <xsl:value-of select="unizh:person/unizh:phone" />
              </span>
              <br/>
              <span>
                <xsl:if test="unizh:person/unizh:email !=''">
                  <xsl:text>Mail: </xsl:text>
                  <a>
                    <xsl:attribute name="href">
                      <xsl:text>mailto:</xsl:text>
                      <xsl:value-of select="unizh:person/unizh:email" />
                    </xsl:attribute>
                    <xsl:attribute name="class">internal</xsl:attribute>
                    <xsl:value-of select="unizh:person/unizh:email" />
                  </a>
                </xsl:if>
              </span>
              <br/>
              <span>
                <xsl:if test="unizh:person/unizh:homepage and (unizh:person/unizh:homepage !='')">
                  <xsl:variable name="href" select="unizh:person/unizh:homepage" />
                  <a>
                    <xsl:attribute name="class">
                      <xsl:choose>
                        <xsl:when test="(starts-with($href, 'http://') or starts-with($href, 'https://')) and not(contains($href, '.unizh.ch')) and not(contains($href, '.uzh.ch'))">
                          <xsl:text>www</xsl:text>
                        </xsl:when>
                        <xsl:when test="(starts-with($href, 'http://') or starts-with($href, 'https://')) and ((contains($href, '.unizh.ch')) or (contains($href, '.uzh.ch')))">
                          <xsl:text>uzh</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text>internal</xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                      <xsl:value-of select="$href" />
                    </xsl:attribute>
                    <xsl:value-of select="$href" />
                  </a>
                </xsl:if>
              </span>
            </p>
          </div>
          <div class="floatleftclear"><xsl:comment/></div>
        </div>
        <div class="solidline">
          <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1" />
        </div>
        <xsl:apply-templates select="unizh:person/unizh:description" />
      </div>
    </div>
  </xsl:template>

  <xsl:template match="unizh:description[parent::unizh:person]">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template name="redirect">
    <div id="col1">
      <xsl:apply-templates select="/document/xhtml:div[@id = 'menu']" />
      <xsl:comment/>
    </div>
    <div class="contcol2">
      <div class="contentarea">
        <xsl:if test="string-length(/document/content/*/lenya:meta/dc:title) &gt; 0">
          <h1><xsl:value-of select="/document/content/*/lenya:meta/dc:title" /></h1>
        </xsl:if>
        <xsl:apply-templates select="*/xhtml:body/*" />
      </div>
    </div>
  </xsl:template>


  <xsl:template match="unizh:column[1]">
    <div id="c1">
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="@double = 'true'">column double</xsl:when>
          <xsl:otherwise>column</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="unizh:column[2]">
    <div class="column" id="c2">
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="unizh:column[3]">
    <div class="column" id="c3">
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="unizh:column[4]">
    <div class="column" id="c4">
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="@*|node()" priority="-1">
    <xsl:element name="{local-name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="@*|node()" />
    </xsl:element>
  </xsl:template> 
  
</xsl:stylesheet>
