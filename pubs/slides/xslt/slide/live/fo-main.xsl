<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format">
  


<xsl:template match="/">
<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <fo:layout-master-set>
    <fo:simple-page-master 
      master-name="main"
      margin-top="75pt"
      margin-bottom="50pt"
      margin-left="75pt"
      margin-right="75pt">
      
      <fo:region-body margin-bottom="75pt"/>
      <fo:region-before extent="75pt"/>
      <fo:region-after  extent="50pt"/>
    </fo:simple-page-master>
  </fo:layout-master-set>

  <fo:page-sequence master-name="main">  
<!--
    <fo:static-content flow-name="xsl-region-before">
      <fo:block>
        <fo:external-graphic src="file:/home/michi/src/lenyacms/src/webapp/lenya/pubs/slides/resources/images/live/lenya_org.gif"/>
      </fo:block>    
    </fo:static-content>
-->
    
    <fo:static-content flow-name="xsl-region-after">
      <fo:block>
        <fo:leader leader-pattern="rule" leader-length.minimum="450pt" 
	  rule-thickness="1pt" start-indent="0pt" end-indent="0pt"
	  space-before.optimum="6pt" space-after.optimum="6pt"/>
      </fo:block>      
       <fo:list-block font-size="9pt" provisional-distance-between-starts="300pt" 
           provisional-label-separation="4pt">
        <fo:list-item>	
	  <fo:list-item-label text-align="start">
            <fo:block>
              <xsl:apply-templates select="/Slides/Meta"/>
            </fo:block>     	  
	  </fo:list-item-label>	  
	  <fo:list-item-body text-align="end">
            <fo:block>
              Page <fo:page-number/>	  
            </fo:block>     	  
	  </fo:list-item-body>	  
	</fo:list-item>
      </fo:list-block>        
   </fo:static-content>

    <fo:flow flow-name="xsl-region-body">   
      <fo:block>
        <fo:external-graphic src="file:/home/michi/src/lenyacms/src/webapp/lenya/pubs/slides/resources/images/live/wyona_klein.gif"/>
<!--
        <fo:external-graphic src="file:/home/michi/src/lenyacms/src/webapp/lenya/pubs/slides/resources/images/live/apache_lenya.png"/>
-->
<!--
        <fo:external-graphic src="file:/home/michi/src/lenyacms/src/webapp/lenya/pubs/slides/resources/images/live/lenya_org.gif"/>
-->
      </fo:block>    
     
      <xsl:for-each select="/Slides/Content/Slide">
        <xsl:choose>
          <xsl:when test="position()=1">
            <fo:block space-before.optimum="100pt" font-size="14pt" font-weight="bold">
              <xsl:value-of select="Content/Title"/>
            </fo:block>     
            <xsl:apply-templates select="."/>
          </xsl:when>
          <xsl:otherwise>
            <fo:block break-before="page" space-before.optimum="100pt" font-size="14pt" font-weight="bold">
              <xsl:value-of select="Content/Title"/>
            </fo:block>     
            <xsl:apply-templates select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>

    </fo:flow>       
    
 </fo:page-sequence>
 
</fo:root>
</xsl:template>



<xsl:template match="Slide">
  <xsl:apply-templates select="Content/Points"/>
  <xsl:apply-templates select="Content/Images"/>
</xsl:template>



<xsl:template match="Points">
       <fo:list-block provisional-distance-between-starts="50pt" 
           provisional-label-separation="20pt">
<xsl:for-each select="Point">
        <fo:list-item space-before.optimum="50pt">		
	  <fo:list-item-label text-align="end">
            <fo:block>&#183;</fo:block>     	  
	  </fo:list-item-label>	  
	  <fo:list-item-body text-align="start">
            <fo:block>
             <xsl:value-of select="Keywords"/>
            </fo:block>     	  
	  </fo:list-item-body>	  
	</fo:list-item>
</xsl:for-each>
      </fo:list-block>              
</xsl:template>



<xsl:template match="Images">
<xsl:for-each select="Image">
      <fo:block space-before.optimum="30pt">
        <fo:external-graphic><xsl:attribute name="src">file:/home/michi/src/lenyacms/src/webapp/lenya/pubs/slides/resources/images/live/<xsl:value-of select="HRef"/></xsl:attribute></fo:external-graphic>
      </fo:block>      
</xsl:for-each>
</xsl:template>



<xsl:template match="Meta">
  <xsl:value-of select="Author/FirstName"/>
  <xsl:text> </xsl:text>
  <xsl:value-of select="Author/LastName"/>,
  <xsl:value-of select="Occasion"/>,
  <xsl:value-of select="Date/Year"/>
  <xsl:text> </xsl:text>
  <xsl:value-of select="Date/Month/@Name"/>
  <xsl:text> </xsl:text>
  <xsl:value-of select="Date/Day"/>
</xsl:template>

</xsl:stylesheet>
