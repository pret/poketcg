; Animation constants
	const_def
	const ANIM_SPRITE_ID
	const ANIM_PALETTE_ID
	const ANIM_SPRITE_ANIM_ID
	const ANIM_SPRITE_ANIM_FLAGS
	const ANIM_SOUND_FX_ID
	const ANIM_HANDLER_FUNCTION

; Animation duel screen constants (see wDuelAnimationScreen)
	const_def
	const DUEL_ANIM_SCREEN_MAIN_SCENE
	const DUEL_ANIM_SCREEN_PLAYER_PLAY_AREA
	const DUEL_ANIM_SCREEN_OPP_PLAY_AREA

	const_def
	; Normal animations
	const DUEL_ANIM_NONE               ; $00
	const DUEL_ANIM_GLOW               ; $01
	const DUEL_ANIM_PARALYSIS          ; $02
	const DUEL_ANIM_SLEEP              ; $03
	const DUEL_ANIM_CONFUSION          ; $04
	const DUEL_ANIM_POISON             ; $05
	const DUEL_ANIM_6                  ; $06
	const DUEL_ANIM_HIT                ; $07
	const DUEL_ANIM_BIG_HIT            ; $08
	const DUEL_ANIM_SHOW_DAMAGE        ; $09
	const DUEL_ANIM_THUNDER_SHOCK      ; $0a
	const DUEL_ANIM_LIGHTNING          ; $0b
	const DUEL_ANIM_BORDER_SPARK       ; $0c
	const DUEL_ANIM_BIG_LIGHTNING      ; $0d
	const DUEL_ANIM_SMALL_FLAME        ; $0e
	const DUEL_ANIM_BIG_FLAME          ; $0f
	const DUEL_ANIM_FIRE_SPIN          ; $10
	const DUEL_ANIM_DIVE_BOMB          ; $11
	const DUEL_ANIM_WATER_JETS         ; $12
	const DUEL_ANIM_WATER_GUN          ; $13
	const DUEL_ANIM_WHIRLPOOL          ; $14
	const DUEL_ANIM_HYDRO_PUMP         ; $15
	const DUEL_ANIM_BLIZZARD           ; $16
	const DUEL_ANIM_PSYCHIC            ; $17
	const DUEL_ANIM_GLARE              ; $18
	const DUEL_ANIM_BEAM               ; $19
	const DUEL_ANIM_HYPER_BEAM         ; $1a
	const DUEL_ANIM_ROCK_THROW         ; $1b
	const DUEL_ANIM_STONE_BARRAGE      ; $1c
	const DUEL_ANIM_PUNCH              ; $1d
	const DUEL_ANIM_THUNDERPUNCH       ; $1e
	const DUEL_ANIM_FIRE_PUNCH         ; $1f
	const DUEL_ANIM_STRETCH_KICK       ; $20
	const DUEL_ANIM_SLASH              ; $21
	const DUEL_ANIM_WHIP               ; $22
	const DUEL_ANIM_TEAR               ; $23
	const DUEL_ANIM_FURY_SWIPES        ; $24
	const DUEL_ANIM_DRILL              ; $25
	const DUEL_ANIM_POT_SMASH          ; $26
	const DUEL_ANIM_BONEMERANG         ; $27
	const DUEL_ANIM_SEISMIC_TOSS       ; $28
	const DUEL_ANIM_NEEDLES            ; $29
	const DUEL_ANIM_WHITE_GAS          ; $2a
	const DUEL_ANIM_POWDER             ; $2b
	const DUEL_ANIM_GOO                ; $2c
	const DUEL_ANIM_BUBBLES            ; $2d
	const DUEL_ANIM_STRING_SHOT        ; $2e
	const DUEL_ANIM_BOYFRIENDS         ; $2f
	const DUEL_ANIM_LURE               ; $30
	const DUEL_ANIM_TOXIC              ; $31
	const DUEL_ANIM_CONFUSE_RAY        ; $32
	const DUEL_ANIM_SING               ; $33
	const DUEL_ANIM_SUPERSONIC         ; $34
	const DUEL_ANIM_PETAL_DANCE        ; $35
	const DUEL_ANIM_PROTECT            ; $36
	const DUEL_ANIM_BARRIER            ; $37
	const DUEL_ANIM_QUICK_ATTACK       ; $38
	const DUEL_ANIM_WHIRLWIND          ; $39
	const DUEL_ANIM_CRY                ; $3a
	const DUEL_ANIM_QUESTION_MARK      ; $3b
	const DUEL_ANIM_SELFDESTRUCT       ; $3c
	const DUEL_ANIM_BIG_SELFDESTRUCT_1 ; $3d
	const DUEL_ANIM_HEAL               ; $3e
	const DUEL_ANIM_DRAIN              ; $3f
	const DUEL_ANIM_DARK_GAS           ; $40
	const DUEL_ANIM_BIG_SELFDESTRUCT_2 ; $41
	const DUEL_ANIM_66                 ; $42
	const DUEL_ANIM_67                 ; $43
	const DUEL_ANIM_68                 ; $44
	const DUEL_ANIM_69                 ; $45
	const DUEL_ANIM_70                 ; $46
	const DUEL_ANIM_71                 ; $47
	const DUEL_ANIM_72                 ; $48
	const DUEL_ANIM_73                 ; $49
	const DUEL_ANIM_74                 ; $4a
	const DUEL_ANIM_EXPAND             ; $4b
	const DUEL_ANIM_76                 ; $4c
	const DUEL_ANIM_THUNDER_WAVE       ; $4d
	const DUEL_ANIM_78                 ; $4e
	const DUEL_ANIM_79                 ; $4f
	const DUEL_ANIM_80                 ; $50
	const DUEL_ANIM_PLAYER_SHUFFLE     ; $51
	const DUEL_ANIM_OPP_SHUFFLE        ; $52
	const DUEL_ANIM_BOTH_SHUFFLE       ; $53
	const DUEL_ANIM_84                 ; $54
	const DUEL_ANIM_BOTH_DRAW          ; $55
	const DUEL_ANIM_PLAYER_DRAW        ; $56
	const DUEL_ANIM_OPP_DRAW           ; $57
	const DUEL_ANIM_COIN_SPIN          ; $58
	const DUEL_ANIM_COIN_TOSS1         ; $59
	const DUEL_ANIM_COIN_TOSS2         ; $5a
	const DUEL_ANIM_COIN_TAILS         ; $5b
	const DUEL_ANIM_COIN_HEADS         ; $5c
	const DUEL_ANIM_DUEL_WIN           ; $5d
	const DUEL_ANIM_DUEL_LOSS          ; $5e
	const DUEL_ANIM_DUEL_DRAW          ; $5f
	const DUEL_ANIM_96                 ; $60

