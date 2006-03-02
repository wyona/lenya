<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:page="http://apache.org/cocoon/lenya/cms-page/1.0"
    xmlns:session="http://www.apache.org/xsp/session/2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    >
    
  <xsl:import href="../../../../../../xslt/admin/users/profile.xsl"/>
  
  <xsl:template match="page">
    <page:page>
      <page:title>
        <xsl:choose>
          <xsl:when test="user/@new = 'true'">Add
          	<xsl:choose>
          		<xsl:when test="user/@ldap = 'true'">University User</xsl:when>
          		<xsl:otherwise>CMS User</xsl:otherwise>
          	</xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            Edit Profile: <xsl:value-of select="user/id"/>
          </xsl:otherwise>
      	</xsl:choose>
      </page:title>
      <page:body>
        <xsl:apply-templates select="user"/>
      </page:body>
    </page:page>
  </xsl:template>
  
  
  <xsl:template match="ldapid">
		<tr>
			<td class="lenya-entry-caption">UniAccess&#160;ID&#160;<span class="lenya-admin-required">*</span></td>
			<td>
				<input class="lenya-form-element" name="ldapid" type="text" value="{normalize-space(.)}"/>
			</td>
		</tr>
  </xsl:template>
  
  
</xsl:stylesheet>
