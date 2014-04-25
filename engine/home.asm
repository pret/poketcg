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
	call CopyDMAFunction
	call Func_080b
	ld a, BANK(Func_4000)
	call BankswitchHome
	ld sp, $e000
	jp Func_4000

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

Func_0264: ; 0264 (0:0264)
	push hl
	ld a, [$cabb]
	bit 7, a
	jr z, .asm_275
	ld hl, $cab8
	ld a, [hl]
.asm_270
	halt
	cp [hl]
	jr z, .asm_270
.asm_275
	pop hl
	ret

Func_0277: ; 0277 (0:0277)
	ld a, [$cabb]
	bit 7, a
	ret nz
	or $80
	ld [$cabb], a
	ld [$ff40], a
	ld a, $c0
	ld [$cabf], a
	ret

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

Func_02b9: ; 02b9 (0:02b9)
	ld a, [$cabb]
	and $fb
	ld [$cabb], a
	ret

Func_02c2: ; 02c2 (0:02c2)
	ld a, [$cabb]
	or $4
	ld [$cabb], a
	ret
; 0x2cb

INCBIN "baserom.gbc",$02cb,$02dd - $02cb

Func_02dd: ; 02dd (0:02dd)
	ld a, [$ffff]
	or $4
	ld [$ffff], a
	ret

Func_02e4: ; 02e4 (0:02e4)
	ld a, [$ffff]
	or $1
	ld [$ffff], a
	ret
; 0x2eb

INCBIN "baserom.gbc",$02eb,$030b - $02eb

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

Func_0404: ; 0404 (0:0404)
	ld a, $c0
	jr asm_411

Func_0408: ; 0408 (0:0408)
	or $80
	jr asm_411

Func_040c: ; 040c (0:040c)
	ld [$cabc], a
asm_40f
	ld a, $80
asm_411
	ld [$cabf], a
	ld a, [$cabb]
	rla
	ret c
	push hl
	push de
	push bc
	call Func_042d
	pop bc
	pop de
	pop hl
	ret

Func_0423: ; 0423 (0:0423)
	ld [$cabd], a
	jr asm_40f

Func_0428: ; 0428 (0:0428)
	ld [$cabe], a
	jr asm_40f

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

INCBIN "baserom.gbc",$0492,$04a2 - $0492

Func_04a2: ; 04a2 (0:04a2)
	call Func_028a
	call Func_03c0
	xor a
	ld [$cac2], a
	ld a, [$cab4]
	cp $1
	ret nz
	call Func_0277
	ld hl, Unknown_04bf
	call Func_0b20
	call Func_028a
	ret

Unknown_04bf: ; 04bf (0:04bf)
INCBIN "baserom.gbc",$04bf,$04cf - $04bf

Func_04cf: ; 04cf (0:04cf)
	ld l, c
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld c, b
	ld b, $98
	add hl, bc
	ld e, l
	ld d, h
	ret

Func_04de: ; 04de (0:04de)
	ld a, $20
	ld [$ff00], a
	ld a, [$ff00]
	ld a, [$ff00]
	cpl
	and $f
	swap a
	ld b, a
	ld a, $10
	ld [$ff00], a
	ld a, [$ff00]
	ld a, [$ff00]
	ld a, [$ff00]
	ld a, [$ff00]
	ld a, [$ff00]
	ld a, [$ff00]
	cpl
	and $f
	or b
	ld c, a
	cpl
	ld b, a
	ld a, [$ff90]
	xor c
	and b
	ld [$ff8e], a
	ld a, [$ff90]
	xor c
	and c
	ld b, a
	ld [$ff91], a
	ld a, [$ff90]
	and $f
	cp $f
	jr nz, asm_522
	call Func_0ea6
Func_051b: ; 051b (0:051b)
	ld a, [$cab3]
	di
	jp Start
asm_522
	ld a, c
	ld [$ff90], a
	ld a, $30
	ld [$ff00], a
	ret
; 0x52a

INCBIN "baserom.gbc",$052a,$053f - $052a

Func_053f: ; 053f (0:053f)
	push af
	push hl
	push de
	push bc
	ld hl, $cad3
	call Func_05b6
	call Func_0264
	call Func_04de
	call Func_0572
	ld a, [$cad5]
	or a
	jr z, .asm_56d
	ld a, [$ff91]
	and $4
	jr z, .asm_56d
.asm_55e
	call Func_0264
	call Func_04de
	call Func_0572
	ld a, [$ff91]
	and $4
	jr z, .asm_55e
.asm_56d
	pop bc
	pop de
	pop hl
	pop af
	ret

Func_0572: ; 0572 (0:0572)
	ld a, [$ff90]
	ld [$ff8f], a
	and $f0
	jr z, .asm_58c
	ld hl, $ff8d
	ld a, [$ff91]
	and $f0
	jr z, .asm_586
	ld [hl], $18
	ret
.asm_586
	dec [hl]
	jr nz, .asm_58c
	ld [hl], $6
	ret
.asm_58c
	ld a, [$ff91]
	and $f
	ld [$ff8f], a
	ret

CopyDMAFunction: ; 0593 (0:0593)
	ld c, $83
	ld b, JumpToFunctionInTable - DMA
	ld hl, DMA
.asm_59a
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	dec b
	jr nz, .asm_59a
	ret

; CopyDMAFunction copies this function to $ff83 
DMA: ; 05a1 (0:05a1)
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

Func_05b6: ; 05b6 (0:05b6)
	push af
	ld a, [hli]
	or [hl]
	jr nz, .asm_5bd
	pop af
	ret
.asm_5bd
	ld a, [hld]
	ld l, [hl]
	ld h, a
	pop af
Func_05c1: ; 05c1 (0:05c1)
	jp [hl]
; 0x5c2

INCBIN "baserom.gbc",$05c2,$0663 - $05c2

Func_0663: ; 0663 (0:0663)
	push bc
	ld bc, $d8f0
	call Func_0686
	ld bc, $fc18
	call Func_0686
	ld bc, $ff9c
	call Func_0686
	ld bc, $fff6
	call Func_0686
	ld bc, $ffff
	call Func_0686
	xor a
	ld [de], a
	pop bc
	ret

Func_0686: ; 0686 (0:0686)
	ld a, $2f
.asm_688
	inc a
	add hl, bc
	jr c, .asm_688
	ld [de], a
	inc de
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	ret
; 0x695

INCBIN "baserom.gbc",$0695,$06c3 - $0695

Func_06c3: ; 06c3 (0:06c3)
	push af
	ld a, [$cabb]
	rla
	jr c, .asm_6d8
	pop af
	push hl
	push de
	push bc
	push af
	call Func_04cf
	pop af
	ld [de], a
	pop bc
	pop de
	pop hl
	ret
.asm_6d8
	pop af
	push hl
	push de
	push bc
	ld hl, $cac1
	push hl
	ld [hl], a
	call Func_04cf
	pop hl
	ld b, $1
	call Func_0c19
	pop bc
	pop de
	pop hl
	ret
; 0x6ee

