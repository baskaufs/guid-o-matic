xquery version "3.1";
(: part of Guid-O-Matic 2.0 https://github.com/baskaufs/guid-o-matic . You are welcome to reuse or hack in any way :)

module namespace propvalue = 'http://bioimages.vanderbilt.edu/xqm/propvalue';

(: Note: copied this function from http://www.xqueryfunctions.com/xq/functx_chars.html :)
declare function propvalue:chars
  ( $arg as xs:string? )  as xs:string* {

   for $ch in string-to-codepoints($arg)
   return codepoints-to-string($ch)
 } ;

declare function propvalue:escape-bad-characters($string,$serialization)
{
switch ($serialization)
    case "json"
    case "turtle" 
       return fn:replace(
                       fn:replace($string,'\\','\\\\')
                       ,'"','\\"')
              
    case "xml"
       return propvalue:escape-less-than(
                       fn:replace($string,'&amp;','&amp;amp;')
                      )
    default return $string
};

declare function propvalue:escape-less-than($string)
{
string-join(
for $char in propvalue:chars($string)
return 
  if ($char = '<') then
     ``[&lt;]``
  else
     $char
 )
};

declare function propvalue:expand-iri($abbreviated,$namespaces)
{
  (: if the passed URI is already expanded as an HTTP IRI or a URN, the function does nothing :)
if (fn:substring($abbreviated,1,8)="https://")
then 
  $abbreviated
else
  if (fn:substring($abbreviated,1,7)="http://")
  then 
    $abbreviated
  else
    if (fn:substring($abbreviated,1,4)="urn:")
    then 
      $abbreviated
    else
      let $curie := substring-before($abbreviated,":")
      let $localName := substring-after($abbreviated,":")
      for $namespace in $namespaces
      where $namespace/curie/text()=$curie
      return concat($namespace/value/text(),$localName)
};

declare function propvalue:wrap-turtle-iri($iri)
{
  (: check whether an unabbreviated HTTP IRI or URN. If so, wrap in lt/gt brackets.  If not, do nothing :)
  if (fn:substring($iri,1,8)="https://")
  then 
    concat('<',$iri,">")
  else
    if (fn:substring($iri,1,7)="http://")
    then 
      concat('<',$iri,">")
    else
      if (fn:substring($iri,1,4)="urn:")
      then 
        concat('<',$iri,">")
      else
        $iri
};

declare function propvalue:subject($iri,$serialization)
{
  (: Note: the subject iri begins the description, so the returned string includes characters necessary to open the container.  In turtle and xml, blank nodes have different formats than full URIs :)
switch ($serialization)
  case "turtle" return 
       if (fn:substring($iri,1,2)="_:") 
       then concat($iri,"&#10;") 
       else concat("<",$iri,">&#10;")
  case "xml" return 
        if (fn:substring($iri,1,2)="_:") 
       then concat('<rdf:Description rdf:nodeID="',concat("U",fn:substring($iri,3,fn:string-length($iri)-2)),'">&#10;') 
       else concat('<rdf:Description rdf:about="',$iri,'">&#10;')
  case "json" return concat("{&#10;",'"@id": "',$iri,'",&#10;')
  default return ""
};

declare function propvalue:plain-literal($predicate,$dirtyString,$serialization)
{
let $string := propvalue:escape-bad-characters($dirtyString,$serialization)
return switch ($serialization)
  case "turtle" return concat("     ",$predicate,' "',$string,'";&#10;')
  case "xml" return concat("     <",$predicate,'>',$string,'</',$predicate,'>&#10;')
  case "json" return concat('"',$predicate,'": "',$string,'",&#10;')
  default return ""
};

declare function propvalue:datatyped-literal($predicate,$dirtyString,$datatype,$serialization,$namespaces)
{
let $string := propvalue:escape-bad-characters($dirtyString,$serialization)
return switch ($serialization)
  case "turtle" return concat("     ",$predicate,' "',$string,'"^^',propvalue:wrap-turtle-iri($datatype),";&#10;")
  case "xml" return concat("     <",$predicate,' rdf:datatype="',propvalue:expand-iri($datatype,$namespaces),'">',$string,'</',$predicate,'>&#10;')
  case "json" return concat('"',$predicate,'": {"@type": "',$datatype,'","@value": "',$string,'"},&#10;')
  default return ""
};

declare function propvalue:language-tagged-literal($predicate,$dirtyString,$lang,$serialization)
{
let $string := propvalue:escape-bad-characters($dirtyString,$serialization)
return switch ($serialization)
  case "turtle" return concat("     ",$predicate,' "',$string,'"@',$lang,";&#10;")
  case "xml" return concat("     <",$predicate,' xml:lang="',$lang,'">',$string,'</',$predicate,'>&#10;')
  case "json" return concat('"',$predicate,'": {"@language": "',$lang,'","@value": "',$string,'"},&#10;')
  default return ""
};

declare function propvalue:iri($predicate,$string,$serialization,$namespaces)
{
switch ($serialization)
  case "turtle" return concat("     ",$predicate,' ',propvalue:wrap-turtle-iri($string),";&#10;") 
  case "xml" return 
       if (fn:substring($string,1,2)="_:") 
       then concat("     <",$predicate,' rdf:nodeID="',concat("U",fn:substring($string,3,fn:string-length($string)-2)),'"/>&#10;') 
       else concat("     <",$predicate,' rdf:resource="',propvalue:expand-iri($string,$namespaces),'"/>&#10;')
  case "json" return concat('"',$predicate,'": {"@id": "',$string,'"},&#10;')
  default return ""
};

declare function propvalue:type($type,$serialization,$namespaces)
{
  (: Note: type is the last property listed, so the returned string includes characters necessary to close the container :)
  (: There also is no trailing separator (if the serialization has one) :)
switch ($serialization)
  case "turtle" return concat("     a ",propvalue:wrap-turtle-iri($type),".&#10;&#10;")
  case "xml" return concat('     <rdf:type rdf:resource="',propvalue:expand-iri($type,$namespaces),'"/>&#10;','</rdf:Description>&#10;&#10;')
  case "json" return concat('"@type": "',$type,'"&#10;',"}&#10;")
  default return ""
};

declare function propvalue:media-type($serialization)
{
switch ($serialization)
  case "turtle" return "text/turtle"
  case "xml" return "application/rdf+xml"
  case "json" return "application/json"
  default return ""
};

declare function propvalue:extension($serialization)
{
switch ($serialization)
  case "turtle" return ".ttl"
  case "xml" return ".rdf"
  case "json" return ".json"
  default return ""
};

