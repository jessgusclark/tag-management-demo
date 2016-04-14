<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ou="http://omniupdate.com/XSL/Variables"
	xmlns:fn="http://omniupdate.com/XSL/Functions"
	xmlns:ouc="http://omniupdate.com/XSL/Variables"
	exclude-result-prefixes="ou xsl xs fn ouc">
	
	<xsl:import href="../common.xsl"/>
	
	<xsl:template match="/document">
		<html lang="en">
			
			<head>
				<link href="//netdna.bootstrapcdn.com/bootswatch/3.1.0/cerulean/bootstrap.min.css" rel="stylesheet"/>
				<link href="/_resources/css/oustaging.css" rel="stylesheet" />
				<style>
					body{
					font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
					}
					.ox-regioneditbutton {
					display: none;
					}
					
					tr {border-bottom:1px solid #EBEBEB}
					tr td {padding:4px 0;}
				</style>
			</head>
			
			<body id="properties">
				
				<div class="container">
					<h1>Library Database</h1>
					<div class="alert alert-warning">
						<p><strong>Data File:</strong> This file does not need to be published, however the pages that pull data from this file do.</p>
					</div>
					
					
					<table width="100%">
						<thead>
							<th width="25%">Property Name</th>
							<th width="75%">Value</th>
						</thead>
						<xsl:for-each select="ouc:properties[@label='config']/parameter">
							<tr>
								<td><xsl:value-of select="@prompt"/></td>
								<xsl:choose>
									<xsl:when test="@type = 'select'">
										<td><xsl:value-of select="option[@selected = 'true']"/></td>
									</xsl:when>
									<xsl:otherwise>
										<td><xsl:value-of select="."/></td>
									</xsl:otherwise>
								</xsl:choose>
							</tr>
						</xsl:for-each>
					</table>
					
					<h3>Tags:</h3>
					<p>Tags are used for 'subject' and 'resource type' sorting.</p>
					<ul>
					
                    <xsl:variable name="page-path" select="replace($ou:path, '.html', '.pcf')" />
                    
					<xsl:for-each select="doc( concat('ou:/Tag/GetTags?', 'site=', $ou:site, '&amp;path=', $page-path ) )/tags/tag">
						<li><xsl:value-of select="name" /></li>
					</xsl:for-each>
					</ul>
					
				</div>
				
				<div style="display:none;">
					<ouc:div label="fake" group="fake" button="hide"/>
				</div>
				
			</body>
		</html>
		
			
	</xsl:template>
	
	
</xsl:stylesheet>
