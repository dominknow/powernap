<html>
	<head>
		<title>PowerNap for ColdFusion</title>
		<style type="text/css">
			BODY {
				.font-family:calibri;
			}
			
			A {
				margin: 0 0 .5em .5em;
			}
			
			PRE {
				background-color: #e5e5e5;
			}
			
			LI {
				padding: .25em .25em .25em .25em;
			}
			
			div.navigation {
				border: 4px gray solid;
				padding: 2em;
				margin: 0 0 1em 0;
			}
			
			div.main_content {
				border: 4px coral solid;
				padding: 2em;
			}
			
			div.links {
				padding: 1em 0 0 0;
			}
			
			.title {
				font-size: 2em;
				font-weight: bold;
			}
			
		</style>
	</head>
	<body>
		
		<div class="navigation">
			
			<div>
				<span class="title">PowerNap</span><br />
				ColdFusion ReSTful Web Services Made Easy.
			</div>
			
			<div class="links">
				<a href="index.cfm">Intro</a>
				<a href="steps_to_nap_1.cfm">The 20 Minute PowerNap (getting started)</a>
				<a href="../examples/hello_world/index.cfm">Hello World Example</a>
				<a href="goodies.cfm">Other Goodies</a>
			</div>
			
		</div>
		
		<div class="main_content">
		
			<h1>The 20 Minute PowerNap (getting started)</h1>
			
			<cfinclude template="steps_nav.cfm" />
			
			<h2>Step 4: Represent your Resource</h2>
			
			<p>
				All right, you've delcared and created a Resource.  You've told your API in what manner it will be accessed (via mappings) 
				Now you need to return a response to the calling client - but there's a catch; you want to be able to support both .xml and .json 
				formats of that resource for a request.  PowerNap supports two ways of requesting a specific format that work with all four verbs (GET, POST, PUT and DELETE):
			</p>

			<ul>
				<li>
					<strong>Format 'Extension'</strong> - You can include the equivalent of a file extension in the resource you access.
					XML is the default unless specified otherwise, but you can override it like in the following examples:
					<pre><code>GET /my/resource HTTP/1.1
GET /my/resource.xml HTTP/1.1
GET /my/resource.json HTTP/1.1</code></pre>
				</li>
				<li>
					<strong>Content Negotiation</strong> - the HTTP Accept header may be used to specify which format (<a href="http://barelyenough.org/blog/2008/05/versioning-rest-web-services/">or version</a>) is desired.
					You can specify a standard format like application/xml or this can be used with custom vendor MIME media types like application/companyname.vnd+xml:
					<ul>
						<li>In your configuration, name your MIME type: <pre>&lt;cfset format().withExtension("application/vnd.mycompany.myapp+xml").willRespondWith("application/vnd.mycompany.myapp+xml").calls("getAsXML") /&gt;</pre></li>
						<li>
							Handle requests:
							<pre><code>===&gt;
GET /accounts/3 HTTP/1.1
Accept: application/vnd.mycompany.myapp+xml
&lt;===
HTTP/1.1 200 OK
Content-Type: application/vnd.mycompany.myapp+xml

&lt;account&gt;
  &lt;name&gt;Inigo Montoya&lt;/name&gt;
