<?xml version="1.0" encoding="iso-8859-1"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns="http://www.w3.org/1999/xhtml">
  
  <xsl:output version="1.0" indent="yes" encoding="ISO-8859-1"/>
  
  <xsl:param name="status"/>
  <xsl:param name="lenya.usecase" select="'create'"/>
  
  <xsl:template match="/">

    <xsl:variable name="doctype" select="/parent-child/doctype"/>

    <page:page xmlns:page="http://apache.org/cocoon/lenya/cms-page/1.0">
      <page:title>
        <xsl:choose>
          <xsl:when test="$doctype = 'xhtml'">Create Document</xsl:when>
          <xsl:when test="$doctype = 'homepage'">Create Homepage</xsl:when>
          <xsl:when test="$doctype = 'homepage4cols'">Create Overview Homepage</xsl:when>
          <xsl:when test="$doctype = 'overview'">Create Overview Page</xsl:when>
          <xsl:when test="$doctype = 'news'">Create RSS News Feed</xsl:when>
          <xsl:when test="$doctype = 'newsitem'">Create News Item</xsl:when>
          <xsl:when test="$doctype = 'team'">Create Team Page</xsl:when>
          <xsl:when test="$doctype = 'person'">Create Persons Description</xsl:when>
          <xsl:when test="$doctype = 'search'">Create Search Page</xsl:when>
          <xsl:when test="$doctype = 'redirect'">Create Redirect Page</xsl:when>
          <xsl:otherwise>Create Document</xsl:otherwise>
        </xsl:choose>
      </page:title>
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
                <xsl:when test="($doctype = 'homepage') or ($doctype = 'homepage4cols')">
                  <tr>
                    <td class="lenya-form-caption">Tabs in Page Header:</td><td><select class="lenya-form-element" name="properties.create.tabs"><option>true</option><option selected="true">false</option></select></td>
                  </tr>
                </xsl:when>
                <xsl:otherwise/>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$doctype = 'newsitem'">
                  <tr>
                    <td class="lenya-form-caption">News Item Type:</td><td><select class="lenya-form-element" name="properties.create.docsubtype"><option>summary only</option><option>summary and link</option><option selected="true">summary and details</option></select></td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <input type="hidden" name="properties.create.docsubtype" value=""/>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td class="lenya-form-caption">Subject (Keywords):</td><td><input class="lenya-form-element" type="text" name="properties.create.subject"/></td>
              </tr>
              <tr>
                <td class="lenya-form-caption">Description:</td><td><textarea class="lenya-form-element" name="properties.create.description" rows="3">&#160;</textarea></td>
              </tr>
              <tr>
                <td class="lenya-form-caption">Publisher:</td><td><input class="lenya-form-element" type="text" name="properties.create.publisher"><xsl:attribute name="value"><xsl:apply-templates select="dc:publisher"/></xsl:attribute>&#160;</input></td>
              </tr>
              <tr>
                <td class="lenya-form-caption">Rights:</td><td><input class="lenya-form-element" type="text" name="properties.create.rights"><xsl:attribute name="value"><xsl:apply-templates select="dc:rights"/></xsl:attribute>&#160;</input></td>
              </tr>
              <xsl:choose>
                <xsl:when test="$doctype = 'xhtml'">
                  <tr>
                    <td class="lenya-form-caption">Number of Columns:</td><td><select class="lenya-form-element" name="properties.create.columns"><option>1</option><option>2</option><option selected="true">3</option></select></td>
                  </tr>
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
  
  <xsl:template match="dc:publisher">
    <xsl:variable name="publisher" select="/parent-child/dc:publisher"/>
    <xsl:variable name="language" select="/parent-child/dc:language"/>
    <xsl:choose>
      <xsl:when test="($publisher = '') and ($language = 'de')">Universit&#228;t Z&#252;rich</xsl:when>
      <xsl:when test="starts-with($publisher, 'Universit') and ($language = 'de')">Universit&#228;t Z&#252;rich</xsl:when>
      <xsl:when test="($publisher = '') and ($language = 'en')">University of Zurich</xsl:when>
      <xsl:when test="starts-with($publisher, 'Universit') and ($language = 'en')">University of Zurich</xsl:when>
      <xsl:otherwise><xsl:value-of select="$publisher"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="dc:rights">
    <xsl:variable name="rights" select="/parent-child/dc:rights"/>
    <xsl:variable name="language" select="/parent-child/dc:language"/>
    <xsl:choose>
      <xsl:when test="($rights = '') and ($language = 'de')">Universit&#228;t Z&#252;rich</xsl:when>
      <xsl:when test="starts-with($rights, 'Universit') and ($language = 'de')">Universit&#228;t Z&#252;rich</xsl:when>
      <xsl:when test="($rights = '') and ($language = 'en')">University of Zurich</xsl:when>
      <xsl:when test="starts-with($rights, 'Universit') and ($language = 'en')">University of Zurich</xsl:when>
      <xsl:otherwise><xsl:value-of select="$rights"/></xsl:otherwise>
    </xsl:choose>
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
