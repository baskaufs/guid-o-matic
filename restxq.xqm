(: this module needs to be put in the webapp folder of your BaseX installation.  On my computer it's at c:\Program Files (x86)\BaseX\webapp\ :)

(: to test, send an HTTP GET to localhost:8984/Longxingsi using cURL, Postman, etc. :)

module namespace page = 'http://basex.org/modules/web-page';
import module namespace serialize = 'http://bioimages.vanderbilt.edu/xqm/serialize' at 'c:/github/guid-o-matic/serialize.xqm';

(: Functions used to set media type-specific values :)
declare function page:determine-extension($header)
{
  if (contains(string-join($header),"application/rdf+xml"))
  then "rdf"
  else
      if (contains(string-join($header),"text/turtle"))
      then "ttl"
      else 
          if (contains(string-join($header),"application/ld+json") or contains(string-join($header),"application/json"))
          then "json"
          else "htm" 
};

declare function page:determine-media-type($extension)
{
  switch($extension)
    case "rdf" return "application/rdf+xml"
    case "ttl" return "text/turtle"
    case "json" return "application/ld+json"
    default return "text/html"
};

declare function page:determine-type-flag($extension)
{
  switch($extension)
    case "rdf" return "xml"
    case "ttl" return "turtle"
    case "json" return "json"
    default return "html"
};

(: Function to return a representation of a resource or all resources :)
declare function page:return-representation($response-media-type,$local-id,$flag,$outtype)
{
if(serialize:find($local-id,"guid-o-matic/","c:/github/"))
then 
  (
  <rest:response>
    <output:serialization-parameters>
      <output:media-type value='{$response-media-type}'/>
    </output:serialization-parameters>
  </rest:response>,
  if ($flag = "html")
  then page:handle-html($local-id)
  else serialize:main($local-id,$flag,"guid-o-matic/","c:/github/",$outtype,"false")
  )
else
  <rest:response>
    <http:response status="404" message="Not found.">
      <http:header name="Content-Language" value="en"/>
      <http:header name="Content-Type" value="text/html; charset=utf-8"/>
    </http:response>
  </rest:response>
};

(: Placeholder function to return a web page :)
declare function page:handle-html($local-id)
{
<html>
    <body>
        <p>Placeholder web page for: {$local-id}</p>
    </body>
</html>  
};

(: Main functions for handling URI patterns :)

(: This is a temporary function for testing the kind of Accept header sent by the client :)
declare
  %rest:path("/header")
  %rest:header-param("Accept","{$acceptHeader}")
  function page:web($acceptHeader)
  {
  <p>{$acceptHeader}</p>
  };

(: This is the main handler function :)
declare
  %rest:path("/{$full-local-id}")
  %rest:header-param("Accept","{$acceptHeader}")
  function page:content-negotiation($acceptHeader,$full-local-id)
  {
    
  let $extension := page:determine-extension($acceptHeader)
  let $response-media-type := page:determine-media-type($extension)
  let $flag := page:determine-type-flag($extension)
  let $outtype := 
      if ($full-local-id = "dump")
      then "dump"
      else "single"

  return

  if ($outtype="dump")
  then 
      (: Handle option to dump the entire dataset.  Doesn't work if text/html is requested. :)
      page:return-representation($response-media-type,$full-local-id,$flag,$outtype)
  else
      (: Handle a request for a single resource :)
      if (contains($full-local-id,"."))
      then
          (: Handle request for specific representation when requested with file extension :)
          let $local-id := substring-before($full-local-id,".")
          let $new-extension := substring-after($full-local-id,".")
          (: When a specific file extension is requested, override the requested content type. :)
          let $new-response-media-type := page:determine-media-type($new-extension)
          let $new-flag := page:determine-type-flag($new-extension)
          return page:return-representation($new-response-media-type,$local-id,$new-flag,$outtype)
      else
          (: Perform "see also" redirect based on requested media type to a specific representation having a file exension :)
          <rest:response>
            <http:response status="303">
              <http:header name="location" value="{ concat($full-local-id,".",$extension) }"/>
            </http:response>
          </rest:response>
  };
