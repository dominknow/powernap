<cfcomponent extends="powernap.core.Resource">
	
	<cfset variables.world = "" />
	
	<cffunction name="setWorld" access="public" returntype="void">
		<cfargument name="world" type="powernap.examples.hello_world.World" required="true" />
		<cfset variables.world = arguments.world />
	</cffunction>
	
	<cffunction name="getWorld" access="public" returntype="powernap.examples.hello_world.World">
		<cfreturn variables.world />
	</cffunction>
	
	<cffunction name="saySomething" access="public" returntype="powernap.core.Representation">
		<cfargument name="textToSpeak" type="string" required="true" />
	
		<cfset var world = getWorld() />
	
		<!--- //
			The 'WorldRepresentation' is a component that understands how to represent
			the 'World' to the requeting client, based off of the requested format.
		// --->
		<cfset var worldRepresentation = getRepresentation() />
		
		<!--- //
			Time to populate our world.
		// --->
		<cfset world.setPopulation(5000000000) />
		<cfset world.setWordsToSpeak(arguments.textToSpeak) />
		
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