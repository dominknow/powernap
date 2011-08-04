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
			
			<h2>Step 3: Create your Resource</h2>
			
			<p>
				We've got our API configured and ready to match request URI's to Resources (that is, if you followed
				the instructions in the first two steps).  However, we have our API looking for a resource
				that hasn't been created yet - let's take care of that.
			</p>
			
			<p>
				A Resource component is where the proverbial "rubber meets the road".
				It's where the implementation details exist for your API.  This component and it's associated
				methods will determine how responses to mapped requests are satisfied.
			</p>
			
			<p>
				This was touched on briefly in the first step - let's continue with that example.  Our
				Resource was declared in the following manner (in our configuration component);
			</p>
			
			<pre>&lt;cfset newResource("myResource").isA("target.cfc.location") /&gt;</pre>
			
			<p>
				And we declared the following request URI mapping for that resource like this;
			</p>
			
			<pre>&lt;cfset map().get().uri("/myresource/{id}").to("myResource").calls("someMethod") /&gt;</pre>
			
			<p>
				In order to handle a matched request, we'll need the following method defined in our "target.cfc.location"
				component;
			</p>
			
			<pre>&lt;cffunction name="someMethod" access="public" returntype="powernap.core.Representation"&gt;
	&lt;cfargument name="id" type="numeric" required="true" /&gt;

	&lt!--- // Perform operations here! // ---&gt;

	&lt;cfreturn simpleRepresentation().withContent("").withStatus(200) /&gt;
&lt;/cffunction&gt;</pre>

			<p>
				In this example, we're returning a 'SimpleRepresentation' with no content (empty string) and an HTTP status code
				of 200.  The 'simpleRepresentation()' method is a convenience routine delcared in <strong>powernap.core.Representation</strong>
				that allows Representations that are extensions of the core component, to render simple responses in text/plain format.
				This may or may not be what you want to do at the end of your operation but don't worry about this right now,
				instructions on how to properly represent your Resource is covered in step 4.
			</p>

			<p>
				<strong>Things to Keep in Mind:</strong><br />
				<ul>
					<li>Resource Methods (that have an associated Mapping) <strong>must</strong> have a returntype of <strong>powernap.core.Representation</strong>.</li>
					<li>A Resource component can <strong>optionally</strong> extend powernap.core.Resource if you need
					access to convenience methods for setting response header information or returning simple Representations.</li>
					<li>The primary responsibility of the Resource component is to perform any operations necessary to satisfy the contract
					of the API and the associated request, <strong>and return the correct representation and HTTP response</strong>.</li>
				</ul>
			</p>
			
			<p>
				In order to further understand this concept, I recommend opening up the /powernap/examples/resources/WorldResource component
				and review the implementation of the <strong>saySomething()</strong> method.
			</p>
			
			<p>
				When the Resource has completed it's processing of the request, it must return a representation - which is what
				we're going to get into in the next step.
			</p>

		</div>
		
	</body>
</html>