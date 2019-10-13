; When you press the A button in front of something it will find a data entry somewhere on this list
; it will then jump to the pointer in the data item. All jumps lead to an RST20 operation.
NPCDataTable:
	dw DrMasonData
	dw DrMasonData
	dw Ronald1Data
	dw IshiharaData
	dw ImakuniData
	dw DrMasonData
	dw DrMasonData
	dw SamData
	dw Tech1Data
	dw Tech2Data
	dw Tech3Data
	dw Tech4Data
	dw Tech5Data
	dw Tech6Data
	dw Clerk1Data
	dw Clerk2Data
	dw Clerk3Data
	dw Clerk4Data
	dw Clerk5Data
	dw Clerk6Data
	dw Clerk7Data
	dw Clerk8Data
	dw Clerk9Data
	dw ChrisData
	dw MichaelData
	dw JessicaData
	dw MitchData
	dw MatthewData
	dw RyanData
	dw AndrewData
	dw GeneData
	dw SaraData
	dw AmandaData
	dw JoshuaData
	dw AmyData
	dw JenniferData
	dw NicholasData
	dw BrandonData
	dw IsaacData
	dw BrittanyData
	dw KristinData
	dw HeatherData
	dw NikkiData
	dw RobertData
	dw DanielData
	dw StephanieData
	dw Murray1Data
	dw JosephData
	dw DavidData
	dw ErikData
	dw RickData
	dw JohnData
	dw AdamData
	dw JonathanData
	dw KenData
	dw CourtneyData
	dw SteveData
	dw JackData
	dw RodData
	dw Clerk10Data
	dw GiftCenterClerkData
	dw Man1Data
	dw Woman1Data
	dw Chap1Data
	dw Gal1Data
	dw Lass1Data
	dw Chap2Data
	dw Lass2Data
	dw Pappy1Data
	dw Lad1Data
	dw Lad2Data
	dw Chap3Data
	dw Clerk12Data
	dw Clerk13Data
	dw HostData
	dw Specs1Data
	dw ButchData
	dw Granny1Data
	dw Lass3Data
	dw Man2Data
	dw Pappy2Data
	dw Lass4Data
	dw Hood1Data
	dw Granny2Data
	dw Gal2Data
	dw Lad3Data
	dw Gal3Data
	dw Chap4Data
	dw Man3Data
	dw Specs2Data
	dw Specs3Data
	dw Woman2Data
	dw ManiaData
	dw Pappy3Data
	dw Gal4Data
	dw ChampData
	dw Hood2Data
	dw Lass5Data
	dw Chap5Data
	dw AaronData
	dw GuideData
	dw Tech7Data
	dw Tech8Data
	dw Data_11f18 ; these actually are used for the effects around the legendary cards
	dw Data_11f1f
	dw Data_11f26
	dw Data_11f2d
	dw Data_11f34
	dw Data_11f3b
	dw Data_11f42
	dw Data_11f49
	dw Data_11f49
	dw Murray2Data
	dw Ronald2Data
	dw Ronald3Data
	dw Data_11f49
DrMasonData:
	db DRMASON
	db $02
	db $00
	db $26
	db $00
	dw $5727 ; Pointer to OWScript
	tx Text03ac
	db $00
	db $00
	db $00
	db $00
Ronald1Data:
	db RONALD1
	db $01
	db $04
	db $0e
	db $00
	dw OWSequence_Ronald ; Pointer to OWScript
	tx Text03ad
	db RONALD_PIC
	db $1a
	db $0f
	db $16
Ronald2Data:
	db RONALD2
	db $01
	db $04
	db $0e
	db $00
	dw OWSequence_Ronald ; Pointer to OWScript
	tx Text03ad
	db RONALD_PIC
	db $1a
	db $0f
	db $16
Ronald3Data:
	db RONALD3
	db $01
	db $04
	db $0e
	db $00
	dw OWSequence_Ronald ; Pointer to OWScript
	tx Text03ad
	db RONALD_PIC
	db $1a
	db $0f
	db $16
IshiharaData:
	db ISHIHARA
	db $03
	db $04
	db $22
	db $00
	dw OWSequence_Ishihara ; Pointer to OWScript
	tx Text03ae
	db $00
	db $00
	db $00
	db $00
ImakuniData:
	db IMAKUNI
	db $04
	db $00
	db $0e
	db $00
	dw OWSequence_Imakuni ; Pointer to OWScript
	tx Text03af
	db IMAKUNI_PIC
	db $34
	db $10
	db $15
