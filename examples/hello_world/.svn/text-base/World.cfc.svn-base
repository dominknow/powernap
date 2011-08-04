<cfcomponent output="false">
	
	<cfset variables.population = 0 />
	<cfset variables.wordsToSpeak = "" />
	
	<cffunction name="init" access="public" returntype="powernap.examples.hello_world.World">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setPopulation" access="public" returntype="void">
		<cfargument name="population" type="numeric" required="true" />
		<cfset variables.population = arguments.population />
	</cffunction>
	
	<cffunction name="getPopulation" access="public" returntype="numeric">
		<cfreturn variables.population />
	</cffunction>
	
	<cffunction name="setWordsToSpeak" access="public" returntype="void">
		<cfargument name="wordsToSpeak" type="string" required="true" />
		<cfset variables.wordsToSpeak = arguments.wordsToSpeak />
	</cffunction>
	
	<cffunction name="getWordsToSpeak" access="public" returntype="string">
		<cfreturn variables.wordsToSpeak />
	</cffunction>
	
	<cffunction name="getAsStruct" access="public" returntype="struct">
		<cfset var me = structNew() />
		<cfset me.population = getPopulation() />
		<cfset me.wordsToSpeak = getWordsToSpeak() />
		<cfreturn me />
	</cffunction>

</cfcomponent>