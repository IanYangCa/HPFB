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
	<xsl:variable name="organization-oid" select="'2.16.840.1.113883.2.20.6.31'"/>
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

		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
		<script src="{$resourcesdir}jqxcore.js" type="text/javascript" charset="utf-8">/* */</script>
		<script src="{$resourcesdir}jqxsplitter1.js" type="text/javascript" charset="utf-8">/* */</script>
		<script src="{$resourcesdir}hpfb-cpid.js" type="text/javascript" charset="utf-8">/* */</script>
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
				<link rel="stylesheet" type="text/css" href="{$resourcesdir}jqx.base.css"/>
				<link rel="stylesheet" type="text/css" href="{$css}"/>
				<xsl:call-template name="include-custom-items"/>
			</head>
			<body onload="setWatermarkBorder();twoColumnsDisplay();">
			<div class="cpidHiddenFields">
				<xsl:attribute name="headerDateLabel">
					<xsl:call-template name="hpfb-title"><xsl:with-param name="code" select="'10120'"/></xsl:call-template>
				</xsl:attribute>
				<xsl:attribute name="headerBrandName">
					<xsl:call-template name="hpfb-title"><xsl:with-param name="code" select="'10130'"/></xsl:call-template>
				</xsl:attribute>
			</div>
			<div class="pageHeader" id="pageHeader">
				<table><tbody>
				<tr><td style="white-space:nowrap;"><span id="headerDateLabel">
					<xsl:call-template name="hpfb-title"><xsl:with-param name="code" select="'10120'"/></xsl:call-template>
					</span><span id="headerDateValue">
						<xsl:call-template name="string-ISO-date">
							<xsl:with-param name="text" select="/v3:document/v3:effectiveTime/v3:originalText"/>
						</xsl:call-template>/
						<xsl:call-template name="string-ISO-date">
							<xsl:with-param name="text" select="/v3:document/v3:effectiveTime/@value"/>
						</xsl:call-template>
					</span>
				</td><td style="white-space:nowrap;"><span id="headerBrandName">
						<xsl:call-template name="hpfb-title"><xsl:with-param name="code" select="'10130'"/></xsl:call-template>
					</span>
				</td><td style="width: 60%;"><div id="pageHeaderTitle"></div>
				</td></tr>
				</tbody></table>
			</div>
			<div class="contentBody" id="jqxSplitter">
				<div class="leftColumn" id="toc">
<!--					<div id="toc_0"><h1 style="background-color:#eff0f1;"><span style="font-weight:bold;" onclick="expandCollapseAll(this);">+&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</span></h1></div>-->
					<div id="toc_0999"><span onclick="expandCollapseAll(this);">&#160;+&#160;</span><h1></h1></div>
				</div>
				<div class="spl rightColumn" id="spl">

					<div class="pagebreak"/>
					<xsl:apply-templates mode="title" select="."/>
					<div id="overviewImage">
						<img alt="Health Canada" src="https://rawgit.com/IanYangCa/HPFB/master/Structured-Product-Labeling-(SPL)/Style-Sheets/CPID/dev/cpid_header_Canada.jpg"/>
					</div>
					<div class="Contents">
						<xsl:apply-templates select="./v3:component">
							<xsl:with-param name="render440" select="'440'"/>
						</xsl:apply-templates>
					</div>
					<div class="pagebreak"/>
				</div>
			</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="overview">
		<div class="overview">
		<table class="contentTablePetite" cellspacing="0" width="100%">
			<tbody>
				<tr>
					<td colspan="4" id="summaryProducts" class="formHeadingTitle">
						<xsl:call-template name="hpfb-title">
							<xsl:with-param name="code" select="'10113'"/>
							<!-- SUMMARY OF PRODUCT INFORMATION -->
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td class="formTitle">
						<xsl:call-template name="hpfb-title">
							<xsl:with-param name="code" select="'10114'"/>
							<!-- Brand Name of Drug Product -->
						</xsl:call-template>
					</td>
					<td class="formItem" colspan="3">
						<xsl:apply-templates mode="showDataWithBR" select="//v3:manufacturedProduct/v3:manufacturedProduct/v3:name"/>
					</td>
				</tr>
				<tr>
					<td class="formTitle">
						<xsl:call-template name="hpfb-title">
							<xsl:with-param name="code" select="'10115'"/>
							<!-- Non-proprietary (Proper or common name) Name of Drug Product -->
						</xsl:call-template>
					</td>
					<td class="formItem" colspan="3">
						<xsl:apply-templates mode="showDataWithBR" select="//v3:manufacturedProduct/v3:manufacturedProduct/v3:asEntityWithGeneric/v3:genericMedicine/v3:name"/>
					</td>
				</tr>
				<xsl:apply-templates mode="nonProprietarySubstance" select="//v3:manufacturedProduct/v3:manufacturedProduct/v3:ingredient[starts-with(@classCode, 'ACTI')]"/>
				<tr>
					<td class="formTitle">
						<xsl:call-template name="hpfb-title">
							<xsl:with-param name="code" select="'10117'"/>
							<!-- Company (Manufacturer/Sponsor) Name -->
						</xsl:call-template>
						 
					</td>
					<td class="formItem" colspan="3">
						<xsl:apply-templates mode="showDataWithBR" select="//v3:author/v3:assignedEntity/v3:representedOrganization/v3:name"/>
					</td>
				</tr>
				<tr>
					<td class="formTitle">
						<xsl:call-template name="hpfb-title">
							<xsl:with-param name="code" select="'10118'"/>
							<!-- Dosage Form(s) -->
						</xsl:call-template>
					</td>
					<td class="formItem" colspan="3">
						<xsl:for-each select="//v3:manufacturedProduct/v3:manufacturedProduct/v3:formCode/@displayName">
							<xsl:value-of select="."/>;&#160;&#160;
						</xsl:for-each>
					</td>
				</tr>
				<tr>
					<td class="formTitle">
						<xsl:call-template name="hpfb-title">
							<xsl:with-param name="code" select="'10077'"/>
							<!-- Route of Administration -->
						</xsl:call-template>
					</td>
					<td class="formItem" colspan="3">
						<xsl:for-each select="//v3:consumedIn/v3:substanceAdministration/v3:routeCode/@displayName">
							<xsl:value-of select="."/>;&#160;&#160;
						</xsl:for-each>
					</td>
				</tr>
				<tr>
					<td class="formTitle">
						<xsl:call-template name="hpfb-title">
							<xsl:with-param name="code" select="'10119'"/>
							<!-- Proposed Indication(s) -->
						</xsl:call-template>
					</td>
					<td class="formItem" colspan="3">
					</td>
				</tr>
				<tr>
					<td class="formTitle">
						<xsl:call-template name="hpfb-title">
							<xsl:with-param name="code" select="'10122'"/>
							<!-- Sponsor’s Date of CPID -->
						</xsl:call-template>
					</td>
					<td class="formItem" colspan="3">
						<xsl:call-template name="string-ISO-date">
							<xsl:with-param name="text" select="/v3:document/v3:effectiveTime/v3:originalText"/>
						</xsl:call-template>
					</td>
				</tr>
				<tr>
					<td class="formHeadingReg" colspan="4">
						footer??
					</td>
				</tr>
			</tbody>
		</table>
		<table class="contentTablePetite" cellspacing="0" width="100%">
		<tbody>
			<tr>
				<td colspan="2" id="administrativeSummary" class="formHeadingTitle">
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10140'"/>
						<!-- Administrative SUMMARY -->
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<td class="formTitle">
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10123'"/>
						<!-- DocuBridge Identifier -->
					</xsl:call-template>
				</td>
				<td class="formItem">
					<xsl:value-of select="/v3:document/v3:templateId[@root='2.16.840.1.113883.2.20.6.48']/@extension"/>
				</td>
			</tr>
			<tr>
				<td class="formTitle">
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10124'"/>
						<!-- Control Number -->
					</xsl:call-template>
				</td>
				<td class="formItem">
					<xsl:value-of select="/v3:document/v3:templateId[@root='2.16.840.1.113883.2.20.6.49']/@extension"/>
				</td>
			</tr>
			<tr>
				<td class="formTitle">
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10125'"/>
						<!-- HC Version -->
					</xsl:call-template>
				</td>
				<td class="formItem">
					<xsl:value-of select="/v3:document/v3:versionNumber"/>
				</td>
			</tr>
			<tr>
				<td class="formTitle">
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10126'"/>
						<!-- Date of Acceptance -->
					</xsl:call-template>
				</td>
				<td class="formItem">
					<xsl:call-template name="string-ISO-date">
						<xsl:with-param name="text" select="/v3:document/v3:effectiveTime/@value"/>
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="formItem">Health Canada use only
				</td>
			</tr>
		</tbody>
		</table>
