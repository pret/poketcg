Func_1c8bc:
	push hl
	push bc
	call Set_OBJ_8x8
	ld a, LOW(Func_3ba2)
	ld [wDoFrameFunction], a
	ld a, HIGH(Func_3ba2)
	ld [wDoFrameFunction + 1], a
	ld a, $ff
	ld hl, wAnimationQueue
	ld c, ANIMATION_QUEUE_LENGTH
.fill_queue
	ld [hli], a
	dec c
	jr nz, .fill_queue
	ld [wd42a], a
	ld [wd4c0], a
	xor a
	ld [wDuelAnimBufferCurPos], a
	ld [wDuelAnimBufferSize], a
	ld [wd4b3], a
	call DefaultScreenAnimationUpdate
	call Func_3ca0
	pop bc
	pop hl
	ret

PlayLoadedDuelAnimation:
	ld a, [wDoFrameFunction + 0]
	cp LOW(Func_3ba2)
	jr nz, .error
	ld a, [wDoFrameFunction + 1]
	cp HIGH(Func_3ba2)
	jr z, .okay
.error
	debug_nop
	ret

.okay
	ld a, [wTempAnimation]
	ld [wd4bf], a
	cp DUEL_SPECIAL_ANIMS
	jp nc, Func_1cb5e

	push hl
	push bc
	push de
	call GetAnimationData
; hl: pointer

	ld a, [wAnimationsDisabled]
	or a
	jr z, .check_to_play_sfx
	; animations are disabled
	push hl
	ld bc, ANIM_SPRITE_ANIM_FLAGS
	add hl, bc
	ld a, [hl]
	; if flag is set, play animation anyway
	and (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE)
	pop hl
	jr z, .return

.check_to_play_sfx
	push hl
	ld bc, ANIM_SOUND_FX_ID
	add hl, bc
	ld a, [hl]
	pop hl
	or a
	jr z, .calc_addr
	call PlaySFX

.calc_addr
; this data field is always $00,
; so this calculation is unnecessary
; seems like there was supposed to be
; more than 1 function to handle animation
	push hl
	ld bc, ANIM_HANDLER_FUNCTION
	add hl, bc
	ld a, [hl]
	rlca
	add LOW(.address) ; $48
	ld l, a ; LO
	ld a, HIGH(.address) ; $49
	adc 0
	ld h, a ; HI
; hl: pointer
	ld a, [hli]
	ld b, [hl]
	ld c, a
	pop hl

	call CallBC
.return
	pop de
	pop bc
	pop hl
	ret

.address
	dw .handler_func

.handler_func
; if any of ANIM_SPRITE_ID, ANIM_PALETTE_ID and ANIM_SPRITE_ANIM_ID
; are 0, then return
	ld e, l
	ld d, h
	ld c, ANIM_SPRITE_ANIM_ID + 1
.loop
	ld a, [de]
	or a
	jr z, .return_with_carry
	inc de
	dec c
	jr nz, .loop

	ld a, [hli] ; ANIM_SPRITE_ID
	farcall CreateSpriteAndAnimBufferEntry
	ld a, [wWhichSprite]
	ld [wAnimationQueue], a ; push an animation to the queue

	xor a
	ld [wVRAMTileOffset], a
	ld [wd4cb], a

	ld a, [hli] ; ANIM_PALETTE_ID
	farcall LoadPaletteData
	ld a, [hli] ; ANIM_SPRITE_ANIM_ID

	push af
	ld a, [hli] ; ANIM_SPRITE_ANIM_FLAGS
	ld [wAnimFlags], a
	call LoadAnimCoordsAndFlags
	pop af

	farcall StartNewSpriteAnimation
	or a
	jr .done

.return_with_carry
	scf
.done
	ret

; loads the correct coordinates/flags for
; sprite animation in wAnimationQueue
LoadAnimCoordsAndFlags:
	push hl
	push bc
	ld a, [wAnimationQueue]
	ld c, SPRITE_ANIM_ATTRIBUTES
	call GetSpriteAnimBufferProperty_SpriteInA
	call GetAnimCoordsAndFlags

	push af
	and (1 << SPRITE_ANIM_FLAG_6) | (1 << SPRITE_ANIM_FLAG_5)
	or [hl]
	ld [hli], a
	ld a, b
	ld [hli], a ; SPRITE_ANIM_COORD_X
	ld [hl], c ; SPRITE_ANIM_COORD_Y
	pop af

	ld bc, SPRITE_ANIM_FLAGS - SPRITE_ANIM_COORD_Y
	add hl, bc
	ld c, a ; useless
	and (1 << SPRITE_ANIM_FLAG_Y_SUBTRACT) | (1 << SPRITE_ANIM_FLAG_X_SUBTRACT)
	or [hl]
	ld [hl], a
	pop bc
	pop hl
	ret

