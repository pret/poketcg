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
	ld hl, Unknown_f8e85
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
	ld [wMusicWaveChange], a
	ld [$ddef], a
	ld [$ddf0], a
	ld [$ddf2], a
	dec a
	ld [wMusicDC], a
	ld de, $0001
	ld bc, $0000
.asm_f80bb
	ld hl, wMusicIsPlaying
	add hl, bc
	ld [hl], d
	ld hl, wMusicTie
	add hl, bc
	ld [hl], d
	ld hl, $ddb3
	add hl, bc
	ld [hl], d
	ld hl, wMusicEC
	add hl, bc
	ld [hl], d
	ld hl, wMusicE8
	add hl, bc
	ld [hl], d
	inc c
	ld a, c
	cp $4
	jr nz, .asm_f80bb
	ld hl, Unknown_f8c20
	ld bc, wMusicReturnAddress
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
	ld hl, Func_fc003
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
	call Music2_PlaySong
	ld a, [$dd80]
	or $80
	ld [$dd80], a
.asm_f8133
	ld a, [$dd82]
	rla
	jr c, .asm_f814a
	ld a, [$dd82]
	ld hl, Func_fc000
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
	ld [wMusicIsPlaying], a
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

; plays the song given by the id in a
Music2_PlaySong: ; f818c (3e:418c)
	push af
	ld c, a
	ld b, $0
	ld hl, SongBanks2
	add hl, bc
	ld a, [hl]
	ld [$dd81], a
	ld [$ff80], a
	ld [$2000], a
	pop af
	add a
	ld c, a
	ld b, $0
	ld hl, SongHeaderPointers2
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
	ld [wMusicMainLoop], a
	ld a, [bc]
	inc bc
	ld [$dd96], a
	ld [$dd9e], a
	ld a, $1
	ld [$ddbb], a
	ld [wMusicIsPlaying], a
	xor a
	ld [wMusicTie], a
	ld [wMusicE4], a
	ld [wMusicE8], a
	ld [wMusicVibratoDelay], a
	ld [wMusicEC], a
	ld a, [Unknown_f8c20]
	ld [wMusicReturnAddress], a
	ld a, [Unknown_f8c20 + 1]
	ld [$ddf4], a
	ld a, $8
	ld [wMusicE9], a
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
	ld a, [wMusicIsPlaying]
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
	ld a, [wMusicE9]
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
	call Music2_PlayNextNote
	ld a, [wMusicIsPlaying]
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
	call Music2_PlayNextNote
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
	call Music2_PlayNextNote
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
	call Music2_PlayNextNote
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

Music2_PlayNextNote: ; f8414 (3e:4414)
	ld a, [hli]
	push hl
	push af
	cp $d0
	jr c, Music2_note
	sub $d0
	add a
	ld e, a
	ld d, $0
	ld hl, Music2_CommandTable
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld h, d
	ld l, e
	pop af
	jp [hl]

Music2_CommandTable: ; f842c (3e:442c)
	dw Music2_speed
	dw Music2_octave
	dw Music2_octave
	dw Music2_octave
	dw Music2_octave
	dw Music2_octave
	dw Music2_octave
	dw Music2_inc_octave
	dw Music2_dec_octave
	dw Music2_tie
	dw Music2_end
	dw Music2_end
	dw Music2_musicdc
	dw Music2_MainLoop
	dw Music2_EndMainLoop
	dw Music2_Loop
	dw Music2_EndLoop
	dw Music2_jp
	dw Music2_call
	dw Music2_ret
	dw Music2_musice4
	dw Music2_duty
	dw Music2_volume
	dw Music2_wave
	dw Music2_musice8
	dw Music2_musice9
	dw Music2_vibrato_type
	dw Music2_vibrato_delay
	dw Music2_musicec
	dw Music2_musiced
	dw Music2_end
	dw Music2_end
	dw Music2_end
	dw Music2_end
	dw Music2_end
	dw Music2_end
	dw Music2_end
	dw Music2_end
	dw Music2_end
	dw Music2_end
	dw Music2_end
	dw Music2_end
	dw Music2_end
	dw Music2_end
	dw Music2_end
	dw Music2_end
	dw Music2_end
	dw Music2_end

Music2_note: ; f448c (3d:448c)
	push af
	ld a, [hl]
	ld e, a
	ld hl, wMusicTie
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
	ld hl, wMusicVibratoType2
	add hl, bc
	ld a, [hl]
	ld hl, wMusicVibratoType
	add hl, bc
	ld [hl], a
