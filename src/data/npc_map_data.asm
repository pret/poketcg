; NPC Map data. Note: pre-load functions also run after battles
; Format:
; NPC, X position, Y Position, Direction,
; pre-load function. (Resets c flag if NPC should not be loaded)
MasonLabNPCS: ; 772f (4:1372f)
	db NPC_DRMASON, $0e, $06, SOUTH
	dw $5710
	db NPC_SAM, $04, $0e, EAST
	dw $5604
	db NPC_TECH1, $16, $08, WEST
	dw $0000
	db NPC_TECH2, $16, $14, SOUTH
	dw $0000
	db NPC_TECH3, $16, $16, WEST
	dw $0000
	db NPC_TECH4, $0a, $16, EAST
	dw $0000
	db NPC_TECH5, $06, $04, SOUTH
	dw $55eb
	db $00

DeckMachineRoomNPCS: ; 775a (4:1375a)
	db NPC_TECH6, $06, $08, SOUTH
	dw $0000
	db NPC_TECH7, $06, $16, WEST
	dw $0000
	db NPC_TECH8, $0a, $12, WEST
	dw $0000
	db NPC_AARON, $0c, $0c, WEST
	dw $0000
	db $00

IshiharasHouseNPCS: ; 7773 (4:13773)
	db NPC_NIKKI, $04, $04, NORTH
	dw Preload_NikkiInIshiharasHouse
	db NPC_ISHIHARA, $08, $08, SOUTH
	dw Preload_IshiharaInIshiharasHouse
	db NPC_RONALD1, $02, $04, WEST
	dw Preload_Ronald1InIshiharasHouse
	db $00

FightingClubEntranceNPCS: ; 7786 (4:13786)
	db NPC_CLERK1, $06, $02, SOUTH
	dw $0000
	db NPC_RONALD1, $08, $fe, SOUTH
	dw $685b
	db NPC_RONALD2, $fe, $08, NORTH
	dw $689a
	db NPC_RONALD3, $fe, $08, NORTH
	dw $6915
	db $00

FightingClubLobbyNPCS: ; 779f (4:1379f)
	db NPC_MAN1, $0c, $0e, WEST
	dw $0000
	db NPC_IMAKUNI, $12, $02, NORTH
	dw $5ceb
	db NPC_SPECS1, $12, $10, EAST
	dw $0000
	db NPC_BUTCH, $14, $10, WEST
	dw $0000
	db NPC_GRANNY1, $04, $10, WEST
	dw $5d98
	db NPC_CLERK10, $06, $04, SOUTH
	dw $0000
	db NPC_GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

FightingClubNPCS: ; 77ca (4:137ca)
	db NPC_CHRIS, $04, $08, SOUTH
	dw $5e43
	db NPC_MICHAEL, $0e, $0a, SOUTH
	dw $5e79
	db NPC_JESSICA, $12, $06, EAST
	dw $5ea5
	db NPC_MITCH, $0a, $04, SOUTH
	dw $0000
	db $00

RockClubEntranceNPCS: ; 77e3 (4:137e3)
	db NPC_CLERK2, $06, $02, SOUTH
	dw $0000
	db NPC_RONALD1, $08, $fe, SOUTH
	dw $685b
	db NPC_RONALD2, $fe, $08, NORTH
	dw $689a
	db NPC_RONALD3, $fe, $08, NORTH
	dw $6915
	db $00

RockClubLobbyNPCS: ; 77fc (4:137fc)
	db NPC_CHRIS, $12, $08, WEST
	dw $5ee9
	db NPC_MATTHEW, $06, $0e, EAST
	dw $0000
	db NPC_WOMAN1, $14, $12, NORTH
	dw $0000
	db NPC_CHAP1, $0e, $10, EAST
	dw $0000
	db NPC_LASS3, $10, $04, SOUTH
	dw $5fcb
	db NPC_CLERK10, $06, $04, SOUTH
	dw $0000
	db NPC_GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

RockClubNPCS: ; 7827 (4:13827)
	db NPC_RYAN, $14, $0e, EAST
	dw $0000
	db NPC_ANDREW, $06, $14, NORTH
	dw $0000
	db NPC_GENE, $0c, $06, NORTH
	dw $0000
	db $00

WaterClubEntranceNPCS: ; 783a (4:1383a)
	db NPC_CLERK3, $06, $02, SOUTH
	dw $0000
	db NPC_RONALD1, $08, $fe, SOUTH
	dw $685b
	db NPC_RONALD2, $fe, $08, NORTH
	dw $689a
	db NPC_RONALD3, $fe, $08, NORTH
	dw $6915
	db $00

WaterClubLobbyNPCS: ; 7853 (4:13853)
	db NPC_GAL1, $06, $0e, SOUTH
	dw $0000
	db NPC_LASS1, $10, $0a, SOUTH
	dw $0000
	db NPC_IMAKUNI, $12, $02, NORTH
	dw Preload_ImakuniInWaterClubLobby
	db NPC_MAN2, $04, $12, EAST
	dw Preload_Man2InWaterClubLobby
	db NPC_PAPPY2, $16, $10, NORTH
	dw $0000
	db NPC_CLERK10, $06, $04, SOUTH
	dw $0000
	db NPC_GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

