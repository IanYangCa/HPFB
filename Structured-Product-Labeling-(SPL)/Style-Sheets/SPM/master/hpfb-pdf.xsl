<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:s="http://www.stylusstudio.com/xquery" 
	xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" 
	xmlns:str="http://exslt.org/strings" 
	xmlns:exsl="http://exslt.org/common" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:v3="urn:hl7-org:v3" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:import href="hpfb-attributes.xsl"/>

	<xsl:param name="input1" select="document('file:///c:/Users/hcuser/HC/HPFB/Controlled-Vocabularies/Content/2.16.840.1.113883.2.20.6.10.xml')"/>
	<xsl:param name="oids-base-url" select="/.."/>

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

	<xsl:variable name="root" select="."/>
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

	<xsl:template match="/">
		<fo:root >
			<fo:layout-master-set>
				<fo:simple-page-master master-name="default-page" page-height="11in" page-width="8.5in" margin-left="0.5in" margin-right="0.5in" margin-top="0.79in" margin-bottom="0.79in">
					<fo:region-body/>
				</fo:simple-page-master>
			</fo:layout-master-set>
			<fo:page-sequence master-reference="default-page">
				<fo:flow flow-name="xsl-region-body">
					<fo:block>
						<xsl:call-template name="TitlePage"/>
					</fo:block>
					<fo:block keep-with-previous.within-page="0"/>
					<fo:block font-weight="bold">
						<xsl:call-template name="hpfb-title">
							<xsl:with-param name="code" select="'170'"/>
						</xsl:call-template>:
						<xsl:value-of select="/descendant-or-self::*[@code='170' and @codeSystem=$section-id-oid]/../v3:text"/>
					</fo:block>
				</fo:flow>
			</fo:page-sequence>
			<fo:page-sequence master-reference="default-page">
				<fo:flow flow-name="xsl-region-body">
				<xsl:apply-templates select="//v3:code[@code='440' and @codeSystem=$section-id-oid]/..">
					<xsl:with-param name="render440" select="'xxx'"/>
				</xsl:apply-templates>
				</fo:flow>
			</fo:page-sequence>
			<xsl:call-template name="toc"/>
			<fo:page-sequence master-reference="default-page" initial-page-number="1">
				<fo:flow flow-name="xsl-region-body">
					<xsl:apply-templates select="$root/v3:document/v3:component">
						<xsl:with-param name="render440" select="'440'"/>
					</xsl:apply-templates>
					<fo:block>
					<xsl:apply-templates mode="subjects" select="//v3:section/v3:subject/*[self::v3:manufacturedProduct or self::v3:identifiedSubstance]"/>
					</fo:block>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
		
	</xsl:template>
	<xsl:template name="TitlePage">
						<fo:block text-align="center">
							<fo:block line-height="100pt">
								<xsl:text> </xsl:text>
							</fo:block>
							<fo:block>
								<fo:block text-align="center">
									<fo:block>
										<fo:inline font-size="30pt" font-weight="bold">
				<xsl:value-of select="$documentTypes/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code' and SimpleValue=$root/v3:document/v3:code/@code]/../Value[@ColumnRef=$display_language]/SimpleValue"/>
										</fo:inline>
									</fo:block>
								</fo:block>
							</fo:block>
							<fo:block line-height="80pt">
								<fo:block text-align="center">
									<fo:block>
										<fo:inline font-size="12pt" font-weight="bold">
											<xsl:call-template name="hpfb-title">
												<xsl:with-param name="code" select="'10031'"/>
												<!-- IncludePatientMedicationInformation -->
											</xsl:call-template>
										</fo:inline>
									</fo:block>
								</fo:block>
							</fo:block>
							<fo:block line-height="80pt">
								<xsl:value-of select="$root/v3:document/v3:title"/>
							</fo:block>
							<fo:block line-height="180pt">
								<xsl:text> </xsl:text>
							</fo:block>
							<fo:block text-align="center">
				<fo:table>
					<fo:table-column column-width="3.8in" number-columns-repeated="2"/>
					<fo:table-body>
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="myBorder">
							<xsl:call-template name="companyAddress"/>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="myBorder">
							<fo:block>
							<xsl:call-template name="hpfb-title">
								<xsl:with-param name="code" select="'10103'"/>
							</xsl:call-template>:
							<xsl:call-template name="string-ISO-date">
								<xsl:with-param name="text" select="/v3:document/v3:effectiveTime/v3:originalText"/>
							</xsl:call-template>
							</fo:block>
							<fo:block><fo:leader/></fo:block>
							<fo:block><fo:leader/></fo:block>
							<fo:block>
							<xsl:call-template name="hpfb-title">
								<xsl:with-param name="code" select="'10105'"/>
							</xsl:call-template>:
							<xsl:call-template name="string-ISO-date">
								<xsl:with-param name="text" select="/v3:document/v3:effectiveTime/@value"/>
							</xsl:call-template>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
					</fo:table-body>
				</fo:table>
							</fo:block>
							<fo:block>
								<xsl:text> </xsl:text>
							</fo:block>
						</fo:block>
	</xsl:template>
	<xsl:template name="companyAddress">
		<xsl:variable name="organization" select="/v3:document/v3:author/v3:assignedEntity/v3:representedOrganization"/>
		<fo:block>
			<xsl:value-of select="$organization/v3:name"/>
		</fo:block>
		<fo:block>
 			<fo:leader/>
		</fo:block>
		<fo:block>
			<xsl:value-of select="/v3:document/v3:author/v3:assignedEntity/v3:representedOrganization/v3:contactParty/v3:contactPerson/v3:name"/>
		</fo:block>
		<fo:block>
			<xsl:value-of select="$organization/v3:contactParty/v3:addr/v3:streetAddressLine"/>
		</fo:block>
		<fo:block>
			<xsl:value-of select="$organization/v3:contactParty/v3:addr/v3:city"/>, <xsl:value-of select="$organization/v3:contactParty/v3:addr/v3:state"/>
		</fo:block>
		<fo:block>
			<xsl:value-of select="$organization/v3:contactParty/v3:addr/v3:postalCode"/>
		</fo:block>
		<fo:block>
			<xsl:call-template name="hpfb-label">
				<xsl:with-param name="codeSystem" select="$country-code-oid"/>
				<xsl:with-param name="code" select="$organization/v3:contactParty/v3:addr/v3:country/@code"/>
			</xsl:call-template>
		</fo:block>
	</xsl:template>
	<xsl:template name="toc">
		<fo:page-sequence master-reference="default-page" force-page-count="no-force">
			<fo:flow flow-name="xsl-region-body">
				<xsl:apply-templates select="$root/v3:document/v3:component" mode="tableOfContents"/>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>
	<xsl:template match="v3:section" mode="tableOfContents">
		<xsl:param name="parentPrefix" select="''"/>
		<xsl:variable name="code" select="v3:code/@code"/>
		<xsl:variable name="validCode" select="$section-id-oid"/>
		<xsl:variable name="heading" select="$codeLookup/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code' and SimpleValue=$code]/../Value[@ColumnRef='level']/SimpleValue"/>
		<!-- Determine most right prefix. -->
		<xsl:variable name="prefix">
			<xsl:choose>
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
				<xsl:when test="$heading='3' or $heading='4' or $heading='5'">
					<xsl:value-of select="count(../preceding-sibling::v3:component[v3:section/v3:code[@codeSystem=$validCode]]) + 1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'5'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$codeLookup/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code' and SimpleValue=$code]/../Value[@ColumnRef='include_in_toc' and SimpleValue = 'True']">
			<fo:block text-align-last="justify">
				<xsl:call-template name="attributes">
					<xsl:with-param name="heading" select="$heading" />
				</xsl:call-template>
				<xsl:choose>
					<xsl:when test="$heading='1'">
								<xsl:value-of select="v3:title"/>
					</xsl:when>
					<xsl:when test="$heading='2'">
								<xsl:value-of select="concat($prefix,'. ')"/>
								<xsl:value-of select="v3:title"/>
					</xsl:when>
					<xsl:when test="$heading='3'">
								<xsl:value-of select="concat($parentPrefix,'.')"/>
								<xsl:value-of select="concat($prefix,' ')"/>
								<xsl:value-of select="v3:title"/>
					</xsl:when>
					<xsl:when test="$heading='4'">
								<xsl:value-of select="concat($parentPrefix,'.')"/>
								<xsl:value-of select="concat($prefix,' ')"/>
								<xsl:value-of select="v3:title"/>
					</xsl:when>
					<xsl:when test="$heading='5'">
								<xsl:value-of select="concat($parentPrefix,'.')"/>
								<xsl:value-of select="concat($prefix,' ')"/>
								<xsl:value-of select="v3:title"/>
					</xsl:when>
					<xsl:otherwise>Error: <xsl:value-of select="$code"/>/<xsl:value-of select="$heading"/></xsl:otherwise>
				</xsl:choose>
				<fo:basic-link internal-destination="{generate-id()}">
					<xsl:value-of select="title"/>
				</fo:basic-link>
				<fo:inline font-weight="normal" font-size="10pt">
					<fo:leader leader-pattern="dots"/>
					<fo:page-number-citation ref-id="{generate-id()}"/>
				</fo:inline>
			</fo:block>
			<!--Health Canada Call the template for the subsequent sections -->
			<xsl:apply-templates select="v3:component/v3:section" mode="tableOfContents">
				<xsl:with-param name="parentPrefix">
					<!--Health Canada  Send the rendered prefix down to nested elements. -->
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

		</xsl:if>
	</xsl:template>
	<xsl:template mode="subjects" match="v3:section[v3:code/@code ='48780-1'][not(v3:subject/v3:manufacturedProduct)]/v3:text">
		<fo:block>
		<fo:table class="contentTablePetite" cellSpacing="0" cellPadding="3" width="100%">
			<fo:table-body>
