; When you press the A button in front of something it will find a data entry somewhere on this list
; it will then jump to the pointer in the data item. All jumps lead to an RST20 operation.
; The Deck IDs are used for the challenge hall
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
	db NPC_DRMASON
	db $02
	db $00
	db $26
	db $00
	dw $5727 ; Pointer to Script
	tx Text03ac
	db $00
	db $00
	db $00
	db $00
Ronald1Data:
	db NPC_RONALD1
	db $01
	db $04
	db $0e
	db $00
	dw Script_Ronald ; Pointer to Script
	tx Text03ad
	db RONALD_PIC
	db INVINCIBLE_RONALD_DECK_ID
	db $0f
	db $16
Ronald2Data:
	db NPC_RONALD2
	db $01
	db $04
	db $0e
	db $00
	dw Script_Ronald ; Pointer to Script
	tx Text03ad
	db RONALD_PIC
	db INVINCIBLE_RONALD_DECK_ID
	db $0f
	db $16
Ronald3Data:
	db NPC_RONALD3
	db $01
	db $04
	db $0e
	db $00
	dw Script_Ronald ; Pointer to Script
	tx Text03ad
	db RONALD_PIC
	db INVINCIBLE_RONALD_DECK_ID
	db $0f
	db $16
IshiharaData:
	db NPC_ISHIHARA
	db $03
	db $04
	db $22
	db $00
	dw Script_Ishihara ; Pointer to Script
	tx Text03ae
	db $00
	db $00
	db $00
	db $00
ImakuniData:
	db NPC_IMAKUNI
	db $04
	db $00
	db $0e
	db $00
	dw Script_Imakuni ; Pointer to Script
	tx Text03af
	db IMAKUNI_PIC
	db IMAKUNI_DECK_ID
	db $10
	db $15
SamData:
	db NPC_SAM
	db $18
	db $00
	db $0e
	db $00
	dw $561d ; Pointer to Script
	tx Text03b1
	db SAM_PIC
	db SAMS_NORMAL_DECK_ID
	db $02
	db $15
Tech1Data:
	db NPC_TECH1
	db $18
	db $00
	db $0e
	db $00
	dw $5583 ; Pointer to Script
	tx Text03b2
	db $00
	db $00
	db $00
	db $00
Tech2Data:
	db NPC_TECH2
	db $18
	db $00
	db $0e
	db $00
	dw $55ca ; Pointer to Script
	tx Text03b2
	db $00
	db $00
	db $00
	db $00
Tech3Data:
	db NPC_TECH3
	db $18
	db $00
	db $0e
	db $00
	dw $55d5 ; Pointer to Script
	tx Text03b2
	db $00
	db $00
	db $00
	db $00
Tech4Data:
	db NPC_TECH4
	db $18
	db $00
	db $0e
	db $00
	dw $55e0 ; Pointer to Script
	tx Text03b2
	db $00
	db $00
	db $00
	db $00
Tech5Data:
	db NPC_TECH5
	db $18
	db $00
	db $0e
	db $00
	dw $55f9 ; Pointer to Script
	tx Text03b2
	db $00
	db $00
	db $00
	db $00
Tech6Data:
	db NPC_TECH6
	db $18
	db $00
	db $0e
	db $00
	dw $58bb ; Pointer to Script
	tx Text03b2
	db $00
	db $00
	db $00
	db $00
Clerk1Data:
	db NPC_CLERK1
	db $21
	db $0a
	db $30
	db $00
	dw Script_Clerk1 ; Pointer to Script
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
Clerk2Data:
	db NPC_CLERK2
	db $21
	db $0a
	db $30
	db $00
	dw $5ed1 ; Pointer to Script
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
Clerk3Data:
	db NPC_CLERK3
	db $21
	db $0a
	db $30
	db $00
	dw $609e ; Pointer to Script
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
Clerk4Data:
	db NPC_CLERK4
	db $21
	db $0a
	db $30
	db $00
	dw $6369 ; Pointer to Script
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
Clerk5Data:
	db NPC_CLERK5
	db $21
	db $0a
	db $30
	db $00
	dw $6566 ; Pointer to Script
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
Clerk6Data:
	db NPC_CLERK6
	db $21
	db $0a
	db $30
	db $00
	dw $684c ; Pointer to Script
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
Clerk7Data:
	db NPC_CLERK7
	db $21
	db $0a
	db $30
	db $00
	dw $6b53 ; Pointer to Script
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
Clerk8Data:
	db NPC_CLERK8
	db $21
	db $0a
	db $30
	db $00
	dw $6d45 ; Pointer to Script
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
Clerk9Data:
	db NPC_CLERK9
	db $21
	db $0a
	db $30
	db $00
	dw Script_Clerk9 ; Pointer to Script
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
ChrisData:
	db NPC_CHRIS
	db $15
	db $00
	db $26
	db $00
	dw $5ef2 ; Pointer to Script
	tx Text03b4
	db CHRIS_PIC
	db MUSCLES_FOR_BRAINS_DECK_ID
	db $03
	db $15
