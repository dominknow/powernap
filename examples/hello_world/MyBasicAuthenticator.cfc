<cfcomponent implements="powernap.interfaces.HTTPBasicAuthenticator">
	
	<cffunction name="init" access="public" returntype="powernap.interfaces.HTTPBasicAuthenticator">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isAuthenticated" access="public" returntype="boolean">
		<cfargument name="username" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />
		
		<cfif arguments.username is "username" and arguments.password is "password">
			<cfreturn true />
		</cfif>
		
		<cfreturn false />
	</cffunction>

</cfcomponent>