SamData:
	db SAM
	db $18
	db $00
	db $0e
	db $00
	dw $561d ; Pointer to OWScript
	tx Text03b1
	db SAM_PIC
	db $02
	db $02
	db $15
Tech1Data:
	db TECH1
	db $18
	db $00
	db $0e
	db $00
	dw $5583 ; Pointer to OWScript
	tx Text03b2
	db $00
	db $00
	db $00
	db $00
Tech2Data:
	db TECH2
	db $18
	db $00
	db $0e
	db $00
	dw $55ca ; Pointer to OWScript
	tx Text03b2
	db $00
	db $00
	db $00
	db $00
Tech3Data:
	db TECH3
	db $18
	db $00
	db $0e
	db $00
	dw $55d5 ; Pointer to OWScript
	tx Text03b2
	db $00
	db $00
	db $00
	db $00
Tech4Data:
	db TECH4
	db $18
	db $00
	db $0e
	db $00
	dw $55e0 ; Pointer to OWScript
	tx Text03b2
	db $00
	db $00
	db $00
	db $00
Tech5Data:
	db TECH5
	db $18
	db $00
	db $0e
	db $00
	dw $55f9 ; Pointer to OWScript
	tx Text03b2
	db $00
	db $00
	db $00
	db $00
Tech6Data:
	db TECH6
	db $18
	db $00
	db $0e
	db $00
	dw $58bb ; Pointer to OWScript
	tx Text03b2
	db $00
	db $00
	db $00
	db $00
Clerk1Data:
	db CLERK1
	db $21
	db $0a
	db $30
	db $00
	dw OWSequence_Clerk1 ; Pointer to OWScript
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
Clerk2Data:
	db CLERK2
	db $21
	db $0a
	db $30
	db $00
	dw $5ed1 ; Pointer to OWScript
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
Clerk3Data:
	db CLERK3
	db $21
	db $0a
	db $30
	db $00
	dw $609e ; Pointer to OWScript
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
Clerk4Data:
	db CLERK4
	db $21
	db $0a
	db $30
	db $00
	dw $6369 ; Pointer to OWScript
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
Clerk5Data:
	db CLERK5
	db $21
	db $0a
	db $30
	db $00
	dw $6566 ; Pointer to OWScript
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
Clerk6Data:
	db CLERK6
	db $21
	db $0a
	db $30
	db $00
	dw $684c ; Pointer to OWScript
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
Clerk7Data:
	db CLERK7
	db $21
	db $0a
	db $30
	db $00
	dw $6b53 ; Pointer to OWScript
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
Clerk8Data:
	db CLERK8
	db $21
	db $0a
	db $30
	db $00
	dw $6d45 ; Pointer to OWScript
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
Clerk9Data:
	db CLERK9
	db $21
	db $0a
	db $30
	db $00
	dw $7025 ; Pointer to OWScript
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
ChrisData:
	db CHRIS
	db $15
	db $00
	db $26
	db $00
	dw $5ef2 ; Pointer to OWScript
	tx Text03b4
	db CHRIS_PIC
	db $1c
	db $03
	db $15
MichaelData:
	db MICHAEL
	db $15
	db $00
	db $26
	db $00
	dw $6573 ; Pointer to OWScript
	tx Text03b5
	db MICHAEL_PIC
	db $1d
	db $03
	db $15
JessicaData:
	db JESSICA
	db $1f
	db $04
	db $1a
	db $00
	dw $6d96 ; Pointer to OWScript
	tx Text03b6
	db JESSICA_PIC
	db $1e
	db $03
	db $15
MitchData:
	db MITCH
	db $0a
	db $00
	db $0e
	db $00
	dw $5dc3 ; Pointer to OWScript
	tx Text03b7
	db MITCH_PIC
	db $10
	db $03
	db $16
MatthewData:
	db MATTHEW
	db $15
	db $00
	db $16
	db $00
	dw $5f39 ; Pointer to OWScript
	tx Text03b8
	db MATTHEW_PIC
	db $21
	db $03
	db $15
RyanData:
	db RYAN
	db $11
	db $00
	db $26
	db $00
	dw $5ff0 ; Pointer to OWScript
	tx Text03b9
	db RYAN_PIC
	db $1f
	db $03
	db $15
