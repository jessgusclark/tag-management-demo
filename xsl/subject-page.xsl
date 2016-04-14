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

	<xsl:template match="/document">
		<html lang="en">

			<head>
				<title><xsl:value-of select="ouc:properties[@label='metadata']/title" />"</title>
				<link href="//netdna.bootstrapcdn.com/bootswatch/3.1.0/cerulean/bootstrap.min.css" rel="stylesheet"/>
			</head>

			<body>
				<h1><xsl:value-of select="ouc:properties[@label='metadata']/title" /></h1>
				<xsl:call-template name="GetDataFilesWithTag" />
			</body>
		</html>

	</xsl:template>

	
	<xsl:template name="GetDataFilesWithTag">
		
		<!-- Get the first Tag that is associated with this page -->
		<xsl:variable name="page-tag" select="doc( concat('ou:/Tag/GetTags?', 'site=', $ou:site, '&amp;path=', replace($ou:path, '.html', '.pcf') ) )/tags/tag[1]/name" />
				
		<!-- Get Data Files With the Tag -->
		<xsl:variable name="tag-select" select="doc( concat('ou:/Tag/GetFilesWithAnyTags?site=', $ou:site, '&amp;tag=', $page-tag) )" /> 
		
		<!-- Loop through the pages that contain the keyword: -->
		<xsl:for-each select="$tag-select/pages/page">
			
			<!-- Sort the pages by the path -->
			<xsl:sort select="path" />
			
			<xsl:call-template name="GetContentFromSingleDataFile">
				<xsl:with-param name="data-url" select="path" />
			</xsl:call-template>
		</xsl:for-each>		
		
	</xsl:template>
	
	<!-- Template that takes a URL and formats the content: -->
	<xsl:template name="GetContentFromSingleDataFile">
		<xsl:param name="data-url" />
		
		<!-- Get the full path to the data file: -->
		<xsl:variable name="full-path" select="concat($ou:root, $ou:site, $data-url)" />
		
		<!-- Get Data File Content -->
		<xsl:variable name="page-content" select="doc($full-path)/document" />
		
		<!-- Only pull in data files -->
		<xsl:if test="$page-content/page/@type = 'library-database'">
		
			<!-- Check to see if the data file is set to 'active' -->
			<xsl:if test="$page-content/ouc:properties[@label='config']/parameter[@name='active']/option[@selected='true'] = 'True'">

				<h2><xsl:value-of select="$page-content/ouc:properties[@label='config']/parameter[@name='database-name']" /></h2>
				<p><xsl:value-of select="$page-content/ouc:properties[@label='config']/parameter[@name='database-description']" /></p>
				<a href="{$page-content/ouc:properties[@label='config']/parameter[@name='database-url']}">Open Database</a>
				<hr/>

			</xsl:if>
		</xsl:if>
		
	</xsl:template>
	

</xsl:stylesheet>
