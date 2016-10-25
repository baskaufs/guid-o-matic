xquery version "3.1";

(: Guid-O-Matic Darwin Core Archive translator https://github.com/baskaufs/guid-o-matic :)

declare namespace dwctext = "http://rs.tdwg.org/dwc/text/";

declare function local:collapse-iri($fullIRI,$namespaces)
{
  (: if the passed URI is already expanded as an HTTP IRI or a URN, the function does nothing :)
  for $namespace in $namespaces 
  where contains($fullIRI,$namespace/value/text() )
  let $localName := substring-after($fullIRI,$namespace/value/text())
  return $namespace/curie/text()||":"||$localName
};

declare function local:suck-out-column-headers($localFilesFolderUnix,$metadataSeparator, $coreDoc)
{
let $metadataDoc := file:read-text($localFilesFolderUnix || $coreDoc)
let $xmlMetadata := csv:parse($metadataDoc, map { 'header' : true(),'separator' : $metadataSeparator })

(: create a sequence that contains the column headers, where item 1 is the first column header :)
let $columnHeaderStrings := $xmlMetadata/csv/record[1]/*/local-name()
return
       for $columnHeader at $counter in $columnHeaderStrings
       return (<column><index>{$counter}</index>,<header>{$columnHeader}</header></column>)
};

declare function local:suck-out-property-fields($fields)
{
for $field in $fields
return (<field><index>{data($field/@index)+1}</index><term>{data($field/@term)}</term></field>)
};

let $repoPath := "guid-o-matic/dwc-a/"
let $pcRepoLocation := "c:/github/"
let $localFilesFolderPC := "c:\github\guid-o-matic\dwc-a\"

let $localFilesFolderUnix := 
  if (fn:substring(file:current-dir(),1,2) = "C:") 
  then 
    (: the computer is a PC with a C: drive, subsitute your path here :)
    "file:///"||$pcRepoLocation||$repoPath
  else
    (: its a Mac with the query running from a repo located at the default under the user directory :)
    file:current-dir() || "/Repositories/"||$repoPath

(: There must be a file called translate-namespaces.csv that contains the abbreviations for dwc:, dcterms:, and any other namespaces used in the meta.xml file :)
let $namespaceDoc := file:read-text(concat($localFilesFolderUnix,'namespace.csv'))
let $xmlNamespace := csv:parse($namespaceDoc, map { 'header' : true(),'separator' : "," })
let $namespaces := $xmlNamespace/csv/record

(: This opens up the meta.xml file and gets necessary information from it :)
let $metaDoc := fn:doc(concat($localFilesFolderUnix, 'meta.xml'))

let $tempSeparator := data($metaDoc/dwctext:archive/dwctext:core/@fieldsTerminatedBy)
(: If the CSV is tab-separated, the excape code for tab must be substituted for the abbreviation "\t" :)
let $metadataSeparator := 
                          if ($tempSeparator="\t")
                          then "&#9;"
                          else $tempSeparator
let $metadataSeparatorOut := 
                          if ($tempSeparator="\t")
                          then "&#9;"
                          else $tempSeparator
let $coreDoc := $metaDoc/dwctext:archive/dwctext:core/dwctext:files/dwctext:location/text()
let $coreClass := local:collapse-iri(data($metaDoc/dwctext:archive/dwctext:core/@rowType),$namespaces)
let $coreClassPrefix := substring-before($coreDoc,".")

(: This opens up the CSV file for the core class so that we can get the column headers from it :)
let $columnHeaders := local:suck-out-column-headers($localFilesFolderUnix,$metadataSeparator, $coreDoc)

(: create a sequence of elements whose values are the attribute values from the meta.csv document. The index of the first column has a value of zero. :)
let $fields := $metaDoc/dwctext:archive/dwctext:core/dwctext:field
let $properties := local:suck-out-property-fields($fields)

(: find the column header that matches the column specified as the ID for the core records :)
let $coreIdColumnHeader :=                 
                        for $columnHeader in $columnHeaders
                        where $columnHeader/index/text()=data($metaDoc/dwctext:archive/dwctext:core/dwctext:id/@index)+1
                        return $columnHeader/header/text()

(: if any column is mapped to dcterms:modified, find the name of the header :)
let $test :=                 
                        for $columnHeader in $columnHeaders,$property in $properties
                        where $columnHeader/index=$property/index and local:collapse-iri($property/term/text(),$namespaces)="dcterms:modified"
                        return $columnHeader/header/text()
let $modifiedColumnHeader := if($test) then $test else ""

return (

(: here we are creating the column mapping file for the base resource class based on the fields defined in the meta.xml file.  If the specified folder for writing doesn't exist, it's created. :)
    (file:create-dir($localFilesFolderPC),file:write-text($localFilesFolderPC||$coreClassPrefix||"-column-mappings.csv",

        csv:serialize(<csv>{
          <record><header>{"header"}</header><predicate>{"predicate"}</predicate><type>{"type"}</type><value>{"value"}</value><attribute>{"attribute"}</attribute><subject_id>{"subject_id"}</subject_id></record>,
          (: step through the columns and generate their mappings :)
          for $columnHeader in $columnHeaders,$property in $properties
          where $columnHeader/index=$property/index
          return <record><header>{$columnHeader/header/text()}</header><predicate>{local:collapse-iri($property/term/text(),$namespaces)}</predicate><type>{"plain"}</type><value/><attribute/><subject_id>{"$root"}</subject_id></record>,
          for $field in $fields
          where $field/@default
          return <record><header>{"$constant"}</header><predicate>{local:collapse-iri(data($field/@term),$namespaces)}</predicate><type>{"plain"}</type><value>{data($field/@default)}</value><attribute/><subject_id>{"$root"}</subject_id></record> 
        }</csv>)
 
    )),
    
(: This creates the file that contains constants, populated by ones we can guess from the meta.xml file :)
(file:write-text($localFilesFolderPC||"constants.csv",

csv:serialize(<csv>{
   <record><domainRoot>{"domainRoot"}</domainRoot><coreClassFilePrefix>{"coreClassFile"}</coreClassFilePrefix><documentClass>{"documentClass"}</documentClass><creator>{"creator"}</creator><outputDirectory>{"outputDirectory"}</outputDirectory><outFileNameAfter>{"outFileNameAfter"}</outFileNameAfter><separator>{"separator"}</separator><baseIriColumn>{"baseIriColumn"}</baseIriColumn><modifiedColumn>{"modifiedColumn"}</modifiedColumn></record>,
   
      <record><domainRoot>{"http://example.org/"}</domainRoot><coreClassFilePrefix>{$coreDoc}</coreClassFilePrefix><documentClass>{"foaf:Document"}</documentClass><creator></creator><outputDirectory></outputDirectory><outFileNameAfter></outFileNameAfter><separator>{$metadataSeparatorOut}</separator><baseIriColumn>{$coreIdColumnHeader}</baseIriColumn><modifiedColumn>{$modifiedColumnHeader}</modifiedColumn></record>

   }</csv>)
   
)),
   
(: This creates the file that specifies classes whose instances have a 1:1 relationship with the root class.  Initially it will only list the root class - others will have to be added manually  :)
(file:write-text($localFilesFolderPC||$coreClassPrefix||"-classes.csv",

csv:serialize(<csv>{
   <record><id>{"id"}</id><class>{"class"}</class></record>,
   <record><id>{"$root"}</id><class>{$coreClass}</class></record>
   }</csv>)
   
)),

(: now build the necessary separate files for the extensions :)
for $extension in $metaDoc/dwctext:archive/dwctext:extension

let $extDoc := $extension/dwctext:files/dwctext:location/text()
let $extClass := local:collapse-iri(data($extension/@rowType),$namespaces)
let $extClassPrefix := substring-before($extDoc,".")

(: This opens up the CSV file for the extension class so that we can get the column headers from it :)
let $extColumnHeaders := local:suck-out-column-headers($localFilesFolderUnix,$metadataSeparator, $extDoc) 

(: create a sequence of elements whose values are the attribute values from the meta.csv document. The index of the first column has a value of zero. :)
let $extFields := $extension/dwctext:field
let $extProperties := local:suck-out-property-fields($extFields)

return (
            (: output a column mapping file for each extension :)
            file:write-text($localFilesFolderPC||$extClassPrefix||"-column-mappings.csv",
        
                          csv:serialize(<csv>{
                            <record><header>{"header"}</header><predicate>{"predicate"}</predicate><type>{"type"}</type><value>{"value"}</value><attribute>{"attribute"}</attribute><subject_id>{"subject_id"}</subject_id></record>,
                            for $columnHeader in $extColumnHeaders,$property in $extProperties
                            where $columnHeader/index=$property/index
                            return <record><header>{$columnHeader/header/text()}</header><predicate>{local:collapse-iri($property/term/text(),$namespaces)}</predicate><type>{"plain"}</type><value/><attribute/><subject_id>{"$root"}</subject_id></record>
                                      }</csv>)
         
                          ),
                          
          (: This creates files that specify classes whose instances have a 1:1 relationship with the particular extension class.  Initially it will only list the extension class itself - others will have to be added manually  :)
          file:write-text($localFilesFolderPC||$extClassPrefix||"-classes.csv",
          
                        csv:serialize(<csv>{
                           <record><id>{"id"}</id><class>{"class"}</class></record>,
                           <record><id>{"$root"}</id><class>{$extClass}</class></record>
                           }</csv>)
             
                         )

       ),


(: build the single file that describes how the extension classes are linked to the core class :)

          file:write-text($localFilesFolderPC||"linked-classes.csv",
          
                        csv:serialize(<csv>{
                           <record><link_column>{"link_column"}</link_column><link_property>{"link_property"}</link_property><suffix1>{"suffix1"}</suffix1><link_characters>{"link_characters"}</link_characters><suffix2>{"suffix2"}</suffix2><class>{"class"}</class><filename>{"filename"}</filename></record>,
       
for $extension in $metaDoc/dwctext:archive/dwctext:extension

let $extDoc := $extension/dwctext:files/dwctext:location/text()
let $extClass := local:collapse-iri(data($extension/@rowType),$namespaces)
let $extClassPrefix := substring-before($extDoc,".")

(: This opens up the CSV file for the extension class so that we can get the column headers from it :)
let $extColumnHeaders := local:suck-out-column-headers($localFilesFolderUnix,$metadataSeparator, $extDoc) 

(: create a sequence of elements whose values are the attribute values from the meta.csv document. The index of the first column has a value of zero. :)
let $extFields := $extension/dwctext:field
let $extProperties := local:suck-out-property-fields($extFields)

(: find the column header that matches the column specified as the IDref for the extension records :)
let $extIdColumnHeader :=                 
                        for $columnHeader in $extColumnHeaders
                        where $columnHeader/index/text()=data($extension/dwctext:coreid/@index)+1
                        return $columnHeader/header/text()

return 
    if ($extIdColumnHeader)
    then
    <record><link_column>{$extIdColumnHeader}</link_column><link_property>{"dcterms:relation"}</link_property><suffix1>{"_:"}</suffix1><link_characters></link_characters><suffix2></suffix2><class>{$extClass}</class><filename>{$extDoc}</filename></record>
    else
    <record/>
    
                           }</csv>)
             
                         )
       
       
)