INCBIN "baserom.gbc",$06ee,$0709 - $06ee

Func_0709: ; 0709 (0:0709)
	jp Func_0c19

Func_070c: ; 070c (0:070c)
	ld a, [$cabb]
	rla
	jr nc, .asm_726
.asm_712
	push bc
	push hl
	push de
	ld b, c
	call Func_0709
	ld b, $0
	pop hl
	add hl, bc
	ld e, l
	ld d, h
	pop hl
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_712
	ret
.asm_726
	push bc
.asm_727
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .asm_727
	pop bc
	dec b
	jr nz, .asm_726
	ret

CopyData_SaveRegisters: ; 0732 (0:0732)
	push hl
	push de
	push bc
	call CopyData
	pop bc
	pop de
	pop hl
	ret

; copies bc bytes from hl to de
CopyData: ; 073c (0:073c)
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, CopyData
	ret

Func_0745: ; 0745 (0:0745)
	push hl
	push bc
	push af
	push de
	ld e, l
	ld d, h
	ld hl, [sp+$9]
	ld b, [hl]
	dec hl
	ld c, [hl]
	dec hl
	ld [hl], b
	dec hl
	ld [hl], c
	ld hl, [sp+$9]
	ld a, [$ff80]
	ld [hld], a
	ld [hl], $0
	ld a, d
	rlca
	rlca
	and $3
	ld b, a
	res 7, d
	set 6, d
	ld l, e
	ld h, d
	pop de
	pop af
	add b
	call BankswitchHome
	pop bc
	ret
; 0x76f

INCBIN "baserom.gbc",$076f,$078e - $076f

Func_078e: ; 078e (0:078e)
	push hl
	push de
	ld hl, [sp+$7]
	ld a, [hld]
	call BankswitchHome
	dec hl
	ld d, [hl]
	dec hl
	ld e, [hl]
	inc hl
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	pop de
	pop hl
	pop af
	ret

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

Func_07d6: ; 07d6 (0:07d6)
	ld [$ff82], a
	ld [$ff4f], a
	ret
; 0x7db

INCBIN "baserom.gbc",$07db,$07e7 - $07db

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
	call Func_4050
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
	call Func_4050
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

Func_0879: ; 0879 (0:0879)
	push de
	ld a, h
	ld e, l
	ld d, $0
	ld l, d
	ld h, d
	jr .asm_887
.asm_882
	add hl, de
.asm_883
	sla e
	rl d
.asm_887
	srl a
	jr c, .asm_882
	jr nz, .asm_883
	pop de
	ret
; 0x88f

INCBIN "baserom.gbc",$088f,$089b - $088f

Func_089b: ; 089b (0:089b)
	push hl
	push de
	ld hl, $caca
	ld a, [hli]
	ld d, [hl]
	inc hl
	ld e, a
	ld a, d
	rlca
	rlca
	xor e
	rra
	push af
	ld a, d
	xor e
	ld d, a
	ld a, [hl]
	xor e
	ld e, a
	pop af
	rl e
	rl d
	ld a, d
	xor e
	inc [hl]
	dec hl
	ld [hl], d
	dec hl
	ld [hl], e
	pop de
	pop hl
	ret
; 0x8bf

INCBIN "baserom.gbc",$08bf,$099c - $08bf

Func_099c: ; 099c (0:099c)
	xor a
	ld [$cab5], a
	ld hl, $ca00
	ld c, $28
	xor a
.asm_9a6
	ld [hli], a
	ld [hli], a
	inc hl
	inc hl
	dec c
	jr nz, .asm_9a6
	ret

; this function affects the stack so that it returns to the pointer following the rst call
; similar to rst 28, except this always loads bank 1
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

; this function affects the stack so that it returns to the three byte pointer following the rst call
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

Func_0c19: ; 0c19 (0:0c19)
	push bc
.asm_c1a
	ei
	di
	ld a, [$ff41]
	and $3
	jr nz, .asm_c1a
	ld a, [hl]
	ld [de], a
	ld a, [$ff41]
	and $3
	jr nz, .asm_c1a
	ei
	inc hl
	inc de
	dec b
	jr nz, .asm_c1a
	pop bc
	ret

Func_0c32: ; 0c32 (0:0c32)
	push bc
.asm_c33
	ei
	di
	ld a, [$ff41]
	and $3
	jr nz, .asm_c33
	ld a, [de]
	ld [hl], a
	ld a, [$ff41]
	and $3
	jr nz, .asm_c33
	ei
	inc hl
	inc de
	dec c
	jr nz, .asm_c33
	pop bc
	ret
; 0xc4b

INCBIN "baserom.gbc",$0c4b,$0c91 - $0c4b

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

INCBIN "baserom.gbc",$0ebf,$1072 - $0ebf

Func_1072: ; 1072 (0:1072)
	ld hl, $c400
	ld a, [$ff97]
	cp $c2
	jr z, .asm_107e
	ld hl, $c480
.asm_107e
	push hl
	ld bc, $003b
	add hl, bc
	ld [hl], $0
	pop hl
	push hl
.asm_1087
	ld a, [de]
	inc de
	ld b, a
	or a
	jr z, .asm_1097
	ld a, [de]
	inc de
	ld c, a
.asm_1090
	ld [hl], c
	inc hl
	dec b
	jr nz, .asm_1090
	jr .asm_1087
.asm_1097
	ld hl, $cce9
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	pop hl
	ld bc, $003b
	add hl, bc
	ld a, [hl]
	or a
	ret nz
	rst $38
	scf
	ret
; 0x10aa

INCBIN "baserom.gbc",$10aa,$1c7d - $10aa

Func_1c7d: ; 1c7d (0:1c7d)
	call Func_07b6
	ld hl, $a010
asm_1c83
	ld a, [hli]
	ld [de], a
	inc de
	or a
	jr nz, asm_1c83
	dec de
	call Func_07be
	ret

Func_1c8e: ; 1c8e (0:1c8e)
	ld hl, $cc16
	ld a, [hli]
	or [hl]
	jr z, .asm_1c9b
	ld a, [hld]
	ld l, [hl]
	ld h, a
	jp Func_2e89
.asm_1c9b
	ld hl, $c500
	ld a, [hl]
	or a
	jr z, .asm_1ca4
	jr asm_1c83
.asm_1ca4
	ld hl, $0092
	jp Func_2e89
; 0x1caa

INCBIN "baserom.gbc",$1caa,$1dca - $1caa

Func_1dca: ; 1dca (0:1dca)
	ld a, [$cabb]
	bit 7, a
	jr nz, .asm_1dd8
.asm_1dd1
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .asm_1dd1
	ret
.asm_1dd8
	jp Func_0c32

Func_1ddb: ; 1ddb (0:1ddb)
	ld l, e
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, l
	add d
	ld l, a
	ld a, h
	adc $98
	ld h, a
	ret

Func_1deb: ; 1deb (0:1deb)
	push af
	ld a, [$ff92]
	rra
	rra
	rra
	and $1f
	add d
	ld d, a
	ld a, [$ff93]
	rra
	rra
	rra
	and $1f
	add e
	ld e, a
	pop af
	ret
