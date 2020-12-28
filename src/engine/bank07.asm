	INCROM $1c000, $1c056

Func_1c056: ; 1c056 (7:4056)
	push hl
	push bc
	push de
	ld a, [wCurMap]
	add a
	ld c, a
	ld b, $0
	ld hl, WarpDataPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0005
	ld a, [wPlayerXCoord]
	ld d, a
	ld a, [wPlayerYCoord]
	ld e, a
.asm_1c072
	ld a, [hli]
	or [hl]
	jr z, .asm_1c095
	ld a, [hld]
	cp e
	jr nz, .asm_1c07e
	ld a, [hl]
	cp d
	jr z, .asm_1c081
.asm_1c07e
	add hl, bc
	jr .asm_1c072
.asm_1c081
	inc hl
	inc hl
	ld a, [hli]
	ld [wTempMap], a
	ld a, [hli]
	ld [wTempPlayerXCoord], a
	ld a, [hli]
	ld [wTempPlayerYCoord], a
	ld a, [wPlayerDirection]
	ld [wTempPlayerDirection], a
.asm_1c095
	pop de
	pop bc
	pop hl
	ret

INCLUDE "data/warps.asm"

Func_1c33b: ; 1c33b (7:433b)
	push hl
	push bc
	push de
	ld a, [wCurMap]
	add a
	ld c, a
	add a
	add c
	ld c, a
	ld b, $0
	ld hl, MapHeaders
	add hl, bc
	ld a, [hli]
	ld [wd131], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld [wd28f], a
	ld a, [hli]
	ld [wd132], a
	ld a, [hli]
	ld [wd290], a
	ld a, [hli]
	ld [wd111], a
	ld a, [wConsole]
	cp $2
	jr nz, .asm_1c370
	ld a, c
	or a
	jr z, .asm_1c370
	ld [wd131], a
.asm_1c370
	pop de
	pop bc
	pop hl
	ret

INCLUDE "data/map_headers.asm"

Func_1c440: ; 1c440 (7:4440)
	INCROM $1c440, $1c455

GetNPCDirection: ; 1c455 (7:4455)
	push hl
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_DIRECTION
	call GetItemInLoadedNPCIndex
	ld a, [hl]
	pop hl
	ret

Func_1c461: ; 1c461 (7:4461)
	push hl
	push bc
	call Func_1c719
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_COORD_X
	call GetItemInLoadedNPCIndex
	ld a, b
	ld [hli], a
	ld [hl], c
	call $46e3
	pop bc
	pop hl
	ret

Func_1c477: ; 1c477 (7:4477)
	push hl
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_COORD_X
	call GetItemInLoadedNPCIndex
	ld a, [hli]
	ld b, a
	ld c, [hl]
	pop hl
	ret

; Loads NPC Sprite Data
Func_1c485: ; 1c485 (7:4485)
	push hl
	push bc
	push de
	xor a
	ld [wLoadedNPCTempIndex], a
	ld b, a
	ld c, LOADED_NPC_MAX
	ld hl, wLoadedNPCs
	ld de, LOADED_NPC_LENGTH
.findEmptyIndexLoop
	ld a, [hl]
	or a
	jr z, .foundEmptyIndex
	add hl, de
	inc b
	dec c
	jr nz, .findEmptyIndexLoop
	ld hl, wLoadedNPCs
	debug_ret
	jr .exit
.foundEmptyIndex
	ld a, b
	ld [wLoadedNPCTempIndex], a
	ld a, [wNPCSpriteID]
	farcall CreateSpriteAndAnimBufferEntry
	jr c, .exit
	ld a, [wLoadedNPCTempIndex]
	call GetLoadedNPCID
	push hl
	ld a, [wTempNPC]
	ld [hli], a
	ld a, [wWhichSprite]
	ld [hli], a
	ld a, [wLoadNPCXPos]
	ld [hli], a
	ld a, [wLoadNPCYPos]
	ld [hli], a
	ld a, [wLoadNPCDirection]
	ld [hli], a
	ld a, [wd3b2]
	ld [hli], a
	ld a, [wd3b1]
	ld [hli], a
	ld a, [wLoadNPCDirection]
	ld [hli], a
	call Func_1c58e
	call Func_1c5b9
	ld hl, wd349
	inc [hl]
	pop hl
	call Func_1c665
	call Func_1c6e3
	ld a, [wTempNPC]
	call Func_1c4fa
	jr nc, .exit
	ld a, $01
	ld [wd3b8], a
.exit
	pop de
	pop bc
	pop hl
	ret

Func_1c4fa: ; 1c4fa (7:44fa)
	cp NPC_RONALD1
	jr z, .asm_1c508
	cp NPC_RONALD2
	jr z, .asm_1c508
	cp NPC_RONALD3
	jr z, .asm_1c508
	or a
	ret
.asm_1c508
	scf
	ret

Func_1c50a: ; 1c50a (7:450a)
	push hl
	call Func_1c719
	ld a, [wLoadedNPCTempIndex]
	call GetLoadedNPCID
	ld a, [hl]
	or a
	jr z, .asm_1c52c
	call $44fa
	jr nc, .asm_1c521
	xor a
	ld [wd3b8], a

.asm_1c521
	xor a
	ld [hli], a
	ld a, [hl]
	farcall $4, $69fd
	ld hl, wd349
	dec [hl]

.asm_1c52c
	pop hl
	ret

Func_1c52e: ; 1c52e (7:452e)
	push hl
	push af
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_FIELD_07
	call GetItemInLoadedNPCIndex
	pop af
	ld [hl], a
	call Func_1c5e9
	pop hl
	ret

Func_1c53f: ; 1c53f (7:453f)
	push hl
	push bc
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_DIRECTION
	call GetItemInLoadedNPCIndex
	ld a, [hl]
	ld bc, $0003
	add hl, bc
	ld [hl], a
	push af
	call Func_1c5e9
	pop af
	pop bc
	pop hl
	ret

