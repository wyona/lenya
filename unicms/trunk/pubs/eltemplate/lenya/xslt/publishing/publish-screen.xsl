<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:page="http://apache.org/cocoon/lenya/cms-page/1.0"
  xmlns:usecase="http://apache.org/cocoon/lenya/usecase/1.0"
  xmlns:not="http://apache.org/cocoon/lenya/notification/1.0"
  xmlns:sch="http://apache.org/cocoon/lenya/scheduler/1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  >
  
  <xsl:import href="../../../../../xslt/util/page-util.xsl"/>

  <xsl:output version="1.0" indent="yes" encoding="ISO-8859-1"/>

  <xsl:param name="action" select="'publish'"/>

  <xsl:variable name="separator" select="','"/>

  <xsl:variable name="sources"><xsl:value-of select="/usecase:publish/usecase:source"/></xsl:variable>
  <xsl:variable name="task-id"><xsl:value-of select="/usecase:publish/usecase:task-id"/></xsl:variable>
  <xsl:variable name="referer"><xsl:value-of select="/usecase:publish/usecase:referer"/></xsl:variable>


  <xsl:template match="usecase:parent">
    <a href="{@href}"><xsl:value-of select="@id"/> [<xsl:value-of select="@language"/>]</a>
  </xsl:template>
        
        
  <xsl:template match="/usecase:publish">

    <page:page>
      <page:title>Publish</page:title>
      <page:body>
        
        <table class="lenya-table-noborder">
        <tr>
        <td>
        
        <form name="form_publish">
          
          <input type="hidden" name="lenya.step" value="publish"/>
          <input type="hidden" name="workflow-event" value="publish"/>
          
          <xsl:call-template name="task-parameters"/>
          
          <div class="lenya-box">
            <div class="lenya-box-title">Publish</div>
            <div class="lenya-box-body">
          
            
            <table class="lenya-table-noborder">
              <tr>
                <td class="lenya-entry-caption" valign="top">Source&#160;File(s):</td>
                <td valign="top">
                  <xsl:call-template name="print-list-simple">
                    <xsl:with-param name="list-string" select="$sources"/>
                  </xsl:call-template>
                </td>
              </tr>
              
              <tr>
                <td valign="top" class="lenya-entry-caption">Scope:</td>
                <td>
                  <input type="radio" name="task-id" value="publish" checked="checked"/> Single document
                  <br/>
                  <input type="radio" name="task-id" value="publishtree"/> Subtree
                </td>
              </tr>
              
              <tr>
                <xsl:apply-templates select="referenced-documents"/>
              </tr>
              
              <tr>
                <xsl:choose>
                  <xsl:when test="usecase:message">
                    <td valign="top" class="lenya-entry-caption">Problem:</td>
                    <td>
                      <span class="lenya-form-error">This page cannot be published unless its parent is
                        published:</span>
                      <ul>
                        <li><xsl:apply-templates select="usecase:parent"/></li>
                      </ul>
                      <input type="button" onClick="location.href='{$referer}';" value="Cancel"/>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td/>
                    <td>
                      <input type="submit" name="lenya.usecase" value="publish"/>
                      &#160;&#160;&#160;
                      <input type="button" onClick="location.href='{$referer}';" value="Cancel"/>
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
              </tr>
              
            </table>
                  
            </div>
          </div>


          <not:notification>
            <not:preset>
              <xsl:apply-templates select="not:users/not:user"/>
            </not:preset>
            <not:textarea/>
          </not:notification>
          
        </form>
        
        <!--
        <sch:scheduler-form>
          
          <sch:job tasklabel="Publish">
            <input type="hidden" name="wrapper.task-id" value="{$task-id}"/>
            <input type="hidden" name="workflow-event" value="publish"/>
            <xsl:call-template name="task-parameters"/>
          </sch:job>
          
          <sch:job tasklabel="Deactivate">
            <input type="hidden" name="wrapper.task-id" value="deactivateDocument"/>
            <input type="hidden" name="workflow-event" value="deactivate"/>
            <xsl:call-template name="task-parameters"/>
          </sch:job>
          
        </sch:scheduler-form>
        
        <div style="text-align: right">
        <form action="{$referer}"><input type="submit" value="Back to Page"/></form>
        </div>
        -->


        </td>
        </tr>
        </table>
          
      </page:body>
    </page:page>
  </xsl:template>
  
  
  <xsl:template name="task-parameters">
    <input type="hidden" name="document-id" value="{/usecase:publish/usecase:document-id}"/>
    <input type="hidden" name="document-language" value="{/usecase:publish/usecase:document-language}"/>
    <input type="hidden" name="user-id" value="{/usecase:publish/usecase:user-id}"/>
    <input type="hidden" name="ip-address" value="{/usecase:publish/usecase:ip-address}"/>
    <input type="hidden" name="role-ids" value="{/usecase:publish/usecase:role-ids}"/>
  </xsl:template>
  

  <xsl:template match="referenced-documents">
    <td class="lenya-entry-caption" valign="top">
      <span class="lenya-form-message-error">This document has links to the <br/>following unpublished documents:<br/><a target="_blank" href="{$referer}?lenya.usecase=publish&amp;lenya.step=show-referenced-documents">[download as list]</a></span>
    </td>
    <td valign="top">
      <xsl:for-each select="referenced-document">
	<a target="_blank" href="{@href}"><xsl:value-of select="@id"/><xsl:value-of select="."/></a><br/>
      </xsl:for-each>
    </td>
  </xsl:template>
  

</xsl:stylesheet>  
