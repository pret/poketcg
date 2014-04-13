; rst vectors
SECTION "rst00",ROM0[0]
	ret
SECTION "rst08",ROM0[8]
	ret
SECTION "rst10",ROM0[$10]
	ret
SECTION "rst18",ROM0[$18]
	jp RST18
SECTION "rst20",ROM0[$20]
	jp RST20
SECTION "rst28",ROM0[$28]
	jp RST28
SECTION "rst30",ROM0[$30]
	ret
SECTION "rst38",ROM0[$38]
	ret

; interrupts
SECTION "vblank",ROM0[$40]
	jp VBlankHandler
SECTION "lcdc",ROM0[$48]
	call $cacd
	reti
SECTION "timer",ROM0[$50]
	jp TimerHandler
SECTION "serial",ROM0[$58]
	jp SerialHandler
SECTION "joypad",ROM0[$60]
	reti

SECTION "romheader",ROM0[$100]
	nop
	jp Start

SECTION "start",ROM0[$150]
Start: ; 0150 (0:0150)
	di
	ld sp, $fffe
	push af
	xor a
	ld [$ff0f], a
	ld [$ffff], a
	call Func_03ec
	ld a, $1
	call BankswitchHome
	xor a
	call Func_07a9
	call Func_07c5
	call Func_028a
	pop af
	ld [$cab3], a
	call Func_0349
	ld a, $20
	ld [$cab6], a
	call Func_03a1
	call Func_030b
	call Func_036a
	call Func_377f
	call Func_0241
	call Func_0ea6
	call Func_0593
	call Func_080b
	ld a, $1
	call BankswitchHome
	ld sp, $e000
	jp $4000

VBlankHandler: ; 019b (0:019b)
	push af
	push bc
	push de
	push hl
	ld a, [$ff80]
	push af
	ld hl, $caba
	bit 0, [hl]
	jr nz, .asm_1dd
	set 0, [hl]
	ld a, [$cac0]
	or a
	jr z, .asm_1b8
	call $ff83
	xor a
	ld [$cac0], a
.asm_1b8
	ld a, [$ff92]
	ld [$ff43], a
	ld a, [$ff93]
	ld [$ff42], a
	ld a, [$ff94]
	ld [$ff4b], a
	ld a, [$ff95]
	ld [$ff4a], a
	ld a, [$cabb]
	ld [$ff40], a
	ei
	call $cad0
	call Func_042d
	ld hl, $cab8
	inc [hl]
	ld hl, $caba
	res 0, [hl]
.asm_1dd
	pop af
	call BankswitchHome
	pop hl
	pop de
	pop bc
	pop af
	reti

TimerHandler: ; 01e6 (0:01e6)
	push af
	push hl
	push de
	push bc
	ei
	call Func_0c91
	ld hl, $cac3
	ld a, [hl]
	inc [hl]
	and $3
	jr nz, .asm_217
	call Func_021c
	ld hl, $caba
	bit 1, [hl]
	jr nz, .asm_217
	set 1, [hl]
	ld a, [$ff80]
	push af
	ld a, BANK(Func_f4003)
	call BankswitchHome
	call Func_f4003
	pop af
	call BankswitchHome
	ld hl, $caba
	res 1, [hl]
.asm_217
	pop bc
	pop de
	pop hl
	pop af
	reti

Func_021c: ; 021c (0:021c)
	ld a, [$cac4]
	or a
	ret z
	ld hl, $cac5
	inc [hl]
	ld a, [hl]
	cp $3c
	ret c
	ld [hl], $0
	inc hl
	inc [hl]
	ld a, [hl]
	cp $3c
	ret c
	ld [hl], $0
	inc hl
	inc [hl]
	ld a, [hl]
	cp $3c
	ret c
	ld [hl], $0
	inc hl
	inc [hl]
	ret nz
	inc hl
	inc [hl]
	ret

