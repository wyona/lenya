<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: header.xsl,v 1.40 2005/03/09 11:11:13 peter Exp $ -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:unizh="http://unizh.ch/doctypes/elements/1.0" 
>
                


  <xsl:template name="header">

    <div id="headerarea">
      <div style="float:right;width:195px;">
        <div class="imgunilogo">
          <a href="http://www.uzh.ch">
            <img src="{$localsharedresources}/images/logo_{$language}.gif" alt="unizh logo" width="180" height="45" />
          </a>
        </div>
        <div class="imginstitute">
          <img src="{$localsharedresources}/images/key-visual.jpg" alt="institute's picture" width="180" height="45" />
        </div>
      </div>
      <div id="headertitelpos">
        <br/>
        <br/>
        <h2>
          <xsl:value-of select="$header_superscription"/>&#160; 
        </h2>
        <h1>
          <a href="#">
            <xsl:value-of select="$header_heading"/> 
          </a>
        </h1>
      </div>
    </div>
    <div class="floatclear"><xsl:comment/></div>
    <div id="primarnav">&#160;</div>
    <div class="floatclear"><xsl:comment/></div>
    <div class="endheaderline">
      <img src="{$imageprefix}/1.gif" alt="separation line" width="1" height="1"/>
    </div>

  </xsl:template>

</xsl:stylesheet>