.asm_f84b0
	pop af
	push de
	ld hl, wMusicSpeed
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
	ld hl, wMusicE8
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
	ld hl, wMusicOctave
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
	ld hl, Music2_NoiseInstruments
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
	ld a, [wMusicDC]
	and $77
	or d
	ld [wMusicDC], a
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
	ld hl, wMusicOctave
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld hl, Unknown_f8c28
	add hl, de
	add a
	ld e, [hl]
	add e
	ld hl, wMusicEC
	add hl, bc
	ld e, [hl]
	add e
	add e
	ld e, a
	ld hl, Unknown_f8c30
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

Music2_speed: ; f8598 (3e:4598)
	pop hl
	ld a, [hli]
	push hl
	ld hl, wMusicSpeed
	add hl, bc
	ld [hl], a
	jp Music2_PlayNextNote_pop

Music2_octave: ; f85a3 (3e:45a3)
	and $7
	dec a
	ld hl, wMusicOctave
	add hl, bc
	push af
	ld a, c
	cp $2
	jr nz, .asm_f85b6
	pop af
	inc a
	ld [hl], a
	jp Music2_PlayNextNote_pop
.asm_f85b6
	pop af
	ld [hl], a
	jp Music2_PlayNextNote_pop

Music2_inc_octave: ; f85bb (3e:45bb)
	ld hl, wMusicOctave
	add hl, bc
	inc [hl]
	jp Music2_PlayNextNote_pop

Music2_dec_octave: ; f85c3 (3e:45c3)
	ld hl, wMusicOctave
	add hl, bc
	dec [hl]
	jp Music2_PlayNextNote_pop

Music2_tie: ; f85cb (3e:45cb)
	ld hl, wMusicTie
	add hl, bc
	ld [hl], $80
	jp Music2_PlayNextNote_pop

Music2_musicdc: ; f85d4 (3e:45d4)
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
	ld hl, wMusicDC
	ld a, [hl]
	and e
	or d
	ld [hl], a
	pop bc
	jp Music2_PlayNextNote_pop

Music2_MainLoop: ; f85ef (3e:45ef)
	pop de
	push de
	dec de
	ld hl, wMusicMainLoop
	add hl, bc
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	jp Music2_PlayNextNote_pop

Music2_EndMainLoop: ; f85fd (3e:45fd)
	pop hl
	ld hl, wMusicMainLoop
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp Music2_PlayNextNote

Music2_Loop: ; f8609 (3e:4609)
	pop de
	ld a, [de]
	inc de
	push af
	call Music2_GetReturnAddress
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	pop af
	ld [hl], a
	inc hl
	push de
	call Music2_SetReturnAddress
	jp Music2_PlayNextNote_pop

Music2_EndLoop: ; f861e (3e:461e)
	call Music2_GetReturnAddress
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
	jp Music2_PlayNextNote
.asm_f8630
	dec hl
	dec hl
	call Music2_SetReturnAddress
	jp Music2_PlayNextNote_pop

Music2_jp: ; f8638 (3e:4638)
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp Music2_PlayNextNote

Music2_call: ; f863f (3e:463f)
	call Music2_GetReturnAddress
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
	call Music2_SetReturnAddress
	jp Music2_PlayNextNote_pop

Music2_ret: ; f8656 (3e:4656)
	pop de
	call Music2_GetReturnAddress
	dec hl
	ld a, [hld]
	ld e, [hl]
	ld d, a
	inc de
	inc de
	push de
	call Music2_SetReturnAddress
	jp Music2_PlayNextNote_pop

Music2_musice4: ; f8667 (3e:4667)
	pop de
	ld a, [de]
	inc de
	ld hl, wMusicE4
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music2_PlayNextNote

Music2_duty: ; f8674 (3e:4674)
	pop de
	ld a, [de]
	and $c0
	inc de
	ld hl, wMusicDuty
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music2_PlayNextNote

Music2_volume: ; f8683 (3e:4683)
	pop de
	ld a, [de]
	inc de
	ld hl, wMusicVolume
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music2_PlayNextNote

Music2_wave: ; f8690 (3e:4690)
	pop de
	ld a, [de]
	inc de
	ld [wMusicWave], a
	ld a, $1
	ld [wMusicWaveChange], a
	ld h, d
	ld l, e
	jp Music2_PlayNextNote

Music2_musice8: ; f86a0 (3e:46a0)
	pop de
	ld a, [de]
	inc de
	ld hl, wMusicE8
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music2_PlayNextNote

Music2_musice9: ; f86ad (3e:46ad)
	pop de
	ld a, [de]
	inc de
	ld hl, wMusicE9
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music2_PlayNextNote

Music2_vibrato_type: ; f86ba (3e:46ba)
	pop de
	ld a, [de]
	inc de
	ld hl, wMusicVibratoType
	add hl, bc
	ld [hl], a
	ld hl, wMusicVibratoType2
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music2_PlayNextNote

