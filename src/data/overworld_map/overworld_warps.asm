; each entry in the overworld map is four bytes
; 1: map id
; 2: player's x coordinate when entering the map
; 2: player's y coordinate when entering the map
; 4: 00
OverworldMapWarps:
	table_width 4, OverworldMapWarps
	db $00, $00, $00, $00
	db MASON_LABORATORY,        $0e, $1a, $00
	db ISHIHARAS_HOUSE,         $08, $14, $00
	db FIGHTING_CLUB_ENTRANCE,  $08, $0e, $00
	db ROCK_CLUB_ENTRANCE,      $08, $0e, $00
	db WATER_CLUB_ENTRANCE,     $08, $0e, $00
	db LIGHTNING_CLUB_ENTRANCE, $08, $0e, $00
	db GRASS_CLUB_ENTRANCE,     $08, $0e, $00
	db PSYCHIC_CLUB_ENTRANCE,   $08, $0e, $00
	db SCIENCE_CLUB_ENTRANCE,   $08, $0e, $00
	db FIRE_CLUB_ENTRANCE,      $08, $0e, $00
	db CHALLENGE_HALL_ENTRANCE, $08, $0e, $00
	db POKEMON_DOME_ENTRANCE,   $0e, $0e, $00
	assert_table_length NUM_OWMAPS
