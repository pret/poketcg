WarpDataPointers: ; 1c099 (7:4099)
	dw $0000
	dw MasonLaboratoryWarpData
	dw DeckMachineRoomWarpData
	dw IshiharasHouseWarpData
	dw FightingClubEntranceWarpData
	dw FightingClubLobbyWarpData
	dw FightingClubWarpData
	dw RockClubEntranceWarpData
	dw RockClubLobbyWarpData
	dw RockClubWarpData
	dw WaterClubEntranceWarpData
	dw WaterClubLobbyWarpData
	dw WaterClubWarpData
	dw LightningClubEntranceWarpData
	dw LightningClubLobbyWarpData
	dw LightningClubWarpData
	dw GrassClubEntranceWarpData
	dw GrassClubLobbyWarpData
	dw GrassClubWarpData
	dw PsychicClubEntranceWarpData
	dw PsychicClubLobbyWarpData
	dw PsychicClubWarpData
	dw ScienceClubEntranceWarpData
	dw ScienceClubLobbyWarpData
	dw ScienceClubWarpData
	dw FireClubEntranceWarpData
	dw FireClubLobbyWarpData
	dw FireClubWarpData
	dw ChallengeHallEntranceWarpData
	dw ChallengeHallLobbyWarpData
	dw ChallengeHallWarpData
	dw PokemonDomeEntranceWarpData
	dw PokemonDomeWarpData
	dw HallOfHonorWarpData

; each warp is five bytes long
; coordinates are measured in tiles
; 1: x coordinate of current map
; 2: y coordinate of current map
; 3: id of connected map
; 4: x coordinate of connected map
; 5: y coordinate of connected map
; double null terminated
MasonLaboratoryWarpData: ; 1c0dd (7:40dd)
	db $0E,$1C,OVERWORLD_MAP,    $00,$00
	db $10,$1C,OVERWORLD_MAP,    $00,$00
	db $1A,$0A,DECK_MACHINE_ROOM,$02,$0A
	db $1A,$0C,DECK_MACHINE_ROOM,$02,$0C
	db $00,$00

DeckMachineRoomWarpData: ; 1c0f3 (7:40f3)
	db $00,$0A,MASON_LABORATORY,$18,$0A
	db $00,$0C,MASON_LABORATORY,$18,$0C
	db $00,$00

IshiharasHouseWarpData: ; 1c0ff (7:40ff)
	db $08,$16,OVERWORLD_MAP,$00,$00
	db $0A,$16,OVERWORLD_MAP,$00,$00
	db $00,$00

FightingClubEntranceWarpData: ; 1c10b (7:410b)
	db $08,$10,OVERWORLD_MAP,      $00,$00
	db $0A,$10,OVERWORLD_MAP,      $00,$00
	db $00,$06,FIGHTING_CLUB_LOBBY,$18,$0A
	db $00,$08,FIGHTING_CLUB_LOBBY,$18,$0C
	db $08,$00,FIGHTING_CLUB,      $0A,$0E
	db $0A,$00,FIGHTING_CLUB,      $0C,$0E
	db $00,$00

FightingClubLobbyWarpData: ; 1c12b (7:412b)
	db $1A,$0A,FIGHTING_CLUB_ENTRANCE,$02,$06
	db $1A,$0C,FIGHTING_CLUB_ENTRANCE,$02,$08
	db $00,$00

FightingClubWarpData: ; 1c137 (7:4137)
	db $0A,$10,FIGHTING_CLUB_ENTRANCE,$08,$02
	db $0C,$10,FIGHTING_CLUB_ENTRANCE,$0A,$02
	db $00,$00

RockClubEntranceWarpData: ; 1c143 (7:4143)
	db $08,$10,OVERWORLD_MAP,  $00,$00
	db $0A,$10,OVERWORLD_MAP,  $00,$00
	db $00,$06,ROCK_CLUB_LOBBY,$18,$0A
	db $00,$08,ROCK_CLUB_LOBBY,$18,$0C
	db $08,$00,ROCK_CLUB,      $0C,$1A
	db $0A,$00,ROCK_CLUB,      $0E,$1A
	db $00,$00

RockClubLobbyWarpData: ; 1c163 (7:4163)
	db $1A,$0A,ROCK_CLUB_ENTRANCE,$02,$06
	db $1A,$0C,ROCK_CLUB_ENTRANCE,$02,$08
	db $00,$00

