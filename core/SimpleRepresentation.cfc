<cfcomponent extends="powernap.core.Representation">
	
	<!--- //
		Initialize this to an empty string.
	// --->
	<cfset represents("") />
	
	<cffunction name="init" access="public" returntype="powernap.core.Representation">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAsPlainText" access="public" returntype="any">
		<!--- //
			In the case of the SimpleRepresentation component,
			the 'object' is a simple string established via
			the 'withContent' method.
		// --->
		<cfreturn getObject() />
	</cffunction>
	
	<cffunction name="withContent" access="public" returntype="powernap.core.SimpleRepresentation">
		<cfargument name="content" type="string" required="false" default="" />
		<cfset represents(arguments.content) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAsXML" access="public" returntype="xml">		
		<cfset var returnXML = xmlNew(true) />
		<cfset returnXML.xmlRoot = xmlElemNew(returnXML, "message") />
		<cfset returnXML.xmlRoot.xmlCdata = getObject() />

		<cfreturn returnXML />
	</cffunction>
	
	<cffunction name="getAsJSON" access="public" returntype="any">
		<cfset var returnStruct = StructNew() />
		<cfset returnStruct["message"] = getObject() />

		<cfreturn serializeJSON(returnStruct) />
	</cffunction>
	
	<cffunction name="getAsHTML" access="public" returntype="any">
		<cfset var returnHTML = "" />
		<cfsavecontent variable="returnHTML">
			<cfoutput>
				<!DOCTYPE html>
				<html>
				<head><title>REST Message</title></head>
				<body><p>#getObject()#</p></body>
				</html>
			</cfoutput>
		</cfsavecontent>

		<cfreturn returnHTML />
	</cffunction>
	
	<cffunction name="getAsPDF" access="public" returntype="any">
		<cfreturn getAsPlainText() />
	</cffunction>

</cfcomponent>
