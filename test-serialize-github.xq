xquery version "3.1";
(: part of Guid-O-Matic 2.0 https://github.com/baskaufs/guid-o-matic :)(: part of Guid-O-Matic 2.0 https://github.com/baskaufs/guid-o-matic . You are welcome to reuse or hack in any way :)

import module namespace serialize = 'http://bioimages.vanderbilt.edu/xqm/serialize' at './serialize.xqm';

(:  The first argument is identifier for the focal resource.  If output is to a file, this argument is used as the first part of the file name, followed by an appropriate extension for the serialization type.  If the fifth argument is "dump", use this argument to specify the file name of the dump :)
(: second argument is the serialization. options are "turtle","xml", and "json":)
(: the third argument base URI of the Github repo (online, not local directory) :)
(: the fourth argument is the name of the github repo. :)
(: the fifth argument should be "single" to return the single record corresponding to the site name, or "dump" to return all of the records in the database regardless of the value of the first argument :)
(: the sixth argument indicates whether the results should be output to a file.  Use "true" to output to a file and anything else to output to the screen :)

serialize:main-github("http://rs.tdwg.org/ac/dc/","turtle","https://raw.githubusercontent.com/tdwg/rs.tdwg.org/master/","term-lists","single","false")