; 0x1e00

INCBIN "baserom.gbc",$1e00,$1e7c - $1e00

Func_1e7c: ; 1e7c (0:1e7c)
	ld a, [$cab4]
	cp $2
	jr z, asm_1ec9
	cp $1
	jp z, Func_1f0f
Func_1e88: ; 1e88 (0:1e88)
	call Func_1ddb
	ld a, $1c
	ld de, $1819
	call Func_1ea5
	dec c
	dec c
.asm_1e95
	ld a, $0
	ld de, $1e1f
	call Func_1ea5
	dec c
	jr nz, .asm_1e95
	ld a, $1d
	ld de, $1a1b
Func_1ea5: ; 1ea5 (0:1ea5)
	add sp, $e0
	push hl
	push bc
	ld hl, [sp+$4]
	dec b
	dec b
	push hl
	ld [hl], d
	inc hl
.asm_1eb0
	ld [hli], a
	dec b
	jr nz, .asm_1eb0
	ld [hl], e
	pop de
	pop bc
	pop hl
	push hl
	push bc
	ld c, b
	ld b, $0
	call Func_1dca
	pop bc
	pop de
	ld hl, $0020
	add hl, de
	add sp, $20
	ret
asm_1ec9
	call Func_1ddb
	ld a, $1c
	ld de, $1819
	call Func_1efb
	dec c
	dec c
.asm_1ed6
	ld a, $0
	ld de, $1e1f
	push hl
	call Func_1ea5
	pop hl
	call Func_07cd
	ld a, [$ccf3]
	ld e, a
	ld d, a
	xor a
	call Func_1ea5
	call Func_07c5
	dec c
	jr nz, .asm_1ed6
	ld a, $1d
	ld de, $1a1b
	call Func_1efb
	ret

Func_1efb: ; 1efb (0:1efb)
	push hl
	call Func_1ea5
	pop hl
	call Func_07cd
	ld a, [$ccf3]
	ld e, a
	ld d, a
	call Func_1ea5
	call Func_07c5
	ret

Func_1f0f: ; 1f0f (0:1f0f)
	push bc
	push de
	call Func_1e88
	pop de
	pop bc
	ld a, [$ccf3]
	or a
	ret z
	push bc
	push de
	ld hl, $cae0
	ld de, $1f4f
	ld c, $10
.asm_1f25
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .asm_1f25
	pop de
	pop bc
	ld hl, $cae4
	ld [hl], d
	inc hl
	ld [hl], e
	inc hl
	ld a, d
	add b
	dec a
	ld [hli], a
	ld a, e
	add c
	dec a
	ld [hli], a
	ld a, [$ccf3]
	and $80
	jr z, .asm_1f48
	ld a, $2
	ld [$cae2], a
.asm_1f48
	ld hl, $cae0
	call Func_0b20
	ret
; 0x1f4f

INCBIN "baserom.gbc",$1f4f,$2119 - $1f4f

Func_2119: ; 2119 (0:2119)
	ld hl, $2968
	ld de, $9000
	ld b, $38
	ld a, $1d
	call Func_0745
	ld c, $10
	call Func_070c
	call Func_078e
	ret
; 0x212f

INCBIN "baserom.gbc",$212f,$21c5 - $212f

Func_21c5: ; 21c5 (0:21c5)
	push de
	push bc
	call Func_2298
	jr .asm_21e8
.asm_21cc
	cp $5
	jr c, .asm_21d9
	cp $10
	jr nc, .asm_21d9
	call Func_21f2
	jr .asm_21e8
.asm_21d9
	ld e, a
	ld d, [hl]
	call Func_2546
	jr nc, .asm_21e1
	inc hl
.asm_21e1
	call Func_22ca
	xor a
	call Func_21f2
.asm_21e8
	ld a, [hli]
	or a
	jr nz, .asm_21cc
	call Func_230f
	pop bc
	pop de
	ret

Func_21f2: ; 21f2 (0:21f2)
	or a
	jr z, .asm_2241
	cp $e
	jr z, .asm_2221
	cp $f
	jr z, .asm_2221
	cp $a
	jr z, .asm_224d
	cp $5
	jr z, .asm_2225
	cp $6
	jr z, .asm_220f
	cp $7
	jr z, .asm_2215
	scf
	ret
.asm_220f
	ld a, $1
	ld [$cd0a], a
	ret
.asm_2215
	call Func_230f
	xor a
	ld [$cd0a], a
	ld a, $f
	ld [$ffaf], a
	ret
.asm_2221
	ld [$ffaf], a
	xor a
	ret
.asm_2225
	ld a, [$cd0a]
	push af
	ld a, $1
	ld [$cd0a], a
	call Func_230f
	pop af
	ld [$cd0a], a
	ld a, [$ffb0]
	or a
	jr nz, .asm_2240
	ld a, [hl]
	push hl
	call Func_22f2
	pop hl
.asm_2240
	inc hl
.asm_2241
	ld a, [$ffae]
	or a
	ret z
	ld b, a
	ld a, [$ffac]
	cp b
	jr z, .asm_224d
	xor a
	ret
.asm_224d
	call Func_230f
	ld a, [$cd08]
	or a
	call z, .asm_2257
.asm_2257
	xor a
	ld [$ffac], a
	ld a, [$ffad]
	add $20
	ld b, a
	ld a, [$ffaa]
	and $e0
	add b
	ld [$ffaa], a
	ld a, [$ffab]
	adc $0
	ld [$ffab], a
	ld a, [$cd09]
	inc a
	ld [$cd09], a
	xor a
	ret

Func_2275: ; 2275 (0:2275)
	ld a, d
	dec a
	ld [$cd04], a
	ld a, e
	ld [$ffa8], a
	call Func_2298
	xor a
	ld [$ffb0], a
	ld [$ffa9], a
	ld a, $88
	ld [$cd06], a
	ld a, $80
	ld [$cd07], a
	ld hl, $c600
.asm_2292
	xor a
	ld [hl], a
	inc l
	jr nz, .asm_2292
	ret

Func_2298: ; 2298 (0:2298)
	xor a
	ld [$cd0a], a
	ld [$ffac], a
	ld [$cd0b], a
	ld a, $f
	ld [$ffaf], a
	ret

Func_22a6: ; 22a6 (0:22a6)
	push af
	call Func_22ae
	pop af
	ld [$ffae], a
	ret

Func_22ae: ; 22ae (0:22ae)
	push hl
	ld a, d
	ld [$ffad], a
	xor a
	ld [$ffae], a
	ld [$cd09], a
	call Func_1ddb
	ld a, l
	ld [$ffaa], a
	ld a, h
	ld [$ffab], a
	call Func_2298
	xor a
	ld [$cd0b], a
	pop hl
	ret

Func_22ca: ; 22ca (0:22ca)
	push hl
	push de
	push bc
	ld a, [$ffb0]
	and $1
	jr nz, .asm_22ed
	call Func_2325
	jr c, .asm_22de
	or a
	jr nz, .asm_22e9
	call Func_24ac
