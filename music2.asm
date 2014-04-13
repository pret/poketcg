Func_f8000: ; f8000 (3e:4000)
	jp Func_f807d

Func_f8003: ; f8003 (3e:4003)
	jp Func_f80e9

Func_f8006: ; f8006 (3e:4006)
	jp Func_f8021

Func_f8009: ; f8009 (3e:4009)
	jp Func_f802d

Func_f800c: ; f800c (3e:400c)
	jp Func_f804e

Func_f800f: ; f800f (3e:400f)
	jp Func_f8052

Func_f8012: ; f8012 (3e:4012)
	jp Func_f805c

Func_f8015: ; f8015 (3e:4015)
	jp Func_f8066

Func_f8018: ; f8018 (3e:4018)
	jp Func_f806f

Func_f801b: ; f801b (3e:401b)
	jp Func_f89c4

Func_f801e: ; f801e (3e:401e)
	jp Func_f89d0

Func_f8021: ; f8021 (3e:4021)
	push hl
	ld hl, NumberOfSongs2
	cp [hl]
	jr nc, .asm_f802b
	ld [$dd80], a
.asm_f802b
	pop hl
	ret

Func_f802d: ; f802d (3e:402d)
	push bc
	push hl
	ld b, $0
	ld c, a
	or a
	jr z, .asm_f8043
	ld hl, $4e85
	add hl, bc
	ld b, [hl]
	ld a, [$dd83]
	or a
	jr z, .asm_f8043
	cp b
	jr c, .asm_f804b
.asm_f8043
	ld a, b
	ld [$dd83], a
	ld a, c
	ld [$dd82], a
.asm_f804b
	pop hl
	pop bc
	ret

Func_f804e: ; f804e (3e:404e)
	ld [$ddf0], a
	ret

Func_f8052: ; f8052 (3e:4052)
	ld a, [$dd80]
	cp $80
	ld a, $1
	ret nz
	xor a
	ret

Func_f805c: ; f805c (3e:405c)
	ld a, [$dd82]
	cp $80
	ld a, $1
	ret nz
	xor a
	ret

Func_f8066: ; f8066 (3e:4066)
	ld a, [$ddf2]
	xor $1
	ld [$ddf2], a
	ret

Func_f806f: ; f806f (3e:406f)
	push bc
	push af
	and $7
	ld b, a
	swap b
	or b
	ld [$ddf1], a
	pop af
	pop bc
	ret

Func_f807d: ; f807d (3e:407d)
	xor a
	ld [$ff26], a
	ld a, $80
	ld [$ff26], a
	ld a, $77
	ld [$ff24], a
	ld a, $ff
	ld [$ff25], a
	ld a, $3d
	ld [$dd81], a
	ld a, $80
	ld [$dd80], a
	ld [$dd82], a
	ld a, $77
	ld [$ddf1], a
	xor a
	ld [$dd8c], a
	ld [$de53], a
	ld [$dd8b], a
	ld [$ddef], a
	ld [$ddf0], a
	ld [$ddf2], a
	dec a
	ld [$dd84], a
	ld de, $0001
	ld bc, $0000
.asm_f80bb
	ld hl, $dd8d
	add hl, bc
	ld [hl], d
	ld hl, $dd91
	add hl, bc
	ld [hl], d
	ld hl, $ddb3
	add hl, bc
	ld [hl], d
	ld hl, $ddcb
	add hl, bc
	ld [hl], d
	ld hl, $ddbf
	add hl, bc
	ld [hl], d
	inc c
	ld a, c
	cp $4
	jr nz, .asm_f80bb
	ld hl, Unknown_f8c20
	ld bc, $ddf3
	ld d, $8
.asm_f80e2
	ld a, [hli]
	ld [bc], a
	inc bc
	dec d
	jr nz, .asm_f80e2
	ret

Func_f80e9: ; f80e9 (3e:40e9)
	call Func_f82a4
	call Func_f811c
	ld hl, $4003
	call Bankswitch3dTo3f
	ld a, [$dd81]
	ld [$ff80], a
	ld [$2000], a
	ld a, [$ddf2]
	cp $0
	jr z, .asm_f8109
	call Func_f8980
	jr .asm_f8115
.asm_f8109
	call Func_f82a5
	call Func_f830a
	call Func_f836f
	call Func_f83ce
.asm_f8115
	call Func_f8866
	call Func_f89b1
	ret

Func_f811c: ; f811c (3e:411c)
	ld a, [$dd80]
	rla
	jr c, .asm_f8133
	call Func_f814b
	ld a, [$dd80]
	call Func_f818c
	ld a, [$dd80]
	or $80
	ld [$dd80], a
.asm_f8133
	ld a, [$dd82]
	rla
	jr c, .asm_f814a
	ld a, [$dd82]
	ld hl, $4000
	call Bankswitch3dTo3f
	ld a, [$dd82]
	or $80
	ld [$dd82], a
.asm_f814a
	ret

Func_f814b: ; f814b (3e:414b)
	ld a, [$dd8c]
	ld d, a
	xor a
	ld [$dd8d], a
	bit 0, d
	jr nz, .asm_f815f
	ld a, $8
	ld [$ff12], a
	swap a
	ld [$ff14], a
.asm_f815f
	xor a
	ld [$dd8e], a
	bit 1, d
	jr nz, .asm_f816f
	ld a, $8
	ld [$ff17], a
	swap a
	ld [$ff19], a
.asm_f816f
	xor a
	ld [$dd90], a
	bit 3, d
	jr nz, .asm_f817f
	ld a, $8
	ld [$ff21], a
	swap a
	ld [$ff23], a
.asm_f817f
	xor a
	ld [$dd8f], a
	bit 2, d
	jr nz, .asm_f818b
	ld a, $0
	ld [$ff1c], a
.asm_f818b
	ret

Func_f818c: ; f818c (3e:418c)
	push af
	ld c, a
	ld b, $0
	ld hl, SongBanks1
	add hl, bc
	ld a, [hl]
	ld [$dd81], a
	ld [$ff80], a
	ld [$2000], a
	pop af
	add a
	ld c, a
	ld b, $0
	ld hl, SongHeaderPointers1
	add hl, bc
	ld e, [hl]
	inc hl
	ld h, [hl]
	ld l, e
	ld e, [hl]
	inc hl
	ld b, h
	ld c, l
	rr e
	jr nc, .asm_f81eb
	ld a, [bc]
	inc bc
	ld [$dd95], a
	ld [$dd9d], a
	ld a, [bc]
	inc bc
	ld [$dd96], a
	ld [$dd9e], a
	ld a, $1
	ld [$ddbb], a
	ld [$dd8d], a
	xor a
	ld [$dd91], a
	ld [$ddea], a
	ld [$ddbf], a
	ld [$dddf], a
	ld [$ddcb], a
	ld a, [Unknown_f8c20]
	ld [$ddf3], a
	ld a, [Unknown_f8c20 + 1]
	ld [$ddf4], a
	ld a, $8
	ld [$ddc7], a
