	ret ; stray ret

Func_80c64: ; unreferenced
	ld a, [wLineSeparation]
	push af
	ld a, SINGLE_SPACED
	ld [wLineSeparation], a
	; load opponent's name
	ld a, [wOpponentName]
	ld [wTxRam2], a
	ld a, [wOpponentName + 1]
	ld [wTxRam2 + 1], a
	ld a, [wNPCDuelistCopy]
	ld [wTxRam3_b], a
	xor a
	ld [wTxRam3_b + 1], a
	; load number of duel prizes
	ld a, [wNPCDuelPrizes]
	ld [wTxRam3], a
	xor a
	ld [wTxRam3 + 1], a

	lb de, 2, 13
	call InitTextPrinting
	ldtx hl, WinLosePrizesDuelWithText
	call PrintTextNoDelay

	ld a, [wNPCDuelDeckID]
	ld [wTxRam3], a
	xor a
	ld [wTxRam3 + 1], a
	lb de, 2, 15
	call InitTextPrinting
	ldtx hl, UseDuelistsDeckText
	call PrintTextNoDelay

	pop af
	ld [wLineSeparation], a
	xor a
	ld hl, .menu_parameters
	call InitializeMenuParameters
	ret

.menu_parameters
	db 1, 13 ; cursor x, cursor y
	db 1 ; y displacement between items
	db 2 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

; fills Tiles0 with random bytes
UnreferencedFillVRAMWithRandomData: ; unreferenced
	call DisableLCD
	ld hl, v0Tiles0
	ld bc, $800
.loop
	call UpdateRNGSources
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret

_DebugVEffect:
	ret

; seems to be used to look at each OW NPC sprites
; with functions to rotate NPC and animate them
_DebugLookAtSprite:
	call DisableLCD
	call EmptyScreen
	call ClearSpriteAnimations
	xor a
	ld [wWhichOBP], a ; not used
	ld [wWhichBGPalIndex], a ; palette index 0
	ld a, PALETTE_0
	farcall LoadBGPalette

	xor a
	ld [wWhichOBP], a ; OBP0
	ld [wWhichOBPalIndex], a ; palette index 0
	ld a, PALETTE_29
	farcall LoadOBPalette

	ld a, SOUTH
	ld [wLoadNPCDirection], a
	ld a, $01
	ld [wLoadedNPCTempIndex], a
	call .DrawNPCSprite
	call .PrintNPCInfo
	call EnableLCD
.loop
	call DoFrameIfLCDEnabled
	call .HandleInput
	call HandleAllSpriteAnimations
	ldh a, [hKeysPressed]
	and PAD_SELECT ; if select is pressed, exit
	jr z, .loop
	ret

	ret ; stray ret

; A button makes NPC rotate
; D-pad scrolls through the NPCs
; from $01 to $2c
; these are not aligned with the regular NPC indices
.HandleInput
	ldh a, [hKeysPressed]
	and PAD_A
	jr z, .no_a_button
	ld a, [wLoadNPCDirection]
	inc a ; rotate NPC
	and %11
	ld [wLoadNPCDirection], a
	call ClearSpriteAnimations
	call .DrawNPCSprite
.no_a_button
	ldh a, [hKeysPressed]
	and PAD_CTRL_PAD
	ret z
	farcall GetDirectionFromDPad
	ld hl, .func_table
	jp JumpToFunctionInTable

.func_table
	dw .up ; PAD_UP
	dw .right ; PAD_RIGHT
	dw .down ; PAD_DOWN
	dw .left ; PAD_LEFT
.up
	ld a, 10
	jr .decr_npc_id
.down
	ld a, 10
	jr .incr_npc_id
.right
	ld a, 1
	jr .incr_npc_id
.left
	ld a, 1
	jr .decr_npc_id

.incr_npc_id
	ld c, a
	ld a, [wLoadedNPCTempIndex]
	cp $2c
	jr z, .load_first_npc
	add c
	jr c, .load_last_npc
	cp $2c
	jr nc, .load_last_npc
	jr .got_npc

.decr_npc_id
	ld c, a
	ld a, [wLoadedNPCTempIndex]
	cp $01
	jr z, .load_last_npc
	sub c
	jr c, .load_first_npc
	cp $01
	jr c, .load_first_npc
	jr .got_npc
.load_first_npc
	ld a, $01
	jr .got_npc
.load_last_npc
	ld a, $2c

.got_npc
	ld [wLoadedNPCTempIndex], a
	call ClearSpriteAnimations
	call .DrawNPCSprite
	jr .PrintNPCInfo

.PrintNPCInfo
	lb de, 0, 4
	call InitTextPrinting
	ldtx hl, SPRText
	call ProcessTextFromID
	ld bc, FlushAllPalettes
	ld a, [wLoadedNPCTempIndex]
	farcall WriteTwoByteNumberInTxSymbolFormat
	ret