.asm_22de
	ld a, [$ffb0]
	and $2
	jr nz, .asm_22e9
	ld a, [$ffa9]
	call Func_22f2
.asm_22e9
	pop bc
	pop de
	pop hl
	ret
.asm_22ed
	call Func_235e
	jr .asm_22e9

Func_22f2: ; 22f2 (0:22f2)
	ld [$cd05], a
	ld hl, $ffaa
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	dec de
	ld l, e
	ld h, d
	ld de, $cd05
	ld c, $1
	call Func_1dca
	ld hl, $ffac
	inc [hl]
	ret

Func_230f: ; 230f (0:230f)
	ld a, [$cd0a]
	or a
	ret z
	ld a, [$cd0b]
	or a
	ret z
	push hl
	push de
	push bc
	ld e, $20
	call Func_22ca
	pop bc
	pop de
	pop hl
	ret

Func_2325: ; 2325 (0:2325)
	call Func_235e
	ret c
	or a
	ret nz
	ld a, [$ffa8]
	ld hl, $cd04
	cp [hl]
	jr nz, .asm_2345
	ld a, [$ffa9]
	ld h, $c8
.asm_2337
	ld l, a
	ld a, [hl]
	or a
	jr nz, .asm_2337
	ld h, $c9
	ld c, [hl]
	ld b, $c8
	xor a
	ld [bc], a
	jr .asm_234a
.asm_2345
	inc [hl]
	jr nz, .asm_2349
	inc [hl]
.asm_2349
	ld l, [hl]
.asm_234a
	ld a, [$ffa9]
	ld c, a
	ld b, $c9
	ld a, l
	ld [$ffa9], a
	ld [bc], a
	ld h, $c8
	ld [hl], c
	ld h, $c6
	ld [hl], e
	inc h
	ld [hl], d
	ld b, l
	xor a
	ret

Func_235e: ; 235e (0:235e)
	ld a, [$cd0a]
	or a
	jr z, .asm_2376
	call Func_23b1
	ld a, [$cd0b]
	ld d, a
	or a
	jr nz, .asm_2376
	ld a, e
	ld [$cd0b], a
	ld a, $1
	or a
	ret
.asm_2376
	xor a
	ld [$cd0b], a
	ld a, [$ffa9]
	ld l, a
.asm_237d
	ld h, $c6
	ld a, [hl]
	or a
	ret z
	cp e
	jr nz, .asm_238a
	inc h
	ld a, [hl]
	cp d
	jr z, .asm_238f
.asm_238a
	ld h, $c8
	ld l, [hl]
	jr .asm_237d
.asm_238f
	ld a, [$ffa9]
	cp l
	jr z, .asm_23af
	ld c, a
	ld b, $c9
	ld a, l
	ld [bc], a
	ld [$ffa9], a
	ld h, $c9
	ld b, [hl]
	ld [hl], $0
	ld h, $c8
	ld a, c
	ld c, [hl]
	ld [hl], a
	ld l, b
	ld [hl], c
	ld h, $c9
	inc c
	dec c
	jr z, .asm_23af
	ld l, c
	ld [hl], b
.asm_23af
	scf
	ret

Func_23b1: ; 23b1 (0:23b1)
	ld a, [$cd0d]
	or a
	ret z
	ld a, e
	cp $60
	ret c
	cp $7b
	ret nc
	sub $20
	ld e, a
	ret
; 0x23c1

INCBIN "baserom.gbc",$23c1,$245d - $23c1

Func_245d: ; 245d (0:245d)
	push de
	push bc
	ld de, $caa0
	push de
	ld bc, $d8f0
	call Func_2499
	ld bc, $fc18
	call Func_2499
	ld bc, $ff9c
	call Func_2499
	ld bc, $fff6
	call Func_2499
	ld bc, $ffff
	call Func_2499
	xor a
	ld [de], a
	pop hl
	ld e, $5
.asm_2486
	inc hl
	ld a, [hl]
	cp $20
	jr nz, .asm_2495
	ld [hl], $0
	inc hl
	dec e
	jr nz, .asm_2486
	dec hl
	ld [hl], $20
.asm_2495
	dec hl
	pop bc
	pop de
	ret

Func_2499: ; 2499 (0:2499)
	ld a, $5
	ld [de], a
	inc de
	ld a, $1f
.asm_249f
	inc a
	add hl, bc
	jr c, .asm_249f
	ld [de], a
	inc de
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	ret

Func_24ac: ; 24ac (0:24ac)
	push hl
	push de
	push bc
	ld a, [$cd0a]
	or a
	jr nz, .asm_24bf
	call Func_2510
	call Func_1dca
.asm_24bb
	pop bc
	pop de
	pop hl
	ret
.asm_24bf
	call Func_24ca
	call Func_2518
	call Func_1dca
	jr .asm_24bb

Func_24ca: ; 24ca (0:24ca)
	push bc
	ld a, [$ff80]
	push af
	ld a, BANK(Unknown_76668)
	call BankswitchHome
	push de
	ld a, e
	ld de, $ccf4
	call Func_24fa
	pop de
	ld a, d
	ld de, $ccf5
	call Func_24fa
	ld hl, $ccf4
	ld b, $8
.asm_24e8
	ld a, [hli]
	swap a
	or [hl]
	dec hl
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .asm_24e8
	call Func_078e
	pop bc
	ld de, $ccf4
	ret

Func_24fa: ; 24fa (0:24fa)
	sub $20
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, Unknown_76668
	add hl, bc
	ld b, $8
.asm_2508
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	dec b
	jr nz, .asm_2508
	ret

Func_2510: ; 2510 (0:2510)
	push bc
	call Func_256d
	call Func_252e
	pop bc
Func_2518: ; 2518 (0:2518)
	ld hl, $cd07
	ld a, b
	xor [hl]
	ld h, $0
	ld l, a
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, [$cd06]
	ld b, a
	ld c, $0
	add hl, bc
	ld c, $10
	ret

Func_252e: ; 252e (0:252e)
	ld a, $1d
	call Func_0745
	ld de, $ccf4
	push de
	ld c, $8
.asm_2539
	ld a, [hli]
	ld [de], a
	inc de
	ld [de], a
	inc de
	dec c
	jr nz, .asm_2539
	pop de
	call Func_078e
	ret

Func_2546: ; 2546 (0:2546)
	ld a, [$cd0a]
	or a
	jr nz, .asm_255f
	ld a, e
	cp $10
	jr c, .asm_2561
	cp $60
	jr nc, .asm_2565
	ld a, [$ffaf]
	cp $f
	jr nz, .asm_2565
	ld d, $f
	or a
	ret
.asm_255f
	or a
	ret
.asm_2561
	cp $5
	jr c, .asm_2569
.asm_2565
	ld d, $0
	or a
	ret
.asm_2569
	ld e, d
	ld d, a
	scf
	ret

