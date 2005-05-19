<?xml version="1.0" encoding="utf-8"?>

<!--
 $Id: screen.xsl,v 1.1 2004/12/06 14:20:21 edith Exp $
 -->

 <xsl:stylesheet version="1.0"
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:session="http://www.apache.org/xsp/session/2.0"
   xmlns:page="http://apache.org/cocoon/lenya/cms-page/1.0"
   xmlns:usecase="http://apache.org/cocoon/lenya/usecase/1.0"
   >

  <xsl:variable name="document-id"><xsl:value-of select="/usecase:newsletter/usecase:document-id"/></xsl:variable>
  <xsl:variable name="document-language"><xsl:value-of select="/usecase:newsletter/usecase:language"/></xsl:variable>
  <xsl:variable name="task-id"><xsl:value-of select="/usecase:newsletter/usecase:task-id"/></xsl:variable>
  <xsl:variable name="area"><xsl:value-of select="/usecase:newsletter/usecase:area"/></xsl:variable>
  <xsl:variable name="referer"><xsl:value-of select="/usecase:newsletter/usecase:referer"/></xsl:variable>

  <xsl:variable name="uri"><xsl:value-of select="concat('/', $area, '/newsletter_', $document-language, '.mail.html')"/></xsl:variable>
    
<xsl:template match="/">
<page:page>
  <page:title>Dispatch Newsletter</page:title>
  <page:body>
    <div class="lenya-box">
      <div class="lenya-box-title">Dispatch Newsletter</div>
      <div class="lenya-box-body">
        <form method="get">
          <input type="hidden" name="lenya.usecase" value="newsletter"/>
          <input type="hidden" name="lenya.step" value="send"/>
          <input type="hidden" name="task-id" value="{$task-id}"/>
          
          <input type="hidden" name="document-id" value="{$document-id}"/>
          <input type="hidden" name="document-language" value="{$document-language}"/>
          <input type="hidden" name="uri" value="{$uri}"/>
          <table class="lenya-table-noborder">
          	<tr>
          	  <td/>
          	  <td><br/>Do you really want to dispatch the newsletter?</td>
          	</tr>
          	<tr>
          	  <td/>
          	  <td>
       			<br/>
                <input type="submit" value="Dispatch"/>&#160;
                <input type="button" onClick="location.href='{$referer}';" value="Cancel"/>
          	  </td>
          	</tr>
          </table>
        </form>
      </div>
    </div>
  </page:body>
</page:page>

</xsl:template>
    
</xsl:stylesheet>