Func_1c557: ; 1c557 (7:4557)
	push bc
	ld c, a
	ld a, [wLoadedNPCTempIndex]
	push af
	ld a, [wTempNPC]
	push af
	ld a, c
	ld [wTempNPC], a
	ld c, $0
	call FindLoadedNPC
	jr c, .asm_1c570
	call Func_1c53f
	ld c, a

.asm_1c570
	pop af
	ld [wTempNPC], a
	pop af
	ld [wLoadedNPCTempIndex], a
	ld a, c
	pop bc
	ret

Func_1c57b: ; 1c57b (7:457b)
	push hl
	push bc
	push af
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_FIELD_06
	call GetItemInLoadedNPCIndex
	pop af
	ld [hl], a
	call Func_1c58e
	pop bc
	pop hl
	ret

Func_1c58e: ; 1c58e (7:458e)
	push hl
	push bc
	ld a, [wWhichSprite]
	push af
	ld a, [wLoadedNPCTempIndex]
	call GetLoadedNPCID
	ld a, [hli]
	or a
	jr z, .quit
	ld a, [hl]
	ld [wWhichSprite], a
	ld bc, LOADED_NPC_FIELD_06 - LOADED_NPC_SPRITE
	add hl, bc
	ld a, [hld]
	bit 4, [hl]
	jr nz, .asm_1c5ae
	dec hl
	add [hl]
	inc hl
.asm_1c5ae
	farcall StartNewSpriteAnimation
.quit
	pop af
	ld [wWhichSprite], a
	pop bc
	pop hl
	ret

Func_1c5b9: ; 1c5b9 (7:45b9)
	INCROM $1c5b9, $1c5e9

Func_1c5e9: ; 1c5e9 (7:45e9)
	push hl
	push bc
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_FIELD_07
	call GetItemInLoadedNPCIndex
	ld a, [hl]
	ld bc, $fffd
	add hl, bc
	ld [hl], a
	call Func_1c58e
	pop bc
	pop hl
	ret
; 0x1c5ff

	INCROM $1c5ff, $1c610

Func_1c610: ; 1c610 (7:4610)
	INCROM $1c610, $1c665

Func_1c665: ; 1c665 (7:4665)
	INCROM $1c665, $1c6e3

Func_1c6e3: ; 1c6e3 (7:46e3)
	push hl
	push bc
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_COORD_X
	call GetItemInLoadedNPCIndex
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld a, $40
	call SetPermissionOfMapPosition
	pop bc
	pop hl
	ret

Func_1c6f8: ; 1c6f8 (7:46f8)
	INCROM $1c6f8, $1c719

Func_1c719: ; 1c719 (7:4719)
	push hl
	push bc
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_COORD_X
	call GetItemInLoadedNPCIndex
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld a, $40
	call $3937
	pop bc
	pop hl
	ret

; Find NPC at coords b (x) c (y)
FindNPCAtLocation: ; 1c72e (7:472e)
	push hl
	push bc
	push de
	ld d, $00
	ld e, LOADED_NPC_MAX
	ld hl, wLoadedNPC1CoordX
.findValidNPCLoop
	ld a, [hli]
	cp b
	jr nz, .noValidNPCHere
	ld a, [hl]
	cp c
	jr nz, .noValidNPCHere
	push hl
	inc hl
	inc hl
	bit 6, [hl]
	pop hl
	jr nz, .noValidNPCHere
	push hl
	dec hl
	dec hl
	ld a, [hl]
	or a
	pop hl
	jr nz, .foundNPCExit
.noValidNPCHere
	ld a, LOADED_NPC_LENGTH - 1
	add l
	ld l, a
	ld a, h
	adc $00
	ld h, a
	inc d
	dec e
	jr nz, .findValidNPCLoop
	scf
	jr .exit
.foundNPCExit
	ld a, d
	ld [wLoadedNPCTempIndex], a
	or a
.exit
	pop de
	pop bc
	pop hl
	ret

; Probably needs a new name. Loads data for NPC that the next Script is for
; Sets direction, Loads Image data for it, loads name, and more
SetNewScriptNPC: ; 1c768 (7:4768)
	push hl
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_DIRECTION
	call GetItemInLoadedNPCIndex
	ld a, [wPlayerDirection]
	xor $02
	ld [hl], a
	call Func_1c58e
	ld a, $02
	farcall Func_c29b
	ld a, [wLoadedNPCTempIndex]
	call GetLoadedNPCID
	ld a, [hl]
	farcall GetNPCNameAndScript
	pop hl
	ret

Func_1c78d: ; 1c78d (7:478d)
	push hl
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_FIELD_05
	call GetItemInLoadedNPCIndex
	set 5, [hl]
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_FIELD_08
	call GetItemInLoadedNPCIndex
	xor a
	ld [hli], a
.asm_1c7a2
	ld [hl], c
	inc hl
	ld [hl], b
	dec hl
	call $39ea
	cp $f0
	jr nc, .asm_1c7bb
	push af
	and $7f
	call $45ff
	pop af
	bit 7, a
	jr z, .asm_1c7dc
	inc bc
	jr .asm_1c7a2

.asm_1c7bb
	cp $ff
	jr z, .asm_1c7d2
	inc bc
	call $39ea
	push hl
	ld l, a
	ld h, $0
	bit 7, l
	jr z, .asm_1c7cc
	dec h

.asm_1c7cc
	add hl, bc
	ld c, l
	ld b, h
	pop hl
	jr .asm_1c7a2

.asm_1c7d2
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_FIELD_05
	call GetItemInLoadedNPCIndex
	res 5, [hl]

.asm_1c7dc
	pop hl
	ret

Func_1c7de: ; 1c7de (7:47de)
	ld a, [wc3b7]
	and $20
	ret
; 0x1c7e4

	INCROM $1c7e4, $1c82e

Func_1c82e: ; 1c82e (7:482e)
	INCROM $1c82e, $1c83d