.asm_f81eb
	rr e
	jr nc, .asm_f8228
	ld a, [bc]
	inc bc
	ld [$dd97], a
	ld [$dd9f], a
	ld a, [bc]
	inc bc
	ld [$dd98], a
	ld [$dda0], a
	ld a, $1
	ld [$ddbc], a
	ld [$dd8e], a
	xor a
	ld [$dd92], a
	ld [$ddeb], a
	ld [$ddc0], a
	ld [$dde0], a
	ld [$ddcc], a
	ld a, [Unknown_f8c20 + 2]
	ld [$ddf5], a
	ld a, [Unknown_f8c20 + 3]
	ld [$ddf6], a
	ld a, $8
	ld [$ddc8], a
.asm_f8228
	rr e
	jr nc, .asm_f8265
	ld a, [bc]
	inc bc
	ld [$dd99], a
	ld [$dda1], a
	ld a, [bc]
	inc bc
	ld [$dd9a], a
	ld [$dda2], a
	ld a, $1
	ld [$ddbd], a
	ld [$dd8f], a
	xor a
	ld [$dd93], a
	ld [$ddec], a
	ld [$ddc1], a
	ld [$dde1], a
	ld [$ddcd], a
	ld a, [Unknown_f8c20 + 4]
	ld [$ddf7], a
	ld a, [Unknown_f8c20 + 5]
	ld [$ddf8], a
	ld a, $40
	ld [$ddc9], a
.asm_f8265
	rr e
	jr nc, .asm_f829f
	ld a, [bc]
	inc bc
	ld [$dd9b], a
	ld [$dda3], a
	ld a, [bc]
	inc bc
	ld [$dd9c], a
	ld [$dda4], a
	ld a, $1
	ld [$ddbe], a
	ld [$dd90], a
	xor a
	ld [$dd94], a
	ld [$ddc2], a
	ld [$dde2], a
	ld [$ddce], a
	ld a, [Unknown_f8c20 + 6]
	ld [$ddf9], a
	ld a, [Unknown_f8c20 + 7]
	ld [$ddfa], a
	ld a, $40
	ld [$ddca], a
.asm_f829f
	xor a
	ld [$ddf2], a
	ret

Func_f82a4: ; f82a4 (3e:42a4)
	ret

Func_f82a5: ; f82a5 (3e:42a5)
	ld a, [$dd8d]
	or a
	jr z, .asm_f82fa
	ld a, [$ddb7]
	cp $0
	jr z, .asm_f82d4
	ld a, [$ddc3]
	dec a
	ld [$ddc3], a
	jr nz, .asm_f82d4
	ld a, [$ddbb]
	cp $1
	jr z, .asm_f82d4
	ld a, [$dd8c]
	bit 0, a
	jr nz, .asm_f82d4
	ld hl, $ff12
	ld a, [$ddc7]
	ld [hli], a
	inc hl
	ld a, $80
	ld [hl], a
.asm_f82d4
	ld a, [$ddbb]
	dec a
	ld [$ddbb], a
	jr nz, .asm_f82f4
	ld a, [$dd96]
	ld h, a
	ld a, [$dd95]
	ld l, a
	ld bc, $0000
	call Func_f8414
	ld a, [$dd8d]
	or a
	jr z, .asm_f82fa
	call Func_f8714
.asm_f82f4
	ld a, $0
	call Func_f885a
	ret
.asm_f82fa
	ld a, [$dd8c]
	bit 0, a
	jr nz, .asm_f8309
	ld a, $8
	ld [$ff12], a
	swap a
	ld [$ff14], a
.asm_f8309
	ret

Func_f830a: ; f830a (3e:430a)
	ld a, [$dd8e]
	or a
	jr z, .asm_f835f
	ld a, [$ddb8]
	cp $0
	jr z, .asm_f8339
	ld a, [$ddc4]
	dec a
	ld [$ddc4], a
	jr nz, .asm_f8339
	ld a, [$ddbc]
	cp $1
	jr z, .asm_f8339
	ld a, [$dd8c]
	bit 1, a
	jr nz, .asm_f8339
	ld hl, $ff17
	ld a, [$ddc8]
	ld [hli], a
	inc hl
	ld a, $80
	ld [hl], a
.asm_f8339
	ld a, [$ddbc]
	dec a
	ld [$ddbc], a
	jr nz, .asm_f8359
	ld a, [$dd98]
	ld h, a
	ld a, [$dd97]
	ld l, a
	ld bc, $0001
	call Func_f8414
	ld a, [$dd8e]
	or a
	jr z, .asm_f835f
	call Func_f875a
.asm_f8359
	ld a, $1
	call Func_f885a
	ret
.asm_f835f
	ld a, [$dd8c]
	bit 1, a
	jr nz, .asm_f836e
	ld a, $8
	ld [$ff17], a
	swap a
	ld [$ff19], a
.asm_f836e
	ret

Func_f836f: ; f836f (3e:436f)
	ld a, [$dd8f]
	or a
	jr z, .asm_f83be
	ld a, [$ddb9]
	cp $0
	jr z, .asm_f8398
	ld a, [$ddc5]
	dec a
	ld [$ddc5], a
	jr nz, .asm_f8398
	ld a, [$dd8c]
	bit 2, a
	jr nz, .asm_f8398
	ld a, [$ddbd]
	cp $1
	jr z, .asm_f8398
	ld a, [$ddc9]
	ld [$ff1c], a
.asm_f8398
	ld a, [$ddbd]
	dec a
	ld [$ddbd], a
	jr nz, .asm_f83b8
	ld a, [$dd9a]
	ld h, a
	ld a, [$dd99]
	ld l, a
	ld bc, $0002
	call Func_f8414
	ld a, [$dd8f]
	or a
	jr z, .asm_f83be
	call Func_f879c
.asm_f83b8
	ld a, $2
	call Func_f885a
	ret
.asm_f83be
	ld a, [$dd8c]
	bit 2, a
	jr nz, .asm_f83cd
	ld a, $0
	ld [$ff1c], a
	ld a, $80
	ld [$ff1e], a
.asm_f83cd
	ret

Func_f83ce: ; f83ce (3e:43ce)
	ld a, [$dd90]
	or a
	jr z, .asm_f8400
	ld a, [$ddbe]
	dec a
	ld [$ddbe], a
	jr nz, .asm_f83f6
	ld a, [$dd9c]
	ld h, a
	ld a, [$dd9b]
	ld l, a
	ld bc, $0003
	call Func_f8414
	ld a, [$dd90]
	or a
	jr z, .asm_f8400
	call Func_f880a
	jr .asm_f8413
.asm_f83f6
	ld a, [$ddef]
	or a
	jr z, .asm_f8413
	call Func_f8839
	ret
