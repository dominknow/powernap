<cfcomponent output="false">

	<cfset variables.defaultExtension = ".xml" />
	<cfset variables.beanFactory = false />
	<cfset variables.formatRegistry = structNew() />
	<cfset variables.resourceRegistry = structNew() />
	<cfset variables.authRegistry = structNew() />
	<cfset variables.authCache = structNew() />
	<cfset variables.componentDispatcher = createObject("component", "powernap.core.ComponentDispatcher").init() />
	<cfset variables.conversionUtils = createObject("component", "powernap.core.ConversionUtils").init() />
	
	<!--- // initialize the map registry // --->
	<cfset variables.mapRegistry = structNew() />
	<cfset variables.mapRegistry["GET"] = arrayNew(1) />
	<cfset variables.mapRegistry["POST"] = arrayNew(1) />
	<cfset variables.mapRegistry["DELETE"] = arrayNew(1) />
	<cfset variables.mapRegistry["PUT"] = arrayNew(1) />
	<cfset variables.mapRegistry["HEAD"] = arrayNew(1) />
	<cfset variables.mapRegistry["OPTIONS"] = arrayNew(1) />
	<cfset variables.mapRegistry["TRACE"] = arrayNew(1) />

	<!--- //
		Initialize default supported representation formats;
	// --->
	<cfset format().withExtension(".txt").willRespondWith("text/plain; charset=UTF-8").calls("getAsPlainText") />
	<cfset format().withExtension(".xml").willRespondWith("application/xml; charset=UTF-8").calls("getAsXML") />
	<cfset format().withExtension(".html").willRespondWith("text/html; charset=UTF-8").calls("getAsHTML") />
	<cfset format().withExtension(".htm").willRespondWith("text/html; charset=UTF-8").calls("getAsHTML") />
	<cfset format().withExtension(".json").willRespondWith("application/json; charset=UTF-8").calls("getAsJSON") />
	<cfset format().withExtension(".pdf").willRespondWith("application/pdf; charset=UTF-8").calls("getAsPDF") />

	<cffunction name="init" access="public" returntype="powernap.core.Engine">
		
		<cfthrow type="powernap.core.Engine.InitializationException"
			message="Cannot directly instantiate the core PowerNap application."
			detail="You must extend this and provide an init() method with the proper configuration." />

	</cffunction>

	<cffunction name="setBeanFactory" access="public" returntype="void">
		<cfargument name="beanFactory" type="coldspring.beans.DefaultXmlBeanFactory" required="true" />
		<cfset variables.beanFactory = arguments.beanFactory />
	</cffunction>
	
	<cffunction name="getBeanFactory" access="public" returntype="any">
		<cfreturn variables.beanFactory />
	</cffunction>
	
	<cffunction name="hasBeanFactory" access="public" returntype="boolean">
		<cfif isObject(getBeanFactory())>
			<cfreturn true />
		</cfif>
		<cfreturn false />
	</cffunction>
	
	<cffunction name="getFormatRegistry" access="public" returntype="struct">
		<cfreturn variables.formatRegistry />
	</cffunction>
	
	<cffunction name="getMapRegistry" access="public" returntype="struct">
		<cfreturn variables.mapRegistry />
	</cffunction>
	
	<cffunction name="getAuthRegistry" access="public" returntype="struct">
		<cfreturn variables.authRegistry />
	</cffunction>
	
	<cffunction name="format" access="public" returntype="powernap.core.Format">
		<cfset var format = createObject("component", "powernap.core.Format").init() />
		<cfset format.setApplicationReference(this) />
		<cfreturn format />
	</cffunction>
	
	<cffunction name="newResource" access="public" returntype="powernap.core.ResourceConfiguration">
		<cfargument name="name" type="string" required="true" />
		
		<cfset var resource = createObject("component", "powernap.core.ResourceConfiguration").init() />
		<cfset resource.setName(arguments.name) />
		
		<!--- // now register the resource // --->
		<cfset variables.resourceRegistry[arguments.name] = resource />
		
		<cfreturn resource />
	</cffunction>
	
	<cffunction name="map" access="public" returntype="powernap.core.Map">
		<cfset var map = createObject("component", "powernap.core.Map").init() />
		<!--- // make sure the map has a reference to the application // --->
		<cfset map.setAppReference(this) />
		<cfreturn map />
	</cffunction>
	
	<cffunction name="go" access="public" returntype="string" output="false">
		<cfargument name="httpMethod" type="string" required="true" />
		<cfargument name="pathInfo" type="string" required="true" />
		<cfargument name="isDebugMode" type="boolean" required="false" default="true" />
		
		<cfset var content = false />
		<cfset var format = false />
		<cfset var params = "" />
		<cfset var representation = "" />
		<cfset var runtimeResource = "" />

		
		<!--- //
			Grab a RuntimeResource based on both the http_method and path_info.
			This effectively 'searches' the registered Maps for a match on 
			the provided URI.
		// --->
		<cfset runtimeResource = getRuntimeResourceFromRequest(arguments.httpMethod, 
				arguments.pathInfo, form, url, getHttpRequestData().headers, getHttpRequestData().content) />
		
		<!--- //
			If no runtime resource was found, then return an 404 response,
			in accordance with ReST principles.
		// --->
		<cfif not runtimeResource.hasResourceReference()>
			<cfheader statuscode="404" statustext="Not Found" />
			<cfsetting showdebugoutput="false" />
			<cfreturn "Not found here" />
		<cfelse>
		</cfif>
		
		<!--- //
			Perform HTTP authentication if an authenticator was defined
			for the target resource.
		// --->
		<cfif runtimeResource.getResourceReference().requiresAuthentication()>
			<cfset params = runtimeResource.getParamStruct() />
			<!--- //
				Make the provided auth username available to the runtime resource
				IF authentication was successful.  Otherwise, it will be an empty string.
			// --->
			<cfset params["auth_username"] = authenticate(runtimeResource.getResourceReference()) />
		<cfelse>
		</cfif>
		
		<!--- //
			Now ask for a representation of the resource that was found.
		// --->
		<cfset representation = getRepresentationFromResource(runtimeResource) />
		
		<!--- //
			And finally, render the correct representation
			of the resource to the requesting client.
		// --->
		<cfreturn render(representation, runtimeResource, arguments.isDebugMode) />
		
	</cffunction>
	
	<cffunction name="newBasicAuthenticator" access="public" returntype="powernap.core.AuthenticatorShell">
		<cfargument name="name" type="string" required="true" />
		<cfset var obj = createObject("component", "powernap.core.AuthenticatorShell").init(this) />
		<cfset obj.setName(trim(arguments.name)) />
		<cfreturn obj />
	</cffunction>
	
	<cffunction name="getRuntimeResourceFromRequest" access="private" returntype="powernap.core.RuntimeResource" output="true">
		<cfargument name="httpMethod" type="string" required="true" />
		<cfargument name="pathInfo" type="string" required="true" />
		<cfargument name="formstruct" type="struct" required="true" />
		<cfargument name="urlstruct" type="struct" required="true" />
		<cfargument name="headerstruct" type="struct" required="true" />
		<cfargument name="requestBody" type="any" required="true" />
		
		<cfset var rr = createObject("component", "powernap.core.RuntimeResource").init() />
		<cfset var idx = "" />
		<cfset var struct = structNew() />
		<cfset var map = false />
		<cfset var resource = false />
		<cfset var content = "" />

		<!--- // Allow tunneling of PUT/DELETE through POST to support less robust clients // --->
		<cfif arguments.httpMethod EQ "POST" AND structKeyExists(arguments.urlstruct, "_method")>
			<cfset arguments.httpMethod = uCase(arguments.urlstruct["_method"]) />
		</cfif>

		<cfloop array="#variables.mapRegistry[arguments.httpMethod]#" index="idx">
			<!--- // if the URL structure has at least one key, then we've found a match // --->
			<cfif (idx.getConfiguredHTTPMethod() IS arguments.httpMethod) AND idx.matchesURI(arguments.pathInfo)>
				
				<!--- // We also support setting the Content-Type header // --->
				<cfset struct = idx.getHeaderVariables(arguments.headerstruct) />
				
				<!--- // This may optionally a format in the URI like .xml or .json, which will override a Content-Type header // --->
				<cfset structAppend(struct, idx.getPathVariables(arguments.pathInfo), true) />
				
				<!--- // append both form and URL parameters // --->
				<cfset structAppend(struct, arguments.urlStruct) />
				<cfset structAppend(struct, arguments.formStruct) />

				<!--- // Handle POST/PUT/DELETE differently (which expect representations as body content) // --->
				<cfif arguments.httpMethod NEQ "GET" AND CGI.content_type NEQ "application/x-www-form-urlencoded">

					<!--- // binary data here will be auto-converted back to a string as needed by CF // --->
					<cfif isBinary(arguments.requestBody)>
						<cfset content = toString(arguments.requestBody) />
					<cfelse>
						<cfset content = arguments.requestBody />
					</cfif>
					
					<!--- // attempt automatic conversion to argumentCollection // --->
					<cfif isXML(content)>
						<cfset structAppend(struct, variables.conversionUtils.xmlToCF(content)) />
					<cfelseif isJSON(content)>
						<cfset structAppend(struct, variables.conversionUtils.jsonToCF(content)) />
					<cfelse>
						<!--- // Unknown content - create an arbitrarily named key "resource" to pass in as an argument to the methods // --->
						<cfset structInsert(struct, "resource", content, true) />
					</cfif>
					
				</cfif>
				
				<!--- // grab a reference to the registered resource // --->
				<cfset resource = getResourceByName(idx.getResourceName()) />
				<cfset rr.setTargetMethod(idx.getTargetMethod()) />
				<cfset rr.setParamStruct(struct) />
				<cfset rr.setResourceReference(resource) />
				
				<!--- // now return the correctly initialized runtime Resource // --->
				<cfreturn rr />
			</cfif>
			
		</cfloop>
	
		<cfreturn rr />
	</cffunction>
	
	<cffunction name="getResourceByName" access="private" returntype="powernap.core.ResourceConfiguration">
		<cfargument name="resourceName" type="string" required="true" />
		<cfreturn variables.resourceRegistry[arguments.resourceName] />
	</cffunction>
	
	<cffunction name="getRepresentationFromResource" access="private" returntype="powernap.core.Representation">
		<cfargument name="resource" type="powernap.core.RuntimeResource" required="true">

		<cfset var representation = false />
		<cfset var targetComponent = "" />
		<cfset var resourceReference = "" />
		<cfset resourceReference = arguments.resource.getResourceReference() />
		<cfset targetComponent = resourceReference.getTargetComponent() />
		
		<cfif hasBeanFactory() and getBeanFactory().containsBean(targetComponent)>
			<cfset targetComponent = getBeanFactory().getBean(targetComponent) />
		</cfif>
		
		<cfset representation = getComponentDispatcher().run(targetComponent, 
					arguments.resource.getTargetMethod(),
					arguments.resource.getParamStruct()) />

		<cfreturn representation />
	</cffunction>
	
	<cffunction name="getContent" access="private" returntype="any">
		<cfargument name="representation" type="any" required="true" />
		<cfargument name="format" type="powernap.core.Format" required="true" />
		
		<cfset var content = getComponentDispatcher().run(arguments.representation, 
				arguments.format.shouldFire(), structNew()) />
	
		<cfreturn content />
	</cffunction>
	
	<cffunction name="getComponentDispatcher" access="private" returntype="powernap.core.ComponentDispatcher">
		<cfreturn variables.componentDispatcher />
	</cffunction>
	
	<cffunction name="defaultFormat" access="public" returntype="void">
		<cfargument name="extension" type="string" required="true" />
		
		<cfif not structKeyExists(variables.formatRegistry, arguments.extension)>
			<cfthrow type="powernap.core.Engine.InvalidFormatException"
				message="Cannot set an invalid format as the application default"
				detail="The format extension '#arguments.extension#' is not supported.
				Please configure it in your application.">
		</cfif>
		
		<cfset variables.defaultExtension = arguments.extension />
	</cffunction>
	
	<cffunction name="getFormatFromExtension" access="private" returntype="powernap.core.Format">
		<cfargument name="extension" type="string" required="true" />
		
		<cfset var type = "" />
		
		<cfif NOT len(trim(arguments.extension))>
			<cfreturn variables.formatRegistry[variables.defaultExtension] />
		</cfif>
		
		<!--- // user-agents (browsers in particular) may send a list of acceptable media types in 
				 order of their preference:
				 Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
				 
				 We need to loop over this list and see if we can find any matches; note we can't use this
				 alone because currently the formats are specified as "html" instead of "text/html".  We could
				 configure both as defaults to support both mechanisms or leave it up to user configuration.
			  // --->
		<cfloop list="#arguments.extension#" index="type">
			<cflog file="powernap" text="Checking #type#" />
			<!--- // Accept headers can have a preference specified in a format like: 
					 Accept: text/html; q=1.0, text/*; q=0.8, image/gif; q=0.6, image/jpeg; q=0.6, image/*; q=0.5, */*; q=0.1 
				  // --->
			<cfif structKeyExists(variables.formatRegistry, listFirst(type, ";"))>
				<cflog file="powernap" text="Found #type# for #arguments.extension#" />
				<cfreturn variables.formatRegistry[arguments.extension] />
			</cfif>
		</cfloop>

		<!--- the type requested is not supported --->
		<cflog file="application" text="caught in getFormatFromExtension, #arguments.extension# doesn't exist in the formatRegistry" />
		<cfheader statuscode="415" statustext="Unsupported Media Type: #arguments.extension#" />
		<cfabort />
		
	</cffunction>
	
	<!--- //
		This method will return either an empty string if authenticate fails OR
		the username that was provided in the request header.
	// --->
	<cffunction name="authenticate" access="private" returntype="string" output="true">
		<cfargument name="resource" type="powernap.core.ResourceConfiguration" required="true" />
			
		<cfset var authReference = false />
		<cfset var componentKey = arguments.resource.getProtectedBy() />
		<cfset var isAuthenticated = false />
		<cfset var varmatch = "" />
		<cfset var credentials = "" />
		<cfset var username = "" />
		<cfset var password = "" />
		<cfset var argStruct = structNew() />
		<cfset var authString = getPageContext().getRequest().getHeader("Authorization") />

		<cfif not isDefined("authString")>
			<cfset authString = "" />
		</cfif>
		
		<!--- peel off the "Basic", we might support others in the future --->
		<cfset argStruct.method = listFirst(authString, " ") />
		<cfset argStruct.username = "" />
		<cfset argStruct.password = "" />
		
		<cfset varmatch = listLast(authString, " ") />
		<cfset credentials = ToString(ToBinary(ListLast(varmatch, " "))) />

		<!--- values can have any character except : --->
		<cfset username = reMatch("([^:]*):", credentials) />
		<cfset password = reMatch(":([^:]*)", credentials) />
		
		<cfif arrayLen(username)>
			<cfset argStruct.username = replaceNoCase(username[1], ":", "", "ALL") />
		</cfif>
		<cfif arrayLen(password)>
			<cfset argStruct.password = replaceNoCase(password[1], ":", "", "ALL") />
		</cfif>
		
		<!--- // 
			Three-step caching check.
		// --->
		<cfif structKeyExists(variables.authCache, componentKey)>
			<cfset authReference = variables.authCache[componentKey] />
		<cfelseif hasBeanFactory() and getBeanFactory().containsBean(variables.authRegistry[componentKey])>
			<cfset authReference = getBeanFactory().getBean(variables.authRegistry[componentKey]) />
			<cfset variables.authCache[componentKey] = authReference />
		<cfelse>
			<cfset authReference = getComponentDispatcher().run(variables.authRegistry[componentKey], "init", structNew()) />
			<cfset variables.authCache[componentKey] = authReference />
		</cfif>
		
		<cfset isAuthenticated = getComponentDispatcher().run(authReference, "isAuthenticated", argStruct) />
		
		<cfif not isAuthenticated>
			<cfheader statuscode="401" />
			<cfheader name="WWW-Authenticate" value="Basic realm='Invalid Authentication for Resource'" />
			<cfabort />
		</cfif>

		<!--- //
			If we've made it this far, then return
			the username of the authentication credentials
		// --->
		<cfreturn trim(argStruct.username) />
	</cffunction>
	
	<cffunction name="render" access="private" returntype="string" output="false">
		<cfargument name="representation" type="powernap.core.Representation" required="true" />
		<cfargument name="runtimeResource" type="powernap.core.RuntimeResource" required="true" />
		<cfargument name="isDebugMode" type="boolean" required="false" default="false" />
		<!--- //
			The 'content' provided by a representation is what needs to be
			sent back to the requesting client.
		// --->
		<cfset var format = "" />
		<cfset var content = "" />

		<cflog file="powernap" text="Rendering" />
		<cftry>
			<cfset format = getFormatFromExtension(runtimeResource.getRequestedFormat()) />
			<cfset content = getContent(representation, format) />
			<cfcatch type="any">
				<cflog file="powernap" text="Error! #cfcatch.message#" />
				<cfrethrow />
			</cfcatch>
		</cftry>
		
		<!--- //
			Ensure the response headers respond correctly to what
			was configured and requested.
		// --->
		<cfheader statuscode="#representation.getResponseHeaders().getStatusCode()#" />
		<cfheader name="Content-Type" value="#format.respondsWith()#" />
		<cfheader name="Access-Control" value="allow <*>" /><!--- this allows cross-domain calls; which should potentially be configurable --->
		<cfheader name="Vary" value="Accept" /><!--- Vary header allows proxies to cache non-standard MIME types --->
	
		<cfif not arguments.isDebugMode>
			<cfsetting showdebugoutput="false" />
		</cfif>
	
		<!--- // Send the content to the client // --->
		<cfreturn content />
	</cffunction>

</cfcomponent>
