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
			
			<h2>Step 1: Configure your ReSTful API</h2>
			
			<p>
				A PowerNap API is a set of instructions initialized in your PowerNap engine, that in it's
				most simple form - 	maps URI's to Resources.  But before we get into all the dirty details regarding how a
				mapping is established, and what exactly a Resource is, you'll need to create a .cfc
				that extends <strong>powernap.core.Engine</strong>.  For now we'll call this
				your <strong>configuration component</strong>, although in reality - what you've created <strong>is a</strong>
				PowerNap engine object that will be directly utilized in the processing of ReSTful requests.
				I've provided a simple "shell" below that you can copy and paste if you like;
			</p>
	
			<a name="the_configuration_component" />		
			<h3>The Configuration Component</h3>
			
			<pre>&lt;cfcomponent extends="powernap.core.Engine"&gt;

	&lt;cffunction name="init" access="public" returntype="powernap.core.Engine"&gt;
		
		&lt;!--- //
			Your API declarations will go here.
		// ---&gt;
		
		&lt;cfreturn this /&gt;
	&lt;/cffunction&gt;

&lt;/cfcomponent&gt;</pre>
			
			<p>
				<strong>Things to Keep in Mind:</strong><br />
				<ul>
					<li>This .cfc can be located anywhere you like.</li>
					<li>This .cfc can have any name you like.</li>
					<li>This .cfc <strong>must</strong> extend powernap.core.Engine</li>
					<li>This .cfc must implement an <strong>init()</strong> method.</li>
					<ul>
						<li>
							init() <strong>must</strong> have a returntype of <strong>powernap.core.Engine</strong>
							i.e., an instance of the core.PowerNap component via &lt;cfreturn this /&gt;
						</li>
					</ul>
				</ul>
			</p>
			
			<p>
				The component that you just created, that extends the core PowerNap engine component, is what we will use
				to configure your endpoints file in the second step.
			</p>
			
			<a name="configuring_a_resource" />
			<h3>API Declarations: Declaring a Resource</h3>
			
			<p>
				The first thing we're going to do is "define" which <strong>Resources</strong> our API is going
				to expose.  For now, all you need to understand is that a Resource is a .cfc that upon a successfull
				URI match, will perform an operation - and optionally return data to the requestor.
				But again, we'll get into that later.  For now, all we're worried about is declaring the API.
			</p>
			
			<p>
				Configuring a Resource is a simple matter of telling your PowerNap engine where (or rather how) to
				find your Resource component.  Go ahead and crack open your configuration component.  And anywhere within
				the <strong>init()</strong> method, place this line of code;
			</p>
			
			<pre>&lt;cfset newResource("myResource").isA("target.cfc.location") /&gt;</pre>
			
			<p>
				One of the first things you may notice here, is that our "configuration" is nothing more than
				a couple of method calls daisy-chained together.  Let's break it down;
				
				<ul>
					<li>
						<strong>newResource(resourceName)</strong>; Inherited from the super class, this method does exactly what you think it does - creates a new
						PowerNap-managed resource.  This method accepts a string argument representing the name you would
						like to give your resource.  The "name" you give it is only meaningful within this configuration
						component - you'll see what I mean when we get into URI Mappings in a minute.  The name argument
						must be unique to this resource - don't go giving the same name to another resource declared in
						this file.
					</li>
					<li>
						<strong>isA(targetCFCLocation)</strong>; This method indicates that the named resource you want to create
						is of the type specified in this argument.  Again, I don't want you to worry about the contents or
						implementation details of your target Resource right now - we'll get to that soon.  This argument
						can represent the dot-notation path (location) to your CFC <strong>OR</strong> a <strong>ColdSpring</strong>
						bean name that has been configured in an external Coldspring configuration file.  Coldspring integration
						is easy and will be covered in step two regarding setting up your endpoints configuration.
						
						Ultimately, the argument passed to the <strong>isA()</strong> method
						will tell the PowerNap engine where to locate your Resource component.
					</li>
				</ul>
			</p>
			
			<p>
				Now, your PowerNap engine "knows" about a resource that will be exposed via the API, <strong>and</strong>
				where to locate that Resource in order to instantiate it correctly.
			</p>
			
			<p>
				Of course, you can declare any number of Resources that need to be a part of your web services API.
			</p>
			
			<a name="mapping_uri_to_resource" />
			<h3>API Declarations: Mapping a URI to a Resource</h3>
			
			<p>
				The second piece of the API puzzle is to map a URI to the resource you've just created, because although
				we've just told PowerNap about a resource, it still has no idea how to service a request for that Resource.
			</p>
			
			<p>
				We're still operating in your configuration component - so, right underneath your Resource delcaration that
				we just covered, insert the following line of code;
			</p>

			<pre>&lt;cfset map().get().uri("/myresource/{id}").to("myResource").calls("someMethod") /&gt;</pre>
			
			<p>
				This may seem a little more confusing than our Resource declaration, hopefully this next section will clear it
				up a bit for you.
			</p>
			
			<p>
				You'll notice the same convention for this mapping delcaration as we used for the Resource delcaration - linked
				method calls.  This mechanism allows you to express your mapping in a logical and readable format.  Read as a sentence,
				the previous declaration tells the PowerNap engine this;
			</p>
			
			<em>
				<strong>
				Map a request with the HTTP method "GET", and the URI "/myresource/{id}" to the Resource "myResource".<br />
				When a match is found, call the "someMethod" function on that Resource.
				</strong>
			</em>
			
			<h3>Important Note</h3>
			
			<p>
				The <strong>get()</strong> is an important part of the mapping declaration above.  This method is telling
				the mapping that in order for it to match the provided URI, that the request being made <strong>must</strong>
				have an HTTP method type of "GET".  If you want instead for the URI to match only an HTTP method of "POST",
				then you would substitute the "get()" for "post()".  PowerNap supports the following HTTP methods;
				<ul>
					<li>GET get()</li>
					<li>POST post()</li>
					<li>PUT put()</li>
					<li>DELETE delete()</li>
					<li>HEAD head()</li>
					<li>OPTIONS options()</li>
					<li>TRACE trace()</li>
				</ul>
			</p>
			
			<p>
				What you may be asking yourself at this moment;
				<ul>
					<li>
						<strong>Q</strong>: Where does the URI root start?  In other words, I know if I simply type /myresource/{id}
						into my browser address bar, I'm not going to get back what I want - should there be 
						a .cfm file somewhere in that path?
					</li>
					<li><strong>A</strong>: Yes.  You're correct - there is in fact a .cfm file involved in order to complete
					this scenario - the endpoints file, which is explained in detail in the second step.</li>
				</ul>
				
				<ul>
					<li><strong>Q</strong>: What's up with the curly-braces surrounding <strong>id</strong>? </li>
					<li><strong>A</strong>: That was a good question, so good in fact, 
					that I'm going to dedicate the next section entirely to it...</li>
				</ul>
				
			</p>
			
			<a name="uri_variables" />
			<h3>URI Variables</h3>
			
			<p>
				URI variables are variables that can be extracted from a matched URI - <strong>They are not query-string key/value pairs</strong>
				and shouldn't be confused as such - the key distinction being this;
				
				<ul>
					<li>Query-String variables (parameters as /resource/?id=123) are not considered a part
					of the URI.  In other words, they are <strong>not</strong> taken into consideration
					when attempting to map a URI to a Resource.  <em>Query-string parameters can still be
					utilized in PowerNap, they're just not a part of the decision-making process when
					URI mappings occur.</em></li>
					<li>Conversely, URI variables <strong>are</strong> considered a part of the URI
					and should a URI variable that has been configured (/resource/{id} as /resource/123) not exist
					(/resource/), then a match will not occur.</li>
				</ul>
				
				.  The URI you configured
				in the mapping you created in the previous section looked like this;
			</p>
			
			<pre>/myresource/{id}</pre>
			
			<p>
				The culprit in the curly-braces is a variable declaration and it operates in a very specific way.
			</p>
			
			<p>
				URI variables "capture" the value that exists in that position of the URI, and injects that value into
				your target Resource, providing an argument name exactly as it was configuered.
			</p>
			
			<p>
				In the above URI configuration, the following URI requests <strong>WILL</strong> match it (i.e, will
				map to the Resource to which they were attached via the <strong>to()</strong> method.);
			</p>

			<pre>/myresource/1234