; outputs x and y coordinates for the sprite animation
; taking into account who the turn duelist is.
; also returns in a the allowed animation flags of
; the configuration that is selected.
; output:
; a = anim flags
; b = x coordinate
; c = y coordinate
GetAnimCoordsAndFlags:
	push hl
	ld c, 0
	ld a, [wAnimFlags]
	and (1 << SPRITE_ANIM_FLAG_SPEED)
	jr nz, .calc_addr

	ld a, [wDuelAnimationScreen]
	add a ; 2 * [wDuelAnimationScreen]
	ld c, a
	add a ; 4 * [wDuelAnimationScreen]
	add c ; 6 * [wDuelAnimationScreen]
	add a ; 12 * [wDuelAnimationScreen]
	ld c, a

	ld a, [wDuelAnimDuelistSide]
	cp PLAYER_TURN
	jr z, .player_side
; opponent side
	ld a, 6
	add c
	ld c, a
.player_side
	ld a, [wDuelAnimLocationParam]
	add c ; a = [wDuelAnimLocationParam] + c
	ld c, a
	ld b, 0
	ld hl, AnimationCoordinatesIndex
	add hl, bc
	ld c, [hl]

.calc_addr
	ld a, c
	add a ; a = c * 2
	add c ; a = c * 3
	ld c, a
	ld b, 0
	ld hl, AnimationCoordinates
	add hl, bc
	ld b, [hl] ; x coord
	inc hl
	ld c, [hl] ; y coord
	inc hl
	ld a, [wAnimFlags]
	and [hl] ; flags
	pop hl
	ret

AnimationCoordinatesIndex:
; animations in the Duel Main Scene
	db $01, $01, $01, $01, $01, $01 ; player
	db $02, $02, $02, $02, $02, $02 ; opponent

; animations in the Player's Play Area, for each Play Area Pokemon
	db $03, $04, $05, $06, $07, $08 ; player
	db $03, $04, $05, $06, $07, $08 ; opponent

; animations in the Opponent's Play Area, for each Play Area Pokemon
	db $09, $0a, $0b, $0c, $0d, $0e ; player
	db $09, $0a, $0b, $0c, $0d, $0e ; opponent

MACRO anim_coords
	db \1
	db \2
	db \3
ENDM

AnimationCoordinates:
; x coord, y coord, animation flags
	anim_coords 88,  88, (1 << SPRITE_ANIM_FLAG_3)

; animations in the Duel Main Scene
	anim_coords 40,  80, $00
	anim_coords 136, 48, (1 << SPRITE_ANIM_FLAG_6) | (1 << SPRITE_ANIM_FLAG_5) | (1 << SPRITE_ANIM_FLAG_Y_SUBTRACT) | (1 << SPRITE_ANIM_FLAG_X_SUBTRACT)

; animations in the Player's Play Area, for each Play Area Pokemon
	anim_coords 88,  72, $00
	anim_coords 24,  96, $00
	anim_coords 56,  96, $00
	anim_coords 88,  96, $00
	anim_coords 120, 96, $00
	anim_coords 152, 96, $00

; animations in the Opponent's Play Area, for each Play Area Pokemon
	anim_coords 88,  80, $00
	anim_coords 152, 40, $00
	anim_coords 120, 40, $00
	anim_coords 88,  40, $00
	anim_coords 56,  40, $00
	anim_coords 24,  40, $00

