; NPC Map data. Note: pre-load functions also run after duels
; Format:
; NPC, X position, Y Position, Direction,
; pre-load function. (Resets c flag if NPC should not be loaded)
MasonLabNPCS:
	db NPC_DRMASON, $0e, $06, SOUTH
	dw Preload_DrMason
	db NPC_SAM, $04, $0e, EAST
	dw Preload_Sam
	db NPC_TECH1, $16, $08, WEST
	dw NULL
	db NPC_TECH2, $16, $14, SOUTH
	dw NULL
	db NPC_TECH3, $16, $16, WEST
	dw NULL
	db NPC_TECH4, $0a, $16, EAST
	dw NULL
	db NPC_TECH5, $06, $04, SOUTH
	dw Preload_Tech5
	db $00

DeckMachineRoomNPCS:
	db NPC_TECH6, $06, $08, SOUTH
	dw NULL
	db NPC_TECH7, $06, $16, WEST
	dw NULL
	db NPC_TECH8, $0a, $12, WEST
	dw NULL
	db NPC_AARON, $0c, $0c, WEST
	dw NULL
	db $00

IshiharasHouseNPCS:
	db NPC_NIKKI, $04, $04, NORTH
	dw Preload_NikkiInIshiharasHouse
	db NPC_ISHIHARA, $08, $08, SOUTH
	dw Preload_IshiharaInIshiharasHouse
	db NPC_RONALD1, $02, $04, WEST
	dw Preload_Ronald1InIshiharasHouse
	db $00

FightingClubEntranceNPCS:
	db NPC_CLERK1, $06, $02, SOUTH
	dw NULL
	db NPC_RONALD1, $08, $fe, SOUTH
	dw Preload_Ronald1InClubEntrance
	db NPC_RONALD2, $fe, $08, NORTH
	dw Preload_Ronald2InClubEntrance
	db NPC_RONALD3, $fe, $08, NORTH
	dw Preload_Ronald3InClubEntrance
	db $00

FightingClubLobbyNPCS:
	db NPC_MAN1, $0c, $0e, WEST
	dw NULL
	db NPC_IMAKUNI, $12, $02, NORTH
	dw Preload_ImakuniInFightingClubLobby
	db NPC_SPECS1, $12, $10, EAST
	dw NULL
	db NPC_BUTCH, $14, $10, WEST
	dw NULL
	db NPC_GRANNY1, $04, $10, WEST
	dw Preload_Granny1
	db NPC_CLERK10, $06, $04, SOUTH
	dw NULL
	db NPC_GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

FightingClubNPCS:
	db NPC_CHRIS, $04, $08, SOUTH
	dw Preload_ChrisInFightingClub
	db NPC_MICHAEL, $0e, $0a, SOUTH
	dw Preload_MichaelInFightingClub
	db NPC_JESSICA, $12, $06, EAST
	dw Preload_JessicaInFightingClub
	db NPC_MITCH, $0a, $04, SOUTH
	dw NULL
	db $00

RockClubEntranceNPCS:
	db NPC_CLERK2, $06, $02, SOUTH
	dw NULL
	db NPC_RONALD1, $08, $fe, SOUTH
	dw Preload_Ronald1InClubEntrance
	db NPC_RONALD2, $fe, $08, NORTH
	dw Preload_Ronald2InClubEntrance
	db NPC_RONALD3, $fe, $08, NORTH
	dw Preload_Ronald3InClubEntrance
	db $00

RockClubLobbyNPCS:
	db NPC_CHRIS, $12, $08, WEST
	dw Preload_ChrisInRockClubLobby
	db NPC_MATTHEW, $06, $0e, EAST
	dw NULL
	db NPC_WOMAN1, $14, $12, NORTH
	dw NULL
	db NPC_CHAP1, $0e, $10, EAST
	dw NULL
	db NPC_LASS3, $10, $04, SOUTH
	dw Preload_Lass3
	db NPC_CLERK10, $06, $04, SOUTH
	dw NULL
	db NPC_GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

RockClubNPCS:
	db NPC_RYAN, $14, $0e, EAST
	dw NULL
	db NPC_ANDREW, $06, $14, NORTH
	dw NULL
	db NPC_GENE, $0c, $06, NORTH
	dw NULL
	db $00

WaterClubEntranceNPCS:
	db NPC_CLERK3, $06, $02, SOUTH
	dw NULL
	db NPC_RONALD1, $08, $fe, SOUTH
	dw Preload_Ronald1InClubEntrance
	db NPC_RONALD2, $fe, $08, NORTH
	dw Preload_Ronald2InClubEntrance
	db NPC_RONALD3, $fe, $08, NORTH
	dw Preload_Ronald3InClubEntrance
	db $00

