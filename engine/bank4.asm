INCBIN "baserom.gbc",$10000,$10059 - $10000

Func_10059: ; 10059 (4:4059)
INCBIN "baserom.gbc",$10059,$100a2 - $10059

Func_100a2: ; 100a2 (4:40a2)
INCBIN "baserom.gbc",$100a2,$103d2 - $100a2

Func_103d2: ; 103d2 (4:43d2)
INCBIN "baserom.gbc",$103d2,$103d3 - $103d2

Func_103d3: ; 103d3 (4:43d3)
INCBIN "baserom.gbc",$103d3,$10548 - $103d3

Func_10548: ; 10548 (4:4548)
INCBIN "baserom.gbc",$10548,$10756 - $10548

Func_10756: ; 10756 (4:4756)
INCBIN "baserom.gbc",$10756,$10a9b - $10756

Func_10a9b: ; 10a9b (4:4a9b)
INCBIN "baserom.gbc",$10a9b,$10ab4 - $10a9b

Func_10ab4: ; 10ab4 (4:4ab4)
INCBIN "baserom.gbc",$10ab4,$10af9 - $10ab4

Func_10af9: ; 10af9 (4:4af9)
INCBIN "baserom.gbc",$10af9,$10e28 - $10af9

Func_10e28: ; 10e28 (4:4e28)
INCBIN "baserom.gbc",$10e28,$10e55 - $10e28

Func_10e55: ; 10e55 (4:4e55)
	ld a, [$d336]
	ld [$d4cf], a
	ld a, [$d33e]
	or a
	jr nz, .asm_10e65
	call Func_10e71
	ret
.asm_10e65
	cp $2
	jr z, .asm_10e6d
	call Func_11060
	ret
.asm_10e6d
	call LoadOverworldMapSelection
	ret

Func_10e71: ; 10e71 (4:4e71)
	ld a, [$ff91]
	and $f0
	jr z, .asm_10e83
	farcall Func_c5d5
	ld [$d334], a
	call Func_10e97
	jr .asm_10e96
.asm_10e83
	ld a, [$ff91]
	and $1
	jr z, .asm_10e96
	ld a, $2
	call Func_3796
	call Func_11016
	call Func_11024
	jr .asm_10e96
.asm_10e96
	ret

Func_10e97: ; 10e97 (4:4e97)
	push hl
	pop hl
	ld a, [$d32e]
	rlca
	rlca
	ld c, a
	ld a, [$d334]
	add c
	ld c, a
	ld b, $0
	ld hl, Unknown_10ebc
	add hl, bc
	ld a, [hl]
	or a
	jr z, .asm_10eb9
	ld [$d32e], a
	call Func_10f2e
	ld a, $1
	call Func_3796
.asm_10eb9
	pop bc
	pop hl
	ret

Unknown_10ebc: ; 10ebc (4:4ebc)
INCBIN "baserom.gbc",$10ebc,$10efd - $10ebc

Func_10efd: ; 10efd (4:4efd)
	push hl
	push de
	rlca
	ld e, a
	ld d, $0
	ld hl, Unknown_10f14
	add hl, de
	pop de
	ld a, [hli]
	add $8
	add d
	ld d, a
	ld a, [hl]
	add $10
	add e
	ld e, a
	pop hl
	ret

Unknown_10f14: ; 10f14 (4:4f14)
INCBIN "baserom.gbc",$10f14,$10f2e - $10f14

Func_10f2e: ; 10f2e (4:4f2e)
	push hl
	push de
	ld de, $0101
	call Func_22ae
	call Func_10f4a
	rlca
	ld e, a
	ld d, $0
	ld hl, Unknown_397b
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_2c29
	pop de
	pop hl
	ret

Func_10f4a: ; 10f4a (4:4f4a)
	push bc
	ld a, [$d32e]
	cp $2
	jr nz, .asm_10f5f
	ld c, a
	ld a, $1e
	farcall Func_ca6c
	or a
	ld a, c
	jr nz, .asm_10f5f
	ld a, $d
.asm_10f5f
	pop bc
	ret

