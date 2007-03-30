<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: elements.xsl,v 1.79 2005/01/17 09:15:15 thomas Exp $ -->

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:dt="http://xsltsl.org/date-time"
>

  <xsl:import href="http://xsltsl.sourceforge.net/modules/stdlib.xsl"/>

  <xsl:include href="../../../unizh/xslt/common/rss-elements.xsl"/>


<!-- overwrite included templates -->

  <xsl:template match="unizh:rss-reader" priority="1">
    <xsl:variable name="target">
      <xsl:choose>
        <xsl:when test="@url and starts-with(@url, 'http://') and not(contains(@url, '.uzh.ch'))">external</xsl:when>
        <xsl:otherwise>internal</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="$target = internal">rssReader internal</xsl:when>
          <xsl:otherwise>rssReader</xsl:otherwise>
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
              <xsl:if test="../../../@items = '' or position() &lt; = ../../../@items">
                <li>
                  <xsl:if test="position() = 1">
                    <xsl:attribute name="id">first</xsl:attribute>
                  </xsl:if>
                  <xsl:choose>
                    <xsl:when test="../../../@itemDescription = 'true' or (../../../@itemDescription = 'true' and ../../../@itemImage = 'true')">
                      <h4><xsl:value-of select="title"/></h4>
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
                        <xsl:if test="../../../@itemPubdate = 'true' and pubDate">
                          <xsl:call-template name="dt:format-date-time">
                            <xsl:with-param name="year"><xsl:value-of select="substring(pubDate, 1, 4)"/></xsl:with-param>
                            <xsl:with-param name="month"><xsl:value-of select="substring(pubDate, 6, 2)"/></xsl:with-param>
                            <xsl:with-param name="day"><xsl:value-of select="substring(pubDate, 9, 2)"/></xsl:with-param>
                            <xsl:with-param name="format">%Y.%n.%e</xsl:with-param>
                          </xsl:call-template>:
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
          no rss
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

</xsl:stylesheet>
