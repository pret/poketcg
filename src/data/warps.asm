WarpDataPointers:
	table_width 2, WarpDataPointers
	dw NULL
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
	assert_table_length NUM_MAPS

; each warp is five bytes long
; coordinates are measured in tiles
; 1: x coordinate of current map
; 2: y coordinate of current map
; 3: id of connected map
; 4: x coordinate of connected map
; 5: y coordinate of connected map
; double null terminated
MasonLaboratoryWarpData:
	db $0e, $1c, OVERWORLD_MAP,     $00, $00
	db $10, $1c, OVERWORLD_MAP,     $00, $00
	db $1a, $0a, DECK_MACHINE_ROOM, $02, $0a
	db $1a, $0c, DECK_MACHINE_ROOM, $02, $0c
	db $00, $00

DeckMachineRoomWarpData:
	db $00, $0a, MASON_LABORATORY, $18, $0a
	db $00, $0c, MASON_LABORATORY, $18, $0c
	db $00, $00

IshiharasHouseWarpData:
	db $08, $16, OVERWORLD_MAP, $00, $00
	db $0a, $16, OVERWORLD_MAP, $00, $00
	db $00, $00

FightingClubEntranceWarpData:
	db $08, $10, OVERWORLD_MAP,       $00, $00
	db $0a, $10, OVERWORLD_MAP,       $00, $00
	db $00, $06, FIGHTING_CLUB_LOBBY, $18, $0a
	db $00, $08, FIGHTING_CLUB_LOBBY, $18, $0c
	db $08, $00, FIGHTING_CLUB,       $0a, $0e
	db $0a, $00, FIGHTING_CLUB,       $0c, $0e
	db $00, $00

FightingClubLobbyWarpData:
	db $1a, $0a, FIGHTING_CLUB_ENTRANCE, $02, $06
	db $1a, $0c, FIGHTING_CLUB_ENTRANCE, $02, $08
	db $00, $00

FightingClubWarpData:
	db $0a, $10, FIGHTING_CLUB_ENTRANCE, $08, $02
	db $0c, $10, FIGHTING_CLUB_ENTRANCE, $0a, $02
	db $00, $00

RockClubEntranceWarpData:
	db $08, $10, OVERWORLD_MAP,   $00, $00
	db $0a, $10, OVERWORLD_MAP,   $00, $00
	db $00, $06, ROCK_CLUB_LOBBY, $18, $0a
	db $00, $08, ROCK_CLUB_LOBBY, $18, $0c
	db $08, $00, ROCK_CLUB,       $0c, $1a
	db $0a, $00, ROCK_CLUB,       $0e, $1a
	db $00, $00

RockClubLobbyWarpData:
	db $1a, $0a, ROCK_CLUB_ENTRANCE, $02, $06
	db $1a, $0c, ROCK_CLUB_ENTRANCE, $02, $08
	db $00, $00

RockClubWarpData:
	db $0c, $1c, ROCK_CLUB_ENTRANCE, $08, $02
	db $0e, $1c, ROCK_CLUB_ENTRANCE, $0a, $02
	db $00, $00

WaterClubEntranceWarpData:
	db $08, $10, OVERWORLD_MAP,    $00, $00
	db $0a, $10, OVERWORLD_MAP,    $00, $00
	db $00, $06, WATER_CLUB_LOBBY, $18, $0a
	db $00, $08, WATER_CLUB_LOBBY, $18, $0c
	db $08, $00, WATER_CLUB,       $0c, $1c
	db $0a, $00, WATER_CLUB,       $0e, $1c
	db $00, $00

WaterClubLobbyWarpData:
	db $1a, $0a, WATER_CLUB_ENTRANCE, $02, $06
	db $1a, $0c, WATER_CLUB_ENTRANCE, $02, $08
	db $00, $00

WaterClubWarpData:
	db $0c, $1e, WATER_CLUB_ENTRANCE, $08, $02
	db $0e, $1e, WATER_CLUB_ENTRANCE, $0a, $02
	db $00, $00

LightningClubEntranceWarpData:
	db $08, $10, OVERWORLD_MAP,        $00, $00
	db $0a, $10, OVERWORLD_MAP,        $00, $00
	db $00, $06, LIGHTNING_CLUB_LOBBY, $18, $0a
	db $00, $08, LIGHTNING_CLUB_LOBBY, $18, $0c
	db $08, $00, LIGHTNING_CLUB,       $0c, $1c
	db $0a, $00, LIGHTNING_CLUB,       $0e, $1c
	db $00, $00

LightningClubLobbyWarpData:
	db $1a, $0a, LIGHTNING_CLUB_ENTRANCE, $02, $06
	db $1a, $0c, LIGHTNING_CLUB_ENTRANCE, $02, $08
	db $00, $00

LightningClubWarpData:
	db $0c, $1e, LIGHTNING_CLUB_ENTRANCE, $08, $02
	db $0e, $1e, LIGHTNING_CLUB_ENTRANCE, $0a, $02
	db $00, $00

GrassClubEntranceWarpData:
	db $08, $10, OVERWORLD_MAP,    $00, $00
	db $0a, $10, OVERWORLD_MAP,    $00, $00
	db $00, $06, GRASS_CLUB_LOBBY, $18, $0a
	db $00, $08, GRASS_CLUB_LOBBY, $18, $0c
	db $08, $00, GRASS_CLUB,       $0c, $1c
	db $0a, $00, GRASS_CLUB,       $0e, $1c
	db $00, $00

