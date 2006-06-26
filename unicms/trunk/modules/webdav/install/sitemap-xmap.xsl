<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:map="http://apache.org/cocoon/sitemap/1.0"> 
<xsl:output method="xml" indent="yes"/>

  <xsl:template match="map:match[@pattern='**' and map:act[@type='authorizer']]">
    <xsl:comment>WebDAV: Authentication and branching off to usecase</xsl:comment>
    <map:match pattern="*/webdav">
      <map:redirect-to uri="{{request:requestURI}}/" global="true"/>
    </map:match>
    <map:match pattern="*/webdav/**">
       <map:act type="authenticator">
          <map:act type="authorizer">
            <map:mount uri-prefix="{{page-envelope:publication-id}}" src="{{fallback:usecases/webdav/usecase-webdav.xmap}}" check-reload="true" reload-method="synchron"/>
          </map:act>
          <map:act type="set-header">
            <map:parameter name="WWW-Authenticate" value="Basic Realm=lenya" />
            <map:generate src="lenya/content/util/empty.xml" />
            <map:serialize type="xhtml" status-code="401"/>
          </map:act>
        </map:act>
        <map:act type="set-header">
          <map:parameter name="WWW-Authenticate" value="Basic Realm=lenya" />
          <map:generate src="lenya/content/util/empty.xml" />
          <map:serialize type="xhtml" status-code="401"/>
        </map:act>
    </map:match>
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