WaterClubNPCS: ; 787e (4:1387e)
	db NPC_SARA, $06, $12, EAST
	dw $0000
	db NPC_AMANDA, $16, $14, WEST
	dw $0000
	db NPC_JOSHUA, $16, $08, SOUTH
	dw $0000
	db NPC_AMY, $16, $04, SOUTH
	dw Preload_Amy
	db $00

LightningClubEntranceNPCS: ; 7897 (4:13897)
	db NPC_CLERK4, $06, $02, SOUTH
	dw $0000
	db NPC_RONALD1, $08, $fe, SOUTH
	dw $685b
	db NPC_RONALD2, $fe, $08, NORTH
	dw $689a
	db NPC_RONALD3, $fe, $08, NORTH
	dw $6915
	db $00

LightningClubLobbyNPCS: ; 78b0 (4:138b0)
	db NPC_CHAP2, $12, $10, WEST
	dw $0000
	db NPC_IMAKUNI, $12, $02, NORTH
	dw $637b
	db NPC_LASS4, $08, $0c, SOUTH
	dw $0000
	db NPC_HOOD1, $14, $08, SOUTH
	dw $0000
	db NPC_CLERK10, $06, $04, SOUTH
	dw $0000
	db NPC_GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

LightningClubNPCS: ; 78d5 (4:138d5)
	db NPC_JENNIFER, $0e, $12, SOUTH
	dw $0000
	db NPC_NICHOLAS, $06, $0a, SOUTH
	dw $0000
	db NPC_BRANDON, $16, $0c, NORTH
	dw $0000
	db NPC_ISAAC, $0c, $04, NORTH
	dw $6494
	db $00

GrassClubEntranceNPCS: ; 78ee (4:138ee)
	db NPC_CLERK5, $06, $02, SOUTH
	dw $0000
	db NPC_MICHAEL, $0e, $08, SOUTH
	dw $656a
	db NPC_RONALD1, $08, $fe, SOUTH
	dw $685b
	db NPC_RONALD2, $fe, $08, NORTH
	dw $689a
	db NPC_RONALD3, $fe, $08, NORTH
	dw $6915
	db $00

GrassClubLobbyNPCS: ; 790d (4:1390d)
	db NPC_BRITTANY, $0c, $0e, WEST
	dw $0000
	db NPC_LASS2, $12, $08, SOUTH
	dw $0000
	db NPC_GRANNY2, $04, $10, EAST
	dw $0000
	db NPC_GAL2, $14, $10, NORTH
	dw $66dc
	db NPC_CLERK10, $06, $04, SOUTH
	dw $0000
	db NPC_GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

GrassClubNPCS: ; 7932 (4:13932)
	db NPC_KRISTIN, $04, $0a, EAST
	dw $0000
	db NPC_HEATHER, $0e, $10, SOUTH
	dw $0000
	db NPC_NIKKI, $0c, $04, SOUTH
	dw $6796
	db $00

PsychicClubEntranceNPCS: ; 7945 (4:13945)
	db NPC_CLERK6, $06, $02, SOUTH
	dw $0000
	db NPC_RONALD1, $08, $fe, SOUTH
	dw $685b
	db NPC_RONALD2, $fe, $08, NORTH
	dw $689a
	db NPC_RONALD3, $fe, $08, NORTH
	dw $6915
	db NPC_LAD3, $0e, $04, SOUTH
	dw $0000
	db $00

PsychicClubLobbyNPCS: ; 7964 (4:13964)
	db NPC_ROBERT, $14, $08, NORTH
	dw $0000
	db NPC_PAPPY1, $04, $10, EAST
	dw $0000
	db NPC_RONALD1, $0c, $0a, EAST
	dw $69f7
	db NPC_GAL3, $10, $0e, WEST
	dw $0000
	db NPC_CHAP4, $18, $10, SOUTH
	dw $0000
	db NPC_CLERK10, $06, $04, SOUTH
	dw $0000
	db NPC_GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

PsychicClubNPCS: ; 798f (4:1398f)
	db NPC_DANIEL, $08, $08, NORTH
	dw $0000
	db NPC_STEPHANIE, $16, $0c, EAST
	dw $0000
	db NPC_MURRAY2, $02, $02, WEST
	dw $6ad0
	db NPC_MURRAY1, $0c, $06, SOUTH
	dw $6ada
	db $00

ScienceClubEntranceNPCS: ; 79a8 (4:139a8)
	db NPC_CLERK7, $06, $02, SOUTH
	dw $0000
	db NPC_RONALD1, $08, $fe, SOUTH
	dw $685b
	db NPC_RONALD2, $fe, $08, NORTH
	dw $689a
	db NPC_RONALD3, $fe, $08, NORTH
	dw $6915
	db $00

ScienceClubLobbyNPCS: ; 79c1 (4:139c1)
	db NPC_LAD1, $12, $12, NORTH
	dw $0000
	db NPC_IMAKUNI, $12, $02, NORTH
	dw $6b65
	db NPC_MAN3, $04, $0e, WEST
	dw $0000
	db NPC_SPECS2, $0c, $0e, WEST
	dw $0000
	db NPC_SPECS3, $16, $08, SOUTH
	dw $0000
	db NPC_CLERK10, $06, $04, SOUTH
	dw $0000
	db NPC_GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