&lt;/account&gt;
</code></pre>
						</li>
					</ul>
				</li>
			</ul>			


			<p>
				All of the above map to the same Resource, and perform the same task - however, as the extensions imply, should respond with
				different formats.  Each format, of course, has very different output requirements.  However your resource needs to be format agnostic - it shouldn't care about the format in which it will be 
				rendered, it simply needs to worry about performing the requested operation.  This is where a 'Representation' comes into play.
			</p>

			<p>
				A 'Representation' is a specialized component that is responsible for rendering your content to the
				requesting client in the correct format.
			</p>

			<p>
				below is the source of the WorldRepresentation in the hello_world example.  You'll notice that the WorldResource can be represented 
				in each of the following formats: .xml, .html, .htm, .json, .say (custom format), .pdf;
			</p>
			
			<pre>&lt;cfcomponent extends="powernap.core.Representation"&gt;
	
	&lt;cffunction name="init" access="public" returntype="powernap.examples.hello_world.WorldRepresentation"&gt;
		&lt;cfreturn this /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="getAsXML" access="public" returntype="xml"&gt;
		
		&lt;!--- //
			This representation 'knows' about our World object because
			we gave it a reference in the WorldResource component via
			the 'represents()' method.  To pull that reference out,
			call the 'getObject()' method.
		// ---&gt;
		&lt;cfset var world = getObject() /&gt;
		
		&lt;!--- //
			Not the most elegant solution to directly include text inline and save the content - 
			but this is just a simple example, so you get the idea.
		// ---&gt;
		&lt;cfsavecontent variable="worldAsXML"&gt;
			&lt;cfoutput&gt;
			&lt;world&gt;
				&lt;population&gt;#world.getPopulation()#&lt;/population&gt;
				&lt;im-supposed-to-say&gt;#world.getWordsToSpeak()#&lt;/im-supposed-to-say&gt;
			&lt;/world&gt;
			&lt;/cfoutput&gt;
		&lt;/cfsavecontent&gt;
		
		&lt;cfreturn worldAsXML /&gt;
	&lt;/cffunction&gt;

	&lt;cffunction name="getAsPDF" acces="public" returntype="any"&gt;
		
		&lt;!--- //
			This representation 'knows' about our World object because
			we gave it a reference in the WorldResource component via
			the 'represents()' method.  To pull that reference out,
			call the 'getObject()' method.
		// ---&gt;
		&lt;cfset var world = getObject() /&gt;
		
		&lt;!--- //
			Not the most elegant solution to directly include text inline and save the content - 
			but this is just a simple example, so you get the idea.
		// ---&gt;
		&lt;cfsavecontent variable="worldAsPDF"&gt;
			&lt;cfdocument format="pdf"&gt;
				I'm a PDF representation of a World Resource!
				Now bask in my portable glory.
				
				&lt;cfoutput&gt;#world.getWordsToSpeak()#&lt;/cfoutput&gt;
			&lt;/cfdocument&gt;
		&lt;/cfsavecontent&gt;
		
		&lt;cfreturn worldAsPDF /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="getAsHTML" access="public" returntype="string"&gt;
		
		&lt;!--- //
			This representation 'knows' about our World object because
			we gave it a reference in the WorldResource component via
			the 'represents()' method.  To pull that reference out,
			call the 'getObject()' method.
		// ---&gt;
		&lt;cfset var world = getObject() /&gt;
		
		&lt;!--- //
			Not the most elegant solution to directly include text inline and save the content - 
			but this is just a simple example, so you get the idea.
		// ---&gt;
		&lt;cfsavecontent variable="worldAsHTML"&gt;
			&lt;cfoutput&gt;
			&lt;h1&gt;#world.getWordsToSpeak()#&lt;/h1&gt;
			&lt;p&gt;
				You can make me say anything you like by simply changing
				the URI to /{whateveryouwant}/world.&lt;br /&gt; For instance, if you want me to say
				'goodbye', then change the URI in the browser address bar to &lt;b&gt;/api.cfm/goodbye/world&lt;/b&gt;.
			&lt;/p&gt;
			&lt;p&gt;
				Did you know that according to the person that wrote me, 
				I have #numberFormat(world.getPopulation(), "___,___,___,___")# inhabitants?
			&lt;/p&gt;
			&lt;/cfoutput&gt;
		&lt;/cfsavecontent&gt;
		
		&lt;cfreturn worldAsHTML /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="getAsCustomFormat" access="public" returntype="any"&gt;
	
		&lt;cfset var world = getObject() /&gt;
		&lt;cfset var content = "This is a custom format.  Although, in this example, it's really just a text file." /&gt;
		
		&lt;cfreturn content /&gt;
	&lt;/cffunction&gt;
	
	&lt;cffunction name="getAsJSON" access="public" returntype="string"&gt;
	
		&lt;cfset var world = getObject() /&gt;
		
		&lt;!--- //
			.JSON functionality made possible by CFJSON: http://www.epiphantastic.com/cfjson/index.php
		// ---&gt;
		&lt;cfset var jsonConverter = createObject("component", "powernap.cfjson.1-9.JSON") /&gt;
		&lt;cfset var json = jsonConverter.encode(world.getAsStruct()) /&gt;
	
		&lt;cfreturn json /&gt;	
	&lt;/cffunction&gt;
	
	&lt;cffunction name="getAsPlainText" access="public" returntype="string"&gt;
		
		&lt;cfset var world = getObject() /&gt;
		
		&lt;cfset var text = "Hi, I'm a plain-text representation of a 'World' resource; " & world.getWordsToSpeak() /&gt;
	
		&lt;cfreturn text /&gt;
	&lt;/cffunction&gt;

&lt;/cfcomponent&gt;</pre>
			
			<p>
				<strong>Things to keep in mind</strong>;
				<ul>
					<li>Your Representation must extend <strong>powernap.core.Representation</strong>.</li>
					<li>Your representation must provide at least one method that will respond to the correct format.</li>
				</ul>
			</p>

			<h3>Natively Supported Formats</h3>
			
			<p>
				PowerNap natively supports the following Formats;
				<ul>
					<li>.txt (getAsPlainText)</li>
					<li>.html and .htm (getAsHTML)</li>
					<li>.xml (getAsXML)</li>
					<li>.json* (getAsJSON)</li>
					<li>.pdf (getAsPDF)</li>
				</ul>
			</p>

			<p>
				So, if you wanted to support xml formats, you would not need to declare a new format in your configuration component, 
				you would simply need to implement the getAsXML method with a return-type of xml in your Representation. (If you wanted to support any other format, the returntype of the method would be "any".)
			</p>
			
			<p>
				<strong>*</strong> <em>
					While PowerNap provies a means to produce and handle format requests, actual formatting operations must be implemented by the API developer
					within the Resource.
					In the case of the .json hello world example, the <strong>cfjson</strong> (<a href="http://www.epiphantastic.com/cfjson/index.php">http://www.epiphantastic.com/cfjson/index.php</a>)
					library was utilized to perform the conversion of the target object.</em>
			</p>
			
			<h3>setDefaultFormat(String extension)</h3>
			
			<p>
				If an extension is ommitted in a request for a resource (/my/resource), then PowerNap will attempt to respond with text/xml (getAsXML).
				If you would like to change that default behavior - the format that PowerNap will render without an extension, you call the <strong>setDefaultFormat()</strong>
				method within your configuration component.
			</p>
			
			<pre>&lt;cfset defaultFormat(".html") /&gt;</pre>
			
			<p>
				With the above declaration, requests for Resources that omit an extension, will respond as though .html (or.htm) was appended to the Resource.
			</p>

		</div>
		
	</body>
</html>