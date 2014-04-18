Func_f4000: ; f4000 (3d:4000)
	jp Func_f407d

Func_f4003: ; f4003 (3d:4003)
	jp Func_f40e9

Func_f4006: ; f4006 (3d:4006)
	jp Func_f4021

Func_f4009: ; f4009 (3d:4009)
	jp Func_f402d

Func_f400c: ; f400c (3d:400c)
	jp Func_f404e

Func_f400f: ; f400f (3d:400f)
	jp Func_f4052

Func_f4012: ; f4012 (3d:4012)
	jp Func_f405c

Func_f4015: ; f4015 (3d:4015)
	jp Func_f4066

Func_f4018: ; f4018 (3d:4018)
	jp Func_f406f

Func_f401b: ; f401b (3d:401b)
	jp Func_f49c4

Func_f401e: ; f401e (3d:401e)
	jp Func_f49d0

Func_f4021: ; f4021 (3d:4021)
	push hl
	ld hl, NumberOfSongs1
	cp [hl]
	jr nc, .asm_f402b
	ld [$dd80], a
.asm_f402b
	pop hl
	ret

Func_f402d: ; f402d (3d:402d)
	push bc
	push hl
	ld b, $0
	ld c, a
	or a
	jr z, .asm_f4043
	ld hl, Unknown_f4e85
	add hl, bc
	ld b, [hl]
	ld a, [$dd83]
	or a
	jr z, .asm_f4043
	cp b
	jr c, .asm_f404b
.asm_f4043
	ld a, b
	ld [$dd83], a
	ld a, c
	ld [$dd82], a
.asm_f404b
	pop hl
	pop bc
	ret

Func_f404e: ; f404e (3d:404e)
	ld [$ddf0], a
	ret

Func_f4052: ; f4052 (3d:4052)
	ld a, [$dd80]
	cp $80
	ld a, $1
	ret nz
	xor a
	ret

Func_f405c: ; f405c (3d:405c)
	ld a, [$dd82]
	cp $80
	ld a, $1
	ret nz
	xor a
	ret

Func_f4066: ; f4066 (3d:4066)
	ld a, [$ddf2]
	xor $1
	ld [$ddf2], a
	ret

Func_f406f: ; f406f (3d:406f)
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

Func_f407d: ; f407d (3d:407d)
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
.asm_f40bb
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
	jr nz, .asm_f40bb
	ld hl, Unknown_f4c20
	ld bc, $ddf3
	ld d, $8
.asm_f40e2
	ld a, [hli]
	ld [bc], a
	inc bc
	dec d
	jr nz, .asm_f40e2
	ret

Func_f40e9: ; f40e9 (3d:40e9)
	call Func_f42a4
	call Func_f411c
	ld hl, Func_fc003
	call Bankswitch3dTo3f
	ld a, [$dd81]
	ld [$ff80], a
	ld [$2000], a
	ld a, [$ddf2]
	cp $0
	jr z, .asm_f4109
	call Func_f4980
	jr .asm_f4115
.asm_f4109
	call Func_f42a5
	call Func_f430a
	call Func_f436f
	call Func_f43ce
.asm_f4115
	call Func_f4866
	call Func_f49b1
	ret

Func_f411c: ; f411c (3d:411c)
	ld a, [$dd80]
	rla
	jr c, .asm_f4133
	call Func_f414b
	ld a, [$dd80]
	call Music1_PlaySong
	ld a, [$dd80]
	or $80
	ld [$dd80], a
.asm_f4133
	ld a, [$dd82]
	rla
	jr c, .asm_f414a
	ld a, [$dd82]
	ld hl, Func_fc000
	call Bankswitch3dTo3f
	ld a, [$dd82]
	or $80
	ld [$dd82], a
.asm_f414a
	ret

Func_f414b: ; f414b (3d:414b)
	ld a, [$dd8c]
	ld d, a
	xor a
	ld [$dd8d], a
	bit 0, d
	jr nz, .asm_f415f
	ld a, $8
	ld [$ff12], a
	swap a
	ld [$ff14], a
.asm_f415f
	xor a
	ld [$dd8e], a
	bit 1, d
	jr nz, .asm_f416f
	ld a, $8
	ld [$ff17], a
	swap a
	ld [$ff19], a
.asm_f416f
	xor a
	ld [$dd90], a
	bit 3, d
	jr nz, .asm_f417f
	ld a, $8
	ld [$ff21], a
	swap a
	ld [$ff23], a
.asm_f417f
	xor a
	ld [$dd8f], a
	bit 2, d
	jr nz, .asm_f418b
	ld a, $0
	ld [$ff1c], a
.asm_f418b
	ret

; plays the song given by the id in a
Music1_PlaySong: ; f418c (3d:418c)
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
	jr nc, .asm_f41eb
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
	ld a, [Unknown_f4c20]
	ld [$ddf3], a
	ld a, [Unknown_f4c20 + 1]
	ld [$ddf4], a
	ld a, $8
	ld [$ddc7], a
.asm_f41eb
	rr e
	jr nc, .asm_f4228
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
	ld a, [Unknown_f4c20 + 2]
	ld [$ddf5], a
	ld a, [Unknown_f4c20 + 3]
	ld [$ddf6], a
	ld a, $8
	ld [$ddc8], a
.asm_f4228
	rr e
	jr nc, .asm_f4265
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
	ld a, [Unknown_f4c20 + 4]
	ld [$ddf7], a
	ld a, [Unknown_f4c20 + 5]
	ld [$ddf8], a
	ld a, $40
	ld [$ddc9], a