Func_0241: ; 0241 (0:0241)
	ld b, $bc
	call Func_025c
	jr c, .asm_250
	ld a, [$ff4d]
	and $80
	jr z, .asm_250
	ld b, $78
.asm_250
	ld a, b
	ld [$ff06], a
	ld a, $3
	ld [$ff07], a
	ld a, $7
	ld [$ff07], a
	ret

Func_025c: ; 025c (0:025c)
	ld a, [$cab4]
	cp $2
	ret z
	scf
	ret
; 0x264

INCBIN "baserom.gbc",$0264,$028a - $0264

Func_028a: ; 028a (0:028a)
	ld a, [$ff40]
	bit 7, a
	ret z
	ld a, [$ffff]
	ld [$cab7], a
	res 0, a
	ld [$ffff], a
.asm_298
	ld a, [$ff44]
	cp $91
	jr nz, .asm_298
	ld a, [$ff40]
	and $7f
	ld [$ff40], a
	ld a, [$cabb]
	and $7f
	ld [$cabb], a
	xor a
	ld [$ff47], a
	ld [$ff48], a
	ld [$ff49], a
	ld a, [$cab7]
	ld [$ffff], a
	ret
; 0x2b9

INCBIN "baserom.gbc",$02b9,$030b - $02b9

Func_030b: ; 030b (0:030b)
	xor a
	ld [$ff42], a
	ld [$ff43], a
	ld [$ff4a], a
	ld [$ff4b], a
	ld [$cab0], a
	ld [$cab1], a
	ld [$cab2], a
	ld [$ff92], a
	ld [$ff93], a
	ld [$ff94], a
	ld [$ff95], a
	xor a
	ld [$caba], a
	ld a, $c3
	ld [$cacd], a
	ld [$cad0], a
	ld hl, $cad1
	ld [hl], Func_0348 & $ff 
	inc hl
	ld [hl], Func_0348 >> $8
	ld a, $47
	ld [$cabb], a
	ld a, $1
	ld [$6000], a
	ld a, $a
	ld [$0000], a
Func_0348: ; 0348 (0:0348)
	ret

Func_0349: ; 0349 (0:0349)
	ld b, $2
	cp $11
	jr z, .asm_35b
	call Func_0b59
	ld b, $0
	jr nc, .asm_35b
	call Func_0a0d
	ld b, $1
.asm_35b
	ld a, b
	ld [$cab4], a
	cp $2
	ret nz
	ld a, $1
	ld [$ff70], a
	call Func_07e7
	ret

Func_036a: ; 036a (0:036a)
	ld hl, $cabc
	ld a, $e4
	ld [$ff47], a
	ld [hli], a
	ld [$ff48], a
	ld [$ff49], a
	ld [hli], a
	ld [hl], a
	xor a
	ld [$cabf], a
	ld a, [$cab4]
	cp $2
	ret nz
	ld de, $caf0
	ld c, $10
.asm_387
	ld hl, InitialPalette
	ld b, $8
.asm_38c
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_38c
	dec c
	jr nz, .asm_387
	call Func_0458
	ret

InitialPalette: ; 0399 (0:0399)
	RGB 28,28,24
	RGB 21,21,16
	RGB 10,10,08
	RGB 00,00,00

Func_03a1: ; 03a1 (0:03a1)
	call Func_03c0
	call Func_025c
	jr c, .asm_3b2
	call Func_07cd
	call .asm_3b2
	call Func_07c5
.asm_3b2
	ld hl, $8000
	ld bc, $1800
.asm_3b8
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .asm_3b8
	ret

Func_03c0: ; 03c0 (0:03c0)
	call Func_07c5
	ld hl, $9800
	ld bc, $0400
.asm_3c9
	ld a, [$cab6]
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .asm_3c9
	ld a, [$cab4]
	cp $2
	ret nz
	call Func_07cd
	ld hl, $9800
	ld bc, $0400
.asm_3e1
	xor a
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .asm_3e1
	call Func_07c5
	ret