<!--				<xsl:call-template name="ProductInfoBasic"/>-->
			</fo:table-body>
		</fo:table>
		</fo:block>
	</xsl:template>
	<!-- Note: This template is also used for top level Product Concept which does not have v3:asEquivalentEntity -->
	<xsl:template mode="subjects" match="v3:section/v3:subject/v3:manufacturedProduct/*[self::v3:manufacturedProduct[v3:name or v3:formCode] or self::v3:manufacturedMedicine]|v3:section/v3:subject/v3:identifiedSubstance/v3:identifiedSubstance">
<!--		<div>
			<xsl:if test="../v3:subjectOf/v3:marketingAct/v3:code[@codeSystem=$term-status-oid]/../v3:effectiveTime/v3:high">
				<xsl:call-template name="styleCodeAttr">
					<xsl:with-param name="styleCode" select="'Watermark'"/>
				</xsl:call-template>
				<xsl:variable name="watermarkText">
					<xsl:call-template name="hpfb-label">
						<xsl:with-param name="codeSystem" select="$term-status-oid"/>
						<xsl:with-param name="code" select="../v3:subjectOf/v3:marketingAct/v3:code[@codeSystem=$term-status-oid]/@code"/>
					</xsl:call-template>&#160;&#160;<xsl:call-template name="hpfb-title"><xsl:with-param name="code" select="'10104'"/> date </xsl:call-template>:&#160;<xsl:call-template name="string-ISO-date"><xsl:with-param name="text"><xsl:value-of select="../v3:subjectOf/v3:marketingAct/v3:code[@codeSystem=$term-status-oid]/../v3:effectiveTime/v3:high/@value"/></xsl:with-param></xsl:call-template>
				</xsl:variable>
				<div class="WatermarkTextStyle">
					<xsl:value-of select="$watermarkText"/>
				</div>
			</xsl:if>-->
			<fo:table xsl:use-attribute-sets="myBorder" border-spacing="0pt 0pt">
				<fo:table-column column-width="7in"/>
				<xsl:if test="../v3:subjectOf/v3:marketingAct/v3:code[@codeSystem=$marketing-status-oid]/../v3:effectiveTime/v3:high">
					<xsl:call-template name="styleCodeAttr">
						<xsl:with-param name="styleCode" select="'contentTablePetite'"/>
						<xsl:with-param name="additionalStyleCode" select="'WatermarkText'"/>
					</xsl:call-template>
				</xsl:if>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell text-align="left" font-weight="bold" >
						<fo:block>
								<xsl:choose>
									<xsl:when test="v3:ingredient">
										<xsl:call-template name="hpfb-title">
											<xsl:with-param name="code" select="'10000'"/>
											<!-- abstractProductConcept -->
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="hpfb-title">
											<xsl:with-param name="code" select="'10007'"/>
											<!-- applicationProductConcept -->
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
						</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<xsl:call-template name="piMedNames"/>
					<xsl:apply-templates mode="substance" select="v3:moiety"/>
					<!--Linkage Table-->
					<xsl:call-template name="ProductInfoBasic"/>
					<!-- Note: there could be a better way to avoid calling this for substances-->
					<xsl:choose>
						<!-- if this is a multi-component subject then call to parts template -->
						<xsl:when test="v3:part">
							<xsl:apply-templates mode="subjects" select="v3:part"/>
<!--							<xsl:call-template name="ProductInfoIng"/>-->
						</xsl:when>
						<!-- otherwise it is a single product and we simply need to display the ingredients, imprint and packaging. -->
						<xsl:otherwise>
<!--							<xsl:call-template name="ProductInfoIng"/>-->
						</xsl:otherwise>
					</xsl:choose>

					<fo:table-row>
						<fo:table-cell>
<!--							<xsl:call-template name="image">
								<xsl:with-param name="path" select="../v3:subjectOf/v3:characteristic[v3:code/@code='2']"/>
							</xsl:call-template>-->
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row>
						<fo:table-cell>
<!--							<xsl:call-template name="MarketingInfo"/>-->
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row>
						<fo:table-cell>
							<xsl:variable name="currCode" select="v3:code/@code"></xsl:variable>
							<xsl:for-each select="ancestor::v3:section[1]/v3:subject/v3:manufacturedProduct/v3:manufacturedProduct[v3:asEquivalentEntity/v3:definingMaterialKind/v3:code/@code = $currCode]">
<!--								<xsl:call-template name="equivalentProductInfo"></xsl:call-template>-->
							</xsl:for-each>
						</fo:table-cell>
					</fo:table-row>
					<xsl:if test="v3:instanceOfKind">
						<fo:table-row>
							<fo:table-cell>
								<fo:table width="100%" cellpadding="3" cellspacing="0" class="formTablePetite">
									<xsl:apply-templates mode="ldd" select="v3:instanceOfKind"/>
								</fo:table>
							</fo:table-cell>
						</fo:table-row>
					</xsl:if>
				</fo:table-body>
			</fo:table>
