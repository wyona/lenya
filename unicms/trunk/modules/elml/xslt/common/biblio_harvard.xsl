<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.elml.ch"
  xmlns:elml="http://www.elml.ch">


  <xsl:template match="elml:book">
    <xsl:param name="comment"/>
    <xsl:param name="furtherReading"/>
    <xsl:param name="name_anon">unknown</xsl:param>
    <xsl:param name="name_download"/>
    <li> 
      <b class="bibAuthor">
        <xsl:choose>
          <xsl:when test="@author">
            <xsl:value-of select="@author"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$name_anon"/>
          </xsl:otherwise>
        </xsl:choose>
      </b>
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
        <i class="bibTitle">
          <xsl:value-of select="@title"/>
        </i>
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
        <span class="bibCommentSource"> 
          <xsl:text> [</xsl:text>
          <xsl:value-of select="text()"/>
          <xsl:text>]</xsl:text>
        </span>
      </xsl:if>
      <xsl:if test="$comment">
        <span class="bibCommentFurther">
          <br/>
          <xsl:value-of select="$comment"/>
        </span>
      </xsl:if>
      <xsl:if test="@downloadUrl">
        <xsl:text> (</xsl:text>
        <a target="_blank">
          <xsl:attribute name="href">
            <xsl:value-of select="@downloadUrl"/>
          </xsl:attribute>
          <xsl:value-of select="$name_download"/>
        </a>
        <xsl:text>)</xsl:text>
      </xsl:if> 
    </li> 
  </xsl:template>


  <xsl:template match="elml:contributionInBook">
    <xsl:param name="comment"/>
    <xsl:param name="furtherReading"/>
    <xsl:param name="name_anon">unknown</xsl:param>
    <xsl:param name="name_download"/>

    <xsl:param name="furtherReading"/>
      <li>
        <b class="bibAuthor">
          <xsl:choose>
            <xsl:when test="@author">
              <xsl:value-of select="@author"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$name_anon"/>
            </xsl:otherwise>
           </xsl:choose>
         </b>
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
         <i class="bibTitle">
           <xsl:text>In: </xsl:text>
         </i>
         <xsl:if test="@editor">
           <b class="bibAuthor">
             <xsl:value-of select="@editor"/>
           </b>
           <xsl:text>, ed. </xsl:text>
         </xsl:if>
         <xsl:if test="@title">
           <i class="bibTitle">
             <xsl:value-of select="@title"/>
           </i>
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
           <span class="bibCommentSource">
             <xsl:text> [</xsl:text>
             <xsl:value-of select="text()"/>
             <xsl:text>]</xsl:text>
           </span>
         </xsl:if>
         <xsl:if test="$comment">
           <span class="bibCommentFurther">
             <br/>
             <xsl:value-of select="$comment"/>
           </span>
         </xsl:if>
         <xsl:if test="@downloadUrl">
           <xsl:text> (</xsl:text>
             <a target="_blank">
               <xsl:attribute name="href">
                 <xsl:value-of select="@downloadUrl"/>
               </xsl:attribute>
               <xsl:value-of select="$name_download"/>
             </a>
           <xsl:text>)</xsl:text>
         </xsl:if>
       </li>
     </xsl:template>

     <xsl:template match="elml:journalArticle">
       <xsl:param name="comment"/>
       <xsl:param name="furtherReading"/>
       <xsl:param name="name_anon">unknown</xsl:param>
       <xsl:param name="name_download"/>

       <li>
         <b class="bibAuthor">
           <xsl:choose>
             <xsl:when test="@author">
               <xsl:value-of select="@author"/>
             </xsl:when>
             <xsl:otherwise>
               <xsl:value-of select="$name_anon"/>
             </xsl:otherwise>
           </xsl:choose>
          </b>
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
            <i class="bibTitle">
              <xsl:value-of select="@journalTitle"/>
            </i>
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
            <span class="bibCommentSource">
              <xsl:text> [</xsl:text>
              <xsl:value-of select="text()"/>
              <xsl:text>]</xsl:text>
            </span>
          </xsl:if>
          <xsl:if test="$comment">
            <span class="bibCommentFurther">
              <br/>
              <xsl:value-of select="$comment"/>
            </span>
          </xsl:if>
          <xsl:if test="@downloadUrl">
            <xsl:text> (</xsl:text>
              <a target="_blank">
                <xsl:attribute name="href">
                  <xsl:value-of select="@downloadUrl"/>
                </xsl:attribute>
                <xsl:value-of select="$name_download"/>
              </a>
             <xsl:text>)</xsl:text>
          </xsl:if>
        </li>
      </xsl:template>

    <xsl:template match="elml:newspaperArticle">

     <xsl:param name="comment"/>
     <xsl:param name="furtherReading"/>
     <xsl:param name="name_anon">unknown</xsl:param>
     <xsl:param name="name_download"/>

     <li>
       <b class="bibAuthor">
         <xsl:choose>
           <xsl:when test="@author">
             <xsl:value-of select="@author"/>
           </xsl:when>
           <xsl:otherwise>
             <xsl:value-of select="$name_anon"/>
           </xsl:otherwise>
         </xsl:choose>
       </b>
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
         <i class="bibTitle">
           <xsl:value-of select="@newspaperTitle"/>
         </i>
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
         <span class="bibCommentSource">
           <xsl:text> [</xsl:text>
           <xsl:value-of select="text()"/>
           <xsl:text>]</xsl:text>
         </span>
        </xsl:if>
        <xsl:if test="$comment">
          <span class="bibCommentFurther">
            <br/>
            <xsl:value-of select="$comment"/>
          </span>
        </xsl:if>
        <xsl:if test="@downloadUrl">
          <xsl:text> (</xsl:text>
          <a target="_blank">
            <xsl:attribute name="href">
              <xsl:value-of select="@downloadUrl"/>
            </xsl:attribute>
            <xsl:value-of select="$name_download"/>
          </a>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </li>
    </xsl:template>


    <xsl:template match="elml:map">
      <xsl:param name="comment"/>
      <xsl:param name="furtherReading"/>
      <xsl:param name="name_anon">unknown</xsl:param>
      <xsl:param name="name_download"/>
      
      <li>
         <b class="bibAuthor">
           <xsl:choose>
             <xsl:when test="@author">
               <xsl:value-of select="@author"/>
             </xsl:when>
             <xsl:otherwise>
               <xsl:value-of select="$name_anon"/>
             </xsl:otherwise>
           </xsl:choose>
         </b>
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
           <span class="bibCommentSource">
             <xsl:text> [</xsl:text>
             <xsl:value-of select="text()"/>
             <xsl:text>]</xsl:text>
           </span>
         </xsl:if>
         <xsl:if test="$comment">
           <span class="bibCommentFurther">
             <br/>
             <xsl:value-of select="$comment"/>
           </span>
         </xsl:if>
         <xsl:if test="@downloadUrl">
           <xsl:text> (</xsl:text>
           <a target="_blank">
             <xsl:attribute name="href">
               <xsl:value-of select="@downloadUrl"/>
             </xsl:attribute>
             <xsl:value-of select="$name_download"/>
           </a>
           <xsl:text>)</xsl:text>
         </xsl:if>
       </li>
     </xsl:template>


     <xsl:template match="elml:conferencePaper">

       <xsl:param name="comment"/>
       <xsl:param name="furtherReading"/>
       <xsl:param name="name_anon">unknown</xsl:param>
       <xsl:param name="name_download"/>

       <li>
         <b class="bibAuthor">
           <xsl:choose>
             <xsl:when test="@author">
               <xsl:value-of select="@author"/>
             </xsl:when>
             <xsl:otherwise>
               <xsl:value-of select="$name_anon"/>
             </xsl:otherwise>
           </xsl:choose>
         </b>
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
         <i class="bibTitle">
           <xsl:text>In: </xsl:text>
         </i>
         <xsl:if test="@editor">
           <b class="bibAuthor">
             <xsl:value-of select="@editor"/>
           </b>
           <xsl:text>, ed. </xsl:text>
         </xsl:if>
         <xsl:if test="@proceedingsTitle">
           <i class="bibTitle">
             <xsl:value-of select="@proceedingsTitle"/>
             <xsl:if test="@datePlace">
               <xsl:text>, </xsl:text>
               <xsl:value-of select="@datePlace"/>
             </xsl:if>
           </i>
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
           <span class="bibCommentSource">
             <xsl:text> [</xsl:text>
             <xsl:value-of select="text()"/>
             <xsl:text>]</xsl:text>
           </span>
         </xsl:if>
        <xsl:if test="$comment">
          <span class="bibCommentFurther">
            <br/>
            <xsl:value-of select="$comment"/>
          </span>
        </xsl:if>
        <xsl:if test="@downloadUrl">
          <xsl:text> (</xsl:text>
          <a target="_blank">
            <xsl:attribute name="href">
              <xsl:value-of select="@downloadUrl"/>
            </xsl:attribute>
            <xsl:value-of select="$name_download"/>
          </a>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </li>
    </xsl:template>


    <xsl:template match="elml:publicationCorporateBody">
      <xsl:param name="comment"/>
      <xsl:param name="furtherReading"/>
      <xsl:param name="name_anon">unknown</xsl:param>
      <xsl:param name="name_download"/>
      <li>
         <b class="bibAuthor">
           <xsl:choose>
             <xsl:when test="@author">
               <xsl:value-of select="@author"/>
             </xsl:when>
             <xsl:otherwise>
               <xsl:value-of select="$name_anon"/>
             </xsl:otherwise>
           </xsl:choose>
         </b>
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
         <i class="bibTitle">
           <xsl:value-of select="@title"/>
         </i>
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
         <span class="bibCommentSource">
           <xsl:text> [</xsl:text>
           <xsl:value-of select="text()"/>
           <xsl:text>]</xsl:text>
         </span>
       </xsl:if>
       <xsl:if test="$comment">
         <span class="bibCommentFurther">
           <br/>
           <xsl:value-of select="$comment"/>
         </span>
       </xsl:if>
       <xsl:if test="@downloadUrl">
         <xsl:text> (</xsl:text>
         <a target="_blank">
           <xsl:attribute name="href">
             <xsl:value-of select="@downloadUrl"/>
           </xsl:attribute>
           <xsl:value-of select="$name_download"/>
         </a>
         <xsl:text>)</xsl:text>
       </xsl:if>
     </li>
   </xsl:template>

 
   <xsl:template match="elml:thesis">
     <xsl:param name="comment"/>
     <xsl:param name="furtherReading"/>
     <xsl:param name="name_anon">unknown</xsl:param>
     <xsl:param name="name_download"/>
 
     <xsl:param name="furtherReading"/>
       <li>
         <b class="bibAuthor">
           <xsl:choose>
             <xsl:when test="@author">
               <xsl:value-of select="@author"/>
             </xsl:when>
             <xsl:otherwise>
               <xsl:value-of select="$name_anon"/>
             </xsl:otherwise>
           </xsl:choose>
         </b>
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
           <i class="bibTitle">
             <xsl:value-of select="@title"/>
           </i>
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
           <span class="bibCommentSource">
             <xsl:text> [</xsl:text>
             <xsl:value-of select="text()"/>
             <xsl:text>]</xsl:text>
           </span>
         </xsl:if>
         <xsl:if test="$comment">
           <span class="bibCommentFurther">
             <br/>
             <xsl:value-of select="$comment"/>
           </span>        
         </xsl:if>
         <xsl:if test="@downloadUrl">
           <xsl:text> (</xsl:text>
             <a target="_blank">
               <xsl:attribute name="href">
                 <xsl:value-of select="@downloadUrl"/>
               </xsl:attribute>
               <xsl:value-of select="$name_download"/>
             </a>
             <xsl:text>)</xsl:text>
           </xsl:if>
         </li>
      </xsl:template>

  
    <xsl:template match="elml:patent">
      <xsl:param name="comment"/>
      <xsl:param name="furtherReading"/>
      <xsl:param name="name_anon">unknown</xsl:param>
      <xsl:param name="name_download"/>      

      <li>
        <b class="bibAuthor">
          <xsl:choose>
            <xsl:when test="@author">
              <xsl:value-of select="@author"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$name_anon"/>
            </xsl:otherwise>
          </xsl:choose>
        </b>
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
          <i class="bibTitle">
            <xsl:value-of select="@title"/>
          </i>
          <xsl:text>. </xsl:text>
        </xsl:if>
        <xsl:if test="@designation">
          <xsl:value-of select="@designation"/>
          <xsl:text>. </xsl:text>
        </xsl:if>
        <xsl:if test="text()">
          <span class="bibCommentSource">
            <xsl:text> [</xsl:text>
            <xsl:value-of select="text()"/>
            <xsl:text>]</xsl:text>
          </span>
        </xsl:if>
        <xsl:if test="$comment">
          <span class="bibCommentFurther">
            <br/>
            <xsl:value-of select="$comment"/>
          </span>
         </xsl:if>
         <xsl:if test="@downloadUrl">
           <xsl:text> (</xsl:text>
           <a target="_blank">
             <xsl:attribute name="href">
               <xsl:value-of select="@downloadUrl"/>
             </xsl:attribute>
             <xsl:value-of select="$name_download"/>
           </a>
           <xsl:text>)</xsl:text>
         </xsl:if>
       </li>
     </xsl:template>


     <xsl:template match="elml:videoFilmBroadcast">
       <xsl:param name="comment"/>
       <xsl:param name="furtherReading"/>
       <xsl:param name="name_anon">unknown</xsl:param>
       <xsl:param name="name_download"/>

       <li> 
         <xsl:if test="@title">
           <i class="bibTitle">
             <xsl:value-of select="@title"/>
           </i>
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
             <span class="bibCommentSource">
               <xsl:text> [</xsl:text>
               <xsl:value-of select="text()"/>
               <xsl:text>]</xsl:text>
             </span>
           </xsl:if>
           <xsl:if test="$comment">
             <span class="bibCommentFurther">
               <br/>
               <xsl:value-of select="$comment"/>
             </span>
           </xsl:if>
           <xsl:if test="@downloadUrl">
             <xsl:text> (</xsl:text>
             <a target="_blank">
               <xsl:attribute name="href">
                 <xsl:value-of select="@downloadUrl"/>
               </xsl:attribute>
               <xsl:value-of select="$name_download"/>
             </a>
             <xsl:text>)</xsl:text>
           </xsl:if>
        </li>
      </xsl:template>

 

  <xsl:template match="elml:websites">

    <xsl:param name="comment"/>
    <xsl:param name="furtherReading"/>
    <xsl:param name="name_anon">unknown</xsl:param>
    <xsl:param name="name_download"/>

    <li>
       <b class="bibAuthor">
         <xsl:choose>
           <xsl:when test="@author">
             <xsl:value-of select="@author"/>
           </xsl:when>
           <xsl:otherwise>
             <xsl:value-of select="$name_anon"/>
           </xsl:otherwise>
         </xsl:choose>
       </b>
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
         <i class="bibTitle">
           <xsl:value-of select="@title"/>
         </i>
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
         <xsl:element name="a">
           <xsl:attribute name="href">
             <xsl:value-of select="@url"/>
           </xsl:attribute>
           <xsl:attribute name="target">
             <xsl:text>_blank</xsl:text>
           </xsl:attribute>
           <xsl:value-of select="@url"/>
         </xsl:element>
         <xsl:if test="@accessedDate">
           <xsl:text> [Accessed </xsl:text>
           <xsl:value-of select="@accessedDate"/>
           <xsl:text>]</xsl:text>
         </xsl:if>
         <xsl:text>. </xsl:text>
       </xsl:if>
       <xsl:if test="text()">
         <span class="bibCommentSource">
           <xsl:text> [</xsl:text>
           <xsl:value-of select="text()"/>
           <xsl:text>]</xsl:text>
         </span>
       </xsl:if>
       <xsl:if test="$comment">
         <span class="bibCommentFurther">
           <br/>
           <xsl:value-of select="$comment"/>
         </span>
       </xsl:if>
       <xsl:if test="@downloadUrl">
         <xsl:text> (</xsl:text>
         <a target="_blank">
           <xsl:attribute name="href">
             <xsl:value-of select="@downloadUrl"/>
           </xsl:attribute>
           <xsl:value-of select="$name_download"/>
         </a>
         <xsl:text>)</xsl:text>
       </xsl:if>
      </li>
    </xsl:template>


    <xsl:template match="elml:eJournals">
      <xsl:param name="comment"/>
      <xsl:param name="furtherReading"/>
      <xsl:param name="name_anon">unknown</xsl:param>
      <xsl:param name="name_download"/>

      <li>
        <b class="bibAuthor">
          <xsl:choose>
            <xsl:when test="@author">
              <xsl:value-of select="@author"/>
            </xsl:when>
	    <xsl:otherwise>
              <xsl:value-of select="$name_anon"/>
            </xsl:otherwise>
          </xsl:choose>
        </b>
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
          <i class="bibTitle">
            <xsl:value-of select="@journalTitle"/>
          </i>
          <xsl:text> [online]</xsl:text>
          <xsl:if test="@volumeNr">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="@volumeNr"/>
          </xsl:if>
          <xsl:text>. </xsl:text>
        </xsl:if>
        <xsl:if test="@url">
          <xsl:text>Available from: </xsl:text>
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="@url"/>
            </xsl:attribute>
            <xsl:attribute name="target">
              <xsl:text>_blank</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="@url"/>
          </xsl:element>
          <xsl:if test="@accessedDate">
            <xsl:text> [Accessed </xsl:text>
            <xsl:value-of select="@accessedDate"/>
            <xsl:text>]</xsl:text>
          </xsl:if>
          <xsl:text>. </xsl:text>
        </xsl:if>
        <xsl:if test="text()">
          <span class="bibCommentSource">
            <xsl:text> [</xsl:text>
            <xsl:value-of select="text()"/>
            <xsl:text>]</xsl:text>
          </span>
        </xsl:if>
        <xsl:if test="$comment">
          <span class="bibCommentFurther">
            <br/>
          <xsl:value-of select="$comment"/>
          </span>
        </xsl:if>
        <xsl:if test="@downloadUrl">
          <xsl:text> (</xsl:text>
          <a target="_blank">
            <xsl:attribute name="href">
              <xsl:value-of select="@downloadUrl"/>
            </xsl:attribute>
            <xsl:value-of select="$name_download"/>
          </a>
          <xsl:text>)</xsl:text>
        </xsl:if>
    </li>
  </xsl:template>


  <xsl:template match="elml:mailLists">

     <xsl:param name="comment"/>
     <xsl:param name="furtherReading"/>
     <xsl:param name="name_anon">unknown</xsl:param>
     <xsl:param name="name_download"/>

     <li>
       <b class="bibAuthor">
         <xsl:choose>
           <xsl:when test="@author">
             <xsl:value-of select="@author"/>
           </xsl:when>
           <xsl:otherwise>
             <xsl:value-of select="$name_anon"/>
           </xsl:otherwise>
         </xsl:choose>
       </b>
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
         <i class="bibTitle">
           <xsl:value-of select="@discussionList"/>
         </i>
         <xsl:text> [online]. </xsl:text>
       </xsl:if>
       <xsl:if test="@url">
         <xsl:text>Available from: </xsl:text>
         <xsl:element name="a">
           <xsl:attribute name="href">
             <xsl:text>mailto:</xsl:text>
             <xsl:value-of select="@url"/>
           </xsl:attribute>
           <xsl:value-of select="@url"/>
         </xsl:element>
         <xsl:if test="@accessedDate">
           <xsl:text> [Accessed </xsl:text>
             <xsl:value-of select="@accessedDate"/>
           <xsl:text>]</xsl:text>
         </xsl:if>
         <xsl:text>. </xsl:text>
       </xsl:if> 
       <xsl:if test="text()">
         <span class="bibCommentSource">
           <xsl:text> [</xsl:text>
           <xsl:value-of select="text()"/>
           <xsl:text>]</xsl:text>
         </span>
       </xsl:if>
       <xsl:if test="$comment">
         <span class="bibCommentFurther">
           <br/>
           <xsl:value-of select="$comment"/>
         </span>
       </xsl:if>
       <xsl:if test="@downloadUrl">
         <xsl:text> (</xsl:text>
           <a target="_blank">
             <xsl:attribute name="href">
               <xsl:value-of select="@downloadUrl"/>
             </xsl:attribute>
             <xsl:value-of select="$name_download"/>
           </a>
           <xsl:text>)</xsl:text>
        </xsl:if>
     </li>
  </xsl:template>

  <xsl:template match="elml:personalMail">
    <xsl:param name="comment"/>
    <xsl:param name="furtherReading"/>
    <xsl:param name="name_anon">unknown</xsl:param>
    <xsl:param name="name_download"/>

    <li>
      <b class="bibAuthor">
        <xsl:choose>
          <xsl:when test="@author">
            <xsl:value-of select="@author"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$name_anon"/>
          </xsl:otherwise>
        </xsl:choose>
      </b>
      <xsl:if test="@emailSender">
        <xsl:text> (</xsl:text>
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:text>mailto:</xsl:text>
            <xsl:value-of select="@emailSender"/>
          </xsl:attribute>
          <xsl:value-of select="@emailSender"/>
        </xsl:element>
        <xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:text>. </xsl:text>
      <xsl:if test="@dayMonthYear">
        <xsl:text> (</xsl:text>
        <xsl:value-of select="@dayMonthYear"/>
        <xsl:text>). </xsl:text>
      </xsl:if>
      <xsl:if test="@subject">
        <i class="bibTitle">
          <xsl:value-of select="@subject"/>
        </i>
        <xsl:text>. </xsl:text>
      </xsl:if>
      <xsl:if test="@recipient">
        <xsl:text> e-Mail to </xsl:text>
        <xsl:value-of select="@recipient"/>
        <xsl:if test="@emailRecipient">
          <xsl:text> (</xsl:text>
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:text>mailto:</xsl:text>
              <xsl:value-of select="@emailRecipient"/>
            </xsl:attribute>
            <xsl:value-of select="@emailRecipient"/>
          </xsl:element>
          <xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:text>. </xsl:text>
      </xsl:if>
      <xsl:if test="@published='yes'">
        <xsl:text> Published.</xsl:text>
      </xsl:if>
      <xsl:if test="text()">
        <span class="bibCommentSource">
          <xsl:text> [</xsl:text>
          <xsl:value-of select="text()"/>
          <xsl:text>]</xsl:text>
        </span>
      </xsl:if> 
      <xsl:if test="$comment">
        <span class="bibCommentFurther">
          <br/>
          <xsl:value-of select="$comment"/>
        </span>
      </xsl:if>
      <xsl:if test="@downloadUrl">
        <xsl:text> (</xsl:text>
        <a target="_blank">
          <xsl:attribute name="href">
            <xsl:value-of select="@downloadUrl"/>
          </xsl:attribute>
          <xsl:value-of select="$name_download"/>
        </a>
        <xsl:text>)</xsl:text>
      </xsl:if>
    </li>
  </xsl:template>


  <xsl:template match="elml:cdRom">

    <xsl:param name="comment"/>
    <xsl:param name="furtherReading"/>
    <xsl:param name="name_anon">unknown</xsl:param>
    <xsl:param name="name_download"/>

    <li>
       <b class="bibAuthor">
         <xsl:choose>
           <xsl:when test="@author">
             <xsl:value-of select="@author"/>
           </xsl:when>
           <xsl:otherwise>
             <xsl:value-of select="$name_anon"/>
           </xsl:otherwise>
         </xsl:choose>
       </b>
       <xsl:if test="@publicationYear">
         <xsl:text> (</xsl:text>
         <xsl:value-of select="@publicationYear"/>
         <xsl:text>)</xsl:text>
       </xsl:if>
       <xsl:text>. </xsl:text>
       <xsl:if test="@title">
         <i class="bibTitle">
           <xsl:value-of select="@title"/>
         </i>
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
          <span class="bibCommentSource">
            <xsl:text> [</xsl:text>
            <xsl:value-of select="text()"/>
            <xsl:text>]</xsl:text>
          </span>
        </xsl:if>
        <xsl:if test="$comment">
          <span class="bibCommentFurther">
            <br/>
            <xsl:value-of select="$comment"/>
          </span>
        </xsl:if>
        <xsl:if test="@downloadUrl">
          <xsl:text> (</xsl:text>
          <a target="_blank">
            <xsl:attribute name="href">
              <xsl:value-of select="@downloadUrl"/>
            </xsl:attribute>
            <xsl:value-of select="$name_download"/>
          </a>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </li>
  </xsl:template> 
</xsl:stylesheet>
