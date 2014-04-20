Func_fc000: ; fc000 (3f:4000)
	jp Func_fc006

Func_fc003: ; fc003 (3f:4003)
	jp Func_fc059

Func_fc006: ; fc006 (3f:4006)
	ld hl, NumberOfSFX
	cp [hl]
	jr nc, .asm_fc058
	add a
	ld c, a
	ld b, $0
	ld a, [$de53]
	or a
	jr z, .asm_fc019
	call Func_fc279
.asm_fc019
	ld a, $1
	ld [$de53], a
	ld hl, SFXHeaderPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld [$dd8c], a
	ld [$de54], a
	ld de, $de4b
	ld c, $0
.asm_fc031
	ld a, [$de54]
	rrca
	ld [$de54], a
	jr nc, .asm_fc050
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	push hl
	ld hl, $de2f
	add hl, bc
	ld [hl], $0
	ld hl, $de33
	add hl, bc
	ld [hl], $1
	pop hl
	jr .asm_fc052
.asm_fc050
	inc de
	inc de
.asm_fc052
	inc c
	ld a, $4
	cp c
	jr nz, .asm_fc031
.asm_fc058
	ret

Func_fc059: ; fc059 (3f:4059)
	ld a, [$dd8c]
	or a
	jr nz, .asm_fc063
	call Func_fc26c
	ret
.asm_fc063
	xor a
	ld b, a
	ld c, a
	ld a, [$dd8c]
	ld [$de54], a
.asm_fc06c
	ld hl, $de54
	ld a, [hl]
	rrca
	ld [hl], a
	jr nc, .asm_fc08d
	ld hl, $de33
	add hl, bc
	ld a, [hl]
	dec a
	jr z, .asm_fc082
	ld [hl], a
	call Func_fc18d
	jr .asm_fc08d
.asm_fc082
	ld hl, $de4b
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_fc094
.asm_fc08d
	inc c
	ld a, c
	cp $4
	jr nz, .asm_fc06c
	ret

Func_fc094: ; fc094 (3f:4094)
	ld a, [hl]
	and $f0
	swap a
	add a
	ld e, a
	ld d, $0
	ld a, [hli]
	push hl
	and $f
	ld hl, PointerTable_fc0ab
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld h, d
	ld l, e
	jp [hl]

PointerTable_fc0ab: ; fc0ab (3f:40ab)
	dw Func_fc0ce
	dw Func_fc10e
	dw Func_fc127
	dw Func_fc138
	dw Func_fc14d
	dw Func_fc166
	dw Func_fc172
	dw Func_fc202
	dw Func_fc22d
	dw Func_fc0cb
	dw Func_fc0cb
	dw Func_fc0cb
	dw Func_fc0cb
	dw Func_fc0cb
	dw Func_fc0cb
	dw Func_fc249

Func_fc0cb: ; fc0cb (3f:40cb)
	jp Func_fc094

Func_fc0ce: ; fc0ce (3f:40ce)
	ld d, a
	pop hl
	ld a, [hli]
	ld e, a
	push hl
	ld hl, $de37
	add hl, bc
	add hl, bc
	push bc
	ld b, [hl]
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, c
	cp $3
	jr nz, .asm_fc0e9
	ld a, b
	xor e
	and $8
	swap a
	ld d, a
.asm_fc0e9
	pop bc
	ld hl, $de2b
	add hl, bc
	ld a, [hl]
	ld [hl], $0
	or d
	ld d, a
	ld hl, $ff11
	ld a, c
	add a
	add a
	add c
	add l
	ld l, a
	ld a, [hl]
	and $c0
	ld [hli], a
	inc hl
	ld a, e
	ld [hli], a
	ld [hl], d
	pop de
Func_fc105: ; fc105 (3f:4105)
	ld hl, $de4b
	add hl, bc
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ret

Func_fc10e: ; fc10e (3f:410e)
	ld hl, $de2b
	add hl, bc
	ld a, $80
	ld [hl], a
	pop hl
	ld a, [hli]
	ld e, a
	push hl
	ld hl, $ff12
	ld a, c
	add a
	add a
	add c
	add l
	ld l, a
	ld [hl], e
	pop hl
	jp Func_fc094