LoadOverworldMapSelection: ; 10f61 (4:4f61)
	push hl
	push bc
	ld a, [$d32e]
	rlca
	rlca
	ld c, a
	ld b, $0
	ld hl, OverworldMapIndexes
	add hl, bc
	ld a, [hli]
	ld [$d0bb], a
	ld a, [hli]
	ld [$d0bc], a
	ld a, [hli]
	ld [$d0bd], a
	ld a, $0
	ld [$d0be], a
	ld hl, $d0b4
	set 4, [hl]
	pop bc
	pop hl
	ret

INCLUDE "data/overworld_indexes.asm"

Func_10fbc: ; 10fbc (4:4fbc)
	ld a, $25
	farcall Func_1299f
	ld c, $2
	call Func_3dbf
	ld a, $80
	ld [hli], a
	ld a, $10
	ld [hl], a
	ld b, $34
	ld a, [$cab4]
	cp $2
	jr nz, .asm_10fd8
	ld b, $37
.asm_10fd8
	ld a, b
	farcall Func_12ab5
	ret

Func_10fde: ; 10fde (4:4fde)
	ld a, [$d32e]
	ld [$d33d], a
	xor a
	ld [$d33e], a
	ld a, $25
	call Func_1299f
	ld a, [$d4cf]
	ld [$d33b], a
	ld b, $35
	ld a, [$cab4]
	cp $2
	jr nz, .asm_10ffe
	ld b, $38
.asm_10ffe
	ld a, b
	ld [$d33c], a
	call Func_12ab5
	ld a, $3e
	farcall Func_ca6c
	or a
	jr nz, .asm_11015
	ld c, $f
	call Func_3dbf
	set 7, [hl]
.asm_11015
	ret

Func_11016: ; 11016 (4:5016)
	ld a, [$d33b]
	ld [$d4cf], a
	ld a, [$d33c]
	inc a
	call Func_12ab5
	ret

Func_11024: ; 11024 (4:5024)
	ld a, $57
	call Func_3796
	ld a, [$d336]
	ld [$d4cf], a
	ld c, $f
	call Func_3dbf
	set 2, [hl]
	ld hl, Unknown_1229f
	ld a, [$d33d]
	dec a
	add a
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [$d32e]
	dec a
	add a
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hli]
	ld [$d33f], a
	ld a, [hl]
	ld [$d340], a
	ld a, $1
	ld [$d33e], a
	xor a
	ld [$d341], a
	ret

Func_11060: ; 11060 (4:5060)
	ld a, [$d336]
	ld [$d4cf], a
	ld a, [$d341]
	or a
	jp nz, Func_11184
	ld a, [$d33f]
	ld l, a
	ld a, [$d340]
	ld h, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	and b
	cp $ff
	jr z, .asm_110a0
	ld a, c
	or b
	jr nz, .asm_11094
	ld a, [$d33d]
	ld e, a
	ld a, [$d32e]
	cp e
	jr z, .asm_110a0
	ld de, $0000
	call Func_10efd
	ld b, d
	ld c, e
.asm_11094
	ld a, l
	ld [$d33f], a
	ld a, h
	ld [$d340], a
	call Func_110a6
	ret
.asm_110a0
	ld a, $2
	ld [$d33e], a
	ret

Func_110a6: ; 110a6 (4:50a6)
	push hl
	push bc
	ld c, $2
	call Func_3dbf
	pop bc
	ld a, b
	sub [hl]
	ld [$d343], a
	ld a, $0
	sbc $0
	ld [$d344], a
	inc hl
	ld a, c
	sub [hl]
	ld [$d345], a
	ld a, $0
	sbc $0
	ld [$d346], a
	ld a, [$d343]
	ld b, a
	ld a, [$d344]
	bit 7, a
	jr z, .asm_110d8
	ld a, [$d343]
	cpl
	inc a
	ld b, a
.asm_110d8
	ld a, [$d345]
	ld c, a
	ld a, [$d346]
	bit 7, a
	jr z, .asm_110e9
	ld a, [$d345]
	cpl
	inc a
	ld c, a
.asm_110e9
	ld a, b
	cp c
	jr c, .asm_110f2
	call Func_11102
	jr .asm_110f5
.asm_110f2
	call Func_1113e
.asm_110f5
	xor a
	ld [$d347], a
	ld [$d348], a
	farcall Func_c5e9
	pop hl
	ret

Func_11102: ; 11102 (4:5102)
	ld a, b
	ld [$d341], a
	ld e, a
	ld d, $0
	ld hl, $d343
	xor a
	ld [hli], a
	bit 7, [hl]
	jr z, .asm_11115
	dec a
	jr .asm_11116
