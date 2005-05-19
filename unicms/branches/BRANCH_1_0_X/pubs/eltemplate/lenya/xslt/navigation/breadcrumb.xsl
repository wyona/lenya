<?xml version="1.0" encoding="UTF-8" ?>

<!-- $Id: breadcrumb.xsl,v 1.2 2004/11/29 09:20:32 thomas Exp $ -->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nav="http://apache.org/cocoon/lenya/navigation/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="nav"
    >
    
<xsl:import href="../../../../../xslt/navigation/breadcrumb.xsl"/>

<xsl:template name="separator">
  &gt;
</xsl:template>

<!-- <xsl:template match="nav:site/nav:node[@id='index']"/>-->


</xsl:stylesheet> 
