<?xml version="1.0" encoding="utf-8"?>

<!--
 $Id: exception.xsl,v 1.1 2004/12/06 14:20:21 edith Exp $
 -->

 <xsl:stylesheet version="1.0"
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:session="http://www.apache.org/xsp/session/2.0"
   xmlns:page="http://apache.org/cocoon/lenya/cms-page/1.0"
   xmlns:usecase="http://apache.org/cocoon/lenya/usecase/1.0"
   >

   <xsl:variable name="referer"><xsl:value-of select="/usecase:newsletter/usecase:referer"/></xsl:variable>

  <xsl:template match="/">
    <page:page>
      <page:title>Newsletter Report</page:title>
      <page:body>
    <div class="lenya-box">
      <div class="lenya-box-title">Newsletter Report</div>
      <div class="lenya-box-body">
        <h2>Error!</h2>
        <p>
          The newsletter has not been sent. Consult the log files for further information.
        </p>
        <a href="{$referer}">Back to Newsletter</a>
       </div>
    </div>
      </page:body>
    </page:page>
  </xsl:template>

</xsl:stylesheet> 