.asm_11115
	inc a
.asm_11116
	ld [hl], a
	ld b, c
	ld c, $0
	call Func_3c5a
	ld a, [$d346]
	bit 7, a
	jr z, .asm_11127
	call Func_11179
.asm_11127
	ld a, c
	ld [$d345], a
	ld a, b
	ld [$d346], a
	ld hl, $d344
	ld a, $1
	bit 7, [hl]
	jr z, .asm_1113a
	ld a, $3
.asm_1113a
	ld [$d334], a
	ret

Func_1113e: ; 1113e (4:513e)
	ld a, c
	ld [$d341], a
	ld e, a
	ld d, $0
	ld hl, $d345
	xor a
	ld [hli], a
	bit 7, [hl]
	jr z, .asm_11151
	dec a
	jr .asm_11152
.asm_11151
	inc a
.asm_11152
	ld [hl], a
	ld c, $0
	call Func_3c5a
	ld a, [$d344]
	bit 7, a
	jr z, .asm_11162
	call Func_11179
.asm_11162
	ld a, c
	ld [$d343], a
	ld a, b
	ld [$d344], a
	ld hl, $d346
	ld a, $2
	bit 7, [hl]
	jr z, .asm_11175
	ld a, $0
.asm_11175
	ld [$d334], a
	ret

Func_11179: ; 11179 (4:5179)
	ld a, c
	cpl
	add $1
	ld c, a
	ld a, b
	cpl
	adc $0
	ld b, a
	ret

Func_11184: ; 11184 (4:5184)
	ld a, [$d347]
	ld d, a
	ld a, [$d348]
	ld e, a
	ld c, $2
	call Func_3dbf
	ld a, [$d343]
	add d
	ld d, a
	ld a, [$d344]
	adc [hl]
	ld [hl], a
	inc hl
	ld a, [$d345]
	add e
	ld e, a
	ld a, [$d346]
	adc [hl]
	ld [hl], a
	ld a, d
	ld [$d347], a
	ld a, e
	ld [$d348], a
	ld hl, $d341
	dec [hl]
	ret
; 0x111b3

INCBIN "baserom.gbc",$111b3,$111e9 - $111b3

Func_111e9: ; 111e9 (4:51e9)
INCBIN "baserom.gbc",$111e9,$1124d - $111e9

Func_1124d: ; 1124d (4:524d)
INCBIN "baserom.gbc",$1124d,$11320 - $1124d

Func_11320: ; 11320 (4:5320)
INCBIN "baserom.gbc",$11320,$11416 - $11320

Func_11416: ; 11416 (4:5416)
INCBIN "baserom.gbc",$11416,$11430 - $11416

Func_11430: ; 11430 (4:5430)
INCBIN "baserom.gbc",$11430,$1162a - $11430

INCLUDE "data/map_scripts.asm"

INCBIN "baserom.gbc",$1184a,$11857 - $1184a

Func_11857: ; 11857 (4:5857)
INCBIN "baserom.gbc",$11857,$1217b - $11857

Unknown_1217b: ; 1217b (4:617b)
INCBIN "baserom.gbc",$1217b,$1229f - $1217b

Unknown_1229f: ; 1229f (4:629f)
INCBIN "baserom.gbc",$1229f,$126d1 - $1229f

Func_126d1: ; 126d1 (4:66d1)
	call Func_099c
	ld hl, $cac0
	inc [hl]
	farcall Func_70018
	ld a, $ff
	ld [$d627], a
.asm_126e1
	ld a, $c2
	ld [$ff97], a
	farcall Func_c1f8
	farcall Func_1d078
	ld a, [$d628]
	ld hl, PointerTable_126fc
	call JumpToFunctionInTable
	jr c, .asm_126e1
	jr Func_126d1

	scf
	ret

PointerTable_126fc
	dw Func_12768
	dw Func_12741
	dw Func_12704
	dw Func_1277e

Func_12704: ; 12704 (4:6704)
	farcall Func_c1b1
	call Func_128a9
	farcall Func_1996e
	call Func_07b6
	ld a, [$a007]
	ld [$d421], a
	ld a, [$a006]
	ld [$ce47], a
	call Func_07be
	ld a, $0
	call Func_3785
	farcall Func_70000
	ld a, $9
	ld [$d111], a
	call Func_39fc
	farcall Func_1d306
	ld a, $0
	ld [$d0b5], a
	farcallx $03, Func_383d
	or a
	ret