Func_256d: ; 256d (0:256d)
	ld bc, $0280
	ld a, d
	cp $e
	jr z, .asm_2580
	cp $f
	jr nz, .asm_2582
	ld bc, $0000
	ld a, e
	sub $10
	ld e, a
.asm_2580
	ld d, $0
.asm_2582
	ld l, e
	ld h, d
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, bc
	ret
; 0x2589

INCBIN "baserom.gbc",$2589,$264b - $2589

Func_264b: ; 264b (0:264b)
	xor a
	ld [$cd99], a
	ld a, [$ff8f]
	or a
	jr z, .asm_2685
	ld b, a
	ld a, [$cd14]
	ld c, a
	ld a, [$cd10]
	bit 6, b
	jr z, .asm_266b
	dec a
	bit 7, a
	jr z, .asm_2674
	ld a, [$cd14]
	dec a
	jr .asm_2674
.asm_266b
	bit 7, b
	jr z, .asm_2685
	inc a
	cp c
	jr c, .asm_2674
	xor a
.asm_2674
	push af
	ld a, $1
	ld [$cd99], a
	call Func_26e9
	pop af
	ld [$cd10], a
	xor a
	ld [$cd0f], a
.asm_2685
	ld a, [$cd10]
	ld [$ffb1], a
	ld hl, $cd17
	ld a, [hli]
	or [hl]
	jr z, .asm_26a9
	ld a, [hld]
	ld l, [hl]
	ld h, a
	ld a, [$ffb1]
	call Func_05c1
	jr nc, asm_26d1
.asm_269b
	call Func_270b
	call Func_26c0
	ld a, [$cd10]
	ld e, a
	ld a, [$ffb1]
	scf
	ret
.asm_26a9
	ld a, [$ff91]
	and $3
	jr z, asm_26d1
	and $1
	jr nz, .asm_269b
	ld a, [$cd10]
	ld e, a
	ld a, $ff
	ld [$ffb1], a
	call Func_26c0
	scf
	ret

Func_26c0: ; 26c0 (0:26c0)
	push af
	ld a, [$ffb1]
	inc a
	jr z, .asm_26ca
	ld a, $2
	jr .asm_26cc
.asm_26ca
	ld a, $3
.asm_26cc
	call Func_3796
	pop af
	ret
asm_26d1
	ld a, [$cd99]
	or a
	jr z, Func_26da
	call Func_3796

Func_26da: ; 26da (0:26da)
	ld hl, $cd0f
	ld a, [hl]
	inc [hl]
	and $f
	ret nz
	ld a, [$cd15]
	bit 4, [hl]
	jr z, asm_26ec
Func_26e9: ; 26e9 (0:26e9)
	ld a, [$cd16]
asm_26ec
	ld c, a
	ld a, [$cd13]
	ld l, a
	ld a, [$cd10]
	ld h, a
	call Func_0879
	ld a, l
	ld hl, $cd11
	ld d, [hl]
	inc hl
	add [hl]
	ld e, a
	call Func_1deb
	ld a, c
	ld c, e
	ld b, d
	call Func_06c3
	or a
	ret

Func_270b: ; 270b (0:270b)
	ld a, [$cd15]
	jr asm_26ec
; 0x2710

INCBIN "baserom.gbc",$2710,$2a1a - $2710

Func_2a1a: ; 2a1a (0:2a1a)
	xor a
	ld hl, $cd10
	ld [hli], a
	ld [hl], d
	inc hl
	ld [hl], e
	inc hl
	ld [hl], $0
	inc hl
	ld [hl], $1
	inc hl
	ld [hl], b
	inc hl
	ld [hl], c
	ld [$cd0f], a
	ret
; 0x2a30

INCBIN "baserom.gbc",$2a30,$2a3e - $2a30

Func_2a3e: ; 2a3e (0:2a3e)
	push hl
	call Func_2a6f
	ld a, $b
	ld de, $010e
	call Func_1deb
	call Func_22a6
	pop hl
	ld a, l
	or h
	jp nz, Func_2e76
	ld hl, $c590
	jp Func_21c5

Func_2a59: ; 2a59 (0:2a59)
	push hl
	call Func_2a9e
	ld a, $13
	ld de, $010e
	call Func_1deb
	call Func_22a6
	call Func_0277
	pop hl
	jp Func_2e41

Func_2a6f: ; 2a6f (0:2a6f)
	ld de, $000c
	ld bc, $0c06
	call Func_1deb
	call Func_1e7c
	ret
; 0x2a7c

INCBIN "baserom.gbc",$2a7c,$2a9e - $2a7c

Func_2a9e: ; 2a9e (0:2a9e)
	ld de, $000c
	ld bc, $1406
	call Func_1deb
	call Func_1e7c
	ret
; 0x2aab

INCBIN "baserom.gbc",$2aab,$2af0 - $2aab

Func_2af0: ; 2af0 (0:2af0)
	call Func_2a59
	ld de, $0710
	call Func_2b66
	ld de, $0610
	jr .asm_2b0a
	call Func_2a3e
	ld de, $0310
	call Func_2b66
	ld de, $0210
.asm_2b0a
	ld a, d
	ld [$cd98], a
	ld bc, $0f00
	call Func_2a1a
	ld a, [$cd9a]
	ld [$cd10], a
	call Func_0277
	jr .asm_2b39
.asm_2b1f
	call Func_053f
	call Func_26da
	ld a, [$ff91]
	bit 0, a
	jr nz, .asm_2b50
	ld a, [$ff8f]
	and $30
	jr z, .asm_2b1f
	ld a, $1
	call Func_3796
	call Func_26e9
.asm_2b39
	ld a, [$cd98]
	ld c, a
	ld hl, $cd10
	ld a, [hl]
	xor $1
	ld [hl], a
	add a
	add a
	add c
	ld [$cd11], a
	xor a
	ld [$cd0f], a
	jr .asm_2b1f
.asm_2b50
	ld a, [$cd10]
	ld [$ffb1], a
	or a
	jr nz, .asm_2b5c
	ld [$cd9a], a
	ret
.asm_2b5c
	xor a
	ld [$cd9a], a
	ld a, $1
	ld [$ffb1], a
	scf
	ret

Func_2b66: ; 2b66 (0:2b66)
	call Func_1deb
	ld hl, $002f
	call Func_2c1b
	ret
; 0x2b70

INCBIN "baserom.gbc",$2b70,$2c1b - $2b70

Func_2c1b: ; 2c1b (0:2c1b)
	call Func_22ae
	jr Func_2c29

Func_2c1f: ; 2c1f (0:2c1f)
	call Func_22ae
	ld a, [hli]
	or [hl]
	ret z
	ld a, [hld]
	ld l, [hl]
	ld h, a
Func_2c29: ; 2c29 (0:2c29)
	ld a, [$ff80]
	push af
	call ReadTextOffset
	call Func_21c5
	pop af
	call BankswitchHome
	ret
; 0x2c37

INCBIN "baserom.gbc",$2c37,$2cc8 - $2c37

Func_2cc8: ; 2cc8 (0:2cc8)
	xor a
	ld [$ce48], a
	ld [$ce49], a
	ld [$ce4a], a
	ld a, $f
	;ld [$ffaf], a
	db $ea, $af, $ff