Func_03ec: ; 03ec (0:03ec)
	ld hl, $c000
	ld bc, $2000
.asm_3f2
	xor a
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .asm_3f2
	ld c, $80
	ld b, $70
	xor a
.asm_3fe
	ld [$ff00+c], a
	inc c
	dec b
	jr nz, .asm_3fe
	ret
; 0x404

INCBIN "baserom.gbc",$0404,$042d - $0404

Func_042d: ; 042d (0:042d)
	ld a, [$cabf]
	or a
	ret z
	ld hl, $cabc
	ld a, [hli]
	ld [$ff47], a
	ld a, [hli]
	ld [$ff48], a
	ld a, [hl]
	ld [$ff49], a
	ld a, [$cab4]
	cp $2
	jr z, asm_44a
asm_445
	xor a
	ld [$cabf], a
	ret
asm_44a
	ld a, [$cabf]
	bit 6, a
	jr nz, Func_0458
	ld b, $8
	call InitializePalettes
	jr asm_445

Func_0458: ; 0458 (0:0458)
	xor a
	ld b, $40
	call InitializePalettes
	ld a, $8
	ld b, $40
	call InitializePalettes
	jr asm_445

InitializePalettes: ; 0467 (0:0467)
	add a
	add a
	add a
	ld e, a
	ld d, $0
	ld hl, $caf0
	add hl, de
	ld c, $68
	bit 6, a
	jr z, .asm_479
	ld c, $6a
.asm_479
	and $bf
	ld e, a
.asm_47c
	ld a, e
	ld [$ff00+c], a
	inc c
.asm_47f
	ld a, [$ff41]
	and $2
	jr nz, .asm_47f
	ld a, [hl]
	ld [$ff00+c], a
	ld a, [$ff00+c]
	cp [hl]
	jr nz, .asm_47f
	inc hl
	dec c
	inc e
	dec b
	jr nz, .asm_47c
	ret
; 0x492

INCBIN "baserom.gbc",$0492,$0593 - $0492

Func_0593: ; 0593 (0:0593)
	ld c, $83
	ld b, $a
	ld hl, Func_05a1
.asm_59a
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	dec b
	jr nz, .asm_59a
	ret

; Func_0593 copies this function to $ff83 
Func_05a1: ; 05a1 (0:05a1)
	ld a, $ca
	ld [$ff46], a
	ld a, $28
.asm_5a7
	dec a
	jr nz, .asm_5a7
	ret

; jumps to index a in pointer table hl
JumpToFunctionInTable: ; 05ab (0:05ab)
	add a
	add l
	ld l, a
	ld a, $0
	adc h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 0x5b6

INCBIN "baserom.gbc",$05b6,$07a3 - $05b6

BankswitchHome: ; 07a3 (0:07a3)
	ld [$ff80], a
	ld [$2000], a
	ret

Func_07a9: ; 07a9 (0:07a9)
	push af
	ld [$ff81], a
	ld [$4000], a
	ld a, $a
	ld [$0000], a
	pop af
	ret

Func_07b6: ; 07b6 (0:07b6)
	push af
	ld a, $a
	ld [$0000], a
	pop af
	ret

Func_07be: ; 07be (0:07be)
	push af
	xor a
	ld [$0000], a
	pop af
	ret

Func_07c5: ; 07c5 (0:07c5)
	push af
	xor a
	ld [$ff82], a
	ld [$ff4f], a
	pop af
	ret

Func_07cd: ; 07cd (0:07cd)
	push af
	ld a, $1
	ld [$ff82], a
	ld [$ff4f], a
	pop af
	ret
; 0x7d6

INCBIN "baserom.gbc",$07d6,$07e7 - $07d6

Func_07e7: ; 07e7 (0:07e7)
	call Func_025c
	ret c
	ld hl, $ff4d
	bit 7, [hl]
	ret nz
	ld a, [$ffff]
	push af
	xor a
	ld [$ffff], a
	set 0, [hl]
	xor a
	ld [$ff0f], a
	ld [$ffff], a
	ld a, $30
	ld [$ff00], a
	stop
	call Func_0241
	pop af
	ld [$ffff], a
	ret

