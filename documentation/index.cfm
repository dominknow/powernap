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
		<h1>Let's Get Lazy.</h1>
		<p>
			That's right, ReSTful web services are in.  Simple, direct, easy to understand and even
			easier to work with.  Enough talk - let's get down to business.
		</p>
		
		<p>
			<h3>What is PowerNap?</h3>
			<ul>
				<li>
					<strong>A ReSTful web services engine</strong> written in ColdFusion who's sole purpose is to provide
					you an easy to implement mechanism to deploy ReSTful web service endpoints.
				</li>
				<li>
					A simple and direct way to map URI's to web Resources - returning a Representation of that Resource based
					off of the requested format.  Particularly suited for lightweight HTTP communication in XML or JSON formats.
				</li>
			</ul>
		</p>
		
		<p>
			<h3>What PowerNap is NOT</h3>
			<ul>
				<li>
					<strong>An MVC Framework</strong>.  While some aspects may feel familiar in this regard, PowerNap IS NOT an MVC Framework.
				</li>
			</ul>
		</p>
		
		<p>
			<h3>Requirements</h3>
			<ul>
				<li>ColdFusion version 8</li>
				<li>A basic understanding of web services and ReST.</li>
				<li>A Web Server properly configured to accept path-info.</li>
			</ul>
		</p>
		
		<p>
			<h3>Resources</h3>
			Poster, a firefox plugin is a must-have for any developer working with ReST;<br />
			<a href="https://addons.mozilla.org/en-US/firefox/addon/2691">https://addons.mozilla.org/en-US/firefox/addon/2691</a>
			
			<br /><br />
			Check out these links for more information on ReST;
			
			<ul>
				<li><a href="http://en.wikipedia.org/wiki/REST">http://en.wikipedia.org/wiki/REST</a></li>
				<li><a href="http://www.petefreitag.com/item/431.cfm">http://www.petefreitag.com/item/431.cfm</a></li>
			</ul>
		</p>
		</div>
		
	</body>
</html>