RockClubWarpData: ; 1c16f (7:416f)
	db $0C,$1C,ROCK_CLUB_ENTRANCE,$08,$02
	db $0E,$1C,ROCK_CLUB_ENTRANCE,$0A,$02
	db $00,$00

WaterClubEntranceWarpData: ; 1c17b (7:417b)
	db $08,$10,OVERWORLD_MAP,   $00,$00
	db $0A,$10,OVERWORLD_MAP,   $00,$00
	db $00,$06,WATER_CLUB_LOBBY,$18,$0A
	db $00,$08,WATER_CLUB_LOBBY,$18,$0C
	db $08,$00,WATER_CLUB,      $0C,$1C
	db $0A,$00,WATER_CLUB,      $0E,$1C
	db $00,$00

WaterClubLobbyWarpData: ; 1c19b (7:419b)
	db $1A,$0A,WATER_CLUB_ENTRANCE,$02,$06
	db $1A,$0C,WATER_CLUB_ENTRANCE,$02,$08
	db $00,$00

WaterClubWarpData: ; 1c1a7 (7:41a7)
	db $0C,$1E,WATER_CLUB_ENTRANCE,$08,$02
	db $0E,$1E,WATER_CLUB_ENTRANCE,$0A,$02
	db $00,$00

LightningClubEntranceWarpData: ; 1c1b3 (7:41b3)
	db $08,$10,OVERWORLD_MAP,       $00,$00
	db $0A,$10,OVERWORLD_MAP,       $00,$00
	db $00,$06,LIGHTNING_CLUB_LOBBY,$18,$0A
	db $00,$08,LIGHTNING_CLUB_LOBBY,$18,$0C
	db $08,$00,LIGHTNING_CLUB,      $0C,$1C
	db $0A,$00,LIGHTNING_CLUB,      $0E,$1C
	db $00,$00

LightningClubLobbyWarpData: ; 1c1d3 (7:41d3)
	db $1A,$0A,LIGHTNING_CLUB_ENTRANCE,$02,$06
	db $1A,$0C,LIGHTNING_CLUB_ENTRANCE,$02,$08
	db $00,$00

LightningClubWarpData: ; 1c1df (7:41df)
	db $0C,$1E,LIGHTNING_CLUB_ENTRANCE,$08,$02
	db $0E,$1E,LIGHTNING_CLUB_ENTRANCE,$0A,$02
	db $00,$00

GrassClubEntranceWarpData: ; 1c1eb (7:41eb)
	db $08,$10,OVERWORLD_MAP,   $00,$00
	db $0A,$10,OVERWORLD_MAP,   $00,$00
	db $00,$06,GRASS_CLUB_LOBBY,$18,$0A
	db $00,$08,GRASS_CLUB_LOBBY,$18,$0C
	db $08,$00,GRASS_CLUB,      $0C,$1C
	db $0A,$00,GRASS_CLUB,      $0E,$1C
	db $00,$00

GrassClubLobbyWarpData: ; 1c20b (7:420b)
	db $1A,$0A,GRASS_CLUB_ENTRANCE,$02,$06
	db $1A,$0C,GRASS_CLUB_ENTRANCE,$02,$08
	db $00,$00

GrassClubWarpData: ; 1c217 (7:4217)
	db $0C,$1E,GRASS_CLUB_ENTRANCE,$08,$02
	db $0E,$1E,GRASS_CLUB_ENTRANCE,$0A,$02
	db $00,$00

PsychicClubEntranceWarpData: ; 1c223 (7:4223)
	db $08,$10,OVERWORLD_MAP,     $00,$00
	db $0A,$10,OVERWORLD_MAP,     $00,$00
	db $00,$06,PSYCHIC_CLUB_LOBBY,$18,$0A
	db $00,$08,PSYCHIC_CLUB_LOBBY,$18,$0C
	db $08,$00,PSYCHIC_CLUB,      $0C,$18
	db $0A,$00,PSYCHIC_CLUB,      $0E,$18
	db $00,$00

PsychicClubLobbyWarpData: ; 1c243 (7:4243)
	db $1A,$0A,PSYCHIC_CLUB_ENTRANCE,$02,$06
	db $1A,$0C,PSYCHIC_CLUB_ENTRANCE,$02,$08
	db $00,$00