Func_080b: ; 080b (0:080b)
	xor a
	call Func_07a9
	ld hl, $a000
	ld bc, $1000
.asm_815
	ld a, [hli]
	cp $41
	jr nz, .asm_82f
	ld a, [hli]
	cp $93
	jr nz, .asm_82f
	dec bc
	ld a, c
	or b
	jr nz, .asm_815
	call Func_084d
	scf
	call $4050
	call Func_07be
	ret
.asm_82f
	ld hl, $a000
	ld a, [hli]
	cp $4
	jr nz, .asm_842
	ld a, [hli]
	cp $21
	jr nz, .asm_842
	ld a, [hl]
	cp $5
	jr nz, .asm_842
	ret
.asm_842
	call Func_084d
	or a
	call $4050
	call Func_07be
	ret

Func_084d: ; 084d (0:084d)
	ld a, $3
.asm_84f
	call Func_0863
	dec a
	cp $ff
	jr nz, .asm_84f
	ld hl, $a000
	ld [hl], $4
	inc hl
	ld [hl], $21
	inc hl
	ld [hl], $5
	ret

Func_0863: ; 0863 (0:0863)
	push af
	call Func_07a9
	call Func_07b6
	ld hl, $a000
	ld bc, $2000
.asm_870
	xor a
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .asm_870
	pop af
	ret
; 0x879

INCBIN "baserom.gbc",$0879,$09ae - $0879

RST18: ; 09ae (0:09ae)
	push hl
	push hl
	push hl
	push hl
	push de
	push af
	ld hl, [sp+$d]
	ld d, [hl]
	dec hl
	ld e, [hl]
	dec hl
	ld [hl], $0
	dec hl
	ld a, [$ff80]
	ld [hld], a
	ld [hl], $9
	dec hl
	ld [hl], $dc
	dec hl
	inc de
	ld a, [de]
	ld [hld], a
	dec de
	ld a, [de]
	ld [hl], a
	ld a, $1
	; fallthrough
Func_09ce: ; 09ce (0:09ce)
	call BankswitchHome
	ld hl, [sp+$d]
	inc de
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	pop af
	pop de
	pop hl
	ret
; 0x9dc

INCBIN "baserom.gbc",$09dc,$09e9 - $09dc

RST28: ; 09e9 (0:09e9)
	push hl
	push hl
	push hl
	push hl
	push de
	push af
	ld hl, [sp+$d]
	ld d, [hl]
	dec hl
	ld e, [hl]
	dec hl
	ld [hl], $0
	dec hl
	ld a, [$ff80]
	ld [hld], a
	ld [hl], $9
	dec hl
	ld [hl], $dc
	dec hl
	inc de
	inc de
	ld a, [de]
	ld [hld], a
	dec de
	ld a, [de]
	ld [hl], a
	dec de
	ld a, [de]
	inc de
	jr Func_09ce

Func_0a0d: ; 0a0d (0:0a0d)
	ld hl, Unknown_0ad0
	call Func_0b20
	ld hl, Unknown_0a50
	call Func_0b20
	ld hl, Unknown_0a60
	call Func_0b20
	ld hl, Unknown_0a70
	call Func_0b20
	ld hl, Unknown_0a80
	call Func_0b20
	ld hl, Unknown_0a90
	call Func_0b20
	ld hl, Unknown_0aa0
	call Func_0b20
	ld hl, Unknown_0ab0
	call Func_0b20
	ld hl, Unknown_0ac0
	call Func_0b20
	ld hl, Unknown_0af0
	call Func_0b20
	ld hl, Unknown_0ae0
	call Func_0b20
	ret

Unknown_0a50: ; 0a50 (0:0a50)
INCBIN "baserom.gbc",$0a50,$0a60 - $0a50