.asm_f4265
	rr e
	jr nc, .asm_f429f
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
	ld a, [Unknown_f4c20 + 6]
	ld [$ddf9], a
	ld a, [Unknown_f4c20 + 7]
	ld [$ddfa], a
	ld a, $40
	ld [$ddca], a
.asm_f429f
	xor a
	ld [$ddf2], a
	ret

Func_f42a4: ; f42a4 (3d:42a4)
	ret

Func_f42a5: ; f42a5 (3d:42a5)
	ld a, [$dd8d]
	or a
	jr z, .asm_f42fa
	ld a, [$ddb7]
	cp $0
	jr z, .asm_f42d4
	ld a, [$ddc3]
	dec a
	ld [$ddc3], a
	jr nz, .asm_f42d4
	ld a, [$ddbb]
	cp $1
	jr z, .asm_f42d4
	ld a, [$dd8c]
	bit 0, a
	jr nz, .asm_f42d4
	ld hl, $ff12
	ld a, [$ddc7]
	ld [hli], a
	inc hl
	ld a, $80
	ld [hl], a
.asm_f42d4
	ld a, [$ddbb]
	dec a
	ld [$ddbb], a
	jr nz, .asm_f42f4
	ld a, [$dd96]
	ld h, a
	ld a, [$dd95]
	ld l, a
	ld bc, $0000
	call Music1_PlayNextNote
	ld a, [$dd8d]
	or a
	jr z, .asm_f42fa
	call Func_f4714
.asm_f42f4
	ld a, $0
	call Func_f485a
	ret
.asm_f42fa
	ld a, [$dd8c]
	bit 0, a
	jr nz, .asm_f4309
	ld a, $8
	ld [$ff12], a
	swap a
	ld [$ff14], a
.asm_f4309
	ret

Func_f430a: ; f430a (3d:430a)
	ld a, [$dd8e]
	or a
	jr z, .asm_f435f
	ld a, [$ddb8]
	cp $0
	jr z, .asm_f4339
	ld a, [$ddc4]
	dec a
	ld [$ddc4], a
	jr nz, .asm_f4339
	ld a, [$ddbc]
	cp $1
	jr z, .asm_f4339
	ld a, [$dd8c]
	bit 1, a
	jr nz, .asm_f4339
	ld hl, $ff17
	ld a, [$ddc8]
	ld [hli], a
	inc hl
	ld a, $80
	ld [hl], a
.asm_f4339
	ld a, [$ddbc]
	dec a
	ld [$ddbc], a
	jr nz, .asm_f4359
	ld a, [$dd98]
	ld h, a
	ld a, [$dd97]
	ld l, a
	ld bc, $0001
	call Music1_PlayNextNote
	ld a, [$dd8e]
	or a
	jr z, .asm_f435f
	call Func_f475a
.asm_f4359
	ld a, $1
	call Func_f485a
	ret
.asm_f435f
	ld a, [$dd8c]
	bit 1, a
	jr nz, .asm_f436e
	ld a, $8
	ld [$ff17], a
	swap a
	ld [$ff19], a
.asm_f436e
	ret

Func_f436f: ; f436f (3d:436f)
	ld a, [$dd8f]
	or a
	jr z, .asm_f43be
	ld a, [$ddb9]
	cp $0
	jr z, .asm_f4398
	ld a, [$ddc5]
	dec a
	ld [$ddc5], a
	jr nz, .asm_f4398
	ld a, [$dd8c]
	bit 2, a
	jr nz, .asm_f4398
	ld a, [$ddbd]
	cp $1
	jr z, .asm_f4398
	ld a, [$ddc9]
	ld [$ff1c], a
.asm_f4398
	ld a, [$ddbd]
	dec a
	ld [$ddbd], a
	jr nz, .asm_f43b8
	ld a, [$dd9a]
	ld h, a
	ld a, [$dd99]
	ld l, a
	ld bc, $0002
	call Music1_PlayNextNote
	ld a, [$dd8f]
	or a
	jr z, .asm_f43be
	call Func_f479c
.asm_f43b8
	ld a, $2
	call Func_f485a
	ret
.asm_f43be
	ld a, [$dd8c]
	bit 2, a
	jr nz, .asm_f43cd
	ld a, $0
	ld [$ff1c], a
	ld a, $80
	ld [$ff1e], a
.asm_f43cd
	ret

Func_f43ce: ; f43ce (3d:43ce)
	ld a, [$dd90]
	or a
	jr z, .asm_f4400
	ld a, [$ddbe]
	dec a
	ld [$ddbe], a
	jr nz, .asm_f43f6
	ld a, [$dd9c]
	ld h, a
	ld a, [$dd9b]
	ld l, a
	ld bc, $0003
	call Music1_PlayNextNote
	ld a, [$dd90]
	or a
	jr z, .asm_f4400
	call Func_f480a
	jr .asm_f4413
.asm_f43f6
	ld a, [$ddef]
	or a
	jr z, .asm_f4413
	call Func_f4839
	ret
.asm_f4400
	ld a, [$dd8c]
	bit 3, a
	jr nz, .asm_f4413
	xor a
	ld [$ddef], a
	ld a, $8
	ld [$ff21], a
	swap a
	ld [$ff23], a
.asm_f4413
	ret

Music1_PlayNextNote: ; f4414 (3d:4414)
	ld a, [hli]
	push hl
	push af
	cp $d0
	jr c, Music1_Note
	sub $d0
	add a
	ld e, a
	ld d, $0
	ld hl, Music1_CommandTable
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld h, d
	ld l, e
	pop af
	jp [hl]