Func_fc127: ; fc127 (3f:4127)
	swap a
	ld e, a
	ld hl, $ff11
	ld a, c
	add a
	add a
	add c
	add l
	ld l, a
	ld [hl], e
	pop hl
	jp Func_fc094

Func_fc138: ; fc138 (3f:4138)
	ld hl, $de43
	add hl, bc
	add hl, bc
	pop de
	ld a, [de]
	inc de
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, $de3f
	add hl, bc
	ld [hl], a
	ld l, e
	ld h, d
	jp Func_fc094

Func_fc14d: ; fc14d (3f:414d)
	ld hl, $de3f
	add hl, bc
	ld a, [hl]
	dec a
	jr z, .asm_fc162
	ld [hl], a
	ld hl, $de43
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	jp Func_fc094
.asm_fc162
	pop hl
	jp Func_fc094

Func_fc166: ; fc166 (3f:4166)
	ld hl, $de2f
	add hl, bc
	ld e, l
	ld d, h
	pop hl
	ld a, [hli]
	ld [de], a
	jp Func_fc094

Func_fc172: ; fc172 (3f:4172)
	ld a, c
	cp $3
	jr nz, .asm_fc17c
	call Func_fc1cd
	jr .asm_fc17f
.asm_fc17c
	call Func_fc18d
.asm_fc17f
	ld hl, $de33
	add hl, bc
	ld e, l
	ld d, h
	pop hl
	ld a, [hli]
	ld [de], a
	ld e, l
	ld d, h
	jp Func_fc105

Func_fc18d: ; fc18d (3f:418d)
	ld hl, $de2f
	add hl, bc
	ld a, [hl]
	or a
	jr z, .asm_fc1cc
	ld hl, $de37
	add hl, bc
	add hl, bc
	bit 7, a
	jr z, .asm_fc1aa
	xor $ff
	inc a
	ld d, a
	ld a, [hl]
	sub d
	ld [hli], a
	ld e, a
	ld a, [hl]
	sbc b
	jr .asm_fc1b1
.asm_fc1aa
	ld d, a
	ld a, [hl]
	add d
	ld [hli], a
	ld e, a
	ld a, [hl]
	adc b
.asm_fc1b1
	ld [hl], a
	ld hl, $de2b
	add hl, bc
	ld d, [hl]
	ld [hl], $0
	or d
	ld d, a
	ld hl, $ff11
	ld a, c
	add a
	add a
	add c
	add l
	ld l, a
	ld a, [hl]
	and $c0
	ld [hli], a
	inc hl
	ld a, e
	ld [hli], a
	ld [hl], d
.asm_fc1cc
	ret

Func_fc1cd: ; fc1cd (3f:41cd)
	ld hl, $de32
	ld a, [hl]
	or a
	jr z, .asm_fc201
	ld hl, $de3d
	bit 7, a
	jr z, .asm_fc1e5
	xor $ff
	inc a
	ld d, a
	ld e, [hl]
	ld a, e
	sub d
	ld [hl], a
	jr .asm_fc1ea
.asm_fc1e5
	ld d, a
	ld e, [hl]
	ld a, e
	add d
	ld [hl], a
.asm_fc1ea
	ld d, a
	xor e
	and $8
	swap a
	ld hl, $de2e
	ld e, [hl]
	ld [hl], $0
	or e
	ld e, a
	ld hl, $ff20
	xor a
	ld [hli], a
	inc hl
	ld a, d
	ld [hli], a
	ld [hl], e
.asm_fc201
	ret

Func_fc202: ; fc202 (3f:4202)
	add a
	ld d, $0
	ld e, a
	ld hl, Unknown_fc485
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $0
	ld [$ff1a], a
	ld b, d
	ld de, $ff30
.asm_fc215
	ld a, [hli]
	ld [de], a
	inc de
	inc b
	ld a, b
	cp $10
	jr nz, .asm_fc215
	ld a, $1
	ld [$dd8b], a
	ld a, $80
	ld [$ff1a], a
	ld b, $0
	pop hl
	jp Func_fc094

