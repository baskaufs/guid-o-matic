[back to landing page](README.md)

![](https://raw.githubusercontent.com/baskaufs/guid-o-matic/master/squid.bmp)

Guid-O-Matic

# Getting started with a simple example

This example will walk you through converting CSV files from a simple dataset into RDF.  The data are from the [New York Public Library](https://www.nypl.org/)'s [Photographers' Identities Catalog](http://pic.nypl.org/).  The complete dataset is available under a [Creative Commons CC0](https://creativecommons.org/publicdomain/zero/1.0/deed.en) (public domain) license at [https://github.com/NYPL/pic-data].  The full dataset includes information about over 125 000 photographers and firms, but the example dataset makes use of a subset of only 1000.  

## The dataset

The dataset includes CSV tables describing a number of entities, but in this example, we will focus on two.

![](https://raw.githubusercontent.com/baskaufs/guid-o-matic/master/images/constituent-table.png)

Fig. 1. Table of photographers or studios

The first table, called constituents.csv, contains records about either photographers or studios.  A column in the table (ConstituentID) contains an identifier for the constituent that is unique within the table.  If you are familiar with databases, this identifier serves the purpose of a primary key for the consituent record.

![](https://raw.githubusercontent.com/baskaufs/guid-o-matic/master/images/address-table.png)

Fig. 2. Table of locations

The second table, called address.csv, contains records about locations associated with the constituents.  A column of the table (ConAddressID) contains an identifier for the location that's unique in the table (primary key).  Another column (ConstituentID) gives the identifier for the constituent that is associated with the location described by the row.  In database terms, this column contains a foreign key relating this table to the constituent table.  A single photographer in the constituents table may be associated with birth, activity, and death locations in the address table, so there may be several rows with the same ConstituentID in this table.

![](https://raw.githubusercontent.com/baskaufs/guid-o-matic/master/images/nypl-pic-graph-model.png)

Fig. 3. Graph model for some data from the New York Public Library Photographers' Identities Catalog (PIC)

Our goal is to turn the data in these tables into a Linked Data graph, and Fig. 3 shows the simple graph model that can represent the relationships described above.

One best practice of Linked Data is to identify resources using URIs.  PIC already assigns URIs to constituents by prepending ```http://pic.nypl.org/constituents/ ``` to the value in the ConstituentID column.  For example, the photographer Richard Long has the ConstituentID 148, and the URI http://pic.nypl.org/constituents/148 will dereference to a web page about him.  Using this pattern, we will mint URI identifiers for the locations by prepending ```http://pic.nypl.org/address/``` to the ConAddressID value (e.g. http://pic.nypl.org/address/111242).  Nothing happens if you put this URI in a browser, but that's fine - it's not a requirement of Linked Data that a URI "do" anything.  At its core, a URI is a unique identifier and this scheme serves that purpose.

![](https://raw.githubusercontent.com/baskaufs/guid-o-matic/master/images/nypl-pic-graph-example.png)

Fig. 4. Example graph for the photographer Otto Alfred Wolfgang Schulze Wols

Fig. 4 shows a Linked Data graph about a particular photographer.  The photographer and his birth, work, and death locations are identified by particular URIs. The photographer is linked to a location by the predicate foaf:based_near (http://xmlns.com/foaf/0.1/based_near).  Each of the relationships connecting two bubbles in the diagram can be represented by a single RDF triple.  For example the triple:

```
<http://pic.nypl.org/constituents/20>
 foaf:based_near <http://pic.nypl.org/address/83580>.
```

relates Otto Wols to his birthplace in Berlin, Germany.

## Setting up the mappings of columns to properties




[back to landing page](README.md)
