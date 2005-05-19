<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: pulldown-menu.xsl,v 1.4 2005/03/21 13:11:29 thomas Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="nav"
    >
    

<xsl:template match="nav:site">

  <div id="pulldownmenu">
    <xsl:for-each select="nav:node/nav:node/nav:node/nav:node[@current = 'true']">
      <select name="select" onChange="location.href=this.options[this.selectedIndex].value">
        <xsl:for-each select="../nav:node">
          <xsl:choose>
            <xsl:when test="@current = 'true'">
              <option value="{@href}" selected="selected">
                <xsl:value-of select="nav:label"/>
              </option>
            </xsl:when>
            <xsl:otherwise>
              <option value="{@href}">
                <xsl:value-of select="nav:label"/>
              </option>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each> 
      </select>
    </xsl:for-each>
  </div>

</xsl:template>

</xsl:stylesheet> 