Func_1c83d: ; 1c83d (7:483d)
	push hl
	push bc
	ld b, a
	ld c, $a
	ld hl, wd3bb
.asm_1c845
	ld a, [hl]
	or a
	jr z, .asm_1c853
	cp b
	jr z, .asm_1c855
	inc hl
	dec c
	jr nz, .asm_1c845
	debug_ret
	jr .asm_1c855

.asm_1c853
	ld a, b
	ld [hl], a

.asm_1c855
	pop bc
	pop hl
	ret
; 0x1c858

	INCROM $1c858, $1c8bc

Func_1c8bc: ; 1c8bc (7:48bc)
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
	ld [wd4ac], a
	ld [wd4ad], a
	ld [wd4b3], a
	call Func_1ccbc
	call Func_3ca0
	pop bc
	pop hl
	ret
; 0x1c8ef

Func_1c8ef: ; 1c8ef (7:48ef)
	ld a, [wDoFrameFunction + 0]
	cp LOW(Func_3ba2)
	jr nz, .error
	ld a, [wDoFrameFunction + 1]
	cp HIGH(Func_3ba2)
	jr z, .okay
.error
	debug_ret
	ret

.okay
	ld a, [wTempAnimation]
	ld [wd4bf], a
	cp $61
	jp nc, Func_1cb5e

	push hl
	push bc
	push de
	call Func_1cab3
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

.handler_func ; 1c94a (7:494a)
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
	farcall Func_80418
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
LoadAnimCoordsAndFlags: ; 1c980 (7:4980)
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
GetAnimCoordsAndFlags: ; 1c9a2 (7:49a2)
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

	ld a, [wd4af]
	cp PLAYER_TURN
	jr z, .player_side
; opponent side
	ld a, 6
	add c
	ld c, a
.player_side
	ld a, [wd4b0]
	add c ; a = [wd4b0] + c
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

anim_coords: MACRO
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

Func_1ca31: ; 1ca31 (7:4a31)
	push hl
	push bc
	ld a, [wd4ac]
	ld b, a
	ld hl, wd4ad
	ld a, [hl]
	ld c, a
	add %00001000
	and %01111111
	cp b
	jp z, .asm_007_4a6b
	ld [hl], a

	ld b, $00
	ld hl, wd42c
	add hl, bc
	ld a, [wTempAnimation]
	ld [hli], a
	ld a, [wDuelAnimationScreen]
	ld [hli], a
	ld a, [wd4af]
	ld [hli], a
	ld a, [wd4b0]
	ld [hli], a
	ld a, [wd4b1]
	ld [hli], a
	ld a, [wd4b2]
	ld [hli], a
	ld a, [wd4b3]
	ld [hli], a
	ld a, [wd4be]
	ld [hl], a

.asm_007_4a6b
	pop bc
	pop hl
	ret

Func_1ca6e: ; 1ca6e (7:4a6e)
	push hl
	push bc
.asm_1ca70
	ld a, [wd4ad]
	ld b, a
	ld a, [wd4ac]
	cp b
	jr z, .asm_1cab0

	ld c, a
	add $08
	and $7f
	ld [wd4ac], a

	ld b, $00
	ld hl, wd42c
	add hl, bc
	ld a, [hli]
	ld [wTempAnimation], a
	ld a, [hli]
	ld [wDuelAnimationScreen], a
	ld a, [hli]
	ld [wd4af], a
	ld a, [hli]
	ld [wd4b0], a
	ld a, [hli]
	ld [wd4b1], a
	ld a, [hli]
	ld [wd4b2], a
	ld a, [hli]
	ld [wd4b3], a
	ld a, [hl]
	ld [wd4be], a

	call Func_1c8ef
	call CheckAnyAnimationPlaying
	jr nc, .asm_1ca70

.asm_1cab0
	pop bc
	pop hl
	ret
; 0x1cab3

; gets data from Animations for anim ID in a
Func_1cab3: ; 1cab3 (7:4ab3)
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

Func_1cac5: ; 1cac5 (7:4ac5)
	ld a, [wd42a]
	cp $ff
	jr nz, .asm_1cb03

	ld a, [wd4c0]
	or a
	jr z, .asm_1cafb
	cp $80
	jr z, .asm_1cb11
	ld hl, wAnimationQueue
	ld c, $07
.asm_1cadb
	push af
	push bc
	ld a, [hl]
	cp $ff
	jr z, .asm_1caf4
	ld [wWhichSprite], a
	farcall Func_12a13
	cp $ff
	jr nz, .asm_1caf4
	farcall Func_129fa
	ld a, $ff
	ld [hl], a
.asm_1caf4
	pop bc
	pop af
	and [hl]
	inc hl
	dec c
	jr nz, .asm_1cadb
.asm_1cafb
	cp $ff
	jr nz, .asm_1cb02
	call Func_1ca6e
.asm_1cb02
	ret

.asm_1cb03
	ld hl, wd4b9
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
; 0x1cb18

Func_1cb18: ; 1cb18 (7:4b18)
	push hl
	push bc
	push de
	ld a, [wDoFrameFunction]
	cp LOW(Func_3ba2)
	jr nz, .asm_1cb5b
	ld a, [wDoFrameFunction + 1]
	cp HIGH(Func_3ba2)
	jr nz, .asm_1cb5b
	ld a, $ff
	ld [wd4c0], a
	ld a, [wd42a]
	cp $ff
	call nz, $4cd4
	ld hl, wAnimationQueue
	ld c, $07
.asm_1cb3b
	push bc
	ld a, [hl]
	cp $ff
	jr z, .asm_1cb4b
	ld [wWhichSprite], a
	farcall $4, $69fa
	ld a, $ff
	ld [hl], a
.asm_1cb4b
	pop bc
	inc hl
	dec c
	jr nz, .asm_1cb3b
	xor a
	ld [wd4ac], a
	ld [wd4ad], a
.asm_1cb57
	pop de
	pop bc
	pop hl
	ret
