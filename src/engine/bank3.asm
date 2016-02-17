LoadMap: ; c000 (3:4000)
	call DisableLCD
	call EnableExtRAM
	bank1call Func_6785
	call DisableExtRAM
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
	call Set_OBJ_8x8
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
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
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
	call DoFrameIfLCDEnabled
	call Func_c491
	call Func_c0ce
	ld hl, $d0b4
	ld a, [hl]
	and $d0
	jr z, .asm_c092
	call DoFrameIfLCDEnabled
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
	farcall Duel_Init
.asm_c0ca
	call Func_c280
	ret

Func_c0ce: ; c0ce (3:40ce)
	ld a, [$d0bf]
	res 7, a
	rlca
	add PointerTable_c0e0 & $ff
	ld l, a
	ld a, PointerTable_c0e0 >> $8
	adc $0
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

PointerTable_c0e0: ; c0e0 (3:40e0)
	dw Func_c0e8
	dw Func_c0ed
	dw Func_c0f1
	dw Func_c10a

Func_c0e8: ; c0e8 (3:40e8)
	farcall Func_10e55
	ret

Func_c0ed: ; c0ed (3:40ed)
	call Func_c510
	ret

Func_c0f1: ; c0f1 (3:40f1)
	ld a, [$d3b6]
	ld [$d3aa], a
	farcall Func_1c768
	ld a, c
	ld [$d0c6], a
	ld a, b
	ld [$d0c7], a
	ld a, $3
	ld [$d0bf], a
	jr Func_c10a

Func_c10a: ; c10a (3:410a)
	ld hl, $d0c6
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

Func_c111: ; c111 (3:4111)
	ld a, [$d0c1]
	bit 0, a
	call nz, Func_c135
	ld a, [$d0c1]
	bit 1, a
	jr z, .asm_c12a
	ld a, [$d3b6]
	ld [$d3aa], a
	farcall Func_1c5e9
.asm_c12a
	xor a
	ld [$d0c1], a
	ld a, [$d0c0]
	ld [$d0bf], a
	ret

Func_c135: ; c135 (3:4135)
	push hl
	farcall Func_80028
	ld hl, $d0c1
	res 0, [hl]
	pop hl
	ret

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
	ld a, [$d0c2]
	cp $1
	ret nz
	ld a, [$d0c4]
	ld [$d3ab], a
	call Func_39c3
	jr c, .asm_c179
	ld a, [$d3aa]
	ld l, $4
	call Func_39ad
	ld a, [$d0c5]
	ld [hl], a
	farcall Func_1c58e
.asm_c179
	ret

Func_c17a: ; c17a (3:417a)
	ld a, [$d0bf]
	cp $3
	ret z
	call Func_c9b8
	ret

Func_c184: ; c184 (3:4184)
	push bc
	ld c, $1
	ld a, [wCurMap]
	cp OVERWORLD_MAP
	jr nz, .asm_c190
	ld c, $0
.asm_c190
	ld a, c
	ld [$d0bf], a
	ld [$d0c0], a
	pop bc
	ret

Func_c199: ; c199 (3:4199)
	ld hl, Func_380e
	call SetDoFrameFunction
	ret

Func_c1a0: ; c1a0 (3:41a0)
	call ResetDoFrameFunction
	ret

Func_c1a4: ; c1a4 (3:41a4)
	xor a
	call Func_040c
	xor a
	call Set_OBP0
	xor a
	call Set_OBP1
	ret

Func_c1b1: ; c1b1 (3:41b1)
	ld a, $c
	ld [$d32e], a
	ld a, $0
	ld [$d0bb], a
	ld a, $c
	ld [$d0bc], a
	ld a, $c
	ld [$d0bd], a
	ld a, $2
	ld [$d0be], a
	call Func_c9cb
	call Func_c9dd
	farcall Func_80b7a
	farcall Func_1c82e
	farcall Func_131b3
	xor a
	ld [wPlayTimeCounter + 0], a
	ld [wPlayTimeCounter + 1], a
	ld [wPlayTimeCounter + 2], a
	ld [wPlayTimeCounter + 3], a
	ld [wPlayTimeCounter + 4], a
	ret