Func_2cd7: ; 2cd7 (0:2cd7)
	push hl
	call Func_2d06
	pop bc
	;ld a, [$ffaf]
	db $fa, $af, $ff
	ld [hli], a
	ld a, [$cd0a]
	ld [hli], a
	ld a, [$ff80]
	ld [hli], a
	ld [hl], c
	inc hl
	ld [hl], b
	ret

Func_2ceb: ; 2ceb (0:2ceb)
	call Func_2cd7
	ld hl, $ce48
	inc [hl]
	ret

Func_2cf3: ; 2cf3 (0:2cf3)
	call Func_2d06
	ld a, [hli]
	;ld [$ffaf], a
	db $ea, $af, $ff
	ld a, [hli]
	ld [$cd0a], a
	ld a, [hli]
	call BankswitchHome
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

Func_2d06: ; 2d06 (0:2d06)
	ld a, [$ce48]
	ld e, a
	add a
	add a
	add e
	ld e, a
	ld d, $0
	ld hl, $ce2b
	add hl, de
	ret
; 0x2d15

INCBIN "baserom.gbc",$2d15,$2d43 - $2d15

Func_2d43: ; 2d43 (0:2d43)
	call Func_2cf3
	ld a, [hli]
	or a
	jr z, .asm_2d79
	cp $5
	jr c, .asm_2d65
	cp $10
	jr nc, .asm_2d65
	call Func_21f2
	jr nc, .asm_2d74
	cp $9
	jr z, .asm_2dc8
	cp $b
	jr z, .asm_2d8a
	cp $c
	jr z, .asm_2db3
	jr .asm_2d74
.asm_2d65
	ld e, a
	ld d, [hl]
	call Func_2546
	jr nc, .asm_2d6d
	inc hl
.asm_2d6d
	call Func_22ca
	xor a
	call Func_21f2
.asm_2d74
	call Func_2cd7
	or a
	ret
.asm_2d79
	ld a, [$ce48]
	or a
	jr z, .asm_2d85
	dec a
	ld [$ce48], a
	jr Func_2d43
.asm_2d85
	call Func_230f
	scf
	ret
.asm_2d8a
	call Func_2ceb
	ld a, $f
	;ld [$ffaf], a
	db $ea, $af, $ff
	xor a
	ld [$cd0a], a
	ld de, $ce3f
	ld hl, $ce49
	call Func_2de0
	ld a, l
	or h
	jr z, .asm_2dab
	call ReadTextOffset
	call Func_2cd7
	jr Func_2d43
.asm_2dab
	ld hl, $c590
	call Func_2cd7
	jr Func_2d43
.asm_2db3
	call Func_2ceb
	ld de, $ce43
	ld hl, $ce4a
	call Func_2de0
	call Func_2e12
	call Func_2cd7
	jp Func_2d43
.asm_2dc8
	call Func_2ceb
	call Func_2e2c
	ld a, [$caa0]
	cp $6
	jr z, .asm_2dda
	ld a, $7
	call Func_21f2
.asm_2dda
	call Func_2cd7
	jp Func_2d43

Func_2de0: ; 2de0 (0:2de0)
	push de
	ld a, [hl]
	inc [hl]
	add a
	ld e, a
	ld d, $0
	pop hl
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

; uses the two byte text id in hl to read the three byte text offset
; loads the correct bank for the specific text and returns the pointer in hl
ReadTextOffset: ; 2ded (0:2ded)
	push de
	ld e, l
	ld d, h
	add hl, hl
	add hl, de
	set 6, h ; hl = (hl * 3) + $4000
	ld a, BANK(TextOffsets)
	call BankswitchHome
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hl]
	ld h, d
	rl h
	rla
	rl h
	rla
	add BANK(TextOffsets)
	call BankswitchHome
	res 7, d
	set 6, d ; $4000 ≤ de ≤ $7fff
	ld l, e
	ld h, d
	pop de
	ret

Func_2e12: ; 2e12 (0:2e12)
	ld a, [$cd0a]
	or a
	jp z, Func_245d
	ld de, $caa0
	push de
	call Func_0663
	pop hl
	ld c, $4
.asm_2e23
	ld a, [hl]
	cp $30
	ret nz
	inc hl
	dec c
	jr nz, .asm_2e23
	ret

Func_2e2c: ; 2e2c (0:2e2c)
	ld de, $caa0
	push de
	ld a, [$ff97]
	cp $c3
	jp z, .asm_2e3c
	call Func_1c7d
	pop hl
	ret
.asm_2e3c
	call Func_1c8e
	pop hl
	ret

Func_2e41: ; 2e41 (0:2e41)
	ld a, l
	or h
	jr z, .asm_2e53
	ld a, [$ff80]
	push af
	call ReadTextOffset
	call .asm_2e56
	pop af
	call BankswitchHome
	ret
.asm_2e53
	ld hl, $c590
.asm_2e56
	call Func_2cc8
.asm_2e59
	ld a, [$ff90]
	ld b, a
	ld a, [$ce47]
	inc a
	cp $3
	jr nc, .asm_2e6d
	bit 1, b
	jr nz, .asm_2e70
	jr .asm_2e6d
.asm_2e6a
	call Func_053f
.asm_2e6d
	dec a
	jr nz, .asm_2e6a
.asm_2e70
	call Func_2d43
	jr nc, .asm_2e59
	ret

Func_2e76: ; 2e76 (0:2e76)
	ld a, [$ff80]
	push af
	call ReadTextOffset
	call Func_2cc8
.asm_2e7f
	call Func_2d43
	jr nc, .asm_2e7f
	pop af
	call BankswitchHome
	ret

Func_2e89: ; 2e89 (0:2e89)
	ld a, l
	or h
	jr z, .asm_2e9f
	ld a, [$ff80]
	push af
	call ReadTextOffset
.asm_2e93
	ld a, [hli]
	ld [de], a
	inc de
	or a
	jr nz, .asm_2e93
	pop af
	call BankswitchHome
	dec de
	ret
.asm_2e9f
	ld a, [$ff97]
	cp $c3
	jp z, Func_1c8e
	jp Func_1c7d
; 0x2ea9

INCBIN "baserom.gbc",$2ea9,$302c - $2ea9

Func_302c: ; 302c (0:302c)
	push hl
	ld l, a
	ld h, $0
	ld a, [$ff80]
	push af
	ld a, BANK(Unknown_30000)
	call BankswitchHome
	add hl, hl
	ld de, Unknown_30000
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, d
	or e
	jr z, .asm_304e
	call Func_1072
	pop af
	call BankswitchHome
	pop hl
	or a
	ret
.asm_304e
	pop af
	call BankswitchHome
	pop hl
	scf
	ret
; 0x3055

INCBIN "baserom.gbc",$3055,$307f - $3055

Unknown_307f: ; 307f (0:307f)
INCBIN "baserom.gbc",$307f,$3189 - $307f

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
	farcall Func_f4000
	ret

