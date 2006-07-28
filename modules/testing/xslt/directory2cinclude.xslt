<?xml version="1.0" encoding="UTF-8"?>

<!-- Prepares the logs from a directory (Directory Gen from Sitemap) -->

<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns="http://apache.org/lenya/test/1.0"
    xmlns:testlog="http://apache.org/lenya/testlog/1.0"
    xmlns:directory="http://apache.org/cocoon/directory/2.0"
    >
    
    <xsl:template match="/">
        <allprojectslogs>
        <xsl:for-each select="directory:directory/directory:file">
            <xsl:variable name="name"><xsl:value-of select="@name"/></xsl:variable>
            <cinclude:include src="junit/{$name}" />
        </xsl:for-each>
        </allprojectslogs>
    </xsl:template>
</xsl:stylesheet>
