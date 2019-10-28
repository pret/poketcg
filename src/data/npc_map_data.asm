; NPC Map data. Note: pre-load functions also run after battles
; Format:
; NPC, X position, Y Position, Direction,
; pre-load function. (Resets c flag if NPC should not be loaded)
MasonLabNPCS: ; 772f (4:1372f)
	db DRMASON, $0e, $06, SOUTH
	dw $5710
	db SAM, $04, $0e, EAST
	dw $5604
	db TECH1, $16, $08, WEST
	dw $0000
	db TECH2, $16, $14, SOUTH
	dw $0000
	db TECH3, $16, $16, WEST
	dw $0000
	db TECH4, $0a, $16, EAST
	dw $0000
	db TECH5, $06, $04, SOUTH
	dw $55eb
	db $00

DeckMachineRoomNPCS: ; 775a (4:1375a)
	db TECH6, $06, $08, SOUTH
	dw $0000
	db TECH7, $06, $16, WEST
	dw $0000
	db TECH8, $0a, $12, WEST
	dw $0000
	db AARON, $0c, $0c, WEST
	dw $0000
	db $00

IshiharasHouseNPCS: ; 7773 (4:13773)
	db NIKKI, $04, $04, NORTH
	dw Preload_NikkiInIshiharasHouse
	db ISHIHARA, $08, $08, SOUTH
	dw Preload_IshiharaInIshiharasHouse
	db RONALD1, $02, $04, WEST
	dw Preload_Ronald1InIshiharasHouse
	db $00

FightingClubEntranceNPCS: ; 7786 (4:13786)
	db CLERK1, $06, $02, SOUTH
	dw $0000
	db RONALD1, $08, $fe, SOUTH
	dw $685b
	db RONALD2, $fe, $08, NORTH
	dw $689a
	db RONALD3, $fe, $08, NORTH
	dw $6915
	db $00

FightingClubLobbyNPCS: ; 779f (4:1379f)
	db MAN1, $0c, $0e, WEST
	dw $0000
	db IMAKUNI, $12, $02, NORTH
	dw $5ceb
	db SPECS1, $12, $10, EAST
	dw $0000
	db BUTCH, $14, $10, WEST
	dw $0000
	db GRANNY1, $04, $10, WEST
	dw $5d98
	db CLERK10, $06, $04, SOUTH
	dw $0000
	db GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

FightingClubNPCS: ; 77ca (4:137ca)
	db CHRIS, $04, $08, SOUTH
	dw $5e43
	db MICHAEL, $0e, $0a, SOUTH
	dw $5e79
	db JESSICA, $12, $06, EAST
	dw $5ea5
	db MITCH, $0a, $04, SOUTH
	dw $0000
	db $00

RockClubEntranceNPCS: ; 77e3 (4:137e3)
	db CLERK2, $06, $02, SOUTH
	dw $0000
	db RONALD1, $08, $fe, SOUTH
	dw $685b
	db RONALD2, $fe, $08, NORTH
	dw $689a
	db RONALD3, $fe, $08, NORTH
	dw $6915
	db $00

RockClubLobbyNPCS: ; 77fc (4:137fc)
	db CHRIS, $12, $08, WEST
	dw $5ee9
	db MATTHEW, $06, $0e, EAST
	dw $0000
	db WOMAN1, $14, $12, NORTH
	dw $0000
	db CHAP1, $0e, $10, EAST
	dw $0000
	db LASS3, $10, $04, SOUTH
	dw $5fcb
	db CLERK10, $06, $04, SOUTH
	dw $0000
	db GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

RockClubNPCS: ; 7827 (4:13827)
	db RYAN, $14, $0e, EAST
	dw $0000
	db ANDREW, $06, $14, NORTH
	dw $0000
	db GENE, $0c, $06, NORTH
	dw $0000
	db $00

WaterClubEntranceNPCS: ; 783a (4:1383a)
	db CLERK3, $06, $02, SOUTH
	dw $0000
	db RONALD1, $08, $fe, SOUTH
	dw $685b
	db RONALD2, $fe, $08, NORTH
	dw $689a
	db RONALD3, $fe, $08, NORTH
	dw $6915
	db $00

WaterClubLobbyNPCS: ; 7853 (4:13853)
	db GAL1, $06, $0e, SOUTH
	dw $0000
	db LASS1, $10, $0a, SOUTH
	dw $0000
	db IMAKUNI, $12, $02, NORTH
	dw Preload_ImakuniInWaterClubLobby
	db MAN2, $04, $12, EAST
	dw Preload_Man2InWaterClubLobby
	db PAPPY2, $16, $10, NORTH
	dw $0000
	db CLERK10, $06, $04, SOUTH
	dw $0000
	db GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