<!--		</div>-->
	</xsl:template>
	<xsl:template mode="subjects" match="//v3:author/v3:assignedEntity/v3:representedOrganization/v3:assignedEntity/v3:assignedOrganization/v3:assignedEntity/v3:assignedOrganization">
		<xsl:if test="./v3:name">
			<fo:table width="100%">
				<fo:table-column />
				<fo:table-column />
				<fo:table-column />
				<fo:table-column />
				<fo:table-column />
				<xsl:variable name="role_id" select="./v3:id[@root=$organization-role-oid]/@extension"/>
				<xsl:variable name="role_name" select="(document(concat($oids-base-url,$organization-role-oid,$file-suffix)))/gc:CodeList/SimpleCodeList/Row[./Value[@ColumnRef='code']/SimpleValue=$role_id]/Value[@ColumnRef=$display_language]/SimpleValue"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell colspan="5" class="formHeadingReg">
							<fo:inline>
								<xsl:variable name="extension" select="current()/id[@root='']/@extension"/>
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
							</fo:inline>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row>
						<fo:table-cell>
							<xsl:call-template name="hpfb-title">
								<xsl:with-param name="code" select="'10076'"/>
								<!-- role -->
							</xsl:call-template>
						</fo:table-cell>
						<fo:table-cell>
							<xsl:call-template name="hpfb-title">
								<xsl:with-param name="code" select="'10051'"/>
								<!-- name -->
							</xsl:call-template>
						</fo:table-cell>
						<fo:table-cell>
							<xsl:call-template name="hpfb-title">
								<xsl:with-param name="code" select="'10003'"/>
								<!-- address -->
							</xsl:call-template>
						</fo:table-cell>
						<fo:table-cell>
							<xsl:call-template name="hpfb-title">
								<xsl:with-param name="code" select="'10027'"/>
								<!-- ID_FEI -->
							</xsl:call-template>
						</fo:table-cell>
						<fo:table-cell>
							<xsl:call-template name="hpfb-title">
								<xsl:with-param name="code" select="'10010'"/>
								<!-- businessOperations -->
							</xsl:call-template>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row>
						<fo:table-cell>
							<xsl:value-of select="$role_name"/>
						</fo:table-cell>
						<fo:table-cell>
							<xsl:value-of select="./v3:name"/>
						</fo:table-cell>
						<fo:table-cell>
							<xsl:apply-templates mode="format" select="./v3:addr"/>
						</fo:table-cell>
						<fo:table-cell>
							<xsl:value-of select="./v3:id/@extension"/>
						</fo:table-cell>
						<fo:table-cell>
							<xsl:for-each select="../v3:performance[not(v3:actDefinition/v3:code/@code = preceding-sibling::*/v3:actDefinition/v3:code/@code)]/v3:actDefinition/v3:code">
								<xsl:variable name="code" select="@code"/>
								<xsl:value-of select="@displayName"/>

								<xsl:variable name="itemCodes" select="../../../v3:performance/v3:actDefinition[v3:code/@code = $code]/v3:product/v3:manufacturedProduct/v3:manufacturedMaterialKind/v3:code/@code"/>
								<xsl:if test="$itemCodes">
									<xsl:text>(</xsl:text>
									<xsl:for-each select="$itemCodes">
										<xsl:value-of select="."/>
										<xsl:if test="position()!=last()">,</xsl:if>
									</xsl:for-each>
									<xsl:text>) </xsl:text>
								</xsl:if>
								<xsl:for-each select="../v3:subjectOf/v3:approval/v3:code[@code]">
									<xsl:text>(</xsl:text>
									<xsl:value-of select="@displayName"/>
									<xsl:text>)</xsl:text>
									<xsl:for-each select="../v3:subjectOf/v3:action/v3:code[@code]">
										<xsl:if test="position()!=last()">,</xsl:if>
										<xsl:value-of select="@displayName"/>
										<xsl:text>(</xsl:text>
										<xsl:if test="../v3:code[@displayName = 'other']">
											<xsl:call-template name="hpfb-title">
												<xsl:with-param name="code" select="'10091'"/>
												<!-- text -->
											</xsl:call-template>-
											<xsl:value-of select="../v3:text/text()"/>
											<xsl:if test="../v3:subjectOf/v3:document">
												<xsl:text>, </xsl:text>
											</xsl:if>
										</xsl:if>
										<xsl:for-each select="../v3:subjectOf/v3:document/v3:text[@mediaType]/v3:reference">
											<xsl:value-of select="@value"/>
											<xsl:if test="position()!=last()">,</xsl:if>
										</xsl:for-each>
										<xsl:text>)</xsl:text>
										<xsl:if test="position()!=last()">,</xsl:if>
									</xsl:for-each>
									<xsl:if test="position()!=last()">,</xsl:if>
								</xsl:for-each>
								<xsl:if test="position()!=last()">,</xsl:if>
							</xsl:for-each>
						</fo:table-cell>
					</fo:table-row>
					<xsl:call-template name="data-contactParty"/>
				</fo:table-body>
			</fo:table>
		</xsl:if>
	</xsl:template>
	<xsl:template name="data-contactParty">
		<xsl:for-each select="v3:contactParty">
			<xsl:if test="position() = 1">
				<fo:table-row>
					<fo:table-cell>
						<xsl:call-template name="hpfb-title">
							<xsl:with-param name="code" select="'10016'"/>
							<!-- contact -->
						</xsl:call-template>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" >
						<xsl:call-template name="hpfb-title">
							<xsl:with-param name="code" select="'10003'"/>
							<!-- address -->
						</xsl:call-template>
					</fo:table-cell>
					<fo:table-cell>
						<xsl:call-template name="hpfb-title">
							<!-- telephoneNumber -->
							<xsl:with-param name="code" select="'10090'"/>
						</xsl:call-template>
					</fo:table-cell>
					<fo:table-cell>
						<xsl:call-template name="hpfb-title">
							<!-- emailAddress -->
							<xsl:with-param name="code" select="'10022'"/>
						</xsl:call-template>
					</fo:table-cell>
				</fo:table-row>
			</xsl:if>
			<fo:table-row>
				<fo:table-cell>
					<xsl:value-of select="v3:contactPerson/v3:name"/>
				</fo:table-cell>
				<fo:table-cell number-columns-spanned="2">
					<xsl:apply-templates mode="format" select="v3:addr"/>
				</fo:table-cell>
				<fo:table-cell>
					<xsl:value-of select="substring-after(v3:telecom/@value[starts-with(.,'tel:')][1], 'tel:')"/>
					<xsl:for-each select="v3:telecom/@value[starts-with(.,'fax:')]">
						<xsl:call-template name="newLine"/>
						<xsl:text>FAX: </xsl:text>
						<xsl:call-template name="hpfb-title">
							<xsl:with-param name="code" select="'10076'"/>
							<!-- role -->
						</xsl:call-template>
						<xsl:value-of select="substring-after(., 'fax:')"/>
					</xsl:for-each>
				</fo:table-cell>
				<fo:table-cell number-columns-spanned="2">
					<xsl:value-of select=" substring-after(v3:telecom/@value[starts-with(.,'mailto:')][1], 'mailto:')"/>
				</fo:table-cell>
			</fo:table-row>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="piMedNames">
		<xsl:variable name="medName">
			<xsl:call-template name="string-uppercase">
				<xsl:with-param name="text">
					<xsl:copy>
						<xsl:apply-templates mode="specialCus" select="v3:name"/>
					</xsl:copy>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="genMedName">
			<xsl:call-template name="string-uppercase">
				<xsl:with-param name="text" select="v3:asEntityWithGeneric/v3:genericMedicine/v3:name|v3:asSpecializedKind/v3:generalizedMaterialKind/v3:code[@codeSystem = '2.16.840.1.113883.6.276'  or @codeSystem = '2.16.840.1.113883.6.303']/@displayName"/>
			</xsl:call-template>
		</xsl:variable>

		<fo:table-row>
			<fo:table-cell>
				<fo:block font-weight="bold">
					<xsl:value-of select="$medName"/>&#xA0;
					<xsl:call-template name="string-uppercase">
						<xsl:with-param name="text" select="v3:name/v3:suffix"/>
					</xsl:call-template>
				</fo:block>
				<xsl:apply-templates mode="substance" select="v3:code[@codeSystem = '2.16.840.1.113883.4.9']/@code"/>
				<fo:block xsl:use-attribute-sets="contentTableReg">
					<xsl:call-template name="string-lowercase">
						<xsl:with-param name="text" select="$genMedName"/>
					</xsl:call-template>
					<xsl:text> </xsl:text>
					<xsl:call-template name="string-lowercase">
						<xsl:with-param name="text" select="v3:formCode/@displayName"/>
					</xsl:call-template>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>
	<xsl:template name="ProductInfoBasic">
		<fo:table-row>
			<fo:table-cell>
				<fo:table width="100%" xsl:use-attribute-sets="formTablePetite">
					<fo:table-body>
					<fo:table-row>
						<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="formHeadingTitle">
							<xsl:call-template name="hpfb-title">
								<xsl:with-param name="code" select="'10066'"/>
								<!-- productInformation -->
							</xsl:call-template>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row xsl:use-attribute-sets="formTableRowAlt">
						<xsl:if test="not(../../v3:part)">
							<fo:table-cell class="formLabel">
								<xsl:call-template name="hpfb-title">
									<xsl:with-param name="code" select="'10068'"/>
									<!-- productType -->
								</xsl:call-template>
							</fo:table-cell>
							<fo:table-cell xsl:use-attribute-sets="formItem">
								<!-- XXX: can't do in XSLT 1.0: xsl:value-of select="replace($documentTypes/v3:document[@code = $root/v3:document/v3:code/@code]/v3:title,'(^| )label( |$)',' ','i')"/ -->
								<xsl:value-of select="$documentTypes/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code' and SimpleValue=$root/v3:document/v3:code/@code]/../Value[@ColumnRef=$display_language]/SimpleValue"/>
							</fo:table-cell>
						</xsl:if>
						<xsl:for-each select="v3:code/@code">
							<fo:table-cell xsl:use-attribute-sets="formLabel">
								<xsl:call-template name="hpfb-title">
									<xsl:with-param name="code" select="'10039'"/>
									<!-- itemCodeSource -->
								</xsl:call-template>
							</fo:table-cell>
							<fo:table-cell xsl:use-attribute-sets="formItem">
								<xsl:variable name="approval" select="current()/../../../v3:subjectOf/v3:approval/v3:code[@codeSystem = $marketing-category-oid]"/>
								<xsl:value-of select="$approval/@displayName"/>
								<xsl:text>( </xsl:text>
								<xsl:value-of select="$approval/@code"/>
								<xsl:text> )</xsl:text>
							</fo:table-cell>
						</xsl:for-each>
					</fo:table-row>
					<xsl:if test="../v3:subjectOf/v3:policy/v3:code/@displayName or  ../v3:consumedIn/*[self::v3:substanceAdministration       or self::v3:substanceAdministration1]/v3:routeCode and not(v3:part)">
						<fo:table-row xsl:use-attribute-sets="formTableRow">
							<xsl:if test="../v3:consumedIn/*[self::v3:substanceAdministration or self::v3:substanceAdministration1]/v3:routeCode and not(v3:part)">
								<fo:table-cell width="30%" xsl:use-attribute-sets="formLabel">
									<xsl:call-template name="hpfb-title">
										<xsl:with-param name="code" select="'10077'"/>
										<!-- routeOfAdministration -->
									</xsl:call-template>
								</fo:table-cell>
								<fo:table-cell xsl:use-attribute-sets="formItem">
									<xsl:for-each select="../v3:consumedIn/*[self::v3:substanceAdministration or self::v3:substanceAdministration1]/v3:routeCode">
										<xsl:if test="position() &gt; 1">,</xsl:if>
										<xsl:value-of select="@displayName"/>
									</xsl:for-each>
								</fo:table-cell>
							</xsl:if>
							<xsl:if test="../v3:subjectOf/v3:policy/v3:code/@displayName">
								<fo:table-cell width="30%" xsl:use-attribute-sets="formLabel">
									<xsl:call-template name="hpfb-title">
										<xsl:with-param name="code" select="'10019'"/>
										<!-- DEA_Schedule -->
									</xsl:call-template>
								</fo:table-cell>
								<fo:table-cell xsl:use-attribute-sets="formItem">
									<xsl:value-of select="../v3:subjectOf/v3:policy/v3:code/@displayName"/>&#xA0;&#xA0;&#xA0;&#xA0;
								</fo:table-cell>
							</xsl:if>
						</fo:table-row>
					</xsl:if>
					<xsl:if test="../../../v3:effectiveTime[v3:low/@value or v3:high/@value]  or  ../v3:effectiveTime[v3:low/@value and v3:high/@value]">
						<fo:table-row xsl:use-attribute-sets="formTableRowAlt">
							<fo:table-cell xsl:use-attribute-sets="formLabel">
								<xsl:call-template name="hpfb-title">
									<xsl:with-param name="code" select="'10070'"/>
									<!-- reportingPeriod -->
								</xsl:call-template>
							</fo:table-cell>
							<fo:table-cell xsl:use-attribute-sets="formItem">
								<xsl:variable name="range" select="ancestor::v3:section[1]/v3:effectiveTime"/>
								<xsl:value-of select="$range/v3:low/@value"/>
								<xsl:text>-</xsl:text>
								<xsl:value-of select="$range/v3:high/@value"/>
							</fo:table-cell>
							<xsl:if test=" ../../../../v3:section[v3:subject/v3:manufacturedProduct]">
								<fo:table-cell xsl:use-attribute-sets="formLabel"/>
								<fo:table-cell xsl:use-attribute-sets="formItem"/>
							</xsl:if>
						</fo:table-row>
					</xsl:if>
				</fo:table-body>
				</fo:table>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>
	<xsl:template mode="ldd" match="/|node()|@*">
		<xsl:apply-templates mode="ldd" select="@*|node()"/>
	</xsl:template>
	<xsl:template name="attributes">
		<xsl:param name="heading" select="/.." />
		<xsl:attribute name="margin-left">
			<xsl:value-of select="($heading - 1) * 2"/>
			<xsl:text>em</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="space-before">
			<xsl:choose>
				<xsl:when test="$heading='1'">4pt</xsl:when>
				<xsl:when test="$heading='2'">3pt</xsl:when>
				<xsl:when test="$heading='3'">3pt</xsl:when>
				<xsl:when test="$heading='4'">2pt</xsl:when>
				<xsl:otherwise>1pt</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
		<xsl:attribute name="space-after">
			<xsl:choose>
				<xsl:when test="$heading='2'">3pt</xsl:when>
				<xsl:when test="$heading='3'">1pt</xsl:when>
				<xsl:otherwise>1pt</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="space-after.conditionality">retain</xsl:attribute>
		<xsl:attribute name="font-size">
			<xsl:choose>
				<xsl:when test="$heading='1'">1.1em</xsl:when>
				<xsl:otherwise>1em</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="font-weight">
			<xsl:value-of select="800 - $heading * 100"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="v3:section">
		<xsl:param name="sectionLevel" select="count(ancestor-or-self::v3:section)"/>
		<xsl:param name="render440" select="'440'"/>
		<xsl:variable name="sectionNumberSequence">
			<xsl:apply-templates mode="sectionNumber" select="ancestor-or-self::v3:section"/>
		</xsl:variable>
		<xsl:variable name="code" select="v3:code/@code"/>

		<xsl:variable name="heading" select="$codeLookup/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code' and SimpleValue=$code]/../Value[@ColumnRef='level']/SimpleValue"/>
		<xsl:if test="not ($code='150' or $code='160' or $code='170' or $code=$render440 or $code='520')">
				<xsl:apply-templates select="v3:title">
					<xsl:with-param name="sectionLevel" select="$sectionLevel"/>
					<xsl:with-param name="sectionNumber" select="substring($sectionNumberSequence,2)"/>
				</xsl:apply-templates>
				<xsl:apply-templates mode="data" select="."/>
				<xsl:apply-templates select="@*|node()[not(self::v3:title)]">
					<xsl:with-param name="render440" select="$render440"/>
				</xsl:apply-templates>