AndrewData:
	db ANDREW
	db $1a
	db $00
	db $16
	db $00
	dw $6017 ; Pointer to OWScript
	tx Text03ba
	db ANDREW_PIC
	db $20
	db $03
	db $15
GeneData:
	db GENE
	db $0b
	db $04
	db $1e
	db $00
	dw $603e ; Pointer to OWScript
	tx Text03bb
	db GENE_PIC
	db $11
	db $03
	db $16
SaraData:
	db SARA
	db $20
	db $00
	db $0e
	db $00
	dw OWSequence_Sara ; Pointer to OWScript
	tx Text03bc
	db SARA_PIC
	db $22
	db $03
	db $15
AmandaData:
	db AMANDA
	db $20
	db $00
	db $16
	db $00
	dw OWSequence_Amanda ; Pointer to OWScript
	tx Text03bd
	db AMANDA_PIC ; battle profile picture
	db $23
	db $03
	db $15
JoshuaData:
	db JOSHUA
	db $16
	db $00
	db $26
	db $00
	dw OWSequence_Joshua ; Pointer to OWScript
	tx Text03be
	db JOSHUA_PIC
	db $24
	db $03
	db $15
AmyData:
	db AMY
	db $08
	db $08
	db $2e
	db $10
	dw OWSequence_Amy ; Pointer to OWScript
	tx Text03bf
	db AMY_PIC
	db $12
	db $03
	db $16
JenniferData:
	db JENNIFER
	db $1c
	db $04
	db $0e
	db $00
	dw $6408 ; Pointer to OWScript
	tx Text03c0
	db JENNIFER_PIC
	db $25
	db $03
	db $15
NicholasData:
	db NICHOLAS
	db $17
	db $04
	db $1e
	db $00
	dw $642f ; Pointer to OWScript
	tx Text03c1
	db NICHOLAS_PIC
	db $26
	db $03
	db $15
BrandonData:
	db BRANDON
	db $17
	db $04
	db $1e
	db $00
	dw $6456 ; Pointer to OWScript
	tx Text03c2
	db BRANDON_PIC
	db $27
	db $03
	db $15
IsaacData:
	db ISAAC
	db $09
	db $00
	db $16
	db $00
	dw $64ad ; Pointer to OWScript
	tx Text03c3
	db ISAAC_PIC
	db $13
	db $03
	db $16
BrittanyData:
	db BRITTANY
	db $1c
	db $04
	db $0e
	db $00
	dw OWSequence_Brittany ; Pointer to OWScript
	tx Text03c4
	db BRITTANY_PIC
	db $28
	db $03
	db $15
KristinData:
	db KRISTIN
	db $1e
	db $00
	db $1e
	db $00
	dw $6701 ; Pointer to OWScript
	tx Text03c5
	db KRISTIN_PIC
	db $29
	db $03
	db $15
HeatherData:
	db HEATHER
	db $1d
	db $04
	db $22
	db $00
	dw $6745 ; Pointer to OWScript
	tx Text03c6
	db HEATHER_PIC
	db $2a
	db $03
	db $15
NikkiData:
	db NIKKI
	db $05
	db $00
	db $1a
	db $00
	dw $679e ; Pointer to OWScript
	tx Text03c7
	db NIKKI_PIC
	db $14
	db $03
	db $16
RobertData:
	db ROBERT
	db $11
	db $04
	db $16
	db $00
	dw $6980 ; Pointer to OWScript
	tx Text03c8
	db ROBERT_PIC
	db $2b
	db $03
	db $15
DanielData:
	db DANIEL
	db $12
	db $04
	db $1a
	db $00
	dw $6a60 ; Pointer to OWScript
	tx Text03c9
	db DANIEL_PIC
	db $2c
	db $03
	db $15
StephanieData:
	db STEPHANIE
	db $1c
	db $04
	db $0e
	db $00
	dw $6aa2 ; Pointer to OWScript
	tx Text03ca
	db STEPHANIE_PIC
	db $2d
	db $03
	db $15
Murray1Data:
	db MURRAY1
	db $0c
	db $00
	db $12
	db $00
	dw $6adf ; Pointer to OWScript
	tx Text03cb
	db MURRAY_PIC
	db $15
	db $03
	db $16
Murray2Data:
	db MURRAY2
	db $0c
	db $03
	db $15
	db $10
	dw $6adf ; Pointer to OWScript
	tx Text03cb
	db MURRAY_PIC
	db $15
	db $03
	db $16