Func_c1ed: ; c1ed (3:41ed)
	call Func_c9cb
	farcall Func_11416
	call Func_c9dd
	ret

Func_c1f8: ; c1f8 (3:41f8)
	xor a
	ld [$d0b8], a
	ld [$d0b9], a
	ld [$d0ba], a
	ld [$d11b], a
	ld [$d0c2], a
	ld [$d111], a
	ld [$d112], a
	ld [$d3b8], a
	call EnableExtRAM
	ld a, [$a007]
	ld [$d421], a
	ld a, [$a006]
	ld [$ce47], a
	call DisableExtRAM
	farcall Func_10756
	ret

Func_c228: ; c228 (3:4228)
	ld a, [wCurMap]
	ld [$d0bb], a
	ld a, [wPlayerXCoord]
	ld [$d0bc], a
	ld a, [wPlayerYCoord]
	ld [$d0bd], a
	ld a, [$d334]
	ld [$d0be], a
	ret

Func_c241: ; c241 (3:4241)
	push hl
	push bc
	push de
	ld de, $307f
	call Func_2275
	call Func_c258
	pop de
	pop bc
	pop hl
	ret

Func_c251: ; c251 (3:4251)
	ldh a, [$ffb0]
	push af
	ld a, $1
	jr asm_c25d

Func_c258: ; c258 (3:4258)
	ldh a, [$ffb0]
	push af
	ld a, $2
asm_c25d
	ldh [$ffb0], a
	push hl
	call Func_c268
	pop hl
	pop af
	ldh [$ffb0], a
	ret

Func_c268: ; c268 (3:4268)
	ld hl, Unknown_c27c
.asm_c26b
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, .asm_c27a
	call Func_2c29
	pop hl
	inc hl
	inc hl
	jr .asm_c26b
.asm_c27a
	pop hl
	ret

Unknown_c27c: ; c27c (3:427c)
INCBIN "baserom.gbc",$c27c,$c280 - $c27c

Func_c280: ; c280 (3:4280)
	call Func_c228
	call Func_3ca0
	call Func_099c
	ld hl, $cac0
	inc [hl]
	call EnableLCD
	call DoFrameIfLCDEnabled
	call DisableLCD
	farcall Func_12871
	ret

Func_c29b: ; c29b (3:429b)
	push hl
	ld hl, $d0c1
	or [hl]
	ld [hl], a
	pop hl
	ret

Func_c2a3: ; c2a3 (3:42a3)
	push hl
	push bc
	push de
	call Func_c335
	farcall Func_10ab4
	ld a, $80
	call Func_c29b
	ld de, $307f
	call Func_2275
	farcall Func_12ba7
	call Func_3ca0
	call Func_099c
	ld a, $1
	ld [$cac0], a
	call EnableLCD
	call DoFrameIfLCDEnabled
	call DisableLCD
	pop de
	pop bc
	pop hl
	ret
; 0xc2d4

INCBIN "baserom.gbc",$c2d4,$c2db - $c2d4

Func_c2db: ; c2db (3:42db)
	push hl
	push bc
	push de
	call DisableLCD
	call Set_OBJ_8x8
	call Func_3ca0
	farcall Func_12bcd
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	call Func_c241
	call Func_04a2
	ld a, [$d111]
	push af
	farcall Func_80000
	pop af
	ld [$d111], a
	ld hl, $d0c1
	res 0, [hl]
	call Func_c34e
	farcall Func_12c5e
	farcall Func_1c6f8
	ld hl, $d0c1
	res 7, [hl]
	ld hl, $d10f
	ld a, [hli]
	or [hl]
	jr z, .asm_c323
	ld a, [hld]
	ld l, [hl]
	ld h, a
	call Func_3c45
.asm_c323
	farcall Func_10af9
	pop de
	pop bc
	pop hl
	ret

Func_c32b: ; c32b (3:432b)
	ld a, l
	ld [$d10f], a
	ld a, h
	ld [$d110], a
	jr Func_c2db

Func_c335: ; c335 (3:4335)
	ld a, [$cabd]
	ld [$d10c], a
	ld a, [$cabe]
	ld [$d10d], a
	ld hl, $cb30
	ld de, $d0cc
	ld bc, $0040
	call CopyData_SaveRegisters
	ret