.DrawNPCSprite
	ld a, [wLoadedNPCTempIndex]
	ld c, a
	add a
	add c ; *3
	ld c, a
	ld b, $0
	ld hl, .NPCSpriteAnimData - 3
	add hl, bc
	ld a, [hli]
	cp $ff
	jr z, .skip_draw_sprite
	farcall CreateSpriteAndAnimBufferEntry
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	inc hl
.not_cgb
	ld a, [wLoadNPCDirection]
	add [hl]
	farcall StartNewSpriteAnimation
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ld a, $48
	ld [hli], a
	ld a, $40
	ld [hl], a ; SPRITE_ANIM_COORD_Y
.skip_draw_sprite
	ret

.NPCSpriteAnimData
	db SPRITE_OW_PLAYER,   SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_RED_NPC_UP       ; $01
	db $ff,                SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_LIGHT_NPC_UP     ; $02
	db SPRITE_OW_RONALD,   SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_BLUE_NPC_UP      ; $03
	db $ff,                SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_LIGHT_NPC_UP     ; $04
	db SPRITE_OW_DRMASON,  SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_WHITE_NPC_UP     ; $05
	db SPRITE_OW_ISHIHARA, SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_PURPLE_NPC_UP    ; $06
	db SPRITE_OW_IMAKUNI,  SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_BLUE_NPC_UP      ; $07
	db SPRITE_OW_NIKKI,    SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_GREEN_NPC_UP     ; $08
	db SPRITE_OW_RICK,     SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_BLUE_NPC_UP      ; $09
	db SPRITE_OW_KEN,      SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_RED_NPC_UP       ; $0a
	db SPRITE_OW_AMY,      SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_BLUE_NPC_UP      ; $0b
	db SPRITE_OW_ISAAC,    SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_YELLOW_NPC_UP    ; $0c
	db SPRITE_OW_MITCH,    SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_BLUE_NPC_UP      ; $0d
	db SPRITE_OW_GENE,     SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_PURPLE_NPC_UP    ; $0e
	db SPRITE_OW_MURRAY,   SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_PINK_NPC_UP      ; $0f
	db SPRITE_OW_COURTNEY, SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_PINK_NPC_UP      ; $10
	db $ff,                SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_LIGHT_NPC_UP     ; $11
	db SPRITE_OW_STEVE,    SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_INDIGO_NPC_UP    ; $12
	db $ff,                SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_LIGHT_NPC_UP     ; $13
	db SPRITE_OW_JACK,     SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_WHITE_NPC_UP     ; $14
	db $ff,                SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_LIGHT_NPC_UP     ; $15
	db SPRITE_OW_ROD,      SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_BLUE_NPC_UP      ; $16
	db $ff,                SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_LIGHT_NPC_UP     ; $17
	db SPRITE_OW_BOY,      SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_YELLOW_NPC_UP    ; $18
	db SPRITE_OW_LAD,      SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_GREEN_NPC_UP     ; $19
	db SPRITE_OW_SPECS,    SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_PURPLE_NPC_UP    ; $1a
	db SPRITE_OW_BUTCH,    SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_YELLOW_NPC_UP    ; $1b
	db SPRITE_OW_MANIA,    SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_WHITE_NPC_UP     ; $1c
	db SPRITE_OW_JOSHUA,   SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_WHITE_NPC_UP     ; $1d
	db SPRITE_OW_HOOD,     SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_RED_NPC_UP       ; $1e
	db SPRITE_OW_TECH,     SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_BLUE_NPC_UP      ; $1f
	db SPRITE_OW_CHAP,     SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_GREEN_NPC_UP     ; $20
	db SPRITE_OW_MAN,      SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_YELLOW_NPC_UP    ; $21
	db SPRITE_OW_PAPPY,    SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_PURPLE_NPC_UP    ; $22
	db SPRITE_OW_GIRL,     SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_BLUE_NPC_UP      ; $23
	db SPRITE_OW_LASS1,    SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_PURPLE_NPC_UP    ; $24
	db SPRITE_OW_LASS2,    SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_RED_NPC_UP       ; $25
	db SPRITE_OW_LASS3,    SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_GREEN_NPC_UP     ; $26
	db SPRITE_OW_SWIMMER,  SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_YELLOW_NPC_UP    ; $27
	db SPRITE_OW_CLERK,    SPRITE_ANIM_SGB_CLERK_NPC_UP, SPRITE_ANIM_CGB_CLERK_NPC_UP ; $28
	db SPRITE_OW_GAL,      SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_YELLOW_NPC_UP    ; $29
	db SPRITE_OW_WOMAN,    SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_RED_NPC_UP       ; $2a
	db SPRITE_OW_GRANNY,   SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_YELLOW_NPC_UP    ; $2b
	db SPRITE_OW_AMY,      SPRITE_ANIM_SGB_AMY_LAYING,   SPRITE_ANIM_CGB_AMY_LAYING   ; $2c