Func_fc22d: ; fc22d (3f:422d)
	pop hl
	ld a, [hli]
	push hl
	push bc
	inc c
	ld e, $ee
.asm_fc234
	dec c
	jr z, .asm_fc23c
	rlca
	rlc e
	jr .asm_fc234
.asm_fc23c
	ld d, a
	ld hl, $dd85
	ld a, [hl]
	and e
	or d
	ld [hl], a
	pop bc
	pop hl
	jp Func_fc094

Func_fc249: ; fc249 (3f:4249)
	ld e, c
	inc e
	ld a, $7f
.asm_fc24d
	rlca
	dec e
	jr nz, .asm_fc24d
	ld e, a
	ld a, [$dd8c]
	and e
	ld [$dd8c], a
	ld a, c
	rlca
	rlca
	add c
	ld e, a
	ld d, b
	ld hl, $ff12
	add hl, de
	ld a, $8
	ld [hli], a
	inc hl
	swap a
	ld [hl], a
	pop hl
	ret

Func_fc26c: ; fc26c (3f:426c)
	xor a
	ld [$de53], a
	ld [$dd83], a
	ld a, $80
	ld [$dd82], a
	ret

Func_fc279: ; fc279 (3f:4279)
	ld a, $8
	ld a, [$ff12]
	ld a, [$ff17]
	ld a, [$ff1c]
	ld a, [$ff21]
	ld a, $80
	ld a, [$ff14]
	ld a, [$ff19]
	ld a, [$ff23]
	xor a
	ld [$dd8c], a
	ret

NumberOfSFX: ; fc290 (3f:4290)
	db $60

SFXHeaderPointers: ; fc291 (3f:4291)
	dw SFX_Stop
	dw SFX_01
	dw SFX_02
	dw SFX_03
	dw SFX_04
	dw SFX_05
	dw SFX_06
	dw SFX_07
	dw SFX_08
	dw SFX_09
	dw SFX_0a
	dw SFX_0b
	dw SFX_0c
	dw SFX_0d
	dw SFX_0e
	dw SFX_0f
	dw SFX_10
	dw SFX_11
	dw SFX_12
	dw SFX_13
	dw SFX_14
	dw SFX_15
	dw SFX_16
	dw SFX_17
	dw SFX_18
	dw SFX_19
	dw SFX_1a
	dw SFX_1b
	dw SFX_1c
	dw SFX_1d
	dw SFX_1e
	dw SFX_1f
	dw SFX_20
	dw SFX_21
	dw SFX_22
	dw SFX_23
	dw SFX_24
	dw SFX_25
	dw SFX_26
	dw SFX_27
	dw SFX_28
	dw SFX_29
	dw SFX_2a
	dw SFX_2b
	dw SFX_2c
	dw SFX_2d
	dw SFX_2e
	dw SFX_2f
	dw SFX_30
	dw SFX_31
	dw SFX_32
	dw SFX_33
	dw SFX_34
	dw SFX_35
	dw SFX_36
	dw SFX_37
	dw SFX_38
	dw SFX_39
	dw SFX_3a
	dw SFX_3b
	dw SFX_3c
	dw SFX_3d
	dw SFX_3e
	dw SFX_3f
	dw SFX_40
	dw SFX_41
	dw SFX_42
	dw SFX_43
	dw SFX_44
	dw SFX_45
	dw SFX_46
	dw SFX_47
	dw SFX_48
	dw SFX_49
	dw SFX_4a
	dw SFX_4b
	dw SFX_4c
	dw SFX_4d
	dw SFX_4e
	dw SFX_4f
	dw SFX_50
	dw SFX_51
	dw SFX_52
	dw SFX_53
	dw SFX_54
	dw SFX_55
	dw SFX_56
	dw SFX_57
	dw SFX_58
	dw SFX_59
	dw SFX_5a
	dw SFX_5b
	dw SFX_5c
	dw SFX_5d
	dw SFX_5e
	dw SFX_5f

SFX_Stop: ; fc351 (3f:4351)
	db %0000