Func_c34e: ; c34e (3:434e)
	ld a, [$d10c]
	ld [$cabd], a
	ld a, [$d10d]
	ld [$cabe], a
	ld hl, $d0cc
	ld de, $cb30
	ld bc, $0040
	call CopyData_SaveRegisters
	call Func_0404
	ret

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

INCBIN "baserom.gbc",$c37a,$c41c - $c37a

Func_c41c: ; c41c (3:441c)
	ld a, [$d332]
	sub $40
	ld [$d235], a
	ld a, [$d333]
	sub $40
	ld [$d236], a
	call Func_c430
	ret

Func_c430: ; c430 (3:4430)
	push bc
	ld a, [$d237]
	sla a
	sla a
	sla a
	ld b, a
	ld a, [$d235]
	cp $b1
	jr c, .asm_c445
	xor a
	jr .asm_c449
.asm_c445
	cp b
	jr c, .asm_c449
	ld a, b
.asm_c449
	ld [$d235], a
	ld a, [$d238]
	sla a
	sla a
	sla a
	ld b, a
	ld a, [$d236]
	cp $b9
	jr c, .asm_c460
	xor a
	jr .asm_c464
.asm_c460
	cp b
	jr c, .asm_c464
	ld a, b
.asm_c464
	ld [$d236], a
	pop bc
	ret

Func_c469: ; c469 (3:4469)
	ld a, [$d235]
	add $4
	and $f8
	rrca
	rrca
	rrca
	ld [$d233], a
	ld a, [$d236]
	add $4
	and $f8
	rrca
	rrca
	rrca
	ld [$d234], a
	ret

Func_c484: ; c484 (3:4484)
	ld a, [$d235]
	ld [$d0b6], a
	ld a, [$d236]
	ld [$d0b7], a
	ret

Func_c491: ; c491 (3:4491)
	ld a, [$d0b6]
	ldh [hSCX], a
	ld a, [$d0b7]
	ldh [hSCY], a
	ret

Func_c49c: ; c49c (3:449c)
	ld a, [wPlayerXCoord]
	and $1f
	ld [wPlayerXCoord], a
	rlca
	rlca
	rlca
	ld [$d332], a
	ld a, [wPlayerYCoord]
	and $1f
	ld [wPlayerYCoord], a
	rlca
	rlca
	rlca
	ld [$d333], a
	ret

Func_c4b9: ; c4b9 (3:44b9)
	xor a
	ld [$d4ca], a
	ld [$d4cb], a
	ld a, $1d
	farcall Func_80418
	ld b, $0
	ld a, [$cab4]
	cp $2
	jr nz, .asm_c4d1
	ld b, $1e
.asm_c4d1
	ld a, b
	ld [$d337], a
	ld a, $0
	farcall Func_1299f
	ld a, [$d4cf]
	ld [$d336], a
	ld b, $2
	ld a, [wCurMap]
	cp OVERWORLD_MAP
	jr z, .asm_c4ee
	ld a, [$d0be]
	ld b, a
.asm_c4ee
	ld a, b
	ld [$d334], a
	call Func_c5e9
	ld a, [wCurMap]
	cp OVERWORLD_MAP
	call nz, Func_c6f7
	xor a
	ld [$d335], a
	ld [$d338], a
	ld a, [wCurMap]
	cp OVERWORLD_MAP
	jr nz, .asm_c50f
	farcall Func_10fde
.asm_c50f
	ret

Func_c510: ; c510 (3:4510)
	ld a, [$d336]
	ld [$d4cf], a
	ld a, [$d335]
	bit 4, a
	ret nz
	bit 0, a
	call z, Func_c5ac
	ld a, [$d335]
	or a
	jr z, .asm_c535
	bit 0, a
	call nz, Func_c66c
	ld a, [$d335]
	bit 1, a
	call nz, Func_c6dc
	ret
.asm_c535
	ldh a, [hButtonsPressed]
	and $8
	call nz, Func_c74d
	ret
; 0xc53d

INCBIN "baserom.gbc",$c53d,$c554 - $c53d

