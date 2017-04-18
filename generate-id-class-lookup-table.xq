xquery version "3.1";
(: part of Guid-O-Matic 2.0 https://github.com/baskaufs/guid-o-matic . You are welcome to reuse or hack in any way :)

(: Note: this is a purpose-built hack of the load-database.xq script whose purpose is to generate a mapping XML file that enables a lookup of a work to find out what class it is an instance of, and therefore what function and database to use when its URI is dereferenced :)

(:--------------------------------------------------------------------------------------------------:)

declare function local:main($filePath,$outputToFile)
{

let $outputDirectory := "c:/test/output/work-class-lookup/"  

let $columnIndexDoc := file:read-text($filePath)
let $xmlColumnIndex := csv:parse($columnIndexDoc, map { 'header' : true(),'separator' : "," })
let $columnInfo := $xmlColumnIndex/csv/record

(: The main function returns a single string formed by concatenating all of the assembled pieces of the document :)
return 
  if ($outputToFile="true")
  then
    (: Creates the output directory specified in the constants.csv file if it doesn't already exist.  Then writes into a file having the name passed via the $id parameter concatenated with an appropriate file extension. uses default UTF-8 encoding :)
    (file:create-dir($outputDirectory),
    

    file:write($outputDirectory||"work-id-class-lookup.xml",<works>{$columnInfo}</works>),
    
    (: put this in the Result window so that the user can tell that something happened :)
    "Completed file write of XML files at "||fn:current-dateTime()
    )
  else
    (: simply output the string to the Result window :)
    $columnInfo
};


(:--------------------------------------------------------------------------------------------------:)
(: Here's the main query that makes it go :)

local:main("file:///c:/github/semantic-web/2016-fall/tang-song/work-id-class-lookup.csv","true")