ScienceClubNPCS: ; 79ec (4:139ec)
	db NPC_JOSEPH, $08, $0a, SOUTH
	dw $6cc4
	db NPC_DAVID, $14, $04, NORTH
	dw $0000
	db NPC_ERIK, $06, $12, SOUTH
	dw $0000
	db NPC_RICK, $04, $04, NORTH
	dw $0000
	db $00

FireClubEntranceNPCS: ; 7a05 (4:13a05)
	db NPC_CLERK8, $06, $02, SOUTH
	dw $0000
	db NPC_RONALD1, $08, $fe, SOUTH
	dw $685b
	db NPC_RONALD2, $fe, $08, NORTH
	dw $689a
	db NPC_RONALD3, $fe, $08, NORTH
	dw $6915
	db $00

FireClubLobbyNPCS: ; 7a1e (4:13a1e)
	db NPC_JESSICA, $0c, $0e, WEST
	dw $6d8d
	db NPC_LAD2, $12, $06, EAST
	dw $6e25
	db NPC_CHAP3, $06, $0a, NORTH
	dw $0000
	db NPC_MANIA, $14, $12, NORTH
	dw $0000
	db NPC_CLERK10, $06, $04, SOUTH
	dw $0000
	db NPC_GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

FireClubNPCS: ; 7a43 (4:13a43)
	db NPC_JOHN, $0c, $12, SOUTH
	dw $0000
	db NPC_ADAM, $08, $0e, SOUTH
	dw $0000
	db NPC_JONATHAN, $12, $0a, SOUTH
	dw $0000
	db NPC_KEN, $0e, $04, SOUTH
	dw $0000
	db $00

ChallengeHallEntranceNPCS: ; 7a5c (4:13a5c)
	db NPC_CLERK9, $06, $02, SOUTH
	dw Preload_Clerk9
	db $00

ChallengeHallLobbyNPCS: ; 7a63 (4:13a63)
	db NPC_PAPPY3, $06, $0e, EAST
	dw Preload_ChallengeHallNPCs1
	db NPC_CHAMP, $10, $12, WEST
	dw Preload_ChallengeHallNPCs1
	db NPC_HOOD2, $14, $08, SOUTH
	dw Preload_ChallengeHallNPCs1
	db NPC_LASS5, $16, $10, WEST
	dw Preload_ChallengeHallNPCs1
	db NPC_GAL4, $0c, $0e, EAST
	dw Preload_ChallengeHallNPCs2
	db NPC_CHAP5, $10, $08, WEST
	dw Preload_ChallengeHallNPCs2
	db NPC_RONALD1, $08, $0c, SOUTH
	dw Preload_ChallengeHallLobbyRonald1
	db NPC_CLERK10, $06, $04, SOUTH
	dw $0000
	db NPC_GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

ChallengeHallNPCS: ; 7a9a (4:13a9a)
	db NPC_CLERK12, $0a, $12, SOUTH
	dw Preload_ChallengeHallNPCs1
	db NPC_CLERK13, $14, $12, SOUTH
	dw Preload_ChallengeHallNPCs1
	db NPC_GUIDE, $0e, $14, SOUTH
	dw Preload_Guide
	db NPC_HOST, $0e, $04, SOUTH
	dw Preload_ChallengeHallNPCs1
	db $ff, $12, $08, WEST ; pre-load function chooses NPC to load
	dw Preload_ChallengeHallOpponent
	db $00

PokemonDomeEntranceNPCS: ; 7ab9 (4:13ab9)
	db NPC_RONALD1, $0e, $12, SOUTH
	dw $0000
	db $00

PokemonDomeNPCS: ; 7ac0 (4:13ac0)
	db NPC_COURTNEY, $12, $02, SOUTH
	dw $774b
	db NPC_STEVE, $16, $02, SOUTH
	dw $778c
	db NPC_JACK, $08, $02, SOUTH
	dw $77a3
	db NPC_ROD, $0c, $02, SOUTH
	dw $77ba
	db NPC_RONALD1, $1e, $00, SOUTH
	dw $77d6
	db $00

HallOfHonorNPCS: ; 7adf (4:13adf)
	db NPC_LEGENDARY_CARD_TOP_LEFT, $0a, $08, SOUTH
	dw $0000
	db NPC_LEGENDARY_CARD_TOP_RIGHT, $0c, $08, SOUTH
	dw $0000
	db NPC_LEGENDARY_CARD_LEFT_SPARK, $08, $0a, SOUTH
	dw $0000
	db NPC_LEGENDARY_CARD_BOTTOM_LEFT, $0a, $0a, SOUTH
	dw $0000
	db NPC_LEGENDARY_CARD_BOTTOM_RIGHT, $0c, $0a, SOUTH
	dw $0000
	db NPC_LEGENDARY_CARD_RIGHT_SPARK, $0e, $0a, SOUTH
	dw $0000
	db $00