GrassClubLobbyWarpData:
	db $1a, $0a, GRASS_CLUB_ENTRANCE, $02, $06
	db $1a, $0c, GRASS_CLUB_ENTRANCE, $02, $08
	db $00, $00

GrassClubWarpData:
	db $0c, $1e, GRASS_CLUB_ENTRANCE, $08, $02
	db $0e, $1e, GRASS_CLUB_ENTRANCE, $0a, $02
	db $00, $00

PsychicClubEntranceWarpData:
	db $08, $10, OVERWORLD_MAP,      $00, $00
	db $0a, $10, OVERWORLD_MAP,      $00, $00
	db $00, $06, PSYCHIC_CLUB_LOBBY, $18, $0a
	db $00, $08, PSYCHIC_CLUB_LOBBY, $18, $0c
	db $08, $00, PSYCHIC_CLUB,       $0c, $18
	db $0a, $00, PSYCHIC_CLUB,       $0e, $18
	db $00, $00

PsychicClubLobbyWarpData:
	db $1a, $0a, PSYCHIC_CLUB_ENTRANCE, $02, $06
	db $1a, $0c, PSYCHIC_CLUB_ENTRANCE, $02, $08
	db $00, $00

PsychicClubWarpData:
	db $0c, $1a, PSYCHIC_CLUB_ENTRANCE, $08, $02
	db $0e, $1a, PSYCHIC_CLUB_ENTRANCE, $0a, $02
	db $00, $00

ScienceClubEntranceWarpData:
	db $08, $10, OVERWORLD_MAP,      $00, $00
	db $0a, $10, OVERWORLD_MAP,      $00, $00
	db $00, $06, SCIENCE_CLUB_LOBBY, $18, $0a
	db $00, $08, SCIENCE_CLUB_LOBBY, $18, $0c
	db $08, $00, SCIENCE_CLUB,       $0c, $1c
	db $0a, $00, SCIENCE_CLUB,       $0e, $1c
	db $00, $00

ScienceClubLobbyWarpData:
	db $1a, $0a, SCIENCE_CLUB_ENTRANCE, $02, $06
	db $1a, $0c, SCIENCE_CLUB_ENTRANCE, $02, $08
	db $00, $00

ScienceClubWarpData:
	db $0c, $1e, SCIENCE_CLUB_ENTRANCE, $08, $02
	db $0e, $1e, SCIENCE_CLUB_ENTRANCE, $0a, $02
	db $00, $00

FireClubEntranceWarpData:
	db $08, $10, OVERWORLD_MAP,   $00, $00
	db $0a, $10, OVERWORLD_MAP,   $00, $00
	db $00, $06, FIRE_CLUB_LOBBY, $18, $0a
	db $00, $08, FIRE_CLUB_LOBBY, $18, $0c
	db $08, $00, FIRE_CLUB,       $0c, $1c
	db $0a, $00, FIRE_CLUB,       $0e, $1c
	db $00, $00

FireClubLobbyWarpData:
	db $1a, $0a, FIRE_CLUB_ENTRANCE, $02, $06
	db $1a, $0c, FIRE_CLUB_ENTRANCE, $02, $08
	db $00, $00

FireClubWarpData:
	db $0c, $1e, FIRE_CLUB_ENTRANCE, $08, $02
	db $0e, $1e, FIRE_CLUB_ENTRANCE, $0a, $02
	db $00, $00

ChallengeHallEntranceWarpData:
	db $08, $10, OVERWORLD_MAP,        $00, $00
	db $0a, $10, OVERWORLD_MAP,        $00, $00
	db $00, $06, CHALLENGE_HALL_LOBBY, $18, $0a
	db $00, $08, CHALLENGE_HALL_LOBBY, $18, $0c
	db $08, $00, CHALLENGE_HALL,       $0e, $1c
	db $0a, $00, CHALLENGE_HALL,       $10, $1c
	db $00, $00

ChallengeHallLobbyWarpData:
	db $1a, $0a, CHALLENGE_HALL_ENTRANCE, $02, $06
	db $1a, $0c, CHALLENGE_HALL_ENTRANCE, $02, $08
	db $00, $00

ChallengeHallWarpData:
	db $0e, $1e, CHALLENGE_HALL_ENTRANCE, $08, $02
	db $10, $1e, CHALLENGE_HALL_ENTRANCE, $0a, $02
	db $00, $00

PokemonDomeEntranceWarpData:
	db $0e, $10, OVERWORLD_MAP, $00, $00
	db $10, $10, OVERWORLD_MAP, $00, $00
	db $16, $00, POKEMON_DOME,  $0e, $1c
	db $18, $00, POKEMON_DOME,  $10, $1c
	db $00, $00

PokemonDomeWarpData:
	db $0e, $1e, POKEMON_DOME_ENTRANCE, $16, $02
	db $10, $1e, POKEMON_DOME_ENTRANCE, $18, $02
	db $0e, $00, HALL_OF_HONOR,         $0a, $16
	db $10, $00, HALL_OF_HONOR,         $0c, $16
	db $00, $00

HallOfHonorWarpData:
	db $0a, $18, POKEMON_DOME, $0e, $02
	db $0c, $18, POKEMON_DOME, $10, $02
	db $00, $00
