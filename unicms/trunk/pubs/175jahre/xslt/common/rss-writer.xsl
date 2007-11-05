<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0"
  xmlns:index="http://apache.org/cocoon/lenya/documentindex/1.0"
  xmlns:lenya="http://apache.org/cocoon/lenya/page-envelope/1.0"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/" 
  xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
  xmlns:uzhfeeds="http://www.uzh.ch/doctypes/rss"
  >

  <xsl:param name="servername" />
  <xsl:param name="serverport" />
  <xsl:param name="contextprefix" />
  <xsl:param name="channelid" />
  <xsl:param name="channelhome" />
  <xsl:param name="channelpath" />

  <xsl:variable name="channelhomepath">
    <xsl:value-of select="concat( 'http://', $servername, ':', $serverport, $contextprefix, $channelid )" />
  </xsl:variable>

  <xsl:template match="unizh:news">
    <rss version="2.0">
      <channel>
        <title><xsl:value-of select="lenya:meta/dc:title" /></title>
        <link><xsl:value-of select="$channelhome" /></link>
        <language><xsl:value-of select="lenya:meta/dc:language" /></language>
        <itunes:subtitle><xsl:value-of select="lenya:meta/dc:subject" /></itunes:subtitle>
        <itunes:author><xsl:value-of select="lenya:meta/dc:publisher" /></itunes:author>
        <itunes:summary><xsl:value-of select="lenya:meta/dc:description" /></itunes:summary>
        <itunes:explicit>no</itunes:explicit>
        <description><xsl:value-of select="lenya:meta/dc:description" /></description>
        <itunes:owner>
          <itunes:name><xsl:value-of select="lenya:meta/dc:rights" /></itunes:name>
        </itunes:owner>
        <xsl:if test="unizh:related-content/descendant::xhtml:object[1]">
          <image>
            <title><xsl:value-of select="lenya:meta/dc:title" /></title>
            <url>
              <xsl:choose>
                <xsl:when test="starts-with( unizh:related-content/descendant::xhtml:object[1]/@data, 'http' )">
                  <xsl:value-of select="unizh:related-content/descendant::xhtml:object[1]/@data" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat( $channelhomepath, '/', unizh:related-content/descendant::xhtml:object[1]/@data )" />
                </xsl:otherwise>
              </xsl:choose>
            </url>
            <width></width>
            <height></height>
            <description></description>
            <link><xsl:value-of select="$channelhome" /></link>
          </image>
          <itunes:image>
            <xsl:attribute name="href">
              <xsl:choose>
                <xsl:when test="starts-with( unizh:related-content/descendant::xhtml:object[1]/@data, 'http' )">
                  <xsl:value-of select="unizh:related-content/descendant::xhtml:object[1]/@data" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat( $channelhomepath, '/', unizh:related-content/descendant::xhtml:object[1]/@data )" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </itunes:image>
        </xsl:if>
        <xsl:for-each select="//index:child">
          <xsl:variable name="fulltext" select="normalize-space(*/unizh:newsitem/xhtml:body/xhtml:p)" />
          <xsl:variable name="link" select="*/unizh:newsitem/unizh:short/xhtml:a" />
          <xsl:variable name="creationdate" select="*/unizh:newsitem/lenya:meta/dcterms:created" />
          <item>
            <title><xsl:value-of select="*/unizh:newsitem/lenya:meta/dc:title" /></title>
            <itunes:author><xsl:value-of select="*/unizh:newsitem/lenya:meta/dc:creator" /></itunes:author>
            <itunes:subtitle><xsl:value-of select="*/unizh:newsitem/xhtml:body/child::xhtml:h2[1]" /></itunes:subtitle>
            <itunes:summary><xsl:apply-templates select="*/unizh:newsitem/unizh:short/xhtml:p" /></itunes:summary>
            <!-- if we find multimedia object, we enclose them, and this feed becomes a podcasts! -->
            <xsl:for-each select="*/unizh:newsitem/descendant::xhtml:object">
              <xsl:variable name="url">
                <xsl:choose>
                  <xsl:when test="@dataPodcast and starts-with( @dataPodcast, 'http' )">
                    <xsl:value-of select="@dataPodcast" />
                  </xsl:when>
                  <xsl:when test="@dataPodcast">
                    <xsl:value-of select="concat( substring-before( ancestor::index:child/@href, '.html' ), '/', @dataPodcast )" />
                  </xsl:when>
                  <xsl:when test="starts-with(@data, 'http')">
                    <xsl:value-of select="@data" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="concat( substring-before( ancestor::index:child/@href, '.html' ),  '/', @data )" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:variable name="suffix">
                <xsl:call-template name="substring-after-last">
                  <xsl:with-param name="input" select="$url" />
                  <xsl:with-param name="substr">.</xsl:with-param>
                </xsl:call-template>
              </xsl:variable>
              <xsl:if test="$suffix = 'mov' or $suffix = 'mp4' or $suffix = 'm4v' or $suffix = 'mp3' or $suffix = 'm4a'">
                <enclosure>
                  <xsl:attribute name="url">
                    <xsl:value-of select="$url" />
                  </xsl:attribute>
                  <xsl:attribute name="length">
                    <xsl:value-of select="@filesize" />
                  </xsl:attribute>
                  <xsl:attribute name="type">
                    <xsl:choose>
                      <xsl:when test="@type != ''">
                        <xsl:value-of select="@type" />
                      </xsl:when>
                      <xsl:when test="$suffix = 'mov'">
                        <xsl:text>video/quicktime</xsl:text>
                      </xsl:when>
                      <xsl:when test="$suffix = 'mp4'">
                        <xsl:text>video/mp4</xsl:text>
                      </xsl:when>
                      <xsl:when test="$suffix = 'm4v'">
                        <xsl:text>video/x-m4v</xsl:text>
                      </xsl:when>
                      <xsl:when test="$suffix = 'mp3'">
                        <xsl:text>audio/mpeg</xsl:text>
                      </xsl:when>
                      <xsl:when test="$suffix = 'm4a'">
                        <xsl:text>audio/x-m4a</xsl:text>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:attribute>
                </enclosure>
              </xsl:if>
            </xsl:for-each>
            <guid><xsl:value-of select="concat( 'http://', $servername, ':', $serverport, $contextprefix, @href )" /></guid>
            <itunes:keywords><xsl:value-of select="*/unizh:newsitem/lenya:meta/dc:description" /></itunes:keywords>
            <link>
              <xsl:choose><!-- BXE keeps paragraph and &#160; as placeholders -->
                <xsl:when test="$link">
                  <xsl:value-of select="$link/@href" />
                </xsl:when>
                <xsl:when test="not( ( $fulltext = '' ) or ( $fulltext = '&#160;' ) )">
                  <xsl:value-of select="concat( 'http://', $servername, ':', $serverport, $contextprefix, @href )" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$channelhome" />
                </xsl:otherwise>
              </xsl:choose> 
            </link>
            <description><xsl:apply-templates select="*/unizh:newsitem/unizh:short/xhtml:p" /></description>
            <xsl:if test="*/unizh:newsitem/unizh:short/descendant::xhtml:object[1]">
              <uzhfeeds:image>
                <uzhfeeds:url>
                  <xsl:choose>
                    <xsl:when test="starts-with( */unizh:newsitem/unizh:short/descendant::xhtml:object[1]/@data, 'http' )">
                      <xsl:value-of select="*/unizh:newsitem/unizh:short/descendant::xhtml:object[1]/@data" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="concat( 'http://', $servername, ':', $serverport, $contextprefix, substring-before( @href, '.html' ), '/', */unizh:newsitem/unizh:short/descendant::xhtml:object[1]/@data )" />
                    </xsl:otherwise>
                  </xsl:choose>
                </uzhfeeds:url>
                <uzhfeeds:width></uzhfeeds:width>
                <uzhfeeds:height></uzhfeeds:height>
                <uzhfeeds:description></uzhfeeds:description>
              </uzhfeeds:image>
            </xsl:if>
            <pubDate>
              <xsl:choose>
                <!-- dd. MMM yyyy HH:mm >> dd MMM yyyy HH:mm -->
                <xsl:when test="string-length( $creationdate ) &lt; '25'">
                  <xsl:value-of select="substring( $creationdate, 1, 2 )" />
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="substring($creationdate, 5)" />
                </xsl:when>
                <!-- EEE MMM dd HH:mm:ss zzz yyyy >> EEE, dd MMM yyy HH:mm:ss zzzz -->
                <xsl:otherwise>
                  <xsl:value-of select="substring($creationdate, 1, 3)" />
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="substring($creationdate, 9, 2)" />
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="substring($creationdate, 5, 3)" />
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="substring($creationdate, 26, 4)" />
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="substring($creationdate, 12, 13)" />
                </xsl:otherwise>
              </xsl:choose>
            </pubDate>
          </item>
        </xsl:for-each>
      </channel>
    </rss>
  </xsl:template>

  <xsl:template match="xhtml:p">
    <xsl:copy-of select="descendant-or-self::text()" />
  </xsl:template>

  <xsl:template name="substring-after-last">
    <xsl:param name="input"/>
    <xsl:param name="substr"/>
    <xsl:variable name="temp" select="substring-after($input, $substr)"/>
    <xsl:choose>
      <xsl:when test="$substr and contains($temp, $substr)">
        <xsl:call-template name="substring-after-last">
          <xsl:with-param name="input" select="$temp"/>
          <xsl:with-param name="substr" select="$substr"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$temp"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>