.asm_1cb5b
	scf
	jr .asm_1cb57
; 0x1cb5e

Func_1cb5e: ; 1cb5e (7:4b5e)
	cp $96
	jp nc, Func_1ce03
	cp $8c
	jp nz, Func_1cc76
	jr .asm_1cb6a ; redundant
.asm_1cb6a
	ld a, [wd4b2]
	cp $03
	jr nz, .asm_1cb76
	ld a, [wd4b1]
	cp $e8
.asm_1cb76
	ret nc

	xor a
	ld [wd4b8], a
	ld [wVRAMTileOffset], a
	ld [wd4cb], a

	ld a, $25
	farcall Func_80418
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
; 0x1cba6

Func_1cba6: ; 1cba6 (7:4ba6)
	call Func_1cc03
	xor a
	ld [wd4b7], a

	ld hl, wd4b4
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
; 0x1cbcc

Func_1cbcc: ; 1cbcc (7:4bcc)
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
	add $fd
	ld e, a
	ld a, $4b
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
; 0x1cbfd

	INCROM $1cbfd, $1cc03

Func_1cc03: ; 1cc03 (7:4c03)
	ld a, [wd4b1]
	ld l, a
	ld a, [wd4b2]
	ld h, a

	ld de, wd4b4
	ld bc, -100
	call .Func_1cc2f
	ld bc, -10
	call .Func_1cc2f

	ld a, l
	add $4f
	ld [de], a
	ld hl, wd4b4
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
; 0x1cc2f

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
; 0x1cc3e

Func_1cc3e: ; 1cc3e (7:4c3e)
	push hl
	ld a, $03
	ld [wd4b7], a
	ld de, wAnimationQueue + 4
	ld a, $5b
	call Func_1cbcc
	pop hl
	ret
; 0x1cc4e

Func_1cc4e: ; 1cc4e (7:4c4e)
	push hl
	ld a, $04
	ld [wd4b7], a
	ld de, wAnimationQueue + 5
	ld a, $5a
	call Func_1cbcc
	ld a, [wd4b8]
	add $12
	ld [wd4b8], a
	pop hl
	ret
; 0x1cc66

Func_1cc66: ; 1cc66 (7:4c66)
	push hl
	ld a, $05
	ld [wd4b7], a
	ld de, wAnimationQueue + 6
	ld a, $59
	call Func_1cbcc
	pop hl
	ret
; 0x1cc76

Func_1cc76: ; 1cc76 (7:4c76)
	ld a, [wAnimationsDisabled]
	or a
	jr nz, .asm_1cc9e
	ld a, [wTempAnimation]
	ld [wd42a], a
	sub $61
	add a
	add a
	ld c, a
	ld b, $00
	ld hl, Data_1cc9f
	add hl, bc
	ld a, [hli]
	ld [wd4b9], a
	ld c, a
	ld a, [hli]
	ld [wd4b9 + 1], a
	ld b, a
	ld a, [hl]
	ld [wd4bb], a
	call CallBC
.asm_1cc9e
	ret
; 0x1cc9f

macro_1cc9f: MACRO
	dw \1
	db \2
	db \3
ENDM

Data_1cc9f: ; 1cc9f (7:4c9f)
	macro_1cc9f Func_1cce4, $18, $00
	macro_1cc9f Func_1cce9, $20, $00
	macro_1cc9f Func_1cd10, $18, $00
	macro_1cc9f Func_1cd15, $20, $00
	macro_1cc9f Func_1cd76, $08, $00
	macro_1cc9f Func_1cdc3, $3f, $00

Func_1ccb7: ; 1ccb7 (7:4cb7)
	ld a, [wd4bb]
	or a
	ret nz
	; fallthrough

Func_1ccbc: ; 1ccbc (7:4cbc)
	ld a, $ff
	ld [wd42a], a
	call DisableInt_LYCoincidence
	xor a
	ldh [hSCX], a
	ldh [rSCX], a
	ldh [hSCY], a
	ld hl, wd4b9
	ld [hl], LOW(Func_1ccbc)
	inc hl
	ld [hl], HIGH(Func_1ccbc)
	ret
; 0x1ccd4

	INCROM $1ccd4, $1cce4

Func_1cce4: ; 1cce4 (7:4ce4)
	ld hl, Data_1cd55
	jr Func_1ccee

Func_1cce9: ; 1cce9 (7:4ce9)
	ld hl, Data_1cd61
	jr Func_1ccee

Func_1ccee: ; 1ccee (7:4cee)
	ld a, l
	ld [wd4bc], a
	ld a, h
	ld [wd4bc + 1], a

	ld hl, wd4b9
	ld [hl], LOW(.asm_1ccff)
	inc hl
	ld [hl], HIGH(.asm_1ccff)
	ret

.asm_1ccff
	call Func_1cd71
	call Func_1cd3c
	jp nc, Func_1ccb7
	ldh a, [hSCX]
	add [hl]
	ldh [hSCX], a
	jp Func_1ccb7
; 0x1cd10

Func_1cd10: ; 1cd10 (7:4d10)
	ld hl, Data_1cd55
	jr Func_1cd1a

Func_1cd15: ; 1cd15 (7:4d15)
	ld hl, Data_1cd61
	jr Func_1cd1a

Func_1cd1a: ; 1cd1a (7:4d1a)
	ld a, l
	ld [wd4bc], a
	ld a, h
	ld [wd4bc + 1], a
	ld hl, wd4b9
	ld [hl], LOW(.asm_1cd2b)
	inc hl
	ld [hl], HIGH(.asm_1cd2b)
	ret

.asm_1cd2b
	call Func_1cd71
	call Func_1cd3c
	jp nc, Func_1ccb7
	ldh a, [hSCY]
	add [hl]
	ldh [hSCY], a
	jp Func_1ccb7
; 0x1cd3c

