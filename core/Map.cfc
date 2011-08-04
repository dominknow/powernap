<cfcomponent output="false">
	
	<cfset variables.appReference = false />
	<cfset variables.HTTPmethod = false />
	<cfset variables.resourceName = false />
	<cfset variables.URI = false />
	<cfset variables.resourceMethodToRun = false />
	<cfset variables.URIRegexMatcher = false />
	
	<cffunction name="init" access="public" returntype="powernap.core.Map">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="get" access="public" returntype="powernap.core.Map">
		<cfset variables.HTTPMethod = "GET" />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="post" access="public" returntype="powernap.core.Map">
		<cfset variables.HTTPMethod = "POST" />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="put" access="public" returntype="powernap.core.Map">
		<cfset variables.HTTPMethod = "PUT" />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="delete" access="public" returntype="powernap.core.Map">
		<cfset variables.HTTPMethod = "DELETE" />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="head" access="public" returntype="powernap.core.Map">
		<cfset variables.HTTPMethod = "HEAD" />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="options" access="public" returntype="powernap.core.Map">
		<cfset variables.HTTPMethod = "OPTIONS" />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="trace" access="public" returntype="powernap.core.Map">
		<cfset variables.HTTPMethod = "TRACE" />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getConfiguredHTTPMethod" access="public" returntype="string">
		<cfreturn variables.HTTPMethod />
	</cffunction>
	
	<cffunction name="uri" access="public" returntype="powernap.core.Map">
		<cfargument name="URI" type="string" required="true" />
		
		<cfset var registry = variables.appReference.getMapRegistry() />
		<cfset arrayAppend(registry[getConfiguredHTTPMethod()], this) />
		
		<cfset setURI(arguments.URI) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="to" access="public" returntype="powernap.core.Map">
		<cfargument name="resourceName" type="string" required="true" />
		<cfset variables.resourceName = arguments.resourceName />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="calls" access="public" returntype="powernap.core.Map">
		<cfargument name="resourceMethodToRun" type="string" required="true" />
		<cfset variables.resourceMethodToRun = arguments.resourceMethodToRun />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getTargetMethod" access="public" returntype="string">
		<cfreturn variables.resourceMethodToRun />
	</cffunction>
	
	<cffunction name="getResourceName" access="public" returntype="string">
		<cfreturn variables.resourceName />
	</cffunction>
	
	<cffunction name="setAppReference" access="public" returntype="void">
		<cfargument name="appReference" type="powernap.core.Engine" />
		<cfset variables.appReference = arguments.appReference />
	</cffunction>
	
	<cffunction name="matchesURI" access="public" returntype="boolean">
		<cfargument name="actualURI" type="string" required="true" />
		
		<!--- // attempt a match // --->
		<cfset var matchResults = refind(variables.URIRegexMatcher, arguments.actualURI, 1, true) />

		<!--- // check to see if we have a winner // --->
		<cfif arrayLen(matchResults.LEN) lte 1>
			<!--- // only one array index means that this is NOT a match // --->
			<cfreturn false />
		</cfif>
	
		<cfreturn true />
	</cffunction>
	
	<cffunction name="getPathVariables" access="public" returntype="struct">
		<cfargument name="actualURI" type="string" required="true" />
		
		<cfset var URIVars = arrayNew(1) />
		<cfset var URIVarStruct = structNew() />
		
		<!--- // attempt a match // --->
		<cfset var matchResults = refind(variables.URIRegexMatcher, arguments.actualURI, 1, true) />
		
		<!--- // check to see if we have a winner // --->
		<cfif arrayLen(matchResults.LEN) lte 1>
			<!--- // only one array index means that this is NOT a match // --->
			<cfreturn URIVarStruct />
		</cfif>

		<!--- //
			Create the "template" for URI variables (/myresource/{variable1}/{variable2})
			and then populate that template with actual values based off of PATH_INFO
		// --->
		<cfset URIVars = createURIVarReference() />
		<cfset URIVarStruct = getPopulatedURIVarStruct(URIVars, matchResults, arguments.actualURI) />
		
		<!--- // now extract the format variable // --->
		<cfset URIVarStruct._format = getFormat(arguments.actualURI, matchResults) />
		
		<!--- // finally, return the populated URI variables structure // --->
		<cfreturn URIVarStruct />
	</cffunction>
	
	<cffunction name="getHeaderVariables" access="public" returntype="struct">
		<cfargument name="headerstruct" type="struct" required="true" />
		
		<cfset var HeaderStructVars = structNew() />
		
		<!--- // First, check if the HTTP Accept header was provided; as this will override the URI .extension // --->
		<cfif structKeyExists(arguments.headerstruct, "Accept") AND len(arguments.headerstruct.Accept)>
			<cfset HeaderStructVars._format = arguments.headerstruct.Accept />
		</cfif>

		<cfreturn HeaderStructVars />			
	</cffunction>
	
	<cffunction name="setURI" access="private" returntype="void">
		<cfargument name="URI" type="string" required="true" />

		<!--- // first, set the "confiuration" URI in this object instance // --->
		<cfset variables.URI = arguments.URI />
		
		<!--- // now, extract all URI variables // --->
		<cfset setURIVarArray(buildURIVarArray()) />
		
		<!--- // 
			Build the dynamic matcher that will be used
			to map this Route to a Resource based off of the
			URL at run-time
		// --->
		<cfset setURIRegexMatcher(buildDynamicRegexMatcher(getURIVarArray())) />
	</cffunction>
	
	<cffunction name="setURIRegexMatcher" access="private" returntype="void">
		<cfargument name="URIRegexMatcher" type="string" required="true" />
		<cfset variables.URIRegexMatcher = arguments.URIRegexMatcher />
	</cffunction>
	
	<cffunction name="getURIRegexMatcher" access="private" returntype="string">
		<cfreturn variables.URIRegexMatcher />
	</cffunction>
	
	<cffunction name="setURIVarArray" access="private" returntype="void">
		<cfargument name="URIVarArray" type="array" required="true" />
		<cfset variables.URIVarArray = arguments.URIVarArray />
	</cffunction>
	
	<cffunction name="getURIVarArray" access="private" returntype="array">
		<cfreturn variables.URIVarArray />
	</cffunction>
	
	<cffunction name="buildDynamicRegexMatcher" access="private" returntype="string">
		<cfargument name="URIVarArray" type="array" required="true" />
		
		<!--- // variables.URI is a reference to the "configuration" URI, not actual path info // --->
		<cfset var matcher = variables.URI />
		<cfset var currentReference = false />
		<cfset var prefix = "^" />
		<cfset var keysList = structKeyList(variables.appReference.getFormatRegistry(), "|") />
		<cfset var suffix = "?(#keysList#)?$" />
		<cfset var idx = "" />
		
		<cfloop from="1" index="idx" to="#arrayLen(arguments.URIVarArray)#">
			<cfset currentReference = URIVarArray[idx] />
			<!--- if this regex includes a period, we can't get formats from URIs like /resource/ID.xml --->
			<cfset matcher = rereplace(matcher, currentReference, "([\w*-]*)") />
		</cfloop>
		
		<cfset matcher = prefix & matcher & suffix />
		
		<cfreturn matcher />
	</cffunction>
	
	<cffunction name="buildURIVarArray" access="private" returntype="array">
		<cfreturn rematch("(\{\w*})", variables.URI) />
	</cffunction>
	
	<cffunction name="getFormat" access="private" returntype="string">
		<cfargument name="actualURI" type="string" required="true" />
		<cfargument name="regexMatchStruct" type="struct" required="true" />
		
		<cfset var lastPosition = arrayLen(arguments.regexMatchStruct.POS) />
		<cfset var format = false />
		
		<!--- //
			First, check to see if a format was provided in the URI (as an extension, .xml, .html, etc).
			If it exists, then the last position of the regex Array (regexmatchStruct) will NOT be zero
		// --->
		<cfif arguments.regexMatchStruct.POS[lastPosition] eq 0 and arguments.regexMatchStruct.POS[lastPosition] eq 0>
			<cfreturn "" />
		</cfif>
		
		<cfset format = mid(arguments.actualURI, arguments.regexMatchStruct.POS[lastPosition], arguments.regexMatchStruct.LEN[lastPosition]) />
		
		<cfreturn format />
	</cffunction>
	
	<cffunction name="createURIVarReference" access="private" returntype="array">
		<cfset var template = getURIVarArray() />
		<cfset var currentReference = false />
		<cfset var populatedURIVars = arrayNew(1) />
		<cfset var idx = "" />
		
		<!--- // 
			populate the var array, but make sure to strip out
			all curly braces
		// --->
		<cfloop from="1" index="idx" to="#arrayLen(template)#">
			<cfset currentReference = URIVarArray[idx] />
			<cfset arrayAppend(populatedURIVars, rereplace(currentReference, "[\{*}*]", "", "all")) />
		</cfloop>
		
		<cfreturn populatedURIVars />
	</cffunction>
	
	<cffunction name="getPopulatedURIVarStruct" access="private" returntype="struct">
		<cfargument name="varTemplate" type="array" required="true" />
		<cfargument name="matchResults" type="struct" required="true" />
		<cfargument name="actualURI" type="string" required="true" />
		
		<cfset var populatedVarStruct = structNew() />
		<cfset var position = false />
		<cfset var varname = false />
		<cfset var idx = "" />
		
		<!--- // 
			First, check to see if any variables need to be populated.  This
			may be the case for Route URI's that have been configured without
			any variable requirements e.g., /myresource/test
		// --->
		<cfif not arrayLen(arguments.varTemplate)>
			<cfreturn populatedVarStruct />
		</cfif>
		
		<!--- // populate the URIvars with info from the URI // --->
		<cfloop from="2" index="idx" to="#arrayLen(matchResults.POS)#">
			<cfset position = idx - 1 />
			<cfset varname = varTemplate[position] />
			<cfset structInsert(populatedVarStruct, varname, mid(actualURI, matchResults.POS[idx], matchResults.LEN[idx])) />
			<cfif position eq (arrayLen(matchResults.POS) - 2)>
				<cfbreak />
			</cfif>
		</cfloop>
		
		<cfreturn populatedVarStruct />
	</cffunction>

</cfcomponent>