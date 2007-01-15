<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xsp="http://apache.org/xsp"
  xmlns:uc="http://apache.org/cocoon/lenya/usecase/1.0"
  xmlns:mb="http://apache.org/cocoon/lenya/menubar/1.0"
  xmlns="http://apache.org/cocoon/lenya/menubar/1.0"
> 

  <xsl:template match="xsp:page/mb:menu/mb:menus/mb:menu[@name = 'File']/mb:block[1]/xsp:logic/mb:item[position() = last()]">
    <xsl:copy-of select="."/> 
    <item uc:usecase="create" uc:step="showscreen" href="?doctype=lesson">New eLML Lesson</item>
  </xsl:template>


  <xsl:template match="xsp:page/mb:menu/mb:menus/mb:menu[@name = 'File']/mb:block[2]">
    <xsl:copy-of select="."/>
    <block>
      <item uc:usecase="importlesson" href="?">Import eLML Lesson</item>
      <item href="?" uc:usecase="layoutmanager" uc:step="init">Layout Manager...</item>
    </block>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