<!--				<xsl:call-template name="flushSectionTitleFootnotes"/>-->
<!--			</div>-->
		</xsl:if>
	</xsl:template>
	<xsl:template match="@*|node()">
		<xsl:apply-templates select="*"/>
	</xsl:template>
	<xsl:template match="v3:text[not(parent::v3:observationMedia)]">
		<!-- Health Canada Change added font size attribute below-->
		<fo:block font-size="0.9em">
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates mode="mixed" select="node()"/>
			<xsl:apply-templates mode="rems" select="../v3:subject2[v3:substanceAdministration/v3:componentOf/v3:protocol]"/>
			<xsl:call-template name="flushfootnotes">
				<xsl:with-param name="isTableOfContent" select="'no'"/>
			</xsl:call-template>
		</fo:block>
	</xsl:template>
	<xsl:template match="v3:list[@listType='ordered']" priority="2">
		<xsl:apply-templates select="v3:caption"/>
		<fo:list-block>
			<xsl:if test="$root/v3:document[v3:code/@code = 'X9999-4']">
				<xsl:attribute name="start">
					<xsl:value-of select="count(preceding-sibling::v3:list/v3:item) + 1"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="@*|node()[not(self::v3:caption)]"/>
		</fo:list-block>
	</xsl:template>
	<xsl:template match="v3:list/v3:item">
		<fo:list-item xsl:use-attribute-sets="list.item">
			<fo:list-item-label end-indent="label-end()">
				<xsl:choose>
				<xsl:when test="../@listType = 'ordered'">
					<xsl:choose>
					<xsl:when test="../@styleCode = 'LittleAlpha'">
						<fo:block text-align="end">
							<xsl:number format="a."/>
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<fo:block text-align="end">
							<xsl:number format="1."/>
						</fo:block>
					</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="../v3:list[@listType='ordered']">
					<fo:block text-align="end">
						<xsl:number format="1."/>
					</fo:block>
				</xsl:when>
				<xsl:otherwise>
					<fo:block>.</fo:block>
				</xsl:otherwise>
				</xsl:choose>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" text-align="justify">
				<fo:block><xsl:apply-templates mode="mixed" select="node()"/></fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<xsl:template match="v3:title">
		<xsl:param name="sectionLevel" select="count(ancestor::v3:section)"/>
		<xsl:param name="sectionNumber" select="/.."/>

		<xsl:variable name="code" select="../v3:code/@code"/>
		<xsl:variable name="validCode" select="$section-id-oid"/>
		<xsl:variable name="tocObject" select="$codeLookup/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code' and SimpleValue=$code]/../Value[@ColumnRef='level']/SimpleValue"/>
		<xsl:variable name="eleSize">
			<xsl:choose>
				<xsl:when test="$sectionLevel &gt; 3">
					<xsl:value-of select="'3'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
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

		<fo:block>
			<xsl:call-template name="attributes">
				<xsl:with-param name="heading" select="$eleSize"/>
			</xsl:call-template>
			<xsl:attribute name="margin-left">0em</xsl:attribute>
			<xsl:attribute name="line-height">4pt</xsl:attribute>
			<xsl:if test="$sectionLevel ='1'">
				<xsl:attribute name="line-height">18pt</xsl:attribute>
			</xsl:if>

			<xsl:if test="$code != '440' and not($sectionLevel ='1')">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:if test="$sectionLevel = 2">
					<xsl:attribute name="line-height">16pt</xsl:attribute>
					<xsl:choose>
						<xsl:when test="name(../../parent::node())='structuredBody'">
							<xsl:value-of select="1 + count(../../preceding-sibling::v3:component[v3:section/v3:code[@codeSystem=$validCode]]) - count($root/v3:document/v3:component/v3:structuredBody/v3:component[v3:section/v3:code[@code=20]]/preceding-sibling::*) - count(../../preceding-sibling::v3:component[v3:section/v3:code[@code='30' or @code='40' or @code='480']])"/>
						</xsl:when>
						<xsl:when test="name(../../parent::node())='section'">
							<xsl:value-of select="1 + count(../../preceding-sibling::v3:component[v3:section/v3:code[@codeSystem=$validCode]]) + count(../../../../preceding-sibling::v3:component[v3:section/v3:code[@code='20' or @code='30' or @code='40']]/v3:section/child::v3:component[v3:section/v3:code[@codeSystem=$validCode]])"/>
						</xsl:when>
					</xsl:choose>
					<xsl:value-of select="'.'"/>
				</xsl:if>
				<xsl:if test="$sectionLevel = 3">
					<xsl:attribute name="line-height">14pt</xsl:attribute>
					<xsl:choose>
						<xsl:when test="name(../../../../parent::node())='structuredBody'">
							<xsl:value-of select="1 + count(../../../../preceding-sibling::v3:component[v3:section/v3:code[@codeSystem=$validCode]]) - count($root/v3:document/v3:component/v3:structuredBody/v3:component[v3:section/v3:code[@code=20]]/preceding-sibling::*) - count(../../../../preceding-sibling::v3:component[v3:section/v3:code[@code='30' or @code='40' or @code='480']])"/>
						</xsl:when>
						<xsl:when test="name(../../../../parent::node())='section'">
							<xsl:value-of select="1 + count(../../../../preceding-sibling::v3:component[v3:section/v3:code[@codeSystem=$validCode]]) + count(../../../../../../preceding-sibling::v3:component[v3:section/v3:code[@code='20' or @code='30' or @code='40']]/v3:section/child::v3:component[v3:section/v3:code[@codeSystem=$validCode]])"/>
						</xsl:when>
					</xsl:choose>
					<xsl:value-of select="concat('.',count(../../preceding-sibling::v3:component[v3:section/v3:code[@codeSystem=$validCode]]) + 1)"/>
				</xsl:if>
				<xsl:if test="$sectionLevel = 4">
					<xsl:attribute name="line-height">12pt</xsl:attribute>
					<xsl:choose>
						<xsl:when test="name(../../../../../../parent::node())='structuredBody'">
							<xsl:value-of select="1 + count(../../../../../../preceding-sibling::v3:component[v3:section/v3:code[@codeSystem=$validCode]]) - count($root/v3:document/v3:component/v3:structuredBody/v3:component[v3:section/v3:code[@code=20]]/preceding-sibling::*) - count(../../../../../../preceding-sibling::v3:component[v3:section/v3:code[@code='30' or @code='40' or @code='480']])"/>
						</xsl:when>
						<xsl:when test="name(../../../../../../parent::node())='section'">
							<xsl:value-of select="1 + count(../../../../../../preceding-sibling::v3:component[v3:section/v3:code[@codeSystem=$validCode]]) + count(../../../../../../../../preceding-sibling::v3:component[v3:section/v3:code[@code='20' or @code='30' or @code='40']]/v3:section/child::v3:component[v3:section/v3:code[@codeSystem=$validCode]])"/>
						</xsl:when>
					</xsl:choose>
					<xsl:value-of select="concat('.',count(../../../../preceding-sibling::v3:component[v3:section/v3:code[@codeSystem=$validCode]]) + 1)"/>
					<xsl:value-of select="concat('.',count(../../preceding-sibling::v3:component[v3:section/v3:code[@codeSystem=$validCode]]) + 1)"/>
				</xsl:if>
				<xsl:if test="$sectionLevel = 5">
					<xsl:attribute name="line-height">10pt</xsl:attribute>
					<xsl:choose>
						<xsl:when test="name(../../../../../../../../parent::node())='structuredBody'">
							<xsl:value-of select="1 + count(../../../../../../../../preceding-sibling::v3:component[v3:section/v3:code[@codeSystem=$validCode]]) - count($root/v3:document/v3:component/v3:structuredBody/v3:component[v3:section/v3:code[@code=20]]/preceding-sibling::*) - count(../../../../../../../../preceding-sibling::v3:component[v3:section/v3:code[@code='30' or @code='40' or @code='480']])"/>
						</xsl:when>
						<xsl:when test="name(../../../../../../../../parent::node())='section'">
							<xsl:value-of select="1 + count(../../../../../../../../preceding-sibling::v3:component[v3:section/v3:code[@codeSystem=$validCode]]) + count(../../../../../../../../../../preceding-sibling::v3:component[v3:section/v3:code[@code='20' or @code='30' or @code='40']]/v3:section/child::v3:component[v3:section/v3:code[@codeSystem=$validCode]])"/>
						</xsl:when>
					</xsl:choose>
					<xsl:value-of select="concat('.',count(../../../../../../preceding-sibling::v3:component[v3:section/v3:code[@codeSystem=$validCode]]) + 1)"/>
					<xsl:value-of select="concat('.',count(../../../../preceding-sibling::v3:component[v3:section/v3:code[@codeSystem=$validCode]]) + 1)"/>
					<xsl:value-of select="concat('.',count(../../preceding-sibling::v3:component[v3:section/v3:code[@codeSystem=$validCode]]) + 1)"/>
				</xsl:if>
				<xsl:value-of select="' '"/>
			</xsl:if>

			<xsl:apply-templates select="@*"/>

