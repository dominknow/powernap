<cfcomponent output="false">
	
	<cfset variables.contentType = "application/xml" />
	<cfset variables.statusCode = 200 />
	
	<cffunction name="init" access="public" returntype="powernap.core.ResponseHeaders">
		<cfreturn this />
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