WaterClubNPCS: ; 787e (4:1387e)
	db SARA, $06, $12, EAST
	dw $0000
	db AMANDA, $16, $14, WEST
	dw $0000
	db JOSHUA, $16, $08, SOUTH
	dw $0000
	db AMY, $16, $04, SOUTH
	dw Preload_Amy
	db $00

LightningClubEntranceNPCS: ; 7897 (4:13897)
	db CLERK4, $06, $02, SOUTH
	dw $0000
	db RONALD1, $08, $fe, SOUTH
	dw $685b
	db RONALD2, $fe, $08, NORTH
	dw $689a
	db RONALD3, $fe, $08, NORTH
	dw $6915
	db $00

LightningClubLobbyNPCS: ; 78b0 (4:138b0)
	db CHAP2, $12, $10, WEST
	dw $0000
	db IMAKUNI, $12, $02, NORTH
	dw $637b
	db LASS4, $08, $0c, SOUTH
	dw $0000
	db HOOD1, $14, $08, SOUTH
	dw $0000
	db CLERK10, $06, $04, SOUTH
	dw $0000
	db GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

LightningClubNPCS: ; 78d5 (4:138d5)
	db JENNIFER, $0e, $12, SOUTH
	dw $0000
	db NICHOLAS, $06, $0a, SOUTH
	dw $0000
	db BRANDON, $16, $0c, NORTH
	dw $0000
	db ISAAC, $0c, $04, NORTH
	dw $6494
	db $00

GrassClubEntranceNPCS: ; 78ee (4:138ee)
	db CLERK5, $06, $02, SOUTH
	dw $0000
	db MICHAEL, $0e, $08, SOUTH
	dw $656a
	db RONALD1, $08, $fe, SOUTH
	dw $685b
	db RONALD2, $fe, $08, NORTH
	dw $689a
	db RONALD3, $fe, $08, NORTH
	dw $6915
	db $00

GrassClubLobbyNPCS: ; 790d (4:1390d)
	db BRITTANY, $0c, $0e, WEST
	dw $0000
	db LASS2, $12, $08, SOUTH
	dw $0000
	db GRANNY2, $04, $10, EAST
	dw $0000
	db GAL2, $14, $10, NORTH
	dw $66dc
	db CLERK10, $06, $04, SOUTH
	dw $0000
	db GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

GrassClubNPCS: ; 7932 (4:13932)
	db KRISTIN, $04, $0a, EAST
	dw $0000
	db HEATHER, $0e, $10, SOUTH
	dw $0000
	db NIKKI, $0c, $04, SOUTH
	dw $6796
	db $00

PsychicClubEntranceNPCS: ; 7945 (4:13945)
	db CLERK6, $06, $02, SOUTH
	dw $0000
	db RONALD1, $08, $fe, SOUTH
	dw $685b
	db RONALD2, $fe, $08, NORTH
	dw $689a
	db RONALD3, $fe, $08, NORTH
	dw $6915
	db LAD3, $0e, $04, SOUTH
	dw $0000
	db $00

PsychicClubLobbyNPCS: ; 7964 (4:13964)
	db ROBERT, $14, $08, NORTH
	dw $0000
	db PAPPY1, $04, $10, EAST
	dw $0000
	db RONALD1, $0c, $0a, EAST
	dw $69f7
	db GAL3, $10, $0e, WEST
	dw $0000
	db CHAP4, $18, $10, SOUTH
	dw $0000
	db CLERK10, $06, $04, SOUTH
	dw $0000
	db GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

PsychicClubNPCS: ; 798f (4:1398f)
	db DANIEL, $08, $08, NORTH
	dw $0000
	db STEPHANIE, $16, $0c, EAST
	dw $0000
	db MURRAY2, $02, $02, WEST
	dw $6ad0
	db MURRAY1, $0c, $06, SOUTH
	dw $6ada
	db $00

ScienceClubEntranceNPCS: ; 79a8 (4:139a8)
	db CLERK7, $06, $02, SOUTH
	dw $0000
	db RONALD1, $08, $fe, SOUTH
	dw $685b
	db RONALD2, $fe, $08, NORTH
	dw $689a
	db RONALD3, $fe, $08, NORTH
	dw $6915
	db $00

