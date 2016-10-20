VERSION 5.00
Begin VB.Form frmGuidOMatic 
   Caption         =   "Guid-O-Matic"
   ClientHeight    =   7455
   ClientLeft      =   60
   ClientTop       =   390
   ClientWidth     =   8940
   Icon            =   "guid-o-maatic.frx":0000
   LinkTopic       =   "Form1"
   Picture         =   "guid-o-maatic.frx":1272
   ScaleHeight     =   7455
   ScaleWidth      =   8940
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdCreateGuids 
      Caption         =   "Create Guids"
      Height          =   735
      Left            =   5160
      TabIndex        =   1
      Top             =   5160
      Width           =   2175
   End
   Begin VB.TextBox txtRootDirectory 
      Height          =   285
      Left            =   5040
      TabIndex        =   32
      Text            =   "c:\temp\"
      Top             =   4320
      Width           =   3135
   End
   Begin VB.PictureBox Picture1 
      BorderStyle     =   0  'None
      Height          =   3135
      Left            =   5280
      Picture         =   "guid-o-maatic.frx":74FC
      ScaleHeight     =   3135
      ScaleWidth      =   3135
      TabIndex        =   29
      Top             =   120
      Width           =   3135
   End
   Begin VB.TextBox txtDomainName 
      Height          =   285
      Left            =   0
      TabIndex        =   18
      Text            =   "arctos.database.museum"
      Top             =   0
      Width           =   5055
   End
   Begin VB.TextBox txtSpecimenInstitutionCode 
      Height          =   285
      Left            =   0
      TabIndex        =   17
      Text            =   "University of Alaska Museum of the North"
      Top             =   720
      Width           =   5055
   End
   Begin VB.TextBox txtSpecimenInstitutionURI 
      Height          =   285
      Left            =   0
      TabIndex        =   16
      Text            =   "http://biocol.org/urn:lsid:biocol.org:col:34847"
      Top             =   1440
      Width           =   5055
   End
   Begin VB.TextBox txtCopyright 
      Height          =   285
      Left            =   0
      TabIndex        =   15
      Text            =   "(c) 2010 University of Louisiana at Monroe Herbarium"
      Top             =   6120
      Width           =   4935
   End
   Begin VB.TextBox txtImageCreditLine 
      Height          =   285
      Left            =   0
      TabIndex        =   14
      Text            =   "University of Louisiana at Monroe Herbarium http://www.ulm.edu/herbarium/"
      Top             =   6840
      Width           =   6255
   End
   Begin VB.Frame fraLicense 
      Caption         =   "License"
      Height          =   975
      Left            =   0
      TabIndex        =   8
      Top             =   3600
      Width           =   3015
      Begin VB.OptionButton optLicense 
         Caption         =   "Public Domain"
         Height          =   255
         Index           =   0
         Left            =   1560
         TabIndex        =   13
         Top             =   600
         Width           =   1335
      End
      Begin VB.OptionButton optLicense 
         Caption         =   "CC BY"
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   12
         Top             =   360
         Width           =   1335
      End
      Begin VB.OptionButton optLicense 
         Caption         =   "CC BY-SA"
         Height          =   255
         Index           =   2
         Left            =   120
         TabIndex        =   11
         Top             =   600
         Width           =   1335
      End
      Begin VB.OptionButton optLicense 
         Caption         =   "CC BY-NC"
         Height          =   255
         Index           =   3
         Left            =   1560
         TabIndex        =   10
         Top             =   120
         Width           =   1335
      End
      Begin VB.OptionButton optLicense 
         Caption         =   "CC BY-NC-SA"
         Height          =   255
         Index           =   4
         Left            =   1560
         TabIndex        =   9
         Top             =   360
         Value           =   -1  'True
         Width           =   1335
      End
   End
   Begin VB.TextBox txtImageInstitutionURI 
      Height          =   285
      Left            =   0
      TabIndex        =   7
      Text            =   "http://cyberfloralouisiana.com"
      Top             =   2880
      Width           =   5055
   End
   Begin VB.TextBox txtMetadataLanguage 
      Height          =   285
      Left            =   3360
      TabIndex        =   6
      Text            =   "en"
      Top             =   3720
      Width           =   375
   End
   Begin VB.TextBox txtImageInstitutionCode 
      Height          =   285
      Left            =   0
      TabIndex        =   5
      Text            =   "CyberFlora Louisiana"
      Top             =   2160
      Width           =   5055
   End
   Begin VB.TextBox txtLogoURL 
      Height          =   285
      Left            =   0
      TabIndex        =   4
      Text            =   "http://cyberfloralouisiana.com/images/CyberFlora252pixtall.png"
      Top             =   4680
      Width           =   5055
   End
   Begin VB.TextBox txtAttributionURL 
      Height          =   285
      Left            =   0
      TabIndex        =   3
      Text            =   "http://cyberfloralouisiana.com/index.html"
      Top             =   5400
      Width           =   5055
   End
   Begin VB.CommandButton cmdSaveSettings 
      Caption         =   "Save these settings"
      Height          =   495
      Left            =   5400
      TabIndex        =   2
      Top             =   5400
      Visible         =   0   'False
      Width           =   2175
   End
   Begin VB.CommandButton cmdQuit 
      Caption         =   "Save changes and quit"
      Height          =   735
      Left            =   5160
      TabIndex        =   0
      Top             =   6000
      Width           =   2175
   End
   Begin VB.Label Label2 
      Caption         =   "for specimens"
      Height          =   255
      Left            =   5160
      TabIndex        =   34
      Top             =   3720
      Width           =   1455
   End
   Begin VB.Label lblRootDirectory 
      Caption         =   "Root web directory"
      Height          =   255
      Left            =   5280
      TabIndex        =   33
      Top             =   4680
      Width           =   2775
   End
   Begin VB.Label Label1 
      Caption         =   """You can write better software than this..."""
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   4920
      TabIndex        =   31
      Top             =   3960
      Width           =   3735
   End
   Begin VB.Label lblSquid 
      Caption         =   "Guid-O-Matic 2.2"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   21.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   5040
      TabIndex        =   30
      Top             =   3240
      Width           =   3495
   End
   Begin VB.Label lblDomainName 
      Caption         =   "Domain name"
      Height          =   255
      Left            =   0
      TabIndex        =   28
      Top             =   360
      Width           =   3015
   End
   Begin VB.Label lblSpecimenInstitutionCode 
      Caption         =   "Specimen Institution Code"
      Height          =   255
      Left            =   0
      TabIndex        =   27
      Top             =   1080
      Width           =   3015
   End
   Begin VB.Label lblSpecimenInstitutionURI 
      Caption         =   "Specimen Institution URI"
      Height          =   255
      Left            =   0
      TabIndex        =   26
      Top             =   1800
      Width           =   3015
   End
   Begin VB.Label lblCopyright 
      Caption         =   "Image Copyright Statement"
      Height          =   255
      Left            =   0
      TabIndex        =   25
      Top             =   6480
      Width           =   3015
   End
   Begin VB.Label lblImageCreditLine 
      Caption         =   "Image Credit Line"
      Height          =   255
      Left            =   0
      TabIndex        =   24
      Top             =   7200
      Width           =   3015
   End
   Begin VB.Label lblImageCollectionURI 
      Caption         =   "Image Collection URI"
      Height          =   255
      Left            =   0
      TabIndex        =   23
      Top             =   3240
      Width           =   4695
   End
   Begin VB.Label lblMetadataLanguage 
      Caption         =   "Metadata language"
      Height          =   255
      Left            =   3360
      TabIndex        =   22
      Top             =   4080
      Width           =   1815
   End
   Begin VB.Label lblImageInstitutionCode 
      Caption         =   "Image Institution Code"
      Height          =   255
      Left            =   0
      TabIndex        =   21
      Top             =   2520
      Width           =   2175
   End
   Begin VB.Label lblLogoURL 
      Caption         =   "Attribution Logo URL"
      Height          =   255
      Left            =   0
      TabIndex        =   20
      Top             =   5040
      Width           =   2295
   End
   Begin VB.Label lblAttributionURL 
      Caption         =   "Attribution URL"
      Height          =   255
      Left            =   0
      TabIndex        =   19
      Top             =   5760
      Width           =   2175
   End
