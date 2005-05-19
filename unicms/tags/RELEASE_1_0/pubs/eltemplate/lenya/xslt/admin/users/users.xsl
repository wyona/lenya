<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:page="http://apache.org/cocoon/lenya/cms-page/1.0"
    xmlns:session="http://www.apache.org/xsp/session/2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    >
    
  <xsl:import href="../../../../../../xslt/admin/users/users.xsl"/>
    
  <xsl:template name="add-user">
  	<table class="lenya-table-noborder">
  	  <tr>
        <td>
          <form method="GET">
            <input type="hidden" name="lenya.usecase" value="userAddUserLdap"/>
            <input type="submit" value="Add University User"/>
          </form>
        </td>
  	    <td>
          <form method="GET">
            <input type="hidden" name="lenya.usecase" value="userAddUser"/>
            <input type="submit" value="Add CMS User"/>
          </form>
        </td>
      </tr>
    </table>
  </xsl:template>
  
</xsl:stylesheet>