Func_1cd3c: ; 1cd3c (7:4d3c)
	ld hl, wd4bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd4bb]
	cp [hl]
	ret nc
	inc hl
	push hl
	inc hl
	ld a, l
	ld [wd4bc], a
	ld a, h
	ld [wd4bc + 1], a
	pop hl
	scf
	ret
; 0x1cd55

Data_1cd55: ; 1cd55 (7:4d55)
	db $15, $02, $11, $fe, $0d, $02, $09, $fe, $05, $01, $01, $ff

Data_1cd61: ; 1cd61 (7:4d61)
	db $1d, $04, $19, $fc, $15, $04, $11, $fc, $0d, $03, $09, $fd, $05, $02, $01, $fe

Func_1cd71: ; 1cd71 (7:4d71)
	ld hl, wd4bb
	dec [hl]
	ret
; 0x1cd76

Func_1cd76: ; 1cd76 (7:4d76)
	ld hl, wd4b9
	ld [hl], $a3
	inc hl
	ld [hl], $4d
	ld a, [wBGP]
	ld [wd4bc], a
	ld hl, wBackgroundPalettesCGB
	ld de, wd297
	ld bc, 8 palettes
	call CopyDataHLtoDE_SaveRegisters
	ld de, $7fff
	ld hl, wBackgroundPalettesCGB
	ld bc, $20
	call FillMemoryWithDE
	xor a
	call SetBGP
	call FlushAllPalettes
	call Func_1cd71
	ld a, [wd4bb]
	or a
	ret nz
	ld hl, wd297
	ld de, wBackgroundPalettesCGB
	ld bc, 8 palettes
	call CopyDataHLtoDE_SaveRegisters
	ld a, [wd4bc]
	call SetBGP
	call FlushAllPalettes
	jp Func_1ccbc
; 0x1cdc3

Func_1cdc3: ; 1cdc3 (7:4dc3)
	ld hl, wd4b9
	ld [hl], $df
	inc hl
	ld [hl], $4d
	xor a
	ld [wApplyBGScroll], a
	ld hl, $cace
	ld [hl], $a6
	inc hl
	ld [hl], $3e
	ld a, $01
	ld [wBGScrollMod], a
	call EnableInt_LYCoincidence
	ld a, [$d4bb]
	srl a
	srl a
	srl a
	and $07
	ld c, a
	ld b, $00
	ld hl, $4dfb
	add hl, bc
	ld a, [hl]
	ld [wBGScrollMod], a
	call Func_1cd71
	jp Func_1ccb7
; 0x1cdfb

	INCROM $1cdfb, $1ce03

Func_1ce03: ; 1ce03 (7:4e03)
	cp $9e
	jr z, .asm_1ce17
	sub $96
	add a
	ld c, a
	ld b, $00
	ld hl, $4e22
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp Func_3bb5
.asm_1ce17
	ld a, [wd4b1]
	ld l, a
	ld a, [wd4b2]
	ld h, a
	jp Func_3bb5
; 0x1ce22

	INCROM $1ce22, $1ce32