<!--			<xsl:call-template name="additionalStyleAttr"/>-->
			<xsl:apply-templates mode="mixed" select="node()"/>
		</fo:block>
	</xsl:template>
	<xsl:template match="comment()"/>
	<xsl:template mode="mixed" match="@*|node()">
		<xsl:apply-templates mode="mixed" select="@*|node()"/>
	</xsl:template>
	<xsl:template mode="mixed" match="text()" priority="0">
		<xsl:copy/>
	</xsl:template>
	<xsl:template mode="mixed" match="v3:content">
		<fo:inline>
			<xsl:call-template name="styleCodeAttr">
				<xsl:with-param name="styleCode" select="@styleCode"/>
				<xsl:with-param name="additionalStyleCodeSequence" select="@emphasis|@revised"/>
			</xsl:call-template>
<!--			<xsl:call-template name="additionalStyleAttr"/>-->
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
		</fo:inline>
	</xsl:template>
	<xsl:template mode="mixed" match="v3:sub">
		<fo:inline baseline-shift="sub" font-size="6pt">
			<xsl:apply-templates mode="mixed" select="@*|node()"/>
		</fo:inline>
	</xsl:template>
	<xsl:template mode="mixed" match="v3:sup">
		<fo:inline vertical-align="super" font-size="4pt">
			<xsl:apply-templates mode="mixed" select="@*|node()"/>
		</fo:inline>
	</xsl:template>
	<xsl:template mode="mixed" match="v3:br">
		<fo:block><fo:leader/></fo:block>
	</xsl:template>
	<xsl:template mode="mixed" priority="1" match="v3:renderMultiMedia[@referencedObject and (ancestor::v3:paragraph or ancestor::v3:td or ancestor::v3:th)]">
		<xsl:variable name="reference" select="@referencedObject"/>
		<!-- see note anchoring and PCR 793 -->
		<xsl:if test="@ID">
			<a name="{@ID}"/>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="boolean(//v3:observationMedia[@ID=$reference]//v3:text)">
