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
			
			<h2>Step 2: Configure your Endpoints File</h2>
			
			<p>
				The endpoints file is a simple .cfm template that routes requests to your configured PowerNap engine (which
				we learned about in step one).  The contents of this file is specific, which we'll discuss - however
				this file can be named anything and located anywhere you like.  <strong>For example;</strong>
			</p>
			
			<pre>/anydirectory/anyname.cfm</pre>
			
			<p>
				This file represents the "root" of your web services - where they begin.  If you had a configured resource with a mapped URI
				of "/my/resource", then to request that resource, you would type the following in your browsers address bar;
			</p>
			
			<pre>/anydirectory/anyname.cfm/my/resource</pre>
			
			<p>
				Go ahead and create an empty .cfm template in a location that suits you.
			</p>
			
			<p>
				Time to fill in the blanks on that file.  Go ahead and crack open that new .cfm endpoints file you created and paste into it
				the code provided below;
			</p>
			
			<pre>&lt;cfimport taglib="/powernap/tag/" prefix="powernap" /&gt;

&lt;powernap:endpoints 
	name="my_endpoints"
	engine="{dot.notation.path.to.your.ConfigurationComponent}"
	reload="false"
	reload_key="reload"
	reload_value="reloadme"
	debug="true" /&gt;</pre>
			
			<p>
				<strong>You're done!</strong>
			</p>
			
			<p>
				Your ReSTful web services API has been configured and is ready to go - with the exception of course
				of having the API point to non-existent resources - we haven't created those yet.  We'll
				cover that in the subsequent steps.  However
				before we move one - I'm going to demistify this tags attributes.
			</p>
			
			<p>
				<table border="1">
					<th>Attribute Name</th>
					<th>Required</th>
					<th>Expected Value</th>
					<th>Description</th>
					
					<tr>
						<td>name</td>
						<td>true</td>
						<td>Unique Application Name</td>
						<td>This should represent a unique value specific to your PowerNap instance.  If you have more
						than one PowerNap engine running within the same CF application context, then each endpoints file
						configuration should have its own unique name.</td>
					</tr>
					
					<tr>
						<td>engine</td>
						<td>true</td>
						<td>Path to your Configuration Component</td>
						<td>This should be the dot-notation path (location)to the configuration component (see step one) that
						extends the powernap.core.Engine component.</td>
					</tr>
					
					<tr>
						<td>reload</td>
						<td>false</td>
						<td>Boolean true or false</td>
						<td>Reinitializes and reloads the PowerNap engine for each request.  If the PowerNap instance is 
							managing an internal ColdSpring DefaultXMLBeanFactory instance (via a provided configuration file path),
							then the engine will recreate and reload the associated BeanFactory for each request as well.
							Recommended for development only.  Defaults to false.</td>
					</tr>
					
					<tr>
						<td>reload_key</td>
						<td>false</td>
						<td>String</td>
						<td>Useful when the "reload" attribute is absent or has been set to "false".  Must be accompanied
						by "reload_value" in order to operate correctly.  The value of this attribute represents
						an associated URL parameter that when present (and when it's value matches the "reload_value" attribute
						value), reinitialize and reload the engine.  If the URL key/value pair is absent, then the default 
						reload behavior is utilized.  If the value to this tag is "foo", and the value of the "reload_value" attribute
						is "bar", then the following URL would force a reload of the engine;
						
						<pre>/api.cfm/my/resource?foo=bar</pre>
						
						</td>
					</tr>
					
					<tr>
						<td>reload_value</td>
						<td>false</td>
						<td>String</td>
						<td>See "reload_key" for more information.</td>
					</tr>
					
					<tr>
						<td>debug</td>
						<td>false</td>
						<td>Boolean true or false</td>
						<td>When set to "false", will suppress ColdFusion debugging output which normally 
							appears at the bottom of the screen (when enabled in the CF Administrator).  Defaults to "false".
							<strong>It is recommended that this be allowed to remain "false" when possible, when developing your ReST API because having
							CF debug output rendered at the end of the request will break requests for .xml resources.</strong>.</td>
					</tr>
					
					<tr>
						<td>coldspring</td>
						<td>false</td>
						<td>String path to a coldspring.xml configuration file
						<strong>OR</strong> an instantiated ColdSpring coldspring.beans.DefaultXmlBeanFactory Object</td>
						<td>
							You can utilize the Coldspring IoC container framework to manage Resource and Authentication
							component dependencies if you like with this attribute.  This attribute can accept one of two possible
							data types;
							<ol>
								<li>A relative file path to a coldspring bean configuration file (.xml); In this case, PowerNap
								will create an instance of the bean Factory and manage it internally.</li>
								<pre>coldspring="/path/to/my/coldspring-config.xml"</pre>
								<li>An already instantiated DefaultXmlBeanFactory object; in this case, the object factory has already
								been initialized and instantiated, and a reference is provided to the PowerNap engine.</li>
								<pre>coldspring="#coldspringBeanFactory#"</pre>
							</ol>
							
							In either case, whenever you declare a Resource via <strong>newResource(name).isA(componentPath)</strong>, the <strong>isA()</strong>
							method can accept the ID (as a string) of a configured bean that the factory manages.  Then, when the engine maps a URI to 
							a Resource to service a request, PowerNap asks ColdSpring to provide an instance of the Resource.
							
						</td>
					</tr>
					
					<tr>
						<td>bootstrapper</td>
						<td>false</td>
						<td>String dot notation path to a CFC 
						<strong>OR</strong> the name of a ColdSpring declared bean.</td>
						<td>
							You can effectively 'set-up' your powernap application via a bootstrapper object with this configuration.  You must provide
							an init() method on the target component - as this method will be invoked when the powernap application is initialized.  The actual
							set-up process of your application is then defined (as any type of logic or algoritm) from within the method body of init().
						</td>
					</tr>
					
				</table>
			</p>
			
			<p>
				Let's go ahead and <a href="steps_to_nap_3.cfm">create a Resource</a>.
			</p>

		</div>
		
	</body>
</html>