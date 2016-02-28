INCBIN "baserom.gbc",$8000,$8cd4 - $8000

Func_8cd4: ; 8cd4 (2:4cd4)
	push bc
	call EnableExtRAM
	ld b, $3c
.asm_8cda
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .asm_8cda
	xor a
	ld [hl], a
	call DisableExtRAM
	pop bc
	ret
; 0x8ce7

INCBIN "baserom.gbc",$8ce7,$8cf9 - $8ce7

Func_8cf9: ; 8cf9 (2:4cf9)
	call EnableExtRAM
	xor a
	ld hl, $b703
	ld [hli], a
	inc a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [$b701], a
	call DisableExtRAM
Func_8d0b: ; 8d0b (2:4d0b)
	ld hl, Unknown_8d15
	ld de, $9380
	call Func_92ad
	ret

Unknown_8d15: ; 8d15 (2:4d15)
INCBIN "baserom.gbc",$8d15,$8d56 - $8d15

Func_8d56: ; 8d56 (2:4d56)
	xor a
	ld [$cab6], a
	call Func_04a2
	call Func_099c
	ld a, $1
	ld [$cac0], a
	call Func_2119
	call Func_20b0
	call Func_8d0b
	bank1call Func_5aeb
	ld de, $3cbf
	call Func_2275
	ret
; 0x8d78

INCBIN "baserom.gbc",$8d78,$8d9d - $8d78

Func_8d9d: ; 8d9d (2:4d9d)
	ld de, $cfd1
	ld b, $7
.asm_8da2
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_8da2
	ret

Unknown_8da9: ; 8da9 (2:4da9)
INCBIN "baserom.gbc",$8da9,$8db0 - $8da9

Func_8db0: ; 8db0 (2:4db0)
	ld hl, Unknown_8da9
	call Func_8d9d
	ld a, $ff
	call Func_9168
	xor a

Func_8dbc: ; 8dbc (2:4dbc)
	ld hl, Unknown_8de2
	call InitializeCursorParameters
	text_hl PleaseSelectDeck
	call DrawWideTextBox_PrintText
.asm_8dc8
	call DoFrame
	jr c, Func_8dbc
	call Func_8dea
	jr c, Func_8dbc
	call MenuCursorAcceptInput
	jr nc, .asm_8dc8
	ldh a, [hCurrentMenuItem]
	cp $ff
	ret z
	ld [$ceb1], a
	jp Func_8e42

Unknown_8de2: ; 8de2 (2:4de2)
INCBIN "baserom.gbc",$8de2,$8dea - $8de2

Func_8dea: ; 8dea (2:4dea)
	ldh a, [hButtonsPressed2]
	and $8
	ret z
	ld a, [wCurMenuItem]
	ld [$ceb1], a
	call Func_8ff2
	jp nc, Func_8e05
	ld a, $ff
	call Func_90fb
	call Func_8fe8
	scf
	ret

Func_8e05: ; 8e05 (2:4e05)
	ld a, $1
	call Func_90fb
	call Func_9048
	push hl
	call Func_9038
	pop de
	call Func_8e1f
	ld a, $ff
	call Func_9168
	ld a, [$ceb1]
	scf
	ret

Func_8e1f: ; 8e1f (2:4e1f)
	push de
	ld de, $cfb9
	call Func_92b4
	pop de
	ld hl, $cf17
	call Func_8cd4
	ld a, $9
	ld hl, $cebb
	call Func_9843
	ld a, $3c
	ld [$cecc], a
	ld hl, $cebb
	ld [hl], a
	call Func_9e41
	ret

Func_8e42: ; 8e42 (2:4e42)
	call DrawWideTextBox
	ld hl, Unknown_9027
	call Func_2c08
	call Func_905a
.asm_8e4e
	call DoFrame
	call Func_9065
	jp nc, .asm_8e4e
	cp $ff
	jr nz, .asm_8e64
	call Func_90d8
	ld a, [$ceb1]
	jp Func_8dbc
.asm_8e64
	ld a, [$ceaf]
	or a
	jp nz, Func_8f8a
	ld a, [$ceb0]
	or a
	jp nz, .asm_8ecf
	call Func_9048
	ld e, l
	ld d, h
	ld hl, $cf17
	call Func_8cd4
	ld a, $14
	ld hl, $cfb9
	call Func_9843
	ld de, $cfb9
	call Func_9038
	call Func_92b4
	call Func_9345
	jr nc, .asm_8ec4
	call EnableExtRAM
	ld hl, $cf17
	call Func_910a
	call Func_9048
	call Func_9152
	ld e, l
	ld d, h
	ld hl, $cf17
	ld b, $3c