JosephData:
	db JOSEPH
	db $18
	db $00
	db $0e
	db $00
	dw $6cdb ; Pointer to OWScript
	tx Text03cc
	db JOSEPH_PIC
	db $2e
	db $03
	db $15
DavidData:
	db DAVID
	db $18
	db $00
	db $0e
	db $00
	dw $6c11 ; Pointer to OWScript
	tx Text03cd
	db DAVID_PIC
	db $2f
	db $03
	db $15
ErikData:
	db ERIK
	db $18
	db $00
	db $0e
	db $00
	dw $6c42 ; Pointer to OWScript
	tx Text03ce
	db ERIK_PIC
	db $30
	db $03
	db $15
RickData:
	db RICK
	db $06
	db $00
	db $0e
	db $00
	dw $6c67 ; Pointer to OWScript
	tx Text03cf
	db RICK_PIC
	db $16
	db $03
	db $16
JohnData:
	db JOHN
	db $12
	db $04
	db $1a
	db $00
	dw $6eb3 ; Pointer to OWScript
	tx Text03d0
	db JOHN_PIC
	db $31
	db $03
	db $15
AdamData:
	db ADAM
	db $13
	db $00
	db $22
	db $00
	dw $6ed8 ; Pointer to OWScript
	tx Text03d1
	db ADAM_PIC
	db $32
	db $03
	db $15
JonathanData:
	db JONATHAN
	db $11
	db $04
	db $16
	db $00
	dw $6efd ; Pointer to OWScript
	tx Text03d2
	db JONATHAN_PIC
	db $33
	db $03
	db $15
KenData:
	db KEN
	db $07
	db $04
	db $1e
	db $00
	dw $6f22 ; Pointer to OWScript
	tx Text03d3
	db KEN_PIC
	db $17
	db $03
	db $16
CourtneyData:
	db COURTNEY
	db $0d
	db $00
	db $12
	db $00
	dw $771f ; Pointer to OWScript
	tx Text03d4
	db COURTNEY_PIC
	db $0c
	db $04
	db $17
SteveData:
	db STEVE
	db $0e
	db $00
	db $2a
	db $00
	dw $772a ; Pointer to OWScript
	tx Text03d5
	db STEVE_PIC
	db $0d
	db $04
	db $17
JackData:
	db JACK
	db $0f
	db $00
	db $26
	db $00
	dw $7735 ; Pointer to OWScript
	tx Text03d6
	db JACK_PIC
	db $0e
	db $04
	db $17
RodData:
	db ROD
	db $10
	db $00
	db $0e
	db $00
	dw $7740 ; Pointer to OWScript
	tx Text03d7
	db ROD_PIC
	db $0f
	db $04
	db $17
Clerk10Data:
	db CLERK10
	db $21
	db $0a
	db $30
	db $00
	dw $4c3e ; Pointer to OWScript
	tx Text03b0
	db $00
	db $00
	db $00
	db $00
GiftCenterClerkData:
	db GIFT_CENTER_CLERK
	db $21
	db $0a
	db $30
	db $00
	dw $4c3e ; Pointer to OWScript
	tx Text03b0
	db $00
	db $00
	db $00
	db $00
Man1Data:
	db MAN1
	db $1a
	db $00
	db $16
	db $00
	dw $5c76 ; Pointer to OWScript
	tx Text03d8
	db $00
	db $00
	db $00
	db $00
Woman1Data:
	db WOMAN1
	db $23
	db $04
	db $1e
	db $00
	dw $5f83 ; Pointer to OWScript
	tx Text03d9
	db $00
	db $00
	db $00
	db $00
Chap1Data:
	db CHAP1
	db $19
	db $00
	db $1a
	db $00
	dw $5fc0 ; Pointer to OWScript
	tx Text03da
	db $00
	db $00
	db $00
	db $00
Gal1Data:
	db GAL1
	db $22
	db $00
	db $16
	db $00
	dw OWSequence_Gal1 ; Pointer to OWScript
	tx Text03db
	db $00
	db $00
	db $00
	db $00
Lass1Data:
	db LASS1
	db $1e
	db $00
	db $1e
	db $00
	dw OWSequence_Lass1 ; Pointer to OWScript
	tx Text03dc
	db $00
	db $00
	db $00
	db $00