Func_3784: ; 3784 (0:3784)
	xor a
Func_3785: ; 3785 (0:3785)
	farcall Func_f4006
	ret

Func_378a: ; 378a (0:378a)
	farcall Func_f400f
	ret

Func_378f: ; 378f (0:378f)
	farcall Func_f4012
	ret

Func_3794: ; 3794 (0:3794)
	ld a, $04
Func_3796: ; 3796 (0:3796)
	farcall Func_f4009
	ret

Func_379b: ; 379b (0:379b)
	farcall Func_f401b
	ret

Func_37a0: ; 37a0 (0:37a0)
	farcall Func_f401e
	ret
; 0x37a5

INCBIN "baserom.gbc",$37a5,$380e - $37a5

Func_380e: ; 380e (0:380e)
	ld a, [$d0c1]
	bit 7, a
	ret nz
	ld a, [$ff80]
	push af
	ld a, BANK(Func_c484)
	call BankswitchHome
	call Func_c484
	call Func_c554
	ld a, BANK(Func_1c610)
	call BankswitchHome
	call Func_1c610
	call Func_3cb4
	ld a, BANK(Func_804d8)
	call BankswitchHome
	call Func_804d8
	call Func_089b
	pop af
	call BankswitchHome
	ret

Func_383d: ; 383d (0:383d)
	ld a, $1
	ld [$cac4], a
	ld a, [$ff80]
	push af
.asm_3845
	call Func_3855
	jr nc, .asm_3850
	farcall LoadMap
	jr .asm_3845
.asm_3850
	pop af
	call BankswitchHome
	ret

Func_3855: ; 3855 (0:3855)
	ld a, [$d0b5]
	cp $7
	jr c, .asm_385e
	ld a, $6
.asm_385e
	ld hl, PointerTable_3864
	jp JumpToFunctionInTable

PointerTable_3864: ; 3864 (0:3864)
	dw Func_3874
	dw Func_38c0
	dw Func_38a3
	dw Func_3876
	dw Func_3911
	dw Func_38fb
	dw Func_38db
	dw Func_3874

Func_3874: ; 3874 (0:3874)
	scf
	ret

Func_3876: ; 3876 (0:3876)
	ld a, [$ff80]
	push af
	call Func_379b
	ld a, $8
	call Func_3785
	ld a, $3
	ld [$d0c2], a
	ld a, [$d10e]
	or $10
	ld [$d10e], a
	farcall Func_b177
	ld a, [$d10e]
	and $ef
	ld [$d10e], a
	call Func_37a0
	pop af
	call BankswitchHome
	scf
	ret

Func_38a3: ; 38a3 (0:38a3)
	ld a, $2
	ld [$d0c2], a
	xor a
	ld [$d112], a
	ld a, $ff
	ld [$d0c3], a
	ld a, $2
	ld [$cc1a], a
	ld a, $8
	call Func_3785
	bank1call Func_758f
	scf
	ret

Func_38c0: ; 38c0 (0:38c0)
	ld a, $1
	ld [$d0c2], a
	xor a
	ld [$d112], a
	call Func_07b6
	xor a
	ld [$ba44], a
	call Func_07be
	call Func_3a3b
	bank1call Func_409f
	scf
	ret

Func_38db: ; 38db (0:38db)
	ld a, $6
	ld [$d111], a
	call Func_39fc
	call Func_07b6
	xor a
	ld [$ba44], a
	call Func_07be
asm_38ed
	farcall Func_131d3
	ld a, $9
	ld [$d111], a
	call Func_39fc
	scf
	ret

Func_38fb: ; 38fb (0:38fb)
	xor a
	ld [$d112], a
	bank1call Func_406f
	call Func_07b6
	ld a, [$ba44]
	call Func_07be
	cp $ff
	jr z, asm_38ed
	scf
	ret

Func_3911: ; 3911 (0:3911)
	farcall Func_1d6ad
	or a
	ret
; 0x3917

INCBIN "baserom.gbc",$3917,$3927 - $3917

Func_3927: ; 3927 (0:3927)
	push hl
	call Func_3946
	ld a, [hl]
	pop hl
	ret
; 0x392e

INCBIN "baserom.gbc",$392e,$3946 - $392e

Func_3946: ; 3946 (0:3946)
	push bc
	srl b
	srl c
	swap c
	ld a, c
	and $f0
	or b
	ld c, a
	ld b, $0
	ld hl, $d133
	add hl, bc
	pop bc
	ret

Func_395a: ; 395a (0:395a)
	ld a, [$ff80]
	push af
	ld a, [$d4c6]
	call BankswitchHome
	call Func_070c
	pop af
	call BankswitchHome
	ret

Unknown_396b: ; 396b (0:396b)
INCBIN "baserom.gbc",$396b,$3973 - $396b

Unknown_3973: ; 3973 (0:3973)
INCBIN "baserom.gbc",$3973,$397b - $3973

Unknown_397b: ; 397b (0:397b)
INCBIN "baserom.gbc",$397b,$3997 - $397b

Func_3997: ; 3997 (0:3997)
	ld a, [$ff80]
	push af
	ld a, BANK(Func_1c056)
	call BankswitchHome
	call Func_1c056
	pop af
	call BankswitchHome
	ret
; 0x39a7

INCBIN "baserom.gbc",$39a7,$39ad - $39a7

Func_39ad: ; 39ad (0:39ad)
	push bc
	cp $8
	jr c, .asm_39b4
	rst $38
	xor a
.asm_39b4
	add a
	add a
	ld h, a
	add a
	add h
	add l
	ld l, a
	ld h, $0
	ld bc, $d34a
	add hl, bc
	pop bc
	ret

Func_39c3: ; 39c3 (0:39c3)
	push hl
	push bc
	push de
	xor a
	ld [$d3aa], a
	ld b, a
	ld c, $8
	ld de, $000c
	ld hl, $d34a
	ld a, [$d3ab]
.asm_39d6
	cp [hl]
	jr z, .asm_39e1
	add hl, de
	inc b
	dec c
	jr nz, .asm_39d6
	scf
	jr z, .asm_39e6
.asm_39e1
	ld a, b
	ld [$d3aa], a
	or a
.asm_39e6
	pop de
	pop bc
	pop hl
	ret
; 0x39ea

INCBIN "baserom.gbc",$39ea,$39fc - $39ea

Func_39fc: ; 39fc (0:39fc)
	push hl
	push bc
	call Func_378a
	or a
	push af
	call Func_3a1f
	ld c, a
	pop af
	jr z, .asm_3a11
	ld a, c
	ld hl, $d112
	cp [hl]
	jr z, .asm_3a1c
.asm_3a11
	ld a, c
	cp $1f
	jr nc, .asm_3a1c
	ld [$d112], a
	call Func_3785
.asm_3a1c
	pop bc
	pop hl
	ret

Func_3a1f: ; 3a1f (0:3a1f)
	ld a, [$d3b8]
	or a
	jr z, .asm_3a37
	ld a, [$d32e]
	cp $2
	jr z, .asm_3a37
	cp $b
	jr z, .asm_3a37
	cp $c
	jr z, .asm_3a37
	ld a, $f
	ret