SFX_01: ; fc352 (3f:4352)
	db %0010
	dw SFX_01_Ch1

SFX_02: ; fc355 (3f:4355)
	db %0010
	dw SFX_02_Ch1

SFX_03: ; fc358 (3f:4358)
	db %0010
	dw SFX_03_Ch1

SFX_04: ; fc35b (3f:435b)
	db %0010
	dw SFX_04_Ch1

SFX_05: ; fc35e (3f:435e)
	db %0010
	dw SFX_05_Ch1

SFX_06: ; fc361 (3f:4361)
	db %0010
	dw SFX_06_Ch1

SFX_07: ; fc364 (3f:4364)
	db %1000
	dw SFX_07_Ch1

SFX_08: ; fc367 (3f:4367)
	db %1000
	dw SFX_08_Ch1

SFX_09: ; fc36a (3f:436a)
	db %1000
	dw SFX_09_Ch1

SFX_0a: ; fc36d (3f:436d)
	db %0010
	dw SFX_0a_Ch1

SFX_0b: ; fc370 (3f:4370)
	db %0010
	dw SFX_0b_Ch1

SFX_0c: ; fc373 (3f:4373)
	db %1000
	dw SFX_0c_Ch1

SFX_0d: ; fc376 (3f:4376)
	db %0010
	dw SFX_0d_Ch1

SFX_0e: ; fc379 (3f:4379)
	db %0010
	dw SFX_0e_Ch1

SFX_0f: ; fc37c (3f:437c)
	db %1000
	dw SFX_0f_Ch1

SFX_10: ; fc37f (3f:437f)
	db %0010
	dw SFX_10_Ch1

SFX_11: ; fc382 (3f:4382)
	db %0010
	dw SFX_11_Ch1

SFX_12: ; fc385 (3f:4385)
	db %0010
	dw SFX_12_Ch1

SFX_13: ; fc388 (3f:4388)
	db %0010
	dw SFX_13_Ch1

SFX_14: ; fc38b (3f:438b)
	db %0010
	dw SFX_14_Ch1

SFX_15: ; fc38e (3f:438e)
	db %0010
	dw SFX_15_Ch1

SFX_16: ; fc391 (3f:4391)
	db %1000
	dw SFX_16_Ch1

SFX_17: ; fc394 (3f:4394)
	db %1000
	dw SFX_17_Ch1

SFX_18: ; fc397 (3f:4397)
	db %1000
	dw SFX_18_Ch1

SFX_19: ; fc39a (3f:439a)
	db %1000
	dw SFX_19_Ch1

SFX_1a: ; fc39d (3f:439d)
	db %1000
	dw SFX_1a_Ch1

SFX_1b: ; fc3a0 (3f:43a0)
	db %1000
	dw SFX_1b_Ch1

SFX_1c: ; fc3a3 (3f:43a3)
	db %1000
	dw SFX_1c_Ch1

SFX_1d: ; fc3a6 (3f:43a6)
	db %1000
	dw SFX_1d_Ch1

SFX_1e: ; fc3a9 (3f:43a9)
	db %1000
	dw SFX_1e_Ch1

SFX_1f: ; fc3ac (3f:43ac)
	db %1000
	dw SFX_1f_Ch1

SFX_20: ; fc3af (3f:43af)
	db %1000
	dw SFX_20_Ch1

SFX_21: ; fc3b2 (3f:43b2)
	db %1000
	dw SFX_21_Ch1

SFX_22: ; fc3b5 (3f:43b5)
	db %1000
	dw SFX_22_Ch1

SFX_23: ; fc3b8 (3f:43b8)
	db %1000
	dw SFX_23_Ch1

SFX_24: ; fc3bb (3f:43bb)
	db %1000
	dw SFX_24_Ch1

SFX_25: ; fc3be (3f:43be)
	db %0010
	dw SFX_25_Ch1

SFX_26: ; fc3c1 (3f:43c1)
	db %0010
	dw SFX_26_Ch1

SFX_27: ; fc3c4 (3f:43c4)
	db %0010
	dw SFX_27_Ch1

