<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dsi="http://www.wyona.org/dspace/1.0"
  xmlns:esql="http://apache.org/cocoon/SQL/2.0"
>

<!-- default parameter value -->
<xsl:param name="rendertype" select="''"/>

<!-- TODO: The language does seem to be passed to this XSLT -->
<xsl:param name="language" select="'HUGO'"/>

<!-- TODO: Add dynamic esql queries for dspace -->
<xsl:template match="dsi:dspace-item">
  <div id="body">


	<esql:execute-query>
			<esql:query>SELECT item_id from dcvalue</esql:query>
	</esql:execute-query>
	<br />
	<esql:execute-query>
			<esql:query>SELECT text_lang from dcvalue</esql:query>
	</esql:execute-query>
	<br />
	<esql:execute-query>
			<esql:query>SELECT * from dcvalue</esql:query>
	</esql:execute-query>
	<br />
	<esql:execute-query>
			<esql:query>SELECT text_value from dcvalue where dc_value_id = <xsl:value-of select="@id"/></esql:query>
	</esql:execute-query>
	<br />
	<esql:execute-query>
			<esql:query>SELECT text_id from dcvalue</esql:query>
	</esql:execute-query>
	<br />
	<esql:execute-query>
			<esql:query>SELECT place from dcvalue</esql:query>
	</esql:execute-query>
	<br />
	<esql:execute-query>
			<esql:query>SELECT source_id from dcvalue</esql:query>
	</esql:execute-query>

<!--
	<esql:connection>
		<esql:pool>dspace</esql:pool>
		<esql:driver>org.postgresql.Driver</esql:driver>
		<esql:dburl>jdbc:postgresql://192.168.100.115/dspace</esql:dburl>
		<esql:username>dspace</esql:username>
		<esql:password>dspace</esql:password>
			<esql:results>
				<esql:row-results>
					<esql:get-string column="text_value"/>
					<esql:get-string column="text_lang"/>
					<esql:get-string column="item_id"/>
				</esql:row-results>
			</esql:results>
		<esql:no-results>
			Sorry, Dspace database is empty!
		</esql:no-results>
	</esql:connection>
-->
  </div>
</xsl:template>




<!--
<xsl:template match="at:ActTitle">
<p>
  <xsl:apply-templates/>
</p>
</xsl:template>

<xsl:template match="at:p">
<p>
  <xsl:apply-templates/>
</p>
</xsl:template>

<xsl:template match="at:ActTitle">
<h1>
  <xsl:apply-templates/>
</h1>
</xsl:template>

<xsl:template match="at:ActProponent">
<b>
  <xsl:apply-templates/>
</b>
</xsl:template>

<xsl:template match="at:ActType">
<h2>
  <xsl:apply-templates/>
</h2>
</xsl:template>

<xsl:template match="at:ActPurpose">
<i>
  <xsl:apply-templates/>
</i>
</xsl:template>
-->

</xsl:stylesheet>