.asm_f8400
	ld a, [$dd8c]
	bit 3, a
	jr nz, .asm_f8413
	xor a
	ld [$ddef], a
	ld a, $8
	ld [$ff21], a
	swap a
	ld [$ff23], a
.asm_f8413
	ret

Func_f8414: ; f8414 (3e:4414)
	ld a, [hli]
	push hl
	push af
	cp $d0
	jr c, .asm_f848c
	sub $d0
	add a
	ld e, a
	ld d, $0
	ld hl, .data_f842c
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld h, d
	ld l, e
	pop af
	jp [hl]

.data_f842c
	dw Func_f8598
	dw Func_f85a3
	dw Func_f85a3
	dw Func_f85a3
	dw Func_f85a3
	dw Func_f85a3
	dw Func_f85a3
	dw Func_f85bb
	dw Func_f85c3
	dw Func_f85cb
	dw Func_f86f4
	dw Func_f86f4
	dw Func_f85d4
	dw Func_f85ef
	dw Func_f85fd
	dw Func_f8609
	dw Func_f861e
	dw Func_f8638
	dw Func_f863f
	dw Func_f8656
	dw Func_f8667
	dw Func_f8674
	dw Func_f8683
	dw Func_f8690
	dw Func_f86a0
	dw Func_f86ad
	dw Func_f86ba
	dw Func_f86cc
	dw Func_f86d9
	dw Func_f86e6
	dw Func_f86f4
	dw Func_f86f4
	dw Func_f86f4
	dw Func_f86f4
	dw Func_f86f4
	dw Func_f86f4
	dw Func_f86f4
	dw Func_f86f4
	dw Func_f86f4
	dw Func_f86f4
	dw Func_f86f4
	dw Func_f86f4
	dw Func_f86f4
	dw Func_f86f4
	dw Func_f86f4
	dw Func_f86f4
	dw Func_f86f4
	dw Func_f86f4

.asm_f848c
	push af
	ld a, [hl]
	ld e, a
	ld hl, $dd91
	add hl, bc
	ld a, [hl]
	cp $80
	jr z, .asm_f84b0
	ld [hl], $1
	xor a
	ld hl, $dddb
	add hl, bc
	ld [hl], a
	ld hl, $dde3
	add hl, bc
	ld [hl], a
	inc [hl]
	ld hl, $ddd7
	add hl, bc
	ld a, [hl]
	ld hl, $ddd3
	add hl, bc
	ld [hl], a
.asm_f84b0
	pop af
	push de
	ld hl, $ddcf
	add hl, bc
	ld d, [hl]
	and $f
	inc a
	cp d
	jr nc, .asm_f84c0
	ld e, a
	ld a, d
	ld d, e
.asm_f84c0
	ld e, a
.asm_f84c1
	dec d
	jr z, .asm_f84c7
	add e
	jr .asm_f84c1
.asm_f84c7
	ld hl, $ddbb
	add hl, bc
	ld [hl], a
	pop de
	ld d, a
	ld a, e
	cp $d9
	ld a, d
	jr z, .asm_f84fb
	ld e, a
	ld hl, $ddbf
	add hl, bc
	ld a, [hl]
	cp $8
	ld d, a
	ld a, e
	jr z, .asm_f84fb
	push hl
	push bc
	ld b, $0
	ld c, a
	ld hl, $0000
.asm_f84e8
	add hl, bc
	dec d
	jr nz, .asm_f84e8
	srl h
	rr l
	srl h
	rr l
	srl h
	rr l
	ld a, l
	pop bc
	pop hl
.asm_f84fb
	ld hl, $ddc3
	add hl, bc
	ld [hl], a
	pop af
	and $f0
	ld hl, $ddb7
	add hl, bc
	ld [hl], a
	or a
	jr nz, .asm_f850e
	jp .asm_f858e
.asm_f850e
	swap a
	dec a
	ld h, a
	ld a, $3
	cp c
	ld a, h
	jr z, .asm_f851a
	jr .asm_f8564
.asm_f851a
	push af
	ld hl, $ddaf
	add hl, bc
	ld a, [hl]
	ld d, a
	sla a
	add d
	sla a
	sla a
	sla a
	ld e, a
	pop af
	ld hl, PointerTable_f8d34
	add a
	ld d, c
	ld c, a
	add hl, bc
	ld c, e
	add hl, bc
	ld c, d
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld d, a
	ld a, [$dd84]
	and $77
	or d
	ld [$dd84], a
	ld de, $ddab
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, b
	ld [de], a
	ld b, $0
	ld a, l
	ld d, h
	ld hl, $dded
	ld [hli], a
	ld [hl], d
	ld a, $1
	ld [$ddef], a
	jr .asm_f858e
.asm_f8564
	ld hl, $dda5
	add hl, bc
	add hl, bc
	push hl
	ld hl, $ddaf
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld hl, Unknown_f8c28
	add hl, de
	add a
	ld e, [hl]
	add e
	ld hl, $ddcb
	add hl, bc
	ld e, [hl]
	add e
	add e
	ld e, a
	ld hl, $4c30
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	call Func_f8967
	pop hl
	ld a, e
	ld [hli], a
	ld [hl], d
.asm_f858e
	pop de
	ld hl, $dd95
	add hl, bc
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ret

Func_f8598: ; f8598 (3e:4598)
	pop hl
	ld a, [hli]
	push hl
	ld hl, $ddcf
	add hl, bc
	ld [hl], a
	jp Func_f8710

Func_f85a3: ; f85a3 (3e:45a3)
	and $7
	dec a
	ld hl, $ddaf
	add hl, bc
	push af
	ld a, c
	cp $2
	jr nz, .asm_f85b6
	pop af
	inc a
	ld [hl], a
	jp Func_f8710
.asm_f85b6
	pop af
	ld [hl], a
	jp Func_f8710

Func_f85bb: ; f85bb (3e:45bb)
	ld hl, $ddaf
	add hl, bc
	inc [hl]
	jp Func_f8710

Func_f85c3: ; f85c3 (3e:45c3)
	ld hl, $ddaf
	add hl, bc
	dec [hl]
	jp Func_f8710

Func_f85cb: ; f85cb (3e:45cb)
	ld hl, $dd91
	add hl, bc
	ld [hl], $80
	jp Func_f8710

Func_f85d4: ; f85d4 (3e:45d4)
	pop hl
	ld a, [hli]
	push hl
	push bc
	inc c
	ld e, $ee
.asm_f85db
	dec c
	jr z, .asm_f85e3
	rlca
	rlc e
	jr .asm_f85db
.asm_f85e3
	ld d, a
	ld hl, $dd84
	ld a, [hl]
	and e
	or d
	ld [hl], a
	pop bc
	jp Func_f8710

Func_f85ef: ; f85ef (3e:45ef)
	pop de
	push de
	dec de
	ld hl, $dd9d
	add hl, bc
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	jp Func_f8710