/myresource/abcd
/myresource/alphanumeric123456789</pre>
			
			<p>
				More importantly, each value succeeding the second forward slash "/" (based on our URI declaration) is captured and provided
				to your target CFC.
			</p>
			
			<p>
				<strong>SO</strong> when a Mapping match is found, and the target method (configured via the
				<strong>calls()</strong> method) is called on your target Resource, the value that was captured
				is provided in an argument named <strong>id</strong>.
			</p>
			
			<p>
				Let's refer back to our original mapping declaration;
			</p>
			
			<pre>&lt;cfset map().get().uri("/myresource/{id}").to("myResource").calls("someMethod") /&gt;</pre>
			
			<p>
				In order to get a handle on the value of {id}, your Resource method signature would have to 
				include an argument to account for it;
			</p>

			<pre>&lt;cffunction name="someMethod" access="public" returntype="powernap.core.Representation"&gt;
	&lt;cfargument name="id" type="numeric" required="true" /&gt;

	... more method stuff ...
&lt;/cffunction&gt;</pre>

			<p>
				Let's try another example mapping configuration;
			</p>
			
			<pre>&lt;cfset map().get().uri("/user/{firstname}/{lastname}/roles").to("myResource").calls("getUserRoles") /&gt;</pre>
			
			<p>
				...would match the following URI's;
			</p>
			
			<pre>/user/foo/bar/roles
/user/mr/marbles/roles</pre>
			
			<p>
				...and would <strong>not</strong> match;
			</p>
			
			<pre>/user/foo/roles
/user/roles
/user/foo/bar/roles/permissions</pre>
			
			
			<p>
				..and finally, what your target resource method signature would need to look like in order to capture
				the "firstname" and "lastname" URI variables.
			</p>
	
			<pre>&lt;cffunction name="getUserRoles" access="public" returntype="powernap.core.Representation"&gt;
	&lt;cfargument name="firstname" type="string" required="true" /&gt;
	&lt;cfargument name="lastname" type="string" required="true" /&gt;

	... more method stuff ...
&lt;/cffunction&gt;</pre>

		<h3>Your ReSTful API Has Been Defined</h3>
		
		<p>
			Now that you've declared a resource, and have mapped a request method and URI to that resource,
			your API is now ready to start serving requests for your resource.  It's time to move on to the
			next step, <a href="steps_to_nap_2.cfm">Configuring your endpoints file</a>.
		</p>
	
		</div>
		
	</body>
</html>