Music1_CommandTable: ; f442c (3d:442c)
	dw Music1_Speed
	dw Music1_musicdx
	dw Music1_musicdx
	dw Music1_musicdx
	dw Music1_musicdx
	dw Music1_musicdx
	dw Music1_musicdx
	dw Music1_musicd7
	dw Music1_musicd8
	dw Music1_musicd9
	dw Music1_End
	dw Music1_End
	dw Music1_musicdc
	dw Music1_MainLoop
	dw Music1_EndMainLoop
	dw Music1_Loop
	dw Music1_EndLoop
	dw Music1_jp
	dw Music1_call
	dw Music1_ret
	dw Music1_musice4
	dw Music1_musice5
	dw Music1_musice6
	dw Music1_musice7
	dw Music1_musice8
	dw Music1_musice9
	dw Music1_musicea
	dw Music1_musiceb
	dw Music1_musicec
	dw Music1_musiced
	dw Music1_End
	dw Music1_End
	dw Music1_End
	dw Music1_End
	dw Music1_End
	dw Music1_End
	dw Music1_End
	dw Music1_End
	dw Music1_End
	dw Music1_End
	dw Music1_End
	dw Music1_End
	dw Music1_End
	dw Music1_End
	dw Music1_End
	dw Music1_End
	dw Music1_End
	dw Music1_End

Music1_Note: ; f448c (3d:448c)
	push af
	ld a, [hl]
	ld e, a
	ld hl, $dd91
	add hl, bc
	ld a, [hl]
	cp $80
	jr z, .asm_f44b0
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
.asm_f44b0
	pop af
	push de
	ld hl, $ddcf
	add hl, bc
	ld d, [hl]
	and $f
	inc a
	cp d
	jr nc, .asm_f44c0
	ld e, a
	ld a, d
	ld d, e
.asm_f44c0
	ld e, a
.asm_f44c1
	dec d
	jr z, .asm_f44c7
	add e
	jr .asm_f44c1
.asm_f44c7
	ld hl, $ddbb
	add hl, bc
	ld [hl], a
	pop de
	ld d, a
	ld a, e
	cp $d9
	ld a, d
	jr z, .asm_f44fb
	ld e, a
	ld hl, $ddbf
	add hl, bc
	ld a, [hl]
	cp $8
	ld d, a
	ld a, e
	jr z, .asm_f44fb
	push hl
	push bc
	ld b, $0
	ld c, a
	ld hl, $0000
.asm_f44e8
	add hl, bc
	dec d
	jr nz, .asm_f44e8
	srl h
	rr l
	srl h
	rr l
	srl h
	rr l
	ld a, l
	pop bc
	pop hl
.asm_f44fb
	ld hl, $ddc3
	add hl, bc
	ld [hl], a
	pop af
	and $f0
	ld hl, $ddb7
	add hl, bc
	ld [hl], a
	or a
	jr nz, .asm_f450e
	jp .asm_f458e
.asm_f450e
	swap a
	dec a
	ld h, a
	ld a, $3
	cp c
	ld a, h
	jr z, .asm_f451a
	jr .asm_f4564
.asm_f451a
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
	ld hl, PointerTable_f4d34
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
	jr .asm_f458e
.asm_f4564
	ld hl, $dda5
	add hl, bc
	add hl, bc
	push hl
	ld hl, $ddaf
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld hl, Unknown_f4c28
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
	ld hl, Unknown_f4c30
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	call Func_f4967
	pop hl
	ld a, e
	ld [hli], a
	ld [hl], d
.asm_f458e
	pop de
	ld hl, $dd95
	add hl, bc
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ret

Music1_Speed: ; f4598 (3d:4598)
	pop hl
	ld a, [hli]
	push hl
	ld hl, $ddcf
	add hl, bc
	ld [hl], a
	jp Music1_PlayNextNote_pop

Music1_musicdx: ; f45a3 (3d:45a3)
	and $7
	dec a
	ld hl, $ddaf
	add hl, bc
	push af
	ld a, c
	cp $2
	jr nz, .asm_f45b6
	pop af
	inc a
	ld [hl], a
	jp Music1_PlayNextNote_pop
.asm_f45b6
	pop af
	ld [hl], a
	jp Music1_PlayNextNote_pop

Music1_musicd7: ; f45bb (3d:45bb)
	ld hl, $ddaf
	add hl, bc
	inc [hl]
	jp Music1_PlayNextNote_pop

Music1_musicd8: ; f45c3 (3d:45c3)
	ld hl, $ddaf
	add hl, bc
	dec [hl]
	jp Music1_PlayNextNote_pop

Music1_musicd9: ; f45cb (3d:45cb)
	ld hl, $dd91
	add hl, bc
	ld [hl], $80
	jp Music1_PlayNextNote_pop

Music1_musicdc: ; f45d4 (3d:45d4)
	pop hl
	ld a, [hli]
	push hl
	push bc
	inc c
	ld e, $ee
.asm_f45db
	dec c
	jr z, .asm_f45e3
	rlca
	rlc e
	jr .asm_f45db
.asm_f45e3
	ld d, a
	ld hl, $dd84
	ld a, [hl]
	and e
	or d
	ld [hl], a
	pop bc
	jp Music1_PlayNextNote_pop

Music1_MainLoop: ; f45ef (3d:45ef)
	pop de
	push de
	dec de
	ld hl, $dd9d
	add hl, bc
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	jp Music1_PlayNextNote_pop

Music1_EndMainLoop: ; f45fd (3d:45fd)
	pop hl
	ld hl, $dd9d
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp Music1_PlayNextNote

Music1_Loop: ; f4609 (3d:4609)
	pop de
	ld a, [de]
	inc de
	push af
	call Music1_GetReturnAddress
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	pop af
	ld [hl], a
	inc hl
	push de
	call Music1_SetReturnAddress
	jp Music1_PlayNextNote_pop