MichaelData:
	db NPC_MICHAEL
	db $15
	db $00
	db $26
	db $00
	dw $6573 ; Pointer to Script
	tx Text03b5
	db MICHAEL_PIC
	db HEATED_BATTLE_DECK_ID
	db $03
	db $15
JessicaData:
	db NPC_JESSICA
	db $1f
	db $04
	db $1a
	db $00
	dw $6d96 ; Pointer to Script
	tx Text03b6
	db JESSICA_PIC
	db LOVE_TO_BATTLE_DECK_ID
	db $03
	db $15
MitchData:
	db NPC_MITCH
	db $0a
	db $00
	db $0e
	db $00
	dw $5dc3 ; Pointer to Script
	tx Text03b7
	db MITCH_PIC
	db FIRST_STRIKE_DECK_ID
	db $03
	db $16
MatthewData:
	db NPC_MATTHEW
	db $15
	db $00
	db $16
	db $00
	dw $5f39 ; Pointer to Script
	tx Text03b8
	db MATTHEW_PIC
	db HARD_POKEMON_DECK_ID
	db $03
	db $15
RyanData:
	db NPC_RYAN
	db $11
	db $00
	db $26
	db $00
	dw $5ff0 ; Pointer to Script
	tx Text03b9
	db RYAN_PIC
	db EXCAVATION_DECK_ID
	db $03
	db $15
AndrewData:
	db NPC_ANDREW
	db $1a
	db $00
	db $16
	db $00
	dw $6017 ; Pointer to Script
	tx Text03ba
	db ANDREW_PIC
	db BLISTERING_POKEMON_DECK_ID
	db $03
	db $15
GeneData:
	db NPC_GENE
	db $0b
	db $04
	db $1e
	db $00
	dw $603e ; Pointer to Script
	tx Text03bb
	db GENE_PIC
	db ROCK_CRUSHER_DECK_ID
	db $03
	db $16
SaraData:
	db NPC_SARA
	db $20
	db $00
	db $0e
	db $00
	dw Script_Sara ; Pointer to Script
	tx Text03bc
	db SARA_PIC
	db WATERFRONT_POKEMON_DECK_ID
	db $03
	db $15
AmandaData:
	db NPC_AMANDA
	db $20
	db $00
	db $16
	db $00
	dw Script_Amanda ; Pointer to Script
	tx Text03bd
	db AMANDA_PIC ; battle profile picture
	db LONELY_FRIENDS_DECK_ID
	db $03
	db $15
JoshuaData:
	db NPC_JOSHUA
	db $16
	db $00
	db $26
	db $00
	dw Script_Joshua ; Pointer to Script
	tx Text03be
	db JOSHUA_PIC
	db SOUND_OF_THE_WAVES_DECK_ID
	db $03
	db $15
AmyData:
	db NPC_AMY
	db $08
	db $08
	db $2e
	db $10
	dw Script_Amy ; Pointer to Script
	tx Text03bf
	db AMY_PIC
	db GO_GO_RAIN_DANCE_DECK_ID
	db $03
	db $16
JenniferData:
	db NPC_JENNIFER
	db $1c
	db $04
	db $0e
	db $00
	dw $6408 ; Pointer to Script
	tx Text03c0
	db JENNIFER_PIC
	db PIKACHU_DECK_ID
	db $03
	db $15
NicholasData:
	db NPC_NICHOLAS
	db $17
	db $04
	db $1e
	db $00
	dw $642f ; Pointer to Script
	tx Text03c1
	db NICHOLAS_PIC
	db BOOM_BOOM_SELFDESTRUCT_DECK_ID
	db $03
	db $15
