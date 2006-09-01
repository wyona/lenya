<?xml version="1.0" encoding="UTF-8" ?>


<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" xmlns:uz="http://unizh.ch"
    xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
    >
    
  <xsl:param name="rendertype"/>

  <xsl:variable name="content" select="/document/content/*"/>
  
  <xsl:variable name="document-element-name">
    <xsl:choose>
      <xsl:when test="name($content) = local-name($content)">
        <xsl:value-of select="concat('xhtml:', name($content))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="name($content)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template name="compute-path">
    <xsl:if test="not(self::document | self::content)">
      <xsl:text>/</xsl:text>
      <xsl:text>*</xsl:text>
      <!-- FIXME: there is a less hackish way to do this -->
      <xsl:if test="name() != 'html' and name() != 'xhtml:html'">
        <xsl:text>[</xsl:text>
        <!--       <xsl:value-of select="1+count(preceding-sibling::*[name(current()) = name()])"/> -->
        <xsl:value-of select="1+count(preceding-sibling::*)"/>
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:template>


  <xsl:template name="asset-dot">
    <xsl:param name="insertReplace" select="false"/>
    <xsl:param name="insertWhere" select="after"/>
    <xsl:param name="insertWhat"/>

    <xsl:variable name="trimmedElementPath">
      <xsl:for-each select="(ancestor-or-self::*)">
        <xsl:call-template name="compute-path"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$insertWhat = 'identity'">
        <lenya:asset-dot class="image" href="?lenya.usecase=asset&amp;lenya.step=showscreen&amp;insert=true&amp;insertimage=true&amp;assetXPath={$trimmedElementPath}&amp;insertWhere={$insertWhere}&amp;insertTemplate=insertIdentity.xml&amp;insertReplace=true"/>
      </xsl:when>
      <xsl:when test="$insertWhat = 'image'">
        <lenya:asset-dot class="image" href="?lenya.usecase=asset&amp;lenya.step=showscreen&amp;insert=true&amp;insertimage=true&amp;assetXPath={$trimmedElementPath}&amp;insertWhere={$insertWhere}&amp;insertTemplate=insertImg.xml&amp;insertReplace={$insertReplace}"/> 
      </xsl:when>
      <xsl:when test="$insertWhat = 'floatImage'"> <!-- FIXME: change usecase instead -->
         <lenya:asset-dot class="floatImage" href="?lenya.usecase=asset&amp;lenya.step=showscreen&amp;insert=true&amp;insertimage=true&amp;assetXPath={$trimmedElementPath}&amp;insertWhere={$insertWhere}&amp;insertTemplate=insertFloatImg.xml&amp;insertReplace={$insertReplace}"/>
      </xsl:when>
      <xsl:otherwise>
        <lenya:asset-dot class="asset" href="?lenya.usecase=asset&amp;lenya.step=showscreen&amp;insert=true&amp;insertimage=false&amp;assetXPath={$trimmedElementPath}&amp;insertWhere={$insertWhere}&amp;insertTemplate=insertAsset.xml&amp;insertReplace={$insertReplace}"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="xhtml:p[parent::xhtml:body and $rendertype = 'imageupload']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:if test="not(preceding-sibling::*[1][local-name() = 'object' and @float = 'true'])">
        <xsl:call-template name="asset-dot">
          <xsl:with-param name="insertWhat">image</xsl:with-param>
          <xsl:with-param name="insertWhere">after</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="asset-dot">
          <xsl:with-param name="insertWhat">floatImage</xsl:with-param>
          <xsl:with-param name="insertWhere">before</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="not(following-sibling::*[1][name() = 'lenya:asset'])">
        <xsl:call-template name="asset-dot">
          <xsl:with-param name="insertWhat">asset</xsl:with-param>
          <xsl:with-param name="insertWhere">after</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="xhtml:p[ancestor::unizh:news and parent::xhtml:body and $rendertype = 'imageupload'][1]">
    <xsl:copy>
      <xsl:if test="not(preceding-sibling::xhtml:object)">
        <xsl:call-template name="asset-dot">
          <xsl:with-param name="insertWhat">floatImage</xsl:with-param>
          <xsl:with-param name="insertWhere">before</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="xhtml:p[parent::unizh:short and $rendertype = 'imageupload']">
    <xsl:copy>
      <xsl:if test="not(preceding-sibling::xhtml:object)">
        <xsl:call-template name="asset-dot">
          <xsl:with-param name="insertWhat">floatImage</xsl:with-param>
          <xsl:with-param name="insertWhere">before</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="xhtml:object[$rendertype = 'imageupload']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:choose>
        <xsl:when test="@float = 'true'">
          <xsl:call-template name="asset-dot">
            <xsl:with-param name="insertWhat">floatImage</xsl:with-param>
            <xsl:with-param name="insertReplace">true</xsl:with-param>
            <xsl:with-param name="insertWhere">before</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="asset-dot">
            <xsl:with-param name="insertWhat">image</xsl:with-param>
            <xsl:with-param name="insertReplace">true</xsl:with-param>
            <xsl:with-param name="insertWhere">after</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="lenya:asset[$rendertype = 'imageupload']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:call-template name="asset-dot">
        <xsl:with-param name="insertWhat">asset</xsl:with-param>
        <xsl:with-param name="insertReplace">true</xsl:with-param>
        <xsl:with-param name="insertWhere">after</xsl:with-param>
      </xsl:call-template>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="lenya:asset[parent::xhtml:body and $rendertype = 'imageupload']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:call-template name="asset-dot">
        <xsl:with-param name="insertWhat">asset</xsl:with-param>
        <xsl:with-param name="insertReplace">true</xsl:with-param>
        <xsl:with-param name="insertWhere">after</xsl:with-param>
      </xsl:call-template>
      <xsl:if test="not(following-sibling::*[1][name() = 'lenya:asset'])">
        <xsl:call-template name="asset-dot">
          <xsl:with-param name="insertWhat">asset</xsl:with-param>
          <xsl:with-param name="insertWhere">after</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="unizh:title[parent::unizh:teaser and $rendertype = 'imageupload']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:if test="not(preceding-sibling::xhtml:object)"> 
        <xsl:call-template name="asset-dot">
          <xsl:with-param name="insertWhat">image</xsl:with-param>
          <xsl:with-param name="insertWhere">before</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="unizh:title[parent::unizh:links and $rendertype = 'imageupload']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:if test="not(following-sibling::xhtml:object)">
        <xsl:call-template name="asset-dot">
          <xsl:with-param name="insertWhat">image</xsl:with-param>
          <xsl:with-param name="insertWhere">after</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="unizh:contcol1[not(unizh:quicklinks) and not(xhtml:object) and $rendertype = 'imageupload']">
    <xsl:copy>    
      <xsl:apply-templates select="@*|node()"/>
      <xsl:call-template name="asset-dot">
        <xsl:with-param name="insertWhat">image</xsl:with-param>
        <xsl:with-param name="insertWhere">inside</xsl:with-param>
      </xsl:call-template> 
    </xsl:copy>
  </xsl:template>


  <xsl:template match="unizh:teaser[$rendertype = 'imageupload']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:call-template name="asset-dot">
        <xsl:with-param name="insertWhat">asset</xsl:with-param>
        <xsl:with-param name="insertWhere">inside</xsl:with-param>
      </xsl:call-template>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="xhtml:p[parent::unizh:lead and $rendertype = 'imageupload']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:if test="not(preceding-sibling::xhtml:object)">
        <xsl:call-template name="asset-dot">
          <xsl:with-param name="insertWhat">image</xsl:with-param>
          <xsl:with-param name="insertWhere">before</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="xhtml:td[$rendertype = 'imageupload']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:if test=". = '' or . = '&#160;'">
         <xsl:call-template name="asset-dot">
          <xsl:with-param name="insertWhat">image</xsl:with-param>
          <xsl:with-param name="insertWhere">inside</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
