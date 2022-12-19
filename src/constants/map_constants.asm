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

DEF NUM_MAPS EQU const_value

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
DEF NUM_OWMAPS EQU const_value
	const OWMAP_MYSTERY_HOUSE    ; $0D for OverworldMapNames
DEF NUM_OWMAP_NAMES EQU const_value


; Size of map data. See data/npc_map_data.asm and data/map_objects.asm
; for more info on what these represent
DEF NPC_MAP_SIZE          EQU $06
DEF MAP_OBJECT_SIZE       EQU $09

; Most of these aren't fully understood so the names aren't great
DEF MAP_SCRIPT_NPCS          EQU $00
DEF MAP_SCRIPT_POST_NPC      EQU $02
DEF MAP_SCRIPT_OBJECTS       EQU $04
DEF MAP_SCRIPT_PRESSED_A     EQU $06
DEF MAP_SCRIPT_LOAD_MAP      EQU $08
DEF MAP_SCRIPT_AFTER_DUEL    EQU $0a
DEF MAP_SCRIPT_MOVED_PLAYER  EQU $0c
DEF MAP_SCRIPT_CLOSE_TEXTBOX EQU $0e

DEF NUM_MAP_SCRIPTS EQU 8

; map palettes for use in SGB mode
	const_def 1
	const MAP_SGB_PALS_1  ; $1
	const MAP_SGB_PALS_2  ; $2
	const MAP_SGB_PALS_3  ; $3
	const MAP_SGB_PALS_4  ; $4
	const MAP_SGB_PALS_5  ; $5
	const MAP_SGB_PALS_6  ; $6
	const MAP_SGB_PALS_7  ; $7
	const MAP_SGB_PALS_8  ; $8
	const MAP_SGB_PALS_9  ; $9
	const MAP_SGB_PALS_10 ; $a

	const_def 0
	const MAP_EVENT_POKEMON_DOME_DOOR      ; $0
	const MAP_EVENT_HALL_OF_HONOR_DOOR     ; $1
	const MAP_EVENT_FIGHTING_DECK_MACHINE  ; $2
	const MAP_EVENT_ROCK_DECK_MACHINE      ; $3
	const MAP_EVENT_WATER_DECK_MACHINE     ; $4
	const MAP_EVENT_LIGHTNING_DECK_MACHINE ; $5
	const MAP_EVENT_GRASS_DECK_MACHINE     ; $6
	const MAP_EVENT_PSYCHIC_DECK_MACHINE   ; $7
	const MAP_EVENT_SCIENCE_DECK_MACHINE   ; $8
	const MAP_EVENT_FIRE_DECK_MACHINE      ; $9
	const MAP_EVENT_CHALLENGE_MACHINE      ; $a
DEF NUM_MAP_EVENTS EQU const_value