SFX_28: ; fc3c7 (3f:43c7)
	db %1010
	dw SFX_28_Ch1
	dw SFX_28_Ch2

SFX_29: ; fc3cc (3f:43cc)
	db %1000
	dw SFX_29_Ch1

SFX_2a: ; fc3cf (3f:43cf)
	db %1000
	dw SFX_2a_Ch1

SFX_2b: ; fc3d2 (3f:43d2)
	db %0010
	dw SFX_2b_Ch1

SFX_2c: ; fc3d5 (3f:43d5)
	db %0010
	dw SFX_2c_Ch1

SFX_2d: ; fc3d8 (3f:43d8)
	db %1000
	dw SFX_2d_Ch1

SFX_2e: ; fc3db (3f:43db)
	db %1000
	dw SFX_2e_Ch1

SFX_2f: ; fc3de (3f:43de)
	db %1000
	dw SFX_2f_Ch1

SFX_30: ; fc3e1 (3f:43e1)
	db %1000
	dw SFX_30_Ch1

SFX_31: ; fc3e4 (3f:43e4)
	db %0010
	dw SFX_31_Ch1

SFX_32: ; fc3e7 (3f:43e7)
	db %1010
	dw SFX_32_Ch1
	dw SFX_32_Ch2

SFX_33: ; fc3ec (3f:43ec)
	db %1010
	dw SFX_33_Ch1
	dw SFX_33_Ch2

SFX_34: ; fc3f1 (3f:43f1)
	db %0010
	dw SFX_34_Ch1

SFX_35: ; fc3f4 (3f:43f4)
	db %1000
	dw SFX_35_Ch1

SFX_36: ; fc3f7 (3f:43f7)
	db %0010
	dw SFX_36_Ch1

SFX_37: ; fc3fa (3f:43fa)
	db %1010
	dw SFX_37_Ch1
	dw SFX_37_Ch2

SFX_38: ; fc3ff (3f:43ff)
	db %0010
	dw SFX_38_Ch1

SFX_39: ; fc402 (3f:4402)
	db %1010
	dw SFX_39_Ch1
	dw SFX_39_Ch2

SFX_3a: ; fc407 (3f:4407)
	db %0010
	dw SFX_3a_Ch1

SFX_3b: ; fc40a (3f:440a)
	db %0010
	dw SFX_3b_Ch1

SFX_3c: ; fc40d (3f:440d)
	db %0010
	dw SFX_3c_Ch1

SFX_3d: ; fc410 (3f:4410)
	db %0010
	dw SFX_3d_Ch1

SFX_3e: ; fc413 (3f:4413)
	db %0010
	dw SFX_3e_Ch1

SFX_3f: ; fc416 (3f:4416)
	db %1000
	dw SFX_3f_Ch1

SFX_40: ; fc419 (3f:4419)
	db %0010
	dw SFX_40_Ch1

SFX_41: ; fc41c (3f:441c)
	db %0010
	dw SFX_41_Ch1

SFX_42: ; fc41f (3f:441f)
	db %0010
	dw SFX_42_Ch1

SFX_43: ; fc422 (3f:4422)
	db %1000
	dw SFX_43_Ch1

SFX_44: ; fc425 (3f:4425)
	db %1000
	dw SFX_44_Ch1

SFX_45: ; fc428 (3f:4428)
	db %0010
	dw SFX_45_Ch1

SFX_46: ; fc42b (3f:442b)
	db %0010
	dw SFX_46_Ch1

SFX_47: ; fc42e (3f:442e)
	db %1000
	dw SFX_47_Ch1

SFX_48: ; fc431 (3f:4431)
	db %1000
	dw SFX_48_Ch1

SFX_49: ; fc434 (3f:4434)
	db %0010
	dw SFX_49_Ch1

SFX_4a: ; fc437 (3f:4437)
	db %0010
	dw SFX_4a_Ch1

SFX_4b: ; fc43a (3f:443a)
	db %1000
	dw SFX_4b_Ch1

SFX_4c: ; fc43d (3f:443d)
	db %0010
	dw SFX_4c_Ch1

