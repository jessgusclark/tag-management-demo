<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="3.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:ou="http://omniupdate.com/XSL/Variables"
				xmlns:fn="http://omniupdate.com/XSL/Functions"
				xmlns:ouc="http://omniupdate.com/XSL/Variables"
				exclude-result-prefixes="ou xsl xs fn ouc">

	
	<xsl:param name="ou:root"/>
	<xsl:param name="ou:site"/>
	<xsl:param name="ou:path"/>
	<xsl:param name="ou:dirname"/>

	<xsl:template match="/document">
		<html lang="en">

			<head>
				<title><xsl:value-of select="ouc:properties[@label='metadata']/title" />"</title>
				<link href="//netdna.bootstrapcdn.com/bootswatch/3.1.0/cerulean/bootstrap.min.css" rel="stylesheet"/>
			</head>

			<body>
				<h1><xsl:value-of select="ouc:properties[@label='metadata']/title" /></h1>
				<xsl:call-template name="GetAllJournals" />
			</body>
		</html>

	</xsl:template>

	
	<xsl:template name="GetAllJournals">
		
		<!-- static folder to look for data files: -->
		<xsl:variable name="data-folder" select="'/jesse/data-file-demo/data'" />
		<xsl:variable name="data-location" select="concat($ou:root, $ou:site, $data-folder)" />
		
		
			<!-- Create Sorted Version First, this has to happen here so we can use preceding-sibling later -->
			<xsl:variable name="sortedcopy">
				<xsl:for-each select="doc($data-location)/list/file">
					<xsl:sort select="." order="ascending"/>
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</xsl:variable>
			
			<!-- Loop through list using the sibiling -->
			<xsl:for-each select="$sortedcopy/file">
				
				<!-- Variables for single data file -->
				<xsl:variable name="file-name"><xsl:value-of select="."/></xsl:variable>
				<xsl:variable name="page-content" select="doc(concat($data-location,'/', $file-name))" />

				<!-- Check to make sure it is a data file -->
				<xsl:if test="$page-content/document/page/@type = 'library-database'">	<!--library-database -->

					
					<!-- Get the first character of the title (example: If 'accounting' this will return 'A') -->
					<xsl:variable name="current-letter" select="upper-case(substring($page-content/document/ouc:properties/parameter[@name='database-name'],1,1))"/>					
					
					<!-- If previous data file exists, get it, else leave the variable $previous-letter as blank -->
					<xsl:variable name="previous-letter">
						<xsl:if test="preceding-sibling::file[1] != ''">
							<xsl:value-of select="upper-case(substring(doc(concat($data-location,'/', preceding-sibling::file[1]))/document/ouc:properties/parameter[@name='database-name'],1,1))" />
						</xsl:if>
					</xsl:variable>
					
					<!-- If the first character of the previous title does not equal the first character of the current title, display a header -->
					<xsl:if test="$previous-letter != $current-letter">							
						<h2 class="break-above"><xsl:value-of select="$current-letter" /></h2>
					</xsl:if>
					
					
					<!-- Display Journal content -->
					<h3><xsl:value-of select="$page-content/document/ouc:properties/parameter[@name='database-name']" /></h3>
					<p><xsl:value-of select="$page-content/document/ouc:properties/parameter[@name='database-description']" /></p>
					<p><a href="{$page-content/ouc:properties[@label='config']/parameter[@name='database-url']}">Open Database</a></p>
					
					<!-- GetTagsForPage function will get the tags associated with the data file -->
					<xsl:call-template name="GetTagsForPage">
						<xsl:with-param name="page-path" select="concat($data-folder,'/', $file-name)" />
					</xsl:call-template>
					
					<hr/>

				</xsl:if>

			</xsl:for-each>
		
	</xsl:template>
	
	<!-- Get the Tags that are associated with the data file -->
	<xsl:template name="GetTagsForPage">
		<xsl:param name="page-path" />
		
		<xsl:variable name="page-tags" select="doc(concat('ou:/Tag/GetTags?site=', $ou:site, '&amp;path=', $page-path))/tags" />
		<xsl:for-each select="$page-tags/tag">
			
			<xsl:call-template name="DisplayTag">
				<xsl:with-param name="tag" select="." />
			</xsl:call-template>			
			
		</xsl:for-each>		
	</xsl:template>
	
	
	<!-- Template to display and format an Individual Tag -->
	<xsl:template name="DisplayTag">
		<xsl:param name="tag" />
		
		<!-- Remove the `library-database-` from the tag name -->
		<xsl:variable name="tag-name" select="replace($tag/name, 'library-database-', '')" />
		
		<!-- Link the label to the page. This server uses aspx -->
		<a href="{$tag-name}.aspx">
			<span class="label label-success">
				<!-- Replace Underscores with Spaces -->
				<xsl:value-of select="replace($tag-name, '_', ' ')" /> 
			</span>
		</a>
		
	</xsl:template>

</xsl:stylesheet>
