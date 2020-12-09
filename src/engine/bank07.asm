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
	ld a, [wd3b3]
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

	INCROM $1c858, $1c8ef

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
	jp nc, $4b5e ; asm_007_4b5e
	push hl
	push bc
	push de
	call Func_1cab3
; hl: pointer
	ld a, [wd421]
	or a
	jr z, .check_to_play_sfx

	push hl
	ld bc, $0003
	add hl, bc
	ld a, [hl]
	and %10000000
	pop hl

	jr z, .return
.check_to_play_sfx
	push hl
	ld bc, $0004
	add hl, bc
	ld a, [hl]
	pop hl

	or a
	jr z, .calc_addr
	call PlaySFX
.calc_addr
	push hl
	ld bc, $0005
	add hl, bc
	ld a, [hl]
	rlca
	add $48
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
	dw Func_1c94a

Func_1c94a:
	ld e, l
	ld d, h
	ld c, 3
.loop
	ld a, [de]
	or a
	jr z, .return_with_carry
	inc de
	dec c
	jr nz, .loop
	ld a, [hli]
	farcall CreateSpriteAndAnimBufferEntry
	ld a, [wWhichSprite]
	ld [wAnimationQueue], a ; push an animation to the queue
	xor a
	ld [wd4ca], a
	ld [wd4cb], a
	ld a, [hli]
	farcall $20, $4418
	ld a, [hli]

	push af
	ld a, [hli]
	ld [wd42b], a
	call Func_1c980
	pop af

	farcall StartNewSpriteAnimation
	or a
	jr .return

.return_with_carry
	scf
.return
	ret

Func_1c980: ; 1c980 (7:4980)
	push hl
	push bc
	ld a, [wAnimationQueue]
	ld c, SPRITE_ANIM_ATTRIBUTES
	call GetSpriteAnimBufferProperty_SpriteInA
	call Func_1c9a2

	push af
	and %01100000
	or [hl]
	ld [hli], a
	ld a, b
	ld [hli], a
	ld [hl], c
	pop af

	ld bc, $000c
	add hl, bc
	ld c, a
	and %00000011
	or [hl]
	ld [hl], a
	pop bc
	pop hl
	ret

Func_1c9a2: ; 1c9a2 (7:49a2)
	push hl
	ld c, 0
	ld a, [wd42b]
	and %00000100
	jr nz, .calc_addr

	ld a, [wd4ae]
	add a
	ld c, a
	add a
	add c
	add a
	ld c, a
	ld a, [wd4af]
	cp PLAYER_TURN
	jr z, .player_turn

	ld a, $06
	add c
	ld c, a
.player_turn
	ld a, [wd4b0]
	add c ; a = [wd4b0] + c
	ld c, a
	ld b, 0
	ld hl, Data_1c9e0
	add hl, bc
	ld c, [hl]
.calc_addr
	ld a, c
	add a ; a = c * 2
	add c ; a = c * 3
	ld c, a
	ld b, 0
	ld hl, Data_1ca04
	add hl, bc
	ld b, [hl]
	inc hl
	ld c, [hl]
	inc hl
	ld a, [wd42b]
	and [hl]
	pop hl
	ret

Data_1c9e0:
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $02
	db $02
	db $02
	db $02
	db $02
	db $02
	db $03
	db $04
	db $05
	db $06
	db $07
	db $08
	db $03
	db $04
	db $05
	db $06
	db $07
	db $08
	db $09
	db $0a
	db $0b
	db $0c
	db $0d
	db $0e
	db $09
	db $0a
	db $0b
	db $0c
	db $0d
	db $0e

macro_1ca04: MACRO
	dw \1
	db \2
ENDM
Data_1ca04:
; value(2), flag(1)
	macro_1ca04 $5858, $08
	macro_1ca04 $5028, $00
	macro_1ca04 $3088, $63
	macro_1ca04 $4858, $00
	macro_1ca04 $6018, $00
	macro_1ca04 $6038, $00
	macro_1ca04 $6058, $00
	macro_1ca04 $6078, $00
	macro_1ca04 $6098, $00
	macro_1ca04 $5058, $00
	macro_1ca04 $2898, $00
	macro_1ca04 $2878, $00
	macro_1ca04 $2858, $00
	macro_1ca04 $2838, $00
	macro_1ca04 $2818, $00

Func_1ca31:
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
	ld b, 0
	ld hl, $d42c
	add hl, bc
	ld a, [wTempAnimation]
	ld [hli], a
	ld a, [wd4ae]
	ld [hli], a
	ld a, [wd4af]
	ld [hli], a
	ld a, [wd4b0]
	ld [hli], a
	ld a, [$d4b1]
	ld [hli], a
	ld a, [$d4b2]
	ld [hli], a
	ld a, [$d4b3]
	ld [hli], a
	ld a, [wd4be]
	ld [hl], a
.asm_007_4a6b
	pop bc
	pop hl
	ret

	INCROM $1ca6e, $1cab3

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
	ld bc, $4e32
	add hl, bc
	pop bc
	ret

	INCROM $1cac5, $1cb18

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

	INCROM $1cb5e, $1d078

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
