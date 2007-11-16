<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
>

  <xsl:param name="contextprefix"/>
  <xsl:param name="document_type" />

  <xsl:variable name="imageprefix" select="concat($contextprefix, '/unizh/authoring/images')"/> 


  <xsl:template match="unizh:rss-reader">
    <xsl:variable name="target">
      <xsl:choose>
        <xsl:when test="@url and starts-with(@url, 'http://') and not(contains(@url, '.unizh.ch')) and not(contains(@url, '.uzh.ch'))">
          <xsl:text>www</xsl:text>
        </xsl:when>
        <xsl:when test="@url and starts-with(@url, 'http://') and ((contains(@url, '.unizh.ch')) or (contains(@url, '.uzh.ch')))">
          <xsl:text>uzh</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>internal</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="$target = 'www'">rssReader www</xsl:when>
          <xsl:when test="$target = 'uzh'">rssReader uzh</xsl:when>
          <xsl:otherwise>rssReader internal</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="rss/channel">
          <h3>
            <xsl:choose>
              <xsl:when test="@link = 'true' and string-length(rss/channel/link)">
                <xsl:attribute name="class">linked</xsl:attribute>
                <a>
                  <xsl:attribute name="href"><xsl:value-of select="rss/channel/link"/></xsl:attribute>
                  <xsl:choose>
                    <xsl:when test="string-length(unizh:title)"><xsl:value-of select="unizh:title"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="rss/channel/title"/></xsl:otherwise>
                  </xsl:choose>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="string-length(unizh:title)"><xsl:value-of select="unizh:title"/></xsl:when>
                  <xsl:otherwise><xsl:value-of select="rss/channel/title"/></xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </h3>
          <ul>
            <xsl:for-each select="rss/channel/item">
              <xsl:variable name="substring1" select="substring(normalize-space(pubDate),1,1)"/>
              <xsl:variable name="substring3" select="substring(normalize-space(pubDate),1,3)"/>
              <xsl:variable name="substring4" select="substring(normalize-space(pubDate),1,4)"/>
              <xsl:variable name="src-pattern">
                <xsl:choose>
                  <xsl:when test="$substring3 = 'Mon' or $substring3 = 'Tue' or $substring3 = 'Wed' or $substring3 = 'Thu' or $substring3 = 'Fri' or $substring3 = 'Sat' or $substring3 = 'Sun'">
                    <xsl:text>EEE, d MMM yyyy HH:mm:ss zzz</xsl:text>
                  </xsl:when>
                  <xsl:when test="number($substring4)"/>
                  <xsl:when test="number($substring1)">
                    <xsl:text>d MMM yyyy HH:mm:ss zzz</xsl:text>
                  </xsl:when>
                  <xsl:otherwise/>
                </xsl:choose>
              </xsl:variable>
              <xsl:if test="../../../@items = '' or position() &lt; = ../../../@items">
                <li>
                  <xsl:if test="position() = 1">
                    <xsl:attribute name="class">first</xsl:attribute>
                  </xsl:if>
                  <xsl:choose>
                    <xsl:when test="../../../@itemDescription = 'true' or (../../../@itemDescription = 'true' and ../../../@itemImage = 'true')">
                      <xsl:if test="../../../@itemImage = 'true' and image">
                        <a>
                          <xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute>
                          <img>
                            <xsl:attribute name="src"><xsl:value-of select="image/url"/></xsl:attribute>
                            <xsl:attribute name="alt"><xsl:value-of select="image/description"/></xsl:attribute>
                          </img>
                        </a>
                      </xsl:if>
                      <h4>
                        <xsl:if test="../../../@itemPubdate = 'true' and pubDate and pubDate != ''">
                          <xsl:choose>
                            <xsl:when test="$src-pattern = ''">
                              <xsl:text>invalid date format</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <i18n:date src-pattern="{$src-pattern}" src-locale="en" pattern="d.M.yyyy: " value="{pubDate}"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                        <xsl:value-of select="title"/>
                      </h4>
                      <xsl:value-of select="description"/>
                      <a>
                        <xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute>
                        <xsl:attribute name="class">block</xsl:attribute>
                        <xsl:text>weiter</xsl:text>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <a>
                        <xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute>
                        <xsl:attribute name="class">block</xsl:attribute>
                        <xsl:if test="../../../@itemPubdate = 'true' and pubDate and pubDate != ''">
                          <xsl:choose>
                            <xsl:when test="$src-pattern = ''">
                              <xsl:text>(invalid date format) </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <i18n:date src-pattern="{$src-pattern}" src-locale="en" pattern="d.M.yyyy: " value="{pubDate}"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                        <xsl:value-of select="title"/>
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </li>
              </xsl:if>
            </xsl:for-each>
          </ul>
        </xsl:when>
        <xsl:otherwise>
          <p>&#160;no rss</p>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>


  <!-- separate display for rss reader in content, but not in columns -->
  <xsl:template match="unizh:rss-reader[ancestor::div[@class='content'] and not(parent::div[@class='column'])]">
    <xsl:variable name="items" select="@items"/>
    <xsl:choose>
      <xsl:when test="rss/channel/item">
        <h2><xsl:value-of select="rss/channel/title"/></h2>
        <xsl:for-each select="rss/channel/item">
          <xsl:if test="$items = '' or position() &lt;= $items">
            <xsl:variable name="substring1" select="substring(normalize-space(pubDate),1,1)"/>
            <xsl:variable name="substring3" select="substring(normalize-space(pubDate),1,3)"/>
            <xsl:variable name="substring4" select="substring(normalize-space(pubDate),1,4)"/>
            <xsl:variable name="src-pattern">
              <xsl:choose>
                <xsl:when test="$substring3 = 'Mon' or $substring3 = 'Tue' or $substring3 = 'Wed' or $substring3 = 'Thu' or $substring3 = 'Fri' or $substring3 = 'Sat' or $substring3 = 'Sun'">
                  <xsl:text>EEE, d MMM yyyy HH:mm:ss zzz</xsl:text>
                </xsl:when>
                <xsl:when test="number($substring4)"/>
                <xsl:when test="number($substring1)">
                  <xsl:text>d MMM yyyy HH:mm:ss zzz</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
              </xsl:choose>
            </xsl:variable>
            <div class="solidline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1" /></div>
            <h2>
              <xsl:value-of select="title"/>
              <xsl:text> </xsl:text>
              <span class="datetime">
                <xsl:if test="pubDate and pubDate != ''">
                  <xsl:choose>
                    <xsl:when test="$src-pattern = ''">
                      <xsl:text>invalid date format</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <i18n:date src-pattern="{$src-pattern}" src-locale="en" pattern="d.M.yyyy: " value="{pubDate}"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>
              </span>
            </h2>
            <p><xsl:apply-templates select="description"/></p>
            <xsl:if test="link != ''">
              <a class="internal" href="{link}"><i18n:text>more</i18n:text></a><br/>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <p>no rss</p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="unizh:rss-reader[$document_type = 'homepage4cols']">
    <xsl:variable name="target">
      <xsl:choose>
        <xsl:when test="@url and starts-with( @url, 'http://' ) and not( contains( @url, '.unizh.ch' ) ) and not( contains( @url, '.uzh.ch' ) )">
          <xsl:text>www</xsl:text>
        </xsl:when>
        <xsl:when test="@url and starts-with( @url, 'http://' ) and ( ( contains( @url, '.unizh.ch' ) ) or ( contains( @url, '.uzh.ch' ) ) )">
          <xsl:text>uzh</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>internal</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="$target = 'www'">rssReader www</xsl:when>
          <xsl:when test="$target = 'uzh'">rssReader uzh</xsl:when>
          <xsl:otherwise>rssReader internal</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="rss/channel">
          <h3>
            <xsl:choose>
              <xsl:when test="@link = 'true' and string-length( rss/channel/link )">
                <xsl:attribute name="class">
                  <xsl:text>linked</xsl:text>
                  <xsl:choose>
                    <xsl:when test="contains( rss/channel/link, 'news' )">
                      <xsl:text> lime</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains( rss/channel/link, 'ueber' )">
                      <xsl:text> cyan</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains( rss/channel/link, 'agenda' )">
                      <xsl:text> amethyst</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains( rss/channel/link, 'veranstaltungen' )">
                      <xsl:text> magenta</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains( rss/channel/link, 'fakultaeten' )">
                      <xsl:text> emerald</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains( rss/channel/link, 'ausstellungen' )">
                      <xsl:text> pumpkin</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains( rss/channel/link, 'blog' )">
                      <xsl:text> marine</xsl:text>
                    </xsl:when>
                  </xsl:choose>
                </xsl:attribute>
                <a>
                  <xsl:attribute name="href"><xsl:value-of select="rss/channel/link"/></xsl:attribute>
                  <xsl:choose>
                    <xsl:when test="string-length( unizh:title )"><xsl:value-of select="unizh:title"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="rss/channel/title"/></xsl:otherwise>
                  </xsl:choose>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="contains( rss/channel/link, 'news' )">
                      <xsl:text>lime</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains( rss/channel/link, 'ueber' )">
                      <xsl:text>cyan</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains( rss/channel/link, 'agenda' )">
                      <xsl:text>amethyst</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains( rss/channel/link, 'veranstaltungen' )">
                      <xsl:text>magenta</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains( rss/channel/link, 'fakultaeten' )">
                      <xsl:text>emerald</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains( rss/channel/link, 'ausstellungen' )">
                      <xsl:text>pumpkin</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains( rss/channel/link, 'blog' )">
                      <xsl:text>marine</xsl:text>
                    </xsl:when>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="string-length( unizh:title )"><xsl:value-of select="unizh:title"/></xsl:when>
                  <xsl:otherwise><xsl:value-of select="rss/channel/title"/></xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </h3>
          <ul>
            <xsl:if test="rss/channel/item[1]">
              <xsl:variable name="substring1" select="substring( normalize-space( rss/channel/item[1]/pubDate ), 1, 1 )"/>
              <xsl:variable name="substring3" select="substring( normalize-space( rss/channel/item[1]/pubDate ), 1, 3 )"/>
              <xsl:variable name="substring4" select="substring( normalize-space( rss/channel/item[1]/pubDate ), 1, 4 )"/>
              <xsl:variable name="src-pattern">
                <xsl:choose>
                  <xsl:when test="$substring3 = 'Mon' or $substring3 = 'Tue' or $substring3 = 'Wed' or $substring3 = 'Thu' or $substring3 = 'Fri' or $substring3 = 'Sat' or $substring3 = 'Sun'">
                    <xsl:text>EEE, d MMM yyyy HH:mm:ss zzz</xsl:text>
                  </xsl:when>
                  <xsl:when test="number( $substring4 )"/>
                  <xsl:when test="number( $substring1 )">
                    <xsl:text>d MMM yyyy HH:mm:ss zzz</xsl:text>
                  </xsl:when>
                  <xsl:otherwise/>
                </xsl:choose>
              </xsl:variable>
              <li>
                <xsl:attribute name="class">first</xsl:attribute>
                <a>
                  <xsl:attribute name="href"><xsl:value-of select="rss/channel/item[1]/link"/></xsl:attribute>
                  <xsl:attribute name="class">block</xsl:attribute>
                  <xsl:if test="@itemPubdate = 'true' and rss/channel/item[1]/pubDate and rss/channel/item[1]/pubDate != ''">
                    <xsl:choose>
                      <xsl:when test="$src-pattern = ''">
                        <xsl:text>(invalid date format) </xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <i18n:date src-pattern="{$src-pattern}" src-locale="en" pattern="d.M.yyyy: " value="{rss/channel/item[1]/pubDate}"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:if>
                  <xsl:value-of select="rss/channel/item[1]/title" />
                </a>
              </li>
            </xsl:if>
          </ul>
        </xsl:when>
        <xsl:otherwise>
          <p>&#160;no rss</p>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>


  <xsl:template match="description">
    <xsl:apply-templates/>
  </xsl:template>


<xsl:template match="@*|node()" priority="-3">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
