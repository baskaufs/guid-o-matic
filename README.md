![](https://raw.githubusercontent.com/baskaufs/guid-o-matic/master/squid.bmp)

"You can write better software than this..."

# guid-o-matic
Software to convert fielded text (CSV) files to RDF serialized as XML, Turtle, and JSON-LD

## What is the purpose of Guid-O-Matic ?
Best Practices in the biodiversity informatics community, as embodied in the [TDWG GUID Applicability Statement](https://github.com/tdwg/guid-as) dictate that globally unique identifiers (GUIDs, rhymes with "squids") should be resolvable (i.e. dereferenceable, Recommendation R7) and that the default metadata response format should be RDF serialized as XML (Recommendation R10).  In practice, machine-readable metadata is rarely provided when the requested content-type is some flavor of RDF. I think the reason is because people think it is "too hard" to generate the necessary RDF.  

The purpose of Guid-O-Matic is mostly to show that it is not really that hard to create RDF.  Anybody who can create a spreadsheet or a [Darwin Core Archive (DwCa)](http://www.gbif.org/resource/80636) can generate RDF with little additional effort.  In production, providers would probably not use spreadsheets as a data source, but the point of Guid-O-Matic is to demonstrate a general strategy and allow users to experiment with different graph structures and play with the generated serializations.

## Why is it called "Guid-O-Matic" and not something like "RDF-Generator-O-Matic"?
Because I already had the cute squid picture and "RDF Generator" doesn't rhyme with "squid".

## Why did you write this script in Xquery and not something like Python or PHP?
I am not a very good Python programmer and I don't know PHP.  Once you understand what Guid-O-Matic does, you can write your own (better) code to do the same thing.

I used Xquery because I'm in a working group that includes a lot of Digital Humanists, and they love XML.  Also, the awesome Xquery processor, BaseX, is free and easily downloaded and installed.  So anybody can easily run the Guid-O-Matic scripts.  Also, BaseX can run as a web server, so in theory, one could call the RDF-generating functions in response to a HTTP request and actually use the scripts to provide RDF online.

## What did Guid-O-Matic 1.1 do?
I wrote Guid-O-Matic 1 in about 2010.  Version 1.1 had a very limited scope:
- it only generated RDF/XML
- it assumed that the focal resource was a specimen
- it assumed that the specimen was depicted by one image
- it was hard-coded to use a specific version of the [Darwin Core](http://rs.tdwg.org/dwc/terms/) and [Darwin-SW](https://github.com/darwin-sw/dsw) vocabularies
- other stuff that I can't remember

Version 1.1 also was written in an old version of Visual Basic, which had the advantage that it could run as an executable, but had the disadvantage that you couldn't hack it unless you had a copy of Visual Basic and knew how to use it.  Even I don't have a functioning copy of that version of Visual Basic, so I can't look at the source code any more.  But it doesn't really matter because I don't advise that anyone try to mess with it anyway.  I'm only posting it here for historical reasons (and so that you can try running it to see the great squid graphic on the UI!).
