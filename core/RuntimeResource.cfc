<cfcomponent output="false">
	
	<cfset variables.paramStruct = structNew() />
	<cfset variables.resourceReference = false />
	<cfset variables.targetMethod = false />

	<cffunction name="init" access="public" returntype="powernap.core.RuntimeResource">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setParamStruct" access="public" returntype="void">
		<cfargument name="paramStruct" type="struct" required="true" />
		<cfset variables.paramStruct = arguments.paramStruct />
	</cffunction>
	
	<cffunction name="getParamStruct" access="public" returntype="struct">
		<cfreturn variables.paramStruct />
	</cffunction>
	
	<cffunction name="setResourceReference" access="public" returntype="void">
		<cfargument name="resource" type="powernap.core.ResourceConfiguration" required="true" />
		<cfset variables.resourceReference = arguments.resource />
	</cffunction>
	
	<cffunction name="getResourceReference" access="public" returntype="powernap.core.ResourceConfiguration">
		<cfreturn variables.resourceReference />
	</cffunction>
	
	<cffunction name="setTargetMethod" access="public" returntype="void">
		<cfargument name="targetMethod" type="string" required="true" />
		<cfset variables.targetMethod = arguments.targetMethod />
	</cffunction>
	
	<cffunction name="getTargetMethod" access="public" returntype="string">
		<cfreturn variables.targetMethod />
	</cffunction>
	
	<cffunction name="hasResourceReference" access="public" returntype="boolean">
		<cfif isObject(variables.resourceReference)>
			<cfreturn true />
		</cfif>
		<cfreturn false />
	</cffunction>
	
	<cffunction name="getRequestedFormat" access="public" returntype="string">
		<cfreturn variables.paramStruct["_FORMAT"] />
	</cffunction>

</cfcomponent>