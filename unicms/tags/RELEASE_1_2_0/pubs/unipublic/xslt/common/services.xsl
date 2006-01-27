<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:service="http://unizh.ch/doctypes/services/1.0"
  exclude-result-prefixes="service">
  
  
  <xsl:template match="service:Services">
    <img alt="service" src="{$imageprefix}/t_service.gif" height="21" width="120"/>
    <table border="0" cellpadding="0" cellspacing="0" width="126">
      <xsl:apply-templates select="service:Service"/>
      <tr>
        <td>
          <br/>
          <a href="{service:Newsletter/@href}">
            <img height="18" width="126" src="{$imageprefix}/newslett.gif"
              border="0" alt="newsletter abo"/>
          </a>
        </td>
      </tr>
      <tr>
        <td>
          <br/>
          <a href="../webperlen/">
            <img height="40" width="83" src="{$imageprefix}/t_webperlen.gif"
              alt="webperlen" border="0"/>
          </a>
        </td>
      </tr>
    </table>
  </xsl:template>

   
  <xsl:template match="service:Service">
    <tr>
      <td>
        <a href="{@href}">
          <img height="25" width="115" src="{$imageprefix}/s_{@id}.gif"
            border="0" alt="{@id}"/>
        </a>
      </td>
    </tr>
    <tr>
      <td>
        <img height="1" width="1" src="{$imageprefix}/1.gif" alt=""/>
      </td>
    </tr>
  </xsl:template>
    
</xsl:stylesheet>