<!--				<img alt="{//v3:observationMedia[@ID=$reference]//v3:text}" src="{//v3:observationMedia[@ID=$reference]//v3:reference/@value}">
					<xsl:apply-templates select="@*"/>
				</img>
				<fo:external-graphic src="//v3:observationMedia[@ID=$reference]//v3:reference/@value"  content-height="scale-to-fit" height="2.00in"  content-width="2.00in" scaling="20%"/>
-->
			</xsl:when>
			<xsl:when test="not(boolean(//v3:observationMedia[@ID=$reference]//v3:text))">
<!--				<img alt="Image from Drug Label Content" src="{//v3:observationMedia[@ID=$reference]//v3:reference/@value}">
					<xsl:apply-templates select="@*"/>
				</img>-->
			</xsl:when>
			<xsl:when test="v3:td/@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="v3:td/@colspan"/>
				</xsl:attribute>
			</xsl:when>
		</xsl:choose>
		<xsl:apply-templates mode="notCentered" select="v3:caption"/>
	</xsl:template>
	<xsl:template name="drawHr">
		<fo:leader leader-pattern="rule" leader-length="100%" rule-style="solid" rule-thickness="1pt"/>             
	</xsl:template>
	<xsl:template mode="mixed" match="v3:renderMultiMedia[@referencedObject]">
		<xsl:variable name="reference" select="@referencedObject"/>
		<fo:block>
<!--			<xsl:call-template name="styleCodeAttr">
				<xsl:with-param name="styleCode" select="@styleCode"/>
				<xsl:with-param name="additionalStyleCode" select="'Figure'"/>
			</xsl:call-template>-->
			<xsl:apply-templates select="@*[not(local-name(.)='styleCode')]"/>

			<!-- see note anchoring and PCR 793 -->
			<xsl:if test="@ID">
				<a name="{@ID}"/>
			</xsl:if>

			<xsl:choose>
				<xsl:when test="boolean(//v3:observationMedia[@ID=$reference]//v3:text)">
<!--					<img alt="{//v3:observationMedia[@ID=$reference]//v3:text}" src="{//v3:observationMedia[@ID=$reference]//v3:reference/@value}">
						<xsl:apply-templates select="@*"/>
					</img>-->
				</xsl:when>
				<xsl:when test="not(boolean(//v3:observationMedia[@ID=$reference]//v3:text))">