WaterClubLobbyNPCS:
	db NPC_GAL1, $06, $0e, SOUTH
	dw NULL
	db NPC_LASS1, $10, $0a, SOUTH
	dw NULL
	db NPC_IMAKUNI, $12, $02, NORTH
	dw Preload_ImakuniInWaterClubLobby
	db NPC_MAN2, $04, $12, EAST
	dw Preload_Man2
	db NPC_PAPPY2, $16, $10, NORTH
	dw NULL
	db NPC_CLERK10, $06, $04, SOUTH
	dw NULL
	db NPC_GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

WaterClubNPCS:
	db NPC_SARA, $06, $12, EAST
	dw NULL
	db NPC_AMANDA, $16, $14, WEST
	dw NULL
	db NPC_JOSHUA, $16, $08, SOUTH
	dw NULL
	db NPC_AMY, $16, $04, SOUTH
	dw Preload_Amy
	db $00

LightningClubEntranceNPCS:
	db NPC_CLERK4, $06, $02, SOUTH
	dw NULL
	db NPC_RONALD1, $08, $fe, SOUTH
	dw Preload_Ronald1InClubEntrance
	db NPC_RONALD2, $fe, $08, NORTH
	dw Preload_Ronald2InClubEntrance
	db NPC_RONALD3, $fe, $08, NORTH
	dw Preload_Ronald3InClubEntrance
	db $00

LightningClubLobbyNPCS:
	db NPC_CHAP2, $12, $10, WEST
	dw NULL
	db NPC_IMAKUNI, $12, $02, NORTH
	dw Preload_ImakuniInLightningClubLobby
	db NPC_LASS4, $08, $0c, SOUTH
	dw NULL
	db NPC_HOOD1, $14, $08, SOUTH
	dw NULL
	db NPC_CLERK10, $06, $04, SOUTH
	dw NULL
	db NPC_GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

LightningClubNPCS:
	db NPC_JENNIFER, $0e, $12, SOUTH
	dw NULL
	db NPC_NICHOLAS, $06, $0a, SOUTH
	dw NULL
	db NPC_BRANDON, $16, $0c, NORTH
	dw NULL
	db NPC_ISAAC, $0c, $04, NORTH
	dw Preload_Isaac
	db $00

GrassClubEntranceNPCS:
	db NPC_CLERK5, $06, $02, SOUTH
	dw NULL
	db NPC_MICHAEL, $0e, $08, SOUTH
	dw Preload_MichaelInGrassClubEntrance
	db NPC_RONALD1, $08, $fe, SOUTH
	dw Preload_Ronald1InClubEntrance
	db NPC_RONALD2, $fe, $08, NORTH
	dw Preload_Ronald2InClubEntrance
	db NPC_RONALD3, $fe, $08, NORTH
	dw Preload_Ronald3InClubEntrance
	db $00

GrassClubLobbyNPCS:
	db NPC_BRITTANY, $0c, $0e, WEST
	dw NULL
	db NPC_LASS2, $12, $08, SOUTH
	dw NULL
	db NPC_GRANNY2, $04, $10, EAST
	dw NULL
	db NPC_GAL2, $14, $10, NORTH
	dw Preload_Gal2
	db NPC_CLERK10, $06, $04, SOUTH
	dw NULL
	db NPC_GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

GrassClubNPCS:
	db NPC_KRISTIN, $04, $0a, EAST
	dw NULL
	db NPC_HEATHER, $0e, $10, SOUTH
	dw NULL
	db NPC_NIKKI, $0c, $04, SOUTH
	dw Preload_NikkiInGrassClub
	db $00

PsychicClubEntranceNPCS:
	db NPC_CLERK6, $06, $02, SOUTH
	dw NULL
	db NPC_RONALD1, $08, $fe, SOUTH
	dw Preload_Ronald1InClubEntrance
	db NPC_RONALD2, $fe, $08, NORTH
	dw Preload_Ronald2InClubEntrance
	db NPC_RONALD3, $fe, $08, NORTH
	dw Preload_Ronald3InClubEntrance
	db NPC_LAD3, $0e, $04, SOUTH
	dw NULL
	db $00

PsychicClubLobbyNPCS:
	db NPC_ROBERT, $14, $08, NORTH
	dw NULL
	db NPC_PAPPY1, $04, $10, EAST
	dw NULL
	db NPC_RONALD1, $0c, $0a, EAST
	dw Preload_Ronald1InPsychicClubLobby
	db NPC_GAL3, $10, $0e, WEST
	dw NULL
	db NPC_CHAP4, $18, $10, SOUTH
	dw NULL
	db NPC_CLERK10, $06, $04, SOUTH
	dw NULL
	db NPC_GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

