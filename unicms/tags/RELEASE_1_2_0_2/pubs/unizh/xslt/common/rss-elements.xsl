<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: elements.xsl,v 1.79 2005/01/17 09:15:15 thomas Exp $ -->
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
  <xsl:param name="contextprefix"/>
 
  <xsl:variable name="imageprefix" select="concat($contextprefix, '/unizh/authoring/images')"/> 

<!--  <xsl:template match="unizh:rss-reader[parent::unizh:related-content]"> -->
  <xsl:template match="unizh:rss-reader">
    <xsl:variable name="items" select="@items"/>

    <div class="relatedboxborder">
      <div class="relatedboxcont">
         <xsl:choose>
           <xsl:when test="rss/channel">

             <xsl:if test="@image = 'true' and rss/channel/image">
               <xsl:variable name="imageheight">
                 <xsl:choose>
                   <xsl:when test="rss/channel/image/height &lt; 100">
                     <xsl:value-of select="rss/channel/image/height"/>
                   </xsl:when>
                   <xsl:otherwise>64</xsl:otherwise>
                 </xsl:choose>
               </xsl:variable>
               <xsl:variable name="imagewidth">
                 <xsl:choose>
                   <xsl:when test="rss/channel/image/width &lt; 156">
                     <xsl:value-of select="rss/channel/image/width"/>
                   </xsl:when>
                   <xsl:otherwise>100</xsl:otherwise>
                 </xsl:choose>
               </xsl:variable>
               <img src="{rss/channel/image/url}" height="{$imageheight}" width="{$imagewidth}"/><br/>
             </xsl:if>

             <div class="titel"><xsl:value-of select="rss/channel/title"/></div>
             <div class="titel">&#160;</div>
             <div class="dotline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"  /><xsl:comment/></div>
             <xsl:for-each select="rss/channel/item">
               <xsl:if test="$items = '' or position() &lt;= $items">
                 <a class="rss" href="{link}"><xsl:value-of select="title"/></a>
                 <xsl:if test="position() &lt; $items">
                   <div class="dotline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/><xsl:comment/></div>
                 </xsl:if>
               </xsl:if>
             </xsl:for-each>
           </xsl:when>
           <xsl:otherwise>
            no rss 
           </xsl:otherwise>
         </xsl:choose>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="unizh:rss-reader[ancestor::div[@class='content']]">
    <xsl:variable name="items" select="@items"/>
       <h2><xsl:value-of select="rss/channel/title"/></h2>
       <xsl:for-each select="rss/channel/item">
         <xsl:if test="$items = '' or position() &lt;= $items">
           <div class="solidline"><img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1" /></div>
           <h2><xsl:value-of select="title"/>&#160;
           <span class="lead"><xsl:value-of select="pubDate"/></span></h2>
           <p><xsl:apply-templates select="description"/>
           <a class="arrow" href="{link}">Weiter</a><br/>
           </p>
         </xsl:if>
       </xsl:for-each>
       <xsl:if test="not(rss/channel/item)">
         <p> no rss </p>
       </xsl:if>
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
