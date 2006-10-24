<?xml version="1.0" encoding="UTF-8"?>
<!-- edited with XMLSPY v2004 rel. 3 U (http://www.xmlspy.com) by Joel Fisler (Geographisches Institut Uni Zuerich) -->
<xsl:stylesheet xmlns:elml="http://www.elml.ch" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">
	<!-- ******* Bibliography Elements *********** -->
	<xsl:template match="elml:book">
		<xsl:param name="comment"/>
		<xsl:param name="furtherReading"/>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block font-family="Courier" font-size="{$fontsize}*1.5" line-height="{$lineheight}" padding-before="2pt">&#x2022;</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:if test="not($furtherReading)">
						<xsl:attribute name="id">
							<xsl:value-of select="generate-id(.)"/>
						</xsl:attribute>
					</xsl:if>
					<fo:inline font-weight="bold" font-variant="small-caps">
						<xsl:choose>
							<xsl:when test="@author">
								<xsl:value-of select="@author"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$label_anon"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
					<xsl:choose>
						<xsl:when test="@publicationYear">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="@publicationYear"/>
							<xsl:text>. </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>. </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="@title">
						<fo:inline font-style="italic">
							<xsl:value-of select="@title"/>
						</fo:inline>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="@edition">
						<xsl:value-of select="@edition"/>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="@publicationPlace">
						<xsl:value-of select="@publicationPlace"/>
					</xsl:if>
					<xsl:if test="@publisher">
						<xsl:if test="@publicationPlace">
							<xsl:text>: </xsl:text>
						</xsl:if>
						<xsl:value-of select="@publisher"/>
					</xsl:if>
					<xsl:if test="@publisher or @publicationPlace">
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="text()">
						<fo:inline font-stretch="narrower">
							<xsl:text> [</xsl:text>
							<xsl:value-of select="text()"/>
							<xsl:text>]</xsl:text>
						</fo:inline>
					</xsl:if>
					<xsl:if test="$comment">
						<fo:block font-size="-1">
							<xsl:value-of select="$comment"/>
						</fo:block>
					</xsl:if>
					<xsl:if test="@downloadUrl">
						<fo:block>
							<xsl:value-of select="$label_download"/>
							<xsl:text>: </xsl:text>
							<fo:basic-link>
								<xsl:attribute name="external-destination">
									<xsl:value-of select="@downloadUrl"/>
								</xsl:attribute>
								<xsl:value-of select="@downloadUrl"/>
							</fo:basic-link>
						</fo:block>
					</xsl:if>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<xsl:template match="elml:contributionInBook">
		<xsl:param name="comment"/>
		<xsl:param name="furtherReading"/>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block font-family="Courier" font-size="{$fontsize}*1.5" line-height="{$lineheight}" padding-before="2pt">&#x2022;</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:if test="not($furtherReading)">
						<xsl:attribute name="id">
							<xsl:value-of select="generate-id(.)"/>
						</xsl:attribute>
					</xsl:if>
					<fo:inline font-weight="bold" font-variant="small-caps">
						<xsl:choose>
							<xsl:when test="@author">
								<xsl:value-of select="@author"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$label_anon"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
					<xsl:choose>
						<xsl:when test="@publicationYear">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="@publicationYear"/>
							<xsl:text>. </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>. </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="@titleOfContribution">
						<xsl:value-of select="@titleOfContribution"/>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<fo:inline font-style="italic">
						<xsl:text>In: </xsl:text>
					</fo:inline>
					<xsl:if test="@editor">
						<fo:inline font-weight="bold" font-variant="small-caps">
							<xsl:value-of select="@editor"/>
						</fo:inline>
						<xsl:text>, ed. </xsl:text>
					</xsl:if>
					<xsl:if test="@title">
						<fo:inline font-style="italic">
							<xsl:value-of select="@title"/>
						</fo:inline>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="@publicationPlace">
						<xsl:value-of select="@publicationPlace"/>
					</xsl:if>
					<xsl:if test="@publisher">
						<xsl:if test="@publicationPlace">
							<xsl:text>: </xsl:text>
						</xsl:if>
						<xsl:value-of select="@publisher"/>
					</xsl:if>
					<xsl:if test="@pageNr">
						<xsl:if test="@publicationPlace or @publisher">
							<xsl:text>, </xsl:text>
						</xsl:if>
						<xsl:value-of select="@pageNr"/>
					</xsl:if>
					<xsl:if test="@publisher or @publicationPlace or @pageNr">
						<xsl:text>. </xsl:text>
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:if test="text()">
						<fo:inline font-stretch="narrower">
							<xsl:text> [</xsl:text>
							<xsl:value-of select="text()"/>
							<xsl:text>]</xsl:text>
						</fo:inline>
					</xsl:if>
					<xsl:if test="$comment">
						<fo:block font-size="-1">
							<xsl:value-of select="$comment"/>
						</fo:block>
					</xsl:if>
					<xsl:if test="@downloadUrl">
						<fo:block>
							<xsl:value-of select="$label_download"/>
							<xsl:text>: </xsl:text>
							<fo:basic-link>
								<xsl:attribute name="external-destination">
									<xsl:value-of select="@downloadUrl"/>
								</xsl:attribute>
								<xsl:value-of select="@downloadUrl"/>
							</fo:basic-link>
						</fo:block>
					</xsl:if>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<xsl:template match="elml:journalArticle">
		<xsl:param name="comment"/>
		<xsl:param name="furtherReading"/>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block font-family="Courier" font-size="{$fontsize}*1.5" line-height="{$lineheight}" padding-before="2pt">&#x2022;</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:if test="not($furtherReading)">
						<xsl:attribute name="id">
							<xsl:value-of select="generate-id(.)"/>
						</xsl:attribute>
					</xsl:if>
					<fo:inline font-weight="bold" font-variant="small-caps">
						<xsl:choose>
							<xsl:when test="@author">
								<xsl:value-of select="@author"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$label_anon"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
					<xsl:choose>
						<xsl:when test="@publicationYear">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="@publicationYear"/>
							<xsl:text>. </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>. </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="@title">
						<xsl:value-of select="@title"/>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="@journalTitle">
						<fo:inline font-style="italic">
							<xsl:value-of select="@journalTitle"/>
						</fo:inline>
						<xsl:if test="@volumeNr or @pageNr">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:if>
					<xsl:if test="@volumeNr">
						<xsl:value-of select="@volumeNr"/>
						<xsl:text>, </xsl:text>
					</xsl:if>
					<xsl:if test="@pageNr">
						<xsl:value-of select="@pageNr"/>
					</xsl:if>
					<xsl:text>. </xsl:text>
					<xsl:if test="text()">
						<fo:inline font-stretch="narrower">
							<xsl:text> [</xsl:text>
							<xsl:value-of select="text()"/>
							<xsl:text>]</xsl:text>
						</fo:inline>
					</xsl:if>
					<xsl:if test="$comment">
						<fo:block font-size="-1">
							<xsl:value-of select="$comment"/>
						</fo:block>
					</xsl:if>
					<xsl:if test="@downloadUrl">
						<fo:block>
							<xsl:value-of select="$label_download"/>
							<xsl:text>: </xsl:text>
							<fo:basic-link>
								<xsl:attribute name="external-destination">
									<xsl:value-of select="@downloadUrl"/>
								</xsl:attribute>
								<xsl:value-of select="@downloadUrl"/>
							</fo:basic-link>
						</fo:block>
					</xsl:if>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<xsl:template match="elml:newspaperArticle">
		<xsl:param name="comment"/>
		<xsl:param name="furtherReading"/>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block font-family="Courier" font-size="{$fontsize}*1.5" line-height="{$lineheight}" padding-before="2pt">&#x2022;</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:if test="not($furtherReading)">
						<xsl:attribute name="id">
							<xsl:value-of select="generate-id(.)"/>
						</xsl:attribute>
					</xsl:if>
					<fo:inline font-weight="bold" font-variant="small-caps">
						<xsl:choose>
							<xsl:when test="@author">
								<xsl:value-of select="@author"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$label_anon"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
					<xsl:choose>
						<xsl:when test="@publicationYear">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="@publicationYear"/>
							<xsl:text>. </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>. </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="@title">
						<xsl:value-of select="@title"/>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="@newspaperTitle">
						<fo:inline font-style="italic">
							<xsl:value-of select="@newspaperTitle"/>
						</fo:inline>
						<xsl:if test="@dayMonthor or @pageNr">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:if>
					<xsl:if test="@dayMonth">
						<xsl:value-of select="@dayMonth"/>
						<xsl:text>, </xsl:text>
					</xsl:if>
					<xsl:if test="@pageNr">
						<xsl:value-of select="@pageNr"/>
					</xsl:if>
					<xsl:text>. </xsl:text>
					<xsl:if test="text()">
						<fo:inline font-stretch="narrower">
							<xsl:text> [</xsl:text>
							<xsl:value-of select="text()"/>
							<xsl:text>]</xsl:text>
						</fo:inline>
					</xsl:if>
					<xsl:if test="$comment">
						<fo:block font-size="-1">
							<xsl:value-of select="$comment"/>
						</fo:block>
					</xsl:if>
					<xsl:if test="@downloadUrl">
						<fo:block>
							<xsl:value-of select="$label_download"/>
							<xsl:text>: </xsl:text>
							<fo:basic-link>
								<xsl:attribute name="external-destination">
									<xsl:value-of select="@downloadUrl"/>
								</xsl:attribute>
								<xsl:value-of select="@downloadUrl"/>
							</fo:basic-link>
						</fo:block>
					</xsl:if>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<xsl:template match="elml:map">
		<xsl:param name="comment"/>
		<xsl:param name="furtherReading"/>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block font-family="Courier" font-size="{$fontsize}*1.5" line-height="{$lineheight}" padding-before="2pt">&#x2022;</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:if test="not($furtherReading)">
						<xsl:attribute name="id">
							<xsl:value-of select="generate-id(.)"/>
						</xsl:attribute>
					</xsl:if>
					<fo:inline font-weight="bold" font-variant="small-caps">
						<xsl:choose>
							<xsl:when test="@author">
								<xsl:value-of select="@author"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$label_anon"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
					<xsl:choose>
						<xsl:when test="@publicationYear">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="@publicationYear"/>
							<xsl:text>. </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>. </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="@title">
						<xsl:value-of select="@title"/>
					</xsl:if>
					<xsl:if test="@scale">
						<xsl:if test="@title">
							<xsl:text>, </xsl:text>
						</xsl:if>
						<xsl:value-of select="@scale"/>
					</xsl:if>
					<xsl:text>. </xsl:text>
					<xsl:if test="@publicationPlace">
						<xsl:value-of select="@publicationPlace"/>
					</xsl:if>
					<xsl:if test="@publisher">
						<xsl:if test="@publicationPlace">
							<xsl:text>: </xsl:text>
						</xsl:if>
						<xsl:value-of select="@publisher"/>
					</xsl:if>
					<xsl:if test="@publisher or @publicationPlace">
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="text()">
						<fo:inline font-stretch="narrower">
							<xsl:text> [</xsl:text>
							<xsl:value-of select="text()"/>
							<xsl:text>]</xsl:text>
						</fo:inline>
					</xsl:if>
					<xsl:if test="$comment">
						<fo:block font-size="-1">
							<xsl:value-of select="$comment"/>
						</fo:block>
					</xsl:if>
					<xsl:if test="@downloadUrl">
						<fo:block>
							<xsl:value-of select="$label_download"/>
							<xsl:text>: </xsl:text>
							<fo:basic-link>
								<xsl:attribute name="external-destination">
									<xsl:value-of select="@downloadUrl"/>
								</xsl:attribute>
								<xsl:value-of select="@downloadUrl"/>
							</fo:basic-link>
						</fo:block>
					</xsl:if>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<xsl:template match="elml:conferencePaper">
		<xsl:param name="comment"/>
		<xsl:param name="furtherReading"/>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block font-family="Courier" font-size="{$fontsize}*1.5" line-height="{$lineheight}" padding-before="2pt">&#x2022;</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:if test="not($furtherReading)">
						<xsl:attribute name="id">
							<xsl:value-of select="generate-id(.)"/>
						</xsl:attribute>
					</xsl:if>
					<fo:inline font-weight="bold" font-variant="small-caps">
						<xsl:choose>
							<xsl:when test="@author">
								<xsl:value-of select="@author"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$label_anon"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
					<xsl:choose>
						<xsl:when test="@publicationYear">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="@publicationYear"/>
							<xsl:text>. </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>. </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="@titleOfContribution">
						<xsl:value-of select="@titleOfContribution"/>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<fo:inline font-style="italic">
						<xsl:text>In: </xsl:text>
					</fo:inline>
					<xsl:if test="@editor">
						<fo:inline font-weight="bold" font-variant="small-caps">
							<xsl:value-of select="@editor"/>
						</fo:inline>
						<xsl:text>, ed. </xsl:text>
					</xsl:if>
					<xsl:if test="@proceedingsTitle">
						<fo:inline font-style="italic">
							<xsl:value-of select="@proceedingsTitle"/>
							<xsl:if test="@datePlace">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="@datePlace"/>
							</xsl:if>
						</fo:inline>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="@publicationPlace">
						<xsl:value-of select="@publicationPlace"/>
					</xsl:if>
					<xsl:if test="@publisher">
						<xsl:if test="@publicationPlace">
							<xsl:text>: </xsl:text>
						</xsl:if>
						<xsl:value-of select="@publisher"/>
					</xsl:if>
					<xsl:if test="@pageNr">
						<xsl:if test="@publicationPlace or @publisher">
							<xsl:text>, </xsl:text>
						</xsl:if>
						<xsl:value-of select="@pageNr"/>
					</xsl:if>
					<xsl:if test="@publisher or @publicationPlace or @pageNr">
						<xsl:text>. </xsl:text>
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:if test="text()">
						<fo:inline font-stretch="narrower">
							<xsl:text> [</xsl:text>
							<xsl:value-of select="text()"/>
							<xsl:text>]</xsl:text>
						</fo:inline>
					</xsl:if>
					<xsl:if test="$comment">
						<fo:block font-size="-1">
							<xsl:value-of select="$comment"/>
						</fo:block>
					</xsl:if>
					<xsl:if test="@downloadUrl">
						<fo:block>
							<xsl:value-of select="$label_download"/>
							<xsl:text>: </xsl:text>
							<fo:basic-link>
								<xsl:attribute name="external-destination">
									<xsl:value-of select="@downloadUrl"/>
								</xsl:attribute>
								<xsl:value-of select="@downloadUrl"/>
							</fo:basic-link>
						</fo:block>
					</xsl:if>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<xsl:template match="elml:publicationCorporateBody">
		<xsl:param name="comment"/>
		<xsl:param name="furtherReading"/>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block font-family="Courier" font-size="{$fontsize}*1.5" line-height="{$lineheight}" padding-before="2pt">&#x2022;</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:if test="not($furtherReading)">
						<xsl:attribute name="id">
							<xsl:value-of select="generate-id(.)"/>
						</xsl:attribute>
					</xsl:if>
					<fo:inline font-weight="bold" font-variant="small-caps">
						<xsl:choose>
							<xsl:when test="@author">
								<xsl:value-of select="@author"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$label_anon"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
					<xsl:choose>
						<xsl:when test="@publicationYear">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="@publicationYear"/>
							<xsl:text>. </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>. </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="@title">
						<fo:inline font-style="italic">
							<xsl:value-of select="@title"/>
						</fo:inline>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="@publicationPlace">
						<xsl:value-of select="@publicationPlace"/>
					</xsl:if>
					<xsl:if test="@publisher">
						<xsl:if test="@publicationPlace">
							<xsl:text>: </xsl:text>
						</xsl:if>
						<xsl:value-of select="@publisher"/>
					</xsl:if>
					<xsl:if test="@reportNr">
						<xsl:if test="@publicationPlace or @publisher">
							<xsl:text>, </xsl:text>
						</xsl:if>
						<xsl:value-of select="@reportNr"/>
					</xsl:if>
					<xsl:if test="@publisher or @publicationPlace or @reportNr">
						<xsl:text>. </xsl:text>
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:if test="text()">
						<fo:inline font-stretch="narrower">
							<xsl:text> [</xsl:text>
							<xsl:value-of select="text()"/>
							<xsl:text>]</xsl:text>
						</fo:inline>
					</xsl:if>
					<xsl:if test="$comment">
						<fo:block font-size="-1">
							<xsl:value-of select="$comment"/>
						</fo:block>
					</xsl:if>
					<xsl:if test="@downloadUrl">
						<fo:block>
							<xsl:value-of select="$label_download"/>
							<xsl:text>: </xsl:text>
							<fo:basic-link>
								<xsl:attribute name="external-destination">
									<xsl:value-of select="@downloadUrl"/>
								</xsl:attribute>
								<xsl:value-of select="@downloadUrl"/>
							</fo:basic-link>
						</fo:block>
					</xsl:if>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<xsl:template match="elml:thesis">
		<xsl:param name="comment"/>
		<xsl:param name="furtherReading"/>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block font-family="Courier" font-size="{$fontsize}*1.5" line-height="{$lineheight}" padding-before="2pt">&#x2022;</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:if test="not($furtherReading)">
						<xsl:attribute name="id">
							<xsl:value-of select="generate-id(.)"/>
						</xsl:attribute>
					</xsl:if>
					<fo:inline font-weight="bold" font-variant="small-caps">
						<xsl:choose>
							<xsl:when test="@author">
								<xsl:value-of select="@author"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$label_anon"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
					<xsl:choose>
						<xsl:when test="@publicationYear">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="@publicationYear"/>
							<xsl:text>. </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>. </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="@title">
						<fo:inline font-style="italic">
							<xsl:value-of select="@title"/>
						</fo:inline>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:value-of select="@designation"/>
					<xsl:if test="@type">
						<xsl:text> (</xsl:text>
						<xsl:value-of select="@type"/>
						<xsl:text>)</xsl:text>
					</xsl:if>
					<xsl:if test="@published='yes'">
						<xsl:text> published</xsl:text>
					</xsl:if>
					<xsl:text>. </xsl:text>
					<xsl:if test="@institution">
						<xsl:value-of select="@institution"/>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="text()">
						<fo:inline font-stretch="narrower">
							<xsl:text> [</xsl:text>
							<xsl:value-of select="text()"/>
							<xsl:text>]</xsl:text>
						</fo:inline>
					</xsl:if>
					<xsl:if test="$comment">
						<fo:block font-size="-1">
							<xsl:value-of select="$comment"/>
						</fo:block>
					</xsl:if>
					<xsl:if test="@downloadUrl">
						<fo:block>
							<xsl:value-of select="$label_download"/>
							<xsl:text>: </xsl:text>
							<fo:basic-link>
								<xsl:attribute name="external-destination">
									<xsl:value-of select="@downloadUrl"/>
								</xsl:attribute>
								<xsl:value-of select="@downloadUrl"/>
							</fo:basic-link>
						</fo:block>
					</xsl:if>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<xsl:template match="elml:patent">
		<xsl:param name="comment"/>
		<xsl:param name="furtherReading"/>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block font-family="Courier" font-size="{$fontsize}*1.5" line-height="{$lineheight}" padding-before="2pt">&#x2022;</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:if test="not($furtherReading)">
						<xsl:attribute name="id">
							<xsl:value-of select="generate-id(.)"/>
						</xsl:attribute>
					</xsl:if>
					<fo:inline font-weight="bold" font-variant="small-caps">
						<xsl:choose>
							<xsl:when test="@author">
								<xsl:value-of select="@author"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$label_anon"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
					<xsl:choose>
						<xsl:when test="@publicationYear">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="@publicationYear"/>
							<xsl:text>. </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>. </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="@title">
						<fo:inline font-style="italic">
							<xsl:value-of select="@title"/>
						</fo:inline>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="@designation">
						<xsl:value-of select="@designation"/>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="text()">
						<fo:inline font-stretch="narrower">
							<xsl:text> [</xsl:text>
							<xsl:value-of select="text()"/>
							<xsl:text>]</xsl:text>
						</fo:inline>
					</xsl:if>
					<xsl:if test="$comment">
						<fo:block font-size="-1">
							<xsl:value-of select="$comment"/>
						</fo:block>
					</xsl:if>
					<xsl:if test="@downloadUrl">
						<fo:block>
							<xsl:value-of select="$label_download"/>
							<xsl:text>: </xsl:text>
							<fo:basic-link>
								<xsl:attribute name="external-destination">
									<xsl:value-of select="@downloadUrl"/>
								</xsl:attribute>
								<xsl:value-of select="@downloadUrl"/>
							</fo:basic-link>
						</fo:block>
					</xsl:if>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<xsl:template match="elml:videoFilmBroadcast">
		<xsl:param name="comment"/>
		<xsl:param name="furtherReading"/>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block font-family="Courier" font-size="{$fontsize}*1.5" line-height="{$lineheight}" padding-before="2pt">&#x2022;</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:if test="not($furtherReading)">
						<xsl:attribute name="id">
							<xsl:value-of select="generate-id(.)"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="@title">
						<fo:inline font-style="italic">
							<xsl:value-of select="@title"/>
						</fo:inline>
						<xsl:if test="@publicationYear">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:if>
					<xsl:value-of select="@publicationYear"/>
					<xsl:text>. </xsl:text>
					<xsl:if test="@designation">
						<xsl:value-of select="@designation"/>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="@author">
						<xsl:text>By </xsl:text>
						<xsl:value-of select="@author"/>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="@productionPlace">
						<xsl:value-of select="@productionPlace"/>
					</xsl:if>
					<xsl:if test="@productionOrganisation">
						<xsl:if test="@productionPlace">
							<xsl:text>: </xsl:text>
						</xsl:if>
						<xsl:value-of select="@productionOrganisation"/>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="text()">
						<fo:inline font-stretch="narrower">
							<xsl:text> [</xsl:text>
							<xsl:value-of select="text()"/>
							<xsl:text>]</xsl:text>
						</fo:inline>
					</xsl:if>
					<xsl:if test="$comment">
						<fo:block font-size="-1">
							<xsl:value-of select="$comment"/>
						</fo:block>
					</xsl:if>
					<xsl:if test="@downloadUrl">
						<fo:block>
							<xsl:value-of select="$label_download"/>
							<xsl:text>: </xsl:text>
							<fo:basic-link>
								<xsl:attribute name="external-destination">
									<xsl:value-of select="@downloadUrl"/>
								</xsl:attribute>
								<xsl:value-of select="@downloadUrl"/>
							</fo:basic-link>
						</fo:block>
					</xsl:if>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<xsl:template match="elml:websites">
		<xsl:param name="comment"/>
		<xsl:param name="furtherReading"/>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block font-family="Courier" font-size="{$fontsize}*1.5" line-height="{$lineheight}" padding-before="2pt">&#x2022;</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:if test="not($furtherReading)">
						<xsl:attribute name="id">
							<xsl:value-of select="generate-id(.)"/>
						</xsl:attribute>
					</xsl:if>
					<fo:inline font-weight="bold" font-variant="small-caps">
						<xsl:choose>
							<xsl:when test="@author">
								<xsl:value-of select="@author"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$label_anon"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
					<xsl:choose>
						<xsl:when test="@publicationYear">
							<xsl:text> (</xsl:text>
							<xsl:value-of select="@publicationYear"/>
							<xsl:text>). </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>. </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="@title">
						<fo:inline font-style="italic">
							<xsl:value-of select="@title"/>
						</fo:inline>
						<xsl:text> [online]. </xsl:text>
					</xsl:if>
					<xsl:if test="@edition">
						<xsl:text> (</xsl:text>
						<xsl:value-of select="@edition"/>
						<xsl:text>). </xsl:text>
					</xsl:if>
					<xsl:if test="@publicationPlace">
						<xsl:value-of select="@publicationPlace"/>
					</xsl:if>
					<xsl:if test="@publisher">
						<xsl:if test="@publicationPlace">
							<xsl:text>: </xsl:text>
						</xsl:if>
						<xsl:value-of select="@publisher"/>
					</xsl:if>
					<xsl:if test="@publisher or @publicationPlace">
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="@url">
						<xsl:text>Available from: </xsl:text>
						<fo:basic-link color="black">
							<xsl:attribute name="external-destination">
								<xsl:value-of select="@url"/>
							</xsl:attribute>
							<xsl:value-of select="@url"/>
						</fo:basic-link>
						<xsl:if test="@accessedDate">
							<xsl:text> [Accessed </xsl:text>
							<xsl:value-of select="@accessedDate"/>
							<xsl:text>]</xsl:text>
						</xsl:if>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="text()">
						<fo:inline font-stretch="narrower">
							<xsl:text> [</xsl:text>
							<xsl:value-of select="text()"/>
							<xsl:text>]</xsl:text>
						</fo:inline>
					</xsl:if>
					<xsl:if test="$comment">
						<fo:block font-size="-1">
							<xsl:value-of select="$comment"/>
						</fo:block>
					</xsl:if>
					<xsl:if test="@downloadUrl">
						<fo:block>
							<xsl:value-of select="$label_download"/>
							<xsl:text>: </xsl:text>
							<fo:basic-link>
								<xsl:attribute name="external-destination">
									<xsl:value-of select="@downloadUrl"/>
								</xsl:attribute>
								<xsl:value-of select="@downloadUrl"/>
							</fo:basic-link>
						</fo:block>
					</xsl:if>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<xsl:template match="elml:eJournals">
		<xsl:param name="comment"/>
		<xsl:param name="furtherReading"/>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block font-family="Courier" font-size="{$fontsize}*1.5" line-height="{$lineheight}" padding-before="2pt">&#x2022;</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:if test="not($furtherReading)">
						<xsl:attribute name="id">
							<xsl:value-of select="generate-id(.)"/>
						</xsl:attribute>
					</xsl:if>
					<fo:inline font-weight="bold" font-variant="small-caps">
						<xsl:choose>
							<xsl:when test="@author">
								<xsl:value-of select="@author"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$label_anon"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
					<xsl:choose>
						<xsl:when test="@publicationYear">
							<xsl:text> (</xsl:text>
							<xsl:value-of select="@publicationYear"/>
							<xsl:text>). </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>. </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="@title">
						<xsl:value-of select="@title"/>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="@journalTitle">
						<fo:inline font-style="italic">
							<xsl:value-of select="@journalTitle"/>
						</fo:inline>
						<xsl:text> [online]</xsl:text>
						<xsl:if test="@volumeNr">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="@volumeNr"/>
						</xsl:if>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="@url">
						<xsl:text>Available from: </xsl:text>
						<fo:basic-link color="black">
							<xsl:attribute name="external-destination">
								<xsl:value-of select="@url"/>
							</xsl:attribute>
							<xsl:value-of select="@url"/>
						</fo:basic-link>
						<xsl:if test="@accessedDate">
							<xsl:text> [Accessed </xsl:text>
							<xsl:value-of select="@accessedDate"/>
							<xsl:text>]</xsl:text>
						</xsl:if>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="text()">
						<fo:inline font-stretch="narrower">
							<xsl:text> [</xsl:text>
							<xsl:value-of select="text()"/>
							<xsl:text>]</xsl:text>
						</fo:inline>
					</xsl:if>
					<xsl:if test="$comment">
						<fo:block font-size="-1">
							<xsl:value-of select="$comment"/>
						</fo:block>
					</xsl:if>
					<xsl:if test="@downloadUrl">
						<fo:block>
							<xsl:value-of select="$label_download"/>
							<xsl:text>: </xsl:text>
							<fo:basic-link>
								<xsl:attribute name="external-destination">
									<xsl:value-of select="@downloadUrl"/>
								</xsl:attribute>
								<xsl:value-of select="@downloadUrl"/>
							</fo:basic-link>
						</fo:block>
					</xsl:if>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<xsl:template match="elml:mailLists">
		<xsl:param name="comment"/>
		<xsl:param name="furtherReading"/>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block font-family="Courier" font-size="{$fontsize}*1.5" line-height="{$lineheight}" padding-before="2pt">&#x2022;</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:if test="not($furtherReading)">
						<xsl:attribute name="id">
							<xsl:value-of select="generate-id(.)"/>
						</xsl:attribute>
					</xsl:if>
					<fo:inline font-weight="bold" font-variant="small-caps">
						<xsl:choose>
							<xsl:when test="@author">
								<xsl:value-of select="@author"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$label_anon"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
					<xsl:if test="@dayMonthYear">
						<xsl:text> (</xsl:text>
						<xsl:value-of select="@dayMonthYear"/>
						<xsl:text>)</xsl:text>
					</xsl:if>
					<xsl:text>. </xsl:text>
					<xsl:if test="@subject">
						<xsl:value-of select="@subject"/>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="@discussionList">
						<fo:inline font-style="italic">
							<xsl:value-of select="@discussionList"/>
						</fo:inline>
						<xsl:text> [online]. </xsl:text>
					</xsl:if>
					<xsl:if test="@url">
						<xsl:text>Available from: </xsl:text>
						<fo:basic-link color="black">
							<xsl:attribute name="external-destination">
								<xsl:text>mailto:</xsl:text>
								<xsl:value-of select="@url"/>
							</xsl:attribute>
							<xsl:value-of select="@url"/>
						</fo:basic-link>
						<xsl:if test="@accessedDate">
							<xsl:text> [Accessed </xsl:text>
							<xsl:value-of select="@accessedDate"/>
							<xsl:text>]</xsl:text>
						</xsl:if>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="text()">
						<fo:inline font-stretch="narrower">
							<xsl:text> [</xsl:text>
							<xsl:value-of select="text()"/>
							<xsl:text>]</xsl:text>
						</fo:inline>
					</xsl:if>
					<xsl:if test="$comment">
						<fo:block font-size="-1">
							<xsl:value-of select="$comment"/>
						</fo:block>
					</xsl:if>
					<xsl:if test="@downloadUrl">
						<fo:block>
							<xsl:value-of select="$label_download"/>
							<xsl:text>: </xsl:text>
							<fo:basic-link>
								<xsl:attribute name="external-destination">
									<xsl:value-of select="@downloadUrl"/>
								</xsl:attribute>
								<xsl:value-of select="@downloadUrl"/>
							</fo:basic-link>
						</fo:block>
					</xsl:if>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<xsl:template match="elml:personalMail">
		<xsl:param name="comment"/>
		<xsl:param name="furtherReading"/>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block font-family="Courier" font-size="{$fontsize}*1.5" line-height="{$lineheight}" padding-before="2pt">&#x2022;</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:if test="not($furtherReading)">
						<xsl:attribute name="id">
							<xsl:value-of select="generate-id(.)"/>
						</xsl:attribute>
					</xsl:if>
					<fo:inline font-weight="bold" font-variant="small-caps">
						<xsl:choose>
							<xsl:when test="@author">
								<xsl:value-of select="@author"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$label_anon"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
					<xsl:if test="@emailSender">
						<xsl:text> (</xsl:text>
						<fo:basic-link color="black">
							<xsl:attribute name="external-destination">
								<xsl:text>mailto:</xsl:text>
								<xsl:value-of select="@emailSender"/>
							</xsl:attribute>
							<xsl:value-of select="@emailSender"/>
						</fo:basic-link>
						<xsl:text>)</xsl:text>
					</xsl:if>
					<xsl:text>. </xsl:text>
					<xsl:if test="@dayMonthYear">
						<xsl:text> (</xsl:text>
						<xsl:value-of select="@dayMonthYear"/>
						<xsl:text>). </xsl:text>
					</xsl:if>
					<xsl:if test="@subject">
						<fo:inline font-style="italic">
							<xsl:value-of select="@subject"/>
						</fo:inline>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="@recipient">
						<xsl:text> e-Mail to </xsl:text>
						<xsl:value-of select="@recipient"/>
						<xsl:if test="@emailRecipient">
							<xsl:text> (</xsl:text>
							<fo:basic-link color="black">
								<xsl:attribute name="external-destination">
									<xsl:text>mailto:</xsl:text>
									<xsl:value-of select="@emailRecipient"/>
								</xsl:attribute>
								<xsl:value-of select="@emailRecipient"/>
							</fo:basic-link>
							<xsl:text>)</xsl:text>
						</xsl:if>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="@published='yes'">
						<xsl:text> Published.</xsl:text>
					</xsl:if>
					<xsl:if test="text()">
						<fo:inline font-stretch="narrower">
							<xsl:text> [</xsl:text>
							<xsl:value-of select="text()"/>
							<xsl:text>]</xsl:text>
						</fo:inline>
					</xsl:if>
					<xsl:if test="$comment">
						<fo:block font-size="-1">
							<xsl:value-of select="$comment"/>
						</fo:block>
					</xsl:if>
					<xsl:if test="@downloadUrl">
						<fo:block>
							<xsl:value-of select="$label_download"/>
							<xsl:text>: </xsl:text>
							<fo:basic-link>
								<xsl:attribute name="external-destination">
									<xsl:value-of select="@downloadUrl"/>
								</xsl:attribute>
								<xsl:value-of select="@downloadUrl"/>
							</fo:basic-link>
						</fo:block>
					</xsl:if>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<xsl:template match="elml:cdRom">
		<xsl:param name="comment"/>
		<xsl:param name="furtherReading"/>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block font-family="Courier" font-size="{$fontsize}*1.5" line-height="{$lineheight}" padding-before="2pt">&#x2022;</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:if test="not($furtherReading)">
						<xsl:attribute name="id">
							<xsl:value-of select="generate-id(.)"/>
						</xsl:attribute>
					</xsl:if>
					<fo:inline font-weight="bold" font-variant="small-caps">
						<xsl:choose>
							<xsl:when test="@author">
								<xsl:value-of select="@author"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$label_anon"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
					<xsl:if test="@publicationYear">
						<xsl:text> (</xsl:text>
						<xsl:value-of select="@publicationYear"/>
						<xsl:text>)</xsl:text>
					</xsl:if>
					<xsl:text>. </xsl:text>
					<xsl:if test="@title">
						<fo:inline font-style="italic">
							<xsl:value-of select="@title"/>
						</fo:inline>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:text> [CD-ROM]. </xsl:text>
					<xsl:if test="@edition">
						<xsl:value-of select="@edition"/>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="@publicationPlace">
						<xsl:value-of select="@publicationPlace"/>
					</xsl:if>
					<xsl:if test="@publisher">
						<xsl:if test="@publicationPlace">
							<xsl:text>: </xsl:text>
						</xsl:if>
						<xsl:value-of select="@publisher"/>
					</xsl:if>
					<xsl:if test="@publisher or @publicationPlace">
						<xsl:text>. </xsl:text>
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:if test="@supplier">
						<xsl:text>Available from: </xsl:text>
						<xsl:value-of select="@supplier"/>
						<xsl:if test="@accessedDate">
							<xsl:text> [Accessed </xsl:text>
							<xsl:value-of select="@accessedDate"/>
							<xsl:text>]</xsl:text>
						</xsl:if>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="text()">
						<fo:inline font-stretch="narrower">
							<xsl:text> [</xsl:text>
							<xsl:value-of select="text()"/>
							<xsl:text>]</xsl:text>
						</fo:inline>
					</xsl:if>
					<xsl:if test="$comment">
						<fo:block font-size="-1">
							<xsl:value-of select="$comment"/>
						</fo:block>
					</xsl:if>
					<xsl:if test="@downloadUrl">
						<fo:block>
							<xsl:value-of select="$label_download"/>
							<xsl:text>: </xsl:text>
							<fo:basic-link>
								<xsl:attribute name="external-destination">
									<xsl:value-of select="@downloadUrl"/>
								</xsl:attribute>
								<xsl:value-of select="@downloadUrl"/>
							</fo:basic-link>
						</fo:block>
					</xsl:if>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
</xsl:stylesheet>
