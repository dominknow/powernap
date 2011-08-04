<cfcomponent extends="powernap.core.Resource">
	
	<cffunction name="welcome" access="public" returntype="powernap.core.Representation">
		<cfargument name="auth_username" type="string" required="false" />
	
		<cfset var world = createObject("component", "powernap.examples.hello_world.World").init() />
	
		<!--- //
			The 'WorldRepresentation' is a component that understands how to represent
			the 'World' to the requeting client, based off of the requested format.
		// --->
		<cfset var worldRepresentation = createObject("component", "powernap.examples.hello_world.ProtectedWorldRepresentation").init() />
		
		<cfset world.setWordsToSpeak(arguments.auth_username) />
		
		<!--- //
			Now, make sure your representation 'knows' about our domain
			model object.
		// --->
		<cfset worldRepresentation.represents(world) />
		
		<!--- //
			The 'withStatus()' method call is completely optional.
		// --->
		<cfreturn worldRepresentation.withStatus(200) />
	</cffunction>

</cfcomponent>