Music2_vibrato_delay: ; f86cc (3e:46cc)
	pop de
	ld a, [de]
	inc de
	ld hl, wMusicVibratoDelay
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music2_PlayNextNote

Music2_musicec: ; f86d9 (3e:46d9)
	pop de
	ld a, [de]
	inc de
	ld hl, wMusicEC
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music2_PlayNextNote

Music2_musiced: ; f86e6 (3e:46e6)
	pop de
	ld a, [de]
	inc de
	ld hl, wMusicEC
	add hl, bc
	add [hl]
	ld [hl], a
	ld h, d
	ld l, e
	jp Music2_PlayNextNote

Music2_end: ; f86f4 (3e:46f4)
	ld hl, wMusicIsPlaying
	add hl, bc
	ld [hl], $0
	pop hl
	ret

; returns the address where the address to
; return to is stored for the current channel
Music2_GetReturnAddress: ; f86fc (3e:46fc)
	ld hl, wMusicReturnAddress
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

; puts the address in hl where the address to
; return to is stored for the currentchannel
Music2_SetReturnAddress: ; f8705 (3e:4705)
	ld d, h
	ld e, l
	ld hl, wMusicReturnAddress
	add hl, bc
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ret

Music2_PlayNextNote_pop: ; f8710 (3e:4710)
	pop hl
	jp Music2_PlayNextNote

Func_f8714: ; f8714 (3e:4714)
	ld a, [$dd8c]
	bit 0, a
	jr nz, .asm_f8749
	ld a, [$ddb7]
	cp $0
	jr z, .asm_f874a
	ld d, $0
	ld hl, wMusicTie
	ld a, [hl]
	cp $80
	jr z, .asm_f8733
	ld a, [wMusicVolume]
	ld [$ff12], a
	ld d, $80
.asm_f8733
	ld [hl], $2
	ld a, $8
	ld [$ff10], a
	ld a, [wMusicDuty]
	ld [$ff11], a
	ld a, [$dda5]
	ld [$ff13], a
	ld a, [$dda6]
	or d
	ld [$ff14], a
.asm_f8749
	ret
.asm_f874a
	ld hl, wMusicTie
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
	ld a, [wMusicWaveChange]
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
	ld hl, wMusicTie
	ld [hl], $0
	xor a
	ld [$ff1a], a
	ret

Func_f87ea: ; f879c (3e:47ea)
	ld a, [wMusicWave]
	add a
	ld d, $0
	ld e, a
	ld hl, Music2_WaveInstruments
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
	ld [wMusicWaveChange], a
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
	ld hl, wMusicDC
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
	ld hl, wMusicVibratoDelay
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
	ld hl, wMusicVibratoType
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld hl, Music2_VibratoTypes
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
	ld hl, wMusicVibratoType
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
	ld a, [wMusicVibratoDelay]
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
	ld hl, wMusicE4
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
	ld hl, wMusicIsPlaying
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
	ld a, [wMusicDC]
	ld [$de57], a
	ld hl, wMusicDuty
	ld de, $de58
	ld a, $4
	call Music2_CopyData
	ld a, [wMusicWave]
	ld [$de5c], a
	ld a, [wMusicWaveChange]
	ld [$de5d], a
	ld hl, wMusicIsPlaying
	ld de, $de5e
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicTie
	ld de, $de62
	ld a, $4
	call Music2_CopyData
	ld hl, $dd95
	ld de, $de66
	ld a, $8
	call Music2_CopyData
	ld hl, wMusicMainLoop
	ld de, $de6e
	ld a, $8
	call Music2_CopyData
	ld a, [$ddab]
	ld [$de76], a
	ld a, [$ddac]
	ld [$de77], a
	ld hl, wMusicOctave
	ld de, $de78
	ld a, $4
	call Music2_CopyData
	ld hl, $ddb3
	ld de, $de7c
	ld a, $4
	call Music2_CopyData
	ld hl, $ddb7
	ld de, $de80
	ld a, $4
	call Music2_CopyData
	ld hl, $ddbb
	ld de, $de84
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicE8
	ld de, $de88
	ld a, $4
	call Music2_CopyData
	ld hl, $ddc3
	ld de, $de8c
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicE9
	ld de, $de90
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicEC
	ld de, $de94
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicSpeed
	ld de, $de98
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicVibratoType2
	ld de, $de9c
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicVibratoDelay
	ld de, $dea0
	ld a, $4
	call Music2_CopyData
	ld a, $0
	ld [$dddb], a
	ld [$dddc], a
	ld [$dddd], a
	ld [$ddde], a
	ld hl, wMusicVolume
	ld de, $dea4
	ld a, $3
	call Music2_CopyData
	ld hl, wMusicE4
	ld de, $dea7
	ld a, $3
	call Music2_CopyData
	ld hl, $dded
	ld de, $deaa
	ld a, $2
	call Music2_CopyData
	ld a, $0
	ld [$deac], a
	ld hl, wMusicReturnAddress
	ld de, $dead
	ld a, $8
	call Music2_CopyData
	ld hl, $ddfb
	ld de, $deb5
	ld a, $30
	call Music2_CopyData
	ret