SFX_4d: ; fc440 (3f:4440)
	db %0010
	dw SFX_4d_Ch1

SFX_4e: ; fc443 (3f:4443)
	db %0010
	dw SFX_4e_Ch1

SFX_4f: ; fc446 (3f:4446)
	db %0010
	dw SFX_4f_Ch1

SFX_50: ; fc449 (3f:4449)
	db %1010
	dw SFX_50_Ch1
	dw SFX_50_Ch2

SFX_51: ; fc44e (3f:444e)
	db %1010
	dw SFX_51_Ch1
	dw SFX_51_Ch2

SFX_52: ; fc453 (3f:4453)
	db %1010
	dw SFX_52_Ch1
	dw SFX_52_Ch2

SFX_53: ; fc458 (3f:4458)
	db %1010
	dw SFX_53_Ch1
	dw SFX_53_Ch2

SFX_54: ; fc45d (3f:445d)
	db %0010
	dw SFX_54_Ch1

SFX_55: ; fc460 (3f:4460)
	db %0010
	dw SFX_55_Ch1

SFX_56: ; fc463 (3f:4463)
	db %0010
	dw SFX_56_Ch1

SFX_57: ; fc466 (3f:4466)
	db %0010
	dw SFX_57_Ch1

SFX_58: ; fc469 (3f:4469)
	db %0010
	dw SFX_58_Ch1

SFX_59: ; fc46c (3f:446c)
	db %0010
	dw SFX_59_Ch1

SFX_5a: ; fc46f (3f:446f)
	db %0010
	dw SFX_5a_Ch1

SFX_5b: ; fc472 (3f:4472)
	db %0010
	dw SFX_5b_Ch1

SFX_5c: ; fc475 (3f:4475)
	db %1000
	dw SFX_5c_Ch1

SFX_5d: ; fc478 (3f:4478)
	db %1011
	dw SFX_5d_Ch1
	dw SFX_5d_Ch2
	dw SFX_5d_Ch3

SFX_5e: ; fc47f (3f:447f)
	db %0010
	dw SFX_5e_Ch1

SFX_5f: ; fc482 (3f:4482)
	db %1000
	dw SFX_5f_Ch1

Unknown_fc485: ; fc485 (3f:4485)
INCBIN "baserom.gbc",$fc485,$fc4df - $fc485

