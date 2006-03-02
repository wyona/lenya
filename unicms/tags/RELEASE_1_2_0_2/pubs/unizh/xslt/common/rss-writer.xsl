<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:index="http://apache.org/cocoon/lenya/documentindex/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/" 
  
  >

  <xsl:param name="servername"/>
  <xsl:param name="serverport"/>
  <xsl:param name="contextprefix"/>
  <xsl:param name="channelid"/>
  <xsl:param name="channelhome"/>
  <xsl:param name="channelpath"/>

  <xsl:variable name="urlprefix" select="concat('http://', $servername, ':', $serverport, $contextprefix)"/> 

  <xsl:variable name="channelHomePath">
   <xsl:value-of select="substring-before($channelhome, '.html')"/>
  </xsl:variable>

  <xsl:variable name="imageprefix">
    <xsl:value-of select="concat($urlprefix, $channelid, '/')"/> 
  </xsl:variable> 

  <xsl:template match="unizh:news">
    <rss version="2.0">
      <channel>
        <title><xsl:value-of select="lenya:meta/dc:title"/></title>
        <link><xsl:value-of select="$channelhome"/></link>
        <description><xsl:value-of select="lenya:meta/dc:description"/></description>
        <xsl:if test="xhtml:body/xhtml:object">
          <image>
            <title></title>
            <url><xsl:value-of select="$imageprefix"/><xsl:value-of select="xhtml:body/xhtml:object/@data"/></url>
            <link></link>
            <width></width>
            <height></height>
            <description>News for web users that write back</description>
          </image>
        </xsl:if>
        <xsl:for-each select="//index:child">
          <item>
            <title><xsl:value-of select="*/unizh:newsitem/lenya:meta/dc:title"/></title>
            <link>
              <xsl:choose><!-- BXE keeps paragraph and &#160; as placeholders -->
                <xsl:when test="*/unizh:newsitem/xhtml:body/xhtml:p != '&#160;'">
                 <xsl:value-of select="concat($channelHomePath, substring-after(@href, $channelpath))"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$channelhome"/>
                </xsl:otherwise>
              </xsl:choose> 
            </link>
            <description><xsl:apply-templates select="*/unizh:newsitem/unizh:short/xhtml:p"/></description>
            <pubDate><xsl:value-of select="*/unizh:newsitem/lenya:meta/dcterms:created"/></pubDate>
          </item>
        </xsl:for-each>
      </channel>
    </rss>
  </xsl:template>

  <xsl:template match="xhtml:p">
    <xsl:copy-of select="*|text()"/>
  </xsl:template>


</xsl:stylesheet>