; appends to end of wDuelAnimBuffer
; the current duel animation
LoadDuelAnimationToBuffer:
	push hl
	push bc
	ld a, [wDuelAnimBufferCurPos]
	ld b, a
	ld hl, wDuelAnimBufferSize
	ld a, [hl]
	ld c, a
	add DUEL_ANIM_STRUCT_SIZE
	and %01111111
	cp b
	jp z, .skip
	ld [hl], a

	ld b, $00
	ld hl, wDuelAnimBuffer
	add hl, bc
	ld a, [wTempAnimation]
	ld [hli], a
	ld a, [wDuelAnimationScreen]
	ld [hli], a
	ld a, [wDuelAnimDuelistSide]
	ld [hli], a
	ld a, [wDuelAnimLocationParam]
	ld [hli], a
	ld a, [wDuelAnimDamage]
	ld [hli], a
	ld a, [wDuelAnimDamage + 1]
	ld [hli], a
	ld a, [wd4b3]
	ld [hli], a
	ld a, [wDuelAnimReturnBank]
	ld [hl], a

.skip
	pop bc
	pop hl
	ret

; loads the animations from wDuelAnimBuffer
; in ascending order, starting at wDuelAnimBufferCurPos
PlayBufferedDuelAnimations:
	push hl
	push bc
.next_duel_anim
	ld a, [wDuelAnimBufferSize]
	ld b, a
	ld a, [wDuelAnimBufferCurPos]
	cp b
	jr z, .skip

	ld c, a
	add DUEL_ANIM_STRUCT_SIZE
	and %01111111
	ld [wDuelAnimBufferCurPos], a

	ld b, $00
	ld hl, wDuelAnimBuffer
	add hl, bc
	ld a, [hli]
	ld [wTempAnimation], a
	ld a, [hli]
	ld [wDuelAnimationScreen], a
	ld a, [hli]
	ld [wDuelAnimDuelistSide], a
	ld a, [hli]
	ld [wDuelAnimLocationParam], a
	ld a, [hli]
	ld [wDuelAnimDamage], a
	ld a, [hli]
	ld [wDuelAnimDamage + 1], a
	ld a, [hli]
	ld [wd4b3], a
	ld a, [hl]
	ld [wDuelAnimReturnBank], a

	call PlayLoadedDuelAnimation
	call CheckAnyAnimationPlaying
	jr nc, .next_duel_anim

.skip
	pop bc
	pop hl
	ret

; gets data from Animations for anim ID in a
; outputs the pointer to the data in hl
GetAnimationData:
	push bc
	ld a, [wTempAnimation]
	ld l, a
	ld h, 0
	add hl, hl ; hl = anim * 2
	ld b, h
	ld c, l
	add hl, hl ; hl = anim * 4
	add hl, bc ; hl = anim * 6
	ld bc, Animations
	add hl, bc
	pop bc
	ret

Func_1cac5:
	ld a, [wd42a]
	cp $ff
	jr nz, .asm_1cb03

	ld a, [wd4c0]
	or a
	jr z, .asm_1cafb
	cp $80
	jr z, .asm_1cb11
	ld hl, wAnimationQueue
	ld c, ANIMATION_QUEUE_LENGTH
.loop_queue
	push af
	push bc
	ld a, [hl]
	cp $ff
	jr z, .next
	ld [wWhichSprite], a
	farcall GetSpriteAnimCounter
	cp $ff
	jr nz, .next
	farcall DisableCurSpriteAnim
	ld a, $ff
	ld [hl], a

.next
	pop bc
	pop af
	and [hl]
	inc hl
	dec c
	jr nz, .loop_queue

.asm_1cafb
	cp $ff
	jr nz, .skip_play_anims
	call PlayBufferedDuelAnimations
.skip_play_anims
	ret

.asm_1cb03
	ld hl, wScreenAnimUpdatePtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call CallHL2
	ld a, [wd42a]
	jr .asm_1cafb

.asm_1cb11
	ld a, $ff
	ld [wd4c0], a
	jr .asm_1cafb

Func_1cb18:
	push hl
	push bc
	push de

	; if Func_3ba2 is not set as
	; wDoFrameFunction, quit and set carry
	ld a, [wDoFrameFunction]
	cp LOW(Func_3ba2)
	jr nz, .carry
	ld a, [wDoFrameFunction + 1]
	cp HIGH(Func_3ba2)
	jr nz, .carry

	ld a, $ff
	ld [wd4c0], a
	ld a, [wd42a]
	cp $ff
	call nz, DoScreenAnimationUpdate

; clear all queued animations
; and disable their sprite anims
	ld hl, wAnimationQueue
	ld c, ANIMATION_QUEUE_LENGTH
