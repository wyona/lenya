<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  exclude-result-prefixes="#default i18n"
>

  <!--
    this stylesheet inserts the wikieditor as a 
    textarea into the div#body tag.
  -->

  <xsl:param name="contextPath"/>
  <xsl:param name="continuationId"/>
  <xsl:param name="usecaseName"/>
  <xsl:param name="wikiContent"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="//xhtml:div[@id='body']">
  <!-- copy the div#body and all attributes that might be in it -->
    <xsl:copy>
      <xsl:for-each select="@*">
        <xsl:copy/>
      </xsl:for-each>
      <form method="post">
        <input type="hidden" name="lenya.continuation" value="{$continuationId}"/>
        <input type="hidden" name="lenya.usecase" value="{$usecaseName}"/>		
        <textarea wrap="virtual" name="wikimarkup" rows="25" style="width:100%">
          <xsl:value-of select="$wikiContent"/>
        </textarea>
        <input i18n:attr="value" type="submit" name="submit" value="Submit"/>		
        <input i18n:attr="value" type="submit" name="cancel" value="Cancel"/>		
      </form>
      <pre>
----             Horizontal ruler
\\               Forced line break
[link]           Create hyperlink to "link", where "link" can be either an internal
                 WikiName or an external link (http://)
[text|link]      Create a hyperlink where the link text is different from the actual
                 hyperlink link.

*                Make a bulleted list (must be in first column). Use more (**)
                 for deeper indentations.
#                Make a numbered list (must be in first column). Use more (##, ###)
                 for deeper indentations.

!, !!, !!!       Start a line with an exclamation mark (!) to make a heading.
                 More exclamation marks mean smaller headings.

__text__         Makes text bold.
^^text^^         Makes text underline.
''text''         Makes text in italic.

{{{text}}}       Makes text as it is (Plaintext).

|text|more text| Makes a table. Double bars for a table heading.
      </pre>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