End
Attribute VB_Name = "frmGuidOMatic"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim DetLocalIdentifier$(), TSNID$(), IdentifiedBy$(), DateIdentified$(), IdentificationRemarks$(), Family$(), Genus$(), SpecificEpithet$(), InfraspecificEpithet$(), TaxonRank$(), ScientificNameAuthorship$()
Dim CurrentLicenseType, ValidClickEvent, NDeterminations

Private Sub Form_Load()
' Version 2.2 updates to darwin-sw version 0.3 2013-09-23  Image and individual part not done
' Version 2.1 updates to current version of darwin-sw as of 2013-03
' Version 2.0 changes the model to the darwin-sw model
' Note: version 1.1 corrects "rdfs:type" error.
' Turn on error handling to detect the "File not found" condition if this is a new
'implementation and the default file hasn't been set up
On Error GoTo trap
Open "guid-o-matic-defaults.txt" For Input As #1
' Turn off error handling since this program isn't really bullet-proof
On Error GoTo 0

Line Input #1, T$
txtDomainName.Text = T$
Line Input #1, T$
txtSpecimenInstitutionCode.Text = T$
Line Input #1, T$
txtSpecimenInstitutionURI.Text = T$
Line Input #1, T$
txtImageInstitutionCode.Text = T$
Line Input #1, T$
txtImageInstitutionURI.Text = T$

Line Input #1, CurrentLicenseType
' Preven a bogus click event
ValidClickEvent = False
optLicense(CurrentLicenseType).Value = True
ValidClickEvent = True
    
Line Input #1, T$
txtMetadataLanguage.Text = T$
Line Input #1, T$
txtLogoURL.Text = T$
Line Input #1, T$
txtAttributionURL.Text = T$
Line Input #1, T$
txtCopyright.Text = T$
Line Input #1, T$
txtImageCreditLine.Text = T$
Line Input #1, T$
txtRootDirectory.Text = T$

Close #1

Exit Sub

'This is an error trap whose sole purpose is to handle a "File not found" error if this
'is the first time the program is run and there are no default settings
trap:

' Open up the file and save the default values from the screen
Open "guid-o-matic-defaults.txt" For Output As #1

Print #1, txtDomainName.Text
Print #1, txtSpecimenInstitutionCode.Text
Print #1, txtSpecimenInstitutionURI.Text
Print #1, txtImageInstitutionCode.Text
Print #1, txtImageInstitutionURI.Text
Print #1, 4     'License value for CC BY-NC-SA
Print #1, txtMetadataLanguage.Text
Print #1, txtLogoURL.Text
Print #1, txtAttributionURL.Text
Print #1, txtCopyright.Text
Print #1, txtImageCreditLine.Text
Print #1, txtRootDirectory.Text

Close #1
' return to the input routine and input these values that were just written

Resume

End Sub

Private Sub cmdSaveSettings_Click()
Open "guid-o-matic-defaults.txt" For Output As #1

Print #1, txtDomainName.Text
Print #1, txtSpecimenInstitutionCode.Text
Print #1, txtSpecimenInstitutionURI.Text
Print #1, txtImageInstitutionCode.Text
Print #1, txtImageInstitutionURI.Text
Print #1, CurrentLicenseType
Print #1, txtMetadataLanguage.Text
Print #1, txtLogoURL.Text
Print #1, txtAttributionURL.Text
Print #1, txtCopyright.Text
Print #1, txtImageCreditLine.Text
Print #1, txtRootDirectory.Text