BrandonData:
	db NPC_BRANDON
	db $17
	db $04
	db $1e
	db $00
	dw $6456 ; Pointer to Script
	tx Text03c2
	db BRANDON_PIC
	db POWER_GENERATOR_DECK_ID
	db $03
	db $15
IsaacData:
	db NPC_ISAAC
	db $09
	db $00
	db $16
	db $00
	dw $64ad ; Pointer to Script
	tx Text03c3
	db ISAAC_PIC
	db ZAPPING_SELFDESTRUCT_DECK_ID
	db $03
	db $16
BrittanyData:
	db NPC_BRITTANY
	db $1c
	db $04
	db $0e
	db $00
	dw Script_Brittany ; Pointer to Script
	tx Text03c4
	db BRITTANY_PIC
	db ETCETERA_DECK_ID
	db $03
	db $15
KristinData:
	db NPC_KRISTIN
	db $1e
	db $00
	db $1e
	db $00
	dw $6701 ; Pointer to Script
	tx Text03c5
	db KRISTIN_PIC
	db FLOWER_GARDEN_DECK_ID
	db $03
	db $15
HeatherData:
	db NPC_HEATHER
	db $1d
	db $04
	db $22
	db $00
	dw $6745 ; Pointer to Script
	tx Text03c6
	db HEATHER_PIC
	db KALEIDOSCOPE_DECK_ID
	db $03
	db $15
NikkiData:
	db NPC_NIKKI
	db $05
	db $00
	db $1a
	db $00
	dw $679e ; Pointer to Script
	tx Text03c7
	db NIKKI_PIC
	db FLOWER_POWER_DECK_ID
	db $03
	db $16
RobertData:
	db NPC_ROBERT
	db $11
	db $04
	db $16
	db $00
	dw $6980 ; Pointer to Script
	tx Text03c8
	db ROBERT_PIC
	db GHOST_DECK_ID
	db $03
	db $15
DanielData:
	db NPC_DANIEL
	db $12
	db $04
	db $1a
	db $00
	dw $6a60 ; Pointer to Script
	tx Text03c9
	db DANIEL_PIC
	db NAP_TIME_DECK_ID
	db $03
	db $15
StephanieData:
	db NPC_STEPHANIE
	db $1c
	db $04
	db $0e
	db $00
	dw $6aa2 ; Pointer to Script
	tx Text03ca
	db STEPHANIE_PIC
	db STRANGE_POWER_DECK_ID
	db $03
	db $15
Murray1Data:
	db NPC_MURRAY1
	db $0c
	db $00
	db $12
	db $00
	dw $6adf ; Pointer to Script
	tx Text03cb
	db MURRAY_PIC
	db STRANGE_PSYSHOCK_DECK_ID
	db $03
	db $16
Murray2Data:
	db NPC_MURRAY2
	db $0c
	db $03
	db $15
	db $10
	dw $6adf ; Pointer to Script
	tx Text03cb
	db MURRAY_PIC
	db STRANGE_PSYSHOCK_DECK_ID
	db $03
	db $16
JosephData:
	db NPC_JOSEPH
	db $18
	db $00
	db $0e
	db $00
	dw $6cdb ; Pointer to Script
	tx Text03cc
	db JOSEPH_PIC
	db FLYIN_POKEMON_DECK_ID
	db $03
	db $15
DavidData:
	db NPC_DAVID
	db $18
	db $00
	db $0e
	db $00
	dw $6c11 ; Pointer to Script
	tx Text03cd
	db DAVID_PIC
	db LOVELY_NIDORAN_DECK_ID
	db $03
	db $15
ErikData:
	db NPC_ERIK
	db $18
	db $00
	db $0e
	db $00
	dw $6c42 ; Pointer to Script
	tx Text03ce
	db ERIK_PIC
	db POISON_DECK_ID
	db $03
	db $15
RickData:
	db NPC_RICK
	db $06
	db $00
	db $0e
	db $00
	dw $6c67 ; Pointer to Script
	tx Text03cf
	db RICK_PIC
	db WONDERS_OF_SCIENCE_DECK_ID
	db $03
	db $16
JohnData:
	db NPC_JOHN
	db $12
	db $04
	db $1a
	db $00
	dw $6eb3 ; Pointer to Script
	tx Text03d0
	db JOHN_PIC
	db ANGER_DECK_ID
	db $03
	db $15
