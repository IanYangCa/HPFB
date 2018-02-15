<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<xsl:transform version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:v3="urn:hl7-org:v3" 
	xmlns:str="http://exslt.org/strings" 
	xmlns:exsl="http://exslt.org/common" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" 
	exclude-result-prefixes="exsl msxsl v3 xsl xsi str">
	<!-- "/.." means the value come from parent or caller parameter -->
	<xsl:param name="oids-base-url" select="/.."/>
	<xsl:param name="resourcesdir" select="/.."/>
	<xsl:param name="css" select="/.."/>

	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="no" doctype-public="-"/>
	<xsl:strip-space elements="*"/>

	<xsl:variable name="root" select="/"/>
	<xsl:variable name="section-id-oid" select="'2.16.840.1.113883.2.20.6.8'"/>
	<xsl:variable name="country-code-oid" select="'2.16.840.1.113883.2.20.6.17'"/>
	<xsl:variable name="document-id-oid" select="'2.16.840.1.113883.2.20.6.10'"/>
	<xsl:variable name="marketing-category-oid" select="'2.16.840.1.113883.2.20.6.11'"/>
	<xsl:variable name="ingredient-id-oid" select="'2.16.840.1.113883.2.20.6.14'"/>
	<xsl:variable name="marketing-status-oid" select="'2.16.840.1.113883.2.20.6.18'"/>
	<xsl:variable name="organization-role-oid" select="'2.16.840.1.113883.2.20.6.33'"/>
	<xsl:variable name="pharmaceutical-standard-oid" select="'2.16.840.1.113883.2.20.6.5'"/>
	<xsl:variable name="product-characteristics-oid" select="'2.16.840.1.113883.2.20.6.23'"/>
	<xsl:variable name="structure-aspects-oid" select="'2.16.840.1.113883.2.20.6.36'"/>
	<xsl:variable name="term-status-oid" select="'2.16.840.1.113883.2.20.6.37'"/>
	<xsl:variable name="din-oid" select="'2.16.840.1.113883.2.20.6.42'"/>

	<xsl:variable name="doc_language">
		<xsl:call-template name="string-lowercase">
			<xsl:with-param name="text">
				<xsl:value-of select="/v3:document/v3:languageCode/@code"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="display_language" select="concat('name-',$doc_language)"/>
	<xsl:variable name="doctype" select="/v3:document/v3:code/@code"/>
	<xsl:variable name="file-suffix" select="'.xml'"/>
	<xsl:variable name="codeLookup" select="document(concat($oids-base-url,$structure-aspects-oid,$file-suffix))"/>
	<xsl:variable name="vocabulary" select="document(concat($oids-base-url,$section-id-oid,$file-suffix))"/>
	<xsl:variable name="documentTypes" select="document(concat($oids-base-url,$document-id-oid,$file-suffix))"/>
	<xsl:variable name="characteristics" select="document(concat($oids-base-url,$product-characteristics-oid,$file-suffix))"/>

	<xsl:template name="include-custom-items">
		<link rel="stylesheet" type="text/css" href="{$resourcesdir}jqx.base.css"/>

		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
		<script src="{$resourcesdir}jqxcore.js" type="text/javascript" charset="utf-8">/* */</script>
		<script src="{$resourcesdir}jqxsplitter.js" type="text/javascript" charset="utf-8">/* */</script>
		<script src="{$resourcesdir}hpfb-spl.js" type="text/javascript" charset="utf-8">/* */</script>
	</xsl:template>
	<!-- Process mixins if they exist -->
	<xsl:template match="/" priority="1">
		<xsl:apply-templates select="*"/>
	</xsl:template>
	<xsl:template match="/v3:document">
		<html>
			<head>
				<meta name="documentId" content="{/v3:document/v3:id/@root}"/>
				<meta name="documentSetId" content="{/v3:document/v3:setId/@root}"/>
				<meta name="documentVersionNumber" content="{/v3:document/v3:versionNumber/@value}"/>
				<meta name="documentEffectiveTime" content="{/v3:document/v3:effectiveTime/@value}"/>
				<title>
					<!-- GS: this isn't right because the title can have markup -->
					<xsl:value-of select="v3:title"/>
				</title>
				<link rel="stylesheet" type="text/css" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>
				<link rel="stylesheet" type="text/css" href="{$css}"/>
				<xsl:call-template name="include-custom-items"/>
			</head>
			<body onload="setWatermarkBorder();twoColumnsDisplay();">
			<div class="pageHeader" id="pageHeader"><table><tbody><tr><td><div id="approvedRevisionDateLabel"></div></td><td><div id="approvedRevisionDateValue"></div></td><td><div id="headerBrandName"></div></td><td><div id="pageHeaderTitle"></div></td></tr></tbody></table></div>
			<div class="contentBody">
				<div class="triangle-left"></div><div class="triangle-right"></div>
				<div class="leftColumn" id="toc">
					<div id="toc_0"><h1 style="background-color:#eff0f1;"><span style="font-weight:bold;" onclick="expandCollapseAll(this);">+&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</span></h1></div>
				</div>
				<div class="spl rightColumn" id="spl">
					<xsl:call-template name="topPage"/>
					<div class="pagebreak"/>
					<xsl:apply-templates select="//v3:code[@code='440' and @codeSystem=$section-id-oid]/..">
						<xsl:with-param name="render440" select="'xxx'"/>
					</xsl:apply-templates>
					<div class="pagebreak"/>
					<xsl:apply-templates mode="title" select="."/>
					<div class="Contents">
						<xsl:apply-templates select="@*|node()">
							<xsl:with-param name="render440" select="'440'"/>
						</xsl:apply-templates>
					</div>
					<div class="pagebreak"/>
				</div>
			</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="topPage">
		<div id="topPageImage">
			<img alt="Health Canada" style="width:100%;" src="'cpid_header_Canada.jpg'"/>
		</div>
	</xsl:template>
	<xsl:template match="v3:section" mode="tableOfContents">
		<!-- Health Canada Import previous prefix level -->
		<xsl:param name="parentPrefix" select="''"/>
		<xsl:variable name="code" select="v3:code/@code"/>
		<xsl:variable name="sectionID" select="./@ID"/>
		<xsl:variable name="validCode" select="$section-id-oid"/>
		<xsl:variable name="heading" select="$codeLookup/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code' and SimpleValue=$code]/../Value[@ColumnRef='level']/SimpleValue"/>

		<!-- Determine most right prefix. -->
		<xsl:variable name="prefix">
			<xsl:choose>
				<!-- Health Canada Heading level 2 nesting can change based on the structure of the XML document. You also have to
					 count the number of siblings in the other sections and then add them. (For example the third element
					 in part #2 needs to also count the number of elements that are in part #1. -->
				<xsl:when test="$heading='2'">
					<xsl:choose>
						<xsl:when test="name(../parent::node())='structuredBody'">
							<xsl:value-of select="1 + count(../preceding-sibling::v3:component[v3:section/v3:code[@codeSystem=$validCode]]) - count($root/v3:document/v3:component/v3:structuredBody/v3:component[v3:section/v3:code[@code=20]]/preceding-sibling::*) - count(../preceding-sibling::v3:component[v3:section/v3:code[@code='30' or @code='40' or @code='480']])"/>
						</xsl:when>
						<xsl:when test="name(../parent::node())='section'">
							<xsl:value-of select="1 + count(../preceding-sibling::v3:component[v3:section/v3:code[@codeSystem=$validCode]]) + count(../../../preceding-sibling::v3:component[v3:section/v3:code[@code='20' or @code='30' or @code='40']]/v3:section/child::v3:component[v3:section/v3:code[@codeSystem=$validCode]])"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="count(../preceding-sibling::v3:component[v3:section/v3:code[@codeSystem=$validCode]]) + 1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<!-- Health Canada  Heading level 3,4,5 are properly nested and resets for each H2 element.
					 You can simply count the sibling elements to determine the prefix. -->
				<xsl:when test="$heading='3' or $heading='4' or $heading='5'">
					<xsl:value-of select="count(../preceding-sibling::v3:component[v3:section/v3:code[@codeSystem=$validCode]]) + 1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'5'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- Health Canada Draw the Heading element only if it should be included in TOC -->
		<xsl:if test="$codeLookup/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code' and SimpleValue=$code]/../Value[@ColumnRef='include_in_toc' and SimpleValue = 'True']">
			<xsl:choose>
				<!-- Health Canada Heading level 1 (part1,2,3) doesn't have a prefix -->
				<xsl:when test="$heading='1'">
					<h1 id="{$sectionID}h"><a href="#{$sectionID}"><xsl:value-of select="v3:title"/></a></h1>
				</xsl:when>
				<!-- Health Canada Heading level 2 doesn't havent any parent prefix -->
				<xsl:when test="$heading='2'">
					<h2 id="{$sectionID}h" style="padding-left:2em;margin-top:1.5ex;"><a href="#{$sectionID}"><xsl:value-of select="concat($prefix,'. ')"/><xsl:value-of select="v3:title"/></a></h2>
				</xsl:when>
				<xsl:when test="$heading='3'">
					<h3 id="{$sectionID}h" style="padding-left:4.5em;margin-top:1.3ex;">
						<a href="#{$sectionID}">
								<xsl:value-of select="concat($parentPrefix,'.')"/>
								<xsl:value-of select="concat($prefix,' ')"/>
								<xsl:value-of select="v3:title"/>
						</a>
					</h3>
				</xsl:when>
				<xsl:when test="$heading='4'">
					<h4 id="{$sectionID}h" style="padding-left:6em;margin-top:1ex;">
						<a href="#{$sectionID}">
								<xsl:value-of select="concat($parentPrefix,'.')"/>
								<xsl:value-of select="concat($prefix,' ')"/>
								<xsl:value-of select="v3:title"/>
						</a>
					</h4>
				</xsl:when>
				<xsl:when test="$heading='5'">
					<h5 id="{$sectionID}h" style="padding-left:7.5em;margin-top:0.8ex;margin-bottom:0.8ex;">
						<a href="#{$sectionID}">
								<xsl:value-of select="concat($parentPrefix,'.')"/>
								<xsl:value-of select="concat($prefix,' ')"/>
								<xsl:value-of select="v3:title"/>
						</a>
					</h5>
				</xsl:when>
				<xsl:otherwise>Error: <xsl:value-of select="$code"/>/<xsl:value-of select="$heading"/></xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:apply-templates select="v3:component/v3:section" mode="tableOfContents">
			<xsl:with-param name="parentPrefix">
				<xsl:choose>
					<xsl:when test="$heading='1' or $heading='2'">
						<xsl:value-of select="$prefix"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($parentPrefix,'.',$prefix)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!-- Health Canada rendering the whole XML doc MAIN MODE based on the deep null-transform -->
	<xsl:template match="@*|node()">
		<xsl:apply-templates select="*"/>
	</xsl:template>
	<xsl:template name="string-uppercase">
		<!--** Convert the input text that is passed in as a parameter to upper case  -->
		<xsl:param name="text"/>
		<xsl:value-of select="translate($text,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
	</xsl:template>
	<xsl:template name="string-lowercase">
		<!--** Convert the input text that is passed in as a parameter to lower case  -->
		<xsl:param name="text"/>
		<xsl:value-of select="translate($text,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
	</xsl:template>
	<xsl:template name="image">
		<xsl:param name="path" select="."/>
		<xsl:if test="string-length($path/v3:value/v3:reference/@value) &gt; 0">
			<img alt="Image of Product" style="width:5%;" src="{$path/v3:value/v3:reference/@value}"/>
		</xsl:if>
	</xsl:template>

</xsl:transform><!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="yes" name="CPID" userelativepaths="no" externalpreview="yes" url="file:///e:/CPID-1.xml" htmlbaseurl="" outputurl="file:///c:/SPM/test/cpid.html" processortype="saxon8" useresolver="yes" profilemode="0" profiledepth=""
		          profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal"
		          customvalidator="">
			<parameterValue name="oids-base-url" value="'https://raw.githubusercontent.com/HealthCanada/HPFB/master/Controlled-Vocabularies/Content/'"/>
			<parameterValue name="css" value="'file://C:\Users\hcuser\git\HPFB\master\Structured-Product-Labeling-(SPL)\Style-Sheets\SPM\CPID\hpfb-spl-core.css'"/>
			<parameterValue name="resourcesdir" value="'file://C:\Users\hcuser\git\HPFB\master\Structured-Product-Labeling-(SPL)\Style-Sheets\SPM\CPID\'"/>
			<advancedProp name="sInitialMode" value=""/>
			<advancedProp name="schemaCache" value="||"/>
			<advancedProp name="bXsltOneIsOkay" value="true"/>
			<advancedProp name="bSchemaAware" value="true"/>
			<advancedProp name="bGenerateByteCode" value="true"/>
			<advancedProp name="bXml11" value="false"/>
			<advancedProp name="iValidation" value="0"/>
			<advancedProp name="bExtensions" value="true"/>
			<advancedProp name="iWhitespace" value="0"/>
			<advancedProp name="sInitialTemplate" value=""/>
			<advancedProp name="bTinyTree" value="true"/>
			<advancedProp name="xsltVersion" value="2.0"/>
			<advancedProp name="bWarnings" value="true"/>
			<advancedProp name="bUseDTD" value="false"/>
			<advancedProp name="iErrorHandling" value="fatal"/>
		</scenario>
	</scenarios>
	<MapperMetaTag>
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
		<MapperBlockPosition></MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
-->