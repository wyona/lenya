<?xml version="1.0" encoding="UTF-8"?>

<!-- Prepares the layout of the view from the Logs -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:test="http://apache.org/lenya/test/1.0" xmlns="http://apache.org/lenya/test/1.0"
    xmlns:directory="http://apache.org/cocoon/directory/2.0" exclude-result-prefixes="test">
    
    <xsl:template match="/">
        <xsl:for-each select="test:allprojectslogs/testsuite">
            <xsl:variable name="name_short">
                <xsl:call-template name="substring-after-last">
                    <xsl:with-param name="input" select="@name"/>
                    <xsl:with-param name="substr" select="'.'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="error">
                    <tr>
                        <td>
                            <font color="red">Failed: </font>
                        </td>
                        <td>
                            <xsl:value-of select="@name"/>
                            <td>
                                <span onclick="toggle('{$name_short}')" id="{$name_short}-switch"
                                    class="switch">[Show]</span>
                            </td>
                        </td>
                        <tr style="display:none" id="{$name_short}">
                            <td colspan="3">
                                <b>
                                    <xsl:value-of select="error/@type"/>
                                </b>
                                <br/>
                                <xsl:value-of select="error"/>
                            </td>
                        </tr>
                    </tr>
                </xsl:when>
                <xsl:otherwise>
                    <tr>
                        <td>
                            <font color="green">Sucess:</font>
                        </td>
                        <td>
                            <xsl:value-of select="@name"/>
                            <td>
                                <span onclick="toggle('{$name_short}')" id="{$name_short}-switch"
                                    class="switch">[Show]</span>
                            </td>
                        </td>
                        <tr style="display:none" id="{$name_short}">
                            <td colspan="3"> Time: <xsl:value-of select="@time"/>
                            </td>
                        </tr>
                    </tr>
                </xsl:otherwise>
            </xsl:choose>
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
