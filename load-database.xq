xquery version "3.1";
(: part of Guid-O-Matic 2.0 https://github.com/baskaufs/guid-o-matic . You are welcome to reuse or hack in any way :)

(: Note: output of the XML files is to the directory specified in the constants.csv file in the input directory :)

(: It is important that the column headers in linked CSV data files are unique. :)

(: In order to avoid hard-coding file locations, the propvalue module is imported from GitHub.  It is unlikely that you will need to modify any of the functions it contains, but if you do, you will need to substitute after the "at" keyword the path to the local directory where you put the propvalue.xqm file :)
import module namespace propvalue = 'http://bioimages.vanderbilt.edu/xqm/propvalue' at 'https://raw.githubusercontent.com/baskaufs/guid-o-matic/master/propvalue.xqm'; 


(: These two functions copied from FunctX http://www.xqueryfunctions.com/ :)

declare function local:substring-after-last
  ( $arg as xs:string? ,
    $delim as xs:string )  as xs:string {

   replace ($arg,concat('^.*',local:escape-for-regex($delim)),'')
 } ;
 
 declare function local:escape-for-regex
  ( $arg as xs:string? )  as xs:string {

   replace($arg,
           '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
 } ;
(:--------------------------------------------------------------------------------------------------:)

declare function local:main($repoPath,$pcRepoLocation,$outputToFile)
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
(: let $outputDirectory := "c:/test/output/xml/"  :)
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
    

    file:write($outputDirectory||"constants.xml",<constants>{$constants}</constants>),
    file:write($outputDirectory||"column-index.xml",<column-index>{$columnInfo}</column-index>),
    file:write($outputDirectory||"namespaces.xml",<namespaces>{$namespaces}</namespaces>),
    file:write($outputDirectory||"classes.xml",<base-classes>{$classes}</base-classes>),
    file:write($outputDirectory||"linked-classes.xml",<linked-classes>{$linkedClasses}</linked-classes>),
    file:write($outputDirectory||"metadata.xml",<metadata>{$metadata}</metadata>),
    file:write($outputDirectory||"linked-metadata.xml",<linked-metadata>{$linkedMetadata}</linked-metadata>),
    
    (: put this in the Result window so that the user can tell that something happened :)
    "Completed file write of XML files at "||fn:current-dateTime()
    )
  else
    (: simply output the string to the Result window :)
    $xmlNamespace
};


(:--------------------------------------------------------------------------------------------------:)
(: Here's the main query that makes it go :)

(: Find the github repo home by getting the parent directory  :)
let $gitRepoWin := file:parent(file:base-dir())

(: If it's a Windows file system, replace backslashes with forward slashes.  Otherwise, nothing happens. :)
let $gitRepo := fn:replace($gitRepoWin,"\\","/")

return local:main("guid-o-matic/",$gitRepo,"true")