; data for each animation ID (see src/constants/sprite_constants.asm)
Animations: ; 1ce32 (7:4e32)
	; DUEL_ANIM_NONE
	db $00 ; sprite ID
	db $00 ; palette ID
	db $00 ; anim ID
	db $00 ; anim flags
	db $00 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_GLOW
	db SPRITE_DUEL_GLOW ; sprite ID
	db $1f ; palette ID
	db $47 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db $11 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_2
	db SPRITE_DUEL_1 ; sprite ID
	db $20 ; palette ID
	db $48 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db $12 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_SLEEP
	db SPRITE_DUEL_2 ; sprite ID
	db $21 ; palette ID
	db $49 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db $13 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_4
	db SPRITE_DUEL_55 ; sprite ID
	db $22 ; palette ID
	db $4a ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db $14 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_POISON
	db SPRITE_DUEL_58 ; sprite ID
	db $23 ; palette ID
	db $4b ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db $15 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_6
	db SPRITE_DUEL_3 ; sprite ID
	db $24 ; palette ID
	db $4c ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db $16 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_HIT
	db SPRITE_DUEL_3 ; sprite ID
	db $24 ; palette ID
	db $4d ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db $16 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_8
	db SPRITE_DUEL_3 ; sprite ID
	db $24 ; palette ID
	db $4e ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db $17 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_SHOW_DAMAGE
	db SPRITE_DUEL_4 ; sprite ID
	db $25 ; palette ID
	db $00 ; anim ID
	db $00 ; anim flags
	db $00 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_THUNDER_SHOCK
	db SPRITE_DUEL_5 ; sprite ID
	db $26 ; palette ID
	db $5c ; anim ID
	db $00 ; anim flags
	db $18 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_11
	db SPRITE_DUEL_6 ; sprite ID
	db $27 ; palette ID
	db $5e ; anim ID
	db $00 ; anim flags
	db $19 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_12
	db SPRITE_DUEL_59 ; sprite ID
	db $28 ; palette ID
	db $5f ; anim ID
	db $00 ; anim flags
	db $1a ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_13
	db SPRITE_DUEL_7 ; sprite ID
	db $29 ; palette ID
	db $60 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $1b ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_14
	db SPRITE_DUEL_8 ; sprite ID
	db $2a ; palette ID
	db $61 ; anim ID
	db $00 ; anim flags
	db $1c ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_15
	db SPRITE_DUEL_8 ; sprite ID
	db $2a ; palette ID
	db $62 ; anim ID
	db $00 ; anim flags
	db $1d ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_16
	db SPRITE_DUEL_9 ; sprite ID
	db $2b ; palette ID
	db $63 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $1e ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_17
	db SPRITE_DUEL_10 ; sprite ID
	db $2c ; palette ID
	db $64 ; anim ID
	db $00 ; anim flags
	db $1f ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_18
	db SPRITE_DUEL_61 ; sprite ID
	db $2d ; palette ID
	db $69 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $20 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_19
	db SPRITE_DUEL_11 ; sprite ID
	db $2e ; palette ID
	db $6a ; anim ID
	db $00 ; anim flags
	db $21 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_20
	db SPRITE_DUEL_12 ; sprite ID
	db $2f ; palette ID
	db $6b ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $22 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_21
	db SPRITE_DUEL_13 ; sprite ID
	db $30 ; palette ID
	db $6c ; anim ID
	db $00 ; anim flags
	db $23 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_22
	db SPRITE_DUEL_62 ; sprite ID
	db $31 ; palette ID
	db $6d ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $24 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_23
	db SPRITE_DUEL_14 ; sprite ID
	db $32 ; palette ID
	db $6e ; anim ID
	db $00 ; anim flags
	db $25 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_24
	db SPRITE_DUEL_15 ; sprite ID
	db $33 ; palette ID
	db $6f ; anim ID
	db $00 ; anim flags
	db $26 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_25
	db SPRITE_DUEL_16 ; sprite ID
	db $34 ; palette ID
	db $70 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_6) | (1 << SPRITE_ANIM_FLAG_Y_SUBTRACT) ; anim flags
	db $27 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_26
	db SPRITE_DUEL_17 ; sprite ID
	db $35 ; palette ID
	db $71 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_6) | (1 << SPRITE_ANIM_FLAG_Y_SUBTRACT) ; anim flags
	db $28 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_27
	db SPRITE_DUEL_18 ; sprite ID
	db $36 ; palette ID
	db $72 ; anim ID
	db $00 ; anim flags
	db $29 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_28
	db SPRITE_DUEL_18 ; sprite ID
	db $36 ; palette ID
	db $73 ; anim ID
	db $00 ; anim flags
	db $2a ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_29
	db SPRITE_DUEL_19 ; sprite ID
	db $37 ; palette ID
	db $74 ; anim ID
	db $00 ; anim flags
	db $2b ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_30
	db SPRITE_DUEL_19 ; sprite ID
	db $37 ; palette ID
	db $75 ; anim ID
	db $00 ; anim flags
	db $52 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_31
	db SPRITE_DUEL_19 ; sprite ID
	db $37 ; palette ID
	db $76 ; anim ID
	db $00 ; anim flags
	db $53 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_32
	db SPRITE_DUEL_20 ; sprite ID
	db $38 ; palette ID
	db $77 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_5) | (1 << SPRITE_ANIM_FLAG_X_SUBTRACT) ; anim flags
	db $2c ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_33
	db SPRITE_DUEL_21 ; sprite ID
	db $39 ; palette ID
	db $78 ; anim ID
	db $00 ; anim flags
	db $2d ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_34
	db SPRITE_DUEL_22 ; sprite ID
	db $3a ; palette ID
	db $7a ; anim ID
	db $00 ; anim flags
	db $2d ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_35
	db SPRITE_DUEL_23 ; sprite ID
	db $3b ; palette ID
	db $7b ; anim ID
	db $00 ; anim flags
	db $2e ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_FURY_SWIPES
	db SPRITE_DUEL_21 ; sprite ID
	db $39 ; palette ID
	db $79 ; anim ID
	db $00 ; anim flags
	db $2f ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_37
	db SPRITE_DUEL_24 ; sprite ID
	db $3c ; palette ID
	db $7c ; anim ID
	db (1 << SPRITE_ANIM_FLAG_5) | (1 << SPRITE_ANIM_FLAG_X_SUBTRACT) ; anim flags
	db $30 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_38
	db SPRITE_DUEL_25 ; sprite ID
	db $3d ; palette ID
	db $7d ; anim ID
	db $00 ; anim flags
	db $31 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_39
	db SPRITE_DUEL_26 ; sprite ID
	db $3e ; palette ID
	db $7e ; anim ID
	db $00 ; anim flags
	db $32 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_40
	db SPRITE_DUEL_27 ; sprite ID
	db $3f ; palette ID
	db $7f ; anim ID
	db $00 ; anim flags
	db $33 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_41
	db SPRITE_DUEL_28 ; sprite ID
	db $40 ; palette ID
	db $80 ; anim ID
	db $00 ; anim flags
	db $34 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_42
	db SPRITE_DUEL_29 ; sprite ID
	db $41 ; palette ID
	db $81 ; anim ID
	db $00 ; anim flags
	db $35 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_43
	db SPRITE_DUEL_56 ; sprite ID
	db $42 ; palette ID
	db $82 ; anim ID
	db $00 ; anim flags
	db $36 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_44
	db SPRITE_DUEL_30 ; sprite ID
	db $43 ; palette ID
	db $83 ; anim ID
	db $00 ; anim flags
	db $37 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_45
	db SPRITE_DUEL_31 ; sprite ID
	db $44 ; palette ID
	db $84 ; anim ID
	db $00 ; anim flags
	db $38 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_46
	db SPRITE_DUEL_32 ; sprite ID
	db $45 ; palette ID
	db $85 ; anim ID
	db $00 ; anim flags
	db $39 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_47
	db SPRITE_DUEL_33 ; sprite ID
	db $46 ; palette ID
	db $86 ; anim ID
	db $00 ; anim flags
	db $3a ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_48
	db SPRITE_DUEL_34 ; sprite ID
	db $47 ; palette ID
	db $87 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_5) | (1 << SPRITE_ANIM_FLAG_X_SUBTRACT) ; anim flags
	db $3b ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_49
	db SPRITE_DUEL_35 ; sprite ID
	db $48 ; palette ID
	db $88 ; anim ID
	db $00 ; anim flags
	db $3c ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_50
	db SPRITE_DUEL_66 ; sprite ID
	db $49 ; palette ID
	db $89 ; anim ID
	db $00 ; anim flags
	db $3d ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_51
	db SPRITE_DUEL_36 ; sprite ID
	db $4a ; palette ID
	db $8a ; anim ID
	db $00 ; anim flags
	db $3e ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_52
	db SPRITE_DUEL_37 ; sprite ID
	db $4b ; palette ID
	db $8b ; anim ID
	db $00 ; anim flags
	db $3f ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_53
	db SPRITE_DUEL_57 ; sprite ID
	db $4c ; palette ID
	db $8c ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $40 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_54
	db SPRITE_DUEL_38 ; sprite ID
	db $4d ; palette ID
	db $8d ; anim ID
	db $00 ; anim flags
	db $41 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_55
	db SPRITE_DUEL_39 ; sprite ID
	db $4e ; palette ID
	db $8e ; anim ID
	db $00 ; anim flags
	db $42 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_56
	db SPRITE_DUEL_40 ; sprite ID
	db $4f ; palette ID
	db $8f ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $43 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_57
	db SPRITE_DUEL_41 ; sprite ID
	db $50 ; palette ID
	db $90 ; anim ID
	db $00 ; anim flags
	db $44 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_58
	db SPRITE_DUEL_42 ; sprite ID
	db $51 ; palette ID
	db $92 ; anim ID
	db $00 ; anim flags
	db $45 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_59
	db SPRITE_DUEL_43 ; sprite ID
	db $52 ; palette ID
	db $93 ; anim ID
	db $00 ; anim flags
	db $46 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_60
	db SPRITE_DUEL_44 ; sprite ID
	db $53 ; palette ID
	db $94 ; anim ID
	db $00 ; anim flags
	db $47 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_61
	db SPRITE_DUEL_44 ; sprite ID
	db $53 ; palette ID
	db $95 ; anim ID
	db $00 ; anim flags
	db $48 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_HEAL
	db SPRITE_DUEL_60 ; sprite ID
	db $54 ; palette ID
	db $97 ; anim ID
	db $00 ; anim flags
	db $49 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_63
	db SPRITE_DUEL_64 ; sprite ID
	db $55 ; palette ID
	db $99 ; anim ID
	db $00 ; anim flags
	db $4a ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_64
	db SPRITE_DUEL_29 ; sprite ID
	db $56 ; palette ID
	db $81 ; anim ID
	db $00 ; anim flags
	db $4b ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_65
	db SPRITE_DUEL_44 ; sprite ID
	db $53 ; palette ID
	db $96 ; anim ID
	db $00 ; anim flags
	db $47 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_66
	db SPRITE_DUEL_3 ; sprite ID
	db $24 ; palette ID
	db $4d ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db $16 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_67
	db SPRITE_DUEL_3 ; sprite ID
	db $24 ; palette ID
	db $4e ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db $17 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_68
	db SPRITE_DUEL_5 ; sprite ID
	db $26 ; palette ID
	db $5c ; anim ID
	db $00 ; anim flags
	db $18 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_69
	db SPRITE_DUEL_62 ; sprite ID
	db $31 ; palette ID
	db $6d ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $24 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_70
	db SPRITE_DUEL_45 ; sprite ID
	db $57 ; palette ID
	db $9a ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) ; anim flags
	db $11 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_71
	db SPRITE_DUEL_10 ; sprite ID
	db $2c ; palette ID
	db $65 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $5c ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_72
	db SPRITE_DUEL_10 ; sprite ID
	db $2c ; palette ID
	db $66 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $00 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_73
	db SPRITE_DUEL_60 ; sprite ID
	db $54 ; palette ID
	db $98 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $4c ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_74
	db SPRITE_DUEL_41 ; sprite ID
	db $50 ; palette ID
	db $91 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $4d ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_75
	db SPRITE_DUEL_46 ; sprite ID
	db $58 ; palette ID
	db $9b ; anim ID
	db $00 ; anim flags
	db $4e ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_76
	db SPRITE_DUEL_47 ; sprite ID
	db $59 ; palette ID
	db $9c ; anim ID
	db $00 ; anim flags
	db $4f ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_77
	db SPRITE_DUEL_48 ; sprite ID
	db $5a ; palette ID
	db $9d ; anim ID
	db $00 ; anim flags
	db $50 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_78
	db SPRITE_DUEL_10 ; sprite ID
	db $2c ; palette ID
	db $67 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $51 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_79
	db SPRITE_DUEL_10 ; sprite ID
	db $2c ; palette ID
	db $68 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $51 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_80
	db SPRITE_DUEL_49 ; sprite ID
	db $5b ; palette ID
	db $9e ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $00 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_PLAYER_SHUFFLE
	db SPRITE_DUEL_49 ; sprite ID
	db $5b ; palette ID
	db $9f ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $07 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_OPP_SHUFFLE
	db SPRITE_DUEL_49 ; sprite ID
	db $5b ; palette ID
	db $a0 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $07 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_BOTH_SHUFFLE
	db SPRITE_DUEL_49 ; sprite ID
	db $5b ; palette ID
	db $a1 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $07 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_84
	db SPRITE_DUEL_49 ; sprite ID
	db $5b ; palette ID
	db $a2 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $00 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_BOTH_DRAW
	db SPRITE_DUEL_49 ; sprite ID
	db $5b ; palette ID
	db $a3 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $00 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_PLAYER_DRAW
	db SPRITE_DUEL_49 ; sprite ID
	db $5b ; palette ID
	db $a4 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $00 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_OPP_DRAW
	db SPRITE_DUEL_49 ; sprite ID
	db $5b ; palette ID
	db $a5 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $00 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_COIN_SPIN
	db SPRITE_DUEL_50 ; sprite ID
	db $5c ; palette ID
	db $a7 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $00 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_COIN_TOSS1
	db SPRITE_DUEL_50 ; sprite ID
	db $5c ; palette ID
	db $a8 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $0b ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_COIN_TOSS2
	db SPRITE_DUEL_50 ; sprite ID
	db $5c ; palette ID
	db $a9 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_3) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $0b ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_COIN_TAILS
	db SPRITE_DUEL_50 ; sprite ID
	db $5c ; palette ID
	db $aa ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $00 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_COIN_HEADS
	db SPRITE_DUEL_50 ; sprite ID
	db $5c ; palette ID
	db $ab ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $00 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_DUEL_WIN
	db SPRITE_DUEL_WON_LOST_DRAW ; sprite ID
	db $5d ; palette ID
	db $ac ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $00 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_DUEL_LOSS
	db SPRITE_DUEL_WON_LOST_DRAW ; sprite ID
	db $5d ; palette ID
	db $ad ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $00 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_DUEL_DRAW
	db SPRITE_DUEL_WON_LOST_DRAW ; sprite ID
	db $5d ; palette ID
	db $ae ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $00 ; sound FX ID
	db $00 ; handler function

	; DUEL_ANIM_96
	db SPRITE_DUEL_49 ; sprite ID
	db $5b ; palette ID
	db $a6 ; anim ID
	db (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE) | (1 << SPRITE_ANIM_FLAG_SPEED) ; anim flags
	db $00 ; sound FX ID
	db $00 ; handler function