<!--					<img alt="Image from Drug Label Content" src="{//v3:observationMedia[@ID=$reference]//v3:reference/@value}">
						<xsl:apply-templates select="@*"/>
					</img>-->
				</xsl:when>
			</xsl:choose>
			<xsl:apply-templates select="v3:caption"/>
		</fo:block>
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
	<xsl:template match="v3:paragraph">
		<fo:block><fo:leader/></fo:block>
		<fo:block font-size="0.9em">
			<xsl:apply-templates select="@*[not(local-name(.)='styleCode')]"/>
			<xsl:apply-templates select="v3:caption"/>
			<xsl:apply-templates mode="mixed" select="node()[not(self::v3:caption)]"/>
		</fo:block>
	</xsl:template>
	<xsl:template mode="data" match="*">
		<xsl:apply-templates mode="data" select="node()"/>
	</xsl:template>
	<xsl:template mode="data" match="text()">
		<xsl:copy/>
	</xsl:template>
	<xsl:template mode="data" match="*[@displayName and not(@code)]">
		<xsl:value-of select="@displayName"/>
	</xsl:template>
	<xsl:template mode="data" match="*[not(@displayName) and @code]">
		<xsl:value-of select="@code"/>
	</xsl:template>
	<xsl:template mode="data" match="*[@displayName and @code]">
		<xsl:value-of select="@displayName"/>
		<xsl:text> (</xsl:text>
		<xsl:value-of select="@code"/>
		<xsl:text>)</xsl:text>
	</xsl:template>
	<xsl:template mode="data" match="*[@value and @unit]" priority="1">
		<xsl:value-of select="@value"/>&#xA0;<xsl:value-of select="@unit"/>
	</xsl:template>
	<xsl:template mode="data" match="*[@value and not(@displayName)]">
		<xsl:value-of select="@value"/>
	</xsl:template>
	<xsl:template mode="data" match="*[@value and @displayName]">
		<xsl:value-of select="@value"/>
		<xsl:text>&#xA0;</xsl:text>
		<xsl:value-of select="@displayName"/>
	</xsl:template>
	<xsl:template mode="data" match="v3:section"/>
	<xsl:template mode="data" match="*[v3:numerator]">
		<xsl:apply-templates mode="data" select="v3:numerator"/>
		<xsl:if test="v3:denominator[not(@value='1' and (not(@unit) or @unit='1'))]">
			<xsl:text> : </xsl:text>
			<xsl:apply-templates mode="data" select="v3:denominator"/>
		</xsl:if>
	</xsl:template>
	<xsl:template mode="data" match="*[@value and (@xsi:type='TS' or contains(local-name(),'Time'))]" priority="1">
		<xsl:param name="displayMonth">true</xsl:param>
		<xsl:param name="displayDay">true</xsl:param>
		<xsl:param name="displayYear">true</xsl:param>
		<xsl:param name="delimiter">/</xsl:param>
		<xsl:variable name="year" select="substring(@value,1,4)"/>
		<xsl:variable name="month" select="substring(@value,5,2)"/>
		<xsl:variable name="day" select="substring(@value,7,2)"/>
		<!-- Changes made to display date in MM/DD/YYYY format instead of DD/MM/YYYY format -->
		<xsl:if test="$displayMonth = 'true'">
			<xsl:choose>
				<xsl:when test="starts-with($month,'0')">
					<xsl:value-of select="substring-after($month,'0')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$month"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$delimiter"/>
		</xsl:if>
		<xsl:if test="$displayDay = 'true'">
			<xsl:value-of select="$day"/>
			<xsl:value-of select="$delimiter"/>
		</xsl:if>
		<xsl:if test="$displayYear = 'true'">
			<xsl:value-of select="$year"/>
		</xsl:if>
	</xsl:template>

	<!-- TABLE MODEL -->
	<xsl:template match="v3:table">
		<xsl:variable name="maxColCount">
			<xsl:value-of select="sum(v3:tbody/v3:tr[1]/v3:td/@colspan/number(.))"/>
		</xsl:variable>
		<fo:table width="100%"  border-style="outset" border-width="0.1mm" background-repeat="repeat">
			<xsl:call-template name="tableColumns">
				<xsl:with-param name="columns" select="$maxColCount"/>
				<xsl:with-param name="width" select="concat( 7.5 div $maxColCount, 'in')"/>
			</xsl:call-template>
			<xsl:apply-templates select="@*|node()"/>
		</fo:table>
	</xsl:template>
	<xsl:template name="tableColumns">
		<xsl:param name="column" select="1"/>
		<xsl:param name="columns" select="/.."/>
		<xsl:param name="width" select="/.."/>
		<fo:table-column>
			<xsl:attribute name="width"><xsl:value-of select="$width"/></xsl:attribute>
		</fo:table-column>
		<xsl:if test="$columns &gt; $column">
			<xsl:call-template name="tableColumns">
				<xsl:with-param name="column" select="$column + 1" />
				<xsl:with-param name="columns" select="$columns" />
				<xsl:with-param name="width" select="$width"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="v3:table/@summary|v3:table/@width|v3:table/@border|v3:table/@frame|v3:table/@rules|v3:table/@cellspacing|v3:table/@cellpadding">
<!--		<xsl:copy-of select="."/>-->
	</xsl:template>
	<xsl:template match="v3:thead">
		<fo:table-header>
			<xsl:apply-templates select="@*|node()"/>
		</fo:table-header>
	</xsl:template>
	<xsl:template match="v3:thead/@align|v3:thead/@char|v3:thead/@charoff|v3:thead/@valign">
		<fo:block><xsl:copy-of select="."/></fo:block>
	</xsl:template>
	<xsl:template match="v3:tbody">
		<xsl:if test="not(preceding-sibling::v3:tfoot) and not(preceding-sibling::v3:tbody)">
			<xsl:call-template name="flushtablefootnotes"/>
		</xsl:if>
		<fo:table-body>
			<xsl:apply-templates select="@*|node()"/>
		</fo:table-body>
	</xsl:template>
	<xsl:template match="v3:tbody[not(preceding-sibling::v3:thead)]">
		<xsl:if test="not(preceding-sibling::v3:tfoot) and not(preceding-sibling::tbody)">
			<xsl:call-template name="flushtablefootnotes"/>
		</xsl:if>
		<fo:table-body>
			<xsl:call-template name="styleCodeAttr">
				<xsl:with-param name="styleCode" select="@styleCode"/>
				<xsl:with-param name="additionalStyleCode" select="'Headless'"/>
			</xsl:call-template>
			<xsl:call-template name="additionalStyleAttr"/>
			<xsl:apply-templates select="@*[not(local-name(.)='styleCode')]"/>
			<xsl:apply-templates select="node()"/>
		</fo:table-body>
	</xsl:template>
	<xsl:template match="v3:tbody/@align|v3:tbody/@char|v3:tbody/@charoff|v3:tbody/@valign">
		<fo:block><xsl:copy-of select="."/></fo:block>
	</xsl:template>
	<xsl:template match="v3:tr">
		<fo:table-row >
			<xsl:call-template name="styleCodeAttr">
				<xsl:with-param name="styleCode" select="@styleCode"/>
				<xsl:with-param name="additionalStyleCode">
					<xsl:choose>
						<xsl:when test="contains(ancestor::v3:table/@styleCode, 'Noautorules') and not(@styleCode)"> <!-- or contains(ancestor::v3:section/v3:code/@code, '43683-2') -->
							<fo:block></fo:block>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="position()=1">
								<fo:block><xsl:text>First </xsl:text></fo:block>
							</xsl:if>
							<xsl:if test="position()=last()">
								<fo:block><xsl:text>Last </xsl:text></fo:block>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="additionalStyleAttr"/>
			<xsl:apply-templates select="@*[not(local-name(.)='styleCode')]"/>
			<xsl:apply-templates select="node()"/>
		</fo:table-row>
	</xsl:template>
	<xsl:template match="v3:td/@align|v3:td/@char|v3:td/@charoff|v3:td/@valign|v3:td/@abbr|v3:td/@axis|v3:td/@headers|v3:td/@scope">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="v3:td">
		<fo:table-cell xsl:use-attribute-sets="myBorder">
			<xsl:if test="@colspan/number(.) > 1">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan/number(.) > 1">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@valign">
				<xsl:attribute name="vertical-align">
					<xsl:value-of select="@valign"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="mixed" select="node()"/>
		</fo:table-cell>
	</xsl:template>
	<xsl:template match="v3:tfoot" name="flushtablefootnotes">
		<xsl:variable name="allspan" select="count(ancestor::v3:table[1]/v3:colgroup/v3:col|ancestor::v3:table[1]/v3:col)"/>
		<xsl:if test="self::v3:tfoot or ancestor::v3:table[1]//v3:footnote">
			<fo:table-footer>
				<xsl:if test="self::v3:tfoot">
					<xsl:apply-templates select="@*|node()"/>
				</xsl:if>
				<xsl:if test="ancestor::v3:table[1]//v3:footnote">
					<fo:table-row>
						<fo:table-cell colspan="{$allspan}" align="left">
							<fo:block class="Footnote">
								<xsl:apply-templates mode="footnote" select="ancestor::v3:table[1]/node()"/>
							</fo:block>l>
						</fo:table-cell>
					</fo:table-row>
				</xsl:if>
			</fo:table-footer>
		</xsl:if>
	</xsl:template>
	<xsl:template match="v3:tfoot/@align|v3:tfoot/@char|v3:tfoot/@charoff|v3:tfoot/@valign">
		<xsl:copy-of select="."/>
	</xsl:template>
	<!-- comment added by Brian Suggs on 11-11-05: The flushfootnotes template is called at the end of every section -->
	<xsl:template match="v3:flushfootnotes" name="flushfootnotes">
		<xsl:variable name="footnotes" select=".//v3:footnote[not(ancestor::v3:table)]"/>
		<xsl:if test="$footnotes">
			<xsl:call-template name="drawHr"/>
			<fo:block font-weight="bold">
				<xsl:call-template name="hpfb-title">
					<xsl:with-param name="code" select="'10102'"/> <!-- Foot Notes -->
				</xsl:call-template>:
			</fo:block>
			<fo:list-block>
				<xsl:for-each select="$footnotes">
					<fo:list-item xsl:use-attribute-sets="list.item">
					<fo:list-item-label end-indent="label-end()">
						<fo:block text-align="end">
							<xsl:number format="1."/>
						</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()" text-align="justify">
						<fo:block>
							<xsl:value-of select="./text()"/>
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
				</xsl:for-each>
			</fo:list-block>
		</xsl:if>
	</xsl:template>
	<xsl:template name="additionalStyleAttr">