PsychicClubWarpData: ; 1c24f (7:424f)
	db $0C,$1A,PSYCHIC_CLUB_ENTRANCE,$08,$02
	db $0E,$1A,PSYCHIC_CLUB_ENTRANCE,$0A,$02
	db $00,$00

ScienceClubEntranceWarpData: ; 1c25b (7:425b)
	db $08,$10,OVERWORLD_MAP,     $00,$00
	db $0A,$10,OVERWORLD_MAP,     $00,$00
	db $00,$06,SCIENCE_CLUB_LOBBY,$18,$0A
	db $00,$08,SCIENCE_CLUB_LOBBY,$18,$0C
	db $08,$00,SCIENCE_CLUB,      $0C,$1C
	db $0A,$00,SCIENCE_CLUB,      $0E,$1C
	db $00,$00

ScienceClubLobbyWarpData: ; 1c27b (7:427b)
	db $1A,$0A,SCIENCE_CLUB_ENTRANCE,$02,$06
	db $1A,$0C,SCIENCE_CLUB_ENTRANCE,$02,$08
	db $00,$00

ScienceClubWarpData: ; 1c287 (7:4287)
	db $0C,$1E,SCIENCE_CLUB_ENTRANCE,$08,$02
	db $0E,$1E,SCIENCE_CLUB_ENTRANCE,$0A,$02
	db $00,$00

FireClubEntranceWarpData: ; 1c293 (7:4293)
	db $08,$10,OVERWORLD_MAP,  $00,$00
	db $0A,$10,OVERWORLD_MAP,  $00,$00
	db $00,$06,FIRE_CLUB_LOBBY,$18,$0A
	db $00,$08,FIRE_CLUB_LOBBY,$18,$0C
	db $08,$00,FIRE_CLUB,      $0C,$1C
	db $0A,$00,FIRE_CLUB,      $0E,$1C
	db $00,$00

FireClubLobbyWarpData: ; 1c2b3 (7:42b3)
	db $1A,$0A,FIRE_CLUB_ENTRANCE,$02,$06
	db $1A,$0C,FIRE_CLUB_ENTRANCE,$02,$08
	db $00,$00

FireClubWarpData: ; 1c2bf (7:42bf)
	db $0C,$1E,FIRE_CLUB_ENTRANCE,$08,$02
	db $0E,$1E,FIRE_CLUB_ENTRANCE,$0A,$02
	db $00,$00

ChallengeHallEntranceWarpData: ; 1c2cb (7:42cb)
	db $08,$10,OVERWORLD_MAP,       $00,$00
	db $0A,$10,OVERWORLD_MAP,       $00,$00
	db $00,$06,CHALLENGE_HALL_LOBBY,$18,$0A
	db $00,$08,CHALLENGE_HALL_LOBBY,$18,$0C
	db $08,$00,CHALLENGE_HALL,      $0E,$1C
	db $0A,$00,CHALLENGE_HALL,      $10,$1C
	db $00,$00

ChallengeHallLobbyWarpData: ; 1c2eb (7:42eb)
	db $1A,$0A,CHALLENGE_HALL_ENTRANCE,$02,$06
	db $1A,$0C,CHALLENGE_HALL_ENTRANCE,$02,$08
	db $00,$00

ChallengeHallWarpData: ; 1c2f7 (7:42f7)
	db $0E,$1E,CHALLENGE_HALL_ENTRANCE,$08,$02
	db $10,$1E,CHALLENGE_HALL_ENTRANCE,$0A,$02
	db $00,$00

PokemonDomeEntranceWarpData: ; 1c303 (7:4303)
	db $0E,$10,OVERWORLD_MAP,$00,$00
	db $10,$10,OVERWORLD_MAP,$00,$00
	db $16,$00,POKEMON_DOME, $0E,$1C
	db $18,$00,POKEMON_DOME, $10,$1C
	db $00,$00

PokemonDomeWarpData: ; 1c319 (7:4319)
	db $0E,$1E,POKEMON_DOME_ENTRANCE,$16,$02
	db $10,$1E,POKEMON_DOME_ENTRANCE,$18,$02
	db $0E,$00,HALL_OF_HONOR,        $0A,$16
	db $10,$00,HALL_OF_HONOR,        $0C,$16
	db $00,$00

HallOfHonorWarpData: ; 1c32f (7:432f)
	db $0A,$18,POKEMON_DOME,$0E,$02
	db $0C,$18,POKEMON_DOME,$10,$02
	db $00,$00
