	drom $1c000, $1c056

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
	ld [$d0bb], a
	ld a, [hli]
	ld [$d0bc], a
	ld a, [hli]
	ld [$d0bd], a
	ld a, [$d334]
	ld [$d0be], a
.asm_1c095
	pop de
	pop bc
	pop hl
	ret

INCLUDE "data/warp_data.asm"

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
	ld [$d131], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld [$d28f], a
	ld a, [hli]
	ld [$d132], a
	ld a, [hli]
	ld [$d290], a
	ld a, [hli]
	ld [$d111], a
	ld a, [$cab4]
	cp $2
	jr nz, .asm_1c370
	ld a, c
	or a
	jr z, .asm_1c370
	ld [$d131], a
.asm_1c370
	pop de
	pop bc
	pop hl
	ret

INCLUDE "data/map_songs.asm"

Func_1c440: ; 1c440 (7:4440)
	drom $1c440, $1c485

Func_1c485: ; 1c485 (7:4485)
	drom $1c485, $1c58e

Func_1c58e: ; 1c58e (7:458e)
	drom $1c58e, $1c5e9

Func_1c5e9: ; 1c5e9 (7:45e9)
	drom $1c5e9, $1c610

Func_1c610: ; 1c610 (7:4610)
	drom $1c610, $1c6f8

Func_1c6f8: ; 1c6f8 (7:46f8)
	drom $1c6f8, $1c72e

Func_1c72e: ; 1c72e (7:472e)
	drom $1c72e, $1c768

Func_1c768: ; 1c768 (7:4768)
	drom $1c768, $1c82e

Func_1c82e: ; 1c82e (7:482e)
	drom $1c82e, $1d078

Func_1d078: ; 1d078 (7:5078)
	ld a, [$d627]
	or a
	jr z, .asm_1d0c7
.asm_1d07e
	ld a, MUSIC_STOP
	call PlaySong
	call Func_3ca0
	call $5335
	call $53ce
	xor a
	ld [$d635], a
	ld a, $3c
	ld [$d626], a
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
	ld a, [$d628]
	cp $2
	jr nz, .asm_1d0db
	call $5289
	jr c, Func_1d078
	jr .asm_1d0e7
.asm_1d0db
	ld a, [$d628]
	cp $1
	jr nz, .asm_1d0e7
	call $52b8
	jr c, Func_1d078
.asm_1d0e7
	ld a, [$d628]
	cp $0
	jr nz, .asm_1d0f3
	call $52dd
	jr c, Func_1d078
.asm_1d0f3
	call ResetDoFrameFunction
	call Func_3ca0
	ret
; 0x1d0fa

	drom $1d0fa, $1d11c

Func_1d11c: ; 1d11c (7:511c)
	ld a, MUSIC_PCMAINMENU
	call PlaySong
	call DisableLCD
	farcallx $4, $4000
	ld de, $308f
	call Func_2275
	call Func_3ca0
	xor a
	ld [$cd08], a
	call $51e1
	call $517f
	ld a, $ff
	ld [$d626], a
	ld a, [$d627]
	cp $4
	jr c, .asm_1d14f
	ld a, [$d624]
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
	ld [$d627], a
	ld a, [$d624]
	or a
	jr nz, .asm_1d17a
	inc e
	inc e
.asm_1d17a
	ld a, e
	ld [$d628], a
	ret
; 0x1d17f

	drom $1d17f, $1d306

Func_1d306: ; 1d306 (7:5306)
	drom $1d306, $1d386

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
	drom $1d3a9, $1d42e

Func_1d42e: ; 1d42e (7:542e)
	drom $1d42e, $1d519

Titlescreen_1d519: ; 1d519 (7:5519)
	ld a, MUSIC_TITLESCREEN
	call PlaySong
	call Func_1d42e
	scf
	ret
; 0x1d523

	drom $1d523, $1d59c

Func_1d59c: ; 1d59c (7:559c)
	drom $1d59c, $1d6ad

Credits_1d6ad: ; 1d6ad (7:56ad)
	ld a, MUSIC_STOP
	call PlaySong
	call $5705
	call $4858
	xor a
	ld [$d324], a
	ld a, MUSIC_CREDITS
	call PlaySong
	farcallx $4, $4031
	call $57fc
.asm_1d6c8
	call DoFrameIfLCDEnabled
	call $5765
	call $580b
	ld a, [$d633]
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
	ld hl, $cabb
	set 1, [hl]
	call ResetDoFrameFunction
	ret
; 0x1d705

	drom $1d705, $20000