Func_f8b01: ; f8b01 (3e:4b01)
	ld a, [$de55]
	ld [$dd80], a
	ld a, [$de56]
	ld [$dd81], a
	ld a, [$de57]
	ld [wMusicDC], a
	ld hl, $de58
	ld de, wMusicDuty
	ld a, $4
	call Music2_CopyData
	ld a, [$de5c]
	ld [wMusicWave], a
	ld a, $1
	ld [wMusicWaveChange], a
	ld hl, $de5e
	ld de, wMusicIsPlaying
	ld a, $4
	call Music2_CopyData
	ld hl, $de62
	ld de, wMusicTie
	ld a, $4
	call Music2_CopyData
	ld hl, $de66
	ld de, $dd95
	ld a, $8
	call Music2_CopyData
	ld hl, $de6e
	ld de, wMusicMainLoop
	ld a, $8
	call Music2_CopyData
	ld a, [$de76]
	ld [$ddab], a
	ld a, [$de77]
	ld [$ddac], a
	ld hl, $de78
	ld de, wMusicOctave
	ld a, $4
	call Music2_CopyData
	ld hl, $de7c
	ld de, $ddb3
	ld a, $4
	call Music2_CopyData
	ld hl, $de80
	ld de, $ddb7
	ld a, $4
	call Music2_CopyData
	ld hl, $de84
	ld de, $ddbb
	ld a, $4
	call Music2_CopyData
	ld hl, $de88
	ld de, wMusicE8
	ld a, $4
	call Music2_CopyData
	ld hl, $de8c
	ld de, $ddc3
	ld a, $4
	call Music2_CopyData
	ld hl, $de90
	ld de, wMusicE9
	ld a, $4
	call Music2_CopyData
	ld hl, $de94
	ld de, wMusicEC
	ld a, $4
	call Music2_CopyData
	ld hl, $de98
	ld de, wMusicSpeed
	ld a, $4
	call Music2_CopyData
	ld hl, $de9c
	ld de, wMusicVibratoType2
	ld a, $4
	call Music2_CopyData
	ld hl, $dea0
	ld de, wMusicVibratoDelay
	ld a, $4
	call Music2_CopyData
	ld hl, $dea4
	ld de, wMusicVolume
	ld a, $3
	call Music2_CopyData
	ld hl, $dea7
	ld de, wMusicE4
	ld a, $3
	call Music2_CopyData
	ld hl, $deaa
	ld de, $dded
	ld a, $2
	call Music2_CopyData
	ld a, [$deac]
	ld [$ddef], a
	ld hl, $dead
	ld de, wMusicReturnAddress
	ld a, $8
	call Music2_CopyData
	ld hl, $deb5
	ld de, $ddfb
	ld a, $30
	call Music2_CopyData
	ret

; copies a bytes from hl to de
Music2_CopyData: ; f8c18 (3e:4c18)
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
INCBIN "baserom.gbc",$f8c28,$f8c30 - $f8c28

Unknown_f8c30: ; f8c30 (3e:4c30)
INCBIN "baserom.gbc",$f8c30,$f8cda - $f8c30

Music2_WaveInstruments: ; f8cda (3e:4cda)
INCLUDE "data/wave_instruments.asm"

Music2_NoiseInstruments: ; f8d34 (3e:4d34)
INCLUDE "data/noise_instruments.asm"

Music2_VibratoTypes: ; f8dde (3e:4dde)
INCLUDE "data/vibrato_types.asm"

Unknown_f8e85: ; f8e85 (3e:4e85)
INCBIN "baserom.gbc",$f8e85,$f8ee5 - $f8e85

INCLUDE "data/music2_headers.asm"

INCLUDE "audio/music/pcmainmenu.asm"
INCLUDE "audio/music/pokemondome.asm"
INCLUDE "audio/music/challengehall.asm"
INCLUDE "audio/music/club1.asm"
INCLUDE "audio/music/club2.asm"
INCLUDE "audio/music/club3.asm"
INCLUDE "audio/music/ronald.asm"
INCLUDE "audio/music/imakuni.asm"
INCLUDE "audio/music/hallofhonor.asm"
INCLUDE "audio/music/credits.asm"

rept $109
db $ff
endr