Func_12741: ; 12741 (4:6741)
	ld a, $0
	call Func_3785
	call Func_11320
	jr nc, Func_12704
	farcall Func_c1ed
	farcall Func_70000
	call Func_07b6
	xor a
	ld [$ba44], a
	call Func_07be
	ld a, $0
	ld [$d0b5], a
	farcallx $03, Func_383d
	or a
	ret

Func_12768: ; 12768 (4:6768)
	ld a, $8
	call Func_3785
	bank1call Func_7571
	farcall Func_c1a4
	call Func_3c48
	ld a, $0
	call Func_3785
	scf
	ret

Func_1277e: ; 1277e (4:677e)
	ld a, $0
	call Func_3785
	farcall Func_c9cb
	farcallx $04, Func_3a40
	farcall Func_70000
	ld a, $5
	ld [$d0b5], a
	farcallx $03, Func_383d
	or a
	ret
; 0x1279a

INCBIN "baserom.gbc",$1279a,$12871 - $1279a

Func_12871: ; 12871 (4:6871)
INCBIN "baserom.gbc",$12871,$1288c - $12871

Func_1288c: ; 1288c (4:688c)
INCBIN "baserom.gbc",$1288c,$128a9 - $1288c

Func_128a9: ; 128a9 (4:68a9)
INCBIN "baserom.gbc",$128a9,$1296e - $128a9

Func_1296e: ; 1296e (4:696e)
INCBIN "baserom.gbc",$1296e,$1299f - $1296e

Func_1299f: ; 1299f (4:699f)
	push af
	ld a, [$d5d7]
	or a
	jr z, .asm_129a8
	pop af
	ret
.asm_129a8
	pop af
	push bc
	push hl
	call Func_12c05
	ld [$d5d3], a
	xor a
	ld [$d4cf], a
	call Func_3db7
	ld bc, $0010
.asm_129bb
	ld a, [hl]
	or a
	jr z, .asm_129cf
	add hl, bc
	ld a, [$d4cf]
	inc a
	ld [$d4cf], a
	cp $10
	jr nz, .asm_129bb
	rst $38
	scf
	jr .asm_129d6
.asm_129cf
	ld a, $1
	ld [hl], a
	call Func_129d9
	or a
.asm_129d6
	pop hl
	pop bc
	ret

Func_129d9: ; 129d9 (4:69d9)
	push hl
	push bc
	push hl
	inc hl
	ld c, $f
	xor a
.asm_129e0
	ld [hli], a
	dec c
	jr nz, .asm_129e0
	pop hl
	ld bc, $0004
	add hl, bc
	ld a, [$d5d3]
	ld [hli], a
	ld a, $ff
	ld [hl], a
	ld bc, $0009
	add hl, bc
	ld a, $ff
	ld [hl], a
	pop bc
	pop hl
	ret
; 0x129fa

INCBIN "baserom.gbc",$129fa,$12a21 - $129fa

Func_12a21: ; 12a21 (4:6a21)
INCBIN "baserom.gbc",$12a21,$12ab5 - $12a21

Func_12ab5: ; 12ab5 (4:6ab5)
	push hl
	push af
	ld c, $5
	call Func_3dbf
	pop af
	cp [hl]
	pop hl
	ret z
	push hl
	call Func_12ae2
	call Func_12b13
	pop hl
	ret
; 0x12ac9

INCBIN "baserom.gbc",$12ac9,$12ae2 - $12ac9

Func_12ae2: ; 12ae2 (4:6ae2)
	push bc
	push af
	call Func_3db7
	pop af
	push hl
	ld bc, $0005
	add hl, bc
	ld [hli], a
	push hl
	ld l, $6
	farcall Func_8020f
	farcall Func_80229
	pop hl
	ld a, [$d4c6]
	ld [hli], a
	ld a, [$d4c4]
	ld [hli], a
	ld c, a
	ld a, [$d4c5]
	ld [hli], a
	ld b, a
	ld a, $3
	add c
	ld [hli], a
	ld a, $0
	adc b
	ld [hli], a
	pop hl
	pop bc
	ret