Func_c554: ; c554 (3:4554)
	ld a, [$d336]
	ld [$d4cf], a
	ld a, [wCurMap]
	cp OVERWORLD_MAP
	jr nz, .asm_c566
	farcall Func_10e28
	ret
.asm_c566
	push hl
	push bc
	push de
	call Func_c58b
	ld a, [$d235]
	ld d, a
	ld a, [$d236]
	ld e, a
	ld c, $2
	call Func_3dbf
	ld a, [$d332]
	sub d
	add $8
	ld [hli], a
	ld a, [$d333]
	sub e
	add $10
	ld [hli], a
	pop de
	pop bc
	pop hl
	ret

Func_c58b: ; c58b (3:458b)
	push hl
	ld a, [wPlayerXCoord]
	ld b, a
	ld a, [wPlayerYCoord]
	ld c, a
	call Func_3927
	and $10
	push af
	ld c, $f
	call Func_3dbf
	pop af
	ld a, [hl]
	jr z, .asm_c5a7
	or $80
	jr .asm_c5a9
.asm_c5a7
	and $7f
.asm_c5a9
	ld [hl], a
	pop hl
	ret

Func_c5ac: ; c5ac (3:45ac)
	ldh a, [hButtonsHeld]
	and $f0
	jr z, .asm_c5bf
	call Func_c5cb
	call Func_c5fe
	ld a, [$d335]
	and $1
	jr nz, .asm_c5ca
.asm_c5bf
	ldh a, [hButtonsPressed]
	and $1
	jr z, .asm_c5ca
	call Func_c71e
	jr .asm_c5ca
.asm_c5ca
	ret

Func_c5cb: ; c5cb (3:45cb)
	call Func_c5d5
	ld [$d334], a
	call Func_c5e9
	ret

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

Func_c5fe: ; c5fe (3:45fe)
	push bc
	call Func_c653
	call Func_c619
	pop bc
	ret
; 0xc607

INCBIN "baserom.gbc",$c607,$c619 - $c607

Func_c619: ; c619 (3:4619)
	push hl
	push bc
	ld a, b
	cp $1f
	jr nc, .asm_c650
	ld a, c
	cp $1f
	jr nc, .asm_c650
	call Func_3927
	and $c0
	jr nz, .asm_c650
	ld a, b
	ld [wPlayerXCoord], a
	ld a, c
	ld [wPlayerYCoord], a
	ld a, [$d335]
	or $1
	ld [$d335], a
	ld a, $10
	ld [$d338], a
	ld c, $f
	call Func_3dbf
	set 2, [hl]
	ld c, $e
	call Func_3dbf
	ld a, $4
	ld [hl], a
.asm_c650
	pop bc
	pop hl
	ret

Func_c653: ; c653 (3:4653)
	ld a, [$d334]
	rlca
	ld c, a
	ld b, $0
	push hl
	ld hl, Unknown_3973
	add hl, bc
	ld a, [wPlayerXCoord]
	add [hl]
	ld b, a
	inc hl
	ld a, [wPlayerYCoord]
	add [hl]
	ld c, a
	pop hl
	ret

Func_c66c: ; c66c (3:466c)
	push hl
	push bc
	ld c, $1
	ldh a, [hButtonsHeld]
	bit 1, a
	jr z, .asm_c67e
	ld a, [$d338]
	cp $2
	jr c, .asm_c67e
	inc c
.asm_c67e
	ld a, [$d334]
	call Func_c694
	pop bc
	pop hl
	ret
; 0xc687

INCBIN "baserom.gbc",$c687,$c694 - $c687

Func_c694: ; c694 (3:4694)
	push hl
	push bc
	push bc
	rlca
	ld c, a
	ld b, $0
	ld hl, Unknown_396b
	add hl, bc
	pop bc
.asm_c6a0
	push hl
	ld a, [hli]
	or a
	call nz, Func_c6cc
	ld a, [hli]
	or a
	call nz, Func_c6d4
	pop hl
	ld a, [$d338]
	dec a
	ld [$d338], a
	jr z, .asm_c6b8
	dec c
	jr nz, .asm_c6a0
.asm_c6b8
	ld a, [$d338]
	or a
	jr nz, .asm_c6c3
	ld hl, $d335
	set 1, [hl]
