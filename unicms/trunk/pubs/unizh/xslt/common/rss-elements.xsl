<?xml version="1.0" encoding="UTF-8"?>


<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
>

  <xsl:param name="contextprefix"/>

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
                    <xsl:attribute name="id">first</xsl:attribute>
                  </xsl:if>
                  <xsl:choose>
                    <xsl:when test="../../../@itemDescription = 'true' or (../../../@itemDescription = 'true' and ../../../@itemImage = 'true')">
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
                      <xsl:if test="../../../@itemImage = 'true' and image and image/url">
                        <a>
                          <xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute>
                          <img>
                            <xsl:attribute name="src"><xsl:value-of select="image/url"/></xsl:attribute>
                            <xsl:attribute name="alt">thumbnail image</xsl:attribute>
                          </img>
                        </a>
                      </xsl:if>
                      <xsl:if test="../../../@itemDescription = 'true'">
                        <xsl:value-of select="description"/>
                      </xsl:if>
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
            <div class="solidline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1" /></div>
            <h2>
              <xsl:value-of select="title"/>&#160;
              <span class="datetime">
                <xsl:variable name="pubDateLength" select="string-length(pubDate)"/>
                <xsl:value-of select="substring(pubDate, 0, $pubDateLength - 12)"/>
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


  <xsl:template match="description">
    <xsl:apply-templates/>
  </xsl:template>


<xsl:template match="@*|node()" priority="-3">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
