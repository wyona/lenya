<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:map="http://apache.org/cocoon/sitemap/1.0"> 
<xsl:output method="xml" indent="yes"/>

  <!-- <xsl:template match="map:pipeline[map:match[@pattern='*/**.html']]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <map:match pattern="webdav/**">
        <map:mount uri-prefix="" src="lenya/usecases/webdav/usecase-webdav.xmap" check-reload="true" reload-method="synchron"/>
      </map:match>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template> -->

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