AdamData:
	db NPC_ADAM
	db $13
	db $00
	db $22
	db $00
	dw $6ed8 ; Pointer to Script
	tx Text03d1
	db ADAM_PIC
	db FLAMETHROWER_DECK_ID
	db $03
	db $15
JonathanData:
	db NPC_JONATHAN
	db $11
	db $04
	db $16
	db $00
	dw $6efd ; Pointer to Script
	tx Text03d2
	db JONATHAN_PIC
	db RESHUFFLE_DECK_ID
	db $03
	db $15
KenData:
	db NPC_KEN
	db $07
	db $04
	db $1e
	db $00
	dw $6f22 ; Pointer to Script
	tx Text03d3
	db KEN_PIC
	db FIRE_CHARGE_DECK_ID
	db $03
	db $16
CourtneyData:
	db NPC_COURTNEY
	db $0d
	db $00
	db $12
	db $00
	dw $771f ; Pointer to Script
	tx Text03d4
	db COURTNEY_PIC
	db LEGENDARY_MOLTRES_DECK_ID
	db $04
	db $17
SteveData:
	db NPC_STEVE
	db $0e
	db $00
	db $2a
	db $00
	dw $772a ; Pointer to Script
	tx Text03d5
	db STEVE_PIC
	db LEGENDARY_ZAPDOS_DECK_ID
	db $04
	db $17
JackData:
	db NPC_JACK
	db $0f
	db $00
	db $26
	db $00
	dw $7735 ; Pointer to Script
	tx Text03d6
	db JACK_PIC
	db LEGENDARY_ARTICUNO_DECK_ID
	db $04
	db $17
RodData:
	db NPC_ROD
	db $10
	db $00
	db $0e
	db $00
	dw $7740 ; Pointer to Script
	tx Text03d7
	db ROD_PIC
	db LEGENDARY_DRAGONITE_DECK_ID
	db $04
	db $17
Clerk10Data:
	db NPC_CLERK10
	db $21
	db $0a
	db $30
	db $00
	dw NoOverworldSequence ; Pointer to Script
	tx Text03b0
	db $00
	db $00
	db $00
	db $00
GiftCenterClerkData:
	db NPC_GIFT_CENTER_CLERK
	db $21
	db $0a
	db $30
	db $00
	dw NoOverworldSequence ; Pointer to Script
	tx Text03b0
	db $00
	db $00
	db $00
	db $00
Man1Data:
	db NPC_MAN1
	db $1a
	db $00
	db $16
	db $00
	dw $5c76 ; Pointer to Script
	tx Text03d8
	db $00
	db $00
	db $00
	db $00
Woman1Data:
	db NPC_WOMAN1
	db $23
	db $04
	db $1e
	db $00
	dw $5f83 ; Pointer to Script
	tx Text03d9
	db $00
	db $00
	db $00
	db $00
Chap1Data:
	db NPC_CHAP1
	db $19
	db $00
	db $1a
	db $00
	dw $5fc0 ; Pointer to Script
	tx Text03da
	db $00
	db $00
	db $00
	db $00
Gal1Data:
	db NPC_GAL1
	db $22
	db $00
	db $16
	db $00
	dw Script_Gal1 ; Pointer to Script
	tx Text03db
	db $00
	db $00
	db $00
	db $00
Lass1Data:
	db NPC_LASS1
	db $1e
	db $00
	db $1e
	db $00
	dw Script_Lass1 ; Pointer to Script
	tx Text03dc
	db $00
	db $00
	db $00
	db $00
Chap2Data:
	db NPC_CHAP2
	db $19
	db $00
	db $1a
	db $00
	dw $639a ; Pointer to Script
	tx Text03da
	db $00
	db $00
	db $00
	db $00
Lass2Data:
	db NPC_LASS2
	db $1e
	db $00
	db $1e
	db $00
	dw Script_e61f ; Pointer to Script
	tx Text03dc
	db $00
	db $00
	db $00
	db $00
Pappy1Data:
	db NPC_PAPPY1
	db $1b
	db $00
	db $22
	db $00
	dw $69a5 ; Pointer to Script
	tx Text03dd
	db $00
	db $00
	db $00
	db $00
Lad1Data:
	db NPC_LAD1
	db $12
	db $04
	db $1a
	db $00
	dw $6b84 ; Pointer to Script
	tx Text03de
	db $00
	db $00
	db $00
	db $00
