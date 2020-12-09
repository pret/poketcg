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
	const SPRITE_ANIM_FLAG_SKIP_DRAW

SPRITE_FRAME_OFFSET_SIZE EQU 4

	const_def 1
	const SPRITE_RONALD   ; $01
	const SPRITE_DRMASON  ; $02
	const SPRITE_ISHIHARA ; $03
	const SPRITE_IMAKUNI  ; $04
	const SPRITE_NIKKI    ; $05
	const SPRITE_RICK     ; $06
	const SPRITE_KEN      ; $07
	const SPRITE_AMY      ; $08
	const SPRITE_ISAAC    ; $09
	const SPRITE_MITCH    ; $0A
	const SPRITE_GENE     ; $0B
	const SPRITE_MURRAY   ; $0C
	const SPRITE_COURTNEY ; $0D
	const SPRITE_STEVE    ; $0E
	const SPRITE_JACK     ; $0F
	const SPRITE_ROD      ; $10
	const SPRITE_BOY1     ; $11
	const SPRITE_BOY2     ; $12
	const SPRITE_BOY3     ; $13
	const SPRITE_BUTCH    ; $14
	const SPRITE_BOY4     ; $15
	const SPRITE_JOSHUA   ; $16
	const SPRITE_BOY5     ; $17
	const SPRITE_TECH     ; $18
	const SPRITE_CHAP     ; $19
	const SPRITE_GUIDE    ; $1A
	const SPRITE_PAPPY    ; $1B
	const SPRITE_GIRL1    ; $1C
	const SPRITE_GIRL2    ; $1D
	const SPRITE_GIRL3    ; $1E
	const SPRITE_GIRL4    ; $1F
	const SPRITE_GIRL5    ; $20
	const SPRITE_CLERK    ; $21
	const SPRITE_HOST     ; $22
	const SPRITE_WOMAN    ; $23
	const SPRITE_GRANNY   ; $24
