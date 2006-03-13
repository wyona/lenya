<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns=""> 
<xsl:output method="xml" indent="yes"/>

  <xsl:template match="css">
    <xsl:copy>
      <xsl:apply-templates select="text()"/>
    /* elml */

table.elml {
        border-width: 1px;
        border-spacing: 0px;
        border-style: solid;
        border-collapse: collapse;
}
table.elml th {
        border-width: 1px;
        padding: 3px;
        border-style: solid;
}
table.elml td {
        border-width: 1px;
        padding: 3px;
        border-style: solid;
}


.lowercase {
        text-transform:lowercase;
}

.uppercase {
        text-transform:lowercase;
}

.box {
        display: block;
        background-color: #ddd;
        margin-top: 15px;
        margin-bottom: 15px;
}

.term {
        color: #0000ff;
}

.bibliography {
        display:block;
}

.book {
        display:block;
}

.contributionInBook {
        display:block;
}

.journalArticle {
        display:block;
}

.newspaperArticle {
        display:block;
}

.map {
        display:block;
}

.conferencePaper {
        display:block;
}

.publicationCorporateBody {
        display:block;
}

.thesis {
        display:block;
}

.patent {
        display:block;
}


.videoFilmBroadcast {
        display:block;
}

.websites {
        display:block;
}

.eJournals {
        display:block;
}

.mailLists {
        display:block;
}

.personalMail {
        display:block;
}

.cdrom {
        display:block;
}
</xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet> 
