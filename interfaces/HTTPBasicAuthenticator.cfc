<cfinterface>

	<cffunction name="init" access="public" returntype="powernap.interfaces.HTTPBasicAuthenticator">
	</cffunction>
	
	<cffunction name="isAuthenticated" access="public" returntype="boolean">
		<cfargument name="username" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />
	</cffunction>

</cfinterface>