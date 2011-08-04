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
				<a href="../../documentation/index.cfm">Intro</a>
				<a href="../../documentation/steps_to_nap_1.cfm">The 20 Minute PowerNap (getting started)</a>
				<a href="../../examples/hello_world/">Hello World Example</a>
				<a href="../../documentation/goodies.cfm">Other Goodies</a>
			</div>
			
		</div>
		
		<div class="main_content">

			<h1>Hello World Example</h1>

			<p>
				What you are viewing right now is <b>NOT</b> a ReSTful web services endpoint.
				The links below create http GET requests to their respective URI's.  At which point,
				the PowerNap ReST web services engine kicks in, maps the URI's to a HelloWorldResource
				and responds accordingly.
			</p>
			
			<p>
				The API declaration located in /powernap/examples/hello_world/HelloWorld has, in the URI
				for the first mapping, described a URI variable called {textToSpeak}.  You can change the 
				value of this variable by modifying <strong>hello</strong> in the URI.
			</p>
			
			<p>
				Currently, the engine is set to reload on each request - if you would like to see this
				examle with greater performance, open up the /powernap/examples/hello_world/api.cfm file
				and change the "reload" attribute to "false".
			</p>
			
			<p>
				<strong>Welcome to our World...</strong>
				<ul>
					<li><a href="api.cfm/hello/world.html">/hello/world.html</a></li>
					<li><a href="api.cfm/hello/world.xml">/hello/world.xml</a></li>
					<li><a href="api.cfm/hello/world.pdf">/hello/world.pdf</a></li>
					<li><a href="api.cfm/hello/world.txt">/hello/world.txt</a></li>
					<li><a href="api.cfm/hello/world.say">/hello/world.say (custom format)</a></li>
				</ul>
				
				<strong>
					.json Example Made Possible by CFJSON: http://www.epiphantastic.com/cfjson/downloads.php.
				</strong>
				<ul>
					<li><a href="api.cfm/hello/world.json">/hello/world.json</a></li>
				</ul>
			</p>
			
			<p>
				<strong>ColdSpring Example</strong><br /><br />
				In this example, the application Resource, Representation and event a domain model object
				(and all dependencies) are being managed by ColdSpring.<br /><br />
				
				For more information view the api.cfm file (with the endpoints configuration) as well as
				the "coldWorld" declared Resource in HelloWorldAPI.<br /><br />
				
				<strong>You must have ColdSpring installed within your CF root in order
				for this example to work properly.</strong>
				<ul>
					<li><a href="api.cfm/hello/cold/world">/hello/cold/world</a></li>
					<li><a href="api.cfm/hello/cold/world.xml">/hello/cold/world.xml</a></li>
				</ul>
			</p>
			
			<p>
				<strong>HTTP Basic Authentication Example</strong><br /><br />
				In the following example, HTTP Basic Authentication has been implemented
				to protect access to the declared resource.<br /><br />
				
				<strong>To access this resource;</strong><br />
				Username: username<br />
				Password: password<br /><br />
				<ul>
					<li><a href="api.cfm/hello/protected/world">/hello/protected/world</a></li>
				</ul>
				For more information, view the HelloWorldAPI.cfc component to see how the 
				"protectedWorld" resource was configured.
			</p>

		</div>
		
	</body>
</html>