<cfcomponent output="false">
	
	<cfset variables.name = false />
	<cfset variables.targetComponent = false />
	
	<cffunction name="init" access="public" returntype="powernap.core.ResourceConfiguration">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setName" access="public" returntype="powernap.core.ResourceConfiguration">
		<cfargument name="name" type="string" required="true" />
		<cfset variables.name = arguments.name />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getName" access="public" returntype="string">
		<cfreturn variables.name />
	</cffunction>
	
	<cffunction name="isA" access="public" returntype="powernap.core.ResourceConfiguration">
		<cfargument name="targetComponent" type="string" required="true" />
		<cfset setTargetComponent(arguments.targetComponent) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setTargetComponent" access="public" returntype="void">
		<cfargument name="targetComponent" type="string" required="true" />
		<cfset variables.targetComponent = arguments.targetComponent />
	</cffunction>
	
	<cffunction name="getTargetComponent" access="public" returntype="string">
		<cfreturn variables.targetComponent />
	</cffunction>

</cfcomponent>
