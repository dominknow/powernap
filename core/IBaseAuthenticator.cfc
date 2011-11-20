<cfinterface>
	<cffunction 
			access="public" 
			returntype="any" 
			name="authenticate" 
			output="false" 
			hint="Authenticates and returns the authenticated user/account/etc.">
		<cfargument name="authString" type="string" required="true" hint="The contents of the Authenticate header" />
		<cfargument name="request" type="any" required="true" hint="The request page context object" />
	</cffunction>

	<cffunction
			access="public"
			returntype="string"
			name="getWWWAuthHeader"
			output="false"
			hint="When authentication fails, this is the content in the WWW-Authenticate response">
	</cffunction>
</cfinterface>
