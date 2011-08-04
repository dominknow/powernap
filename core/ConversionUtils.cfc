<cfcomponent displayname="Misc XML/JSON Functions" hint="Various methods for transforming xml,json,cf objects">

	<!--- --------------------------------------------------------------- 
		@copyright: 	(c) 2008 Websolete.com
		
		@author:		Kevin Miller
		@date:		10/24/2008
		@file:		packetUtilities.cfc 
		
		@description: 	
	   		utility functions for transforming data between xml, json and native cf objects
	------------------------------------------------------------------ --->
	<!--- 	Date: 1/14/2009  Usage: init --->
	<cffunction name="init" output="false" access="public" returntype="any">
		<cfreturn this />	
	</cffunction>
	
	
	<cffunction name="xmlObjToStructSimple" hint="takes an xml object and converts it to native cf struct; no attributes are handled, only simple node based values" access="public" output="no" returntype="struct">
		<cfargument name="theXML" type="any" required="yes">
		
			<cfscript>
			 	var x = structnew(); 
				var i = ""; 
				
				if(isxml(arguments.theXML)) { 
					if(not structisempty(arguments.theXML)) { 
						for(i in arguments.theXML) { 
							if(not structisempty(arguments.theXML[i])) { 
								x[i] = xmlObjToStructSimple(duplicate(arguments.theXML[i])); 
							}
							else {
								x[i] = arguments.theXML[i].xmltext; 
							}
						}
					}
				}
				return x;
			 </cfscript>
	
	</cffunction>
	
	<cffunction name="xmlObjToStructDeep" access="public" hint="takes an xml object and converts to a native cf struct, including attributes" output="false" returntype="struct">
		<cfargument name="theXML" type="any" required="yes">
		
			<cfscript>
			 	var x = structnew(); 
				var y = ""; 
				var i = ""; 
				var k = ""; 
				
				if(isxml(arguments.theXML)) { 
					if(not structisempty(arguments.theXML)) {  
						for (k in arguments.theXML) {  
							x[arguments.theXML[k].xmlName] = structnew(); 
							
							// has attributes
							if(not structisempty(arguments.theXML[k].xmlAttributes)) {  
								for (i in arguments.theXML[k].xmlAttributes) { 
									x[arguments.theXML[k].xmlName][i] = arguments.theXML[k].xmlAttributes[i];
								}
							} 
							// has children
							if(not arrayisempty(arguments.theXML[k].xmlChildren)) { 
								for (y = 1; y lte arraylen(arguments.theXML[k].xmlChildren); y = y + 1) { 
									x[arguments.theXML[k].xmlName][arguments.theXML[k].xmlChildren[y].xmlName] = xmlObjToStructDeep(duplicate(arguments.theXML[k].xmlChildren[y]));
								}
							} 
							// simple value
							else { 
								x[arguments.theXML[k].xmlName].value = arguments.theXML[k].xmlText; 
							} 
						} 
					} 
					else if (structcount(arguments.theXML.xmlAttributes)) {  
						for (i in arguments.theXML.xmlAttributes) { 
							x[i] = arguments.theXML.xmlAttributes[i];
						} 
						x.value = arguments.theXML.xmlText; 
					} 
					else { 
						x.value = arguments.theXML.xmlText; 
					}
				}
				return x; 
		</cfscript>
		
	</cffunction>
	
	<cffunction name="xmlToJSON" hint="Alias for xmlToJSONSimple" access="public">
		<cfreturn xmlToJSONSimple(argumentCollection = arguments) />
	</cffunction>
	
	<cffunction name="xmlToJSONSimple" hint="takes an xml string and converts it to JSON, ignores xml attributes" access="public" output="no" returntype="string">
		<cfargument name="theXML" type="string" required="yes">
		
			<cfset var local = structnew()>
			
			<cfset local.x = xmlparse(trim(arguments.theXML))>
			<cfset local.obj = xmlToCF(local.x)>
			
			<cfreturn serializeJSON(local.obj)>
	
	</cffunction>
	
	<cffunction name="xmlToJSONDeep" hint="takes an xml string and converts it to JSON, including xml attributes" access="public" output="no" returntype="string">
		<cfargument name="theXML" type="string" required="yes">
		
			<cfset var local = structnew()>
			
			<cfset local.x = xmlparse(trim(arguments.theXML))>
			<cfset local.obj = xmlObjToStructDeep(local.x)>
			
			<cfreturn serializeJSON(local.obj)>
	
	</cffunction>
	
	<cffunction name="jsonToXML" hint="takes a json string and converts it to a xml object" access="public" output="no" returntype="any">
		<cfargument name="theJSON" type="string" required="yes">
		
			<cfset var local = structnew()>
			
			<cfset local.j = trim(arguments.theJSON)>
			<cfset local.obj = deserializeJSON(local.j)>
			
			<cfreturn cfToXML(object=local.obj)>
	
	</cffunction>
	
	<cffunction name="jsonToCF" hint="takes a json string and converts it to an equivalent CF object" access="public" output="no" returntype="any">
		<cfargument name="theJSON" type="string" required="yes">

		<!--- BDG: could optionally swap this out for the json.cfc, but native is presumably faster --->
		<cfreturn deserializeJSON(arguments.theJSON)>		
	</cffunction>	
	
	<cffunction name="cfToXML" hint="takes a complex cf object and converts it to an xml document string" access="public" output="no" returntype="any">
		<cfargument name="object" type="any" required="yes">
		<cfargument name="root" type="string" required="no" default=""><!--- root is not required, if specified, it is created --->
		<cfargument name="forceCase" type="string" required="no" default="natural"><!--- lower, upper, natural --->
		
			<cfscript>
				var x = ""; 
				var i = ""; 
				var c = ""; 
				var col = ""; 
				var recursing = false; 
				var parent = "data"; // used for naming array keys
				
				if(structkeyexists(arguments,"recursing") and arguments.recursing) { recursing = true; }
				if(structkeyexists(arguments,"parentnode") and len(arguments.parentnode)) { parent = arguments.parentnode; }
						
				if(not issimplevalue(arguments.object)) { 				
					if(isstruct(arguments.object)) { 					
						for(i in arguments.object) { 					
							if(arguments.forceCase eq "lower") { i = lcase(i); }
							else if(arguments.forceCase eq "upper") { i = ucase(i); }
						
							if(not issimplevalue(arguments.object[i])) { 
								x = x & "<#i#>" & cfToXML(object=duplicate(arguments.object[i]),root=arguments.root,forcecase=arguments.forcecase,recursing=true,parentnode=i) & "</#i#>"; 
							}
							else { 					
								x = x & "<#i#>#arguments.object[i]#</#i#>"; 								
							}
						}					
					}
					else if(isarray(arguments.object)) { 			
						if(right(parent,1) eq "s") { parent = left(parent,len(parent)-1); }						
						if(arguments.forceCase eq "lower") { parent = lcase(parent); }
						else if(arguments.forceCase eq "upper") { parent = ucase(parent); }			
					
						for(i = 1; i lte arraylen(arguments.object); i = i + 1) { 						
							if(not issimplevalue(arguments.object[i])) { 
								x = x & "<#parent#-item>" & cfToXML(object=duplicate(arguments.object[i]),root=arguments.root,forcecase=arguments.forcecase,recursing=true,parentnode=i) & "</#parent#-item>"; 
							}
							else { 					
								x = x & "<#parent#-item>#arguments.object[i]#</#parent#-item>"; 	
							}							
						}					
					}
					else if(isquery(arguments.object)) { 			
						if(right(parent,1) eq "s") { parent = left(parent,len(parent)-1); }						
						if(arguments.forceCase eq "lower") { parent = lcase(parent); }
						else if(arguments.forceCase eq "upper") { parent = ucase(parent); }			
								
						for(i = 1; i lte arguments.object.recordcount; i = i + 1) { 							
							x = x & "<#parent#-row-#i#>";
						
							for(c=1; c lte listlen(arguments.object.columnlist); c = c + 1) { 							
								col = listgetat(arguments.object.columnlist,c); 
								if(arguments.forceCase eq "lower") { col = lcase(col); }
								else if(arguments.forceCase eq "upper") { col = ucase(col); }			
								
								if(isbinary(arguments.object[col][i])) { 
									x = x & "<#col#>#toBase64(arguments.object[col][i])#</#col#>"; 	
								}
								else { 	
									x = x & "<#col#>#arguments.object[col][i]#</#col#>"; 	
								}							
							}							
							x = x & "</#parent#-row-#i#>";							
						}
					}
				}
				
				if(not recursing and len(arguments.root)) { 
					if(arguments.forceCase eq "lower") { arguments.root = lcase(arguments.root); } 
					else if(arguments.forceCase eq "upper") { arguments.root = ucase(arguments.root); } 
					x = "<#arguments.root#>" & x & "</#arguments.root#>"; 
				}
				
				return x;			
			 </cfscript>
	
	</cffunction>
	
	<cffunction name="xmlToCF" hint="Takes an XML object and converts it into an equivalent CF object" access="public" output="no" returntype="any">
	<cfargument name="thexml" type="XML" required="Yes">
	
	<!--- Only supports use of attributes if the element is unique to the parent node --->
	 
	 <cfset var x = structnew()>
	 <cfset var i = "">
	 <cfset var a = "">
	 <cfset var n = "">
	 
	<cfscript>				
		if(len(structkeylist(thexml))) { 
			for(i in thexml) { 
				if (arraylen(thexml[i]) gt 1) { 
					x = arraynew(1); 
					for(n = 1; n lte arraylen(thexml[i]); n = n + 1) {  
						x[n] = xmlToCF(duplicate(thexml[i][n]));
					}
				}
				else if(len(structkeylist(thexml[i]))) { 
					x[i] = xmlToCF(duplicate(thexml[i])); 
				} 
				else { 
					if(len(structkeylist(thexml[i]['xmlattributes']))) { 
						x[i] = structnew(); 
						x[i].value = thexml[i].xmltext; 
						for(a in thexml[i].xmlattributes) { 
							x[i][a] = thexml[i]['xmlattributes'][a]; 
						}
					}
					else { 
						x[i] = thexml[i].xmltext; 
					}
				}
			}
		}
		return x;
	</cfscript>
	
	</cffunction>
	
</cfcomponent>