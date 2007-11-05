<?xml version="1.0" encoding="ISO-8859-1" ?>

<!-- $Id: includeAssetMetaData.xsl,v 1.4 2004/06/23 16:07:25 edith Exp $ -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0" 
  xmlns:map="http://lenya.apache.org/sitemap/"
  >

  <xsl:param name="basePath"/>

  <xsl:template match="/">
    <map:assets>
      <xsl:for-each select="descendant::dir:file">

        <xsl:variable name="path">
          <xsl:for-each select="ancestor::dir:directory[parent::dir:directory]">
            <xsl:value-of select="concat('/', @name)"/>
          </xsl:for-each>
        </xsl:variable>

        <xsl:if test="substring(@name, (string-length(@name) - 4)) != '.meta'">
          <map:asset name="{@name}" path="{concat($path, '/', @name)}" refID="{$path}">
            <cinclude:includexml ignoreErrors="true">
              <cinclude:src><xsl:value-of select="concat($basePath, $path, '/' , @name, '.meta')"/></cinclude:src>
            </cinclude:includexml>
          </map:asset>
        </xsl:if>
      </xsl:for-each>
    </map:assets>
  </xsl:template>
  

</xsl:stylesheet>
