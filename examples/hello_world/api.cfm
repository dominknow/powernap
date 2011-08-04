<cfset setEncoding("url", "UTF-8") />
<cfset setEncoding("form", "UTF-8") />
<cfprocessingdirective pageEncoding="UTF-8" /> 

<cfimport taglib="/powernap/tags/" prefix="powernap" />

<powernap:endpoints 
	name="HelloWorldAPI"
	engine="powernap.examples.hello_world.HelloWorld"
	reload="true"
	debug="true" />