Func_f85fd: ; f85fd (3e:45fd)
	pop hl
	ld hl, $dd9d
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp Func_f8414

Func_f8609: ; f8609 (3e:4609)
	pop de
	ld a, [de]
	inc de
	push af
	call Func_f86fc
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	pop af
	ld [hl], a
	inc hl
	push de
	call Func_f8705
	jp Func_f8710

Func_f861e: ; f861e (3e:461e)
	call Func_f86fc
	dec hl
	ld a, [hl]
	dec a
	jr z, .asm_f8630
	ld [hld], a
	ld d, [hl]
	dec hl
	ld e, [hl]
	pop hl
	ld h, d
	ld l, e
	jp Func_f8414
.asm_f8630
	dec hl
	dec hl
	call Func_f8705
	jp Func_f8710

Func_f8638: ; f8638 (3e:4638)
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp Func_f8414

Func_f863f: ; f863f (3e:463f)
	call Func_f86fc
	pop de
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	ld d, a
	ld e, b
	ld b, $0
	push de
	call Func_f8705
	jp Func_f8710

Func_f8656: ; f8656 (3e:4656)
	pop de
	call Func_f86fc
	dec hl
	ld a, [hld]
	ld e, [hl]
	ld d, a
	inc de
	inc de
	push de
	call Func_f8705
	jp Func_f8710

Func_f8667: ; f8667 (3e:4667)
	pop de
	ld a, [de]
	inc de
	ld hl, $ddea
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Func_f8414

Func_f8674: ; f8674 (3e:4674)
	pop de
	ld a, [de]
	and $c0
	inc de
	ld hl, $dd86
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Func_f8414

Func_f8683: ; f8683 (3e:4683)
	pop de
	ld a, [de]
	inc de
	ld hl, $dde7
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Func_f8414

Func_f8690: ; f8690 (3e:4690)
	pop de
	ld a, [de]
	inc de
	ld [$dd8a], a
	ld a, $1
	ld [$dd8b], a
	ld h, d
	ld l, e
	jp Func_f8414

Func_f86a0: ; f86a0 (3e:46a0)
	pop de
	ld a, [de]
	inc de
	ld hl, $ddbf
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Func_f8414

Func_f86ad: ; f86ad (3e:46ad)
	pop de
	ld a, [de]
	inc de
	ld hl, $ddc7
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Func_f8414

Func_f86ba: ; f86ba (3e:46ba)
	pop de
	ld a, [de]
	inc de
	ld hl, $ddd3
	add hl, bc
	ld [hl], a
	ld hl, $ddd7
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Func_f8414

Func_f86cc: ; f86cc (3e:46cc)
	pop de
	ld a, [de]
	inc de
	ld hl, $dddf
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Func_f8414

Func_f86d9: ; f86d9 (3e:46d9)
	pop de
	ld a, [de]
	inc de
	ld hl, $ddcb
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Func_f8414

Func_f86e6: ; f86e6 (3e:46e6)
	pop de
	ld a, [de]
	inc de
	ld hl, $ddcb
	add hl, bc
	add [hl]
	ld [hl], a
	ld h, d
	ld l, e
	jp Func_f8414

Func_f86f4: ; f86f4 (3e:46f4)
	ld hl, $dd8d
	add hl, bc
	ld [hl], $0
	pop hl
	ret

Func_f86fc: ; f86fc (3e:46fc)
	ld hl, $ddf3
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

Func_f8705: ; f8705 (3e:4705)
	ld d, h
	ld e, l
	ld hl, $ddf3
	add hl, bc
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ret

Func_f8710: ; f8710 (3e:4710)
	pop hl
	jp Func_f8414

Func_f8714: ; f8714 (3e:4714)
	ld a, [$dd8c]
	bit 0, a
	jr nz, .asm_f8749
	ld a, [$ddb7]
	cp $0
	jr z, .asm_f874a
	ld d, $0
	ld hl, $dd91
	ld a, [hl]
	cp $80
	jr z, .asm_f8733
	ld a, [$dde7]
	ld [$ff12], a
	ld d, $80
.asm_f8733
	ld [hl], $2
	ld a, $8
	ld [$ff10], a
	ld a, [$dd86]
	ld [$ff11], a
	ld a, [$dda5]
	ld [$ff13], a
	ld a, [$dda6]
	or d
	ld [$ff14], a
.asm_f8749
	ret
.asm_f874a
	ld hl, $dd91
	ld [hl], $0
	ld hl, $ff12
	ld a, $8
	ld [hli], a
	inc hl
	swap a
	ld [hl], a
	ret

Func_f875a: ; f875a (3e:475a)
	ld a, [$dd8c]
	bit 1, a
	jr nz, .asm_f878b
	ld a, [$ddb8]
	cp $0
	jr z, .asm_f878c
	ld d, $0
	ld hl, $dd92
	ld a, [hl]
	cp $80
	jr z, .asm_f8779
	ld a, [$dde8]
	ld [$ff17], a
	ld d, $80
.asm_f8779
	ld [hl], $2
	ld a, [$dd87]
	ld [$ff16], a
	ld a, [$dda7]
	ld [$ff18], a
	ld a, [$dda8]
	or d
	ld [$ff19], a
.asm_f878b
	ret
.asm_f878c
	ld hl, $dd92
	ld [hl], $0
	ld hl, $ff17
	ld a, $8
	ld [hli], a
	inc hl
	swap a
	ld [hl], a
	ret

Func_f879c: ; f879c (3e:479c)
	ld a, [$dd8c]
	bit 2, a
	jr nz, .asm_f87e0
	ld d, $0
	ld a, [$dd8b]
	or a
	jr z, .asm_f87b3
	xor a
	ld [$ff1a], a
	call Func_f87ea
	ld d, $80
.asm_f87b3
	ld a, [$ddb9]
	cp $0
	jr z, .asm_f87e1
	ld hl, $dd93
	ld a, [hl]
	cp $80
	jr z, .asm_f87cc
	ld a, [$dde9]
	ld [$ff1c], a
	xor a
	ld [$ff1a], a
	ld d, $80
.asm_f87cc
	ld [hl], $2
	xor a
	ld [$ff1b], a
	ld a, [$dda9]
	ld [$ff1d], a
	ld a, $80
	ld [$ff1a], a
	ld a, [$ddaa]
	or d
	ld [$ff1e], a
.asm_f87e0
	ret
.asm_f87e1
	ld hl, $dd91
	ld [hl], $0
	xor a
	ld [$ff1a], a
	ret

Func_f87ea: ; f879c (3e:47ea)
	ld a, [$dd8a]
	add a
	ld d, $0
	ld e, a
	ld hl, PointerTable_f8cda
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld b, d
	ld de, $ff30
.asm_f87fc
	ld a, [hli]
	ld [de], a
	inc de
	inc b
	ld a, b
	cp $10
	jr nz, .asm_f87fc
	xor a
	ld [$dd8b], a
	ret