ScienceClubLobbyNPCS: ; 79c1 (4:139c1)
	db LAD1, $12, $12, NORTH
	dw $0000
	db IMAKUNI, $12, $02, NORTH
	dw $6b65
	db MAN3, $04, $0e, WEST
	dw $0000
	db SPECS2, $0c, $0e, WEST
	dw $0000
	db SPECS3, $16, $08, SOUTH
	dw $0000
	db CLERK10, $06, $04, SOUTH
	dw $0000
	db GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

ScienceClubNPCS: ; 79ec (4:139ec)
	db JOSEPH, $08, $0a, SOUTH
	dw $6cc4
	db DAVID, $14, $04, NORTH
	dw $0000
	db ERIK, $06, $12, SOUTH
	dw $0000
	db RICK, $04, $04, NORTH
	dw $0000
	db $00

FireClubEntranceNPCS: ; 7a05 (4:13a05)
	db CLERK8, $06, $02, SOUTH
	dw $0000
	db RONALD1, $08, $fe, SOUTH
	dw $685b
	db RONALD2, $fe, $08, NORTH
	dw $689a
	db RONALD3, $fe, $08, NORTH
	dw $6915
	db $00

FireClubLobbyNPCS: ; 7a1e (4:13a1e)
	db JESSICA, $0c, $0e, WEST
	dw $6d8d
	db LAD2, $12, $06, EAST
	dw $6e25
	db CHAP3, $06, $0a, NORTH
	dw $0000
	db MANIA, $14, $12, NORTH
	dw $0000
	db CLERK10, $06, $04, SOUTH
	dw $0000
	db GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

FireClubNPCS: ; 7a43 (4:13a43)
	db JOHN, $0c, $12, SOUTH
	dw $0000
	db ADAM, $08, $0e, SOUTH
	dw $0000
	db JONATHAN, $12, $0a, SOUTH
	dw $0000
	db KEN, $0e, $04, SOUTH
	dw $0000
	db $00

ChallengeHallEntranceNPCS: ; 7a5c (4:13a5c)
	db CLERK9, $06, $02, SOUTH
	dw $6f96
	db $00

ChallengeHallLobbyNPCS: ; 7a63 (4:13a63)
	db PAPPY3, $06, $0e, EAST
	dw $707a
	db CHAMP, $10, $12, WEST
	dw $707a
	db HOOD2, $14, $08, SOUTH
	dw $707a
	db LASS5, $16, $10, WEST
	dw $707a
	db GAL4, $0c, $0e, EAST
	dw $7075
	db CHAP5, $10, $08, WEST
	dw $7075
	db RONALD1, $08, $0c, SOUTH
	dw $70b4
	db CLERK10, $06, $04, SOUTH
	dw $0000
	db GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

ChallengeHallNPCS: ; 7a9a (4:13a9a)
	db CLERK12, $0a, $12, SOUTH
	dw $707a
	db CLERK13, $14, $12, SOUTH
	dw $707a
	db GUIDE, $0e, $14, SOUTH
	dw Preload_Guide
	db HOST, $0e, $04, SOUTH
	dw $707a
	db $ff, $12, $08, WEST ; pre-load function chooses NPC to load
	dw $7559
	db $00

PokemonDomeEntranceNPCS: ; 7ab9 (4:13ab9)
	db RONALD1, $0e, $12, SOUTH
	dw $0000
	db $00

PokemonDomeNPCS: ; 7ac0 (4:13ac0)
	db COURTNEY, $12, $02, SOUTH
	dw $774b
	db STEVE, $16, $02, SOUTH
	dw $778c
	db JACK, $08, $02, SOUTH
	dw $77a3
	db ROD, $0c, $02, SOUTH
	dw $77ba
	db RONALD1, $1e, $00, SOUTH
	dw $77d6
	db $00

HallOfHonorNPCS: ; 7adf (4:13adf)
	db LEGEND_CARDS_TOP_LEFT, $0a, $08, SOUTH
	dw $0000
	db LEGEND_CARDS_TOP_RIGHT, $0c, $08, SOUTH
	dw $0000
	db LEGEND_CARDS_LEFT_SPARK, $08, $0a, SOUTH
	dw $0000
	db LEGEND_CARDS_BOTTOM_LEFT, $0a, $0a, SOUTH
	dw $0000
	db LEGEND_CARDS_BOTTOM_RIGHT, $0c, $0a, SOUTH
	dw $0000
	db LEGEND_CARDS_RIGHT_SPARK, $0e, $0a, SOUTH
	dw $0000
	db $00