Music1_EndLoop: ; f461e (3d:461e)
	call Music1_GetReturnAddress
	dec hl
	ld a, [hl]
	dec a
	jr z, .asm_f4630
	ld [hld], a
	ld d, [hl]
	dec hl
	ld e, [hl]
	pop hl
	ld h, d
	ld l, e
	jp Music1_PlayNextNote
.asm_f4630
	dec hl
	dec hl
	call Music1_SetReturnAddress
	jp Music1_PlayNextNote_pop

Music1_jp: ; f4638 (3d:4638)
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp Music1_PlayNextNote

Music1_call: ; f463f (3d:463f)
	call Music1_GetReturnAddress
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
	call Music1_SetReturnAddress
	jp Music1_PlayNextNote_pop

Music1_ret: ; f4656 (3d:4656)
	pop de
	call Music1_GetReturnAddress
	dec hl
	ld a, [hld]
	ld e, [hl]
	ld d, a
	inc de
	inc de
	push de
	call Music1_SetReturnAddress
	jp Music1_PlayNextNote_pop

Music1_musice4: ; f4667 (3d:4667)
	pop de
	ld a, [de]
	inc de
	ld hl, $ddea
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music1_PlayNextNote

Music1_musice5: ; f4674 (3d:4674)
	pop de
	ld a, [de]
	and $c0
	inc de
	ld hl, $dd86
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music1_PlayNextNote

Music1_musice6: ; f4683 (3d:4683)
	pop de
	ld a, [de]
	inc de
	ld hl, $dde7
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music1_PlayNextNote

Music1_musice7: ; f4690 (3d:4690)
	pop de
	ld a, [de]
	inc de
	ld [$dd8a], a
	ld a, $1
	ld [$dd8b], a
	ld h, d
	ld l, e
	jp Music1_PlayNextNote

Music1_musice8: ; f46a0 (3d:46a0)
	pop de
	ld a, [de]
	inc de
	ld hl, $ddbf
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music1_PlayNextNote

Music1_musice9: ; f46ad (3d:46ad)
	pop de
	ld a, [de]
	inc de
	ld hl, $ddc7
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music1_PlayNextNote

Music1_musicea: ; f46ba (3d:46ba)
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
	jp Music1_PlayNextNote

Music1_musiceb: ; f46cc (3d:46cc)
	pop de
	ld a, [de]
	inc de
	ld hl, $dddf
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music1_PlayNextNote

Music1_musicec: ; f46d9 (3d:46d9)
	pop de
	ld a, [de]
	inc de
	ld hl, $ddcb
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music1_PlayNextNote

Music1_musiced: ; f46e6 (3d:46e6)
	pop de
	ld a, [de]
	inc de
	ld hl, $ddcb
	add hl, bc
	add [hl]
	ld [hl], a
	ld h, d
	ld l, e
	jp Music1_PlayNextNote

Music1_End: ; f46f4 (3d:46f4)
	ld hl, $dd8d
	add hl, bc
	ld [hl], $0
	pop hl
	ret

; returns the address where the address to
; return to is stored for the current channel
Music1_GetReturnAddress: ; f46fc (3d:46fc)
	ld hl, $ddf3
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

; puts the address in hl where the address to
; return to is stored for the currentchannel
; since this function is used for loops and calls, a song
; should not use a loop inside a called piece of music
; or call a piece of music inside a loop
Music1_SetReturnAddress: ; f4705 (3d:4705)
	ld d, h
	ld e, l
	ld hl, $ddf3
	add hl, bc
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ret

Music1_PlayNextNote_pop ; f4710 (3d:4710)
	pop hl
	jp Music1_PlayNextNote

Func_f4714: ; f4714 (3d:4714)
	ld a, [$dd8c]
	bit 0, a
	jr nz, .asm_f4749
	ld a, [$ddb7]
	cp $0
	jr z, .asm_f474a
	ld d, $0
	ld hl, $dd91
	ld a, [hl]
	cp $80
	jr z, .asm_f4733
	ld a, [$dde7]
	ld [$ff12], a
	ld d, $80
.asm_f4733
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
.asm_f4749
	ret
.asm_f474a
	ld hl, $dd91
	ld [hl], $0
	ld hl, $ff12
	ld a, $8
	ld [hli], a
	inc hl
	swap a
	ld [hl], a
	ret

Func_f475a: ; f475a (3d:475a)
	ld a, [$dd8c]
	bit 1, a
	jr nz, .asm_f478b
	ld a, [$ddb8]
	cp $0
	jr z, .asm_f478c
	ld d, $0
	ld hl, $dd92
	ld a, [hl]
	cp $80
	jr z, .asm_f4779
	ld a, [$dde8]
	ld [$ff17], a
	ld d, $80
.asm_f4779
	ld [hl], $2
	ld a, [$dd87]
	ld [$ff16], a
	ld a, [$dda7]
	ld [$ff18], a
	ld a, [$dda8]
	or d
	ld [$ff19], a
.asm_f478b
	ret
.asm_f478c
	ld hl, $dd92
	ld [hl], $0
	ld hl, $ff17
	ld a, $8
	ld [hli], a
	inc hl
	swap a
	ld [hl], a
	ret

Func_f479c: ; f479c (3d:479c)
	ld a, [$dd8c]
	bit 2, a
	jr nz, .asm_f47e0
	ld d, $0
	ld a, [$dd8b]
	or a
	jr z, .asm_f47b3
	xor a
	ld [$ff1a], a
	call Func_f47ea
	ld d, $80
