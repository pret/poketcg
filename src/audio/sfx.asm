SFX_PlaySFX:
	jp SFX_Play

SFX_UpdateSFX:
	jp SFX_Update

SFX_Play:
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

SFX_Update:
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

Func_fc094:
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

SFX_CommandTable:
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

SFX_unused:
	jp Func_fc094

SFX_0:
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
Func_fc105:
	ld hl, wde4b
	add hl, bc
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ret

SFX_1:
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

SFX_2:
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

SFX_loop:
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

SFX_endloop:
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

SFX_5:
	ld hl, wde2f
	add hl, bc
	ld e, l
	ld d, h
	pop hl
	ld a, [hli]
	ld [de], a
	jp Func_fc094

SFX_6:
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

Func_fc18d:
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

Func_fc1cd:
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

SFX_7:
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

SFX_8:
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

SFX_end:
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

Func_fc26c:
	xor a
	ld [wde53], a
	ld [wSfxPriority], a
	ld a, $80
	ld [wCurSfxID], a
	ret

Func_fc279:
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

SFX_WaveInstruments:
INCLUDE "audio/wave_instruments.asm"

INCLUDE "audio/sfx/sfx_cursor.asm"
INCLUDE "audio/sfx/sfx_confirm.asm"
INCLUDE "audio/sfx/sfx_cancel.asm"
INCLUDE "audio/sfx/sfx_denied.asm"
INCLUDE "audio/sfx/sfx_unused_05.asm"
INCLUDE "audio/sfx/sfx_unused_06.asm"
INCLUDE "audio/sfx/sfx_card_shuffle.asm"
INCLUDE "audio/sfx/sfx_place_prize.asm"
INCLUDE "audio/sfx/sfx_unused_09.asm"
INCLUDE "audio/sfx/sfx_unused_0a.asm"
INCLUDE "audio/sfx/sfx_coin_toss.asm"
INCLUDE "audio/sfx/sfx_warp.asm"
INCLUDE "audio/sfx/sfx_unused_0d.asm"
INCLUDE "audio/sfx/sfx_unused_0e.asm"
INCLUDE "audio/sfx/sfx_pokemon_dome_doors.asm"
INCLUDE "audio/sfx/sfx_legendary_cards.asm"
INCLUDE "audio/sfx/sfx_glow.asm"
INCLUDE "audio/sfx/sfx_paralysis.asm"
INCLUDE "audio/sfx/sfx_sleep.asm"
INCLUDE "audio/sfx/sfx_confusion.asm"
INCLUDE "audio/sfx/sfx_poison.asm"
INCLUDE "audio/sfx/sfx_single_hit.asm"
INCLUDE "audio/sfx/sfx_big_hit.asm"
INCLUDE "audio/sfx/sfx_thunder_shock.asm"
INCLUDE "audio/sfx/sfx_lightning.asm"
INCLUDE "audio/sfx/sfx_border_spark.asm"
INCLUDE "audio/sfx/sfx_big_lightning.asm"
INCLUDE "audio/sfx/sfx_small_flame.asm"
INCLUDE "audio/sfx/sfx_big_flame.asm"
INCLUDE "audio/sfx/sfx_fire_spin.asm"
INCLUDE "audio/sfx/sfx_dive_bomb.asm"
INCLUDE "audio/sfx/sfx_water_jets.asm"
INCLUDE "audio/sfx/sfx_water_gun.asm"
INCLUDE "audio/sfx/sfx_whirlpool.asm"
INCLUDE "audio/sfx/sfx_hydro_pump.asm"
INCLUDE "audio/sfx/sfx_blizzard.asm"
INCLUDE "audio/sfx/sfx_psychic.asm"
INCLUDE "audio/sfx/sfx_leer.asm"
INCLUDE "audio/sfx/sfx_beam.asm"
INCLUDE "audio/sfx/sfx_hyper_beam.asm"
INCLUDE "audio/sfx/sfx_rock_throw.asm"
INCLUDE "audio/sfx/sfx_stone_barrage.asm"
INCLUDE "audio/sfx/sfx_punch.asm"
INCLUDE "audio/sfx/sfx_stretch_kick.asm"
INCLUDE "audio/sfx/sfx_slash.asm"
INCLUDE "audio/sfx/sfx_sonicboom.asm"
INCLUDE "audio/sfx/sfx_fury_swipes.asm"
INCLUDE "audio/sfx/sfx_drill.asm"
INCLUDE "audio/sfx/sfx_pot_smash.asm"
INCLUDE "audio/sfx/sfx_bonemerang.asm"
INCLUDE "audio/sfx/sfx_seismic_toss.asm"
INCLUDE "audio/sfx/sfx_needles.asm"
INCLUDE "audio/sfx/sfx_white_gas.asm"
INCLUDE "audio/sfx/sfx_powder.asm"
INCLUDE "audio/sfx/sfx_goo.asm"
INCLUDE "audio/sfx/sfx_bubbles.asm"
INCLUDE "audio/sfx/sfx_string_shot.asm"
INCLUDE "audio/sfx/sfx_boyfriends.asm"
INCLUDE "audio/sfx/sfx_lure.asm"
INCLUDE "audio/sfx/sfx_toxic.asm"
INCLUDE "audio/sfx/sfx_confuse_ray.asm"
INCLUDE "audio/sfx/sfx_sing.asm"
INCLUDE "audio/sfx/sfx_supersonic.asm"
INCLUDE "audio/sfx/sfx_petal_dance.asm"
INCLUDE "audio/sfx/sfx_protect.asm"
INCLUDE "audio/sfx/sfx_barrier.asm"
INCLUDE "audio/sfx/sfx_speed.asm"
INCLUDE "audio/sfx/sfx_whirlwind.asm"
INCLUDE "audio/sfx/sfx_cry.asm"
INCLUDE "audio/sfx/sfx_question_mark.asm"
INCLUDE "audio/sfx/sfx_selfdestruct.asm"
INCLUDE "audio/sfx/sfx_big_selfdestruct.asm"
INCLUDE "audio/sfx/sfx_heal.asm"
INCLUDE "audio/sfx/sfx_drain.asm"
INCLUDE "audio/sfx/sfx_dark_gas.asm"
INCLUDE "audio/sfx/sfx_healing_wind.asm"
INCLUDE "audio/sfx/sfx_bench_whirlwind.asm"
INCLUDE "audio/sfx/sfx_expand.asm"
INCLUDE "audio/sfx/sfx_cat_punch.asm"
INCLUDE "audio/sfx/sfx_thunder_wave.asm"
INCLUDE "audio/sfx/sfx_firegiver.asm"
INCLUDE "audio/sfx/sfx_thunderpunch.asm"
INCLUDE "audio/sfx/sfx_fire_punch.asm"
INCLUDE "audio/sfx/sfx_coin_toss_heads.asm"
INCLUDE "audio/sfx/sfx_coin_toss_tails.asm"
INCLUDE "audio/sfx/sfx_save_game.asm"
INCLUDE "audio/sfx/sfx_player_walk_map.asm"
INCLUDE "audio/sfx/sfx_intro_orb.asm"
INCLUDE "audio/sfx/sfx_intro_orb_swoop.asm"
INCLUDE "audio/sfx/sfx_intro_orb_title.asm"
INCLUDE "audio/sfx/sfx_intro_orb_scatter.asm"
INCLUDE "audio/sfx/sfx_firegiver_start.asm"
INCLUDE "audio/sfx/sfx_receive_card_pop.asm"
INCLUDE "audio/sfx/sfx_pokemon_evolution.asm"
INCLUDE "audio/sfx/sfx_unused_5f.asm"