; 0x1d078

Func_1d078: ; 1d078 (7:5078)
	ld a, [wd627]
	or a
	jr z, .asm_1d0c7
.asm_1d07e
	ld a, MUSIC_STOP
	call PlaySong
	call Func_3ca0
	call $5335
	call $53ce
	xor a
	ld [wd635], a
	ld a, $3c
	ld [wd626], a
.asm_1d095
	call DoFrameIfLCDEnabled
	call UpdateRNGSources
	call $5614
	ld hl, wd635
	inc [hl]
	call AssertSongFinished
	or a
	jr nz, .asm_1d0ae
	farcall Func_10ab4
	jr .asm_1d07e
.asm_1d0ae
	ld hl, wd626
	ld a, [hl]
	or a
	jr z, .asm_1d0b8
	dec [hl]
	jr .asm_1d095
.asm_1d0b8
	ldh a, [hKeysPressed]
	and A_BUTTON | START
	jr z, .asm_1d095
	ld a, SFX_02
	call PlaySFX
	farcall Func_10ab4

.asm_1d0c7
	call $50fa
	call $511c
	ld a, [wd628]
	cp $2
	jr nz, .asm_1d0db
	call $5289
	jr c, Func_1d078
	jr .asm_1d0e7
.asm_1d0db
	ld a, [wd628]
	cp $1
	jr nz, .asm_1d0e7
	call $52b8
	jr c, Func_1d078
