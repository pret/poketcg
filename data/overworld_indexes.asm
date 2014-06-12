; each entry in the overworld map is four bytes
; 1: map id
; 2: player's x coordinate when entering the map
; 2: player's y coordinate when entering the map
; 4: 00
OverworldMapIndexes: ; 10f88 (4:4f88)
	db $00,$00,$00,$00
	db MASON_LABORATORY,       $0E,$1A,$00
	db ISHIHARAS_HOUSE,        $08,$14,$00
	db FIGHTING_CLUB_ENTRANCE, $08,$0E,$00
	db ROCK_CLUB_ENTRANCE,     $08,$0E,$00
	db WATER_CLUB_ENTRANCE,    $08,$0E,$00
	db LIGHTNING_CLUB_ENTRANCE,$08,$0E,$00
	db GRASS_CLUB_ENTRANCE,    $08,$0E,$00
	db PSYCHIC_CLUB_ENTRANCE,  $08,$0E,$00
	db SCIENCE_CLUB_ENTRANCE,  $08,$0E,$00
	db FIRE_CLUB_ENTRANCE,     $08,$0E,$00
	db CHALLENGE_HALL_ENTRANCE,$08,$0E,$00
	db POKEMON_DOME_ENTRANCE,  $0E,$0E,$00
