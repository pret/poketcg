deck_const: MACRO
if const_value >= 2
\1_ID EQU const_value - 2
endc
	const \1
ENDM

; Both *_DECK and *_DECK_ID constants are defined here.
; *_DECK constants are to be used with LoadDeck and related routines.
; *_DECK_ID constants are specific to be loaded into wOpponentDeckID.
; Always, *_DECK_ID = *_DECK - 2. UNNAMED_DECK_ID and UNNAMED_2_DECK_ID do not exist.
	const_def
	deck_const UNNAMED_DECK                ; $00
	deck_const UNNAMED_2_DECK              ; $01
	deck_const SAMS_PRACTICE_DECK          ; $02
	deck_const PRACTICE_PLAYER_DECK        ; $03
	deck_const SAMS_NORMAL_DECK            ; $04
	deck_const CHARMANDER_AND_FRIENDS_DECK ; $05
	deck_const CHARMANDER_EXTRA_DECK       ; $06
	deck_const SQUIRTLE_AND_FRIENDS_DECK   ; $07
	deck_const SQUIRTLE_EXTRA_DECK         ; $08
	deck_const BULBASAUR_AND_FRIENDS_DECK  ; $09
	deck_const BULBASAUR_EXTRA_DECK        ; $0A
	deck_const LIGHTNING_AND_FIRE_DECK     ; $0B
	deck_const WATER_AND_FIGHTING_DECK     ; $0C
	deck_const GRASS_AND_PSYCHIC_DECK      ; $0D
	deck_const LEGENDARY_MOLTRES_DECK      ; $0E
	deck_const LEGENDARY_ZAPDOS_DECK       ; $0F
	deck_const LEGENDARY_ARTICUNO_DECK     ; $10
	deck_const LEGENDARY_DRAGONITE_DECK    ; $11
	deck_const FIRST_STRIKE_DECK           ; $12
	deck_const ROCK_CRUSHER_DECK           ; $13
	deck_const GO_GO_RAIN_DANCE_DECK       ; $14
	deck_const ZAPPING_SELFDESTRUCT_DECK   ; $15
	deck_const FLOWER_POWER_DECK           ; $16
	deck_const STRANGE_PSYSHOCK_DECK       ; $17
	deck_const WONDERS_OF_SCIENCE_DECK     ; $18
	deck_const FIRE_CHARGE_DECK            ; $19
	deck_const IM_RONALD_DECK              ; $1A
	deck_const POWERFUL_RONALD_DECK        ; $1B
	deck_const INVINCIBLE_RONALD_DECK      ; $1C
	deck_const LEGENDARY_RONALD_DECK       ; $1D
	deck_const MUSCLES_FOR_BRAINS_DECK     ; $1E
	deck_const HEATED_BATTLE_DECK          ; $1F
	deck_const LOVE_TO_BATTLE_DECK         ; $20
	deck_const EXCAVATION_DECK             ; $21
	deck_const BLISTERING_POKEMON_DECK     ; $22
	deck_const HARD_POKEMON_DECK           ; $23
	deck_const WATERFRONT_POKEMON_DECK     ; $24
	deck_const LONELY_FRIENDS_DECK         ; $25
	deck_const SOUND_OF_THE_WAVES_DECK     ; $26
	deck_const PIKACHU_DECK                ; $27
	deck_const BOOM_BOOM_SELFDESTRUCT_DECK ; $28
	deck_const POWER_GENERATOR_DECK        ; $29
	deck_const ETCETERA_DECK               ; $2A
	deck_const FLOWER_GARDEN_DECK          ; $2B
	deck_const KALEIDOSCOPE_DECK           ; $2C
	deck_const GHOST_DECK                  ; $2D
	deck_const NAP_TIME_DECK               ; $2E
	deck_const STRANGE_POWER_DECK          ; $2F
	deck_const FLYIN_POKEMON_DECK          ; $30
	deck_const LOVELY_NIDORAN_DECK         ; $31
	deck_const POISON_DECK                 ; $32
	deck_const ANGER_DECK                  ; $33
	deck_const FLAMETHROWER_DECK           ; $34
	deck_const RESHUFFLE_DECK              ; $35
	deck_const IMAKUNI_DECK                ; $36
DECKS_END EQU const_value - 1
DECK_IDS_END EQU DECKS_END - 2