.asm_f47b3
	ld a, [$ddb9]
	cp $0
	jr z, .asm_f47e1
	ld hl, $dd93
	ld a, [hl]
	cp $80
	jr z, .asm_f47cc
	ld a, [$dde9]
	ld [$ff1c], a
	xor a
	ld [$ff1a], a
	ld d, $80
.asm_f47cc
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
.asm_f47e0
	ret
.asm_f47e1
	ld hl, $dd91
	ld [hl], $0
	xor a
	ld [$ff1a], a
	ret

Func_f47ea: ; f479c (3d:47ea)
	ld a, [$dd8a]
	add a
	ld d, $0
	ld e, a
	ld hl, PointerTable_f4cda
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld b, d
	ld de, $ff30
.asm_f47fc
	ld a, [hli]
	ld [de], a
	inc de
	inc b
	ld a, b
	cp $10
	jr nz, .asm_f47fc
	xor a
	ld [$dd8b], a
	ret

Func_f480a: ; f480a (3d:480a)
	ld a, [$dd8c]
	bit 3, a
	jr nz, .asm_f4829
	ld a, [$ddba]
	cp $0
	jr z, asm_f482a
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
.asm_f4829
	ret
asm_f482a
	xor a
	ld [$ddef], a
	ld hl, $ff21
	ld a, $8
	ld [hli], a
	inc hl
	swap a
	ld [hl], a
	ret

Func_f4839: ; f4839 (3d:4839)
	ld a, [$dd8c]
	bit 3, a
	jr z, .asm_f4846
	xor a
	ld [$ddef], a
	jr .asm_f4859
.asm_f4846
	ld hl, $dded
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld a, [de]
	cp $ff
	jr nz, .asm_f4853
	jr asm_f482a
.asm_f4853
	ld [$ff22], a
	inc de
	ld a, d
	ld [hld], a
	ld [hl], e
.asm_f4859
	ret

Func_f485a: ; f485a (3d:485a)
	push af
	ld b, $0
	ld c, a
	call Func_f4898
	pop af
	call Func_f490b
	ret

Func_f4866: ; f4866 (3d:4866)
	ld a, [$ddf1]
	ld [$ff24], a
	ld a, [$dd8c]
	or a
	ld hl, $dd84
	ld a, [hli]
	jr z, .asm_f4888
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
.asm_f4888
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

Func_f4898: ; f4898 (3d:4898)
	ld hl, $dddf
	add hl, bc
	ld a, [hl]
	cp $0
	jr z, .asm_f4902
	ld hl, $dde3
	add hl, bc
	cp [hl]
	jr z, .asm_f48ab
	inc [hl]
	jr .asm_f4902
.asm_f48ab
	ld hl, $ddd3
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld hl, PointerTable_f4dde
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
	jr z, .asm_f48ee
	ld hl, $dda5
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	bit 7, a
	jr nz, .asm_f48df
	add e
	ld e, a
	ld a, $0
	adc d
	and $7
	ld d, a
	ret
.asm_f48df
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
.asm_f48ee
	push hl
	ld hl, $dddb
	add hl, bc
	ld [hl], $0
	pop hl
	ld a, [hl]
	cp $80
	jr z, .asm_f48ab
	ld hl, $ddd3
	add hl, bc
	ld [hl], a
	jr .asm_f48ab
.asm_f4902
	ld hl, $dda5
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret

Func_f490b: ; f490b (3d:490b)
	cp $0
	jr nz, .asm_f492c
	ld a, [$dddf]
	cp $0
	jr z, .asm_f4966
	ld a, [$dd8c]
	bit 0, a
	jr nz, .asm_f4966
	ld a, e
	ld [$ff13], a
	ld a, [$ff11]
	and $c0
	ld [$ff11], a
	ld a, d
	and $3f
	ld [$ff14], a
	ret
.asm_f492c
	cp $1
	jr nz, .asm_f494b
	ld a, [$dde0]
	cp $0
	jr z, .asm_f4966
	ld a, [$dd8c]
	bit 1, a
	jr nz, .asm_f4966
	ld a, e
	ld [$ff18], a
	ld a, [$ff16]
	and $c0
	ld [$ff16], a
	ld a, d
	ld [$ff19], a
	ret
.asm_f494b
	cp $2
	jr nz, .asm_f4966
	ld a, [$dde1]
	cp $0
	jr z, .asm_f4966
	ld a, [$dd8c]
	bit 2, a
	jr nz, .asm_f4966
	ld a, e
	ld [$ff1d], a
	xor a
	ld [$ff1b], a
	ld a, d
	ld [$ff1e], a
.asm_f4966
	ret

Func_f4967: ; f4967 (3d:4967)
	ld hl, $ddea
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr nz, .asm_f4976
	add e
	ld e, a
	ld a, d
	adc b
	ld d, a
	ret
.asm_f4976
	xor $ff
	ld h, a
	ld a, e
	sub h
	ld e, a
	ld a, d
	sbc b
	ld d, a
	ret

Func_f4980: ; f4980 (3d:4980)
	ld a, [$dd8c]
	ld d, a
	bit 0, d
	jr nz, .asm_f4990
	ld a, $8
	ld [$ff12], a
	swap a
	ld [$ff14], a
.asm_f4990
	bit 1, d
	jr nz, .asm_f499c
	swap a
	ld [$ff17], a
	swap a
	ld [$ff19], a
.asm_f499c
	bit 3, d
	jr nz, .asm_f49a8
	swap a
	ld [$ff21], a
	swap a
	ld [$ff23], a
.asm_f49a8
	bit 2, d
	jr nz, .asm_f49b0
	ld a, $0
	ld [$ff1c], a
.asm_f49b0
	ret

Func_f49b1: ; f49b1 (3d:49b1)
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

