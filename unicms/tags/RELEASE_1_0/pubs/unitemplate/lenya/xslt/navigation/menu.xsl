<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: menu.xsl,v 1.5 2005/02/24 15:29:24 jann Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="nav"
    >
   
<xsl:import href="../../../../../xslt/navigation/menu.xsl"/>
    

<xsl:template match="nav:site">
  <div id="menu">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <xsl:apply-templates select="nav:node"/>
    </table>
  </div>
</xsl:template>

<xsl:template match="nav:node[@visibleinnav = 'false']"/>

<xsl:template match="nav:site/nav:node[@id = 'index']">
	<tr>
		<td class="publtitle"><a href="{@href}"><xsl:apply-templates select="nav:label"/></a></td>
	</tr>
	<tr>
		<td class="navoff">&#160;</td>
	</tr>
</xsl:template>

<xsl:template match="nav:node">
  <xsl:call-template name="item"/>
  <xsl:apply-templates select="nav:node"/>
</xsl:template>


<!-- hide everything but siblings, parents and first level children. yes its that complicated :) -->
<xsl:template match="nav:node/nav:node
          [not(ancestor-or-self::nav:node[@current = 'true']) and
           not(descendant-or-self::nav:node[@current = 'true']) and
           not(..//nav:node[@current = 'true'])]"/>


<xsl:template match="nav:node[@current = 'true']/*/nav:node"/>


<xsl:template name="item-default">
  <tr>
    <td class="navoff">
  	  <div class="nlevel{count(ancestor-or-self::nav:node)}">
        <a href="{@href}"><xsl:apply-templates select="nav:label"/></a>
      </div>
    </td>
  </tr>
</xsl:template>
    
    
<xsl:template name="item-selected">
  <tr>
    <td class="navon">
  	  <div class="nlevel{count(ancestor-or-self::nav:node)}">
        <xsl:apply-templates select="nav:label"/>
      </div>
    </td>
  </tr>
</xsl:template>


</xsl:stylesheet> 
