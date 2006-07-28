<?xml version="1.0" encoding="UTF-8"?>

<!-- Prepares the layout of the testlists in the GUI -->

<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:test="http://apache.org/lenya/test/1.0"
    xmlns="http://apache.org/lenya/test/1.0"
    exclude-result-prefixes="test"
    >
    
    <xsl:template match="/">
        <xsl:for-each select="test:allprojects/test:project">
            <xsl:variable name="name"><xsl:value-of select="@name"/></xsl:variable>
            <b><xsl:value-of select="$name"/></b> | 
            <span onclick="toggle('{$name}')" id="{$name}-switch" class="switch">[Show]</span>
            <pre style="display:none" id="{$name}">
            <xsl:for-each select="test:tests/test:test/@file">
                <xsl:variable name="fileid">
                <xsl:call-template name="substring-after-last">
                    <xsl:with-param name="input" select="current()"/>
                    <xsl:with-param name="substr" select="'.'"/>
                </xsl:call-template>             
                </xsl:variable>
                <input type="checkbox" name="{$name}:{$fileid}"><xsl:value-of select="$fileid"/></input><br /> 
             </xsl:for-each>
             <xsl:choose>
                 <xsl:when test="test:tests/test:test/@file">
                <input type="checkbox" name="{$name}-all"><b>All</b></input>
                </xsl:when>
                 <xsl:otherwise>
                     <i>no tests defined in tests.xml</i>
                 </xsl:otherwise>
             </xsl:choose>
            </pre>
            <br />   
       </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="substring-after-last">
        <xsl:param name="input"/>
        <xsl:param name="substr"/>
        <xsl:variable name="temp" select="string(substring-after($input, $substr))"/>
        <xsl:choose>
            <xsl:when test="$substr and contains($temp, $substr)">
                <xsl:call-template name="substring-after-last">
                    <xsl:with-param name="input" select="string($temp)"/>
                    <xsl:with-param name="substr" select="string($substr)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="string($temp)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>