<cfcomponent>
	
	<cffunction name="init" access="public" returntype="powernap.core.ComponentDispatcher">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="run" access="public" returntype="any">
		<cfargument name="targetComponent" type="any" required="true" />
		<cfargument name="targetMethod" type="string" required="true" />
		<cfargument name="argStruct" type="struct" required="true" />

		<cfset var results = "" />
		
		<cfinvoke component="#arguments.targetComponent#"
			method="#arguments.targetMethod#"
			argumentcollection="#arguments.argStruct#"
			returnVariable="results" />
			
		<!--- // need this for executions that do not return any results // --->
		<cfparam name="results" default="" />
		
		<cfreturn results />
	</cffunction>

</cfcomponent>