<cfcomponent output="false">
	
	<cffunction 
			access="public" 
			returntype="any" 
			name="authenticate" 
			output="false" 
			hint="Authenticates and returns the authenticated user/account/etc.">
		<cfargument name="authString" type="string" required="true" hint="The contents of the Authenticate header" />

		<cfthrow message="Not implemented" />

	</cffunction>

	<cffunction
			access="public"
			returntype="string"
			name="getWWWAuthHeader"
			output="false"
			hint="When authentication fails, this is the content in the WWW-Authenticate response">

		<cfreturn "Basic realm='Invalid Authentication for Resource'">
	</cffunction>

	<cffunction 
			access="private" 
			returntype="void" 
			name="authFailed"
			output="false"
			hint="Generates appropriate HTTP response for failed authentication">

			<cfheader statuscode="401" />
			<cfheader name="WWW-Authenticate" value="#getWWWAuthHeader#" />
			<cfabort />
	</cffunction>

</cfcomponent>