PsychicClubNPCS:
	db NPC_DANIEL, $08, $08, NORTH
	dw NULL
	db NPC_STEPHANIE, $16, $0c, EAST
	dw NULL
	db NPC_MURRAY2, $02, $02, WEST
	dw Preload_Murray2
	db NPC_MURRAY1, $0c, $06, SOUTH
	dw Preload_Murray1
	db $00

ScienceClubEntranceNPCS:
	db NPC_CLERK7, $06, $02, SOUTH
	dw NULL
	db NPC_RONALD1, $08, $fe, SOUTH
	dw Preload_Ronald1InClubEntrance
	db NPC_RONALD2, $fe, $08, NORTH
	dw Preload_Ronald2InClubEntrance
	db NPC_RONALD3, $fe, $08, NORTH
	dw Preload_Ronald3InClubEntrance
	db $00

ScienceClubLobbyNPCS:
	db NPC_LAD1, $12, $12, NORTH
	dw NULL
	db NPC_IMAKUNI, $12, $02, NORTH
	dw Preload_ImakuniInScienceClubLobby
	db NPC_MAN3, $04, $0e, WEST
	dw NULL
	db NPC_SPECS2, $0c, $0e, WEST
	dw NULL
	db NPC_SPECS3, $16, $08, SOUTH
	dw NULL
	db NPC_CLERK10, $06, $04, SOUTH
	dw NULL
	db NPC_GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

ScienceClubNPCS:
	db NPC_JOSEPH, $08, $0a, SOUTH
	dw Preload_Joseph
	db NPC_DAVID, $14, $04, NORTH
	dw NULL
	db NPC_ERIK, $06, $12, SOUTH
	dw NULL
	db NPC_RICK, $04, $04, NORTH
	dw NULL
	db $00

FireClubEntranceNPCS:
	db NPC_CLERK8, $06, $02, SOUTH
	dw NULL
	db NPC_RONALD1, $08, $fe, SOUTH
	dw Preload_Ronald1InClubEntrance
	db NPC_RONALD2, $fe, $08, NORTH
	dw Preload_Ronald2InClubEntrance
	db NPC_RONALD3, $fe, $08, NORTH
	dw Preload_Ronald3InClubEntrance
	db $00

FireClubLobbyNPCS:
	db NPC_JESSICA, $0c, $0e, WEST
	dw Preload_JessicaInFireClubLobby
	db NPC_LAD2, $12, $06, EAST
	dw Preload_Lad2
	db NPC_CHAP3, $06, $0a, NORTH
	dw NULL
	db NPC_MANIA, $14, $12, NORTH
	dw NULL
	db NPC_CLERK10, $06, $04, SOUTH
	dw NULL
	db NPC_GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

FireClubNPCS:
	db NPC_JOHN, $0c, $12, SOUTH
	dw NULL
	db NPC_ADAM, $08, $0e, SOUTH
	dw NULL
	db NPC_JONATHAN, $12, $0a, SOUTH
	dw NULL
	db NPC_KEN, $0e, $04, SOUTH
	dw NULL
	db $00

ChallengeHallEntranceNPCS:
	db NPC_CLERK9, $06, $02, SOUTH
	dw Preload_Clerk9
	db $00

ChallengeHallLobbyNPCS:
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
	dw NULL
	db NPC_GIFT_CENTER_CLERK, $0a, $04, SOUTH
	dw Preload_GiftCenterClerk
	db $00

ChallengeHallNPCS:
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

PokemonDomeEntranceNPCS:
	db NPC_RONALD1, $0e, $12, SOUTH
	dw NULL
	db $00

PokemonDomeNPCS:
	db NPC_COURTNEY, $12, $02, SOUTH
	dw Preload_Courtney
	db NPC_STEVE, $16, $02, SOUTH
	dw Preload_Steve
	db NPC_JACK, $08, $02, SOUTH
	dw Preload_Jack
	db NPC_ROD, $0c, $02, SOUTH
	dw Preload_Rod
	db NPC_RONALD1, $1e, $00, SOUTH
	dw Preload_Ronald1InPokemonDome
	db $00

HallOfHonorNPCS:
	db NPC_LEGENDARY_CARD_TOP_LEFT, $0a, $08, SOUTH
	dw NULL
	db NPC_LEGENDARY_CARD_TOP_RIGHT, $0c, $08, SOUTH
	dw NULL
	db NPC_LEGENDARY_CARD_LEFT_SPARK, $08, $0a, SOUTH
	dw NULL
	db NPC_LEGENDARY_CARD_BOTTOM_LEFT, $0a, $0a, SOUTH
	dw NULL
	db NPC_LEGENDARY_CARD_BOTTOM_RIGHT, $0c, $0a, SOUTH
	dw NULL
	db NPC_LEGENDARY_CARD_RIGHT_SPARK, $0e, $0a, SOUTH
	dw NULL
	db $00