<!--		<xsl:if test="self::*[self::v3:paragraph]//v3:content[@styleCode[contains(.,'xmChange')]] or v3:content[@styleCode[contains(.,'xmChange')]] and not(ancestor::v3:table)">
			<xsl:attribute name="style">
				<xsl:choose>
					<xsl:when test="ancestor::v3:section[v3:code[@code = '34066-1']]">margin-left:-2em; padding-left:2em; border-left:1px solid; position:relative; zoom: 1;</xsl:when>
					<xsl:when test="self::*//v3:content/@styleCode[contains(.,'xmChange')] or v3:content/@styleCode[contains(.,'xmChange')]">border-left:1px solid;</xsl:when>
					<xsl:otherwise>margin-left:-1em; padding-left:1em; border-left:1px solid;</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:if>-->
	</xsl:template>
	<xsl:template match="@styleCode" name="styleCodeAttr">
		<xsl:param name="styleCode" select="."/>
		<xsl:param name="additionalStyleCode" select="/.."/>
		<xsl:param name="allCodes" select="normalize-space(concat($additionalStyleCode,' ',$styleCode))"/>
		<xsl:param name="additionalStyleCodeSequence" select="/.."/>
			<xsl:if test="@styleCode = 'bold'">
				<xsl:attribute name="font-weight"><xsl:value-of select="@styleCode"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@styleCode = 'underline'">
				<xsl:attribute name="text-decoration"><xsl:value-of select="@styleCode"/></xsl:attribute>
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
	<xsl:template name="string-ISO-date">
		<xsl:param name="text"/>
		<xsl:variable name="year" select="substring($text,1,4)"/>
		<xsl:variable name="month" select="substring($text,5,2)"/>
		<xsl:variable name="day" select="substring($text,7,2)"/>
		<xsl:value-of select="concat($year, '-', $month, '-', $day)"/>
	</xsl:template>
	<xsl:template name="string-lowercase">
		<!--** Convert the input text that is passed in as a parameter to lower case  -->
		<xsl:param name="text"/>
		<xsl:value-of select="translate($text,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
	</xsl:template>
	<xsl:template name="string-uppercase">
		<xsl:param name="text"/>
		<xsl:value-of select="translate($text,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
	</xsl:template>
	<xsl:template name="newLine">
		<fo:block><fo:leader/></fo:block>
	</xsl:template>
	<xsl:template name="hpfb-label">
		<xsl:param name="codeSystem" select="/.."/>
		<xsl:param name="code" select="/.."/>
		<xsl:variable name="tempDoc" select="document(concat($oids-base-url,$codeSystem,$file-suffix))"/>
		<xsl:variable name="node" select="$tempDoc/gc:CodeList/SimpleCodeList/Row/Value[@ColumnRef='code' and SimpleValue=$code]"/>
		<xsl:variable name="value" select="$node/../Value[@ColumnRef=$display_language]/SimpleValue"/>
		<xsl:if test="$value">
			<xsl:value-of select="$value"/>
		</xsl:if>
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
</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="no" name="Scenario1" userelativepaths="yes" externalpreview="no" url="1.xml" htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="yes" profilemode="0" profiledepth="" profilelength="" urlprofilexml="" commandline=""
		          additionalpath="" additionalclasspath="" postprocessortype="renderx" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator="">
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
		<scenario default="yes" name="PDF" userelativepaths="no" externalpreview="no" url="file:///e:/4.xml" htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="yes" profilemode="0" profiledepth="" profilelength="" urlprofilexml=""
		          commandline="" additionalpath="" additionalclasspath="" postprocessortype="fop" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator="">
			<parameterValue name="oids-base-url" value="'https://raw.githubusercontent.com/HealthCanada/HPFB/master/Controlled-Vocabularies/Content/'"/>
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
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no">
			<SourceSchema srcSchemaPath="2.xml" srcSchemaRoot="document" AssociatedInstance="" loaderFunction="document" loaderFunctionUsesURI="no"/>
			<SourceSchema srcSchemaPath="..\..\Users\hcuser\HC\HPFB\Controlled-Vocabularies\Content\2.16.840.1.113883.2.20.6.10.xml" srcSchemaRoot="gc:CodeList"
			              AssociatedInstance="file:///c:/Users/hcuser/HC/HPFB/Controlled-Vocabularies/Content/2.16.840.1.113883.2.20.6.10.xml" loaderFunction="document" loaderFunctionUsesURI="no"/>
			<SourceSchema srcSchemaPath="..\..\Users\hcuser\HC\HPFB\Controlled-Vocabularies\Content\2.16.840.1.113883.2.20.6.10.xml" srcSchemaRoot="gc:CodeList" AssociatedInstance="$input1" loaderFunction="document" loaderFunctionUsesURI="no"/>
		</MapperInfo>
		<MapperBlockPosition>
			<template match="/"></template>
		</MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
-->