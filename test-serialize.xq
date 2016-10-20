
import module namespace serialize = 'http://bioimages.vanderbilt.edu/xqm/serialize' at './serialize.xqm';

(:  The first argument is the site name. Other values to try are "Longmensi" or "Lingyansi". If output is to a file, this argument is used as the first part of the file name, followed by an appropriate extension for the serialization type.  If the fifth argument is "dump", use this argument to specify the file name of the dump :)
(: second argument is the serialization. options are "turtle","xml", and "json":)
(: the third argument is the path to the directory containing the queries within the cloned GitHub repo :)
(: the fourth argument is only relevant for PC users.  It is the path to the location where your GitHub repo is stored. :)
(: the fifth argument should be "single" to return the single record corresponding to the site name, or "dump" to return all of the records in the database regardless of the value of the first argument :)
(: the sixth argument indicates whether the results should be output to a file.  Use "true" to output to a file and anything else to output to the screen :)
serialize:main("Longxingsi","turtle","semantic-web/2016-fall/tang-song/","c:/github/","single","false")


