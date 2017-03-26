(: this module needs to be put in the webapp folder of your BaseX installation.  On my computer it's at c:\Program Files (x86)\BaseX\webapp\ :)

(: to test, send an HTTP GET to localhost:8984/Longxingsi using cURL, Postman, etc. :)

module namespace page = 'http://basex.org/modules/web-page';
import module namespace serialize = 'http://bioimages.vanderbilt.edu/xqm/serialize' at 'https://raw.githubusercontent.com/baskaufs/guid-o-matic/master/serialize.xqm';

(:----------------------------------------------------------------------------------------------:)
(: Main functions for handling URI patterns :)

(: This is a temporary function for testing the kind of Accept header sent by the client :)
declare
  %rest:path("/header")
  %rest:header-param("Accept","{$acceptHeader}")
  function page:web($acceptHeader)
  {
  <p>{$acceptHeader}</p>
  };

(: This is a hacked function to provice an option to dump the entire dataset :)
declare
  %rest:path("/dump")
  %rest:header-param("Accept","{$acceptHeader}")
  function page:dump($acceptHeader)
  {
  let $ext := page:determine-extension($acceptHeader)
  let $extension := 
      if ($ext = "htm")
      then 
          (: If the client is a browser, return Turtle :)
          "ttl"
      else
          (: Otherwise, return the requested media type :)
          $ext    
  let $response-media-type := page:determine-media-type($extension)
  let $flag := page:determine-type-flag($extension)

  return
      (
      <rest:response>
        <output:serialization-parameters>
          <output:media-type value='{$response-media-type}'/>
        </output:serialization-parameters>
      </rest:response>,
      serialize:main-db("",$flag,"dump","false")
      )
  };

(: This is the main handler function :)
declare
  %rest:path("/{$full-local-id}")
  %rest:header-param("Accept","{$acceptHeader}")
  function page:content-negotiation($acceptHeader,$full-local-id)
  {
  if (contains($full-local-id,"."))
  then page:handle-repesentation($acceptHeader,$full-local-id)
  else page:see-also($acceptHeader,$full-local-id)
  };

(:----------------------------------------------------------------------------------------------:)
(: Second-level functions :)

(: Handle request for specific representation when requested with file extension :)
declare function page:handle-repesentation($acceptHeader,$full-local-id)
{
  let $local-id := substring-before($full-local-id,".")
  return
      if(serialize:find-db($local-id))  (: check whether the resource is in the database :)
      then
          let $extension := substring-after($full-local-id,".")
          (: When a specific file extension is requested, override the requested content type. :)
          let $response-media-type := page:determine-media-type($extension)
          let $flag := page:determine-type-flag($extension)
          return page:return-representation($response-media-type,$local-id,$flag)
      else
          page:not-found()  (: respond with 404 if not in database :)
};

(: Function to return a representation of a resource or all resources :)
declare function page:return-representation($response-media-type,$local-id,$flag)
{
  <rest:response>
    <output:serialization-parameters>
      <output:media-type value='{$response-media-type}'/>
    </output:serialization-parameters>
  </rest:response>,
  if ($flag = "html")
  then page:handle-html($local-id)
  else serialize:main-db($local-id,$flag,"single","false")
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

(: 303 See Also redirect to specific representation having file exension, based on requested media type :)
declare function page:see-also($acceptHeader,$full-local-id)
{
  if(serialize:find-db($full-local-id))  (: check whether the resource is in the database :)
  then
      let $extension := page:determine-extension($acceptHeader)
      return
          <rest:response>
            <http:response status="303">
              <http:header name="location" value="{ concat($full-local-id,".",$extension) }"/>
            </http:response>
          </rest:response> 
  else
      page:not-found()  (: respond with 404 if not in database :)
};

(: Function to generate a 404 Not found response :)
declare function page:not-found()
{
  <rest:response>
    <http:response status="404" message="Not found.">
      <http:header name="Content-Language" value="en"/>
      <http:header name="Content-Type" value="text/html; charset=utf-8"/>
    </http:response>
  </rest:response>
};

(:----------------------------------------------------------------------------------------------:)
(: Utility functions to set media type-dependent values :)

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

