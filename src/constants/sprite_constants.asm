; wSpriteAnimBuffer
SPRITE_ANIM_BUFFER_CAPACITY EQU 16 ; sprites

; sprite_anim_struct constants
	const_def
	const SPRITE_ANIM_ENABLED
	const SPRITE_ANIM_ATTRIBUTES
	const SPRITE_ANIM_COORD_X
	const SPRITE_ANIM_COORD_Y
	const SPRITE_ANIM_TILE_ID
	const SPRITE_ANIM_ID
	const SPRITE_ANIM_BANK
	const SPRITE_ANIM_POINTER
const_value = const_value+1 ; pointer
	const SPRITE_ANIM_FRAME_OFFSET_POINTER
const_value = const_value+1 ; pointer
	const SPRITE_ANIM_FRAME_BANK
	const SPRITE_ANIM_FRAME_DATA_POINTER
const_value = const_value+1 ; pointer
	const SPRITE_ANIM_COUNTER
	const SPRITE_ANIM_FLAGS
SPRITE_ANIM_LENGTH EQU const_value

; SPRITE_ANIM_FLAGS values
	const_def
	const SPRITE_ANIM_FLAG_X_SUBTRACT
	const SPRITE_ANIM_FLAG_Y_SUBTRACT
	const SPRITE_ANIM_FLAG_SPEED
	const SPRITE_ANIM_FLAG_3
	const SPRITE_ANIM_FLAG_4
	const SPRITE_ANIM_FLAG_5
	const SPRITE_ANIM_FLAG_6
	const SPRITE_ANIM_FLAG_UNSKIPPABLE

SPRITE_FRAME_OFFSET_SIZE EQU 4

	const_def
	const SPRITE_OW_PLAYER          ; $00
	const SPRITE_OW_RONALD          ; $01
	const SPRITE_OW_DRMASON         ; $02
	const SPRITE_OW_ISHIHARA        ; $03
	const SPRITE_OW_IMAKUNI         ; $04
	const SPRITE_OW_NIKKI           ; $05
	const SPRITE_OW_RICK            ; $06
	const SPRITE_OW_KEN             ; $07
	const SPRITE_OW_AMY             ; $08
	const SPRITE_OW_ISAAC           ; $09
	const SPRITE_OW_MITCH           ; $0a
	const SPRITE_OW_GENE            ; $0b
	const SPRITE_OW_MURRAY          ; $0c
	const SPRITE_OW_COURTNEY        ; $0d
	const SPRITE_OW_STEVE           ; $0e
	const SPRITE_OW_JACK            ; $0f
	const SPRITE_OW_ROD             ; $10
	const SPRITE_OW_BOY             ; $11
	const SPRITE_OW_LAD             ; $12
	const SPRITE_OW_SPECS           ; $13
	const SPRITE_OW_BUTCH           ; $14
	const SPRITE_OW_MANIA           ; $15
	const SPRITE_OW_JOSHUA          ; $16
	const SPRITE_OW_HOOD            ; $17
	const SPRITE_OW_TECH            ; $18
	const SPRITE_OW_CHAP            ; $19
	const SPRITE_OW_MAN             ; $1a
	const SPRITE_OW_PAPPY           ; $1b
	const SPRITE_OW_GIRL            ; $1c
	const SPRITE_OW_LASS1           ; $1d
	const SPRITE_OW_LASS2           ; $1e
	const SPRITE_OW_LASS3           ; $1f
	const SPRITE_OW_SWIMMER         ; $20
	const SPRITE_OW_CLERK           ; $21
	const SPRITE_OW_GAL             ; $22
	const SPRITE_OW_WOMAN           ; $23
	const SPRITE_OW_GRANNY          ; $24
	const SPRITE_OW_MAP_OAM         ; $25
	const SPRITE_DUEL_0             ; $26
	const SPRITE_DUEL_63            ; $27
	const SPRITE_DUEL_GLOW          ; $28
	const SPRITE_DUEL_1             ; $29
	const SPRITE_DUEL_2             ; $2a
	const SPRITE_DUEL_55            ; $2b
	const SPRITE_DUEL_58            ; $2c
	const SPRITE_DUEL_3             ; $2d
	const SPRITE_DUEL_4             ; $2e
	const SPRITE_DUEL_5             ; $2f
	const SPRITE_DUEL_6             ; $30
	const SPRITE_DUEL_59            ; $31
	const SPRITE_DUEL_7             ; $32
	const SPRITE_DUEL_8             ; $33
	const SPRITE_DUEL_9             ; $34
	const SPRITE_DUEL_10            ; $35
	const SPRITE_DUEL_61            ; $36
	const SPRITE_DUEL_11            ; $37
	const SPRITE_DUEL_12            ; $38
	const SPRITE_DUEL_13            ; $39
	const SPRITE_DUEL_62            ; $3a
	const SPRITE_DUEL_14            ; $3b
	const SPRITE_DUEL_15            ; $3c
	const SPRITE_DUEL_16            ; $3d
	const SPRITE_DUEL_17            ; $3e
	const SPRITE_DUEL_18            ; $3f
	const SPRITE_DUEL_19            ; $40
	const SPRITE_DUEL_20            ; $41
	const SPRITE_DUEL_21            ; $42
	const SPRITE_DUEL_22            ; $43
	const SPRITE_DUEL_23            ; $44
	const SPRITE_DUEL_24            ; $45
	const SPRITE_DUEL_25            ; $46
	const SPRITE_DUEL_26            ; $47
	const SPRITE_DUEL_27            ; $48
	const SPRITE_DUEL_28            ; $49
	const SPRITE_DUEL_29            ; $4a
	const SPRITE_DUEL_56            ; $4b
	const SPRITE_DUEL_30            ; $4c
	const SPRITE_DUEL_31            ; $4d
	const SPRITE_DUEL_32            ; $4e
	const SPRITE_DUEL_33            ; $4f
	const SPRITE_DUEL_34            ; $50
	const SPRITE_DUEL_35            ; $51
	const SPRITE_DUEL_66            ; $52
	const SPRITE_DUEL_36            ; $53
	const SPRITE_DUEL_37            ; $54
	const SPRITE_DUEL_57            ; $55
	const SPRITE_DUEL_38            ; $56
	const SPRITE_DUEL_39            ; $57
	const SPRITE_DUEL_40            ; $58
	const SPRITE_DUEL_41            ; $59
	const SPRITE_DUEL_42            ; $5a
	const SPRITE_DUEL_43            ; $5b
	const SPRITE_DUEL_44            ; $5c
	const SPRITE_DUEL_60            ; $5d
	const SPRITE_DUEL_64            ; $5e
	const SPRITE_DUEL_45            ; $5f
	const SPRITE_DUEL_46            ; $60
	const SPRITE_DUEL_47            ; $61
	const SPRITE_DUEL_48            ; $62
	const SPRITE_DUEL_49            ; $63
	const SPRITE_DUEL_50            ; $64
	const SPRITE_DUEL_WON_LOST_DRAW ; $65
	const SPRITE_DUEL_52            ; $66
	const SPRITE_DUEL_53            ; $67
	const SPRITE_DUEL_54            ; $68
	const SPRITE_BOOSTER_PACK_OAM   ; $69
	const SPRITE_PRESS_START        ; $6a
	const SPRITE_GRASS              ; $6b
	const SPRITE_FIRE               ; $6c
	const SPRITE_WATER              ; $6d
	const SPRITE_COLORLESS          ; $6e
	const SPRITE_LIGHTNING          ; $6f
	const SPRITE_PSYCHIC            ; $70
	const SPRITE_FIGHTING           ; $71
