xquery version "3.1";
(: part of Guid-O-Matic 2.0 https://github.com/baskaufs/guid-o-matic . You are welcome to reuse or hack in any way :)

module namespace serialize = 'http://bioimages.vanderbilt.edu/xqm/serialize';

(: In order to avoid hard-coding file locations, the propvalue module is imported from GitHub.  It is unlikely that you will need to modify any of the functions it contains, but if you do, you will need to substitute after the "at" keyword the path to the local directory where you put the propvalue.xqm file :)
import module namespace propvalue = 'http://bioimages.vanderbilt.edu/xqm/propvalue' at 'https://raw.githubusercontent.com/baskaufs/guid-o-matic/master/propvalue.xqm'; 

(: These two functions copied from FunctX http://www.xqueryfunctions.com/ :)

declare function serialize:substring-after-last
  ( $arg as xs:string? ,
    $delim as xs:string )  as xs:string {

   replace ($arg,concat('^.*',serialize:escape-for-regex($delim)),'')
 } ;
 
 declare function serialize:escape-for-regex
  ( $arg as xs:string? )  as xs:string {

   replace($arg,
           '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
 } ;
(:--------------------------------------------------------------------------------------------------:)

declare function serialize:main-db($id,$serialization,$singleOrDump,$db)
{
(: This database version is intended to be used with the restxq-db web service.  So output to a file is always
disabled.  Instead of using the last parameter to pass the save file path, in this function, it's used to specify
the database to be used in the function call. :)
(: let $db := "tang-song" :)
let $outputToFile := "false"

let $constants := fn:collection($db)//constants/record
let $domainRoot := $constants//domainRoot/text()
let $outputDirectory := $constants//outputDirectory/text()
let $baseIriColumn := $constants//baseIriColumn/text()
let $modifiedColumn := $constants//modifiedColumn/text()
let $outFileNameAfter := $constants//outFileNameAfter/text()

let $columnInfo := fn:collection($db)//column-index/record
let $namespaces := fn:collection($db)//namespaces/record
let $classes := fn:collection($db)//base-classes/record
let $linkedClasses := fn:collection($db)//linked-classes/record
let $metadata := fn:collection($db)/metadata/record
let $linkedMetadata := fn:collection($db)//linked-metadata/file
  
(: The main function returns a single string formed by concatenating all of the assembled pieces of the document :)
return 
  if ($outputToFile="true")
  then
    (: Creates the output directory specified in the constants.csv file if it doesn't already exist.  Then writes into a file having the name passed via the $id parameter concatenated with an appropriate file extension. uses default UTF-8 encoding :)
    (file:create-dir($outputDirectory),
    
    (: If the $id is a full IRI or long string, use only the part after the delimiter in $outFileNameAfter as the file name.  Otherwise, use the entire value of $id as the file name:) 
    if ($outFileNameAfter) 
    then file:write-text($outputDirectory||serialize:substring-after-last($id, $outFileNameAfter)||propvalue:extension($serialization),serialize:generate-entire-document($id,$linkedMetadata,$metadata,$domainRoot,$classes,$columnInfo,$serialization,$namespaces,$constants,$singleOrDump,$baseIriColumn,$modifiedColumn))
    else file:write-text($outputDirectory||$id||propvalue:extension($serialization),serialize:generate-entire-document($id,$linkedMetadata,$metadata,$domainRoot,$classes,$columnInfo,$serialization,$namespaces,$constants,$singleOrDump,$baseIriColumn,$modifiedColumn))
    ,
    
    (: put this in the Result window so that the user can tell that something happened :)
    "Completed file write of "||$id||propvalue:extension($serialization)||" at "||fn:current-dateTime()
    )
  else
    (: simply output the string to the Result window :)
    serialize:generate-entire-document($id,$linkedMetadata,$metadata,$domainRoot,$classes,$columnInfo,$serialization,$namespaces,$constants,$singleOrDump,$baseIriColumn,$modifiedColumn)
};
(:--------------------------------------------------------------------------------------------------:)

declare function serialize:main($id,$serialization,$repoPath,$pcRepoLocation,$singleOrDump,$outputToFile)
{

(: This is an attempt to allow the necessary CSV files to load on any platform without hard-coding any paths here.  I know it works for PCs, but am not sure how consistently it works on non-PCs :)
let $localFilesFolderUnix := 
(:  if (fn:substring(file:current-dir(),1,2) = "C:") 
  then :)
    (: the computer is a PC with a C: drive, the path specified in the function arguments are substituted :)
    "file:///"||$pcRepoLocation||$repoPath
(:  else
     it's a Mac with the query running from a repo located at the default under the user directory
    file:current-dir() || "/Repositories/"||$repoPath :)

let $constantsDoc := file:read-text(concat($localFilesFolderUnix, 'constants.csv'))
let $xmlConstants := csv:parse($constantsDoc, map { 'header' : true(),'separator' : "," })
let $constants := $xmlConstants/csv/record

let $domainRoot := $constants//domainRoot/text()
let $coreDoc := $constants//coreClassFile/text()
let $coreClassPrefix := substring-before($coreDoc,".")
let $outputDirectory := $constants//outputDirectory/text()
let $metadataSeparator := $constants//separator/text()
let $baseIriColumn := $constants//baseIriColumn/text()
let $modifiedColumn := $constants//modifiedColumn/text()
let $outFileNameAfter := $constants//outFileNameAfter/text()

let $columnIndexDoc := file:read-text($localFilesFolderUnix||$coreClassPrefix||'-column-mappings.csv')
let $xmlColumnIndex := csv:parse($columnIndexDoc, map { 'header' : true(),'separator' : "," })
let $columnInfo := $xmlColumnIndex/csv/record

let $namespaceDoc := file:read-text(concat($localFilesFolderUnix,'namespace.csv'))
let $xmlNamespace := csv:parse($namespaceDoc, map { 'header' : true(),'separator' : "," })
let $namespaces := $xmlNamespace/csv/record

let $classesDoc := file:read-text($localFilesFolderUnix||$coreClassPrefix||'-classes.csv')
let $xmlClasses := csv:parse($classesDoc, map { 'header' : true(),'separator' : "," })
let $classes := $xmlClasses/csv/record

let $linkedClassesDoc := file:read-text(concat($localFilesFolderUnix,'linked-classes.csv'))
let $xmlLinkedClasses := csv:parse($linkedClassesDoc, map { 'header' : true(),'separator' : "," })
let $linkedClasses := $xmlLinkedClasses/csv/record

let $metadataDoc := file:read-text($localFilesFolderUnix ||$coreDoc)
let $xmlMetadata := csv:parse($metadataDoc, map { 'header' : true(),'separator' : $metadataSeparator })
let $metadata := $xmlMetadata/csv/record

let $linkedMetadata :=
      for $class in $linkedClasses
      let $linkedDoc := $class/filename/text()
      let $linkedClassPrefix := substring-before($linkedDoc,".")

      let $classMappingDoc := file:read-text(concat($localFilesFolderUnix,$linkedClassPrefix,"-column-mappings.csv"))
      let $xmlClassMapping := csv:parse($classMappingDoc, map { 'header' : true(),'separator' : "," })
      let $classClassesDoc := file:read-text(concat($localFilesFolderUnix,$linkedClassPrefix,"-classes.csv"))
      let $xmlClassClasses := csv:parse($classClassesDoc, map { 'header' : true(),'separator' : "," })
      let $classMetadataDoc := file:read-text(concat($localFilesFolderUnix,$linkedDoc))
      let $xmlClassMetadata := csv:parse($classMetadataDoc, map { 'header' : true(),'separator' : $metadataSeparator })
      return
        ( 
        <file>{
          $class/link_column,
          $class/link_property,
          $class/suffix1,
          $class/link_characters,
          $class/suffix2,
          $class/forward_link,
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
  
(: The main function returns a single string formed by concatenating all of the assembled pieces of the document :)
return 
  if ($outputToFile="true")
  then
    (: Creates the output directory specified in the constants.csv file if it doesn't already exist.  Then writes into a file having the name passed via the $id parameter concatenated with an appropriate file extension. uses default UTF-8 encoding :)
    (file:create-dir($outputDirectory),
    
    (: If the $id is a full IRI or long string, use only the part after the delimiter in $outFileNameAfter as the file name.  Otherwise, use the entire value of $id as the file name:) 
    if ($outFileNameAfter) 
    then file:write-text($outputDirectory||serialize:substring-after-last($id, $outFileNameAfter)||propvalue:extension($serialization),serialize:generate-entire-document($id,$linkedMetadata,$metadata,$domainRoot,$classes,$columnInfo,$serialization,$namespaces,$constants,$singleOrDump,$baseIriColumn,$modifiedColumn))
    else file:write-text($outputDirectory||$id||propvalue:extension($serialization),serialize:generate-entire-document($id,$linkedMetadata,$metadata,$domainRoot,$classes,$columnInfo,$serialization,$namespaces,$constants,$singleOrDump,$baseIriColumn,$modifiedColumn))
    ,
    
    (: put this in the Result window so that the user can tell that something happened :)
    "Completed file write of "||$id||propvalue:extension($serialization)||" at "||fn:current-dateTime()
    )
  else
    (: simply output the string to the Result window :)
    serialize:generate-entire-document($id,$linkedMetadata,$metadata,$domainRoot,$classes,$columnInfo,$serialization,$namespaces,$constants,$singleOrDump,$baseIriColumn,$modifiedColumn)
};

(:--------------------------------------------------------------------------------------------------:)

declare function serialize:main-github($id,$serialization,$repoName,$singleOrDump,$outputToFile)
{
    
    (: Despite the variable name, this is hacked to be the HTTP URI of the github repo online. :)
let $localFilesFolderUnix := concat("https://raw.githubusercontent.com/tdwg/rs.tdwg.org/master/",$repoName,"/")

let $constantsDoc := http:send-request(<http:request method='get' href='{$localFilesFolderUnix||'constants.csv'}'/>)[2]
let $xmlConstants := csv:parse($constantsDoc, map { 'header' : true(),'separator' : "," })
let $constants := $xmlConstants/csv/record

let $domainRoot := $constants//domainRoot/text()
let $coreDoc := $constants//coreClassFile/text()
let $coreClassPrefix := substring-before($coreDoc,".")
let $outputDirectory := $constants//outputDirectory/text()
let $metadataSeparator := $constants//separator/text()
let $baseIriColumn := $constants//baseIriColumn/text()
let $modifiedColumn := $constants//modifiedColumn/text()
let $outFileNameAfter := $constants//outFileNameAfter/text()

let $columnIndexDoc := http:send-request(<http:request method='get' href='{$localFilesFolderUnix||$coreClassPrefix||'-column-mappings.csv'}'/>)[2]
let $xmlColumnIndex := csv:parse($columnIndexDoc, map { 'header' : true(),'separator' : "," })
let $columnInfo := $xmlColumnIndex/csv/record

let $namespaceDoc := http:send-request(<http:request method='get' href='{$localFilesFolderUnix||'namespace.csv'}'/>)[2]
let $xmlNamespace := csv:parse($namespaceDoc, map { 'header' : true(),'separator' : "," })
let $namespaces := $xmlNamespace/csv/record

let $classesDoc := http:send-request(<http:request method='get' href='{$localFilesFolderUnix||$coreClassPrefix||'-classes.csv'}'/>)[2]
let $xmlClasses := csv:parse($classesDoc, map { 'header' : true(),'separator' : "," })
let $classes := $xmlClasses/csv/record

let $linkedClassesDoc := http:send-request(<http:request method='get' href='{$localFilesFolderUnix||'linked-classes.csv'}'/>)[2]
let $xmlLinkedClasses := csv:parse($linkedClassesDoc, map { 'header' : true(),'separator' : "," })
let $linkedClasses := $xmlLinkedClasses/csv/record

let $metadataDoc := http:send-request(<http:request method='get' href='{$localFilesFolderUnix ||$coreDoc}'/>)[2]
let $xmlMetadata := csv:parse($metadataDoc, map { 'header' : true(),'separator' : $metadataSeparator })
let $metadata := $xmlMetadata/csv/record

let $linkedMetadata :=
      for $class in $linkedClasses
      let $linkedDoc := $class/filename/text()
      let $linkedClassPrefix := substring-before($linkedDoc,".")

      let $classMappingDoc := http:send-request(<http:request method='get' href='{$localFilesFolderUnix,$linkedClassPrefix||"-column-mappings.csv"}'/>)[2]
      let $xmlClassMapping := csv:parse($classMappingDoc, map { 'header' : true(),'separator' : "," })
      let $classClassesDoc := http:send-request(<http:request method='get' href='{$localFilesFolderUnix||$linkedClassPrefix,"-classes.csv"}'/>)[2]
      let $xmlClassClasses := csv:parse($classClassesDoc, map { 'header' : true(),'separator' : "," })
      let $classMetadataDoc := http:send-request(<http:request method='get' href='{$localFilesFolderUnix,$linkedDoc}'/>)[2]
      let $xmlClassMetadata := csv:parse($classMetadataDoc, map { 'header' : true(),'separator' : $metadataSeparator })
      return
        ( 
        <file>{
          $class/link_column,
          $class/link_property,
          $class/suffix1,
          $class/link_characters,
          $class/suffix2,
          $class/forward_link,
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
  
(: The main function returns a single string formed by concatenating all of the assembled pieces of the document :)
return 
  if ($outputToFile="true")
  then
    (: Creates the output directory specified in the constants.csv file if it doesn't already exist.  Then writes into a file having the name passed via the $id parameter concatenated with an appropriate file extension. uses default UTF-8 encoding :)
    (file:create-dir($outputDirectory),
    
    (: If the $id is a full IRI or long string, use only the part after the delimiter in $outFileNameAfter as the file name.  Otherwise, use the entire value of $id as the file name:) 
    if ($outFileNameAfter) 
    then file:write-text($outputDirectory||serialize:substring-after-last($id, $outFileNameAfter)||propvalue:extension($serialization),serialize:generate-entire-document($id,$linkedMetadata,$metadata,$domainRoot,$classes,$columnInfo,$serialization,$namespaces,$constants,$singleOrDump,$baseIriColumn,$modifiedColumn))
    else file:write-text($outputDirectory||$id||propvalue:extension($serialization),serialize:generate-entire-document($id,$linkedMetadata,$metadata,$domainRoot,$classes,$columnInfo,$serialization,$namespaces,$constants,$singleOrDump,$baseIriColumn,$modifiedColumn))
    ,
    
    (: put this in the Result window so that the user can tell that something happened :)
    "Completed file write of "||$id||propvalue:extension($serialization)||" at "||fn:current-dateTime()
    )
  else
    (: simply output the string to the Result window :)
    serialize:generate-entire-document($id,$linkedMetadata,$metadata,$domainRoot,$classes,$columnInfo,$serialization,$namespaces,$constants,$singleOrDump,$baseIriColumn,$modifiedColumn)
};

(:--------------------------------------------------------------------------------------------------:)

declare function serialize:find($id,$repoPath,$pcRepoLocation)
{

(: This is an attempt to allow the necessary CSV files to load on any platform without hard-coding any paths here.  I know it works for PCs, but am not sure how consistently it works on non-PCs :)
let $localFilesFolderUnix := 
(:  if (fn:substring(file:current-dir(),1,2) = "C:") 
  then :)
    (: the computer is a PC with a C: drive, the path specified in the function arguments are substituted :)
    "file:///"||$pcRepoLocation||$repoPath
(:  else
     it's a Mac with the query running from a repo located at the default under the user directory
    file:current-dir() || "/Repositories/"||$repoPath :)

let $constantsDoc := file:read-text(concat($localFilesFolderUnix, 'constants.csv'))
let $xmlConstants := csv:parse($constantsDoc, map { 'header' : true(),'separator' : "," })
let $constants := $xmlConstants/csv/record

let $domainRoot := $constants//domainRoot/text()
let $coreDoc := $constants//coreClassFile/text()
let $coreClassPrefix := substring-before($coreDoc,".")
let $outputDirectory := $constants//outputDirectory/text()
let $metadataSeparator := $constants//separator/text()
let $baseIriColumn := $constants//baseIriColumn/text()
let $modifiedColumn := $constants//modifiedColumn/text()
let $outFileNameAfter := $constants//outFileNameAfter/text()

let $columnIndexDoc := file:read-text($localFilesFolderUnix||$coreClassPrefix||'-column-mappings.csv')
let $xmlColumnIndex := csv:parse($columnIndexDoc, map { 'header' : true(),'separator' : "," })
let $columnInfo := $xmlColumnIndex/csv/record

let $namespaceDoc := file:read-text(concat($localFilesFolderUnix,'namespace.csv'))
let $xmlNamespace := csv:parse($namespaceDoc, map { 'header' : true(),'separator' : "," })
let $namespaces := $xmlNamespace/csv/record

let $classesDoc := file:read-text($localFilesFolderUnix||$coreClassPrefix||'-classes.csv')
let $xmlClasses := csv:parse($classesDoc, map { 'header' : true(),'separator' : "," })
let $classes := $xmlClasses/csv/record

let $linkedClassesDoc := file:read-text(concat($localFilesFolderUnix,'linked-classes.csv'))
let $xmlLinkedClasses := csv:parse($linkedClassesDoc, map { 'header' : true(),'separator' : "," })
let $linkedClasses := $xmlLinkedClasses/csv/record

let $metadataDoc := file:read-text($localFilesFolderUnix ||$coreDoc)
let $xmlMetadata := csv:parse($metadataDoc, map { 'header' : true(),'separator' : $metadataSeparator })
let $metadata := $xmlMetadata/csv/record

let $linkedMetadata :=
      for $class in $linkedClasses
      let $linkedDoc := $class/filename/text()
      let $linkedClassPrefix := substring-before($linkedDoc,".")

      let $classMappingDoc := file:read-text(concat($localFilesFolderUnix,$linkedClassPrefix,"-column-mappings.csv"))
      let $xmlClassMapping := csv:parse($classMappingDoc, map { 'header' : true(),'separator' : "," })
      let $classClassesDoc := file:read-text(concat($localFilesFolderUnix,$linkedClassPrefix,"-classes.csv"))
      let $xmlClassClasses := csv:parse($classClassesDoc, map { 'header' : true(),'separator' : "," })
      let $classMetadataDoc := file:read-text(concat($localFilesFolderUnix,$linkedDoc))
      let $xmlClassMetadata := csv:parse($classMetadataDoc, map { 'header' : true(),'separator' : $metadataSeparator })
      return
        ( 
        <file>{
          $class/link_column,
          $class/link_property,
          $class/suffix1,
          $class/link_characters,
          $class/suffix2,
          $class/forward_link,
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
  
return 
      (: each record in the database must be checked for a match to the requested URI :)
      for $record in $metadata
      where $record/*[local-name()=$baseIriColumn]/text()=$id
      return true()      
};

(:--------------------------------------------------------------------------------------------------:)

declare function serialize:find-db($id,$db)
{
(: let $db := "tang-song" :)

let $constants := fn:collection($db)//constants/record
let $baseIriColumn := $constants//baseIriColumn/text()

let $metadata := fn:collection($db)/metadata/record
  
return 
      (: each record in the database must be checked for a match to the requested URI :)
      for $record in $metadata
      where $record/*[local-name()=$baseIriColumn]/text()=$id
      return true()      
};

(:--------------------------------------------------------------------------------------------------:)

declare function serialize:generate-entire-document($id,$linkedMetadata,$metadata,$domainRoot,$classes,$columnInfo,$serialization,$namespaces,$constants,$singleOrDump,$baseIriColumn,$modifiedColumn)
{
concat( 
  (: the namespace abbreviations only needs to be generated once for the entire document :)
  serialize:list-namespaces($namespaces,$serialization),
  if($serialization = 'json')
  then
    (: When each each resource description in each record is generated as json, it has a trailing comma.  The last one must be removed before closing the container for the array and document :)
    serialize:remove-last-comma(serialize:generate-records($id,$linkedMetadata,$metadata,$domainRoot,$classes,$columnInfo,$serialization,$namespaces,$constants,$singleOrDump,$baseIriColumn,$modifiedColumn))
  else 
    serialize:generate-records($id,$linkedMetadata,$metadata,$domainRoot,$classes,$columnInfo,$serialization,$namespaces,$constants,$singleOrDump,$baseIriColumn,$modifiedColumn)
  ,
  serialize:close-container($serialization) 
  ) 
};

(:--------------------------------------------------------------------------------------------------:)

declare function serialize:generate-records($id,$linkedMetadata,$metadata,$domainRoot,$classes,$columnInfo,$serialization,$namespaces,$constants,$singleOrDump,$baseIriColumn,$modifiedColumn)
{
string-join( 
  if ($singleOrDump = "dump")
  then
    (: this case outputs every record in the database :)
    for $record in $metadata
    let $baseIRI := $domainRoot||$record/*[local-name()=$baseIriColumn]/text()
    let $modified := $record/*[local-name()=$modifiedColumn]/text()
    return serialize:generate-a-record($record,$linkedMetadata,$baseIRI,$domainRoot,$modified,$classes,$columnInfo,$serialization,$namespaces,$constants)
  else
    (: for a single record, each record in the database must be checked for a match to the requested URI :)
    for $record in $metadata
    where $record/*[local-name()=$baseIriColumn]/text()=$id
    let $baseIRI := $domainRoot||$record/*[local-name()=$baseIriColumn]/text()
    let $modified := $record/*[local-name()=$modifiedColumn]/text()
    return serialize:generate-a-record($record,$linkedMetadata,$baseIRI,$domainRoot,$modified,$classes,$columnInfo,$serialization,$namespaces,$constants)
  )  
};

(:--------------------------------------------------------------------------------------------------:)

declare function serialize:generate-a-record($record,$linkedMetadata,$baseIRI,$domainRoot,$modified,$classes,$columnInfo,$serialization,$namespaces,$constants)
{
        
          (: Generate unabbreviated URIs and blank node identifiers. This must be done for every record separately since the UUIDs generated for the blank node identifiers must be the same within a record, but differ among records. :)
          
          let $IRIs := serialize:construct-iri($baseIRI,$classes) 
          (: generate a description for each class of resource included in the record :)
          for $modifiedClass in $IRIs
          return serialize:describe-resource($IRIs,$columnInfo,$record,$modifiedClass,$serialization,$namespaces,"") 
          ,
          
          (: now step through each class that's linked to the root class by many-to-one relationships and generate the resource description for each linked resource in that class :)
          for $linkedClass in $linkedMetadata
          return (
            (: determine the constants for the linked class :)
            let $linkColumn := $linkedClass/link_column/text()
            let $linkProperty := $linkedClass/link_property/text()
            let $suffix1 := $linkedClass/suffix1/text()
            let $linkCharacters := $linkedClass/link_characters/text()
            let $suffix2 := $linkedClass/suffix2/text()
            let $forwardLink :=
                  if ( exists($linkedClass/forward_link/text()) )
                  then $linkedClass/forward_link/text()
                  else "null"
            
            for $linkedClassRecord in $linkedClass/metadata/record
            where $baseIRI=$domainRoot||$linkedClassRecord/*[local-name()=$linkColumn]/text()
            
            (: generate an IRI or bnode for the instance of the linked class based on the convention for that class. 
            If the value of $linkCharacters is "http", then use the value in the $suffix1 column as the URI of the linked class instance :)
            let $linkedClassIRI := 
                    if (fn:substring($suffix1,1,2)="_:")
                    then
                        concat("_:",random:uuid() )
                    else
                            if ($linkCharacters="http")
                            then
                                $linkedClassRecord/*[local-name()=$suffix1]/text()
                            else
                            $baseIRI||"#"||$linkedClassRecord/*[local-name()=$suffix1]/text()||$linkCharacters||$linkedClassRecord/*[local-name()=$suffix2]/text()
            return (
                    (: Construct the descriptions of the linked class instances :)
                    let $linkedIRIs := serialize:construct-iri($linkedClassIRI,$linkedClass/classes/record)
                    let $extraTriple := if ($linkProperty = "null")
                                        then ""
                                        else
                                            (: The $extraTriple makes the backlink from the linked resource to the root class :)
                                            propvalue:iri($linkProperty,$baseIRI,$serialization,$namespaces)
                    for $linkedModifiedClass in $linkedIRIs
                    return
                       serialize:describe-resource($linkedIRIs,$linkedClass/mapping/record,$linkedClassRecord,$linkedModifiedClass,$serialization,$namespaces,$extraTriple)
                    ,
                    (: This provides an option to create a forward link from the root class resource to the linked resource:)
                    if ($forwardLink = "null")
                    then ()
                    else
                      (: construct a single triple :)
                      concat(
                            (: the last-item function removes trailing delimiters if necessary for a serialization :)
                            serialize:last-item(concat(
                                  propvalue:subject($baseIRI,$serialization),
                                  propvalue:iri($forwardLink,$linkedClassIRI,$serialization,$namespaces)
                                  )
                                  , $serialization),
                            (: The propvalue:type function with "null" type simply closes the container appropriately for the serialization. :)
                            propvalue:type("null",$serialization,$namespaces),
                            (: each described resource must be separated by a comma in JSON. If a resource is the last described in the the array, the trailing comma will be removed after they are all concatenated. :)
                            if ($serialization="json")
                            then ",&#10;"
                            else ""
                            )
                    )
            )
            ,
            
            (: The document description is done once for each record. Suppress if the document class has a value of "null" :)
            if ($constants//documentClass/text() = "null")
            then
              ()
            else
              serialize:describe-document($baseIRI,$modified,$serialization,$namespaces,$constants)
};

(:--------------------------------------------------------------------------------------------------:)

declare function serialize:describe-document($baseIRI,$modified,$serialization,$namespaces,$constants)
{
  let $type := $constants//documentClass/text()
  let $suffix := propvalue:extension($serialization)
  (: If the URI ends in a slash, e.g. http://example.org/ex/, then remove the trailing slash before appending the suffix. :)
  (: I.e. http://example.org/ex.ttl, not http://example.org/ex/.ttl :)
  let $iri := concat(serialize:remove-trailing-slash($baseIRI),$suffix)
  return concat(
    propvalue:subject($iri,$serialization),
    propvalue:plain-literal("dc:format",propvalue:media-type($serialization),$serialization),
    propvalue:plain-literal("dc:creator",$constants//creator/text(),$serialization),

    (: you are welcome to remove the following line if it annoys you :)
    propvalue:plain-literal("rdfs:comment","Generated by Guid-O-Matic 2.0 https://github.com/baskaufs/guid-o-matic",$serialization),
    
    propvalue:iri("dcterms:references",$baseIRI,$serialization,$namespaces),
    if ($modified)
    then propvalue:datatyped-literal("dcterms:modified",$modified,"xsd:dateTime",$serialization,$namespaces)
    else "",
    propvalue:type($type,$serialization,$namespaces),
    
    (: each described resource must be separated by a comma in JSON. The final trailing comma for all resources will be removed after they are all concatenated. :)
    if ($serialization="json")
    then ",&#10;"
    else ""

  )  
};

(:--------------------------------------------------------------------------------------------------:)

declare function serialize:remove-trailing-slash($temp)
{
  if (fn:ends-with($temp, '/'))
  then
    fn:substring($temp,1,fn:string-length($temp)-1)
  else
    $temp
};

(:--------------------------------------------------------------------------------------------------:)

declare function serialize:remove-last-comma($temp)
{
  concat(fn:substring($temp,1,fn:string-length($temp)-2),"&#10;")
};

(:--------------------------------------------------------------------------------------------------:)

declare function serialize:replace-semicolon-with-period($temp)
{
  concat(fn:substring($temp,1,fn:string-length($temp)-2),".&#10;")
};

(:--------------------------------------------------------------------------------------------------:)

(: if the last item in a property-value list is not followed by a type declaration, a trailing delimiter may need removal :)
declare function serialize:last-item($propertyBlock, $serialization)
{
if ($serialization = 'json')
then 
  (: For JSON, only the trailing comma needs to be removed. :)
  serialize:remove-last-comma($propertyBlock)
else 
    if ($serialization = 'turtle')
    then
        (: for Turtle, the trailing semicolon must be replaced with a final period :) 
        serialize:replace-semicolon-with-period($propertyBlock)
    else
        (: for XML there are no trailing delimiters, so nothing to remove. :)
        $propertyBlock
};

(:--------------------------------------------------------------------------------------------------:)

(: This generates the list of namespace abbreviations used :)
declare function serialize:list-namespaces($namespaces,$serialization)
{  
(: Because this is the beginning of the file, it also opens the root container for the serialization (if any) :)
switch ($serialization)
    case "turtle" return concat(
                          string-join(serialize:curie-value-pairs($namespaces,$serialization)),
                          "&#10;"
                        )
    case "xml" return concat(
                          "<rdf:RDF&#10;",
                          string-join(serialize:curie-value-pairs($namespaces,$serialization)),
                          ">&#10;"
                        )
    case "json" return concat(
                          "{&#10;",
                          '"@context": {&#10;',
                          serialize:remove-last-comma(string-join(serialize:curie-value-pairs($namespaces,$serialization))),
                          '},&#10;',
                          '"@graph": [&#10;'
                        )
    default return ""
};

(:--------------------------------------------------------------------------------------------------:)

(: generate sequence of CURIE,value pairs :)
declare function serialize:curie-value-pairs($namespaces,$serialization)
{
  for $namespace in $namespaces
  return switch ($serialization)
        case "turtle" return concat("@prefix ",$namespace/curie/text(),": <",$namespace/value/text(),">.&#10;")
        case "xml" return concat('xmlns:',$namespace/curie/text(),'="',$namespace/value/text(),'"&#10;')
        case "json" return concat('"',$namespace/curie/text(),'": "',$namespace/value/text(),'",&#10;')
        default return ""
};

(:--------------------------------------------------------------------------------------------------:)

(: This function describes a single instance of the type of resource being described by the table :)
declare function serialize:describe-resource($IRIs,$columnInfo,$record,$class,$serialization,$namespaces,$extraTriple)
{  
(: Note: the propvalue:subject function sets up any string necessary to open the container, and the propvalue:type function closes the container :)
let $type := $class/class/text()
let $id := $class/id/text()
let $iri := $class/fullId/text()
let $propertyBlock := 
  concat(
    propvalue:subject($iri,$serialization),
    string-join(serialize:property-value-pairs($IRIs,$columnInfo,$record,$id,$serialization,$namespaces)),
    
    (: make the backlink only for the instance of the primary class in a table :)
    if ($id="$root")
    then $extraTriple
    else ""
  )
return (
  if ($type = 'null')
  then
    (: if the type declaration is omitted, then delimiters may need to be removed from the last property/value pair :)
    serialize:last-item($propertyBlock, $serialization)
  else
    (: if there is a type declaration, no action needed on removing delimiters :)
    $propertyBlock
  ,
  propvalue:type($type,$serialization,$namespaces),
  (: each described resource must be separated by a comma in JSON. If a resource is the last described in the the array, the trailing comma will be removed after they are all concatenated. :)
  if ($serialization="json")
  then ",&#10;"
  else ""
  )
};

(:--------------------------------------------------------------------------------------------------:)

(: generate sequence of non-type property/value pair strings :)
declare function serialize:property-value-pairs($IRIs,$columnInfo,$record,$id,$serialization,$namespaces)
{
  (: generates property/value pairs that have fixed values :)
  for $columnType in $columnInfo
  where "$constant" = $columnType/header/text() and $columnType/subject_id/text() = $id
  return switch ($columnType/type/text())
     case "plain" return propvalue:plain-literal($columnType/predicate/text(),$columnType/value/text(),$serialization)
     case "datatype" return propvalue:datatyped-literal($columnType/predicate/text(),$columnType/value/text(),$columnType/attribute/text(),$serialization,$namespaces)
     case "language" return propvalue:language-tagged-literal($columnType/predicate/text(),$columnType/value/text(),$columnType/attribute/text(),$serialization)
     case "iri" return propvalue:iri($columnType/predicate/text(),$columnType/value/text(),$serialization,$namespaces)
     default return ""
,

  (: generates property/value pairs whose values are given in the metadata table :)
  for $column in $record/child::*, $columnType in $columnInfo
  (: The loop only includes columns containing properties associated with the class of the described resource; that column in the record must not be empty :)
  where fn:local-name($column) = $columnType/header/text() and $columnType/subject_id/text() = $id and $column//text() != ""
  return switch ($columnType/type/text())
     case "plain" return propvalue:plain-literal($columnType/predicate/text(),$column//text(),$serialization)
     case "datatype" return propvalue:datatyped-literal($columnType/predicate/text(),$column//text(),$columnType/attribute/text(),$serialization,$namespaces)
     case "language" return propvalue:language-tagged-literal($columnType/predicate/text(),$column//text(),$columnType/attribute/text(),$serialization)
     case "iri" return 
       (:: check whether the value column in the mapping table has anything in it :)
       if ($columnType/value/text())
       then
         (: something is there. Construct the IRI by concatenating what's in the value column, the column content, and what's in the attribute column :)
         propvalue:iri($columnType/predicate/text(),$columnType/value/text()||$column//text()||$columnType/attribute/text(),$serialization,$namespaces)
       else
         (: nothing is there.  The column either contains a full IRI or an abbreviated one :)
         propvalue:iri($columnType/predicate/text(),$column//text(),$serialization,$namespaces)
     default return ""
,

  (: generates links to associated resources described in the same document :)
  for $columnType in $columnInfo
  where "$link" = $columnType/header/text() and $columnType/subject_id/text() = $id
  let $suffix := $columnType/value/text()
  return 
      for $iri in $IRIs
      where $iri/id/text()=$suffix
      let $object := $iri/fullId/text()
      return propvalue:iri($columnType/predicate/text(),$object,$serialization,$namespaces)
};

(:--------------------------------------------------------------------------------------------------:)

(: this function closes the root container for the serialization (if any) :)
declare function serialize:close-container($serialization)
{  
switch ($serialization)
    case "turtle" return ""
    case "xml" return "</rdf:RDF>&#10;"
    case "json" return ']&#10;}'
    default return ""
};

(:--------------------------------------------------------------------------------------------------:)

declare function serialize:construct-iri($baseIRI,$classes)
{
  (: This function basically creates a parallel set of class records that contain the full URIs in addition to the abbreviated ones that are found in classes.csv . In addition, UUID blank node identifiers are generated for nodes that are anonymous.  UUIDs are used instead of sequential numbers since the main function may be hacked to serialize ALL records rather than just one and in that case using UUIDs would ensure that there is no duplication of blank node identifiers among records. :)
  for $class in $classes
  let $suffix := $class/id/text()
  return
     <record>{
     if (fn:substring($suffix,1,2)="_:")
     then (<fullId>{concat("_:",random:uuid() ) }</fullId>, $class/id, $class/class )
     else 
       if ($suffix="$root")
       then (<fullId>{$baseIRI}</fullId>, $class/id, $class/class )
       else (<fullId>{concat($baseIRI,$suffix) }</fullId>, $class/id, $class/class )
   }</record>
};

(:--------------------------------------------------------------------------------------------------:)

declare function serialize:html($id,$serialization)
{
 let $value := concat("Placeholder page for local ID=",$id,".")
return 
<html>
  <body>
  {$value}
  </body>
</html>
};