Close #1
End Sub

Private Sub cmdCreateGuids_Click()

Quote$ = Chr$(34)

Open "c:/guid-o-matic-determinations.csv" For Input As #1
Input #1, NDeterminations
Line Input #1, T$   'Read in the rest of the header line and do nothing with it
ReDim DetLocalIdentifier$(NDeterminations), TSNID$(NDeterminations), IdentifiedBy$(NDeterminations), DateIdentified$(NDeterminations), IdentificationRemarks$(NDeterminations), Family$(NDeterminations), Genus$(NDeterminations), SpecificEpithet$(NDeterminations), InfraspecificEpithet$(NDeterminations), TaxonRank$(NDeterminations), ScientificNameAuthorship$(NDeterminations)
For Determination = 1 To NDeterminations
    Input #1, T1$, T2$, TSNID$(Determination), IdentifiedBy$(Determination), DateIdentified$(Determination), IdentificationRemarks$(Determination), Family$(Determination), Genus$(Determination), SpecificEpithet$(Determination), InfraspecificEpithet$(Determination), TaxonRank$(Determination), ScientificNameAuthorship$(Determination)
    DetLocalIdentifier$(Determination) = T1$ + "/" + T2$
Next Determination

Close #1

Open "c:/guid-o-matic-specimens.csv " For Input As #1
Input #1, NSpecimens
Line Input #1, T$       'Read in the rest of the first line (headers) and do nothing with them