.asm_8ea9
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_8ea9
	call Func_9038
	ld d, h
	ld e, l
	ld hl, $cfb9
	call Func_92ad
	call Func_9038
	ld a, [hl]
	call DisableExtRAM
	or a
	jr z, .asm_8edb
.asm_8ec4
	ld a, $ff
	call Func_9168
	ld a, [$ceb1]
	jp Func_8dbc
.asm_8ecf
	call Func_8ff2
	jp nc, .asm_8edb
	call Func_8fe8
	jp Func_8dbc
.asm_8edb
	ld a, $14
	ld hl, $cfb9
	call Func_9843
	ld de, $cfb9
	call Func_9038
	call Func_92b4
	call Func_8f05
	call Func_9038
	ld d, h
	ld e, l
	ld hl, $cfb9
	call Func_92b4
	ld a, $ff
	call Func_9168
	ld a, [$ceb1]
	jp Func_8dbc

Func_8f05: ; 8f05 (2:4f05)
	ld a, [$ceb1]
	or a
	jr nz, .asm_8f10
	ld hl, Unknown_a763
	jr .asm_8f23
.asm_8f10
	dec a
	jr nz, .asm_8f18
	ld hl, Unknown_a76c
	jr .asm_8f23
.asm_8f18
	dec a
	jr nz, .asm_8f20
	ld hl, Unknown_a775
	jr .asm_8f23
.asm_8f20
	ld hl, Unknown_a77e
.asm_8f23
	ld a, $14
	ld bc, $0401
	ld de, $cfb9
	farcall Func_1ad89
	ld a, [$cfb9]
	or a
	ret nz
	call Func_8f38
	ret

Func_8f38: ; 8f38 (2:4f38)
	ld hl, $b701
	call EnableExtRAM
	ld a, [hli]
	ld h, [hl]
	call DisableExtRAM
	ld l, a
	ld de, $c590
	call Func_0663
	ld hl, $cfb9
	ld [hl], $6
	inc hl
	ld [hl], $44
	inc hl
	ld [hl], $65
	inc hl
	ld [hl], $63
	inc hl
	ld [hl], $6b
	inc hl
	ld [hl], $20
	inc hl
	ld de, $c592
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hli], a
	xor a
	ld [hl], a
	ld hl, $b701
	call EnableExtRAM
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, $3
	cp d
	jr nz, .asm_8f82
	ld a, $e7
	cp e
	jr nz, .asm_8f82
	ld de, $0000
.asm_8f82
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	call DisableExtRAM
	ret

Func_8f8a: ; 8f8a (2:4f8a)
	ld a, [$ceb0]
	or a
	jp nz, Func_9026
	call Func_8ff2
	jp nc, Func_8f9d
	call Func_8fe8
	jp Func_8dbc

Func_8f9d: ; 8f9d (2:4f9d)
	call EnableExtRAM
	ld a, [$b700]
	call DisableExtRAM
	ld h, $3
	ld l, a
	call HtimesL
	ld e, l
	inc e
	ld d, $2
	xor a
	ld hl, $0000
	ld bc, $0202
	call Func_1f5f
	ld a, [$ceb1]
	call EnableExtRAM
	ld [$b700], a
	call DisableExtRAM
	call Func_9326
	call Func_9038
	call EnableExtRAM
	call Func_9253
	call DisableExtRAM
	xor a
	ld [$ce3f], a
	ld [$ce40], a
	text_hl ChosenAsDuelingDeck
	call DrawWideTextBox_WaitForInput
	ld a, [$ceb1]
	jp Func_8dbc

Func_8fe8: ; 8fe8 (2:4fe8)
	text_hl ThereIsNoDeckHere
	call DrawWideTextBox_WaitForInput
	ld a, [$ceb1]
	ret

Func_8ff2: ; 8ff2 (2:4ff2)
	ld a, [$ceb1]
	ld hl, $ceb2
	ld b, $0
	ld c, a
	add hl, bc
	ld a, [hl]
	or a
	ret nz
	scf
	ret
; 0x9001

INCBIN "baserom.gbc",$9001,$9026 - $9001

Func_9026: ; 9026 (2:5026)
	ret

Unknown_9027: ; 9027 (2:5027)
INCBIN "baserom.gbc",$9027,$9038 - $9027

Func_9038: ; 9038 (2:5038)
	ld a, [$ceb1]
	ld h, a
	ld l, $54
	call HtimesL
	push de
	ld de, $a200
	add hl, de
	pop de
	ret