; animations passed this point are treated differently
DUEL_SPECIAL_ANIMS EQU const_value

DUEL_SCREEN_ANIMS EQU const_value
	const DUEL_ANIM_SMALL_SHAKE_X      ; $61
	const DUEL_ANIM_BIG_SHAKE_X        ; $62
	const DUEL_ANIM_SMALL_SHAKE_Y      ; $63
	const DUEL_ANIM_BIG_SHAKE_Y        ; $64
	const DUEL_ANIM_FLASH              ; $65
	const DUEL_ANIM_DISTORT            ; $66

	const_def $96
	const DUEL_ANIM_150                ; $96
	const DUEL_ANIM_PRINT_DAMAGE       ; $97
	const DUEL_ANIM_UPDATE_HUD         ; $98
	const DUEL_ANIM_153                ; $99
	const DUEL_ANIM_154                ; $9a
	const DUEL_ANIM_155                ; $9b
	const DUEL_ANIM_156                ; $9c
	const DUEL_ANIM_157                ; $9d
	const DUEL_ANIM_158                ; $9e

	; Special animations
	const_def $fa
	const DUEL_ANIM_SHAKE1             ; $fa
	const DUEL_ANIM_SHAKE2             ; $fb
	const DUEL_ANIM_SHAKE3             ; $fc

	; Duel Anim Struct constants
	const_def
	const DUEL_ANIM_STRUCT_ID             ; $0
	const DUEL_ANIM_STRUCT_SCREEN         ; $1
	const DUEL_ANIM_STRUCT_DUELIST_SIDE   ; $2
	const DUEL_ANIM_STRUCT_LOCATION_PARAM ; $3
	const DUEL_ANIM_STRUCT_DAMAGE         ; $4
const_value = const_value + 1
	const DUEL_ANIM_STRUCT_UNKNOWN_2      ; $6
	const DUEL_ANIM_STRUCT_BANK           ; $7
DUEL_ANIM_STRUCT_SIZE EQU const_value

	; ow_frame struct constants
	const_def
	const OW_FRAME_STRUCT_DURATION         ; $0
	const OW_FRAME_STRUCT_VRAM_TILE_OFFSET ; $1
	const OW_FRAME_STRUCT_VRAM_BANK        ; $2
	const OW_FRAME_STRUCT_TILESET_BANK     ; $3
	const OW_FRAME_STRUCT_TILESET          ; $4
const_value = const_value + 1
	const OW_FRAME_STRUCT_TILESET_OFFSET   ; $6
const_value = const_value + 1
OW_FRAME_STRUCT_SIZE EQU const_value

NUM_OW_FRAMESET_SUBGROUPS EQU 3