Func_12b13: ; 12b13 (4:6b13)
	push bc
	push de
	push hl
.asm_12b16
	push hl
	ld bc, $0006
	add hl, bc
	ld a, [hli]
	ld [$d4c6], a
	inc hl
	inc hl
	ld a, [hl]
	ld [$d4c4], a
	add $4
	ld [hli], a
	ld a, [hl]
	ld [$d4c5], a
	adc $0
	ld [hl], a
	ld de, $d23e
	ld bc, $0004
	call Func_3bf5
	pop hl
	ld de, $d23e
	ld a, [de]
	call Func_12b6a
	inc de
	ld a, [de]
	call Func_12b89
	jr c, .asm_12b16
	inc de
	ld bc, $0002
	add hl, bc
	push hl
	ld bc, $000d
	add hl, bc
	ld b, [hl]
	pop hl
	ld a, [de]
	bit 0, b
	jr z, .asm_12b5a
	cpl
	inc a
.asm_12b5a
	add [hl]
	ld [hli], a
	inc de
	ld a, [de]
	bit 1, b
	jr z, .asm_12b64
	cpl
	inc a
.asm_12b64
	add [hl]
	ld [hl], a
	pop hl
	pop de
	pop bc
	ret

Func_12b6a: ; 12b6a (4:6b6a)
	ld [$d4ca], a
	push hl
	push bc
	push de
	push hl
	ld bc, $0006
	add hl, bc
	ld a, [hli]
	ld [$d4c6], a
	ld a, [hli]
	ld [$d4c4], a
	ld a, [hli]
	ld [$d4c5], a
	pop hl
	call Func_3d72
	pop de
	pop bc
	pop hl
	ret

Func_12b89: ; 12b89 (4:6b89)
	push hl
	push bc
	ld bc, $000e
	add hl, bc
	ld [hl], a
	or a
	jr nz, .asm_12ba4
	ld bc, $fff9
	add hl, bc
	ld a, [hli]
	add $3
	ld c, a
	ld a, [hli]
	adc $0
	ld b, a
	ld a, c
	ld [hli], a
	ld a, b
	ld [hl], a
	scf
.asm_12ba4
	pop bc
	pop hl
	ret

Func_12ba7: ; 12ba7 (4:6ba7)
INCBIN "baserom.gbc",$12ba7,$12bcd - $12ba7

Func_12bcd: ; 12bcd (4:6bcd)
INCBIN "baserom.gbc",$12bcd,$12c05 - $12bcd

Func_12c05: ; 12c05 (4:6c05)
	push hl
	push bc
	push de
	ld b, a
	ld d, $0
	ld a, [$d618]
	ld c, a
	ld hl, $d5d8
	or a
	jr z, .asm_12c22
.asm_12c15
	inc hl
	ld a, [hl]
	cp b
	jr z, .asm_12c3a
	inc hl
	ld a, [hli]
	add [hl]
	ld d, a
	inc hl
	dec c
	jr nz, .asm_12c15
.asm_12c22
	ld a, [$d618]
	cp $10
	jr nc, .asm_12c48
	inc a
	ld [$d618], a
	inc hl
	push hl
	ld a, b
	ld [hli], a
	call Func_12c4f
	push af
	ld a, d
	ld [hli], a
	pop af
	ld [hl], a
	pop hl
.asm_12c3a
	dec hl
	inc [hl]
	inc hl
	inc hl
	ld a, [hli]
	add [hl]
	cp $81
	jr nc, .asm_12c48
	ld a, d
	or a
	jr .asm_12c4b
.asm_12c48
	rst $38
	xor a
	scf
.asm_12c4b
	pop de
	pop bc
	pop hl
	ret

Func_12c4f: ; 12c4f (4:6c4f)
	push af
	xor a
	ld [$d4cb], a
	ld a, d
	ld [$d4ca], a
	pop af
	farcall Func_8025b
	ret

Func_12c5e: ; 12c5e (4:6c5e)
INCBIN "baserom.gbc",$12c5e,$131b3 - $12c5e

Func_131b3: ; 131b3 (4:71b3)
INCBIN "baserom.gbc",$131b3,$131d3 - $131b3

Func_131d3: ; 131d3 (4:71d3)
INCBIN "baserom.gbc",$131d3,$14000 - $131d3