Unknown_0a60: ; 0a60 (0:0a60)
INCBIN "baserom.gbc",$0a60,$0a70 - $0a60

Unknown_0a70: ; 0a70 (0:0a70)
INCBIN "baserom.gbc",$0a70,$0a80 - $0a70

Unknown_0a80: ; 0a80 (0:0a80)
INCBIN "baserom.gbc",$0a80,$0a90 - $0a80

Unknown_0a90: ; 0a90 (0:0a90)
INCBIN "baserom.gbc",$0a90,$0aa0 - $0a90

Unknown_0aa0: ; 0aa0 (0:0aa0)
INCBIN "baserom.gbc",$0aa0,$0ab0 - $0aa0

Unknown_0ab0: ; 0ab0 (0:0ab0)
INCBIN "baserom.gbc",$0ab0,$0ac0 - $0ab0

Unknown_0ac0: ; 0ac0 (0:0ac0)
INCBIN "baserom.gbc",$0ac0,$0ad0 - $0ac0

Unknown_0ad0: ; 0ad0 (0:0ad0)
INCBIN "baserom.gbc",$0ad0,$0ae0 - $0ad0

Unknown_0ae0: ; 0ae0 (0:0ae0)
INCBIN "baserom.gbc",$0ae0,$0af0 - $0ae0

Unknown_0af0: ; 0af0 (0:0af0)
INCBIN "baserom.gbc",$0af0,$0b20 - $0af0

Func_0b20: ; 0b20 (0:0b20)
	ld a, [hl]
	and $7
	ret z
	ld b, a
	ld c, $0
.asm_b27
	push bc
	ld a, $0
	ld [$ff00+c], a
	ld a, $30
	ld [$ff00+c], a
	ld b, $10
.asm_b30
	ld e, $8
	ld a, [hli]
	ld d, a
.asm_b34
	bit 0, d
	ld a, $10
	jr nz, .asm_b3c
	ld a, $20
.asm_b3c
	ld [$ff00+c], a
	ld a, $30
	ld [$ff00+c], a
	rr d
	dec e
	jr nz, .asm_b34
	dec b
	jr nz, .asm_b30
	ld a, $20
	ld [$ff00+c], a
	ld a, $30
	ld [$ff00+c], a
	pop bc
	dec b
	jr nz, .asm_b27
	ld bc, $0004
	call Wait
	ret

Func_0b59: ; 0b59 (0:0b59)
	ld bc, $003c
	call Wait
	ld hl, Unknown_0bbb
	call Func_0b20
	ld a, [$ff00]
	and $3
	cp $3
	jr nz, .asm_ba3
	ld a, $20
	ld [$ff00], a
	ld a, [$ff00]
	ld a, [$ff00]
	ld a, $30
	ld [$ff00], a
	ld a, $10
	ld [$ff00], a
	ld a, [$ff00]
	ld a, [$ff00]
	ld a, [$ff00]
	ld a, [$ff00]
	ld a, [$ff00]
	ld a, [$ff00]
	ld a, $30
	ld [$ff00], a
	ld a, [$ff00]
	ld a, [$ff00]
	ld a, [$ff00]
	ld a, [$ff00]
	and $3
	cp $3
	jr nz, .asm_ba3
	ld hl, Unknown_0bab
	call Func_0b20
	or a
	ret
.asm_ba3
	ld hl, Unknown_0bab
	call Func_0b20
	scf
	ret

Unknown_0bab: ; 0bab (0:0bab)
INCBIN "baserom.gbc",$0bab,$0bbb - $0bab

Unknown_0bbb: ; 0bbb (0:0bbb)
INCBIN "baserom.gbc",$0bbb,$0c08 - $0bbb

; loops 1750 * bc times
Wait: ; 0c08 (0:0c08)
	ld de, 1750
.loop
	nop
	nop
	nop
	dec de
	ld a, d
	or e
	jr nz, .loop
	dec bc
	ld a, b
	or c
	jr nz, Wait
	ret