Chap2Data:
	db CHAP2
	db $19
	db $00
	db $1a
	db $00
	dw $639a ; Pointer to OWScript
	tx Text03da
	db $00
	db $00
	db $00
	db $00
Lass2Data:
	db LASS2
	db $1e
	db $00
	db $1e
	db $00
	dw $661f ; Pointer to OWScript
	tx Text03dc
	db $00
	db $00
	db $00
	db $00
Pappy1Data:
	db PAPPY1
	db $1b
	db $00
	db $22
	db $00
	dw $69a5 ; Pointer to OWScript
	tx Text03dd
	db $00
	db $00
	db $00
	db $00
Lad1Data:
	db LAD1
	db $12
	db $04
	db $1a
	db $00
	dw $6b84 ; Pointer to OWScript
	tx Text03de
	db $00
	db $00
	db $00
	db $00
Lad2Data:
	db LAD2
	db $11
	db $04
	db $16
	db $00
	dw $6e2c ; Pointer to OWScript
	tx Text03de
	db $00
	db $00
	db $00
	db $00
Chap3Data:
	db CHAP3
	db $19
	db $00
	db $1a
	db $00
	dw $6de8 ; Pointer to OWScript
	tx Text03da
	db $00
	db $00
	db $00
	db $00
Clerk12Data:
	db CLERK12
	db $22
	db $00
	db $16
	db $00
	dw $7295 ; Pointer to OWScript
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
Clerk13Data:
	db CLERK13
	db $22
	db $00
	db $16
	db $00
	dw $726c ; Pointer to OWScript
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
HostData:
	db HOST
	db $22
	db $00
	db $16
	db $00
	dw $7352 ; Pointer to OWScript
	tx Text03df
	db $00
	db $00
	db $00
	db $00
Specs1Data:
	db SPECS1
	db $13
	db $00
	db $22
	db $00
	dw $5d82 ; Pointer to OWScript
	tx Text03e0
	db $00
	db $00
	db $00
	db $00
ButchData:
	db BUTCH
	db $14
	db $00
	db $16
	db $00
	dw $5d8d ; Pointer to OWScript
	tx Text03e1
	db $00
	db $00
	db $00
	db $00
Granny1Data:
	db GRANNY1
	db $24
	db $00
	db $16
	db $00
	dw $5d9f ; Pointer to OWScript
	tx Text03e5
	db $00
	db $00
	db $00
	db $00
Lass3Data:
	db LASS3
	db $1d
	db $04
	db $22
	db $00
	dw $5fd2 ; Pointer to OWScript
	tx Text03dc
	db $00
	db $00
	db $00
	db $00
Man2Data:
	db MAN2
	db $1a
	db $00
	db $16
	db $00
	dw OWSequence_Man2 ; Pointer to OWScript
	tx Text03d8
	db $00
	db $00
	db $00
	db $00
Pappy2Data:
	db PAPPY2
	db $1b
	db $00
	db $22
	db $00
	dw OWSequence_Pappy2 ; Pointer to OWScript
	tx Text03dd
	db $00
	db $00
	db $00
	db $00
Lass4Data:
	db LASS4
	db $1d
	db $04
	db $22
	db $00
	dw $63d9 ; Pointer to OWScript
	tx Text03dc
	db $00
	db $00
	db $00
	db $00
Hood1Data:
	db HOOD1
	db $17
	db $04
	db $1e
	db $00
	dw $63dd ; Pointer to OWScript
	tx Text03e2
	db $00
	db $00
	db $00
	db $00
Granny2Data:
	db GRANNY2
	db $24
	db $00
	db $16
	db $00
	dw $66d8 ; Pointer to OWScript
	tx Text03e5
	db $00
	db $00
	db $00
	db $00
Gal2Data:
	db GAL2
	db $22
	db $00
	db $16
	db $00
	dw $66e3 ; Pointer to OWScript
	tx Text03db
	db $00
	db $00
	db $00
	db $00
Lad3Data:
	db LAD3
	db $12
	db $04
	db $1a
	db $00
	dw $6850 ; Pointer to OWScript
	tx Text03de
	db $00
	db $00
	db $00
	db $00
Gal3Data:
	db GAL3
	db $22
	db $00
	db $16
	db $00
	dw $6a30 ; Pointer to OWScript
	tx Text03db
	db $00
	db $00
	db $00
	db $00