INCLUDE "audio/sfx/sfx_01.asm"
INCLUDE "audio/sfx/sfx_02.asm"
INCLUDE "audio/sfx/sfx_03.asm"
INCLUDE "audio/sfx/sfx_04.asm"
INCLUDE "audio/sfx/sfx_05.asm"
INCLUDE "audio/sfx/sfx_06.asm"
INCLUDE "audio/sfx/sfx_07.asm"
INCLUDE "audio/sfx/sfx_08.asm"
INCLUDE "audio/sfx/sfx_09.asm"
INCLUDE "audio/sfx/sfx_0a.asm"
INCLUDE "audio/sfx/sfx_0b.asm"
INCLUDE "audio/sfx/sfx_0c.asm"
INCLUDE "audio/sfx/sfx_0d.asm"
INCLUDE "audio/sfx/sfx_0e.asm"
INCLUDE "audio/sfx/sfx_0f.asm"
INCLUDE "audio/sfx/sfx_10.asm"
INCLUDE "audio/sfx/sfx_11.asm"
INCLUDE "audio/sfx/sfx_12.asm"
INCLUDE "audio/sfx/sfx_13.asm"
INCLUDE "audio/sfx/sfx_14.asm"
INCLUDE "audio/sfx/sfx_15.asm"
INCLUDE "audio/sfx/sfx_16.asm"
INCLUDE "audio/sfx/sfx_17.asm"
INCLUDE "audio/sfx/sfx_18.asm"
INCLUDE "audio/sfx/sfx_19.asm"
INCLUDE "audio/sfx/sfx_1a.asm"
INCLUDE "audio/sfx/sfx_1b.asm"
INCLUDE "audio/sfx/sfx_1c.asm"
INCLUDE "audio/sfx/sfx_1d.asm"
INCLUDE "audio/sfx/sfx_1e.asm"
INCLUDE "audio/sfx/sfx_1f.asm"
INCLUDE "audio/sfx/sfx_20.asm"
INCLUDE "audio/sfx/sfx_21.asm"
INCLUDE "audio/sfx/sfx_22.asm"
INCLUDE "audio/sfx/sfx_23.asm"
INCLUDE "audio/sfx/sfx_24.asm"
INCLUDE "audio/sfx/sfx_25.asm"
INCLUDE "audio/sfx/sfx_26.asm"
INCLUDE "audio/sfx/sfx_27.asm"
INCLUDE "audio/sfx/sfx_28.asm"
INCLUDE "audio/sfx/sfx_29.asm"
INCLUDE "audio/sfx/sfx_2a.asm"
INCLUDE "audio/sfx/sfx_2b.asm"
INCLUDE "audio/sfx/sfx_2c.asm"
INCLUDE "audio/sfx/sfx_2d.asm"
INCLUDE "audio/sfx/sfx_2e.asm"
INCLUDE "audio/sfx/sfx_2f.asm"
INCLUDE "audio/sfx/sfx_30.asm"
INCLUDE "audio/sfx/sfx_31.asm"
INCLUDE "audio/sfx/sfx_32.asm"
INCLUDE "audio/sfx/sfx_33.asm"
INCLUDE "audio/sfx/sfx_34.asm"
INCLUDE "audio/sfx/sfx_35.asm"
INCLUDE "audio/sfx/sfx_36.asm"
INCLUDE "audio/sfx/sfx_37.asm"
INCLUDE "audio/sfx/sfx_38.asm"
INCLUDE "audio/sfx/sfx_39.asm"
INCLUDE "audio/sfx/sfx_3a.asm"
INCLUDE "audio/sfx/sfx_3b.asm"
INCLUDE "audio/sfx/sfx_3c.asm"
INCLUDE "audio/sfx/sfx_3d.asm"
INCLUDE "audio/sfx/sfx_3e.asm"
INCLUDE "audio/sfx/sfx_3f.asm"
INCLUDE "audio/sfx/sfx_40.asm"
INCLUDE "audio/sfx/sfx_41.asm"
INCLUDE "audio/sfx/sfx_42.asm"
INCLUDE "audio/sfx/sfx_43.asm"
INCLUDE "audio/sfx/sfx_44.asm"
INCLUDE "audio/sfx/sfx_45.asm"
INCLUDE "audio/sfx/sfx_46.asm"
INCLUDE "audio/sfx/sfx_47.asm"
INCLUDE "audio/sfx/sfx_48.asm"
INCLUDE "audio/sfx/sfx_49.asm"
INCLUDE "audio/sfx/sfx_4a.asm"
INCLUDE "audio/sfx/sfx_4b.asm"
INCLUDE "audio/sfx/sfx_4c.asm"
INCLUDE "audio/sfx/sfx_4d.asm"
INCLUDE "audio/sfx/sfx_4e.asm"
INCLUDE "audio/sfx/sfx_4f.asm"
INCLUDE "audio/sfx/sfx_50.asm"
INCLUDE "audio/sfx/sfx_51.asm"
INCLUDE "audio/sfx/sfx_52.asm"
INCLUDE "audio/sfx/sfx_53.asm"
INCLUDE "audio/sfx/sfx_54.asm"
INCLUDE "audio/sfx/sfx_55.asm"
INCLUDE "audio/sfx/sfx_56.asm"
INCLUDE "audio/sfx/sfx_57.asm"
INCLUDE "audio/sfx/sfx_58.asm"
INCLUDE "audio/sfx/sfx_59.asm"
INCLUDE "audio/sfx/sfx_5a.asm"
INCLUDE "audio/sfx/sfx_5b.asm"
INCLUDE "audio/sfx/sfx_5c.asm"
INCLUDE "audio/sfx/sfx_5d.asm"
INCLUDE "audio/sfx/sfx_5e.asm"
INCLUDE "audio/sfx/sfx_5f.asm"