Func_f49c4: ; f49c4 (3d:49c4)
	di
	call Func_f4980
	call Func_f49dc
	call Func_f414b
	ei
	ret

Func_f49d0: ; f49d0 (3d:49d0)
	di
	call Func_f4980
	call Func_f414b
	call Func_f4b01
	ei
	ret

Func_f49dc: ; f49dc (3d:49dc)
	ld a, [$dd80]
	ld [$de55], a
	ld a, [$dd81]
	ld [$de56], a
	ld a, [$dd84]
	ld [$de57], a
	ld hl, $dd86
	ld de, $de58
	ld a, $4
	call Music1_CopyData
	ld a, [$dd8a]
	ld [$de5c], a
	ld a, [$dd8b]
	ld [$de5d], a
	ld hl, $dd8d
	ld de, $de5e
	ld a, $4
	call Music1_CopyData
	ld hl, $dd91
	ld de, $de62
	ld a, $4
	call Music1_CopyData
	ld hl, $dd95
	ld de, $de66
	ld a, $8
	call Music1_CopyData
	ld hl, $dd9d
	ld de, $de6e
	ld a, $8
	call Music1_CopyData
	ld a, [$ddab]
	ld [$de76], a
	ld a, [$ddac]
	ld [$de77], a
	ld hl, $ddaf
	ld de, $de78
	ld a, $4
	call Music1_CopyData
	ld hl, $ddb3
	ld de, $de7c
	ld a, $4
	call Music1_CopyData
	ld hl, $ddb7
	ld de, $de80
	ld a, $4
	call Music1_CopyData
	ld hl, $ddbb
	ld de, $de84
	ld a, $4
	call Music1_CopyData
	ld hl, $ddbf
	ld de, $de88
	ld a, $4
	call Music1_CopyData
	ld hl, $ddc3
	ld de, $de8c
	ld a, $4
	call Music1_CopyData
	ld hl, $ddc7
	ld de, $de90
	ld a, $4
	call Music1_CopyData
	ld hl, $ddcb
	ld de, $de94
	ld a, $4
	call Music1_CopyData
	ld hl, $ddcf
	ld de, $de98
	ld a, $4
	call Music1_CopyData
	ld hl, $ddd7
	ld de, $de9c
	ld a, $4
	call Music1_CopyData
	ld hl, $dddf
	ld de, $dea0
	ld a, $4
	call Music1_CopyData
	ld a, $0
	ld [$dddb], a
	ld [$dddc], a
	ld [$dddd], a
	ld [$ddde], a
	ld hl, $dde7
	ld de, $dea4
	ld a, $3
	call Music1_CopyData
	ld hl, $ddea
	ld de, $dea7
	ld a, $3
	call Music1_CopyData
	ld hl, $dded
	ld de, $deaa
	ld a, $2
	call Music1_CopyData
	ld a, $0
	ld [$deac], a
	ld hl, $ddf3
	ld de, $dead
	ld a, $8
	call Music1_CopyData
	ld hl, $ddfb
	ld de, $deb5
	ld a, $30
	call Music1_CopyData
	ret

Func_f4b01: ; f4b01 (3d:4b01)
	ld a, [$de55]
	ld [$dd80], a
	ld a, [$de56]
	ld [$dd81], a
	ld a, [$de57]
	ld [$dd84], a
	ld hl, $de58
	ld de, $dd86
	ld a, $4
	call Music1_CopyData
	ld a, [$de5c]
	ld [$dd8a], a
	ld a, $1
	ld [$dd8b], a
	ld hl, $de5e
	ld de, $dd8d
	ld a, $4
	call Music1_CopyData
	ld hl, $de62
	ld de, $dd91
	ld a, $4
	call Music1_CopyData
	ld hl, $de66
	ld de, $dd95
	ld a, $8
	call Music1_CopyData
	ld hl, $de6e
	ld de, $dd9d
	ld a, $8
	call Music1_CopyData
	ld a, [$de76]
	ld [$ddab], a
	ld a, [$de77]
	ld [$ddac], a
	ld hl, $de78
	ld de, $ddaf
	ld a, $4
	call Music1_CopyData
	ld hl, $de7c
	ld de, $ddb3
	ld a, $4
	call Music1_CopyData
	ld hl, $de80
	ld de, $ddb7
	ld a, $4
	call Music1_CopyData
	ld hl, $de84
	ld de, $ddbb
	ld a, $4
	call Music1_CopyData
	ld hl, $de88
	ld de, $ddbf
	ld a, $4
	call Music1_CopyData
	ld hl, $de8c
	ld de, $ddc3
	ld a, $4
	call Music1_CopyData
	ld hl, $de90
	ld de, $ddc7
	ld a, $4
	call Music1_CopyData
	ld hl, $de94
	ld de, $ddcb
	ld a, $4
	call Music1_CopyData
	ld hl, $de98
	ld de, $ddcf
	ld a, $4
	call Music1_CopyData
	ld hl, $de9c
	ld de, $ddd7
	ld a, $4
	call Music1_CopyData
	ld hl, $dea0
	ld de, $dddf
	ld a, $4
	call Music1_CopyData
	ld hl, $dea4
	ld de, $dde7
	ld a, $3
	call Music1_CopyData
	ld hl, $dea7
	ld de, $ddea
	ld a, $3
	call Music1_CopyData
	ld hl, $deaa
	ld de, $dded
	ld a, $2
	call Music1_CopyData
	ld a, [$deac]
	ld [$ddef], a
	ld hl, $dead
	ld de, $ddf3
	ld a, $8
	call Music1_CopyData
	ld hl, $deb5
	ld de, $ddfb
	ld a, $30
	call Music1_CopyData
	ret

