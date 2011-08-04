<cfcomponent output="false">
	
	<cfset variables.applicationReference = false />
	<cfset variables.extension = false />
	<cfset variables.contentType = false />
	<cfset variables.representationMethod = false />
	
	<cffunction name="init" access="public" returntype="powernap.core.Format">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setApplicationReference" access="public" returntype="void">
		<cfargument name="applicationReference" type="powernap.core.Engine" required="true" />
		<cfset variables.applicationReference = arguments.applicationReference />
	</cffunction>
	
	<cffunction name="withExtension" access="public" returntype="powernap.core.Format">
		<cfargument name="extension" type="string" required="true" />
		<cfset var registry = variables.applicationReference.getFormatRegistry() />
		<cfset variables.extension = arguments.extension />
		<cfset registry[arguments.extension] = this />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="willRespondWith" access="public" returntype="powernap.core.Format">
		<cfargument name="contentType" type="string" required="true" />
		<cfset variables.contentType = arguments.contentType />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="calls" access="public" returntype="powernap.core.Format">
		<cfargument name="representationMethod" type="string" required="true" />
		<cfset variables.representationMethod = arguments.representationMethod />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="shouldFire" access="public" returntype="string">
		<cfreturn variables.representationMethod />
	</cffunction>
	
	<cffunction name="respondsWith" access="public" returntype="string">
		<cfreturn variables.contentType />
	</cffunction>
	
	<cffunction name="getExtension" access="public" returntype="string">
		<cfreturn variables.extension />
	</cffunction>

</cfcomponent>