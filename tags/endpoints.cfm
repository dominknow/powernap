<cfsilent>
	<cfparam name="attributes.name" type="string" />
	<cfparam name="attributes.engine" type="string" />
	<cfparam name="attributes.coldspring" type="any" default="" />
	<cfparam name="attributes.bootstrapper" type="string" default="" />
	<cfparam name="attributes.reload" type="boolean" default="false" />
	<cfparam name="attributes.reload_key" type="string" default="false" /><!--- the default reload key is "false"? --->
	<cfparam name="attributes.reload_value" type="string" default="false" />
	<cfparam name="attributes.debug" type="boolean" default="false" />
	<cfparam name="url.#attributes.reload_key#" default="" />
	
	<!--- // outermost try/catch to return an HTTP error instead of a ColdFusion error 
		
			Will generate custom response headers based on the Engine name, like:
			
			X-PowerNap-Error 
			X-PowerNap-Error-Detail (debug mode only)
			X-PowerNap-Error-Location (debug mode only)
	// --->
	<cffunction name="returnError">
		<cfargument name="status" type="numeric" required="false" default="500" />
		<cfargument name="header" type="string" required="false" default="#attributes.name#" />
		<cfargument name="error" type="any" required="true" />
		
		<cfset var msg = "" />
	
		<cfswitch expression="#arguments.status#">
			<cfcase value="500"><cfset msg = "Internal Server Error" /></cfcase>
			<cfcase value="502"><cfset msg = "Bad Gateway" /></cfcase>
			<cfcase value="503"><cfset msg = "Service Unavailable" /></cfcase>
		</cfswitch>
	
		<!--- // provide stock headers for all responses // --->
		<cfheader statuscode="#arguments.status#" statustext="#msg#" />
		<cfheader name="X-#arguments.header#-Error" value="#cfcatch.message#" />
	
		<!--- // provide optional detail // --->
		<cfif attributes.debug>
			<cfheader name="X-#arguments.header#-Error-Detail" value="#cfcatch.detail#" />
			<cfif structKeyExists(cfcatch, "TagContext") AND isArray(cfcatch.TagContext) AND arrayLen(cfcatch.TagContext)>
				<cfheader name="X-#arguments.header#-Error-Location" value="#cfcatch.TagContext[1].Template# (Line #cfcatch.TagContext[1].Line#)" />
			</cfif>
			<cfif structKeyExists(cfcatch, "sql")>
				<cfheader name="X-#arguments.header#-Error-SQL" value="#cfcatch.sql#" />
			</cfif>
			<cfif structKeyExists(cfcatch, "where")>
				<cfheader name="X-#arguments.header#-Error-SQL-WHERE" value="#cfcatch.where#" />
			</cfif>
		</cfif>
		<cfcontent reset="true" /><cfabort />
	
	</cffunction>

</cfsilent>
<cfswitch expression="#thisTag.executionMode#">
	
	<cfcase value="start">
		
		<cftry>
			
			<cfif NOT structKeyExists(application, "_powernap_engine") 
					OR NOT structKeyExists(application._powernap_engine, attributes.name)
					OR attributes.reload EQ true
					OR url[attributes.reload_key] EQ attributes.reload_value>
			
				<!--- //
					Ensure the application is initialized properly; error here results in 503
				// --->
				<cfset variables.app = createObject("component", attributes.engine).init() />
			
				<!--- // 
					Can either set an already instantiated coldspring BeanFactory object OR
					create one from a provided coldspring config file path.
				// --->
				<cfif isObject(attributes.coldspring)>
					<cfset variables.app.setBeanFactory(attributes.coldspring) />
				<cfelseif len(trim(attributes.coldspring))>
					<cfset variables.beanFactory = createObject("component", "coldspring.beans.DefaultXmlBeanFactory").init() />  
					<cfset variables.beanFactory.loadBeans(attributes.coldspring) />
					<cfset variables.app.setBeanFactory(variables.beanFactory) />
				</cfif>
				
				<!--- //
					Now if a bootstrapper cfc is provided, either ask coldspring for it, or instantiate a new
					reference and invoke the init method.
				// --->
				<cfif isDefined("attributes.bootstrapper") and len(trim(attributes.bootstrapper))>
					<cfif variables.app.hasBeanFactory() and variables.app.getBeanFactory().containsBean(attributes.bootstrapper)>
						<!--- // 
							Because asking for the bean via the 'getBean()' method implicitly invokes the 'init' method
							on the target object - all we need to do is ask for it - nothing else
						// --->
						<cfset variables.app.getBeanFactory().getBean(attributes.bootstrapper) />
					<cfelse>
						<cfset createObject("component", attributes.bootstrapper).init() />
					</cfif>
				</cfif>
				
				<!--- //
					Now set the application as a singleton, accessible in the
					application scope.
				// --->
				<cflock scope="application" type="exclusive" timeout="25" throwontimeout="true">
					<cfset application._powernap_engine[attributes.name] = variables.app />
				</cflock>
				
			</cfif>

			<cfcatch type="any">
				<!--- We couldn't instantiate PowerNap, which is a small problem. --->
				<cfset returnError(status = 503, error = cfcatch) />
			</cfcatch>

		</cftry>
		
	</cfcase>
	
	<cfcase value="end">
		<!--- //
			Process the resource request; if an error exists while generating, it's a 500
		// --->
		<cftry>
			<cfset content = application._powernap_engine[attributes.name].go(cgi.request_method, cgi.path_info, attributes.debug) />
			<cfoutput>#content#</cfoutput>
			<cfcatch type="any">
				<!--- // any uncaught exception means a 500 in REST parlance // --->
				<!--- TODO: should we output the error as a representation in either XML or JSON? --->
				<cfset returnError(status = 500, error = cfcatch) />
			</cfcatch>
		</cftry>
	</cfcase>

</cfswitch>
