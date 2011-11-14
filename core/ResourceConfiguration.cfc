<cfcomponent output="false" extends="powernap.core.RegistryConfiguration">

	<cfset variables.authenticatorReference = false />
	<cfset variables.requiresAuthentication = false />

	<cffunction name="protectedBy" access="public" returntype="powernap.core.ResourceConfiguration">
		<cfargument name="authenticator" type="string" required="true" />
		<cfset variables.authenticatorReference = arguments.authenticator />
		<cfset variables.requiresAuthentication = true />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getProtectedBy" access="public" returntype="string">
		<cfreturn variables.authenticatorReference />
	</cffunction>
	
	<cffunction name="requiresAuthentication" access="public" returntype="boolean">
		<cfreturn variables.requiresAuthentication />
	</cffunction>

</cfcomponent>
