<?xml version="1.0" encoding="iso-8859-1"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns="http://www.w3.org/1999/xhtml">
  
  <xsl:output version="1.0" indent="yes" encoding="ISO-8859-1"/>
  
  <xsl:param name="status"/>
  <xsl:param name="lenya.usecase" select="'create'"/>
  
  <xsl:template match="/">
    <page:page xmlns:page="http://apache.org/cocoon/lenya/cms-page/1.0">
      <page:title>Create Document</page:title>
      <page:body>
        <xsl:apply-templates/>
      </page:body>
    </page:page>
  </xsl:template>
  
  <xsl:template match="parent-child">
    
    <xsl:apply-templates select="exception"/>
    
    <xsl:variable name="doctype" select="/parent-child/doctype"/>
    
    <xsl:if test="not(exception)">
      <div class="lenya-box">
        <div class="lenya-box-title">New Document</div>
        <div class="lenya-box-body">
        <script Language="JavaScript">
function validRequired(formField,fieldLabel)
{
        var result = true;
        
        if (formField.value == "")
        {
                alert('Please enter a value for the "' + fieldLabel +'" field.');
                formField.focus();
                result = false;
        }
        
        return result;
}

function validContent(formField,fieldLabel)
{
        var result = true;
        
        if (formField.value.match("[^a-zA-Z0-9\\-]+"))
        {
                alert('Please enter a valid value for the "' + fieldLabel +'" field. A-Z, a-z, 0-9 or -');
                formField.focus();
                result = false;
        }
        
        return result;
}

function validateForm(theForm)
{
        if (!validContent(theForm["properties.create.child-id"],"Document ID"))
                return false;

        if (!validRequired(theForm["properties.create.child-id"],"Document ID"))
                return false;

        if (!validRequired(theForm["properties.create.child-name"],"Navigation Title"))
                return false;

        if (!validRequired(theForm["properties.create.title"],"Document Title"))
                return false;
        
        return true;
}
</script>
   
          <form method="GET" 
            action="{/parent-child/referer}" id="create" onsubmit="return validateForm(this)">
            <input type="hidden" name="properties.create.parent-id" value="{/parent-child/parentid}"/>
            <input type="hidden" name="lenya.usecase" value="{$lenya.usecase}"/>
            <input type="hidden" name="lenya.step" value="create"/>
            <input type="hidden" name="properties.create.child-type" value="branch"/>
            <input type="hidden" name="properties.create.doctype" value="{$doctype}"/>
            <input type="hidden" name="properties.create.userid" value="{/parent-child/user-id}"/>
            <input type="hidden" name="properties.create.ipaddress" value="{/parent-child/ip-address}"/>
            <table class="lenya-table-noborder">
              <xsl:if test="$status != ''">
                <tr>
                  <td class="lenya-form-message-error" colspan="2">The ID
                    you've entered is already taken. Please choose
                    another one.</td>
                </tr>
              </xsl:if>
              <tr>
                <td class="lenya-form-caption">Parent ID:</td><td><xsl:value-of select="/parent-child/parentid"/></td>
              </tr>
              <tr>
                <td class="lenya-form-caption">Document ID*:</td><td><input class="lenya-form-element" type="text" name="properties.create.child-id"/><br/>(No whitespace, no special characters)</td>
              </tr>
               <tr>
                <td class="lenya-form-caption">Document visible in navigation:</td><td><select class="lenya-form-element" name="properties.create.visible"><option selected="true">yes</option><option>no</option></select></td>
              </tr>
              <tr>
                <td class="lenya-form-caption">Document Title*:</td><td><input class="lenya-form-element" type="text" name="properties.create.title"/></td>
              </tr>
              <tr>
                <td class="lenya-form-caption">Navigation Title*:</td><td><input class="lenya-form-element" type="text" name="properties.create.child-name"/></td>
              </tr>
              <tr>
                <td class="lenya-form-caption">Language:</td><td><input class="lenya-form-element" type="hidden" name="properties.create.language" value="{/parent-child/dc:language}"/><xsl:value-of select="/parent-child/dc:language"/></td>
              </tr>
              <xsl:choose>
                <xsl:when test="$doctype = 'homepage'">
                  <tr>
                    <td class="lenya-form-caption">Tabs in Page Header:</td><td><select class="lenya-form-element" name="properties.create.tabs"><option selected="true">true</option><option>false</option></select></td>
                  </tr>
                </xsl:when>
                <xsl:otherwise/>
              </xsl:choose>
              <tr>
                <td class="lenya-form-caption">Subject (Keywords):</td><td><input class="lenya-form-element" type="text" name="properties.create.subject"/></td>
              </tr>
              <tr>
                <td class="lenya-form-caption">Description:</td><td><textarea class="lenya-form-element" name="properties.create.description" rows="3">&#160;</textarea></td>
              </tr>
              <tr>
                <td class="lenya-form-caption">Publisher:</td><td><input class="lenya-form-element" type="text" name="properties.create.publisher" value="{/parent-child/dc:publisher}"/></td>
              </tr>
              <tr>
                <td class="lenya-form-caption">Rights:</td><td><input class="lenya-form-element" type="text" name="properties.create.rights" value="{/parent-child/dc:rights}"/></td>
              </tr>
              <xsl:choose>
                <xsl:when test="$doctype = 'xhtml'">
                  <tr>
                    <td class="lenya-form-caption">Number of Columns:</td><td><select class="lenya-form-element" name="properties.create.columns"><option>1</option><option>2</option><option selected="true">3</option></select></td>
                  </tr>
                </xsl:when>
                <xsl:when test="$doctype = 'section'">
                  <input type="hidden" name="properties.create.columns" value="1"/>
                </xsl:when>
                <xsl:otherwise/>
              </xsl:choose>
              <tr>
                <td class="lenya-form-caption">Date:</td><td><input class="lenya-form-element" type="hidden" name="properties.create.date" value="{/parent-child/dc:date}"/><xsl:value-of select="/parent-child/dc:date"/></td>
              </tr>
              <tr>
                <td class="lenya-form-caption">Creator:</td><td><input class="lenya-form-element" type="hidden" name="properties.create.creator" value="{/parent-child/dc:creator}"/><xsl:value-of select="/parent-child/dc:creator"/></td>
              </tr>
              <tr>
                <td class="lenya-form-caption">* required fields</td>
              </tr>
              <tr>
                <td/>
                <td>
                  <input type="submit" value="Create"/>&#160;
                  <input type="button" onClick="location.href='{/parent-child/referer}';" value="Cancel"/>
                </td>
              </tr>
            </table>
          </form>
        </div>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="exception">
    <font color="red">EXCEPTION</font><br />
    Go <a href="{../referer}">back</a> to page.<br />
    <p>
      Exception handling isn't very good at the moment. 
      For further details please take a look at the log-files
      of Cocoon. In most cases it's one of the two possible exceptions:
      <ol>
        <li>The id is not allowed to have whitespaces</li>
        <li>The id is already in use</li>
      </ol>
      Exception handling will be improved in the near future.
    </p>
  </xsl:template>
  
</xsl:stylesheet>  
