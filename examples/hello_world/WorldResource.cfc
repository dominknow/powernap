<cfcomponent extends="powernap.core.Resource">
	
	<cffunction name="saySomething" access="public" returntype="powernap.core.Representation">
		<cfargument name="textToSpeak" type="string" required="true" />
	
		<cfset var world = createObject("component", "powernap.examples.hello_world.World").init() />
	
		<!--- //
			The 'WorldRepresentation' is a component that understands how to represent
			the 'World' to the requeting client, based off of the requested format.
		// --->
		<cfset var worldRepresentation = createObject("component", "powernap.examples.hello_world.WorldRepresentation").init() />
		
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
	
	<cffunction name="getWorldByID" access="public" returntype="powernap.core.Representation">
		<cfargument name="id" type="numeric" required="true" />
	
		<!--- //
			This would be a good spot to search for and return
			a world representation based off of the ID that
			was passed in.  But, we're not going to right now
			because this is a simple demonstration - see the other
			methods for more fun stuff.
			
			For now, we're just going to return an HTTP status
			of 200.
		// --->

		<cfreturn simpleRepresentation().withContent("").withStatus(200) />
	</cffunction>

	<cffunction name="createANewWorld" access="public" returntype="powernap.core.Representation">
	
		<!--- //
			This method, as configured in our HelloWorldAPI, will respond only to the correct
			URI AND a 'POST' HTTP method.
			
			So go ahead and create the world here.
		// --->
		
		<!--- //
			Because this was a create operation, we may only want to respond with
			a success ('200') as well as the ID of the newly created resource.
			We don't want a big complicated representation to generate the content
			for us - we can return a simpleRepresentation as follows;
		// --->
		<cfreturn simpleRepresentation().withContent("New ID Here").withStatus(200) />
	</cffunction>
	
	<cffunction name="itsTheEndOfTheWorldAsWeKnowIt" access="public" returntype="powernap.core.Representation">
		<cfargument name="id" type="numeric" required="true" />
		
		<!--- //
			You can't simply destory our world with impunity!
		// --->
		<cfthrow message="Whoa! I'm not sure if destroying our little world (with id: #arguments.id#) is such a good idea!" />
	
	</cffunction>
	
	<cffunction name="simpleContentTest" access="public" returntype="powernap.core.Representation">
		
		<!--- //
			This would be a good spot for some type of Update operation.
		// --->
		
		<cfreturn simpleRepresentation().withContent("Hello").withStatus(200) />
	</cffunction>

</cfcomponent>