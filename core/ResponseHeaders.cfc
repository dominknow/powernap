<cfcomponent output="false">
	
	<cfset variables.contentType = "application/xml" />
	<cfset variables.statusCode = 200 />
	<cfset variables.customHeaders = arrayNew(1) />
	
	<cffunction name="init" access="public" returntype="powernap.core.ResponseHeaders">
		<cfreturn this />
	</cffunction>

	<cffunction name="addCustom" access="public" returntype="void">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="value" type="string" required="true" />

		<cfset arrayAppend(variables.customHeaders, arguments) />
	</cffunction>

	<cffunction name="getCustom" access="public" returntype="array">
		<cfreturn variables.customHeaders />
	</cffunction>
	
	<cffunction name="setContentType" access="public" returntype="void">
		<cfargument name="contentType" type="string" required="true" />
		<cfset variables.contentType = arguments.contentType />
	</cffunction>
	
	<cffunction name="getContentType" access="public" returntype="string">
		<cfreturn variables.contentType />
	</cffunction>
	
	<cffunction name="setStatusCode" access="public" returntype="void">
		<cfargument name="statusCode" type="numeric" required="true" />
		<cfset variables.statusCode = arguments.statusCode />
	</cffunction>
	
	<cffunction name="getStatusCode" access="public" returntype="string">
		<cfreturn variables.statusCode />
	</cffunction>

</cfcomponent>
