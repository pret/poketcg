	const_def
	const OVERWORLD_MAP           ; $00
	const MASON_LABORATORY        ; $01
	const DECK_MACHINE_ROOM       ; $02
	const ISHIHARAS_HOUSE         ; $03
	const FIGHTING_CLUB_ENTRANCE  ; $04
	const FIGHTING_CLUB_LOBBY     ; $05
	const FIGHTING_CLUB           ; $06
	const ROCK_CLUB_ENTRANCE      ; $07
	const ROCK_CLUB_LOBBY         ; $08
	const ROCK_CLUB               ; $09
	const WATER_CLUB_ENTRANCE     ; $0A
	const WATER_CLUB_LOBBY        ; $0B
	const WATER_CLUB              ; $0C
	const LIGHTNING_CLUB_ENTRANCE ; $0D
	const LIGHTNING_CLUB_LOBBY    ; $0E
	const LIGHTNING_CLUB          ; $0F
	const GRASS_CLUB_ENTRANCE     ; $10
	const GRASS_CLUB_LOBBY        ; $11
	const GRASS_CLUB              ; $12
	const PSYCHIC_CLUB_ENTRANCE   ; $13
	const PSYCHIC_CLUB_LOBBY      ; $14
	const PSYCHIC_CLUB            ; $15
	const SCIENCE_CLUB_ENTRANCE   ; $16
	const SCIENCE_CLUB_LOBBY      ; $17
	const SCIENCE_CLUB            ; $18
	const FIRE_CLUB_ENTRANCE      ; $19
	const FIRE_CLUB_LOBBY         ; $1A
	const FIRE_CLUB               ; $1B
	const CHALLENGE_HALL_ENTRANCE ; $1C
	const CHALLENGE_HALL_LOBBY    ; $1D
	const CHALLENGE_HALL          ; $1E
	const POKEMON_DOME_ENTRANCE   ; $1F
	const POKEMON_DOME            ; $20
	const HALL_OF_HONOR           ; $21

; overworld map selections
	const_def 1
	const OWMAP_MASON_LABORATORY ; $01
	const OWMAP_ISHIHARAS_HOUSE  ; $02
	const OWMAP_FIGHTING_CLUB    ; $03
	const OWMAP_ROCK_CLUB        ; $04
	const OWMAP_WATER_CLUB       ; $05
	const OWMAP_LIGHTNING_CLUB   ; $06
	const OWMAP_GRASS_CLUB       ; $07
	const OWMAP_PSYCHIC_CLUB     ; $08
	const OWMAP_SCIENCE_CLUB     ; $09
	const OWMAP_FIRE_CLUB        ; $0A
	const OWMAP_CHALLENGE_HALL   ; $0B
	const OWMAP_POKEMON_DOME     ; $0C
	const OWMAP_MYSTERY_HOUSE    ; $0D for OverworldMapNames

; Size of map data. See data/npc_map_data.asm and data/map_objects.asm
; for more info on what these represent
NPC_MAP_SIZE          EQU $06
MAP_OBJECT_SIZE       EQU $09

; Most of these aren't fully understood so the names aren't great
MAP_SCRIPT_SIZE          EQU $0f
MAP_SCRIPT_NPCS          EQU $00
MAP_SCRIPT_POST_NPC      EQU $02
MAP_SCRIPT_OBJECTS       EQU $04
MAP_SCRIPT_PRESSED_A     EQU $06
MAP_SCRIPT_LOAD_MAP      EQU $08
MAP_SCRIPT_AFTER_DUEL    EQU $0a
MAP_SCRIPT_MOVED_PLAYER  EQU $0c
MAP_SCRIPT_CLOSE_TEXTBOX EQU $0e

; map palettes for use in SGB mode
	const_def 1
	const MAP_SGB_PALETTE_1  ; $1
	const MAP_SGB_PALETTE_2  ; $2
	const MAP_SGB_PALETTE_3  ; $3
	const MAP_SGB_PALETTE_4  ; $4
	const MAP_SGB_PALETTE_5  ; $5
	const MAP_SGB_PALETTE_6  ; $6
	const MAP_SGB_PALETTE_7  ; $7
	const MAP_SGB_PALETTE_8  ; $8
	const MAP_SGB_PALETTE_9  ; $9
	const MAP_SGB_PALETTE_10 ; $a
