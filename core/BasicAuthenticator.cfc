<cfcomponent output="false" extends="powernap.core.BaseAuthenticator">
	
	<cffunction name="init" access="public" output="false" returntype="any" hint="The public constructor">
		<cfargument name="engineReference" type="any" required="true" hint="The engine that instantiated the authenticator">

		<cfset variables.engineReference = arguments.engineReference>

		<cfreturn this />
	</cffunction>

	<cffunction name="isA" access="public" output="false" returntype="void">
		<cfargument name="target" type="any" hint="The component that performs the actual validation of username/password">
		
		<cfset variables.targetComponent = arguments.target />
		<cfif variables.engineReference.hasBeanFactory() AND variables.engineReference.getBeanFactory().containsBean(variables.targetComponent)>
			<cfset variables.targetComponent = variables.engineReference.getBeanFactory().getBean(variables.targetComponent)>
		</cfif>
	</cffunction>

	<cffunction name="authenticate" access="public" output="false" returntype="any">
		<cfargument name="authString" type="string" required="true">
		
		<!--- peel off the "Basic", we might support others in the future --->
		<cfset var method = listFirst(arguments.authString, " ") />
		<cfset var argStruct = structNew() />
		
		<cfset var varmatch = listLast(arguments.authString, " ") />
		<cfset var credentials = ToString(ToBinary(ListLast(varmatch, " "))) />
		<cfset var user = "" />
		<cfset var pass = "" />
		<cfset var isAuthenticated = false />

		<cfset var argStruct.username = "" />
		<cfset var argStruct.password = "" /> 

		<!--- values can have any character except : --->
		<cfset user = reMatch("([^:]*):", credentials) />
		<cfset Pass = reMatch(":([^:]*)", credentials) />
		
		<cfif arrayLen(user)>
			<cfset argStruct.username = replaceNoCase(user[1], ":", "", "ALL") />
		</cfif>
		<cfif arrayLen(pass)>
			<cfset argStruct.password = replaceNoCase(pass[1], ":", "", "ALL") />
		</cfif>

		<cfset isAuthenticated = variables.engineReference.getComponentDispatcher().run(
				variables.targetComponent,
				"isAuthenticated",
				argStruct) />

		<cfif NOT isAuthenticated>
			<cfset authFailed() />
		</cfif>

		<cfreturn argStruct.username />

	</cffunction>
</cfcomponent>