Func_f880a: ; f880a (3e:480a)
	ld a, [$dd8c]
	bit 3, a
	jr nz, .asm_f8829
	ld a, [$ddba]
	cp $0
	jr z, asm_f882a
	ld de, $ff20
	ld hl, $ddab
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
.asm_f8829
	ret
asm_f882a
	xor a
	ld [$ddef], a
	ld hl, $ff21
	ld a, $8
	ld [hli], a
	inc hl
	swap a
	ld [hl], a
	ret

Func_f8839: ; f8839 (3e:4839)
	ld a, [$dd8c]
	bit 3, a
	jr z, .asm_f8846
	xor a
	ld [$ddef], a
	jr .asm_f8859
.asm_f8846
	ld hl, $dded
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld a, [de]
	cp $ff
	jr nz, .asm_f8853
	jr asm_f882a
.asm_f8853
	ld [$ff22], a
	inc de
	ld a, d
	ld [hld], a
	ld [hl], e
.asm_f8859
	ret

Func_f885a: ; f885a (3e:485a)
	push af
	ld b, $0
	ld c, a
	call Func_f8898
	pop af
	call Func_f890b
	ret

Func_f8866: ; f8866 (3e:4866)
	ld a, [$ddf1]
	ld [$ff24], a
	ld a, [$dd8c]
	or a
	ld hl, $dd84
	ld a, [hli]
	jr z, .asm_f8888
	ld a, [$dd8c]
	and $f
	ld d, a
	swap d
	or d
	ld d, a
	xor $ff
	ld e, a
	ld a, [hld]
	and d
	ld d, a
	ld a, [hl]
	and e
	or d
.asm_f8888
	ld d, a
	ld a, [$ddf0]
	xor $ff
	and $f
	ld e, a
	swap e
	or e
	and d
	ld [$ff25], a
	ret

Func_f8898: ; f8898 (3e:4898)
	ld hl, $dddf
	add hl, bc
	ld a, [hl]
	cp $0
	jr z, .asm_f8902
	ld hl, $dde3
	add hl, bc
	cp [hl]
	jr z, .asm_f88ab
	inc [hl]
	jr .asm_f8902
.asm_f88ab
	ld hl, $ddd3
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld hl, PointerTable_f8dde
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld hl, $dddb
	add hl, bc
	ld d, $0
	ld e, [hl]
	inc [hl]
	pop hl
	add hl, de
	ld a, [hli]
	cp $80
	jr z, .asm_f88ee
	ld hl, $dda5
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	bit 7, a
	jr nz, .asm_f88df
	add e
	ld e, a
	ld a, $0
	adc d
	and $7
	ld d, a
	ret
.asm_f88df
	xor $ff
	inc a
	push bc
	ld c, a
	ld a, e
	sub c
	ld e, a
	ld a, d
	sbc b
	and $7
	ld d, a
	pop bc
	ret
.asm_f88ee
	push hl
	ld hl, $dddb
	add hl, bc
	ld [hl], $0
	pop hl
	ld a, [hl]
	cp $80
	jr z, .asm_f88ab
	ld hl, $ddd3
	add hl, bc
	ld [hl], a
	jr .asm_f88ab
.asm_f8902
	ld hl, $dda5
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret

Func_f890b: ; f890b (3e:490b)
	cp $0
	jr nz, .asm_f892c
	ld a, [$dddf]
	cp $0
	jr z, .asm_f8966
	ld a, [$dd8c]
	bit 0, a
	jr nz, .asm_f8966
	ld a, e
	ld [$ff13], a
	ld a, [$ff11]
	and $c0
	ld [$ff11], a
	ld a, d
	and $3f
	ld [$ff14], a
	ret
.asm_f892c
	cp $1
	jr nz, .asm_f894b
	ld a, [$dde0]
	cp $0
	jr z, .asm_f8966
	ld a, [$dd8c]
	bit 1, a
	jr nz, .asm_f8966
	ld a, e
	ld [$ff18], a
	ld a, [$ff16]
	and $c0
	ld [$ff16], a
	ld a, d
	ld [$ff19], a
	ret
.asm_f894b
	cp $2
	jr nz, .asm_f8966
	ld a, [$dde1]
	cp $0
	jr z, .asm_f8966
	ld a, [$dd8c]
	bit 2, a
	jr nz, .asm_f8966
	ld a, e
	ld [$ff1d], a
	xor a
	ld [$ff1b], a
	ld a, d
	ld [$ff1e], a
.asm_f8966
	ret

Func_f8967: ; f8967 (3e:4967)
	ld hl, $ddea
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr nz, .asm_f8976
	add e
	ld e, a
	ld a, d
	adc b
	ld d, a
	ret
.asm_f8976
	xor $ff
	ld h, a
	ld a, e
	sub h
	ld e, a
	ld a, d
	sbc b
	ld d, a
	ret

Func_f8980: ; f8980 (3e:4980)
	ld a, [$dd8c]
	ld d, a
	bit 0, d
	jr nz, .asm_f8990
	ld a, $8
	ld [$ff12], a
	swap a
	ld [$ff14], a
.asm_f8990
	bit 1, d
	jr nz, .asm_f899c
	swap a
	ld [$ff17], a
	swap a
	ld [$ff19], a
.asm_f899c
	bit 3, d
	jr nz, .asm_f89a8
	swap a
	ld [$ff21], a
	swap a
	ld [$ff23], a
.asm_f89a8
	bit 2, d
	jr nz, .asm_f89b0
	ld a, $0
	ld [$ff1c], a
.asm_f89b0
	ret

Func_f89b1: ; f89b1 (3e:49b1)
	ld hl, $dd8d
	xor a
	add [hl]
	inc hl
	add [hl]
	inc hl
	add [hl]
	inc hl
	add [hl]
	or a
	ret nz
	ld a, $80
	ld [$dd80], a
	ret

Func_f89c4: ; f89c4 (3e:49c4)
	di
	call Func_f8980
	call Func_f89dc
	call Func_f814b
	ei
	ret

Func_f89d0: ; f89d0 (3e:49d0)
	di
	call Func_f8980
	call Func_f814b
	call Func_f8b01
	ei
	ret

