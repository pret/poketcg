SetupSound: ; 377f (0:377f)
	farcall _SetupSound
	ret

StopMusic: ; 3784 (0:3784)
	xor a ; MUSIC_STOP
PlaySong: ; 3785 (0:3785)
	farcall _PlaySong
	ret

; return a = 0: song finished, a = 1: song not finished
AssertSongFinished: ; 378a (0:378a)
	farcall _AssertSongFinished
	ret

; return a = 0: SFX finished, a = 1: SFX not finished
AssertSFXFinished: ; 378f (0:378f)
	farcall _AssertSFXFinished
	ret

Func_3794: ; 3794 (0:3794)
	ld a, $04
PlaySFX: ; 3796 (0:3796)
	farcall _PlaySFX
	ret

PauseSong: ; 379b (0:379b)
	farcall _PauseSong
	ret

ResumeSong: ; 37a0 (0:37a0)
	farcall _ResumeSong
	ret

Func_37a5: ; 37a5 (0:37a5)
	ldh a, [hBankROM]
	push af
	push hl
	srl h
	srl h
	srl h
	ld a, BANK(CardGraphics)
	add h
	call BankswitchROM
	pop hl
	add hl, hl
	add hl, hl
	add hl, hl
	res 7, h
	set 6, h ; $4000 ≤ hl ≤ $7fff
	call Func_37c5
	pop af
	call BankswitchROM
	ret

Func_37c5: ; 37c5 (0:37c5)
	ld c, $08
.asm_37c7
	ld b, $06
.asm_37c9
	push bc
	ld c, $08
.asm_37cc
	ld b, $02
.asm_37ce
	push bc
	push hl
	ld c, [hl]
	ld b, $04
.asm_37d3
	rr c
	rra
	sra a
	dec b
	jr nz, .asm_37d3
	ld hl, $c0
	add hl, de
	ld [hli], a
	inc hl
	ld [hl], a
	ld b, $04
.asm_37e4
	rr c
	rra
	sra a
	dec b
	jr nz, .asm_37e4
	ld [de], a
	ld hl, $2
	add hl, de
	ld [hl], a
	pop hl
	pop bc
	inc de
	inc hl
	dec b
	jr nz, .asm_37ce
	inc de
	inc de
	dec c
	jr nz, .asm_37cc
	pop bc
	dec b
	jr nz, .asm_37c9
	ld a, $c0
	add e
	ld e, a
	ld a, $00
	adc d
	ld d, a
	dec c
	jr nz, .asm_37c7
	ret