For specimen = 1 To NSpecimens
    ' Read in the elements that vary among specimens
    Input #1, IndividualGUID$, namespace$, identifier$, CatalogNumber$, OccurrenceRemarks$, RecordedBy$, RecordNumber$, EventDate$, DecimalLatitude$, DecimalLongitude$, GeodeticDatum$, GeoAlt$, CoordinateUncertaintyInMeters$, GeoreferenceRemarks$, Continent$, CountryCode$, StateProvince$, County$, Locality$, created$, BQAccessURL$, BQImageWidth$, BQImageHeight$, BQXSamplingFrequency$, GQAccessURL$, GQImageWidth$, GQImageHeight$, LQAccessURL$, LQImageWidth$, LQImageHeight$, TNAccessURL$, TNImageWidth$, TNImageHeight$
      
    BaseGUID$ = "http://" + txtDomainName.Text + "/" + namespace$ + "/" + identifier$
    localidentifier$ = namespace$ + "/" + identifier$
        
    ' Open the RDF file
    Open txtRootDirectory.Text + namespace$ + "\" + identifier$ + ".rdf" For Output As #2
    Print #2, "<?xml version="; Quote$; "1.0"; Quote$; " encoding="; Quote$; "UTF-8"; Quote$; "?>"
    Print #2, "<?xml-stylesheet type="; Quote$; "text/xsl"; Quote$; " href="; Quote$; "../guid-o-matic.xsl"; Quote$; "?>"
    
    ' Information about the organizational structure of the RDF and how it was created
    Print #2, "<!-- "
    Print #2, "This RDF is structured as described at http://code.google.com/p/darwin-sw/ "
    Print #2, "It was generated by Guid-O-Matic 2.2 (http://bioimages.vanderbilt.edu/guid-o-matic/index.htm)"
    Print #2, "-->"
    ' RDF container opening tag.  The namespace definitions include every possible one that might be used in the RDF
    Print #2, "<rdf:RDF xmlns:rdf="; Quote$; "http://www.w3.org/1999/02/22-rdf-syntax-ns#"; Quote$
    Print #2, "xmlns:rdfs="; Quote$; "http://www.w3.org/2000/01/rdf-schema#"; Quote$
    Print #2, "xmlns:dc="; Quote$; "http://purl.org/dc/elements/1.1/"; Quote$
    Print #2, "xmlns:dcterms="; Quote$; "http://purl.org/dc/terms/"; Quote$
    Print #2, "xmlns:dwc="; Quote$; "http://rs.tdwg.org/dwc/terms/"; Quote$
    Print #2, "xmlns:dwcuri="; Quote$; "http://rs.tdwg.org/dwc/uri/"; Quote$
    Print #2, "xmlns:owl="; Quote$; "http://www.w3.org/2002/07/owl#"; Quote$
    Print #2, "xmlns:dsw="; Quote$; "http://purl.org/dsw/"; Quote$
    Print #2, "xmlns:ac="; Quote$; "http://rs.tdwg.org/ac/terms/"; Quote$
    Print #2, "xmlns:xmp="; Quote$; "http://ns.adobe.com/xap/1.0/"; Quote$
    Print #2, "xmlns:xmpRights="; Quote$; "http://ns.adobe.com/xap/1.0/rights/"; Quote$
    Print #2, "xmlns:Iptc4xmpExt="; Quote$; "http://iptc.org/std/Iptc4xmpExt/2008-02-29/"; Quote$
    Print #2, "xmlns:mbank="; Quote$; "http://www.morphbank.net/schema/morphbank#"; Quote$
    Print #2, "xmlns:mix="; Quote$; "http://www.loc.gov/mix/v20"; Quote$
    Print #2, "xmlns:bibo="; Quote$; "http://purl.org/ontology/bibo/"; Quote$
    Print #2, "xmlns:foaf="; Quote$; "http://xmlns.com/foaf/0.1/"; Quote$
    Print #2, "xmlns:geo="; Quote$; "http://www.w3.org/2003/01/geo/wgs84_pos#"; Quote$
    Print #2, ">"
        
    If IndividualGUID$ = "" Then ' If there is a IndividualGUID$ then a link will be created later rather than the actual metadata
        'Individual container element
        Print #2, "<rdf:Description rdf:about="; Quote$; BaseGUID$ + "#ind"; Quote$; ">"
        Print #2, "     <mrtg:metadataLanguage>" + txtMetadataLanguage.Text + "</mrtg:metadataLanguage>"
        Print #2, "     <!--Basic information about the individual-->"
        
        LatestDet = 0
        Test$ = "0000"
        For Determination = 1 To NDeterminations
            If DetLocalIdentifier$(Determination) = localidentifier$ Then
                If DateIdentified$(Determination) > Test$ Then LatestDet = Determination
            End If
        Next Determination
        Print #2, "     <dcterms:description>Field individual of "; Genus$(LatestDet); " "; SpecificEpithet$(LatestDet);
        Select Case TaxonRank$(LatestDet)
            Case "varietas"
                Print #2, " var. "; InfraspecificEpithet$(LatestDet);
            Case "subspecies"
                Print #2, " ssp. "; InfraspecificEpithet$(LatestDet);
        End Select
        Print #2, " with GUID: "; BaseGUID$; "#ind</dcterms:description>"
        Print #2, "     <!-- Currently there is no Darwin Core class for individuals that can be used as"
        Print #2, "     a value for rdf:type.  As a temporary measure, I defined a class for individuals"
        Print #2, "     and used that class to type the individuals here.-->"
        Print #2, "     <rdf:type rdf:resource =" + Quote$ + "http://bioimages.vanderbilt.edu/rdf/terms#Individual" + Quote$ + " />"
        Print #2, "     <dcterms:type rdf:resource =" + Quote$ + "http://purl.org/dc/dcmitype/PhysicalObject" + Quote$ + " />"
        Print #2, "     <dwc:establishmentMeans>"; EstablishmentMeans$; "</dwc:establishmentMeans>"
        If IndividualRemarks$ <> "" Then
            Print #2, "     <dsw:individualRemarks>"; IndividualRemarks$; "</dsw:individualRemarks>"
        End If
    
        Print #2, ""
        
        Print #2, "     <!-- Relationships of the individual to other resources.  -->"
        Print #2, "     <dsw:hasDerivative rdf:resource="; Quote$; BaseGUID$; Quote$; "/>"
        Print #2, "     <dcterms:hasPart rdf:resource=" + Quote$ + BaseGUID$ + Quote$ + " />"
        Print #2, ""
        Print #2, "     <!-- Determinations applied to the individual-->"
        For Determination = 1 To NDeterminations
            If DetLocalIdentifier$(Determination) = localidentifier$ Then
                Print #2, "     <dwc:identificationID rdf:resource="; Quote$ + BaseGUID$ + "#" + TSNID$(Determination) + Quote$; " />"
            End If
        Next Determination
        ' closing tag for the individual
        Print #2, "</rdf:Description>"
        Print #2, ""
        
        ' now create the rdf for each determination
        For Determination = 1 To NDeterminations
            If DetLocalIdentifier$(Determination) = localidentifier$ Then
                ' identification property elements
                Print #2, "<rdf:Description rdf:about="; Quote$ + BaseGUID$ + "#" + TSNID$(Determination) + Quote$; ">"
                
                Print #2, "     <!-- Basic information about the determination -->"
                Print #2, "     <dcterms:description>Determination of "; Genus$(Determination); " "; SpecificEpithet$(Determination);
                Select Case TaxonRank$(Determination)
                    Case "varietas"
                        Print #2, " var. "; InfraspecificEpithet$(Determination);
                    Case "subspecies"
                        Print #2, " ssp. "; InfraspecificEpithet$(Determination);
                End Select
                Print #2, " for the individual "; BaseGUID$ + "#" + TSNID$(Determination); "</dcterms:description>"
                Print #2, "     <rdf:type rdf:resource =" + Quote$ + "http://rs.tdwg.org/dwc/terms/Identification" + Quote$ + " />"
                Print #2, "     <dwc:identifiedBy>"; IdentifiedBy$(Determination); "</dwc:identifiedBy>"
                Print #2, "     <dwc:dateIdentified>"; DateIdentified$(Determination); "</dwc:dateIdentified>"
                If IdentificationRemarks$(Determination) <> "" Then
                    Print #2, "     <dwc:identificationRemarks>"; IdentificationRemarks$(Determination); "</dwc:identificationRemarks>"
                End If
                Print #2, ""
                Print #2, "     <!-- Relationship of the determination to other resources -->"
                Print #2, "     <dsw:identifies rdf:resource="; Quote$; BaseGUID$ + "#ind"; Quote$; "/>"
                Print #2, "     <dsw:identifiedBasedOn rdf:resource="; Quote$; BaseGUID$; Quote$; "/>"
                Print #2, ""
                'Print #2, "     <!-- Direct literals for the determination can be found here without resolving a scientificNameID -->"
                'Print #2, "     <dwc:family>"; Family$(Determination); "</dwc:family>"
                'Print #2, "     <dwc:genus>"; Genus$(Determination); "</dwc:genus>"
                'Print #2, "     <dwc:specificEpithet>"; SpecificEpithet$(Determination); "</dwc:specificEpithet>"
                'If InfraspecificEpithet$(Determination) <> "" Then Print #2, "     <dwc:infraspecificEpithet>"; InfraspecificEpithet$(Determination); "</dwc:infraspecificEpithet>"
                'Print #2, "     <dwc:taxonRank>"; TaxonRank$(Determination); "</dwc:taxonRank>"
                'Print #2, "     <dwc:scientificNameAuthorship>"; ScientificNameAuthorship$(Determination); "</dwc:scientificNameAuthorship>"
    
                ' determination container closing tag
                Print #2, "</rdf:Description>"
            End If
        Next Determination
        Print #2, ""
    End If

    'Specimen container element
    Print #2, "<rdf:Description rdf:about="; Quote$; BaseGUID$; Quote$; ">"
    Print #2, "     <!--Basic information about the specimen-->"
    
    If IndividualGUID$ = "" Then
        Print #2, "     <dcterms:description>Preserved specimen of "; Genus$(LatestDet); " "; SpecificEpithet$(LatestDet);
        Select Case TaxonRank$(LatestDet)
            Case "varietas"
                Print #2, " var. "; InfraspecificEpithet$(LatestDet);
            Case "subspecies"
                Print #2, " ssp. "; InfraspecificEpithet$(LatestDet);
        End Select
    Else
        Print #2, "     <dcterms:description>Preserved specimen from the individual organism "; IndividualGUID$;
    End If
    Print #2, "</dcterms:description>"
    Print #2, "     <rdf:type rdf:resource =" + Quote$ + "http://rs.tdwg.org/dwc/dwctype/PreservedSpecimen" + Quote$ + " />"
    Print #2, "     <dcterms:type rdf:resource =" + Quote$ + "http://purl.org/dc/dcmitype/PhysicalObject" + Quote$ + " />"
    'Print #2, "     <dcterms:identifier>"; BaseGUID$; "</dcterms:identifier>"
    Print #2, "     <dc:creator>"; txtSpecimenInstitutionCode.Text; "</dc:creator>"
    Print #2, "     <dcterms:creator rdf:resource="; Quote$; txtSpecimenInstitutionURI.Text; Quote$; "/>"
    Print #2, "     <dcterms:created>"; EventDate$; "</dcterms:created>"
    Print #2, "     <dwcuri:inCollection rdf:resource =" + Quote$ + txtSpecimenInstitutionURI.Text + Quote$ + " />"
    'Print #2, "     <dwc:institutionCode>" + txtSpecimenInstitutionCode.Text + "</dwc:institutionCode>"
    'Print #2, "     <dwc:catalogNumber>" + CatalogNumber$ + "</dwc:catalogNumber>"
    
    Print #2, "     <!-- Relationships of the specimen to other resources -->"
    If IndividualGUID$ = "" Then
        Print #2, "     <dsw:derivedFrom rdf:resource=" + Quote$ + BaseGUID$ + "#ind" + Quote$ + " />"
        Print #2, "     <dcterms:isPartOf rdf:resource=" + Quote$ + BaseGUID$ + "#ind" + Quote$ + " />"
    Else
        Print #2, "     <dsw:derivedFrom rdf:resource=" + Quote$ + IndividualGUID$ + Quote$ + " />"
        Print #2, "     <dcterms:isPartOf rdf:resource=" + Quote$ + IndividualGUID$ + Quote$ + " />"
    End If
    Print #2, "     <dsw:evidenceFor rdf:resource=" + Quote$ + BaseGUID$ + "#occ" + Quote$ + " />"
    Print #2, "     <foaf:isPrimaryTopicOf rdf:resource="; Quote$; BaseGUID$ + ".rdf"; Quote$; " />"

    ' Don't create image links if there isn't at least a hires image
    If BQAccessURL$ <> "" Then
        Print #2, "     <foaf:depiction rdf:resource="; Quote$; BaseGUID$; "#img"; ; Quote$; "/>"
    End If
    If IndividualGUID$ = "" Then    'If the individual organism is defined elsewhere, then the determination structure is not known
        For Determination = 1 To NDeterminations
            If DetLocalIdentifier$(Determination) = localidentifier$ Then
                Print #2, "     <sernec:isBasisForIdentification rdf:resource=" + Quote$ + BaseGUID$ + "#" + TSNID$(Determination) + Quote$ + " />"
            End If
        Next Determination
    End If
    ' specimen container closing tag
    Print #2, "</rdf:Description>"
    
    ' Occurrence container element
    Print #2, "<rdf:Description rdf:about="; Quote$; BaseGUID$; "#occ"; Quote$; ">"
    Print #2, "     <rdf:type rdf:resource =" + Quote$ + "http://rs.tdwg.org/dwc/dwctype/Occurrence" + Quote$ + " />"
    If IndividualGUID$ = "" Then
        Print #2, "     <dsw:occurrenceOf rdf:resource=" + Quote$ + BaseGUID$ + "#ind" + Quote$ + " />"
    Else
        Print #2, "     <dsw:occurrenceOf rdf:resource=" + Quote$ + IndividualGUID$ + Quote$ + " />"
    End If
    Print #2, "     <dsw:hasEvidence rdf:resource=" + Quote$ + BaseGUID$ + Quote$ + " />"
    Print #2, "     <dwc:recordedBy>"; RecordedBy$; "</dwc:recordedBy>"
    Print #2, "     <dwc:recordNumber>"; RecordNumber$; "</dwc:recordNumber>"
    If OccurrenceRemarks$ <> "" Then
        Print #2, "     <dwc:occurrenceRemarks>" + OccurrenceRemarks$ + "</dwc:occurrenceRemarks>"
    End If
    
    Print #2, "     <dsw:atEvent>"
    Print #2, "         <rdf:Description rdf:about="; Quote$; BaseGUID$; "#eve"; Quote$; ">"
    Print #2, "             <dwc:eventDate>" + EventDate$ + "</dwc:eventDate>"
    Print #2, "             <rdf:type rdf:resource =" + Quote$ + "http://purl.org/dc/dcmitype/Event" + Quote$ + " />"
    Print #2, "             <dsw:eventOf rdf:resource =" + Quote$ + BaseGUID$; "#occ"; Quote$; "/>"
    Print #2, "             <dsw:locatedAt>"
    Print #2, "                 <rdf:Description rdf:about="; Quote$; BaseGUID$; "#loc"; Quote$; ">"
    Print #2, "                     <rdf:type rdf:resource =" + Quote$ + "http://purl.org/dc/terms/Location" + Quote$ + " />"
    Print #2, "                     <dsw:locates rdf:resource =" + Quote$ + BaseGUID$; "#eve"; Quote$; "/>"
    ' Leave out the georeference terms if there isn't a decimal latitude
    If DecimalLatitude$ <> "" Then
        If GeodeticDatum$ = "EPSG:4326" Then
            Print #2, "                     <geo:lat>" + DecimalLatitude$ + "</geo:lat>"
            Print #2, "                     <geo:long>" + DecimalLongitude$ + "</geo:long>"
        End If
        Print #2, "                     <dwc:decimalLatitude rdf:datatype=" + Quote$ + "http://www.w3.org/2001/XMLSchema#decimal" + Quote$ + ">" + DecimalLatitude$ + "</dwc:decimalLatitude>"
        Print #2, "                     <dwc:decimalLongitude rdf:datatype=" + Quote$ + "http://www.w3.org/2001/XMLSchema#decimal" + Quote$ + ">" + DecimalLongitude$ + "</dwc:decimalLongitude>"
        Print #2, "                     <dwc:geodeticDatum>" + GeodeticDatum$ + "</dwc:geodeticDatum>"
        
        If GeoAlt$ <> "" Then
            If GeodeticDatum$ = "EPSG:4326" Then
                Print #2, "                     <geo:alt>" + GeoAlt$ + "</geo:alt>"
            End If
            Print #2, "                     <dwc:minimumElevationInMeters rdf:datatype=" + Quote$ + "http://www.w3.org/2001/XMLSchema#int" + Quote$ + ">" + GeoAlt$ + "</dwc:minimumElevationInMeters>"
            Print #2, "                     <dwc:maximumElevationInMeters rdf:datatype=" + Quote$ + "http://www.w3.org/2001/XMLSchema#int" + Quote$ + ">" + GeoAlt$ + "</dwc:maximumElevationInMeters>"
        End If
        Print #2, "                     <dwc:coordinateUncertaintyInMeters rdf:datatype=" + Quote$ + "http://www.w3.org/2001/XMLSchema#int" + Quote$ + ">" + CoordinateUncertaintyInMeters$ + "</dwc:coordinateUncertaintyInMeters>"
        Print #2, "                     <dwc:georeferenceRemarks xml:lang=" + Quote$ + "en" + Quote$; ">" + GeoreferenceRemarks$ + "</dwc:georeferenceRemarks>"
    End If
    Print #2, "                     <dwc:continent>" + Continent$ + "</dwc:continent>"
    Print #2, "                     <dwc:countryCode>" + CountryCode$ + "</dwc:countryCode>"
    Print #2, "                     <dwc:stateProvince>" + StateProvince$ + "</dwc:stateProvince>"
    Print #2, "                     <dwc:county>" + County$ + "</dwc:county>"
    Print #2, "                     <dwc:locality>" + Locality$ + "</dwc:locality>"
    Print #2, "                 </rdf:Description>"
    Print #2, "             </dsw:locatedAt>"
    Print #2, "         </rdf:Description>"
    Print #2, "     </dsw:atEvent>"
    Print #2, "</rdf:Description>"
    Print #2, ""
    
    ' Skip the image metadata section if there isn't at least a hires image
    If BQAccessURL$ <> "" Then
        Print #2, "<rdf:Description rdf:about="; Quote$; BaseGUID$ + "#img"; Quote$; ">"
        Print #2, "     <mrtg:metadataLanguage>" + txtMetadataLanguage.Text + "</mrtg:metadataLanguage>"
        Print #2, "     <!--Basic information about the image-->"
        Print #2, "     <dcterms:creator>"
        Print #2, "          <rdf:Description rdf:about="; Quote$; txtSpecimenInstitutionURI.Text; Quote$; ">"
        Print #2, "               <rdfs:label>"; txtSpecimenInstitutionCode.Text; "</rdfs:label>"
        Print #2, "          </rdf:Description>"
        Print #2, "     </dcterms:creator>"
        Print #2, "     <dcterms:created>"; created$; "</dcterms:created>"
        Print #2, "     <rdf:type rdf:resource =" + Quote$ + "http://rs.tdwg.org/dwc/terms/Occurrence" + Quote$ + " />"
        Print #2, "     <dcterms:type rdf:resource =" + Quote$ + "http://purl.org/dc/dcmitype/StillImage" + Quote$ + " />"
        Print #2, "     <!-- DigitalStillImage does not have a normative URI because it is not (yet) an accepted DwC type -->"
        Print #2, "     <dwc:basisOfRecord>DigitalStillImage</dwc:basisOfRecord>"
        ' Note: Specimens images don't document distribution
        'Print #2, "     <sernec:documentsDistribution>false</sernec:documentsDistribution>"
        Print #2, "     <dwc:institutionCode>" + txtSpecimenInstitutionCode.Text + "</dwc:institutionCode>"
        Print #2, "     <dwc:collectionID rdf:resource =" + Quote$ + txtSpecimenInstitutionURI.Text + Quote$ + " />"
            
        Print #2, "     <!--Other properties of the image related to intellectual property rights, use and attribution guidelines, etc. -->"
        Print #2, "     <dcterms:rights>";
            ' if in public domain, over-ride existing value and make this "public domain"
            If CurrentLicenseType = 0 Then
                Print #2, "Image in the public domain";
            Else
                Print #2, txtCopyright.Text;
            End If
        Print #2, "</dcterms:rights>"
    
        Print #2, "     <xmpRights:owner>"
        Print #2, "          <rdf:Description rdf:about="; Quote$; txtSpecimenInstitutionURI.Text; Quote$; " >"
        Print #2, "               <rdfs:label>"; txtSpecimenInstitutionCode.Text; "</rdfs:label>"
        Print #2, "          </rdf:Description>"
        Print #2, "     </xmpRights:owner>"
        Print #2, "     <Iptc4xmpExt:creditLine>"; txtImageCreditLine.Text; "</Iptc4xmpExt:creditLine>"
        Print #2, "     <mbank:view>77407</mbank:view>" 'This is the view for herbarium specimens
        Print #2, "     <Iptc4xmpExt:CVterm rdf:resource =" + Quote$ + "http://bioimages.vanderbilt.edu/rdf/stdview#000000" + Quote$ + " />"
        Print #2, "     <dcterms:title>Preserved specimen of "; Genus$(LatestDet); " "; SpecificEpithet$(LatestDet);
        Select Case TaxonRank$(LatestDet)
            Case "varietas"
                Print #2, " var. "; InfraspecificEpithet$(LatestDet);
            Case "subspecies"
                Print #2, " ssp. "; InfraspecificEpithet$(LatestDet);
        End Select
        Print #2, "</dcterms:title>"
        
        Select Case CurrentLicenseType
            Case 0
                ut$ = "License not required (in the public domain)"
                ws$ = "http://creativecommons.org/licenses/publicdomain/"
            Case 1
                ut$ = "Available under Creative Commons Attribution 3.0 license"
                ws$ = "http://creativecommons.org/licenses/by/3.0/us/"
            Case 2
                ut$ = "Available under Creative Commons Attribution-Share Alike 3.0 license"
                ws$ = "http://creativecommons.org/licenses/by-sa/3.0/us/"
            Case 3
                ut$ = "Available under Creative Commons Attribution-Noncommercial 3.0 license"
                ws$ = "http://creativecommons.org/licenses/by-nc/3.0/us/"
            Case 4
                ut$ = "Available under Creative Commons Attribution-Noncommercial-Share Alike 3.0 license"
                ws$ = "http://creativecommons.org/licenses/by-nc-sa/3.0/us/"
        End Select
        Print #2, "     <xmpRights:UsageTerms>"; ut$; "</xmpRights:UsageTerms>"
        Print #2, "     <xmpRights:WebStatement>"; ws$; "</xmpRights:WebStatement>"
    
        Print #2, "     <dcterms:description>Image of a "; Genus$(LatestDet); " "; SpecificEpithet$(LatestDet);
        Select Case TaxonRank$(LatestDet)
            Case "varietas"
                Print #2, " var. "; InfraspecificEpithet$(LatestDet);
            Case "subspecies"
                Print #2, " ssp. "; InfraspecificEpithet$(LatestDet);
        End Select
        Print #2, " specimen</dcterms:description>"
    
        Print #2, "     <mrtg:attributionLinkURL>"; txtAttributionURL.Text; "</mrtg:attributionLinkURL>"
        Print #2, "     <mrtg:attributionLogoURL>"; txtLogoURL.Text; "</mrtg:attributionLogoURL>"
        Print #2, "     <sernec:sernecImageCollectionStatus>0</sernec:sernecImageCollectionStatus>"
        Print #2, "     <xmp:rating>5</xmp:rating>"
        Print #2, ""
        Print #2, "     <!-- Relationships of the image to other resources.  -->"
        Print #2, "     <dwc:individualID rdf:resource=" + Quote$ + BaseGUID$ + "#ind" + Quote$ + " />"
        Print #2, "     <sernec:derivedFrom rdf:resource=" + Quote$ + BaseGUID$ + Quote$ + " />"
        Print #2, "     <foaf:depicts rdf:resource=" + Quote$ + BaseGUID$ + Quote$ + " />"
    
        For sap = 1 To 4
            Print #2, "     <mrtg:hasServiceAccessPoint rdf:resource="; Quote$;
          
            Select Case sap
                Case 1
                    T$ = "bq"
                Case 2
                    T$ = "tn"
                Case 3
                    T$ = "lq"
                Case 4
                    T$ = "gq"
            End Select
            Print #2, BaseGUID$ + "#" + T$; Quote$; " />"
        Next sap
            
        ' image container closing tag/end of line
        Print #2, "</rdf:Description>"
        Print #2, ""
        
    Print #2, "<!--"
    Print #2, "ServiceAccessPoints provide information about alternative versions of the image having different resolutions"
    Print #2, "-->"
        
    'Service Access Points for the image
    ' I'm supporting four sizes of image: bestQuality (original),thumbnail,lowerQuality, and goodQuality
    For sap = 1 To 4
        ' Test whether there is a SAP for a particular variant type
        Select Case sap
            Case 1
                URL$ = BQAccessURL$
            Case 2
                URL$ = TNAccessURL$
            Case 3
                URL$ = LQAccessURL$
            Case 4
                URL$ = GQAccessURL$
        End Select
        If URL$ <> "" Then
            ' Service Access Point property elements
            
            ' Service Access Point container opening tag
            Select Case sap
                Case 1
                    T$ = "bq"
                Case 2
                    T$ = "tn"
                Case 3
                    T$ = "lq"
                Case 4
                    T$ = "gq"
            End Select
            Print #2, "<mrtg:hasServiceAccessPoint rdf:about="; Quote$; BaseGUID$ + "#"; T$; Quote$; ">"
    
            Select Case sap
                Case 1
                    T$ = "Best Quality"
                Case 2
                    T$ = "Thumbnail"
                Case 3
                    T$ = "Lower Quality"
                Case 4
                    T$ = "Good Quality"
            End Select
            Print #2, "     <mrtg:variant>"; T$; "</mrtg:variant>"
    
            Print #2, "     <mrtg:accessURL>"; URL$; "</mrtg:accessURL>"
    
            Select Case Right$(LCase$(URL$), 3)
                Case "jpg", "jpe"
                    T1$ = "image/jpeg"
                Case "gif"
                    T1$ = "image/gif"
                Case "bmp"
                    T1$ = "image/bmp"
                Case "tif"
                    T1$ = "image/tiff"
                Case Else
                    T1$ = "unknown"
            End Select
            Print #2, "     <dcterms:format>"; T1$; "</dcterms:format>"
    
            Select Case sap
                Case 1  'full size
                    T$ = BQImageWidth$
                Case 2  'thumbnail
                    T$ = TNImageWidth$
                Case 3  'low quality
                    T$ = LQImageWidth$
                Case 4  'good quality
                    T$ = GQImageWidth$
            End Select
            Print #2, "     <mix:imageWidth>"; T$; "</mix:imageWidth>"
    
            Select Case sap
                Case 1  'full size
                    T$ = BQImageHeight$
                Case 2  'thumbnail
                    T$ = TNImageHeight$
                Case 3  'low quality
                    T$ = LQImageHeight$
                Case 4  'good quality
                    T$ = GQImageHeight$
            End Select
            Print #2, "     <mix:imageHeight>"; T$; "</mix:imageHeight>"
            
            ' Note: it is assumed that the X and Y pixels have the same size
            If BQXSamplingFrequency$ <> "" Then
                Select Case sap
                    Case 1  'full size
                        T$ = BQXSamplingFrequency$
                    Case 2  'thumbnail
                        T$ = LTrim$(Str$(Int(Val(TNImageHeight$) / Val(BQImageHeight$) * Val(BQXSamplingFrequency$) + 0.5)))
                    Case 3  'low quality
                        T$ = LTrim$(Str$(Int(Val(LQImageHeight$) / Val(BQImageHeight$) * Val(BQXSamplingFrequency$) + 0.5)))
                    Case 4  'good quality
                        T$ = LTrim$(Str$(Int(Val(GQImageHeight$) / Val(BQImageHeight$) * Val(BQXSamplingFrequency$) + 0.5)))
                End Select
                Print #2, "     <mix:xSamplingFrequency>"; T$; "</mix:xSamplingFrequency>"
                Print #2, "     <mix:ySamplingFrequency>"; T$; "</mix:ySamplingFrequency>"
                Print #2, "     <mix:samplingFrequencyUnit>cm</mix:samplingFrequencyUnit>"
            End If
    
            ' service access point container closing tag/end of row
            Print #2, "</mrtg:hasServiceAccessPoint>"
        End If
    Next sap
    End If
    Print #2, ""
    '---------------------------------
    