Func_f89dc: ; f89dc (3e:49dc)
	ld a, [$dd80]
	ld [$de55], a
	ld a, [$dd81]
	ld [$de56], a
	ld a, [$dd84]
	ld [$de57], a
	ld hl, $dd86
	ld de, $de58
	ld a, $4
	call Func_f8c18
	ld a, [$dd8a]
	ld [$de5c], a
	ld a, [$dd8b]
	ld [$de5d], a
	ld hl, $dd8d
	ld de, $de5e
	ld a, $4
	call Func_f8c18
	ld hl, $dd91
	ld de, $de62
	ld a, $4
	call Func_f8c18
	ld hl, $dd95
	ld de, $de66
	ld a, $8
	call Func_f8c18
	ld hl, $dd9d
	ld de, $de6e
	ld a, $8
	call Func_f8c18
	ld a, [$ddab]
	ld [$de76], a
	ld a, [$ddac]
	ld [$de77], a
	ld hl, $ddaf
	ld de, $de78
	ld a, $4
	call Func_f8c18
	ld hl, $ddb3
	ld de, $de7c
	ld a, $4
	call Func_f8c18
	ld hl, $ddb7
	ld de, $de80
	ld a, $4
	call Func_f8c18
	ld hl, $ddbb
	ld de, $de84
	ld a, $4
	call Func_f8c18
	ld hl, $ddbf
	ld de, $de88
	ld a, $4
	call Func_f8c18
	ld hl, $ddc3
	ld de, $de8c
	ld a, $4
	call Func_f8c18
	ld hl, $ddc7
	ld de, $de90
	ld a, $4
	call Func_f8c18
	ld hl, $ddcb
	ld de, $de94
	ld a, $4
	call Func_f8c18
	ld hl, $ddcf
	ld de, $de98
	ld a, $4
	call Func_f8c18
	ld hl, $ddd7
	ld de, $de9c
	ld a, $4
	call Func_f8c18
	ld hl, $dddf
	ld de, $dea0
	ld a, $4
	call Func_f8c18
	ld a, $0
	ld [$dddb], a
	ld [$dddc], a
	ld [$dddd], a
	ld [$ddde], a
	ld hl, $dde7
	ld de, $dea4
	ld a, $3
	call Func_f8c18
	ld hl, $ddea
	ld de, $dea7
	ld a, $3
	call Func_f8c18
	ld hl, $dded
	ld de, $deaa
	ld a, $2
	call Func_f8c18
	ld a, $0
	ld [$deac], a
	ld hl, $ddf3
	ld de, $dead
	ld a, $8
	call Func_f8c18
	ld hl, $ddfb
	ld de, $deb5
	ld a, $30
	call Func_f8c18
	ret

Func_f8b01: ; f8b01 (3e:4b01)
	ld a, [$de55]
	ld [$dd80], a
	ld a, [$de56]
	ld [$dd81], a
	ld a, [$de57]
	ld [$dd84], a
	ld hl, $de58
	ld de, $dd86
	ld a, $4
	call Func_f8c18
	ld a, [$de5c]
	ld [$dd8a], a
	ld a, $1
	ld [$dd8b], a
	ld hl, $de5e
	ld de, $dd8d
	ld a, $4
	call Func_f8c18
	ld hl, $de62
	ld de, $dd91
	ld a, $4
	call Func_f8c18
	ld hl, $de66
	ld de, $dd95
	ld a, $8
	call Func_f8c18
	ld hl, $de6e
	ld de, $dd9d
	ld a, $8
	call Func_f8c18
	ld a, [$de76]
	ld [$ddab], a
	ld a, [$de77]
	ld [$ddac], a
	ld hl, $de78
	ld de, $ddaf
	ld a, $4
	call Func_f8c18
	ld hl, $de7c
	ld de, $ddb3
	ld a, $4
	call Func_f8c18
	ld hl, $de80
	ld de, $ddb7
	ld a, $4
	call Func_f8c18
	ld hl, $de84
	ld de, $ddbb
	ld a, $4
	call Func_f8c18
	ld hl, $de88
	ld de, $ddbf
	ld a, $4
	call Func_f8c18
	ld hl, $de8c
	ld de, $ddc3
	ld a, $4
	call Func_f8c18
	ld hl, $de90
	ld de, $ddc7
	ld a, $4
	call Func_f8c18
	ld hl, $de94
	ld de, $ddcb
	ld a, $4
	call Func_f8c18
	ld hl, $de98
	ld de, $ddcf
	ld a, $4
	call Func_f8c18
	ld hl, $de9c
	ld de, $ddd7
	ld a, $4
	call Func_f8c18
	ld hl, $dea0
	ld de, $dddf
	ld a, $4
	call Func_f8c18
	ld hl, $dea4
	ld de, $dde7
	ld a, $3
	call Func_f8c18
	ld hl, $dea7
	ld de, $ddea
	ld a, $3
	call Func_f8c18
	ld hl, $deaa
	ld de, $dded
	ld a, $2
	call Func_f8c18
	ld a, [$deac]
	ld [$ddef], a
	ld hl, $dead
	ld de, $ddf3
	ld a, $8
	call Func_f8c18
	ld hl, $deb5
	ld de, $ddfb
	ld a, $30
	call Func_f8c18
	ret

; copies a bytes from hl to de
Func_f8c18: ; f8c18 (3e:4c18)
	ld c, a
.asm_f8c19
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .asm_f8c19
	ret

Unknown_f8c20: ; f8c20 (3e:4c20)
INCBIN "baserom.gbc",$f8c20,$f8c28 - $f8c20

Unknown_f8c28: ; f8c28 (3e:4c28)
INCBIN "baserom.gbc",$f8c28,$f8cda - $f8c28

PointerTable_f8cda: ; f8cda (3e:4cda)
	dw Unknown_f8ce4
	dw Unknown_f8cf4
	dw Unknown_f8d04
	dw Unknown_f8d14
	dw Unknown_f8d24

Unknown_f8ce4: ; f8ce4 (3e:4ce4)
INCBIN "baserom.gbc",$f8ce4,$f8cf4 - $f8ce4

Unknown_f8cf4: ; f8cf4 (3e:4cf4)
INCBIN "baserom.gbc",$f8cf4,$f8d04 - $f8cf4

Unknown_f8d04: ; f8d04 (3e:4d04)
INCBIN "baserom.gbc",$f8d04,$f8d14 - $f8d04

Unknown_f8d14: ; f8d14 (3e:4d14)
INCBIN "baserom.gbc",$f8d14,$f8d24 - $f8d14

Unknown_f8d24: ; f8d24 (3e:4d24)
INCBIN "baserom.gbc",$f8d24,$f8d34 - $f8d24

PointerTable_f8d34: ; f8d34 (3e:4d34)
	dw Unknown_f8d53
	dw Unknown_f8d4c
	dw Unknown_f8d5a
	dw Unknown_f8d4c
	dw Unknown_f8d64
	dw Unknown_f8d4c
	dw Unknown_f8d6d
	dw Unknown_f8d4c
	dw Unknown_f8d76
	dw Unknown_f8d4c
	dw Unknown_f8d4c
	dw Unknown_f8daa

Unknown_f8d4c: ; f8d4c (3e:4d4c)
INCBIN "baserom.gbc",$f8d4c,$f8d53 - $f8d4c

Unknown_f8d53: ; f8d53 (3e:4d53)
INCBIN "baserom.gbc",$f8d53,$f8d5a - $f8d53

Unknown_f8d5a: ; f8d5a (3e:4d5a)
INCBIN "baserom.gbc",$f8d5a,$f8d64 - $f8d5a

