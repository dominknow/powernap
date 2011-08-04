PowerNap
ColdFusion ReSTful web services made easy.

This software is distributed under the Apache 2.0 License.  For
more information see; http://www.apache.org/licenses/LICENSE-2.0

In order for PowerNap to function correctly, you must install 
it using one of the following three methods:

1. Extract the contents of this package so that the "powernap" 
   directory (containing the PowerNap library) is located directly 
   within your ColdFusion root directory: {cfroot}/powernap
2. Create a system mapping for "/powernap" to your PowerNap folder
3. If you have ColdFusion 8, you can create a per-application 
   mapping in your Application.cfc:
   <cfset this.mappings["/powernap"] = expandPath("/some/folder/to/powernap") />
   
If you used technique #1, examples are located in:

   /powernap/examples

And of course, documentation;

   /powernap/documentation


********** GIVING CREDIT WHERE CREDIT IS DUE *************
.json format and getAsJSON representation functionality
has been made possible by CFJSON: http://www.epiphantastic.com/cfjson/examples.php

ConversionUtils.cfc provided by Kevin J. Miller (http://www.websolete.com/)

Qustions / Comments, please feel free to
shoot me an email at; bcarr14@gmail.com