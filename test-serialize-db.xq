xquery version "3.1";
(: part of Guid-O-Matic 2.0 https://github.com/baskaufs/guid-o-matic :)(: part of Guid-O-Matic 2.0 https://github.com/baskaufs/guid-o-matic . You are welcome to reuse or hack in any way :)

import module namespace serialize = 'http://bioimages.vanderbilt.edu/xqm/serialize' at './serialize.xqm';

(:  The first argument is identifier for the focal resource.  In the default example, it is the site name. Other values to try are "Longmensi" or "Lingyansi". If output is to a file, this argument is used as the first part of the file name, followed by an appropriate extension for the serialization type.  If the fifth argument is "dump", use this argument to specify the file name of the dump :)
(: second argument is the serialization. options are "turtle","xml", and "json":)
(: the third argument is the path to the directory containing the csv files relative to the GitHub repo home folder :)
(: the fourth argument is a variable containing the path to the GitHub repo home folder. You can hard code this to
something else if the running files are somewhere else on your drive. :)
(: the fifth argument should be "single" to return the single record corresponding to the site name, or "dump" to return all of the records in the database regardless of the value of the first argument :)
(: the sixth argument indicates whether the results should be output to a file.  Use "true" to output to a file and anything else to output to the screen :)

(: Assume that this file is being run from a directory that is just below the github repo home directory.
Find the github repo home by getting the parent directory  :)
let $gitRepoWin := file:parent(file:base-dir())

(: If it's a Windows file system, replace backslashes with forward slashes.  Otherwise, nothing happens. :)
let $gitRepo := fn:replace($gitRepoWin,"\\","/")

return serialize:main-db("Longxingsi","turtle","guid-o-matic/",$gitRepo,"single","false")