Lad2Data:
	db NPC_LAD2
	db $11
	db $04
	db $16
	db $00
	dw $6e2c ; Pointer to Script
	tx Text03de
	db $00
	db $00
	db $00
	db $00
Chap3Data:
	db NPC_CHAP3
	db $19
	db $00
	db $1a
	db $00
	dw $6de8 ; Pointer to Script
	tx Text03da
	db $00
	db $00
	db $00
	db $00
Clerk12Data:
	db NPC_CLERK12
	db $22
	db $00
	db $16
	db $00
	dw Script_Clerk12 ; Pointer to Script
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
Clerk13Data:
	db NPC_CLERK13
	db $22
	db $00
	db $16
	db $00
	dw Script_Clerk13 ; Pointer to Script
	tx Text03b3
	db $00
	db $00
	db $00
	db $00
HostData:
	db NPC_HOST
	db $22
	db $00
	db $16
	db $00
	dw Script_HostStubbed ; Pointer to Script
	tx Text03df
	db $00
	db $00
	db $00
	db $00
Specs1Data:
	db NPC_SPECS1
	db $13
	db $00
	db $22
	db $00
	dw $5d82 ; Pointer to Script
	tx Text03e0
	db $00
	db $00
	db $00
	db $00
ButchData:
	db NPC_BUTCH
	db $14
	db $00
	db $16
	db $00
	dw $5d8d ; Pointer to Script
	tx Text03e1
	db $00
	db $00
	db $00
	db $00
Granny1Data:
	db NPC_GRANNY1
	db $24
	db $00
	db $16
	db $00
	dw $5d9f ; Pointer to Script
	tx Text03e5
	db $00
	db $00
	db $00
	db $00
Lass3Data:
	db NPC_LASS3
	db $1d
	db $04
	db $22
	db $00
	dw $5fd2 ; Pointer to Script
	tx Text03dc
	db $00
	db $00
	db $00
	db $00
Man2Data:
	db NPC_MAN2
	db $1a
	db $00
	db $16
	db $00
	dw Script_Man2 ; Pointer to Script
	tx Text03d8
	db $00
	db $00
	db $00
	db $00
Pappy2Data:
	db NPC_PAPPY2
	db $1b
	db $00
	db $22
	db $00
	dw Script_Pappy2 ; Pointer to Script
	tx Text03dd
	db $00
	db $00
	db $00
	db $00
Lass4Data:
	db NPC_LASS4
	db $1d
	db $04
	db $22
	db $00
	dw $63d9 ; Pointer to Script
	tx Text03dc
	db $00
	db $00
	db $00
	db $00
Hood1Data:
	db NPC_HOOD1
	db $17
	db $04
	db $1e
	db $00
	dw $63dd ; Pointer to Script
	tx Text03e2
	db $00
	db $00
	db $00
	db $00
Granny2Data:
	db NPC_GRANNY2
	db $24
	db $00
	db $16
	db $00
	dw $66d8 ; Pointer to Script
	tx Text03e5
	db $00
	db $00
	db $00
	db $00
Gal2Data:
	db NPC_GAL2
	db $22
	db $00
	db $16
	db $00
	dw $66e3 ; Pointer to Script
	tx Text03db
	db $00
	db $00
	db $00
	db $00
Lad3Data:
	db NPC_LAD3
	db $12
	db $04
	db $1a
	db $00
	dw $6850 ; Pointer to Script
	tx Text03de
	db $00
	db $00
	db $00
	db $00
Gal3Data:
	db NPC_GAL3
	db $22
	db $00
	db $16
	db $00
	dw $6a30 ; Pointer to Script
	tx Text03db
	db $00
	db $00
	db $00
	db $00
Chap4Data:
	db NPC_CHAP4
	db $19
	db $00
	db $1a
	db $00
	dw $6a3b ; Pointer to Script
	tx Text03da
	db $00
	db $00
	db $00
	db $00
Man3Data:
	db NPC_MAN3
	db $1a
	db $00
	db $16
	db $00
	dw $6bc1 ; Pointer to Script
	tx Text03d8
	db $00
	db $00
	db $00
	db $00
Specs2Data:
	db NPC_SPECS2
	db $18
	db $00
	db $0e
	db $00
	dw $6bc5 ; Pointer to Script
	tx Text03e0
	db $00
	db $00
	db $00
	db $00
