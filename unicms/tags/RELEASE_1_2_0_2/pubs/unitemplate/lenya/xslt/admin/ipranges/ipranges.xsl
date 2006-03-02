<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:page="http://apache.org/cocoon/lenya/cms-page/1.0"
    xmlns:session="http://www.apache.org/xsp/session/2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    >
    
  <xsl:import href="../../../../../../xslt/admin/ipranges/ipranges.xsl"/>
    
  <xsl:template match="ipranges">
    <div style="margin: 10px 0px">
      <xsl:call-template name="add-iprange"/>
    </div>
    <table cellspacing="0" class="lenya-table">
      <tr>
        <th>IP range ID</th>
        <th>Name</th>
        <th></th>
      </tr>
      <xsl:apply-templates select="iprange">
        <xsl:sort select="id"/>
      </xsl:apply-templates>
    </table>
  </xsl:template>
  
  
  <xsl:template match="groups"/>
  
  
</xsl:stylesheet>