.asm_1d0e7
	ld a, [wd628]
	cp $0
	jr nz, .asm_1d0f3
	call $52dd
	jr c, Func_1d078
.asm_1d0f3
	call ResetDoFrameFunction
	call Func_3ca0
	ret
; 0x1d0fa

	INCROM $1d0fa, $1d11c

Func_1d11c: ; 1d11c (7:511c)
	ld a, MUSIC_PC_MAIN_MENU
	call PlaySong
	call DisableLCD
	farcall $4, $4000
	lb de, $30, $8f
	call SetupText
	call Func_3ca0
	xor a
	ld [wLineSeparation], a
	call $51e1
	call $517f
	ld a, $ff
	ld [wd626], a
	ld a, [wd627]
	cp $4
	jr c, .asm_1d14f
	ld a, [wd624]
	or a
	jr z, .asm_1d14f
	ld a, $1
.asm_1d14f
	ld hl, wd636
	farcall Func_111e9
	farcall $4, $4031
.asm_1d15a
	call DoFrameIfLCDEnabled
	call UpdateRNGSources
	call HandleMenuInput
	push af
	call $51e9
	pop af
	jr nc, .asm_1d15a
	ldh a, [hCurMenuItem]
	cp e
	jr nz, .asm_1d15a
	ld [wd627], a
	ld a, [wd624]
	or a
	jr nz, .asm_1d17a
	inc e
	inc e
.asm_1d17a
	ld a, e
	ld [wd628], a
	ret
; 0x1d17f

	INCROM $1d17f, $1d306

Func_1d306: ; 1d306 (7:5306)
	INCROM $1d306, $1d386

Titlescreen_1d386: ; 1d386 (7:5386)
	call AssertSongFinished
	or a
	jr nz, .asm_1d39f
	call DisableLCD
	ld a, MUSIC_TITLESCREEN
	call PlaySong
	ld bc, $0000
	ld a, $0
	call Func_3df3
	call Func_1d59c
.asm_1d39f
	call Func_3ca0
	call Func_1d3a9
	call EnableLCD
	ret

Func_1d3a9: ; 1d3a9 (7:53a9)
	INCROM $1d3a9, $1d42e

Func_1d42e: ; 1d42e (7:542e)
	INCROM $1d42e, $1d519

Titlescreen_1d519: ; 1d519 (7:5519)
	ld a, MUSIC_TITLESCREEN
	call PlaySong
	call Func_1d42e
	scf
	ret
; 0x1d523

	INCROM $1d523, $1d59c

Func_1d59c: ; 1d59c (7:559c)
	INCROM $1d59c, $1d6ad

Credits_1d6ad: ; 1d6ad (7:56ad)
	ld a, MUSIC_STOP
	call PlaySong
	call $5705
	call $4858
	xor a
	ld [wd324], a
	ld a, MUSIC_CREDITS
	call PlaySong
	farcall $4, $4031
	call $57fc
.asm_1d6c8
	call DoFrameIfLCDEnabled
	call $5765
	call $580b
	ld a, [wd633]
	cp $ff
	jr nz, .asm_1d6c8
	call WaitForSongToFinish
	ld a, $8
	farcall $4, $6863
	ld a, MUSIC_STOP
	call PlaySong
	farcall Func_10ab4
	call Func_3ca4
	call Set_WD_off
	call $5758
	call EnableLCD
	call DoFrameIfLCDEnabled
	call DisableLCD
	ld hl, wLCDC
	set 1, [hl]
	call ResetDoFrameFunction
	ret
; 0x1d705

	INCROM $1d705, $1e1c4