.asm_c6c3
	call Func_c41c
	call Func_c469
	pop bc
	pop hl
	ret

Func_c6cc: ; c6cc (3:46cc)
	push hl
	ld hl, $d332
	add [hl]
	ld [hl], a
	pop hl
	ret

Func_c6d4: ; c6d4 (3:46d4)
	push hl
	ld hl, $d333
	add [hl]
	ld [hl], a
	pop hl
	ret

Func_c6dc: ; c6dc (3:46dc)
	push hl
	ld hl, $d335
	res 0, [hl]
	res 1, [hl]
	call Func_c6f7
	call Func_3997
	call Func_c70d
	ld a, [$d0bf]
	cp $1
	call z, Func_c9c0
	pop hl
	ret

Func_c6f7: ; c6f7 (3:46f7)
	ld a, [$d336]
	ld [$d4cf], a
	ld c, $f
	call Func_3dbf
	res 2, [hl]
	ld c, $e
	call Func_3dbf
	ld a, $ff
	ld [hl], a
	ret

Func_c70d: ; c70d (3:470d)
	push hl
	ld hl, $d0bb
	ld a, [wCurMap]
	cp [hl]
	jr z, .asm_c71c
	ld hl, $d0b4
	set 4, [hl]
.asm_c71c
	pop hl
	ret

Func_c71e: ; c71e (3:471e)
	ld a, $ff
	ld [$d3b6], a
	call Func_c653
	call Func_3927
	and $40
	jr z, .asm_c73d
	farcall Func_1c72e
	jr c, .asm_c73d
	ld a, [$d3aa]
	ld [$d3b6], a
	ld a, $2
	jr .asm_c748
.asm_c73d
	call Func_3a5e
	jr nc, .asm_c746
	ld a, $3
	jr .asm_c748
.asm_c746
	or a
	ret
.asm_c748
	ld [$d0bf], a
	scf
	ret

Func_c74d: ; c74d (3:474d)
	push hl
	push bc
	push de
	call MainMenu_c75a
	call Func_c111
	pop de
	pop bc
	pop hl
	ret

MainMenu_c75a: ; c75a (3:475a)
	call Func_379b
	ld a, MUSIC_PAUSEMENU
	call PlaySong
	call Func_c797
.asm_c765
	ld a, $1
	call Func_c29b
.asm_c76a
	call DoFrameIfLCDEnabled
	call Func_264b
	jr nc, .asm_c76a
	ld a, e
	ld [$d0b8], a
	ldh a, [hCurrentMenuItem]
	cp e
	jr nz, .asm_c793
	cp $5
	jr z, .asm_c793
	call Func_c2a3
	ld a, [$d0b8]
	ld hl, PointerTable_c7a2
	call JumpToFunctionInTable
	ld hl, Func_c797
	call Func_c32b
	jr .asm_c765
.asm_c793
	call Func_37a0
	ret

Func_c797: ; c797 (3:4797)
	ld a, [$d0b8]
	ld hl, Unknown_cd98
	farcall Func_111e9
	ret

PointerTable_c7a2: ; c7a2 (3:47a2)
	dw Func_c7ae
	dw Func_c7b3
	dw Func_c7b8
	dw Func_c7cc
	dw Func_c7e0
	dw Func_c7e5

Func_c7ae: ; c7ae (3:47ae)
	farcall Func_10059
	ret

Func_c7b3: ; c7b3 (3:47b3)
	farcall Func_100a2
	ret

Func_c7b8: ; c7b8 (3:47b8)
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	call Set_OBJ_8x16
	farcall Func_1288c
	farcall Func_8db0
	call Set_OBJ_8x8
	ret

Func_c7cc: ; c7cc (3:47cc)
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	call Set_OBJ_8x16
	farcall Func_1288c
	farcall Func_a288
	call Set_OBJ_8x8
	ret

Func_c7e0: ; c7e0 (3:47e0)
	farcall Func_10548
	ret

Func_c7e5: ; c7e5 (3:47e5)
	farcall Func_103d2
	ret

PC_c7ea: ; c7ea (3:47ea)
	ld a, MUSIC_PCMAINMENU
	call PlaySong
	call Func_c241
	call $4915
	call DoFrameIfLCDEnabled
	ld hl, $0352
	call Func_2c73
	call $484e