Func_9048: ; 9048 (2:5048)
	push af
	ld a, [$ceb1]
	ld h, a
	ld l, $54
	call HtimesL
	push de
	ld de, $a218
	add hl, de
	pop de
	pop af
	ret

Func_905a: ; 905a (2:505a)
	xor a
	ld [$ceaf], a
	ld [$ceb0], a
	ld [$cea3], a
	ret

Func_9065: ; 9065 (2:5065)
	xor a
	ld [$cfe3], a
	ld a, [$ceaf]
	ld d, a
	ld a, [$ceb0]
	ld e, a
	ldh a, [hButtonsPressed2]
	or a
	jr z, .asm_90a6
	bit 5, a
	jr nz, .asm_907e
	bit 4, a
	jr z, .asm_9084
.asm_907e
	ld a, d
	xor $1
	ld d, a
	jr .asm_9090
.asm_9084
	bit 6, a
	jr nz, .asm_908c
	bit 7, a
	jr z, .asm_90a6
.asm_908c
	ld a, e
	xor $1
	ld e, a
.asm_9090
	ld a, $1
	ld [$cfe3], a
	push de
	call Func_90d8
	pop de
	ld a, d
	ld [$ceaf], a
	ld a, e
	ld [$ceb0], a
	xor a
	ld [$cea3], a
.asm_90a6
	ldh a, [hButtonsPressed]
	and $3
	jr z, .asm_90c1
	and $1
	jr nz, .asm_90b7
	ld a, $ff
	call Func_90fb
	scf
	ret
.asm_90b7
	call Func_90f7
	ld a, $1
	call Func_90fb
	scf
	ret
.asm_90c1
	ld a, [$cfe3]
	or a
	jr z, .asm_90ca
	call Func_3796
.asm_90ca
	ld hl, $cea3
	ld a, [hl]
	inc [hl]
	and $f
	ret nz
	ld a, $f
	bit 4, [hl]
	jr z, asm_90da
Func_90d8: ; 90d8 (2:50d8)
	ld a, $0
asm_90da
	ld e, a
	ld a, $a
	ld l, a
	ld a, [$ceaf]
	ld h, a
	call HtimesL
	ld a, l
	add $1
	ld b, a
	ld a, [$ceb0]
	sla a
	add $e
	ld c, a
	ld a, e
	call Func_06c3
	or a
	ret

Func_90f7: ; 90f7 (2:50f7)
	ld a, $f
	jr asm_90da

Func_90fb: ; 90fb (2:50fb)
	push af
	inc a
	jr z, .asm_9103
	ld a, $2
	jr .asm_9105
.asm_9103
	ld a, $3
.asm_9105
	call Func_3796
	pop af
	ret

Func_910a: ; 910a (2:510a)
	push hl
	ld b, $0
	ld d, $3c
.asm_910f
	ld a, [hli]
	or a
	jr z, .asm_911e
	ld c, a
	push hl
	ld hl, $a100
	add hl, bc
	dec [hl]
	pop hl
	dec d
	jr nz, .asm_910f
.asm_911e
	pop hl
	ret
; 0x9120

INCBIN "baserom.gbc",$9120,$9152 - $9120

Func_9152: ; 9152 (2:5152)
	push hl
	ld b, $0
	ld d, $3c
.asm_9157
	ld a, [hli]
	or a
	jr z, .asm_9166
	ld c, a
	push hl
	ld hl, $a100
	add hl, bc
	inc [hl]
	pop hl
	dec d
	jr nz, .asm_9157
.asm_9166
	pop hl
	ret

Func_9168: ; 9168 (2:5168)
	ld [hffb5], a
	call Func_8d56
	ld de, $0000
	ld bc, $1404
	call DrawRegularTextBox
	ld de, $0003
	ld bc, $1404
	call DrawRegularTextBox
	ld de, $0006
	ld bc, $1404
	call DrawRegularTextBox
	ld de, $0009
	ld bc, $1404
	call DrawRegularTextBox
	ld hl, Unknown_9242
	call Func_2c08
	ld a, $4
	ld hl, $ceb2
	call Func_9843
	ld a, [hffb5]
	bit 0, a
	jr z, .asm_91b0
	ld hl, $a200
	ld de, $0602
	call Func_926e
.asm_91b0
	ld hl, $a218
	call Func_9314
	jr c, .asm_91bd
	ld a, $1
	ld [$ceb2], a
.asm_91bd
	ld a, [hffb5]
	bit 1, a
	jr z, .asm_91cd
	ld hl, $a254
	ld de, $0605
	call Func_926e