.asm_3a37
	ld a, [$d111]
	ret

Func_3a3b: ; 3a3b (0:3a3b)
	farcall Func_1124d
	ret

Func_3a40: ; 3a40 (0:3a40)
	farcall Func_11430
	ret
; 0x3a45

INCBIN "baserom.gbc",$3a45,$3a5e - $3a45

Func_3a5e: ; 3a5e (0:3a5e)
	ld a, [$ff80]
	push af
	ld l, $4
	call Func_3abd
	jr nc, .asm_3ab3
	ld a, BANK(Func_c653)
	call BankswitchHome
	call Func_c653
	ld a, $4
	call BankswitchHome
	ld a, [$d334]
	ld d, a
.asm_3a79
	ld a, [hli]
	bit 7, a
	jr nz, .asm_3ab3
	push bc
	push hl
	cp d
	jr nz, .asm_3aab
	ld a, [hli]
	cp b
	jr nz, .asm_3aab
	ld a, [hli]
	cp c
	jr nz, .asm_3aab
	ld a, [hli]
	ld [$d0c6], a
	ld a, [hli]
	ld [$d0c7], a
	ld a, [hli]
	ld [$d0ca], a
	ld a, [hli]
	ld [$d0cb], a
	ld a, [hli]
	ld [$d0c8], a
	ld a, [hli]
	ld [$d0c9], a
	pop hl
	pop bc
	pop af
	call BankswitchHome
	scf
	ret
.asm_3aab
	pop hl
	ld bc, $0008
	add hl, bc
	pop bc
	jr .asm_3a79
.asm_3ab3
	pop af
	call BankswitchHome
	ld l, $6
	call $49c2
	ret

Func_3abd: ; 3abd (0:3abd)
	push bc
	push hl
	ld a, [wCurMap]
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, MapHeaders
	add hl, bc
	pop bc
	ld b, $0
	add hl, bc
	ld a, [$ff80]
	push af
	ld a, BANK(MapHeaders)
	call BankswitchHome
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	call BankswitchHome
	ld a, l
	or h
	jr nz, .asm_3ae5
	scf
.asm_3ae5
	ccf
	pop bc
	ret
; 0x3ae8

INCBIN "baserom.gbc",$3ae8,$3aed - $3ae8

Func_3aed: ; 3aed (0:3aed)
	ld hl, $d413
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld c, [hl]
	inc hl
	ld b, [hl]
	push bc
	rlca
	ld c, a
	ld b, $0
	ld hl, Unknown_1217b
	add hl, bc
	ld a, [$ff80]
	push af
	ld a, BANK(Unknown_1217b)
	call BankswitchHome
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	call BankswitchHome
	pop bc
	jp [hl]
; 0x3b11

INCBIN "baserom.gbc",$3b11,$3bd2 - $3b11

Func_3bd2: ; 3bd2 (0:3bd2)
	ld a, l
	ld [$cad3], a
	ld a, h
	ld [$cad4], a
	ret

Func_3bdb: ; 3bdb (0:3bdb)
	push hl
	ld hl, $0000
	call Func_3bd2
	pop hl
	ret
; 0x3be4

INCBIN "baserom.gbc",$3be4,$3bf5 - $3be4

Func_3bf5: ; 3bf5 (0:3bf5)
	ld a, [$ff80]
	push af
	push hl
	ld a, [$d4c6]
	call BankswitchHome
	ld a, [$d4c4]
	ld l, a
	ld a, [$d4c5]
	ld h, a
	call CopyData_SaveRegisters
	pop hl
	pop af
	call BankswitchHome
	ret
; 0x3c10

INCBIN "baserom.gbc",$3c10,$3c45 - $3c10

Func_3c45: ; 3c45 (0:3c45)
	jp [hl]
; 0x3c46

INCBIN "baserom.gbc",$3c46,$3c48 - $3c46

Func_3c48: ; 3c48 (0:3c48)
	push af
	ld a, [$ff40]
	bit 7, a
	jr z, .asm_3c58
	push bc
	push de
	push hl
	call Func_053f
	pop hl
	pop de
	pop bc
.asm_3c58
	pop af
	ret

Func_3c5a: ; 3c5a (0:3c5a)
	ld hl, $0000
	rl c
	rl b
	ld a, $10
.asm_3c63
	ld [$ffb6], a
	rl l
	rl h
	push hl
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ccf
	jr nc, .asm_3c78
	ld h, a
	add sp, $2
	scf
	jr .asm_3c79
.asm_3c78
	pop hl
.asm_3c79
	rl c
	rl b
	ld a, [$ffb6]
	dec a
	jr nz, .asm_3c63
	ret
; 0x3c83

INCBIN "baserom.gbc",$3c83,$3ca0 - $3c83

Func_3ca0: ; 3ca0 (0:3ca0)
	xor a
	ld [$d5d7], a
	ld a, [$ff80]
	push af
	ld a, BANK(Func_1296e)
	call BankswitchHome
	call Func_1296e
	pop af
	call BankswitchHome
	ret

Func_3cb4: ; 3cb4 (0:3cb4)
	ld a, [$ff80]
	push af
	ld a, BANK(Func_12a21)
	call BankswitchHome
	call Func_12a21
	pop af
	call BankswitchHome
	ret
; 0x3cc4

INCBIN "baserom.gbc",$3cc4,$3d72 - $3cc4

Func_3d72: ; 3d72 (0:3d72)
	ld a, [$ff80]
	push af
	push hl
	push hl
	ld a, [$d4ca]
	cp $ff
	jr nz, .asm_3d84
	ld de, Unknown_80e5a
	xor a
	jr .asm_3da1
.asm_3d84
	ld a, [$d4c4]
	ld l, a
	ld a, [$d4c5]
	ld h, a
	ld a, [$d4c6]
	call BankswitchHome
	ld a, [hli]
	push af
	ld a, [$d4ca]
	rlca
	ld e, [hl]
	add e
	ld e, a
	inc hl
	ld a, [hl]
	adc $0
	ld d, a
	pop af
.asm_3da1
	add BANK(Unknown_80e5a)
	pop hl
	ld bc, $000b
	add hl, bc
	ld [hli], a
	call BankswitchHome
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	pop hl
	pop af
	call BankswitchHome
	ret

Func_3db7: ; 3db7 (0:3db7)
	push bc
	ld c, $0
	call Func_3dbf
	pop bc
	ret

Func_3dbf: ; 3dbf (0:3dbf)
	ld a, [$d4cf]
	cp $10
	jr c, .asm_3dc9
	rst $38
	ld a, $f
.asm_3dc9
	push bc
	swap a
	push af
	and $f
	ld b, a
	pop af
	and $f0
	or c
	ld c, a
	ld hl, $d4d0
	add hl, bc
	pop bc
	ret
; 0x3ddb

INCBIN "baserom.gbc",$3ddb,$3fe0 - $3ddb

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

rept $a
db $ff
endr