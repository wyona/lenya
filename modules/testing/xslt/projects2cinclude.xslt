<?xml version="1.0" encoding="UTF-8"?>

<!-- Prepares the path to the tests.xml (called from sitemap) -->

<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns="http://apache.org/lenya/test/1.0"
    xmlns:test="http://apache.org/lenya/test/1.0"
    >
    
    <xsl:template match="/">
        <allprojects>
        <xsl:for-each select="test:projects/test:project">
            <xsl:variable name="path"><xsl:value-of select="test:path"/></xsl:variable>
            <xsl:variable name="name"><xsl:value-of select="@name"/></xsl:variable>
            <!-- CInclude will generate one big xml over all tests.xml which are found -->
            <project name="{$name}">
            <cinclude:include src="{$path}/tests.xml"/>
            </project>
        </xsl:for-each>
        </allprojects>
    </xsl:template>
</xsl:stylesheet>