; 0xc19

INCBIN "baserom.gbc",$0c19,$0c91 - $0c19

Func_0c91: ; 0c91 (0:0c91)
	ld a, [$cb74]
	cp $29
	jr z, .asm_c9d
	cp $12
	jr z, .asm_caa
	ret
.asm_c9d
	ld a, [$ff02]
	add a
	ret c
	ld a, $1
	ld [$ff02], a
	ld a, $81
	ld [$ff02], a
	ret
.asm_caa
	ld a, [$cb76]
	ld hl, $cb77
	cp [hl]
	ld [hl], a
	ld hl, $cb78
	jr nz, .asm_cc2
	inc [hl]
	ld a, [hl]
	cp $4
	ret c
	ld hl, $cb75
	set 7, [hl]
	ret
.asm_cc2
	ld [hl], $0
	ret
; 0xcc5

INCBIN "baserom.gbc",$0cc5,$0d26 - $0cc5

SerialHandler: ; 0d26 (0:0d26)
	push af
	push hl
	push de
	push bc
	ld a, [$ce63]
	or a
	jr z, .asm_d35
	call Func_3189
	jr .asm_d6e
.asm_d35
	ld a, [$cb74]
	or a
	jr z, .asm_d55
	ld a, [$ff01]
	call Func_0d77
	call Func_0dc8
	push af
.asm_d44
	ld a, [$ff02]
	add a
	jr c, .asm_d44
	pop af
	ld [$ff01], a
	ld a, [$cb74]
	cp $29
	jr z, .asm_d6e
	jr .asm_d6a
.asm_d55
	ld a, $1
	ld [$cba2], a
	ld a, [$ff01]
	ld [$cba5], a
	ld a, $ac
	ld [$ff01], a
	ld a, [$cba5]
	cp $12
	jr z, .asm_d6e
.asm_d6a
	ld a, $80
	ld [$ff02], a
.asm_d6e
	ld hl, $cb76
	inc [hl]
	pop bc
	pop de
	pop hl
	pop af
	reti

Func_0d77: ; 0d77 (0:0d77)
	ld hl, $cba1
	ld e, [hl]
	dec e
	jr z, .asm_d94
	cp $ac
	ret z
	cp $ca
	jr z, .asm_d92
	or a
	jr z, .asm_d8c
	cp $ff
	jr nz, .asm_d99
.asm_d8c
	ld hl, $cb75
	set 6, [hl]
	ret
.asm_d92
	inc [hl]
	ret
.asm_d94
	ld [hl], $0
	cpl
	jr .asm_d9b
.asm_d99
	xor $c0
.asm_d9b
	push af
	ld a, [$cba4]
	ld e, a
	ld a, [$cba3]
	dec a
	and $1f
	cp e
	jr z, .asm_dc1
	ld d, $0
	ld hl, $cba5
	add hl, de
	pop af
	ld [hl], a
	ld a, e
	inc a
	and $1f
	ld [$cba4], a
	ld hl, $cba2
	inc [hl]
	xor a
	ld [$cb75], a
	ret
.asm_dc1
	pop af
	ld hl, $cb75
	set 0, [hl]
	ret

Func_0dc8: ; 0dc8 (0:0dc8)
	ld hl, $cb7d
	ld a, [hl]
	or a
	jr nz, .asm_dd9
	ld hl, $cb7e
	ld a, [hl]
	or a
	jr nz, .asm_ddd
	ld a, $ac
	ret
.asm_dd9
	ld a, [hl]
	ld [hl], $0
	ret
.asm_ddd
	dec [hl]
	ld a, [$cb7f]
	ld e, a
	ld d, $0
	ld hl, $cb81
	add hl, de
	inc a
	and $1f
	ld [$cb7f], a
	ld a, [hl]
	xor $c0
	cp $ac
	jr z, .asm_e01
	cp $ca
	jr z, .asm_e01
	cp $ff
	jr z, .asm_e01
	or a
	jr z, .asm_e01
	ret
