LoadMap: ; c000 (3:4000)
	call Func_028a
	call Func_07b6
	bank1call Func_6785
	call Func_07be
	ld a, $0
	ld [$d0b5], a
	xor a
	ld [$d10f], a
	ld [$d110], a
	ld [$d113], a
	farcall Func_10a9b
	call Func_c1a4
	call Func_099c
	xor a
	ld [$cab6], a
	call Func_2119
	call Func_02b9
	xor a
	ld [$cd08], a
	xor a
	ld [$d291], a
.asm_c037
	farcall Func_10ab4
	call Func_c1a4
	call Func_c241
	call Func_04a2
	call Func_3ca0
	ld a, $c2
	ld [$ff97], a
	farcall Func_1c440
	ld a, [$d0bb]
	ld [wCurMap], a
	ld a, [$d0bc]
	ld [wPlayerXCoord], a
	ld a, [$d0bd]
	ld [wPlayerYCoord], a
	call Func_c36a
	call Func_c184
	call Func_c49c
	farcall Func_80000
	call Func_c4b9
	call Func_c943
	call Func_c158
	farcall Func_80480
	call Func_c199
	xor a
	ld [$d0b4], a
	ld [$d0c1], a
	call Func_39fc
	farcall Func_10af9
	call Func_c141
	call Func_c17a
.asm_c092
	call Func_3c48
	call Func_c491
	call Func_c0ce
	ld hl, $d0b4
	ld a, [hl]
	and $d0
	jr z, .asm_c092
	call Func_3c48
	ld hl, $d0b4
	ld a, [hl]
	bit 4, [hl]
	jr z, .asm_c0b6
	ld a, $c
	call Func_3796
	jp .asm_c037
.asm_c0b6
	farcall Func_10ab4
	call Func_c1a0
	ld a, [$d113]
	or a
	jr z, .asm_c0ca
	call Func_c280
	farcall Func_103d3
.asm_c0ca
	call Func_c280
	ret

Func_c0ce: ; c0ce (3:40ce)
	ld a, [$d0bf]
	res 7, a
	rlca
	add $e0
	ld l, a
	ld a, $40
	adc $0
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 0xc0e0

INCBIN "baserom.gbc",$c0e0,$c141 - $c0e0

Func_c141: ; c141 (3:4141)
	ld hl, $d0c2
	ld a, [hl]
	or a
	ret z
	push af
	xor a
	ld [hl], a
	pop af
	dec a
	ld hl, PointerTable_c152
	jp JumpToFunctionInTable

PointerTable_c152: ; c152 (3:4152)
	dw Func_c9bc
	dw Func_fc2b
	dw Func_fcad

Func_c158: ; c158 (3:4158)
INCBIN "baserom.gbc",$c158,$c17a - $c158

Func_c17a: ; c17a (3:417a)
INCBIN "baserom.gbc",$c17a,$c184 - $c17a

Func_c184: ; c184 (3:4184)
INCBIN "baserom.gbc",$c184,$c199 - $c184

Func_c199: ; c199 (3:4199)
INCBIN "baserom.gbc",$c199,$c1a0 - $c199

Func_c1a0: ; c1a0 (3:41a0)
INCBIN "baserom.gbc",$c1a0,$c1a4 - $c1a0

Func_c1a4: ; c1a4 (3:41a4)
INCBIN "baserom.gbc",$c1a4,$c1b1 - $c1a4

Func_c1b1: ; c1b1 (3:41b1)
INCBIN "baserom.gbc",$c1b1,$c1ed - $c1b1

Func_c1ed: ; c1ed (3:41ed)
INCBIN "baserom.gbc",$c1ed,$c1f8 - $c1ed

Func_c1f8: ; c1f8 (3:41f8)
INCBIN "baserom.gbc",$c1f8,$c241 - $c1f8

Func_c241: ; c241 (3:4241)
INCBIN "baserom.gbc",$c241,$c280 - $c241

Func_c280: ; c280 (3:4280)
INCBIN "baserom.gbc",$c280,$c36a - $c280

Func_c36a: ; c36a (3:436a)
	xor a
	ld [$d323], a
	ld a, [wCurMap]
	cp POKEMON_DOME_ENTRANCE
	jr nz, .asm_c379
	xor a
	ld [$d324], a
.asm_c379
	ret
; 0xc37a

INCBIN "baserom.gbc",$c37a,$c491 - $c37a

Func_c491: ; c491 (3:4491)
INCBIN "baserom.gbc",$c491,$c49c - $c491

Func_c49c: ; c49c (3:449c)
INCBIN "baserom.gbc",$c49c,$c4b9 - $c49c

Func_c4b9: ; c4b9 (3:44b9)
INCBIN "baserom.gbc",$c4b9,$c5d5 - $c4b9

Func_c5d5: ; c5d5 (3:45d5)
	push hl
	ld hl, Unknown_c5e5
	or a
	jr z, .asm_c5e2
.asm_c5dc
	rlca
	jr c, .asm_c5e2
	inc hl
	jr .asm_c5dc
.asm_c5e2
	ld a, [hl]
	pop hl
	ret

Unknown_c5e5: ; c5e5 (3:45e5)
	db $02,$00,$03,$01

Func_c5e9: ; c5e9 (3:45e9)
	push bc
	ld a, [$d336]
	ld [$d4cf], a
	ld a, [$d337]
	ld b, a
	ld a, [$d334]
	add b
	farcall Func_12ab5
	pop bc
	ret
; 0xc5fe

INCBIN "baserom.gbc",$c5fe,$c943 - $c5fe

Func_c943: ; c943 (3:4943)
INCBIN "baserom.gbc",$c943,$c9bc - $c943

Func_c9bc: ; c9bc (3:49bc)
INCBIN "baserom.gbc",$c9bc,$c9cb - $c9bc

Func_c9cb: ; c9cb (3:49cb)
INCBIN "baserom.gbc",$c9cb,$ca6c - $c9cb

Func_ca6c: ; ca6c (3:4a6c)
	push hl
	push bc
	call Func_cb1d
	ld c, [hl]
	ld a, [$d3d1]
.asm_ca75
	bit 0, a
	jr nz, .asm_ca7f
	srl a
	srl c
	jr .asm_ca75
.asm_ca7f
	and c
	pop bc
	pop hl
	or a
	ret
; 0xca84

INCBIN "baserom.gbc",$ca84,$cb1d - $ca84

Func_cb1d: ; cb1d (3:4b1d)
	push bc
	ld c, a
	ld b, $0
	sla c
	rl b
	ld hl, Unknown_cb37
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld [$d3d1], a
	ld b, $0
	ld hl, $d3d2
	add hl, bc
	pop bc
	ret

Unknown_cb37: ; cb37 (3:4b37)
INCBIN "baserom.gbc",$cb37,$cc42 - $cb37

RST20: ; cc42 (3:4c42)
	pop hl
	ld a, l
	ld [$d413], a
	ld a, h
	ld [$d414], a
	xor a
	ld [$d412], a
.asm_cc4f
	call Func_3aed
	ld a, [$d412]
	or a
	jr z, .asm_cc4f
	ld hl, $d413
	ld a, [hli]
	ld c, a
	ld b, [hl]
	push bc
	ret
; 0xcc60

INCBIN "baserom.gbc",$cc60,$fc2b - $cc60

Func_fc2b: ; fc2b (3:7c2b)
INCBIN "baserom.gbc",$fc2b,$fcad - $fc2b

Func_fcad: ; fcad (3:7cad)
INCBIN "baserom.gbc",$fcad,$10000 - $fcad