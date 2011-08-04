<cfcomponent extends="powernap.core.Representation">
	
	<cffunction name="init" access="public" returntype="powernap.examples.hello_world.WorldRepresentation">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAsXML" access="public" returntype="xml">
		
		<!--- //
			This representation 'knows' about our World object because
			we gave it a reference in the WorldResource component via
			the 'represents()' method.  To pull that reference out,
			call the 'getObject()' method.
		// --->
		<cfset var world = getObject() />
		<cfset var worldAsXML = "" />
		
		<!--- //
			Not the most elegant solution to directly include text inline and save the content - 
			but this is just a simple example, so you get the idea.
		// --->
		<cfsavecontent variable="worldAsXML">
			<cfoutput>
			<world>
				<population>#world.getPopulation()#</population>
				<im-supposed-to-say>#world.getWordsToSpeak()#</im-supposed-to-say>
			</world>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn worldAsXML />
	</cffunction>

	<cffunction name="getAsPDF" acces="public" returntype="any">
		
		<!--- //
			This representation 'knows' about our World object because
			we gave it a reference in the WorldResource component via
			the 'represents()' method.  To pull that reference out,
			call the 'getObject()' method.
		// --->
		<cfset var world = getObject() />
		<cfset var worldAsPDF = "" />
		
		<!--- //
			Not the most elegant solution to directly include text inline and save the content - 
			but this is just a simple example, so you get the idea.
		// --->
		<cfsavecontent variable="worldAsPDF">
			<cfdocument format="pdf">
				I'm a PDF representation of a World Resource!
				Now bask in my portable glory.
				
				<cfoutput>#world.getWordsToSpeak()#</cfoutput>
			</cfdocument>
		</cfsavecontent>
		
		<cfreturn worldAsPDF />
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
			<p>
				You can make me say anything you like by simply changing
				the URI to /{whateveryouwant}/world.<br /> For instance, if you want me to say
				'goodbye', then change the URI in the browser address bar to <b>/api.cfm/goodbye/world</b>.
			</p>
			<p>
				Did you know that according to the person that wrote me, 
				I have #numberFormat(world.getPopulation(), "___,___,___,___")# inhabitants?
			</p>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn worldAsHTML />
	</cffunction>
	
	<cffunction name="getAsCustomFormat" access="public" returntype="any">
	
		<cfset var world = getObject() />
		<cfset var content = "This is a custom format.  Although, in this example, it's really just a text file." />
		
		<cfreturn content />
	</cffunction>
	
	<cffunction name="getAsJSON" access="public" returntype="string">
	
		<cfset var world = getObject() />
		
		<!--- //
			.JSON functionality made possible by CFJSON: http://www.epiphantastic.com/cfjson/index.php
		// --->
		<cfset var jsonConverter = createObject("component", "powernap.cfjson.1-9.JSON") />
		<cfset var json = jsonConverter.encode(world.getAsStruct()) />
	
		<cfreturn json />	
	</cffunction>
	
	<cffunction name="getAsPlainText" access="public" returntype="string">
		
		<cfset var world = getObject() />
		
		<cfset var text = "Hi, I'm a plain-text representation of a 'World' resource; " & world.getWordsToSpeak() />
	
		<cfreturn text />
	</cffunction>

</cfcomponent>