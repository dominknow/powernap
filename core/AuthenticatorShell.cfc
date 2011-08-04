<cfcomponent output="false">
	
	<cfset variables.name = false />
	<cfset variables.engineReference = false />
	
	<cffunction name="init" access="public" returntype="powernap.core.AuthenticatorShell">
		<cfargument name="engineRef" type="powernap.core.Engine" required="true" />
		<cfset variables.engineReference = arguments.engineRef />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isA" access="public" returntype="powernap.core.AuthenticatorShell">
		<cfargument name="componentPath" type="string" required="true" />

		<cfset var registry = variables.engineReference.getAuthRegistry() />
		
		<cfset structInsert(registry, variables.name, trim(arguments.componentPath)) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setName" access="public" returntype="void">
		<cfargument name="name" type="string" required="true" />
		<cfset variables.name = arguments.name />
	</cffunction>

</cfcomponent>