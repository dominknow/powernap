<cfcomponent extends="powernap.core.Representation">
	
	<cffunction name="init" access="public" returntype="powernap.examples.hello_world.ProtectedWorldRepresentation">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAsHTML" access="public" returntype="string">
		
		<!--- //
			This representation 'knows' about our World object because
			we gave it a reference in the WorldResource component via
			the 'represents()' method.  To pull that reference out,
			call the 'getObject()' method.
		// --->
		<cfset var world = getObject() />
		<cfset var worldAsHTML = "" />
		
		<!--- //
			Not the most elegant solution to directly include text inline and save the content - 
			but this is just a simple example, so you get the idea.
		// --->
		<cfsavecontent variable="worldAsHTML">
			<cfoutput>
			<h1>#world.getWordsToSpeak()#</h1>
			<p>Through the magic of Basic HTTP Authentication, you should only be seeing this resource
			if you provided a valid username and password.</p>
			<p>The actual implementation of the security was done in the "MyBasicAuthenticator.cfc" Component.
			Go ahead and check it out for all of the juicy details.</p>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn worldAsHTML />
	</cffunction>

</cfcomponent>