Unknown_f8d64: ; f8d64 (3e:4d64)
INCBIN "baserom.gbc",$f8d64,$f8d6d - $f8d64

Unknown_f8d6d: ; f8d6d (3e:4d6d)
INCBIN "baserom.gbc",$f8d6d,$f8d76 - $f8d6d

Unknown_f8d76: ; f8d76 (3e:4d76)
INCBIN "baserom.gbc",$f8d76,$f8daa - $f8d76

Unknown_f8daa: ; f8daa (3e:4daa)
INCBIN "baserom.gbc",$f8daa,$f8dde - $f8daa

PointerTable_f8dde: ; f8dde (3e:4dde)
	dw Unknown_f8df4
	dw Unknown_f8df7
	dw Unknown_f8e01
	dw Unknown_f8e0f
	dw Unknown_f8e19
	dw Unknown_f8e27
	dw Unknown_f8e35
	dw Unknown_f8e47
	dw Unknown_f8e5b
	dw Unknown_f8e65
	dw Unknown_f8e73

Unknown_f8df4: ; f8df4 (3e:4df4)
INCBIN "baserom.gbc",$f8df4,$f8df7 - $f8df4

Unknown_f8df7: ; f8df7 (3e:4df7)
INCBIN "baserom.gbc",$f8df7,$f8e01 - $f8df7

Unknown_f8e01: ; f8e01 (3e:4e01)
INCBIN "baserom.gbc",$f8e01,$f8e0f - $f8e01

Unknown_f8e0f: ; f8e0f (3e:4e0f)
INCBIN "baserom.gbc",$f8e0f,$f8e19 - $f8e0f

Unknown_f8e19: ; f8e19 (3e:4e19)
INCBIN "baserom.gbc",$f8e19,$f8e27 - $f8e19

Unknown_f8e27: ; f8e27 (3e:4e27)
INCBIN "baserom.gbc",$f8e27,$f8e35 - $f8e27

Unknown_f8e35: ; f8e35 (3e:4e35)
INCBIN "baserom.gbc",$f8e35,$f8e47 - $f8e35

Unknown_f8e47: ; f8e47 (3e:4e47)
INCBIN "baserom.gbc",$f8e47,$f8e5b - $f8e47

Unknown_f8e5b: ; f8e5b (3e:4e5b)
INCBIN "baserom.gbc",$f8e5b,$f8e65 - $f8e5b

Unknown_f8e65: ; f8e65 (3e:4e65)
INCBIN "baserom.gbc",$f8e65,$f8e73 - $f8e65

Unknown_f8e73: ; f8e73 (3e:4e73)
INCBIN "baserom.gbc",$f8e73,$f8ee5 - $f8e73

NumberOfSongs2: ; f8ee5 (3e:4ee5)
	db $1f

SongBanks2: ; f8ee6 (3e:4ee6)
	db BANK(Music_Stop)
	db BANK(Music_TitleScreen)
	db BANK(Music_BattleTheme1)
	db BANK(Music_BattleTheme2)
	db BANK(Music_BattleTheme3)
	db BANK(Music_PauseMenu)
	db BANK(Music_PCMainMenu)
	db BANK(Music_DeckMachine)
	db BANK(Music_CardPop)
	db BANK(Music_Overworld)
	db BANK(Music_PokemonDome)
	db BANK(Music_ChallengeHall)
	db BANK(Music_Club1)
	db BANK(Music_Club2)
	db BANK(Music_Club3)
	db BANK(Music_Ronald)
	db BANK(Music_Imakuni)
	db BANK(Music_HallOfHonor)
	db BANK(Music_Credits)
	db BANK(Music_Unused13)
	db BANK(Music_Unused14)
	db BANK(Music_MatchStart1)
	db BANK(Music_MatchStart2)
	db BANK(Music_MatchStart3)
	db BANK(Music_MatchVictory)
	db BANK(Music_MatchLoss)
	db BANK(Music_DarkDiddly)
	db BANK(Music_Unused1b)
	db BANK(Music_BoosterPack)
	db BANK(Music_Medal)
	db BANK(Music_Unused1e)

SongHeaderPointers2: ; f8f05 (3e:4f05)
	dw Music_Stop
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw Music_PCMainMenu
	dw $0000
	dw $0000
	dw $0000
	dw Music_PokemonDome
	dw Music_ChallengeHall
	dw Music_Club1
	dw Music_Club2
	dw Music_Club3
	dw Music_Ronald
	dw Music_Imakuni
	dw Music_HallOfHonor
	dw Music_Credits
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Stop
	db %0000

;Music_TitleScreen
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_BattleTheme1
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_BattleTheme2
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_BattleTheme3
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_PauseMenu
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

Music_PCMainMenu: ; f8f71 (3e:4f71)
	db %1111
	dw Music_PCMainMenu_Ch1 ; 5052
	dw Music_PCMainMenu_Ch2 ; 50ED
	dw Music_PCMainMenu_Ch3 ; 5189
	dw Music_PCMainMenu_Ch4 ; 522B

;Music_DeckMachine
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_CardPop
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Overworld
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

Music_PokemonDome: ; f8f95 (3e:4f95)
	db %1111
	dw Music_PokemonDome_Ch1 ; 5251
	dw Music_PokemonDome_Ch2 ; 53F8
	dw Music_PokemonDome_Ch3 ; 5579
	dw Music_PokemonDome_Ch4 ; 5629

Music_ChallengeHall: ; f8f9e (3e:4f9e)
	db %1111
	dw Music_ChallengeHall_Ch1 ; 5646
	dw Music_ChallengeHall_Ch2 ; 5883
	dw Music_ChallengeHall_Ch3 ; 5a92
	dw Music_ChallengeHall_Ch4 ; 5bA9

Music_Club1: ; f8fa7 (3e:4fa7)
	db %1111
	dw Music_Club1_Ch1 ; 5bE5
	dw Music_Club1_Ch2 ; 5d5F
	dw Music_Club1_Ch3 ; 5eC4
	dw Music_Club1_Ch4 ; 6044

Music_Club2: ; f8fb0 (3e:4fb0)
	db %0111
	dw Music_Club2_Ch1 ; 6077
	dw Music_Club2_Ch2 ; 60E3
	dw Music_Club2_Ch3 ; 6164
	dw $0000

Music_Club3: ; f8fb9 (3e:4fb9)
	db %1111
	dw Music_Club3_Ch1 ; 6210
	dw Music_Club3_Ch2 ; 6423
	dw Music_Club3_Ch3 ; 663E
	dw Music_Club3_Ch4 ; 6772

Music_Ronald: ; f8fc2 (3e:4fc2)
	db %1111
	dw Music_Ronald_Ch1 ; 67A0
	dw Music_Ronald_Ch2 ; 6a0E
	dw Music_Ronald_Ch3 ; 6bC0
	dw Music_Ronald_Ch4 ; 6cE0

