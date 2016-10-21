[jump to a detailed explanation](use.md)

[jump to the Darwin Core translator page](dwca-converter.md)

# Guid-O-Matic
Software to convert fielded text (CSV) files to RDF serialized as XML, Turtle, or JSON-LD

![](https://raw.githubusercontent.com/baskaufs/guid-o-matic/master/squid.bmp)
![](https://raw.githubusercontent.com/baskaufs/guid-o-matic/master/images/translation.png)

"You can write better software than this..."

## What is the purpose of Guid-O-Matic ?
Best Practices in the biodiversity informatics community, as embodied in the [TDWG GUID Applicability Statement](https://github.com/tdwg/guid-as) dictate that globally unique identifiers (GUIDs, rhymes with "squids") should be resolvable (i.e. dereferenceable, Recommendation R7) and that the default metadata response format should be RDF serialized as XML (Recommendation R10).  In practice, machine-readable metadata is rarely provided when the requested content-type is some flavor of RDF. I think the reason is because people think it is "too hard" to generate the necessary RDF.  

The purpose of Guid-O-Matic is mostly to show that it is not really that hard to create RDF.  Anybody who can create a spreadsheet or a [Darwin Core Archive (DwCa)](http://www.gbif.org/resource/80636) can generate RDF with little additional effort.  In production, providers would probably not use spreadsheets as a data source, but the point of Guid-O-Matic is to demonstrate a general strategy and allow users to experiment with different graph structures and play with the generated serializations.

## Why is it called "Guid-O-Matic" and not something like "RDF-Generator-O-Matic"?
Because I already had the cute squid picture and "RDF Generator" doesn't rhyme with "squid".

## Why did you write this script in Xquery and not something like Python or PHP?
I am not a very good Python programmer and I don't know PHP.  Once you understand what Guid-O-Matic does, you can write your own (better) code to do the same thing.

I used Xquery because I'm in a working group that includes a lot of Digital Humanists, and they love XML.  Also, the awesome Xquery processor, BaseX, is free and easily downloaded and installed.  So anybody can easily run the Guid-O-Matic scripts.  In addition, BaseX can run as a web server, so in theory, one could call the RDF-generating functions in response to a HTTP request and actually use the scripts to provide RDF online.

## What did Guid-O-Matic 1.1 do?
I wrote Guid-O-Matic 1 in about 2010.  Version 1.1 had a very limited scope:
- it only generated RDF/XML
- it assumed that the focal resource was a specimen
- it assumed that the specimen was depicted by one image
- it was hard-coded to use a specific version of the [Darwin Core](http://rs.tdwg.org/dwc/terms/) and [Darwin-SW](https://github.com/darwin-sw/dsw) vocabularies
- other stuff that I can't remember

Version 1.1 also was written in an old version of Visual Basic, which had the advantage that it could run as an executable, but had the disadvantage that you couldn't hack it unless you had a copy of Visual Basic and knew how to use it.  Even I don't have a functioning copy of that version of Visual Basic any more, so I can't even look at the source code now.  But it doesn't really matter because I don't advise that anyone try to mess with version 1.1 anyway.  I'm only posting it here for historical reasons (and so that you can try running it to see the great squid graphic on the UI!).

## What does Guid-O-Matic 2 do?
Version 2 is intended to be as general as is practical considering that the source data are being pulled from a CSV file.  It:
- provides RDF output in XML, Turtle, or JSON-LD
- allows the focal resource to be of any class
- allows the use of any RDF vocabularies
- accepts input from any "flat" delimited text file (i.e. a CSV file)
- allows the user to set up all of the defaults and CSV-to-RDF mappings via CSV files that can be edited in Excel or any other typical spreadsheet application.
- allows linking of any number of classes whose instances have a one-to-one relationship with the focal class.
- allows linking of any number of classes whose instances have a many-to-one relationship with the focal class (i.e. a "star schema"). This includes [Darwin Core Archive (DwCa)](http://www.gbif.org/resource/80636) files.
- output can be onscreen or to a file.
- output can be a single record or a dump of the entire database.
- the main script is included in an Xquery module so that it could potentially be called from the [BaseX Web Application](http://docs.basex.org/wiki/Web_Application) and therefore be used to actually dereference IRIs.  (In that case, the code would probably be hacked to pull the data from an XML database rather than from the CSV files.)

Version 2 is written in [Xquery (a W3C Recommendation)](https://www.w3.org/TR/xquery/).  It can be run using [BaseX](http://basex.org/), a free Xquery processor.  Instructions for setting everything up are elsewhere.

In addition to the main script that generates the RDF, there is an additional script that processes a Darwin Core Archive so that it can be used as source data.  It pulls information from the meta.xml file to generate hackable mappings from the CSV files to the RDF.  

## Can I try it?
Yes, please do!  If all you want to do is see what happens, do the following:
- fork the Guid-O-Matic GitHub repo (https://github.com/baskaufs/guid-o-matic) to your local drive.  Where you clone it on your hard drive has implications for the software finding the necessary files.  Read below before you actually do the cloning.
- install [BaseX](http://basex.org/products/download/all-downloads/) (if you haven't already)
- use the Open (file folder) button in BaseX to navigate to the downloaded folder for the repo and load the query test-serialize.xq into BaseX.
- if you downloaded the repo to the default location and are using a Mac (and probably any Linux system), you shouldn't have to do anything for the script to find the necessary files.  If you are running a PC, or if you are using a non-PC with the files located at some non-default location, you need to set the path to the guid-o-matic repo directory as the fourth parameter of the function.  The default repo-cloning location on PCs is in some horrible place inside the default user directory. However, when cloning the repo, you can specify some simpler location for the repo.  I use c:\github\, which is the default given in the function as it is downloaded.
- Click the "Run Query" ("play" triangle) button.  The example data are Chinese religious sites and buildings.*  You can see the [graph model here](graph-model.md).

You can play around with changing the identifier for the focal resource (the first parameter of the function) to generate RDF for other temple sites, and the serialization (the second parameter).  Suggested values are given in the comments above the function.   

If you want to try more complicated things like changing the properties or graph model, or if you want to set up mappings for your own data, you will need to read [more detailed instructions](use.md).  To take it a step further and try using a Darwin Core archive as input also requires [reading more instructions](dwca-converter.md).

\* Tang-Song temple data provided by [Dr. Tracy Miller](http://as.vanderbilt.edu/historyart/people/miller.php) of the Vanderbilt University Department of History of Art, who graciously let us use her data as a guinea pig in our Semantic Web working group.  Please contact her for more information about the data.
