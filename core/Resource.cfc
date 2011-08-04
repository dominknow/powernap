<cfcomponent output="false">
	
	<cfset variables.representation = "" />
	
	<cffunction name="setRepresentation" access="public" returntype="void">
		<cfargument name="representation" type="powernap.core.Representation" />
		<cfset variables.representation = arguments.representation />
	</cffunction>
	
	<cffunction name="getRepresentation" access="public" returntype="powernap.core.Representation">
		<cfreturn variables.representation />
	</cffunction>
	
	<cffunction name="simpleRepresentation" access="public" returntype="powernap.core.Representation">
		<cfreturn createObject("component", "powernap.core.SimpleRepresentation").init() />
	</cffunction>

</cfcomponent>