Music_Imakuni: ; f8fcb (3e:4fcb)
	db %1111
	dw Music_Imakuni_Ch1 ; 6d55
	dw Music_Imakuni_Ch2 ; 6e32
	dw Music_Imakuni_Ch3 ; 6eBC
	dw Music_Imakuni_Ch4 ; 6fA4

Music_HallOfHonor: ; f8fd4 (3e:4fd4)
	db %0111
	dw Music_HallOfHonor_Ch1 ; 6fEA
	dw Music_HallOfHonor_Ch2 ; 706E
	dw Music_HallOfHonor_Ch3 ; 70D5
	dw $0000

Music_Credits: ; f8fdd (3e:4fdd)
	db %1111
	dw Music_Credits_Ch1 ; 71FE
	dw Music_Credits_Ch2 ; 768A
	dw Music_Credits_Ch3 ; 7b9D
	dw Music_Credits_Ch4 ; 7e51

;Music_Unused13
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Unused14
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_MatchStart1
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_MatchStart2
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_MatchStart3
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_MatchVictory
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_MatchLoss
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_DarkDiddly
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Unused1b
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_BoosterPack
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Medal
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Unused1e
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

Music_PCMainMenu_Ch1: ; f9052 (3e:5052)
INCBIN "baserom.gbc",$f9052,$f90ed - $f9052

Music_PCMainMenu_Ch2: ; f90ed (3e:50ed)
INCBIN "baserom.gbc",$f90ed,$f9189 - $f90ed

Music_PCMainMenu_Ch3: ; f9189 (3e:5189)
INCBIN "baserom.gbc",$f9189,$f922b - $f9189

Music_PCMainMenu_Ch4: ; f922b (3e:522b)
INCBIN "baserom.gbc",$f922b,$f9251 - $f922b

Music_PokemonDome_Ch1: ; f9251 (3e:5251)
INCBIN "baserom.gbc",$f9251,$f93f8 - $f9251

Music_PokemonDome_Ch2: ; f93f8 (3e:53f8)
INCBIN "baserom.gbc",$f93f8,$f9579 - $f93f8

Music_PokemonDome_Ch3: ; f9579 (3e:5579)
INCBIN "baserom.gbc",$f9579,$f9629 - $f9579

Music_PokemonDome_Ch4: ; f9629 (3e:5629)
INCBIN "baserom.gbc",$f9629,$f9646 - $f9629

Music_ChallengeHall_Ch1: ; f9646 (3e:5646)
INCBIN "baserom.gbc",$f9646,$f9883 - $f9646

Music_ChallengeHall_Ch2: ; f9883 (3e:5883)
INCBIN "baserom.gbc",$f9883,$f9a92 - $f9883

Music_ChallengeHall_Ch3: ; f9a92 (3e:5a92)
INCBIN "baserom.gbc",$f9a92,$f9ba9 - $f9a92

Music_ChallengeHall_Ch4: ; f9ba9 (3e:5ba9)
INCBIN "baserom.gbc",$f9ba9,$f9be5 - $f9ba9

Music_Club1_Ch1: ; f9be5 (3e:5be5)
INCBIN "baserom.gbc",$f9be5,$f9d5f - $f9be5

Music_Club1_Ch2: ; f9d5f (3e:5d5f)
INCBIN "baserom.gbc",$f9d5f,$f9ec4 - $f9d5f

Music_Club1_Ch3: ; f9ec4 (3e:5ec4)
INCBIN "baserom.gbc",$f9ec4,$fa044 - $f9ec4

Music_Club1_Ch4: ; fa044 (3e:6044)
INCBIN "baserom.gbc",$fa044,$fa077 - $fa044

Music_Club2_Ch1: ; fa077 (3e:6077)
INCBIN "baserom.gbc",$fa077,$fa0e3 - $fa077

Music_Club2_Ch2: ; fa0e3 (3e:60e3)
INCBIN "baserom.gbc",$fa0e3,$fa164 - $fa0e3

Music_Club2_Ch3: ; fa164 (3e:6164)
INCBIN "baserom.gbc",$fa164,$fa210 - $fa164

Music_Club3_Ch1: ; fa210 (3e:6210)
INCBIN "baserom.gbc",$fa210,$fa423 - $fa210

Music_Club3_Ch2: ; fa423 (3e:6423)
INCBIN "baserom.gbc",$fa423,$fa63e - $fa423

Music_Club3_Ch3: ; fa63e (3e:663e)
INCBIN "baserom.gbc",$fa63e,$fa772 - $fa63e

Music_Club3_Ch4: ; fa772 (3e:6772)
INCBIN "baserom.gbc",$fa772,$fa7a0 - $fa772

Music_Ronald_Ch1: ; fa7a0 (3e:67a0)
INCBIN "baserom.gbc",$fa7a0,$faa0e - $fa7a0

Music_Ronald_Ch2: ; faa0e (3e:6a0e)
INCBIN "baserom.gbc",$faa0e,$fabC0 - $faa0e

Music_Ronald_Ch3: ; fabC0 (3e:6bC0)
INCBIN "baserom.gbc",$fabC0,$face0 - $fabC0

Music_Ronald_Ch4: ; face0 (3e:6ce0)
INCBIN "baserom.gbc",$face0,$fad55 - $face0

Music_Imakuni_Ch1: ; fad55 (3e:6d55)
INCBIN "baserom.gbc",$fad55,$fae32 - $fad55

Music_Imakuni_Ch2: ; fae32 (3e:6e32)
INCBIN "baserom.gbc",$fae32,$faebc - $fae32

Music_Imakuni_Ch3: ; faebc (3e:6ebc)
INCBIN "baserom.gbc",$faebc,$fafa4 - $faebc

Music_Imakuni_Ch4: ; fafa4 (3e:6fa4)
INCBIN "baserom.gbc",$fafa4,$fafea - $fafa4

Music_HallOfHonor_Ch1: ; fafea (3e:6fea)
INCBIN "baserom.gbc",$fafea,$fb06e - $fafea

Music_HallOfHonor_Ch2: ; fb06e (3e:706e)
INCBIN "baserom.gbc",$fb06e,$fb0d5 - $fb06e

Music_HallOfHonor_Ch3: ; fb0d5 (3e:70d5)
INCBIN "baserom.gbc",$fb0d5,$fb1fe - $fb0d5

Music_Credits_Ch1: ; fb1fe (3e:71fe)
INCBIN "baserom.gbc",$fb1fe,$fb68a - $fb1fe

Music_Credits_Ch2: ; fb68a (3e:768a)
INCBIN "baserom.gbc",$fb68a,$fbb9d - $fb68a

Music_Credits_Ch3: ; fbb9d (3e:7b9d)
INCBIN "baserom.gbc",$fbb9d,$fbe51 - $fbb9d

Music_Credits_Ch4: ; fbe51 (3e:7e51)
INCBIN "baserom.gbc",$fbe51,$fc000 - $fbe51