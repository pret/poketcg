MapOWFramesetPointers:
; non-cgb, cgb
	table_width 4, MapOWFramesetPointers
	dw OverworldMapOWFrameset,    OverworldMapCGBOWFrameset    ; OVERWORLD_MAP
	dw MasonLaboratoryOWFrameset, MasonLaboratoryOWFrameset    ; MASON_LABORATORY
	dw DeckMachineRoomOWFrameset, DeckMachineRoomCGBOWFrameset ; DECK_MACHINE_ROOM
	dw DefaultOWFrameset,         DefaultOWFrameset            ; ISHIHARAS_HOUSE
	dw DefaultOWFrameset,         DefaultOWFrameset            ; FIGHTING_CLUB_ENTRANCE
	dw DefaultOWFrameset,         DefaultOWFrameset            ; FIGHTING_CLUB_LOBBY
	dw DefaultOWFrameset,         DefaultOWFrameset            ; FIGHTING_CLUB
	dw DefaultOWFrameset,         DefaultOWFrameset            ; ROCK_CLUB_ENTRANCE
	dw DefaultOWFrameset,         DefaultOWFrameset            ; ROCK_CLUB_LOBBY
	dw DefaultOWFrameset,         DefaultOWFrameset            ; ROCK_CLUB
	dw DefaultOWFrameset,         DefaultOWFrameset            ; WATER_CLUB_ENTRANCE
	dw DefaultOWFrameset,         DefaultOWFrameset            ; WATER_CLUB_LOBBY
	dw WaterClubOWFrameset,       WaterClubOWFrameset          ; WATER_CLUB
	dw DefaultOWFrameset,         DefaultOWFrameset            ; LIGHTNING_CLUB_ENTRANCE
	dw DefaultOWFrameset,         DefaultOWFrameset            ; LIGHTNING_CLUB_LOBBY
	dw LightningClubOWFrameset,   LightningClubOWFrameset      ; LIGHTNING_CLUB
	dw DefaultOWFrameset,         DefaultOWFrameset            ; GRASS_CLUB_ENTRANCE
	dw DefaultOWFrameset,         DefaultOWFrameset            ; GRASS_CLUB_LOBBY
	dw DefaultOWFrameset,         DefaultOWFrameset            ; GRASS_CLUB
	dw DefaultOWFrameset,         DefaultOWFrameset            ; PSYCHIC_CLUB_ENTRANCE
	dw DefaultOWFrameset,         DefaultOWFrameset            ; PSYCHIC_CLUB_LOBBY
	dw DefaultOWFrameset,         DefaultOWFrameset            ; PSYCHIC_CLUB
	dw DefaultOWFrameset,         DefaultOWFrameset            ; SCIENCE_CLUB_ENTRANCE
	dw DefaultOWFrameset,         DefaultOWFrameset            ; SCIENCE_CLUB_LOBBY
	dw ScienceClubOWFrameset,     ScienceClubOWFrameset        ; SCIENCE_CLUB
	dw DefaultOWFrameset,         DefaultOWFrameset            ; FIRE_CLUB_ENTRANCE
	dw DefaultOWFrameset,         DefaultOWFrameset            ; FIRE_CLUB_LOBBY
	dw FireClubOWFrameset,        FireClubCGBOWFrameset        ; FIRE_CLUB
	dw DefaultOWFrameset,         DefaultOWFrameset            ; CHALLENGE_HALL_ENTRANCE
	dw DefaultOWFrameset,         DefaultOWFrameset            ; CHALLENGE_HALL_LOBBY
	dw ChallengeHallOWFrameset,   ChallengeHallOWFrameset      ; CHALLENGE_HALL
	dw DefaultOWFrameset,         DefaultOWFrameset            ; POKEMON_DOME_ENTRANCE
	dw DefaultOWFrameset,         DefaultOWFrameset            ; POKEMON_DOME
	dw HallOfHonorOWFrameset,     HallOfHonorOWFrameset        ; HALL_OF_HONOR
	assert_table_length NUM_MAPS