; copies a bytes from hl to de
Music1_CopyData: ; f4c18 (3d:4c18)
	ld c, a
.asm_f4c19
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .asm_f4c19
	ret

Unknown_f4c20: ; f4c20 (3d:4c20)
INCBIN "baserom.gbc",$f4c20,$f4c28 - $f4c20

Unknown_f4c28: ; f4c28 (3d:4c28)
INCBIN "baserom.gbc",$f4c28,$f4c30 - $f4c28

Unknown_f4c30: ; f4c30 (3d:4c30)
INCBIN "baserom.gbc",$f4c30,$f4cda - $f4c30

PointerTable_f4cda: ; f4cda (3d:4cda)
	dw Unknown_f4ce4
	dw Unknown_f4cf4
	dw Unknown_f4d04
	dw Unknown_f4d14
	dw Unknown_f4d24

Unknown_f4ce4: ; f4ce4 (3d:4ce4)
INCBIN "baserom.gbc",$f4ce4,$f4cf4 - $f4ce4

Unknown_f4cf4: ; f4cf4 (3d:4cf4)
INCBIN "baserom.gbc",$f4cf4,$f4d04 - $f4cf4

Unknown_f4d04: ; f4d04 (3d:4d04)
INCBIN "baserom.gbc",$f4d04,$f4d14 - $f4d04

Unknown_f4d14: ; f4d14 (3d:4d14)
INCBIN "baserom.gbc",$f4d14,$f4d24 - $f4d14

Unknown_f4d24: ; f4d24 (3d:4d24)
INCBIN "baserom.gbc",$f4d24,$f4d34 - $f4d24

PointerTable_f4d34: ; f4d34 (3d:4d34)
	dw Unknown_f4d53
	dw Unknown_f4d4c
	dw Unknown_f4d5a
	dw Unknown_f4d4c
	dw Unknown_f4d64
	dw Unknown_f4d4c
	dw Unknown_f4d6d
	dw Unknown_f4d4c
	dw Unknown_f4d76
	dw Unknown_f4d4c
	dw Unknown_f4d4c
	dw Unknown_f4daa

Unknown_f4d4c: ; f4d4c (3d:4d4c)
INCBIN "baserom.gbc",$f4d4c,$f4d53 - $f4d4c

Unknown_f4d53: ; f4d53 (3d:4d53)
INCBIN "baserom.gbc",$f4d53,$f4d5a - $f4d53

Unknown_f4d5a: ; f4d5a (3d:4d5a)
INCBIN "baserom.gbc",$f4d5a,$f4d64 - $f4d5a

Unknown_f4d64: ; f4d64 (3d:4d64)
INCBIN "baserom.gbc",$f4d64,$f4d6d - $f4d64

Unknown_f4d6d: ; f4d6d (3d:4d6d)
INCBIN "baserom.gbc",$f4d6d,$f4d76 - $f4d6d

Unknown_f4d76: ; f4d76 (3d:4d76)
INCBIN "baserom.gbc",$f4d76,$f4daa - $f4d76

Unknown_f4daa: ; f4daa (3d:4daa)
INCBIN "baserom.gbc",$f4daa,$f4dde - $f4daa

PointerTable_f4dde: ; f4dde (3d:4dde)
	dw Unknown_f4df4
	dw Unknown_f4df7
	dw Unknown_f4e01
	dw Unknown_f4e0f
	dw Unknown_f4e19
	dw Unknown_f4e27
	dw Unknown_f4e35
	dw Unknown_f4e47
	dw Unknown_f4e5b
	dw Unknown_f4e65
	dw Unknown_f4e73

Unknown_f4df4: ; f4df4 (3d:4df4)
INCBIN "baserom.gbc",$f4df4,$f4df7 - $f4df4

Unknown_f4df7: ; f4df7 (3d:4df7)
INCBIN "baserom.gbc",$f4df7,$f4e01 - $f4df7

Unknown_f4e01: ; f4e01 (3d:4e01)
INCBIN "baserom.gbc",$f4e01,$f4e0f - $f4e01

Unknown_f4e0f: ; f4e0f (3d:4e0f)
INCBIN "baserom.gbc",$f4e0f,$f4e19 - $f4e0f

Unknown_f4e19: ; f4e19 (3d:4e19)
INCBIN "baserom.gbc",$f4e19,$f4e27 - $f4e19

Unknown_f4e27: ; f4e27 (3d:4e27)
INCBIN "baserom.gbc",$f4e27,$f4e35 - $f4e27

Unknown_f4e35: ; f4e35 (3d:4e35)
INCBIN "baserom.gbc",$f4e35,$f4e47 - $f4e35

Unknown_f4e47: ; f4e47 (3d:4e47)
INCBIN "baserom.gbc",$f4e47,$f4e5b - $f4e47

Unknown_f4e5b: ; f4e5b (3d:4e5b)
INCBIN "baserom.gbc",$f4e5b,$f4e65 - $f4e5b

Unknown_f4e65: ; f4e65 (3d:4e65)
INCBIN "baserom.gbc",$f4e65,$f4e73 - $f4e65

Unknown_f4e73: ; f4e73 (3d:4e73)
INCBIN "baserom.gbc",$f4e73,$f4e85 - $f4e73

Unknown_f4e85: ; f4e85 (3d:4e85)
INCBIN "baserom.gbc",$f4e85,$f4ee5 - $f4e85

NumberOfSongs1: ; 4fee5 (3d:4ee5)
	db $1f

SongBanks1: ; f4ee6 (3d:4ee6)
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

