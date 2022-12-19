OverworldMap_MapPositions:
	table_width 2, OverworldMap_MapPositions
	db $00, $00 ; unused
	db $0c, $68 ; OWMAP_MASON_LABORATORY
	db $04, $18 ; OWMAP_ISHIHARAS_HOUSE
	db $34, $68 ; OWMAP_FIGHTING_CLUB
	db $14, $38 ; OWMAP_ROCK_CLUB
	db $6c, $64 ; OWMAP_WATER_CLUB
	db $24, $50 ; OWMAP_LIGHTNING_CLUB
	db $7c, $40 ; OWMAP_GRASS_CLUB
	db $5c, $2c ; OWMAP_PSYCHIC_CLUB
	db $7c, $20 ; OWMAP_SCIENCE_CLUB
	db $6c, $10 ; OWMAP_FIRE_CLUB
	db $3c, $20 ; OWMAP_CHALLENGE_HALL
	db $44, $44 ; OWMAP_POKEMON_DOME
	assert_table_length NUM_OWMAPS
