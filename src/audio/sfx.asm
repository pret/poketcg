SFX_PlaySFX: ; fc000 (3f:4000)
	jp SFX_Play

SFX_UpdateSFX: ; fc003 (3f:4003)
	jp SFX_Update

SFX_Play: ; fc006 (3f:4006)
	ld hl, NumberOfSFX
	cp [hl]
	jr nc, .invalidID
	add a
	ld c, a
	ld b, $0
	ld a, [wde53]
	or a
	jr z, .asm_fc019
	call Func_fc279
.asm_fc019
	ld a, $1
	ld [wde53], a
	ld hl, SFXHeaderPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld [wdd8c], a
	ld [wde54], a
	ld de, wde4b
	ld c, $0
.asm_fc031
	ld a, [wde54]
	rrca
	ld [wde54], a
	jr nc, .asm_fc050
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	push hl
	ld hl, wde2f
	add hl, bc
	ld [hl], $0
	ld hl, wde33
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
.invalidID
	ret

SFX_Update: ; fc059 (3f:4059)
	ld a, [wdd8c]
	or a
	jr nz, .asm_fc063
	call Func_fc26c
	ret
.asm_fc063
	xor a
	ld b, a
	ld c, a
	ld a, [wdd8c]
	ld [wde54], a
.asm_fc06c
	ld hl, wde54
	ld a, [hl]
	rrca
	ld [hl], a
	jr nc, .asm_fc08d
	ld hl, wde33
	add hl, bc
	ld a, [hl]
	dec a
	jr z, .asm_fc082
	ld [hl], a
	call Func_fc18d
	jr .asm_fc08d
.asm_fc082
	ld hl, wde4b
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
	ld hl, SFX_CommandTable
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld h, d
	ld l, e
	jp hl

SFX_CommandTable: ; fc0ab (3f:40ab)
	dw SFX_0
	dw SFX_1
	dw SFX_2
	dw SFX_loop
	dw SFX_endloop
	dw SFX_5
	dw SFX_6
	dw SFX_7
	dw SFX_8
	dw SFX_unused
	dw SFX_unused
	dw SFX_unused
	dw SFX_unused
	dw SFX_unused
	dw SFX_unused
	dw SFX_end

SFX_unused: ; fc0cb (3f:40cb)
	jp Func_fc094

SFX_0: ; fc0ce (3f:40ce)
	ld d, a
	pop hl
	ld a, [hli]
	ld e, a
	push hl
	ld hl, wde37
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
	ld hl, wde2b
	add hl, bc
	ld a, [hl]
	ld [hl], $0
	or d
	ld d, a
	ld hl, rNR11
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
	ld hl, wde4b
	add hl, bc
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ret

SFX_1: ; fc10e (3f:410e)
	ld hl, wde2b
	add hl, bc
	ld a, $80
	ld [hl], a
	pop hl
	ld a, [hli]
	ld e, a
	push hl
	ld hl, rNR12
	ld a, c
	add a
	add a
	add c
	add l
	ld l, a
	ld [hl], e
	pop hl
	jp Func_fc094

SFX_2: ; fc127 (3f:4127)
	swap a
	ld e, a
	ld hl, rNR11
	ld a, c
	add a
	add a
	add c
	add l
	ld l, a
	ld [hl], e
	pop hl
	jp Func_fc094

SFX_loop: ; fc138 (3f:4138)
	ld hl, wde43
	add hl, bc
	add hl, bc
	pop de
	ld a, [de]
	inc de
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, wde3f
	add hl, bc
	ld [hl], a
	ld l, e
	ld h, d
	jp Func_fc094

SFX_endloop: ; fc14d (3f:414d)
	ld hl, wde3f
	add hl, bc
	ld a, [hl]
	dec a
	jr z, .asm_fc162
	ld [hl], a
	ld hl, wde43
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

SFX_5: ; fc166 (3f:4166)
	ld hl, wde2f
	add hl, bc
	ld e, l
	ld d, h
	pop hl
	ld a, [hli]
	ld [de], a
	jp Func_fc094

SFX_6: ; fc172 (3f:4172)
	ld a, c
	cp $3
	jr nz, .asm_fc17c
	call Func_fc1cd
	jr .asm_fc17f
.asm_fc17c
	call Func_fc18d
.asm_fc17f
	ld hl, wde33
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
	ld hl, wde2f
	add hl, bc
	ld a, [hl]
	or a
	jr z, .asm_fc1cc
	ld hl, wde37
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
	ld hl, wde2b
	add hl, bc
	ld d, [hl]
	ld [hl], $0
	or d
	ld d, a
	ld hl, rNR11
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
	ld hl, wde32
	ld a, [hl]
	or a
	jr z, .asm_fc201
	ld hl, wde3d
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
	ld hl, wde2e
	ld e, [hl]
	ld [hl], $0
	or e
	ld e, a
	ld hl, rNR41
	xor a
	ld [hli], a
	inc hl
	ld a, d
	ld [hli], a
	ld [hl], e
.asm_fc201
	ret

SFX_7: ; fc202 (3f:4202)
	add a
	ld d, $0
	ld e, a
	ld hl, SFX_WaveInstruments
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $0
	ldh [rNR30], a
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
	ld [wMusicWaveChange], a
	ld a, $80
	ldh [rNR30], a
	ld b, $0
	pop hl
	jp Func_fc094

SFX_8: ; fc22d (3f:422d)
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
	ld hl, wdd85
	ld a, [hl]
	and e
	or d
	ld [hl], a
	pop bc
	pop hl
	jp Func_fc094

SFX_end: ; fc249 (3f:4249)
	ld e, c
	inc e
	ld a, $7f
.asm_fc24d
	rlca
	dec e
	jr nz, .asm_fc24d
	ld e, a
	ld a, [wdd8c]
	and e
	ld [wdd8c], a
	ld a, c
	rlca
	rlca
	add c
	ld e, a
	ld d, b
	ld hl, rNR12
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
	ld [wde53], a
	ld [wSfxPriority], a
	ld a, $80
	ld [wCurSfxID], a
	ret

Func_fc279: ; fc279 (3f:4279)
	ld a, $8
	ldh a, [rNR12]
	ldh a, [rNR22]
	ldh a, [rNR32]
	ldh a, [rNR42]
	ld a, $80
	ldh a, [rNR14]
	ldh a, [rNR24]
	ldh a, [rNR44]
	xor a
	ld [wdd8c], a
	ret

INCLUDE "audio/sfx_headers.asm"

SFX_WaveInstruments: ; fc485 (3f:4485)
INCLUDE "audio/wave_instruments.asm"

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

rept $c1
	db $ff
endr