SongHeaderPointers1: ; f4f05 (3d:4f05)
	dw Music_Stop
	dw Music_TitleScreen
	dw Music_BattleTheme1
	dw Music_BattleTheme2
	dw Music_BattleTheme3
	dw Music_PauseMenu
	dw $0000
	dw Music_DeckMachine
	dw Music_CardPop
	dw Music_Overworld
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw Music_Unused13
	dw Music_Unused14
	dw Music_MatchStart1
	dw Music_MatchStart2
	dw Music_MatchStart3
	dw Music_MatchVictory
	dw Music_MatchLoss
	dw Music_DarkDiddly
	dw Music_Unused1b
	dw Music_BoosterPack
	dw Music_Medal
	dw Music_Unused1e

Music_Stop: ; f4f43 (3d:4f43)
	db %0000

Music_TitleScreen: ; f4f44 (3d:4f44)
	db %1111
	dw Music_TitleScreen_Ch1
	dw Music_TitleScreen_Ch2
	dw Music_TitleScreen_Ch3
	dw Music_TitleScreen_Ch4

Music_BattleTheme1: ; f4f4d (3d:4f4d)
	db %1111
	dw Music_BattleTheme1_Ch1
	dw Music_BattleTheme1_Ch2
	dw Music_BattleTheme1_Ch3
	dw Music_BattleTheme1_Ch4

Music_BattleTheme2: ; f4f56 (3d:4f56)
	db %1111
	dw Music_BattleTheme2_Ch1
	dw Music_BattleTheme2_Ch2
	dw Music_BattleTheme2_Ch3
	dw Music_BattleTheme2_Ch4

Music_BattleTheme3: ; f4f5f (3d:4f5f)
	db %1111
	dw Music_BattleTheme3_Ch1
	dw Music_BattleTheme3_Ch2
	dw Music_BattleTheme3_Ch3
	dw Music_BattleTheme3_Ch4

Music_PauseMenu: ; f4f68 (3d:4f68)
	db %1111
	dw Music_PauseMenu_Ch1
	dw Music_PauseMenu_Ch2
	dw Music_PauseMenu_Ch3
	dw Music_PauseMenu_Ch4

;Music_PCMainMenu
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

Music_DeckMachine: ; f4f7a (3d:4f7a)
	db %1111
	dw Music_DeckMachine_Ch1
	dw Music_DeckMachine_Ch2
	dw Music_DeckMachine_Ch3
	dw Music_DeckMachine_Ch4

Music_CardPop: ; f4f83 (3d:4f83)
	db %1111
	dw Music_CardPop_Ch1
	dw Music_CardPop_Ch2
	dw Music_CardPop_Ch3
	dw Music_CardPop_Ch4

Music_Overworld: ; f4f8c (3d:4f8c)
	db %1111
	dw Music_Overworld_Ch1
	dw Music_Overworld_Ch2
	dw Music_Overworld_Ch3
	dw Music_Overworld_Ch4

;Music_PokemonDome
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_ChallengeHall
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Club1
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Club2
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Club3
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Ronald
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Imakuni
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_HallOfHonor
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Credits
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

Music_Unused13: ; f4fe6 (3d:4fe6)
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

Music_Unused14: ; f4fef (3d:4fef)
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

Music_MatchStart1: ; f4ff8 (3d:4ff8)
	db %0001
	dw Music_MatchStart1_Ch1
	dw $0000
	dw $0000
	dw $0000

Music_MatchStart2: ; f5001 (3d:5001)
	db %0011
	dw Music_MatchStart2_Ch1
	dw Music_MatchStart2_Ch2
	dw $0000
	dw $0000

Music_MatchStart3: ; f500a (3d:500a)
	db %0011
	dw Music_MatchStart3_Ch1
	dw Music_MatchStart3_Ch2
	dw $0000
	dw $0000

Music_MatchVictory: ; f5013 (3d:5013)
	db %0111
	dw Music_MatchVictory_Ch1
	dw Music_MatchVictory_Ch2
	dw Music_MatchVictory_Ch3
	dw $0000

Music_MatchLoss: ; f501c (3d:501c)
	db %0111
	dw Music_MatchLoss_Ch1
	dw Music_MatchLoss_Ch2
	dw Music_MatchLoss_Ch3
	dw $0000

Music_DarkDiddly: ; f5025 (3d:5025)
	db %0111
	dw Music_DarkDiddly_Ch1
	dw Music_DarkDiddly_Ch2
	dw Music_DarkDiddly_Ch3
	dw $0000

Music_Unused1b: ; f502e (3d:502e)
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

Music_BoosterPack: ; f5037 (3d:5037)
	db %0111
	dw Music_BoosterPack_Ch1
	dw Music_BoosterPack_Ch2
	dw Music_BoosterPack_Ch3
	dw $0000

Music_Medal: ; f5040 (3d:5040)
	db %0111
	dw Music_Medal_Ch1
	dw Music_Medal_Ch2
	dw Music_Medal_Ch3
	dw $0000

Music_Unused1e: ; f5049 (3d:5049)
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

INCLUDE "music/titlescreen.asm"
INCLUDE "music/battletheme1.asm"
INCLUDE "music/battletheme2.asm"
INCLUDE "music/battletheme3.asm"
INCLUDE "music/pausemenu.asm"
INCLUDE "music/deckmachine.asm"
INCLUDE "music/cardpop.asm"
INCLUDE "music/overworld.asm"
INCLUDE "music/matchstart1.asm"
INCLUDE "music/matchstart2.asm"
INCLUDE "music/matchstart3.asm"
INCLUDE "music/matchvictory.asm"
INCLUDE "music/matchloss.asm"
INCLUDE "music/darkdiddly.asm"
INCLUDE "music/boosterpack.asm"
INCLUDE "music/medal.asm"

rept $138
db $ff
endr