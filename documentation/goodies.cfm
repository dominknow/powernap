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

			<h1>Other Goodies</h1>
			
			<ul>
				<li><a href="#simplerepresentation">'simpleRepresentation()' Short-Cut</a></li>
				<li><a href="#user-defined_formats">User-Defined Formats and Custom extensions</a></li>
				<li><a href="#form_post_and_query_string">Handling Form Post and Query String Variables</a></li>
				<li><a href="#automatic_argument_conversion">Automatic JSON/XML -&gt; ArgumentCollection conversion</a></li>
				<li><a href="#tunneling_with_post">Tunneling PUT/DELETE requests via POST</a></li>
				<li><a href="#jsonp_hack">Supporting JSONP Callback Wrapper</a></li>
			</ul>
			
			<a name="simplerepresentation"></a>
			<h3>'simpleRepresentation()' Short-Cut</h3>
			
			<p>
				While developing your ReSTful web services, you're likely to come across a scenario when
				creating a new Representation component is a bit of a hassle - especially if you simply want to return 
				an HTTP status code without content to the requestor, OR return a very small amount of content that
				should only be represented one way (not in multiple formats).
			</p>
			
			<p>
				This is where the SipmleRepresentation comes in.  If your Resource Component extends powernap.core.Resource,
				then you have access to the convenience method 'simpleRepresentation()'.  this will return an instance
				of a SimpleRepresentation object.  The purpose of the SimpleRepresentation type is to allow you to return a plain-text representation with little or no content.  For instance;
			</p>
			
			<pre>&lt;cfreturn simpleRepresentation().withContent("") /&gt;</pre>
			
			<p>
				this will return an HTTP status of 200 without any content.  This is particularly useful in scenarios
				where you have performed an operation in your resource (perhaps an update via "PUT") and you only want
				to return an HTTP status.  Similarly, you can return a small amount of plain-text data;
			</p>
			
			<pre>&lt;cfreturn simpleRepresentation().withContent("id is: 10") /&gt;</pre>
			
			<p>
				Or with a different HTTP status - perhaps representing a problem with the requested operation;
			</p>
			
			<pre>&lt;cfreturn simpleRepresentation().withContent("").withStatus(405) /&gt;</pre>
			
			<a name="user-defined_formats"></a>
			<h3>User-Defined Formats and Custom extensions</h3>
			
			<p>
				PowerNap supports the creation of custom formats / extensions (e.g., myresource.bleh).  You can accomplish this
				by declaring the custom format in your configuration component (see<a href="steps_to_nap_1.cfm">step 1</a>)
				as follows;
			</p>
			
			<pre>&lt;cfset format().withExtension(".bleh").willReturn("text/plain").calls("getAsBLEH") /&gt;</pre>
			
			<p>
				<strong>Declaration Break-Down;</strong>
				<ul>
					<li>.withExtension(); fairly self-explanatory - provide your custom extension here, prefixed with a period ".".</li>
					<li>.willReturn(); This method accepts an argument representing the http content type 
						that will be returned in the response when a resource is requested in format .bleh.  
						This can be any string you like, however it's important to understand that whatever 
						client may be requesting a .bleh formatted resource, will need to understand how to 
						handle the http content type that you provide in this declaration.</li>
					<li>calls(); The argument passed to this method is the name of the target method that 
						will be called on the representation of the resource that was requested - this is 
						discussed in greater detail below.</li>
				</ul>
			</p>
			
			<p>
				Now your API is half-way there to understanding how to handle requests for resources with an extension of ".bleh".
			</p>
			
			<p>
				The second piece of this puzzle is to ensure that any Resource you need represented in a 
				format of .bleh, has an associated representation that implements the "getAsBLEH" method.  
				It is there that you write the implementation of the format.  When /myresource.bleh is 
				called, the "getAsBLEH" method defined in the representation is expected to return 
				information (that the resource provided) to the client in accordance with your custom format 
				(which of course, is entirely up to you!).
			</p>
			
			<p>
				The hello_world example api has a custom format with a ".say" extension defined.  
				Go ahead and review that implementation for more information.
			</p>
			
			<a name="form_post_and_query_string"></a>
			<h3>Handling Form Post and Query String Variables</h3>
			
			<p>
				Another common occurrence that you're sure to encounter is having to allow your Resources to 
				accept and handle query-string and/or form-post parameters.  This is as simple as ensuring your 
				target resource has provided an argument to account for those variables.
			</p>
			
			<p>
				For instance, if you have a resource that will be looking for a url parameter named "test" 
				- the URI and query-string combination would look something like this;
			</p>
			
			<pre>/myresource/123?test=hello</pre>
			
			<p>
				To get a handle on the value of "test", The corresponding resource and target method to 
				which this URI was mapped will simply have to define an argument with a name of "test" as 
				follows;
			</p>
			
			<pre>&lt;cfargument name="test" type="string" required="true" /&gt;</pre>
			
			<p>Of course, both the values of both the "type" and "required" attributes of the argument are entirely up to you to define.</p>
			
			<p>This same method can be used to capture form-post variables as well.</p>
			
			<p>
				<strong>Caveat;</strong>
				<ul>
					<li>Do not configure URI variables with the same name as expected URL or form-post 
						parameters OR define form-post parameters with the same name as URL parameters 
						(for the same resource method) - one will overwrite the other and you're likely 
						to get unexpected results.</li>
				</ul>
			</p>


			<a name="automatic_argument_conversion"></a>
			<h3>Automatic JSON/XML -&gt; ArgumentCollection conversion</h3>
			
			<p>
				One of the things that PowerNap tries to do for you is abstract the details of the request handling
				so you can use normal ColdFusion code to process requests.  In your Resources, URL and FORM
				variables are converted to arguments like you would expect in any other CFC.
			</p>
			
			<p>
				For POST, PUT and DELETE operations which expect to have a representation of a resource 
				(commonly provided in XML or JSON), PowerNap will automatically convert those representations
				into an argument collection for your Resource CFC.  For example, if the BODY of an HTTP PUT 
				request contained the following JSON:
			</p>
			
			<pre>{ name: "PowerNap", version: "0.8.5", authors: ['Joe Blow', 'Don Juan']}</pre>
			
			<p>
				Into the following arguments:
			</p>
			
			<ul>
				<li>arguments.name = "PowerNap"</li>
				<li>arguments.version = "0.8.5"</li>
				<li>arguments.authors = array with two elements, "Joe Blow" and "Don Juan"</li>
			</ul>
			
			<p>
				We use a built-in conversion library to perform the conversions to and from XML/JSON
				and ColdFusion objects.  The idea is that you work with values instead of spending your 
				time parsing XML or JSON for data.
			</p>

			<p>
				<strong>Caveat;</strong>
				<ul>
					<li>It is important that you do not use attributes in your XML!  While this is a
						nice way of formatting XML, it prevents auto-conversion to formats that do not
						have an "attributes" concept, such as JSON.  While it is possible in some cases
						to still perform an automatic conversion, the use of the slightly more verbose
						node format will make your representations MUCH easier to encode and decode across
						formats.
						</li>
				</ul>
			</p>

			<a name="tunneling_with_post"></a>
			<h3>Tunneling PUT/DELETE requests via POST</h3>
			
			<p>
				While ReSTful APIs require the use of other HTTP verbs like PUT and DELETE, not all consuming libraries
				have support for these two methods.  PowerNap allows you to provide a special URL parameter that will override
				the actual HTTP method for just such an occasion.  Simple specify the <strong>_method</strong> parameter
				in your URL to any POST operation and the request will be handled as though it was originally
				sent in that manner:
			</p>

			<pre>POST /myresource/123?_method=PUT</pre>

			<p>
				You will still need to deliver the representation as the body of the POST request.
			</p>


			<a name="jsonp_hack"></a>
			<h3>Supporting JSONP Callback Wrapper</h3>
			
			<p>
				Browsers restrict cross-domain URL access from Javascript but there are ways around it by using
				JSONP as implemented by jQuery, Dojo and others.  The catch is that your server-side must implement
				a wrapper around your JSON response to take advantage of this technique.  Ray Cambden explains it 
				in <a href="http://www.coldfusionjedi.com/index.cfm/2009/3/11/Writing-a-JSONP-service-in-ColdFusion">ColdFusion terms pretty well</a>.
			</p>
			<p>
				We looked at how to properly encapsulate and support this in PowerNap and decided, for now, that a 
				dirty hack for a one-off edge case that worked OK was acceptable.  So here it is in all of its glory
				as implemented by Brian Ghidinelli (<a href="http://www.ghidinelli.com">http://www.ghidinelli.com</a>).
				Assuming you wanted to name your URL parameter "myCallback", you would have the following in your representation:
			</p>
			
<pre>
&lt;cffunction name="getAsJSONP" access="public" returntype="string"&gt;
	&lt;cfif isDefined("myCallback")&gt;
		&lt;cfreturn "#myCallback#(" & getAsJSON(arguments[1]) & ")" /&gt;
	&lt;cfelse&gt;
		&lt;cfreturn "callbackMethodUndefinedSeeDocumentation(" & getAsJSON(arguments[1]) & ")" /&gt;
	&lt;/cfif&gt;
&lt;/cffunction&gt;
</pre>
				
			<p>
				This could be made smarter in several ways, like explicitly checking the URL
				or FORM scopes, but it doesn't particularly matter.  If you wanted your
				parameter to be "c" instead of "myCallback", simply change the check for "c".  The
				defacto standard seems to be "callback" or "jsoncallback", the latter probably
				being more unique and unlikely to collide with a real argument.
			</p>

		</div>

	</body>
</html>