Chap4Data:
	db CHAP4
	db $19
	db $00
	db $1a
	db $00
	dw $6a3b ; Pointer to OWScript
	tx Text03da
	db $00
	db $00
	db $00
	db $00
Man3Data:
	db MAN3
	db $1a
	db $00
	db $16
	db $00
	dw $6bc1 ; Pointer to OWScript
	tx Text03d8
	db $00
	db $00
	db $00
	db $00
Specs2Data:
	db SPECS2
	db $18
	db $00
	db $0e
	db $00
	dw $6bc5 ; Pointer to OWScript
	tx Text03e0
	db $00
	db $00
	db $00
	db $00
Specs3Data:
	db SPECS3
	db $13
	db $00
	db $22
	db $00
	dw $6bed ; Pointer to OWScript
	tx Text03e0
	db $00
	db $00
	db $00
	db $00
Woman2Data:
	db WOMAN2
	db $23
	db $04
	db $1e
	db $00
	dw $4c3e ; Pointer to OWScript
	tx Text03d9
	db $00
	db $00
	db $00
	db $00
ManiaData:
	db MANIA
	db $15
	db $00
	db $26
	db $00
	dw $6e88 ; Pointer to OWScript
	tx Text03e4
	db $00
	db $00
	db $00
	db $00
Pappy3Data:
	db PAPPY3
	db $1b
	db $00
	db $22
	db $00
	dw $709c ; Pointer to OWScript
	tx Text03dd
	db $00
	db $00
	db $00
	db $00
Gal4Data:
	db GAL4
	db $22
	db $00
	db $16
	db $00
	dw $70a0 ; Pointer to OWScript
	tx Text03db
	db $00
	db $00
	db $00
	db $00
ChampData:
	db CHAMP
	db $15
	db $00
	db $26
	db $00
	dw $70a4 ; Pointer to OWScript
	tx Text03e3
	db $00
	db $00
	db $00
	db $00
Hood2Data:
	db HOOD2
	db $17
	db $04
	db $1e
	db $00
	dw $70a8 ; Pointer to OWScript
	tx Text03e2
	db $00
	db $00
	db $00
	db $00
Lass5Data:
	db LASS5
	db $1f
	db $04
	db $1a
	db $00
	dw $70ac ; Pointer to OWScript
	tx Text03dc
	db $00
	db $00
	db $00
	db $00
Chap5Data:
	db CHAP5
	db $19
	db $00
	db $1a
	db $00
	dw $70b0 ; Pointer to OWScript
	tx Text03da
	db $00
	db $00
	db $00
	db $00
AaronData:
	db AARON
	db $18
	db $00
	db $0e
	db $00
	dw $58dd ; Pointer to OWScript
	tx Text03e7
	db AARON_PIC
	db $09
	db $02
	db $15
GuideData:
	db GUIDE
	db $1a
	db $00
	db $16
	db $00
	dw $7283 ; Pointer to OWScript
	tx Text03e6
	db $00
	db $00
	db $00
	db $00
Tech7Data:
	db TECH7
	db $18
	db $00
	db $0e
	db $00
	dw $58c6 ; Pointer to OWScript
	tx Text03b2
	db $00
	db $00
	db $00
	db $00
Tech8Data:
	db TECH8
	db $18
	db $00
	db $0e
	db $00
	dw $58d1 ; Pointer to OWScript
	tx Text03b2
	db $00
	db $00
	db $00
	db $00
Data_11f18:
	db $67
	db $26
	db $3a
	db $3a
	db $10
	dw $4c3e ; Pointer to OWScript
Data_11f1f:
	db $68
	db $27
	db $3b
	db $41
	db $50
	dw $4c3e ; Pointer to OWScript
Data_11f26:
	db $69
	db $27
	db $3c
	db $42
	db $50
	dw $4c3e ; Pointer to OWScript
Data_11f2d:
	db $6a
	db $27
	db $3d
	db $43
	db $50
	dw $4c3e ; Pointer to OWScript
Data_11f34:
	db $6b
	db $27
	db $3e
	db $44
	db $50
	dw $4c3e ; Pointer to OWScript
Data_11f3b:
	db $6c
	db $27
	db $3f
	db $45
	db $50
	dw $4c3e ; Pointer to OWScript
Data_11f42:
	db $6d
	db $27
	db $40
	db $46
	db $50
	dw $4c3e ; Pointer to OWScript
Data_11f49:
	db $00
	db $00
	db $00
	db $1e
	db $00
