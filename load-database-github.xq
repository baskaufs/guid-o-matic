xquery version "3.1";
(: part of Guid-O-Matic 2.0 https://github.com/baskaufs/guid-o-matic . You are welcome to reuse or hack in any way :)

(: It is important that the column headers in linked CSV data files are unique. :)

declare function local:main($repoPath,$repoSubdirectory,$dbaseName,$outputMethod,$password)
{

let $path := "https://raw.githubusercontent.com/"||$repoPath||"master/"||$repoSubdirectory||$dbaseName||"/"

let $constants := local:load-csv-github($path,"constants.csv",",")
let $coreDoc := $constants//coreClassFile/text()
let $coreClassPrefix := substring-before($coreDoc,".")
let $outputDirectory := $constants//outputDirectory/text() 
let $metadataSeparator := $constants//separator/text()

let $columnInfo := local:load-csv-github($path,$coreClassPrefix||'-column-mappings.csv',",")
let $namespaces := local:load-csv-github($path,'namespace.csv',",")
let $classes := local:load-csv-github($path,$coreClassPrefix||'-classes.csv',",")
let $linkedClasses := local:load-csv-github($path,'linked-classes.csv',",")
let $metadata := local:load-csv-github($path,$coreDoc,$metadataSeparator)

let $linkedMetadata :=
      for $class in $linkedClasses
      let $linkedDoc := $class/filename/text()
      let $linkedClassPrefix := substring-before($linkedDoc,".")

      let $classMappingDoc := http:send-request(<http:request method='get' href='{$path||$linkedClassPrefix||"-column-mappings.csv"}'/>)[2]
      let $xmlClassMapping := csv:parse($classMappingDoc, map { 'header' : true(),'separator' : "," })
      let $classClassesDoc := http:send-request(<http:request method='get' href='{$path||$linkedClassPrefix||"-classes.csv"}'/>)[2]
      let $xmlClassClasses := csv:parse($classClassesDoc, map { 'header' : true(),'separator' : "," })
      let $classMetadataDoc := http:send-request(<http:request method='get' href='{$path||$linkedDoc}'/>)[2]
      let $xmlClassMetadata := csv:parse($classMetadataDoc, map { 'header' : true(),'separator' : $metadataSeparator })
      return
        ( 
        <file>{
          $class/link_column,
          $class/link_property,
          $class/suffix1,
          $class/link_characters,
          $class/suffix2,
          $class/class,
          <classes>{
            $xmlClassClasses/csv/record
          }</classes>,
          <mapping>{
            $xmlClassMapping/csv/record
          }</mapping>,
          <metadata>{
            $xmlClassMetadata/csv/record
          }</metadata>
       }</file>
       )
       
return (
    local:output($outputMethod,$outputDirectory,$dbaseName,$password,"constants.xml",<constants>{$constants}</constants>),
    local:output($outputMethod,$outputDirectory,$dbaseName,$password,"column-index.xml",<column-index>{$columnInfo}</column-index>),
    local:output($outputMethod,$outputDirectory,$dbaseName,$password,"namespaces.xml",<namespaces>{$namespaces}</namespaces>),
    local:output($outputMethod,$outputDirectory,$dbaseName,$password,"classes.xml",<base-classes>{$classes}</base-classes>),
    local:output($outputMethod,$outputDirectory,$dbaseName,$password,"linked-classes.xml",<linked-classes>{$linkedClasses}</linked-classes>),
    local:output($outputMethod,$outputDirectory,$dbaseName,$password,"metadata.xml",<metadata>{$metadata}</metadata>),
    local:output($outputMethod,$outputDirectory,$dbaseName,$password,"linked-metadata.xml",<linked-metadata>{$linkedMetadata}</linked-metadata>)
    )
};

declare function local:load-csv-github($path,$file,$separator)
{
let $constantsDoc := http:send-request(<http:request method='get' href='{$path}{$file}'/>)[2]
let $xmlConstants := csv:parse($constantsDoc, map { 'header' : true(),'separator' : $separator })
return $xmlConstants/csv/record
};

declare function local:output($outputMethod,$outputDirectory,$dbaseName,$password,$fileName,$outputXml)
{
  if ($outputMethod="file")
  then 
    local:write-file-local($outputDirectory,$fileName,$outputXml)
  else
    if ($outputMethod="screen")
    then
      $outputXml (: simply output the string to the Result window :)
    else 
      local:write-file-http($outputMethod||$dbaseName||'/',$password,$fileName,$outputXml) (: $outputMethod contains base URI for the REST service for the PUT; the database name gets concatenated after that :)
};

declare function local:write-file-local($outputDirectory,$fileName,$outputXml)
{ 
(: Creates the specified output directory if it doesn't already exist.  Then writes into a file using default UTF-8 encoding :)
file:create-dir($outputDirectory),file:write($outputDirectory||$fileName,$outputXml),
"Completed file write of "||$fileName||" at "||fn:current-dateTime()
};

declare function local:write-file-http($URI,$password,$fileName,$outputXml)
{ 
let $request :=
  <http:request href='{concat($URI,$fileName)}'
    method='put' username='admin' password='{$password}' send-authorization='true'>
      <http:body media-type='application/xml'>
        {$outputXml}
      </http:body>
  </http:request>
return concat($fileName," ",string-join(http:send-request($request)))
};

(:--------------------------------------------------------------------------------------------------:)
(: Here's the main query that makes it go :)

(: 
1st argument is the GitHub username/repo/ path
2nd argument is the sub-path within the GitHub repo that contains the database directories (may be the empty string if the CSV files are in a directory directly below the root directory of the repo)
3rd arugment is the database name as used in restxq.xqm; must also be the subdirectory in which the CSV files are saved, within the sub-path (if any)
4th argument is the output method: "file", "screen", or a URI for HTTP PUT to the BaseX REST API e.g. http://localhost:8984/rest/ or the URI of an installation on the Internet
5th argument is the password for communicating with the BaseX REST API (ignore if not using HTTP)

For example, the default values below are for CSV files in this repo: 
https://github.com/HeardLibrary/semantic-web/tree/master/2016-fall/tang-song/

When the data are written to files, they will be written to the directory specified in the constants.csv file.

When the data are written to a BaseX database, the database name will be "tang-song" if the default values below are used.  Note: the database must already exist.  If it doesn't, create it by HTTP PUT to the database URI, e.g. 
http://localhost:8984/rest/tang-song
:)
local:main("HeardLibrary/semantic-web/","2016-fall/","tang-song","screen","pwd")
