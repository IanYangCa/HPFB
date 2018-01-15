<?xml version="1.0" encoding="utf-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:attribute-set name="myBorder">
	  <xsl:attribute name="border">solid 0.1mm black</xsl:attribute>
	  <xsl:attribute name="padding-left">2mm</xsl:attribute>
	  <xsl:attribute name="padding-right">2mm</xsl:attribute>
	  <xsl:attribute name="padding-top">2mm</xsl:attribute>
	  <xsl:attribute name="padding-bottom">2mm</xsl:attribute>
	  <xsl:attribute name="text-align">left</xsl:attribute>
	  <xsl:attribute name="display-align">center</xsl:attribute>
	  <xsl:attribute name="font-size">0.7em</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="myCellPadding">
	  <xsl:attribute name="padding-left">2mm</xsl:attribute>
	  <xsl:attribute name="padding-right">2mm</xsl:attribute>
	  <xsl:attribute name="padding-top">2mm</xsl:attribute>
	  <xsl:attribute name="padding-bottom">2mm</xsl:attribute>
	  <xsl:attribute name="font-size">0.7em</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="list.item" >
	  <xsl:attribute name="space-before">0.4em</xsl:attribute>
	  <xsl:attribute name="space-after">0.4em</xsl:attribute>
	  <xsl:attribute name="relative-align">baseline</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="formLabel">
	  <xsl:attribute name="border">solid 0.1mm black</xsl:attribute>
		<xsl:attribute name="background-color">#DDDDDD</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-size">0.9em</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="formLabel">
	  <xsl:attribute name="border">solid 0.1mm #FFFFFF</xsl:attribute>
		<xsl:attribute name="background-color">#DDDDDD</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-size">0.9em</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="formItem">
		<xsl:attribute name="border">solid 0.1mm #CCCCCC</xsl:attribute>
		<xsl:attribute name="background-color">#DDDDDD</xsl:attribute>
		<xsl:attribute name="font-size">0.7em</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="formTablePetite">
		<xsl:attribute name="border">solid 0.1mm #FFFFFF</xsl:attribute>
		<xsl:attribute name="border-collapse">collapse</xsl:attribute>
		<xsl:attribute name="font-size">0.8em</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="formHeadingTitle">
		<xsl:attribute name="border">none</xsl:attribute>
		<xsl:attribute name="background-color">#CCCCCC</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-size">1em</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="formTableRow">
		<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="formTableRowAlt">
		<xsl:attribute name="background-color">#F2F2F2</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="contentTableReg">
		<xsl:attribute name="border-bottom">none</xsl:attribute>
		<xsl:attribute name="background-color">#CCCCCC</xsl:attribute>
		<xsl:attribute name="font-weight">lighter</xsl:attribute>
		<xsl:attribute name="font-size">0.8em</xsl:attribute>
	</xsl:attribute-set>
	
</xsl:transform><!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios/>
	<MapperMetaTag>
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
		<MapperBlockPosition></MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
-->