.asm_c801
	ld a, $1
	call Func_c29b
.asm_c806
	call DoFrameIfLCDEnabled
	call Func_264b
	jr nc, .asm_c806
	ld a, e
	ld [$d0b9], a
	ldh a, [hCurrentMenuItem]
	cp e
	jr nz, .asm_c82f
	cp $4
	jr z, .asm_c82f
	call Func_c2a3
	ld a, [$d0b9]
	ld hl, $4846
	call JumpToFunctionInTable
	ld hl, $484e
	call Func_c32b
	jr .asm_c801
.asm_c82f
	call Func_c135
	call DoFrameIfLCDEnabled
	ld hl, $0353
	call $4891
	call Func_c111
	xor a
	ld [$d112], a
	call Func_39fc
	ret
; 0xc846

INCBIN "baserom.gbc",$c846,$c935 - $c846

Func_c935: ; c935 (3:4935)
	push hl
	ld hl, $d0c6
	ld [hl], c
	inc hl
	ld [hl], b
	ld a, $3
	ld [$d0bf], a
	pop hl
	ret

Func_c943: ; c943 (3:4943)
	push hl
	push bc
	push de
	ld l, $0
	call Func_3abd
	jr nc, .asm_c98f
.asm_c94d
	ld a, l
	ld [$d4c4], a
	ld a, h
	ld [$d4c5], a
	ld a, $4
	ld [$d4c6], a
	ld de, $d3ab
	ld bc, $0006
	call Func_3bf5
	ld a, [$d3ab]
	or a
	jr z, .asm_c98f
	push hl
	ld a, [$d3af]
	ld l, a
	ld a, [$d3b0]
	ld h, a
	or l
	jr z, .asm_c97a
	call Func_3c45
	jr nc, .asm_c988
.asm_c97a
	ld a, [$d3ab]
	farcall Func_11857
	call Func_c998
	farcall Func_1c485
.asm_c988
	pop hl
	ld bc, $0006
	add hl, bc
	jr .asm_c94d
.asm_c98f
	ld l, $2
	call Func_c9c2
	pop de
	pop bc
	pop hl
	ret

Func_c998: ; c998 (3:4998)
	ld a, [$d3ab]
	cp $22
	ret nz
	ld a, [$d3d0]
	or a
	ret z
	ld b, $4
	ld a, [$cab4]
	cp $2
	jr nz, .asm_c9ae
	ld b, $e
.asm_c9ae
	ld a, b
	ld [$d3b1], a
	ld a, $0
	ld [$d3b2], a
	ret

Func_c9b8: ; c9b8 (3:49b8)
	ld l, $8
	jr Func_c9c2

Func_c9bc: ; c9bc (3:49bc)
	ld l, $a
	jr Func_c9c2

Func_c9c0: ; c9c0 (3:49c0)
	ld l, $c

Func_c9c2: ; c9c2 (3:49c2)
	call Func_3abd
	ret nc
	jp [hl]

Func_c9c7: ; c9c7 (3:49c7)
	ld l, $e
	jr Func_c9c2

Func_c9cb: ; c9cb (3:49cb)
	push hl
	push bc
	ld hl, $d3d2
	ld bc, $0040
.asm_c9d3
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .asm_c9d3
	pop bc
	pop hl
	ret

Func_c9dd: ; c9dd (3:49dd)
	xor a
	ld [$d411], a
	call Func_c9e8
	call Func_ca0e
	ret

Func_c9e8: ; c9e8 (3:49e8)
	ld c, $0
	call Func_ca69
	db $13
	cp $2
	jr c, .asm_ca04
.asm_c9f2
	call UpdateRNGSources
	and $3
	ld c, a
	ld b, $0
	ld hl, Unknown_ca0a
	add hl, bc
	ld a, [$d0bb]
	cp [hl]
	jr z, .asm_c9f2
.asm_ca04
	ld a, c
	call Func_ca8f
	db $34
	ret

Unknown_ca0a: ; ca0a (3:4a04)
INCBIN "baserom.gbc",$ca0a,$ca0e - $ca0a