.asm_e01
	xor $c0
	cpl
	ld [$cb7d], a
	ld a, $ca
	ret
; 0xe0a

INCBIN "baserom.gbc",$0e0a,$0ea6 - $0e0a

Func_0ea6: ; 0ea6 (0:0ea6)
	ld a, [$ffff]
	and $f7
	ld [$ffff], a
	xor a
	ld [$ff01], a
	ld [$ff02], a
	ld hl, $cb74
	ld bc, $0051
.asm_eb7
	xor a
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .asm_eb7
	ret
; 0xebf

INCBIN "baserom.gbc",$0ebf,$3189 - $0ebf

Func_3189: ; 3189 (0:3189)
	ld hl, PointerTable_3190
	dec a
	jp JumpToFunctionInTable

PointerTable_3190: ; 3190 (0:3190)
	dw Func_31a8
	dw Func_31a8
	dw Func_31a8
	dw Func_31a8
	dw Func_31a8
	dw Func_31b0
	dw Func_31ca
	dw Func_31dd
	dw Func_31e5
	dw Func_31ef
	dw Func_31ea
	dw Func_31f2

Func_31a8: ; 31a8 (0:31a8)
	call Func_31fc
Func_31ab: ; 31ab (0:31ab)
	ld hl, $ce63
	inc [hl]
	ret

Func_31b0: ; 31b0 (0:31b0)
	call Func_31ab
	ld hl, $ce68
	ld a, [hli]
	or [hl]
	jr nz, .asm_31bf
	call Func_31ab
	jr Func_31dd
.asm_31bf
	ld hl, $ce6a
	ld de, $ce70
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

Func_31ca: ; 31ca (0:31ca)
	call Func_31fc
	ld hl, $ce68
	ld a, [hl]
	dec [hl]
	or a
	jr nz, .asm_31d8
	inc hl
	dec [hl]
	dec hl
.asm_31d8
	ld a, [hli]
	or [hl]
	jr z, Func_31ab
	ret

Func_31dd: ; 31dd (0:31dd)
	ld a, [$ce6c]
Func_31e0: ; 31e0 (0:31e0)
	call Func_3212
	jr Func_31ab

Func_31e5: ; 31e5 (0:31e5)
	ld a, [$ce6d]
	jr Func_31e0

Func_31ea: ; 31ea (0:31ea)
	ld a, [$ff01]
	ld [$ce6e], a
Func_31ef: ; 31ef (0:31ef)
	xor a
	jr Func_31e0

Func_31f2: ; 31f2 (0:31f2)
	ld a, [$ff01]
	ld [$ce6f], a
	xor a
	ld [$ce63], a
	ret

Func_31fc: ; 31fc (0:31fc)
	ld hl, $ce70
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [de]
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	ld e, a
	ld hl, $ce6c
	add [hl]
	ld [hli], a
	ld a, $0
	adc [hl]
	ld [hl], a
	ld a, e
Func_3212: ; 3212 (0:3212)
	ld [$ff01], a
	ld a, $1
	ld [$ff02], a
	ld a, $81
	ld [$ff02], a
	ret
; 0x321d

INCBIN "baserom.gbc",$321d,$377f - $321d

Func_377f: ; 377f (0:377f)
	rst $28
	dec a
	nop
	ld b, b
	ret
; 0x3784

INCBIN "baserom.gbc",$3784,$3fe0 - $3784

; jumps to 3f:hl
Bankswitch3dTo3f: ; 3fe0 (0:3fe0)
	push af
	ld a, $3f
	ld [$ff80], a
	ld [$2000], a
	pop af
	ld bc, Bankswitch3d
	push bc
	jp [hl]

Bankswitch3d: ; 3fe0 (0:3fe0)
	ld a, $3d
	ld [$ff80], a
	ld [$2000], a
	ret
; 0x3ff6

INCBIN "baserom.gbc",$3ff6,$4000 - $3ff6