Specs3Data:
	db NPC_SPECS3
	db $13
	db $00
	db $22
	db $00
	dw $6bed ; Pointer to Script
	tx Text03e0
	db $00
	db $00
	db $00
	db $00
Woman2Data:
	db NPC_WOMAN2
	db $23
	db $04
	db $1e
	db $00
	dw NoOverworldSequence ; Pointer to Script
	tx Text03d9
	db $00
	db $00
	db $00
	db $00
ManiaData:
	db NPC_MANIA
	db $15
	db $00
	db $26
	db $00
	dw $6e88 ; Pointer to Script
	tx Text03e4
	db $00
	db $00
	db $00
	db $00
Pappy3Data:
	db NPC_PAPPY3
	db $1b
	db $00
	db $22
	db $00
	dw Script_Pappy3 ; Pointer to Script
	tx Text03dd
	db $00
	db $00
	db $00
	db $00
Gal4Data:
	db NPC_GAL4
	db $22
	db $00
	db $16
	db $00
	dw Script_Gal4 ; Pointer to Script
	tx Text03db
	db $00
	db $00
	db $00
	db $00
ChampData:
	db NPC_CHAMP
	db $15
	db $00
	db $26
	db $00
	dw Script_Champ ; Pointer to Script
	tx Text03e3
	db $00
	db $00
	db $00
	db $00
Hood2Data:
	db NPC_HOOD2
	db $17
	db $04
	db $1e
	db $00
	dw Script_Hood2 ; Pointer to Script
	tx Text03e2
	db $00
	db $00
	db $00
	db $00
Lass5Data:
	db NPC_LASS5
	db $1f
	db $04
	db $1a
	db $00
	dw Script_Lass5 ; Pointer to Script
	tx Text03dc
	db $00
	db $00
	db $00
	db $00
Chap5Data:
	db NPC_CHAP5
	db $19
	db $00
	db $1a
	db $00
	dw Script_Chap5 ; Pointer to Script
	tx Text03da
	db $00
	db $00
	db $00
	db $00
AaronData:
	db NPC_AARON
	db $18
	db $00
	db $0e
	db $00
	dw $58dd ; Pointer to Script
	tx Text03e7
	db AARON_PIC
	db LIGHTNING_AND_FIRE_DECK_ID
	db $02
	db $15
GuideData:
	db NPC_GUIDE
	db $1a
	db $00
	db $16
	db $00
	dw Script_Guide ; Pointer to Script
	tx Text03e6
	db $00
	db $00
	db $00
	db $00
Tech7Data:
	db NPC_TECH7
	db $18
	db $00
	db $0e
	db $00
	dw $58c6 ; Pointer to Script
	tx Text03b2
	db $00
	db $00
	db $00
	db $00
Tech8Data:
	db NPC_TECH8
	db $18
	db $00
	db $0e
	db $00
	dw $58d1 ; Pointer to Script
	tx Text03b2
	db $00
	db $00
	db $00
	db $00
Data_11f18:
	db NPC_TORCH
	db $26
	db $3a
	db $3a
	db $10
	dw NoOverworldSequence ; Pointer to Script
Data_11f1f:
	db NPC_LEGENDARY_CARD_TOP_LEFT
	db $27
	db $3b
	db $41
	db $50
	dw NoOverworldSequence ; Pointer to Script
Data_11f26:
	db NPC_LEGENDARY_CARD_TOP_RIGHT
	db $27
	db $3c
	db $42
	db $50
	dw NoOverworldSequence ; Pointer to Script
Data_11f2d:
	db NPC_LEGENDARY_CARD_LEFT_SPARK
	db $27
	db $3d
	db $43
	db $50
	dw NoOverworldSequence ; Pointer to Script
Data_11f34:
	db NPC_LEGENDARY_CARD_BOTTOM_LEFT
	db $27
	db $3e
	db $44
	db $50
	dw NoOverworldSequence ; Pointer to Script
Data_11f3b:
	db NPC_LEGENDARY_CARD_BOTTOM_RIGHT
	db $27
	db $3f
	db $45
	db $50
	dw NoOverworldSequence ; Pointer to Script
Data_11f42:
	db NPC_LEGENDARY_CARD_RIGHT_SPARK
	db $27
	db $40
	db $46
	db $50
	dw NoOverworldSequence ; Pointer to Script
Data_11f49:
	db $00
	db $00
	db $00
	db $1e
	db $00
