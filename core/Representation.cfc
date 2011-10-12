<cfcomponent output="false">
	
	<cfset variables.object = false />
	<cfset variables.responseHeaders = createObject("component", "powernap.core.ResponseHeaders").init() />
	<cfset variables.conversionUtils = createObject("component", "powernap.core.ConversionUtils").init() />
	
	<cffunction name="init" access="public" returntype="powernap.core.Representation">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getResponseHeaders" access="public" returntype="powernap.core.ResponseHeaders">
		<cfreturn variables.responseHeaders />
	</cffunction>

	<cffunction name="withHeader" access="public" returntype="powernap.core.Representation">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="value" type="string" required="true" />

		<cfset variables.responseHeaders.addCustom(arguments.name, arguments.value) />

		<cfreturn this />
	</cffunction>

	<cffunction name="withHeaders" access="public" returntype="powernap.core.Representation">
		<cfargument name="headers" type="array" required="true" />

		<!--- 
			We're going to loop through each item in the array and add it one at a time,
			to ensure they're all valid structures
		--->
		<cfset var loopIndex = 1 />

		<cfloop from="1" to="#arrayLen(arguments.headers)#" index="loopIndex">
			<cfset variables.responseHeaders.addCustom(arguments.headers[loopIndex].name, arguments.headers[loopIndex].value) />
		</cfloop>

		<cfreturn this />
	</cffunction>
	
	<cffunction name="represents" access="public" returntype="powernap.core.Representation">
		<cfargument name="object" type="any" required="true" />
		<cfset variables.object = arguments.object />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getObject" access="public" returntype="any">
		<cfreturn variables.object />
	</cffunction>
	
	<cffunction name="withStatus" access="public" returntype="powernap.core.Representation">
		<cfargument name="statusCode" type="numeric" required="true" />
		<cfset getResponseHeaders().setStatusCode(arguments.statusCode) />
		<cfreturn this />
	</cffunction>
	
	<!--- 	Date: 1/18/2009  Usage: Return the conversion utility object for changing data formats --->
	<cffunction name="convert" output="false" access="public" returntype="any" hint="Return the conversion utility object for changing data formats">
		<cfreturn variables.conversionUtils />		
	</cffunction>
	
	<!--- // These getAs* methods are only spelled out as examples - they must be 
			 overridden in your Representations // --->
	<cffunction name="getAsXML" access="public" returntype="xml">		
		<cfheader statuscode="415" statustext="Unsupported Media Type: #getResponseHeaders().getContentType()#" />
		<cfabort />
	</cffunction>
	
	<cffunction name="getAsJSON" access="public" returntype="any">
		<cfheader statuscode="415" statustext="Unsupported Media Type: #getResponseHeaders().getContentType()#" />
		<cfabort />
	</cffunction>
	
	<cffunction name="getAsHTML" access="public" returntype="any">
		<cfheader statuscode="415" statustext="Unsupported Media Type: #getResponseHeaders().getContentType()#" />
		<cfabort />
	</cffunction>
	
	<cffunction name="getAsPDF" access="public" returntype="any">
		<cfheader statuscode="415" statustext="Unsupported Media Type: #getResponseHeaders().getContentType()#" />
		<cfabort />
	</cffunction>
	
	<cffunction name="getAsPlainText" access="public" returntype="any">
		<cfheader statuscode="415" statustext="Unsupported Media Type: #getResponseHeaders().getContentType()#" />
		<cfabort />
	</cffunction>

	<cffunction name="onMissingMethod" access="public" returntype="any">
		<cfheader statuscode="415" statustext="Unsupported Media Type: #getResponseHeaders().getContentType()#" />
		<cfabort />
	</cffunction>

</cfcomponent>