' metadata about the rdf file itself
    Print #2, "<!--"
    Print #2, "Information about the metadata document itself"
    Print #2, "-->"
    
    Print #2, "<rdf:Description rdf:about="; Quote$; BaseGUID$ + ".rdf"; Quote$; ">"
    Print #2, "     <dcterms:description>RDF formatted description of the preserved specimen "; BaseGUID$; "</dcterms:description>"
    Print #2, "     <rdf:type rdf:resource =" + Quote$ + "http://xmlns.com/foaf/0.1/Document" + Quote$ + " />"
    Print #2, "     <dcterms:identifier>"; BaseGUID$ + ".rdf"; "</dcterms:identifier>"
    Print #2, "     <dc:creator>"; txtImageInstitutionCode.Text; "</dc:creator>"
    Print #2, "     <dcterms:creator rdf:resource="; Quote$; txtImageInstitutionURI.Text; Quote$; "/>"
    Print #2, "     <dc:language>en</dc:language>"
            
    T$ = Format(Date, "yyyy-mm-dd") + "T" + Format(Time, "hh:mm:ss")
    Print #2, "     <dcterms:modified rdf:datatype=" + Quote$ + "http://www.w3.org/2001/XMLSchema#dateTime" + Quote$ + ">"; T$; "</dcterms:modified>"
    Print #2, "     <dcterms:references rdf:resource="; Quote$; BaseGUID$; Quote$; "/>"
    Print #2, "     <dcterms:references rdf:resource="; Quote$; BaseGUID$ + "#occ"; Quote$; "/>"
    If IndividualGUID$ = "" Then Print #2, "     <dcterms:references rdf:resource="; Quote$; BaseGUID$ + "#ind"; Quote$; "/>"
    If BQAccessURL$ <> "" Then Print #2, "     <dcterms:references rdf:resource="; Quote$; BaseGUID$ + "#img"; Quote$; "/>"
    Print #2, "     <foaf:primaryTopic rdf:resource="; Quote$; BaseGUID$; Quote$; "/>"
    Print #2, "</rdf:Description>"
        
    Print #2, "</rdf:RDF>"
        
    Close #2
    
    ' Include this code if the content negotiation requires ".var" files (i.e. Apache)
    Open txtRootDirectory.Text + namespace$ + "\" + identifier$ + ".var" For Output As #2
        Print #2, "URI: "; identifier$
        Print #2, ""
        Print #2, "URI: "; identifier$; ".rdf"
        Print #2, "content-type: text/html"
        Print #2, ""
        Print #2, "URI: "; identifier$; ".rdf"
        Print #2, "content-type: application/rdf+xml"
    Close #2
        
Next specimen
Close #1

End Sub

Private Sub optLicense_Click(Index As Integer)

T$ = ""
If ValidClickEvent = True Then  'this prevents bogus click events generated by setting option button
'values from having unintended consequences
    CurrentLicenseType = Index
End If

End Sub

Private Sub cmdQuit_Click()

cmdSaveSettings_Click

End
End Sub