.loop_queue
	push bc
	ld a, [hl]
	cp $ff
	jr z, .next_queued
	ld [wWhichSprite], a
	farcall DisableCurSpriteAnim
	ld a, $ff
	ld [hl], a
.next_queued
	pop bc
	inc hl
	dec c
	jr nz, .loop_queue

	xor a
	ld [wDuelAnimBufferCurPos], a
	ld [wDuelAnimBufferSize], a
.done
	pop de
	pop bc
	pop hl
	ret
.carry
	scf
	jr .done

Func_1cb5e:
	cp $96
	jp nc, Func_1ce03
	cp $8c
	jp nz, InitScreenAnimation
	jr .asm_1cb6a ; redundant
.asm_1cb6a
	ld a, [wDuelAnimDamage + 1]
	cp $03
	jr nz, .asm_1cb76
	ld a, [wDuelAnimDamage]
	cp $e8
.asm_1cb76
	ret nc

	xor a
	ld [wd4b8], a
	ld [wVRAMTileOffset], a
	ld [wd4cb], a

	ld a, PALETTE_37
	farcall LoadPaletteData
	call Func_1cba6

	ld hl, wd4b3
	bit 0, [hl]
	call nz, Func_1cc3e

	ld a, $12
	ld [wd4b8], a
	bit 1, [hl]
	call nz, Func_1cc4e

	bit 2, [hl]
	call nz, Func_1cc66

	xor a
	ld [wd4b3], a
	ret

Func_1cba6:
	call Func_1cc03
	xor a
	ld [wd4b7], a

	ld hl, wDecimalChars
	ld de, wAnimationQueue + 1
.asm_1cbb3
	push hl
	push de
	ld a, [hl]
	or a
	jr z, .asm_1cbbc
	call Func_1cbcc

.asm_1cbbc
	pop de
	pop hl
	inc hl
	inc de
	ld a, [wd4b7]
	inc a
	ld [wd4b7], a
	cp $03
	jr c, .asm_1cbb3
	ret

Func_1cbcc:
	push af
	ld a, SPRITE_DUEL_4
	farcall CreateSpriteAndAnimBufferEntry
	ld a, [wWhichSprite]
	ld [de], a
	ld a, (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE)
	ld [wAnimFlags], a
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	call GetAnimCoordsAndFlags

	ld a, [wd4b7]
	add LOW(Unknown_1cbfd)
	ld e, a
	ld a, HIGH(Unknown_1cbfd)
	adc 0
	ld d, a
	ld a, [de]
	add b

	ld [hli], a ; SPRITE_ANIM_COORD_X
	ld [hl], c ; SPRITE_ANIM_COORD_Y

	ld a, [wd4b8]
	ld c, a
	pop af
	farcall Func_12ac9
	ret

Unknown_1cbfd:
	db -$10, -$8, $0, $8, -$8, -$10

Func_1cc03:
	ld a, [wDuelAnimDamage]
	ld l, a
	ld a, [wDuelAnimDamage + 1]
	ld h, a

	ld de, wDecimalChars
	ld bc, -100
	call .Func_1cc2f
	ld bc, -10
	call .Func_1cc2f

	ld a, l
	add $4f
	ld [de], a
	ld hl, wDecimalChars
	ld c, 2
.asm_1cc23
	ld a, [hl]
	cp $4f
	jr nz, .asm_1cc2e
	ld [hl], $00
	inc hl
	dec c
	jr nz, .asm_1cc23
.asm_1cc2e
	ret

.Func_1cc2f
	ld a, $4e
.loop
	inc a
	add hl, bc
	jr c, .loop

	ld [de], a
	inc de
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	ret

Func_1cc3e:
	push hl
	ld a, $03
	ld [wd4b7], a
	ld de, wAnimationQueue + 4
	ld a, SPRITE_ANIM_91
	call Func_1cbcc
	pop hl
	ret

Func_1cc4e:
	push hl
	ld a, $04
	ld [wd4b7], a
	ld de, wAnimationQueue + 5
	ld a, SPRITE_ANIM_90
	call Func_1cbcc
	ld a, [wd4b8]
	add $12
	ld [wd4b8], a
	pop hl
	ret

Func_1cc66:
	push hl
	ld a, $05
	ld [wd4b7], a
	ld de, wAnimationQueue + 6
	ld a, SPRITE_ANIM_89
	call Func_1cbcc
	pop hl
	ret