.asm_91cd
	ld hl, $a26c
	call Func_9314
	jr c, .asm_91da
	ld a, $1
	ld [$ceb3], a
.asm_91da
	ld a, [hffb5]
	bit 2, a
	jr z, .asm_91ea
	ld hl, $a2a8
	ld de, $0608
	call Func_926e
.asm_91ea
	ld hl, $a2c0
	call Func_9314
	jr c, .asm_91f7
	ld a, $1
	ld [$ceb4], a
.asm_91f7
	ld a, [hffb5]
	bit 3, a
	jr z, .asm_9207
	ld hl, $a2fc
	ld de, $060b
	call Func_926e
.asm_9207
	ld hl, $a314
	call Func_9314
	jr c, .asm_9214
	ld a, $1
	ld [$ceb5], a
.asm_9214
	call EnableExtRAM
	ld a, [$b700]
	ld c, a
	ld b, $0
	ld d, $2
.asm_921f
	ld hl, $ceb2
	add hl, bc
	ld a, [hl]
	or a
	jr nz, .asm_9234
	inc c
	ld a, $4
	cp c
	jr nz, .asm_921f
	ld c, $0
	dec d
	jr z, .asm_9234
	jr .asm_921f
.asm_9234
	ld a, c
	ld [$b700], a
	call DisableExtRAM
	call Func_9326
	call EnableLCD
	ret

Unknown_9242: ; 9242 (2:5242)
INCBIN "baserom.gbc",$9242,$9253 - $9242

Func_9253: ; 9253 (2:5253)
	ld de, $c590
	call Func_92ad
	ld hl, $c590
	call Func_23c1
	ld b, $0
	ld hl, $c590
	add hl, bc
	ld d, h
	ld e, l
	ld hl, Unknown_92a7
	call Func_92ad
	ret

Func_926e: ; 926e (2:526e)
	push hl
	call Func_9314
	pop hl
	jr c, .asm_929c
	push de
	ld de, $c590
	call Func_92b4
	ld hl, $c590
	call Func_23c1
	ld b, $0
	ld hl, $c590
	add hl, bc
	ld d, h
	ld e, l
	ld hl, Unknown_92a7
	call Func_92ad
	pop de
	ld hl, $c590
	call Func_22ae
	call Func_21c5
	or a
	ret
.asm_929c
	call Func_22ae
	text_hl NewDeck
	call Func_2c29
	scf
	ret

Unknown_92a7: ; 92a7 (2:52a7)
INCBIN "baserom.gbc",$92a7,$92ad - $92a7

Func_92ad: ; 92ad (2:52ad)
	ld a, [hli]
	ld [de], a
	or a
	ret z
	inc de
	jr Func_92ad

Func_92b4: ; 92b4 (2:52b4)
	call EnableExtRAM
	call Func_92ad
	call DisableExtRAM
	ret
; 0x92be

INCBIN "baserom.gbc",$92be,$9314 - $92be

Func_9314: ; 9314 (2:5314)
	ld bc, $0018
	add hl, bc
	call EnableExtRAM
	ld a, [hl]
	call DisableExtRAM
	or a
	jr nz, .asm_9324
	scf
	ret
.asm_9324
	or a
	ret

Func_9326: ; 9326 (2:5326)
	call EnableExtRAM
	ld a, [$b700]
	call DisableExtRAM
	ld h, $3
	ld l, a
	call HtimesL
	ld e, l
	inc e
	ld d, $2
	ld a, $38
	ld hl, $0102
	ld bc, $0202
	call Func_1f5f
	ret

Func_9345: ; 9345 (2:5345)
INCBIN "baserom.gbc",$9345,$9843 - $9345

Func_9843: ; 9843 (2:5843)
INCBIN "baserom.gbc",$9843,$9e41 - $9843

Func_9e41: ; 9e41 (2:5e41)
INCBIN "baserom.gbc",$9e41,$a288 - $9e41

Func_a288: ; a288 (2:6288)
INCBIN "baserom.gbc",$a288,$a763 - $a288

Unknown_a763: ; a763 (2:6763)
INCBIN "baserom.gbc",$a763,$a76c - $a763

Unknown_a76c: ; a76c (2:676c)
INCBIN "baserom.gbc",$a76c,$a775 - $a76c

Unknown_a775: ; a775 (2:6775)
INCBIN "baserom.gbc",$a775,$a77e - $a775

Unknown_a77e: ; a77e (2:677e)
INCBIN "baserom.gbc",$a77e,$b177 - $a77e

Func_b177: ; b177 (2:7177)
INCBIN "baserom.gbc",$b177,$c000 - $b177