Func_ca0e: ; ca0e (3:4a0e)
	ld a, [$d32e]
	cp $b
	jr z, .asm_ca68
	call Func_ca69
	db $22
	or a
	jr nz, .asm_ca4a
	call Func_ca69
	db $40
	cp $7
	jr z, .asm_ca68
	or a
	jr z, .asm_ca33
	cp $2
	jr z, .asm_ca62
	ld c, $1
	call Func_ca8f
	db $40
	jr .asm_ca62
.asm_ca33
	call Func_ca69
	db $3f
	cp $7
	jr z, .asm_ca68
	or a
	jr z, .asm_ca68
	cp $2
	jr z, .asm_ca68
	ld c, $1
	call Func_ca8f
	db $3f
	jr .asm_ca68
.asm_ca4a
	call UpdateRNGSources
	ld c, $1
	and $3
	or a
	jr z, .asm_ca56
	ld c, $0
.asm_ca56
	call Func_ca8f
	db $41
	jr .asm_ca5c
.asm_ca5c
	ld c, $7
	call Func_ca8f
	db $40
.asm_ca62
	ld c, $7
	call Func_ca8f
	db $3f
.asm_ca68
	ret

Func_ca69: ; ca69 (3:4a69)
	call Func_cab3
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

INCBIN "baserom.gbc",$ca84,$ca8f - $ca84

Func_ca8f: ; ca8f (3:4a8f)
	call Func_cab3
	push hl
	push bc
	call Func_cb1d
	ld a, [$d3d1]
.asm_ca9a
	bit 0, a
	jr nz, .asm_caa4
	srl a
	sla c
	jr .asm_ca9a
.asm_caa4
	ld a, [$d3d1]
	and c
	ld c, a
	ld a, [$d3d1]
	cpl
	and [hl]
	or c
	ld [hl], a
	pop bc
	pop hl
	ret

Func_cab3: ; cab3 (3:4ab3)
	push hl
	ld hl, [sp+$4]
	push bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, [bc]
	inc bc
	ld [hl], b
	dec hl
	ld [hl], c
	pop bc
	pop hl
	ret
; 0xcac2

INCBIN "baserom.gbc",$cac2,$cb1d - $cac2

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

INCBIN "baserom.gbc",$cc60,$cd98 - $cc60

Unknown_cd98: ; cd98 (3:4d98)
INCBIN "baserom.gbc",$cd98,$d336 - $cd98

DeckMachine_d336: ; d336 (3:5336)
	push bc
	call Func_c2a3
	call Func_379b
	ld a, MUSIC_DECKMACHINE
	call PlaySong
	call Func_04a2
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	farcall Func_1288c
	call EnableLCD
	pop bc
	ld a, c
	or a
	jr z, .asm_d360
	dec a
	ld [$d0a9], a
	farcallx $2, $7a04
	jr .asm_d364
.asm_d360
	farcallx $2, $719d
.asm_d364
	call Func_37a0
	call $42d4
	jp $4c64
; 0xd36d

INCBIN "baserom.gbc",$d36d,$fc2b - $d36d

Func_fc2b: ; fc2b (3:7c2b)
	ld a, [$d0c3]
	cp $2
	jr c, .asm_fc34
	ld a, $2
.asm_fc34
	rlca
	ld c, a
	ld b, $0
	ld hl, PointerTable_fc4c
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, $b0
	ld [$d0c8], a
	ld a, $3
	ld [$d0c9], a
	jp Func_c935

PointerTable_fc4c: ; fc4c (3:7c4c)
	dw Unknown_fc64
	dw Unknown_fc68
	dw Unknown_fc60

INCBIN "baserom.gbc",$fc52,$fc60 - $fc52

Unknown_fc60: ; fc60 (3:7c60)
INCBIN "baserom.gbc",$fc60,$fc64 - $fc60

Unknown_fc64: ; fc64 (3:7c64)
INCBIN "baserom.gbc",$fc64,$fc68 - $fc64

Unknown_fc68: ; fc68 (3:7c68)
INCBIN "baserom.gbc",$fc68,$fcad - $fc68

Func_fcad: ; fcad (3:7cad)
INCBIN "baserom.gbc",$fcad,$10000 - $fcad
