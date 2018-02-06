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
	ld [wd0bb], a
	ld a, [hli]
	ld [wd0bc], a
	ld a, [hli]
	ld [wd0bd], a
	ld a, [wd334]
	ld [wd0be], a
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
	ld hl, MapSongs
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

INCLUDE "data/map_songs.asm"

Func_1c440: ; 1c440 (7:4440)
	INCROM $1c440, $1c455

Func_1c455: ; 1c455 (7:4455)
	push hl
	ld a, [wd3aa]
	ld l, $4
	call Func_39ad
	ld a, [hl]
	pop hl
	ret

Func_1c461: ; 1c461 (7:4461)
	push hl
	push bc
	call Func_1c719
	ld a, [wd3aa]
	ld l, $2
	call Func_39ad
	ld a, b
	ld [hli], a
	ld [hl], c
	call $46e3
	pop bc
	pop hl
	ret

Func_1c477: ; 1c477 (7:4477)
	push hl
	ld a, [wd3aa]
	ld l, $2
	call Func_39ad
	ld a, [hli]
	ld b, a
	ld c, [hl]
	pop hl
	ret

Func_1c485: ; 1c485 (7:4485)
	INCROM $1c485, $1c50a

Func_1c50a: ; 1c50a (7:450a)
	push hl
	call Func_1c719
	ld a, [wd3aa]
	call $39a7
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
	farcallx $4, $69fd
	ld hl, $d349
	dec [hl]

.asm_1c52c
	pop hl
	ret

Func_1c52e: ; 1c52e (7:452e)
	push hl
	push af
	ld a, [wd3aa]
	ld l, $7
	call Func_39ad
	pop af
	ld [hl], a
	call Func_1c5e9
	pop hl
	ret

Func_1c53f: ; 1c53f (7:453f)
	push hl
	push bc
	ld a, [wd3aa]
	ld l, $4
	call Func_39ad
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
	ld a, [wd3aa]
	push af
	ld a, [wd3ab]
	push af
	ld a, c
	ld [wd3ab], a
	ld c, $0
	call Func_39c3
	jr c, .asm_1c570
	call Func_1c53f
	ld c, a

.asm_1c570
	pop af
	ld [wd3ab], a
	pop af
	ld [wd3aa], a
	ld a, c
	pop bc
	ret

Func_1c57b: ; 1c57b (7:457b)
	push hl
	push bc
	push af
	ld a, [wd3aa]
	ld l, $6
	call Func_39ad
	pop af
	ld [hl], a
	call Func_1c58e
	pop bc
	pop hl
	ret

Func_1c58e: ; 1c58e (7:458e)
	INCROM $1c58e, $1c5e9

Func_1c5e9: ; 1c5e9 (7:45e9)
	INCROM $1c5e9, $1c610

Func_1c610: ; 1c610 (7:4610)
	INCROM $1c610, $1c6f8

Func_1c6f8: ; 1c6f8 (7:46f8)
	INCROM $1c6f8, $1c719

Func_1c719: ; 1c719 (7:4719)
	push hl
	push bc
	ld a, [wd3aa]
	ld l, $2
	call Func_39ad
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld a, $40
	call $3937
	pop bc
	pop hl
	ret

Func_1c72e: ; 1c72e (7:472e)
	INCROM $1c72e, $1c768

Func_1c768: ; 1c768 (7:4768)
	push hl
	ld a, [wd3aa]
	ld l, $04
	call Func_39ad
	ld a, [wd334]
	xor $02
	ld [hl], a
	call Func_1c58e
	ld a, $02
	farcall Func_c29b
	ld a, [wd3aa]
	call $39a7
	ld a, [hl]
	farcall Func_1187d
	pop hl
	ret

Func_1c78d: ; 1c78d (7:478d)
	push hl
	ld a, [wd3aa]
	ld l, $5
	call Func_39ad
	set 5, [hl]
	ld a, [wd3aa]
	ld l, $8
	call Func_39ad
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
	ld a, [wd3aa]
	ld l, $5
	call Func_39ad
	res 5, [hl]

.asm_1c7dc
	pop hl
	ret

Func_1c7de: ; 1c7de (7:47de)
	ld a, [$d3b7]
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
	ld hl, $d3bb
.asm_1c845
	ld a, [hl]
	or a
	jr z, .asm_1c853
	cp b
	jr z, .asm_1c855
	inc hl
	dec c
	jr nz, .asm_1c845
	rst $38
	jr .asm_1c855

.asm_1c853
	ld a, b
	ld [hl], a

.asm_1c855
	pop bc
	pop hl
	ret
; 0x1c858

	INCROM $1c858, $1d078

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
	ld hl, $d635
	inc [hl]
	call Func_378a
	or a
	jr nz, .asm_1d0ae
	farcall Func_10ab4
	jr .asm_1d07e
.asm_1d0ae
	ld hl, $d626
	ld a, [hl]
	or a
	jr z, .asm_1d0b8
	dec [hl]
	jr .asm_1d095
.asm_1d0b8
	ldh a, [hButtonsPressed]
	and A_BUTTON | START
	jr z, .asm_1d095
	ld a, $2
	call Func_3796
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
	ld a, MUSIC_PCMAINMENU
	call PlaySong
	call DisableLCD
	farcallx $4, $4000
	ld de, $308f
	call Func_2275
	call Func_3ca0
	xor a
	ld [wcd08], a
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
	ld hl, $d636
	farcall Func_111e9
	farcallx $4, $4031
.asm_1d15a
	call DoFrameIfLCDEnabled
	call UpdateRNGSources
	call MenuCursorAcceptInput
	push af
	call $51e9
	pop af
	jr nc, .asm_1d15a
	ldh a, [hCurrentMenuItem]
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
	call Func_378a
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
	farcallx $4, $4031
	call $57fc
.asm_1d6c8
	call DoFrameIfLCDEnabled
	call $5765
	call $580b
	ld a, [wd633]
	cp $ff
	jr nz, .asm_1d6c8
	call Func_3c96
	ld a, $8
	farcallx $4, $6863
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