<!--		<div id="topPageFootImage">
			<img alt="Health Canada" src="https://rawgit.com/IanYangCa/HPFB/master/Structured-Product-Labeling-(SPL)/Style-Sheets/CPID/dev/Canada.jpg"/>
		</div>-->
		</div>
	</xsl:template>
	<xsl:template mode="nonProprietarySubstance" match="*">
		<tr>
			<td class="formTitle">
				<xsl:call-template name="hpfb-title">
					<xsl:with-param name="code" select="'10116'"/>
					<!-- Non-proprietary or Common Name of Drug Substance (Medicinal Ingredient) -->
				</xsl:call-template>
			</td>
			<td class="formItem">
				<xsl:value-of select="./v3:ingredientSubstance/v3:code/@displayName"/>
				(<xsl:call-template name="hpfb-title"><xsl:with-param name="code" select="'10093'"/></xsl:call-template>:&#160;<xsl:value-of select="./v3:ingredientSubstance/v3:code/@code"/>)
			</td>
			<td class="formTitle" style="width:7em;">
				<xsl:call-template name="hpfb-title">
					<xsl:with-param name="code" select="'10086'"/>
					<!-- Strength -->
				</xsl:call-template>
			</td>
			<td class="formItem">
				<xsl:value-of select="./v3:quantity/v3:numerator/@value"/>&#160;
				<xsl:value-of select="./v3:quantity/v3:numerator/@unit"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template mode="title" match="/|@*|node()"/>
	<xsl:template mode="title" match="v3:document">
		<div class="DocumentTitle toc" id="tableOfContent">
			<xsl:attribute name="expandCollapse">
				<xsl:call-template name="hpfb-title">
					<xsl:with-param name="code" select="'10107'"/>
					<!-- applicationProductConcept -->
				</xsl:call-template>
			</xsl:attribute>
			<p class="DocumentTitle">
				<span class="formHeadingTitle">
					<xsl:apply-templates select="v3:component" mode="tableOfContents"/>
					<xsl:text disable-output-escaping="yes">
						&lt;h1 id=&#39;productDescriptionh&#39;&gt;&lt;a href=&#39;#prodDesc&#39;&gt;
					</xsl:text>
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10000'"/>
						<!-- productDescription -->
					</xsl:call-template>
					<xsl:text disable-output-escaping="yes">&lt;/a&gt;&lt;/h1&gt;</xsl:text>
					<xsl:call-template name="productNames"/>
					<xsl:text disable-output-escaping="yes">
						&lt;h1 id=&#39;organizationsh&#39;&gt;&lt;a href=&#39;#organizations&#39;&gt;
					</xsl:text>
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10109'"/>
						<!-- Organization -->
					</xsl:call-template>
					<xsl:text disable-output-escaping="yes">&lt;/a&gt;&lt;/h1&gt;</xsl:text>
					<xsl:call-template name="organizations"/>
				</span>
			</p>
			<xsl:if test="not(//v3:manufacturedProduct) and /v3:document/v3:code/@displayName">
				<xsl:value-of select="/v3:document/v3:code/@displayName"/>
				<br/>
			</xsl:if>
		</div>
	</xsl:template>
	<xsl:template match="v3:title">
		<xsl:param name="sectionLevel" select="count(ancestor::v3:section)"/>
		<xsl:param name="sectionNumber" select="/.."/>

		<xsl:variable name="code" select="../v3:code/@code"/>
		<xsl:variable name="validCode" select="$section-id-oid"/>
		<xsl:variable name="tocObject" select="$codeLookup/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code' and SimpleValue=$code]/../Value[@ColumnRef='level']/SimpleValue"/>
		<!-- Health Canada Change Draw H3,H4,H5 elements as H3 because they are too small otherwise -->
		<xsl:variable name="eleSize">
			<xsl:choose>
				<xsl:when test="$sectionLevel &gt; 3">
					<xsl:value-of select="'3'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$sectionLevel = '0'">
							<xsl:value-of select="'1'"/>
						</xsl:when>
						<xsl:when test="$sectionLevel">
							<xsl:value-of select="$sectionLevel"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="count(ancestor::v3:section)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Health Canada Changed variable name to eleSize-->
		<xsl:element name="h{$eleSize}">
			<xsl:value-of select="' '"/>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates mode="mixed" select="node()"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="productNames">
		<xsl:for-each select="//v3:manufacturedProduct/v3:manufacturedProduct">
			<h2 id="product{count(preceding::v3:manufacturedProduct/v3:manufacturedProduct)}h" style="padding-left:3em;margin-top:1.5ex;"><a href="#product{count(preceding::v3:manufacturedProduct/v3:manufacturedProduct)}">
			<xsl:value-of select="./v3:name"/>
			<xsl:variable name="strength">
				<xsl:for-each select="./v3:ingredient[starts-with(@classCode,'ACTI')]/v3:quantity/v3:numerator">
					<xsl:apply-templates mode="productNames" select="."/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:if test="$strength !=''">
				<xsl:variable name="strLen" select="string-length($strength)"/>
				<xsl:value-of select="concat(' - ', substring($strength, 1, $strLen - 1))"/>
			</xsl:if>
			</a></h2>
		</xsl:for-each>
	</xsl:template>
	<xsl:template mode="productNames" match="node()">
		<xsl:choose>
		<xsl:when test="./@value">
			<xsl:value-of select="./@value"/><xsl:value-of select="'/'"/>
		</xsl:when>
		<xsl:when test=".">
			<xsl:value-of select="'-'"/><xsl:value-of select="'/'"/>
		</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="organizations">
		<xsl:for-each select="//v3:author/v3:assignedEntity/v3:representedOrganization">
			<xsl:if test="(count(./v3:name)&gt;0)">
				<h2 id="dinOwner{count(preceding::v3:author/v3:assignedEntity/v3:representedOrganization)}h" style="padding-left:2em;margin-top:1.5ex;"><a href="#dinOwner{count(preceding::v3:author/v3:assignedEntity/v3:representedOrganization)}">
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10020'"/>
						<!-- DIN_Owner -->
					</xsl:call-template>
				</a></h2>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="//v3:author/v3:assignedEntity/v3:representedOrganization/v3:assignedEntity/v3:assignedOrganization/v3:assignedEntity/v3:assignedOrganization">
			<xsl:variable name="role_id" select="./v3:id[@root=$organization-role-oid]/@extension"/>
			<xsl:variable name="role_name" select="(document(concat($oids-base-url,$organization-role-oid,$file-suffix)))/gc:CodeList/SimpleCodeList/Row[./Value[@ColumnRef='code']/SimpleValue=$role_id]/Value[@ColumnRef=$display_language]/SimpleValue"/>
			<h2 id="{$role_name}{count(preceding::v3:author/v3:assignedEntity/v3:representedOrganization/v3:assignedEntity/v3:assignedOrganization/v3:assignedEntity/v3:assignedOrganization)}h" style="padding-left:2em;margin-top:1.5ex;"><a href="#{$role_name}{count(preceding::v3:author/v3:assignedEntity/v3:representedOrganization/v3:assignedEntity/v3:assignedOrganization/v3:assignedEntity/v3:assignedOrganization)}">
				<xsl:choose>
					<!-- replace with HPFB codes -->
					<xsl:when test="string($role_name) != 'NaN'">
						<xsl:value-of select="$role_name"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="hpfb-title">
							<xsl:with-param name="code" select="'10056'"/>
							<!-- otherParty -->
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</a></h2>
		</xsl:for-each>
		<xsl:for-each select="//v3:author/v3:assignedEntity/v3:representedOrganization/v3:assignedEntity/v3:assignedOrganization">
			<xsl:if test="(count(./v3:name)&gt;0)">
				<h2 id="otherpart{count(preceding::v3:author/v3:assignedEntity/v3:representedOrganization/v3:assignedEntity/v3:assignedOrganization)}h" style="padding-left:2em;margin-top:1.5ex;"><a href="#otherpart{count(preceding::v3:author/v3:assignedEntity/v3:representedOrganization/v3:assignedEntity/v3:assignedOrganization)}">
					<xsl:call-template name="hpfb-title">
							<xsl:with-param name="code" select="'10071'"/>
							<!-- registrant -->
					</xsl:call-template>&#xA0;-&#xA0;<xsl:value-of select="./v3:name"/>
				</a></h2>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="manufactures">
<!--		<xsl:param name="index" select="/.."/>-->
		<xsl:variable name="organizations" select="//v3:author/v3:assignedEntity/v3:representedOrganization/v3:assignedEntity/v3:assignedOrganization/v3:assignedEntity/v3:assignedOrganization"/>
		<xsl:if test="$organizations">
			<tr><td>
<!--			<xsl:variable name="role_name" select="(document(concat($oids-base-url,$organization-role-oid,$file-suffix)))/gc:CodeList/SimpleCodeList/Row[./Value[@ColumnRef='code']/SimpleValue=$index]/Value[@ColumnRef=$display_language]/SimpleValue"/>-->
			<table cellpadding="3" cellspacing="0" class="formTableMorePetite" width="100%">
			<tbody>
			<tr>
				<td class="formTitle">
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10027'"/>
						<!-- Org ID -->
					</xsl:call-template>
				</td>
				<td class="formTitle">
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10051'"/>
						<!-- Org Name -->
					</xsl:call-template>
				</td>
				<td class="formTitle">
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10003'"/>
						<!-- Org Address -->
					</xsl:call-template>
				</td>
				<td class="formTitle">
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10076'"/>
						<!-- Role - Product - Substance -->
					</xsl:call-template>
				</td>
			</tr>
			<xsl:for-each select="//v3:author/v3:assignedEntity/v3:representedOrganization/v3:assignedEntity/v3:assignedOrganization/v3:assignedEntity/v3:assignedOrganization">
			<xsl:call-template name="manufacture">
				<xsl:with-param name="index" select="position()"/>
			</xsl:call-template>
			</xsl:for-each>

			</tbody>
			</table>
			</td></tr>
		</xsl:if>
<!--		<xsl:if test="$index &lt; 25">
			<xsl:call-template name="manufactures">
				<xsl:with-param name="index" select="$index + 1"/>
			</xsl:call-template>
		</xsl:if>-->
	</xsl:template>
	<xsl:template name="manufacture">
		<xsl:param name="index" select="/.."/>
		<tr>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="$index mod 2 = 0">formTableRow</xsl:when>
					<xsl:otherwise>formTableRowAlt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<td class="formItem">
				<xsl:value-of select="./v3:id[@root=$organization-oid]/@extension"/>
			</td>
			<td class="formItem">
				<xsl:value-of select="./v3:name"/>
			</td>
			<td class="formItem">
				<xsl:apply-templates mode="format" select="./v3:addr"/>
			</td>
			<td class="formItem">
				<xsl:for-each select="../v3:performance">
				<div style="white-space:nowrap;">
				<xsl:value-of select="v3:actDefinition/v3:code[@codeSystem='2.16.840.1.113883.2.20.6.33']/@displayName"/>
				&#160;-&#160;
				<xsl:for-each select="v3:actDefinition/v3:product">
					<xsl:if test="position() &gt; 1">
						;&#160;&#160;
					</xsl:if>
					<xsl:value-of select="v3:manufacturedProduct/v3:manufacturedMaterialKind/v3:code/@code"/>
					&#160;-&#160;
					<xsl:value-of select="v3:manufacturedProduct/v3:manufacturedMaterialKind/v3:templateId[@root='2.16.840.1.113883.2.20.6.14']/@extension"/>
				</xsl:for-each>
				</div>
				</xsl:for-each>
			</td>
		</tr>
	</xsl:template>
	<xsl:template mode="format" match="*/v3:addr">
		<div class="addressContainer">
			<div class="address">
				<span class="label">
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10003'"/>
						<!-- Address -->
					</xsl:call-template>:
				</span>
				<span class="value">
					<xsl:value-of select="./v3:streetAddressLine"/>
				</span>
			</div>
			<div class="address">
				<span class="label">
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10011'"/>
						<!-- cityStateZip -->
					</xsl:call-template>:
				</span>
				<span class="value">
					<xsl:value-of select="./v3:city"/>
					<xsl:if test="string-length(./v3:state)&gt;0">,&#xA0;<xsl:value-of select="./v3:state"/></xsl:if>
					<xsl:if test="string-length(./v3:postalCode)&gt;0">,&#xA0;<xsl:value-of select="./v3:postalCode"/></xsl:if>
				</span>
			</div>
			<div class="address">
				<span class="label">
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10106'"/>
						<!-- Country -->
					</xsl:call-template>:
				</span>
				<span class="value">
					<xsl:call-template name="hpfb-label">
						<xsl:with-param name="codeSystem" select="$country-code-oid"/>
						<xsl:with-param name="code" select="./v3:country/@code"/>
					</xsl:call-template>
				</span>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="performances">
		<xsl:for-each select="//v3:author/v3:assignedEntity/v3:representedOrganization/v3:assignedEntity/v3:assignedOrganization/v3:assignedEntity/v3:performance">
		<table class="contentTablePetite" cellspacing="0" width="100%">
		<tbody>
			<tr>
				<td colspan="3" class="formHeadingReg">
					<xsl:value-of select="./v3:actDefinition/v3:product/v3:manufacturedProduct/v3:manufacturedMaterialKind/v3:code/@displayName"/>
				</td>
			</tr>
			<tr>
				<td class="formTitle">
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10051'"/>
						<!-- name -->
					</xsl:call-template>
				</td>
				<td class="formTitle">
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10003'"/>
						<!-- address -->
					</xsl:call-template>
				</td>
				<td class="formTitle">
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10129'"/>
						<!-- API -->
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<td class="formItem">
					<xsl:value-of select="../v3:assignedOrganization/v3:name"/>
				</td>
				<td class="formItem">
					<xsl:apply-templates mode="format" select="../v3:assignedOrganization/v3:addr"/>
				</td>
				<td>
					<xsl:value-of select="./v3:actDefinition/v3:code/@displayName"/>
				</td>
			</tr>
			<tr>
				<td colspan="3" class="formHeadingReg">footer???
				</td>
			</tr>
		</tbody>
		</table>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="storageConditions">
		<table class="contentTablePetite" cellspacing="0" width="100%">
		<tbody>
			<tr>
				<td colspan="3" class="formHeadingReg">???
				</td>
			</tr>
			<tr>
				<td class="formTitle">
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10137'"/>
						<!-- Container Closure System -->
					</xsl:call-template>
				</td>
				<td class="formTitle">
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10138'"/>
						<!-- Storage Conditions -->
					</xsl:call-template>
				</td>
				<td class="formTitle">
					<xsl:call-template name="hpfb-title">
						<xsl:with-param name="code" select="'10139'"/>
						<!-- Re-test Period -->
					</xsl:call-template>
				</td>
			</tr>
			<xsl:for-each select="//v3:instanceOfKind/v3:productInstance/v3:asContent">
				<tr>
					<td class="formItem">
						<xsl:value-of select="./v3:container/v3:code/@displayName"/>
					</td>
					<td class="formItem">
						<xsl:value-of select="./v3:subjectOf/v3:productEvent/v3:code/@displayName"/>&#160;
						<xsl:value-of select="./v3:subjectOf/v3:productEvent/v3:text"/>
					</td>
					<td class="formItem">
						<xsl:call-template name="string-ISO-date">
							<xsl:with-param name="text" select="../v3:existenceTime"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:for-each>
			<tr>
				<td colspan="3" class="formHeadingReg">footer???
				</td>
			</tr>
		</tbody>
		</table>
	</xsl:template>
	<xsl:template match="v3:section" mode="tableOfContents">
		<!-- Health Canada Import previous prefix level -->
		<xsl:param name="parentPrefix" select="''"/>
		<xsl:variable name="code" select="v3:code/@code"/>
		<xsl:variable name="sectionID" select="./@ID"/>
		<xsl:variable name="validCode" select="$section-id-oid"/>
		<xsl:variable name="heading" select="$codeLookup/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code' and SimpleValue=$code]/../Value[@ColumnRef='level']/SimpleValue"/>

		<xsl:if test="$codeLookup/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code' and SimpleValue=$code]/../Value[@ColumnRef='include_in_toc' and SimpleValue = 'True']">
			<xsl:choose>
				<!-- Health Canada Heading level 1 (part1,2,3) doesn't have a prefix -->
				<xsl:when test="$heading='1'">
					<h1 id="{$sectionID}h"><a href="#{$sectionID}"><xsl:value-of select="v3:title"/></a></h1>
			<!--code="5056" codeSystem="2.16.840.1.113883.2.20.6.8"-->
					<xsl:if test="$code = '5056' and $section-id-oid = v3:code/@codeSystem">
						<h2 id="summaryProductsh"><a href="#summaryProducts">
							<xsl:call-template name="hpfb-title">
								<xsl:with-param name="code" select="'10113'"/>
								<!-- SUMMARY OF PRODUCT INFORMATION -->
							</xsl:call-template>
						</a></h2>
						<h2 id="administrativeSummaryh"><a href="#administrativeSummary">
							<xsl:call-template name="hpfb-title">
								<xsl:with-param name="code" select="'10140'"/>
								<!-- Administrative SUMMARY -->
							</xsl:call-template>
						</a></h2>
					</xsl:if>
				</xsl:when>
				<!-- Health Canada Heading level 2 doesn't havent any parent prefix -->
				<xsl:when test="$heading='2'">
					<h2 id="{$sectionID}h" style="padding-left:2em;margin-top:1.5ex;"><a href="#{$sectionID}"><xsl:value-of select="v3:title"/></a></h2>
				</xsl:when>
				<xsl:when test="$heading='3'">
					<h3 id="{$sectionID}h" style="padding-left:4.5em;margin-top:1.3ex;">
						<a href="#{$sectionID}"><xsl:value-of select="v3:title"/></a>
					</h3>
				</xsl:when>
				<xsl:when test="$heading='4'">
					<h4 id="{$sectionID}h" style="padding-left:6em;margin-top:1ex;">
						<a href="#{$sectionID}"><xsl:value-of select="v3:title"/></a>
					</h4>
				</xsl:when>
				<xsl:when test="$heading='5'">
					<h5 id="{$sectionID}h" style="padding-left:7.5em;margin-top:0.8ex;margin-bottom:0.8ex;">
						<a href="#{$sectionID}">
								<xsl:value-of select="v3:title"/>
						</a>
					</h5>
				</xsl:when>
				<xsl:otherwise>Error: <xsl:value-of select="$code"/>/<xsl:value-of select="$heading"/></xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:apply-templates select="v3:component/v3:section" mode="tableOfContents">
			<xsl:with-param name="parentPrefix" select="''"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="v3:section">
		<xsl:param name="sectionLevel" select="count(ancestor-or-self::v3:section)"/>
		<xsl:param name="render440" select="'440'"/>
		<xsl:variable name="sectionNumberSequence">
			<xsl:apply-templates mode="sectionNumber" select="ancestor-or-self::v3:section"/>
		</xsl:variable>
		<xsl:variable name="code" select="v3:code/@code"/>
		<xsl:variable name="sectionID" select="./@ID"/>

		<xsl:variable name="heading" select="$codeLookup/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code' and SimpleValue=$code]/../Value[@ColumnRef='level']/SimpleValue"/>
		<xsl:if test="not ($code='150' or $code='160' or $code='170' or $code=$render440 or $code='520')">
			<xsl:if test="$heading = 1">
				<div class="pagebreak" />
			</xsl:if>
			<div class="Section">
				<xsl:attribute name="toc-include">
					<xsl:value-of select="$codeLookup/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code' and SimpleValue=$code]/../Value[@ColumnRef='include_in_toc']/SimpleValue"/>
				</xsl:attribute>
				<xsl:if test="$code = '440'">
					<xsl:attribute name="tabindex">
						<xsl:value-of select="'2'"/>
					</xsl:attribute>
				</xsl:if>
				
				<xsl:for-each select="v3:code">
					<xsl:attribute name="data-sectionCode">
						<xsl:value-of select="$sectionID"/>
					</xsl:attribute>
				</xsl:for-each>
				<xsl:call-template name="styleCodeAttr">
					<xsl:with-param name="styleCode" select="@styleCode"/>
					<xsl:with-param name="additionalStyleCode" select="'Section'"/>
				</xsl:call-template>
				<!-- Health Canada Changed the below line to get code of section for anchors-->
<!--				<xsl:for-each select="v3:code/@code">
					<a name="{.}"/>
				</xsl:for-each>-->
				<a>
					<xsl:attribute name="name">
						<xsl:value-of select="$sectionID"/>
					</xsl:attribute>
				</a>
				<p/>
				<xsl:apply-templates select="v3:title">
					<xsl:with-param name="sectionLevel" select="$heading"/>
					<xsl:with-param name="sectionNumber" select="substring($sectionNumberSequence,2)"/>
				</xsl:apply-templates>
<!--				<xsl:apply-templates mode="data" select="."/>-->
				<xsl:apply-templates select="@*|node()[not(self::v3:title)]">
					<xsl:with-param name="render440" select="$render440"/>
				</xsl:apply-templates>
				<xsl:call-template name="flushSectionTitleFootnotes"/>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template name="flushSectionTitleFootnotes">
		<xsl:variable name="footnotes" select="./v3:title/v3:footnote[not(ancestor::v3:table)]"/>
		<xsl:if test="$footnotes">
			<hr class="Footnoterule"/>
			<ol class="Footnote">
				<xsl:apply-templates mode="footnote" select="$footnotes"/>
			</ol>
		</xsl:if>
	</xsl:template>
	<xsl:template match="v3:paragraph">
		<!-- Health Canada Change added font size attribute below-->
		<p style="font-size:1.1em;">
			<xsl:call-template name="styleCodeAttr">
				<xsl:with-param name="styleCode" select="@styleCode"/>
				<xsl:with-param name="additionalStyleCode">
					<xsl:if test="count(preceding-sibling::v3:paragraph)=0">
						<xsl:text>First</xsl:text>
					</xsl:if>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="additionalStyleAttr"/>
			<xsl:apply-templates select="@*[not(local-name(.)='styleCode')]"/>
			<!-- see note anchoring and PCR 793 -->
			<!-- GS: moved this to after the styleCode and othe attribute handling -->
			<xsl:if test="@ID">
				<a name="{@ID}"/>
			</xsl:if>
			<xsl:apply-templates select="v3:caption"/>
			<xsl:apply-templates mode="mixed" select="node()[not(self::v3:caption)]"/>
		</p>
	</xsl:template>
	<xsl:template mode="mixed" match="v3:paragraph|v3:list|v3:table|v3:footnote|v3:footnoteRef|v3:flushfootnotes">
		<xsl:param name="isTableOfContent"/>
		<xsl:choose>
			<xsl:when test="$isTableOfContent='yes'">
				<xsl:apply-templates select=".">
					<xsl:with-param name="isTableOfContent2" select="'yes'"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select=".">
					<xsl:with-param name="isTableOfContent2" select="'no'"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="v3:text[not(parent::v3:observationMedia)]">
		<!-- Health Canada Change added font size attribute below-->
		<xsl:choose>
			<xsl:when test="../v3:code[@code='5056']">
				<xsl:call-template name="overview"/>
			</xsl:when>
			<xsl:when test="../v3:code[@code='5053']">
				<table class="contentTablePetite" cellspacing="0"  width="100%">
				<tbody>
					<tr>
						<td align="left" class="formHeadingTitle"><strong>Organizations</strong></td>
					</tr>
					<xsl:call-template name="manufactures">
						<xsl:with-param name="index" select="'1'"/>
					</xsl:call-template>
					<tr>
						<td colspan="4" class="formHeadingReg">footer???
						</td>
					</tr>
				</tbody>
				</table>
			</xsl:when>
			<xsl:when test="../v3:code[@code='5013']">
				<xsl:call-template name="performances"/>
			</xsl:when>
			<xsl:when test="../v3:code[@code='5022']">
				<xsl:call-template name="storageConditions"/>
			</xsl:when>
			<xsl:when test="../v3:code[@code='5031']">
				<table class="contentTablePetite" cellspacing="0" width="100%">
				<tbody>
					<tr>
						<td align="left" class="formHeadingTitle"><strong>Organizations</strong></td>
					</tr>
					<xsl:call-template name="manufactures">
						<xsl:with-param name="index" select="'1'"/>
					</xsl:call-template>
					<tr>
						<td colspan="4" class="formHeadingReg">footer???
						</td>
					</tr>
				</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
				<text style="font-size:0.8em;">
					<xsl:apply-templates select="@*"/>
					<xsl:apply-templates mode="mixed" select="node()"/>
					<xsl:apply-templates mode="rems" select="../v3:subject2[v3:substanceAdministration/v3:componentOf/v3:protocol]"/>
					<xsl:call-template name="flushfootnotes">
						<xsl:with-param name="isTableOfContent" select="'no'"/>
					</xsl:call-template>
				</text>
	</xsl:template>
	<xsl:template match="v3:flushfootnotes" name="flushfootnotes">
		<xsl:variable name="footnotes" select=".//v3:footnote[not(ancestor::v3:table)]"/>
		<xsl:if test="$footnotes">
			<div class="Footnoterule"/>
			<br/>
			<div class="bold">
				<xsl:call-template name="hpfb-title">
					<xsl:with-param name="code" select="'10102'"/> <!-- Foot Notes -->
					<!-- additive -->
				</xsl:call-template>:
			</div>
			<ol class="Footnote">
				<xsl:for-each select="$footnotes">
					<li>
						<xsl:value-of select="./text()"/>
					</li>
				</xsl:for-each>
			</ol>
		</xsl:if>
	</xsl:template>
	<!-- MIXED MODE: where text is rendered as is, even if nested
	 inside elements that we do not understand  -->
	<!-- based on the deep null-transform -->
	<xsl:template mode="mixed" match="@*|node()">
		<xsl:apply-templates mode="mixed" select="@*|node()"/>
	</xsl:template>
	<xsl:template mode="mixed" match="text()" priority="0">
		<xsl:copy/>
	</xsl:template>
	<xsl:template mode="mixed" match="v3:content">
		<span>
			<xsl:call-template name="styleCodeAttr">
				<xsl:with-param name="styleCode" select="@styleCode"/>
				<xsl:with-param name="additionalStyleCodeSequence" select="@emphasis|@revised"/>
			</xsl:call-template>
			<xsl:call-template name="additionalStyleAttr"/>
			<xsl:apply-templates select="@*[not(local-name(.)='styleCode')]"/>
			<!-- see note anchoring and PCR 793 -->
			<!-- GS: moved this till after styleCode and other attribute handling -->
			<xsl:choose>
				<xsl:when test="$root/v3:document[v3:code/@code = 'X9999-4']">
					<xsl:if test="not(@ID)">
						<xsl:apply-templates mode="mixed" select="node()"/>
					</xsl:if>
					<xsl:if test="@ID">
						<xsl:variable name="id" select="@ID"/>
						<xsl:variable name="contentID" select="concat('#',$id)"/>
						<xsl:variable name="link" select="/v3:document//v3:subject/v3:manufacturedProduct/v3:subjectOf/v3:document[v3:title/v3:reference/@value = $contentID]/v3:text/v3:reference/@value"/>
						<xsl:if test="$link">
							<a>
								<xsl:attribute name="href">
									<xsl:value-of select="$link"/>
								</xsl:attribute>
								<xsl:apply-templates mode="mixed" select="node()"/>
							</a>
						</xsl:if>
						<xsl:if test="not($link)">
							<a name="{@ID}"/>
							<xsl:apply-templates mode="mixed" select="node()"/>
						</xsl:if>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="@ID">
						<a name="{@ID}"/>
					</xsl:if>
					<xsl:apply-templates mode="mixed" select="node()"/>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>
	<!-- We don't use <sub> and <sup> elements here because IE produces
	 ugly uneven line spacing. -->
	<xsl:template mode="mixed" match="v3:sub">
		<span>
			<xsl:call-template name="styleCodeAttr">
				<xsl:with-param name="styleCode" select="@styleCode"/>
				<xsl:with-param name="additionalStyleCode" select="'Sub'"/>
			</xsl:call-template>
			<xsl:apply-templates mode="mixed" select="@*|node()"/>
		</span>
	</xsl:template>
	<xsl:template mode="mixed" match="v3:sup">
		<span>
			<xsl:call-template name="styleCodeAttr">
				<xsl:with-param name="styleCode" select="@styleCode"/>
				<xsl:with-param name="additionalStyleCode" select="'Sup'"/>
			</xsl:call-template>
			<xsl:apply-templates mode="mixed" select="@*|node()"/>
		</span>
	</xsl:template>
	<xsl:template mode="mixed" match="v3:br">
		<br/>
	</xsl:template>
	<xsl:template mode="mixed" priority="1" match="v3:renderMultiMedia[@referencedObject and (ancestor::v3:paragraph or ancestor::v3:td or ancestor::v3:th)]">
		<xsl:variable name="reference" select="@referencedObject"/>
		<!-- see note anchoring and PCR 793 -->
		<xsl:if test="@ID">
			<a name="{@ID}"/>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="boolean(//v3:observationMedia[@ID=$reference]//v3:text)">
				<img alt="{//v3:observationMedia[@ID=$reference]//v3:text}" src="{//v3:observationMedia[@ID=$reference]//v3:reference/@value}">
					<xsl:apply-templates select="@*"/>
				</img>
			</xsl:when>
			<xsl:when test="not(boolean(//v3:observationMedia[@ID=$reference]//v3:text))">
				<img alt="Image from Drug Label Content" src="{//v3:observationMedia[@ID=$reference]//v3:reference/@value}">
					<xsl:apply-templates select="@*"/>
				</img>
			</xsl:when>
		</xsl:choose>
		<xsl:apply-templates mode="notCentered" select="v3:caption"/>
	</xsl:template>
	<xsl:template mode="mixed" match="v3:renderMultiMedia[@referencedObject]">
		<xsl:variable name="reference" select="@referencedObject"/>
		<div>
			<xsl:call-template name="styleCodeAttr">
				<xsl:with-param name="styleCode" select="@styleCode"/>
				<xsl:with-param name="additionalStyleCode" select="'Figure'"/>
			</xsl:call-template>
			<xsl:apply-templates select="@*[not(local-name(.)='styleCode')]"/>

			<!-- see note anchoring and PCR 793 -->
			<xsl:if test="@ID">
				<a name="{@ID}"/>
			</xsl:if>

			<xsl:choose>
				<xsl:when test="boolean(//v3:observationMedia[@ID=$reference]//v3:text)">
					<img alt="{//v3:observationMedia[@ID=$reference]//v3:text}" src="{//v3:observationMedia[@ID=$reference]//v3:reference/@value}">
						<xsl:apply-templates select="@*"/>
					</img>
				</xsl:when>
				<xsl:when test="not(boolean(//v3:observationMedia[@ID=$reference]//v3:text))">
					<img alt="Image from Drug Label Content" src="{//v3:observationMedia[@ID=$reference]//v3:reference/@value}">
						<xsl:apply-templates select="@*"/>
					</img>
				</xsl:when>
			</xsl:choose>
			<xsl:apply-templates select="v3:caption"/>
		</div>
	</xsl:template>
	<xsl:template mode="mixed" match="v3:paragraph|v3:list|v3:table|v3:footnote|v3:footnoteRef|v3:flushfootnotes">
		<xsl:param name="isTableOfContent"/>
		<xsl:choose>
			<xsl:when test="$isTableOfContent='yes'">
				<xsl:apply-templates select=".">
					<xsl:with-param name="isTableOfContent2" select="'yes'"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select=".">
					<xsl:with-param name="isTableOfContent2" select="'no'"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template mode="mixed" match="v3:linkHtml">
		<xsl:element name="a">
			<xsl:attribute name="href"><xsl:value-of select="./@href"/></xsl:attribute>
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>
	<!-- TABLE MODEL -->
	<!-- Health Canada Change-->
	<xsl:template match="v3:table">
		<!-- see note anchoring and PCR 793 -->
		<xsl:if test="@ID">
			<a name="{@ID}"/>
		</xsl:if>
		<!-- Health Canada Change added attributes for tables-->
		<table width="100%" border="1" style="border:solid 2px;">
			<xsl:apply-templates select="@*|node()"/>
		</table>
	</xsl:template>
	<xsl:template match="v3:table/@summary|v3:table/@width|v3:table/@border|v3:table/@frame|v3:table/@rules|v3:table/@cellspacing|v3:table/@cellpadding">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="v3:thead">
		<thead>
			<xsl:apply-templates select="@*|node()"/>
		</thead>
	</xsl:template>
	<xsl:template match="v3:thead/@align|v3:thead/@char|v3:thead/@charoff|v3:thead/@valign">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="v3:tfoot" name="flushtablefootnotes">
		<xsl:variable name="allspan" select="count(ancestor::v3:table[1]/v3:colgroup/v3:col|ancestor::v3:table[1]/v3:col)"/>
		<xsl:if test="self::v3:tfoot or ancestor::v3:table[1]//v3:footnote">
			<tfoot>
				<xsl:if test="self::v3:tfoot">
					<xsl:apply-templates select="@*|node()"/>
				</xsl:if>
				<xsl:if test="ancestor::v3:table[1]//v3:footnote">
					<tr>
						<td colspan="{$allspan}" align="left">
							<dl class="Footnote">
								<xsl:apply-templates mode="footnote" select="ancestor::v3:table[1]/node()"/>
							</dl>
						</td>
					</tr>
				</xsl:if>
			</tfoot>
		</xsl:if>
	</xsl:template>
	<xsl:template match="v3:tfoot/@align|v3:tfoot/@char|v3:tfoot/@charoff|v3:tfoot/@valign">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="v3:tbody">
		<xsl:if test="not(preceding-sibling::v3:tfoot) and not(preceding-sibling::v3:tbody)">
			<xsl:call-template name="flushtablefootnotes"/>
		</xsl:if>
		<tbody>
			<xsl:apply-templates select="@*|node()"/>
		</tbody>
	</xsl:template>
	<xsl:template match="v3:tbody[not(preceding-sibling::v3:thead)]">
		<xsl:if test="not(preceding-sibling::v3:tfoot) and not(preceding-sibling::tbody)">
			<xsl:call-template name="flushtablefootnotes"/>
		</xsl:if>
		<tbody>
			<xsl:call-template name="styleCodeAttr">
				<xsl:with-param name="styleCode" select="@styleCode"/>
				<xsl:with-param name="additionalStyleCode" select="'Headless'"/>
			</xsl:call-template>
			<xsl:call-template name="additionalStyleAttr"/>
			<xsl:apply-templates select="@*[not(local-name(.)='styleCode')]"/>
			<xsl:apply-templates select="node()"/>
		</tbody>
	</xsl:template>
	<xsl:template match="v3:tbody/@align|v3:tbody/@char|v3:tbody/@charoff|v3:tbody/@valign">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="v3:tr">
		<tr style="border-collapse: collapse;">
			<xsl:call-template name="styleCodeAttr">
				<xsl:with-param name="styleCode" select="@styleCode"/>
				<xsl:with-param name="additionalStyleCode">
					<xsl:choose>
						<xsl:when test="contains(ancestor::v3:table/@styleCode, 'Noautorules') and not(@styleCode)"> <!-- or contains(ancestor::v3:section/v3:code/@code, '43683-2') -->
							<xsl:text></xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="position()=1">
								<xsl:text>First </xsl:text>
							</xsl:if>
							<xsl:if test="position()=last()">
								<xsl:text>Last </xsl:text>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="additionalStyleAttr"/>
			<xsl:apply-templates select="@*[not(local-name(.)='styleCode')]"/>
			<xsl:apply-templates select="node()"/>
		</tr>
	</xsl:template>
	<xsl:template match="v3:td">
		<!-- determine our position to find out the associated col -->
		<!-- Health Canada Change added attributes for td-->
		<td style="padding:5px; border: solid 1px;">
			<xsl:call-template name="styleCodeAttr">
				<xsl:with-param name="styleCode" select="@styleCode"/>
			</xsl:call-template>
			<xsl:call-template name="additionalStyleAttr"/>
			<xsl:apply-templates select="@*[not(local-name(.)='styleCode')]"/>
			<xsl:apply-templates mode="mixed" select="node()"/>
		</td>
	</xsl:template>
	<xsl:template match="v3:td/@align|v3:td/@char|v3:td/@charoff|v3:td/@valign|v3:td/@abbr|v3:td/@axis|v3:td/@headers|v3:td/@scope|v3:td/@rowspan|v3:td/@colspan">
		<xsl:copy-of select="."/>
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
	<xsl:template name="string-ISO-date">
		<xsl:param name="text"/>
		<xsl:variable name="year" select="substring($text,1,4)"/>
		<xsl:variable name="month" select="substring($text,5,2)"/>
		<xsl:variable name="day" select="substring($text,7,2)"/>
		<xsl:choose>
			<xsl:when test="string-length($text) &gt; 12">
				<xsl:value-of select="concat($year, '-', $month, '-', $day, ' ', substring($text,9,2), ':', substring($text,11,2), ':', substring($text,13,2))"/>
			</xsl:when>
			<xsl:when test="string-length($text) &gt; 8">
				<xsl:value-of select="concat($year, '-', $month, '-', $day, ' ', substring($text,9,2), ':', substring($text,11,2))"/>
			</xsl:when>
			<xsl:when test="string-length($text) &lt; 1">
				<xsl:value-of select="'None'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($year, '-', $month, '-', $day)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="@styleCode" name="styleCodeAttr">
		<xsl:param name="styleCode" select="."/>
		<xsl:param name="additionalStyleCode" select="/.."/>
		<xsl:param name="allCodes" select="normalize-space(concat($additionalStyleCode,' ',$styleCode))"/>
		<xsl:param name="additionalStyleCodeSequence" select="/.."/>
		<xsl:variable name="splitRtf">
			<xsl:if test="$allCodes">
				<xsl:call-template name="splitTokens">
					<xsl:with-param name="text" select="$allCodes"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:for-each select="$additionalStyleCodeSequence">
				<token value="{concat(translate(substring(current(),1,1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), substring(current(),2))}"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="class">
			<xsl:choose>
				<xsl:when test="function-available('exsl:node-set')">
					<xsl:variable name="sortedTokensRtf">
						<xsl:for-each select="exsl:node-set($splitRtf)/token">
							<xsl:sort select="@value"/>
							<xsl:copy-of select="."/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:call-template name="uniqueStyleCodes">
						<xsl:with-param name="in" select="exsl:node-set($sortedTokensRtf)"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="function-available('msxsl:node-set')">
					<xsl:variable name="sortedTokensRtf">
						<xsl:for-each select="msxsl:node-set($splitRtf)/token">
							<xsl:sort select="@value"/>
							<xsl:copy-of select="."/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:call-template name="uniqueStyleCodes">
						<xsl:with-param name="in" select="msxsl:node-set($sortedTokensRtf)"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<!-- this one below should work for all parsers as it is using exslt but will keep the above code for msxsl for now -->
					<xsl:message>
						<xsl:call-template name="hpfb-title">
							<xsl:with-param name="code" select="'10099'"/>
							<!-- warningMissingRequired -->
						</xsl:call-template>
					</xsl:message>
					<xsl:for-each select="str:tokenize($allCodes, ' ')">
						<xsl:sort select="."/>
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($class) &gt; 0">
				<xsl:attribute name="class">
					<xsl:value-of select="normalize-space($class)"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test="string-length($allCodes) &gt; 0">
				<xsl:attribute name="class">
					<xsl:value-of select="normalize-space($allCodes)"/>
				</xsl:attribute>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="additionalStyleAttr">
		<xsl:if test="self::*[self::v3:paragraph]//v3:content[@styleCode[contains(.,'xmChange')]] or v3:content[@styleCode[contains(.,'xmChange')]] and not(ancestor::v3:table)">
			<xsl:attribute name="style">
				<xsl:choose>
					<xsl:when test="self::*//v3:content/@styleCode[contains(.,'xmChange')] or v3:content/@styleCode[contains(.,'xmChange')]">border-left:1px solid;</xsl:when>
					<xsl:otherwise>margin-left:-1em; padding-left:1em; border-left:1px solid;</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template name="splitTokens">
		<xsl:param name="text" select="."/>
		<xsl:param name="firstCode" select="substring-before($text,' ')"/>
		<xsl:param name="restOfCodes" select="substring-after($text,' ')"/>
		<xsl:choose>
			<xsl:when test="$firstCode">
				<token value="{concat(translate(substring($firstCode,1,1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), substring($firstCode,2))}"/>
				<xsl:if test="string-length($restOfCodes) &gt; 0">
					<xsl:call-template name="splitTokens">
						<xsl:with-param name="text" select="$restOfCodes"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<token value="{concat(translate(substring($text,1,1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), substring($text,2))}"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="uniqueStyleCodes">
		<xsl:param name="in" select="/.."/>
		<xsl:for-each select="$in/token[not(preceding::token/@value = @value)]">
			<xsl:value-of select="@value"/>
			<xsl:text> </xsl:text>
		</xsl:for-each>
	</xsl:template>
	<xsl:template mode="showDataWithBR" match="*">
		<xsl:value-of select="."/><xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
	</xsl:template>
	<xsl:template name="hpfb-label">
		<xsl:param name="codeSystem" select="/.."/>
		<xsl:param name="code" select="/.."/>
		<xsl:variable name="tempDoc" select="document(concat($oids-base-url,$codeSystem,$file-suffix))"/>
		<xsl:variable name="node" select="$tempDoc/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code' and SimpleValue=$code]"/>
		<xsl:variable name="value" select="$node/../Value[@ColumnRef=$display_language]/SimpleValue"/>
		<xsl:if test="$value"><xsl:value-of select="$value"/></xsl:if>
		<xsl:if test="not($value)">Error: code missing:(<xsl:value-of select="$code"/> in <xsl:value-of select="$codeSystem"/>)</xsl:if>
	</xsl:template>
	<xsl:template name="hpfb-title">
		<xsl:param name="code" select="/.."/>
		<xsl:variable name="node" select="$vocabulary/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code' and SimpleValue=$code]"/>
		<xsl:variable name="value" select="$node/../Value[@ColumnRef=$display_language]/SimpleValue"/>
		<xsl:if test="$value">
			<xsl:value-of select="$value"/>
		</xsl:if>
		<xsl:if test="not($value)">Error: code missing:(<xsl:value-of select="$code"/> in <xsl:value-of select="$section-id-oid"/>)</xsl:if>
	</xsl:template>

</xsl:transform><!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="yes" name="CPID" userelativepaths="no" externalpreview="yes" url="file:///e:/CPID-3.xml" htmlbaseurl="" outputurl="file:///c:/SPM/test/cpid.html" processortype="saxon8" useresolver="yes" profilemode="0" profiledepth=""
		          profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal"
		          customvalidator="">
			<parameterValue name="oids-base-url" value="'https://raw.githubusercontent.com/HealthCanada/HPFB/master/Controlled-Vocabularies/Content/'"/>
			<parameterValue name="css" value="'file://C:\IP-602\HPFB\Structured-Product-Labeling-(SPL)\Style-Sheets\CPID\dev\hpfb-cpid-core.css'"/>
			<parameterValue name="resourcesdir" value="'file://C:\IP-602\HPFB\Structured-Product-Labeling-(SPL)\Style-Sheets\CPID\dev\'"/>
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