<cfcomponent extends="powernap.core.Engine">

	<cffunction name="init" access="public" returntype="powernap.core.Engine">
		
		<!--- //
			The 'defaultFormat()' method call is not required in the application init method
			as you see below.  However, if an extension (*.something) is ommitted from the
			URI, then PowerNap will attempt to return your representation in .xml format.
			If you want your application to respond with something other than XML when
			the extension is missing, then configure it with the 'defaultFormat()' method call.
		// --->
		<cfset defaultFormat(".html") />
		
		<!--- //
			This is a simple example of a custom user-defined format.  In the example below,
			if the URI is appended with the .say extension, then the HTTP response 'content-type'
			will be whatever is set in the 'willRespondWith()' method AND call the 'getAsCustomFormat'
			method on the associated Representation component that is responsible for rendering your
			Resource.
			
			Defining formats in your application is not required.  PowerNap natively supports the following
			formats that you DO NOT need to configure on your own;
			
			.xml, .html, .htm, .json, .pdf
		// --->
		<cfset format().withExtension(".say").willRespondWith("text/plain").calls("getAsCustomFormat") />
		
		<!--- //
			PowerNap can protect access to resources via HTTP Authentication.  In the declaration you see below,
			we are creating an instance of an authenticator that implements Basic HTTP Authentication.  Once you
			have declared the new authenticator - you can "attach" it to any resource you declar via the 
			'protectedBy' method.
		// --->
		<cfset newBasicAuthenticator("myAuthenticator").isA("powernap.examples.hello_world.MyBasicAuthenticator") />
		
		<!--- //
			In our simple example here - we're only configuring one Resource - a World.
		// --->		
		<cfset newResource("world").isA("powernap.examples.hello_world.WorldResource") />
		
		<!--- //
			This is an example of having a configured ColdSpring bean factory return
			an instance of a resource.  See the coldspring-config.xml file for the
			reference to 'coldspringDrivenResource'.  A coldspring configuration file
			was referenced in api.cfm (the endpoints configuration) which means that
			an instance of a ColdSpring BeanFactory was created to manage any beans
			defined in the file.  You can now reference those "Beans" in the "isA()"
			method.
		// --->
		<cfset newResource("coldWorld").isA("coldspringDrivenResource") />
		
		<!--- //
			We're going to declare a new resource separate from the previous two,
			that will be protected by the 'myAuthenticator' object that we 
			declared on line 34.
		// --->
		<cfset newResource("protectedWorld").isA("powernap.examples.hello_world.ProtectedWorldResource").protectedBy("myAuthenticator") />
		
		<!--- //
			Now we're going create a few URI and method mappings to our configured World resource.
		// --->
		<cfset map().get().uri("/say/something/now/{textToSpeak}").to("world").calls("saySomething") />
		<cfset map().get().uri("/{textToSpeak}/world/").to("world").calls("saySomething") />
		<cfset map().get().uri("/world/{id}").to("world").calls("getWorldByID") />
		<cfset map().post().uri("/world").to("world").calls("createANewWorld") />
		<cfset map().delete().uri("/world/{id}").to("world").calls("itsTheEndOfTheWorldAsWeKnowIt") />
		<cfset map().put().uri("/world/{id}").to("world").calls("needToUpdateSomething") />
		<cfset map().get().uri("/small/simple/world/").to("world").calls("simpleContentTest") />
		
		<!--- //
			Let's ask the coldspring resource to say the same thing as it's other 'world'
			counterpart.
		// --->
		<cfset map().get().uri("/{textToSpeak}/cold/world").to("coldWorld").calls("saySomething") />
		
		<!--- //
			Let's create a map to the protectedWorld resource that we declared earlier;
		// --->
		<cfset map().get().uri("/hello/protected/world").to("protectedWorld").calls("welcome") />
		
		<cfreturn this />
	</cffunction>

</cfcomponent>