Func_f8000: ; f8000 (3e:4000)
	jp Music2_Init

Func_f8003: ; f8003 (3e:4003)
	jp Music2_Update

Func_f8006: ; f8006 (3e:4006)
	jp Music2_PlaySong

Func_f8009: ; f8009 (3e:4009)
	jp Music2_PlaySFX

Func_f800c: ; f800c (3e:400c)
	jp Func_f804e

Func_f800f: ; f800f (3e:400f)
	jp Music2_AssertSongFinished

Func_f8012: ; f8012 (3e:4012)
	jp Music2_AssertSFXFinished

Func_f8015: ; f8015 (3e:4015)
	jp Func_f8066

Func_f8018: ; f8018 (3e:4018)
	jp Func_f806f

Func_f801b: ; f801b (3e:401b)
	jp Music2_PauseSong

Func_f801e: ; f801e (3e:401e)
	jp Music2_ResumeSong

Music2_PlaySong: ; f8021 (3e:4021)
	push hl
	ld hl, NumberOfSongs2
	cp [hl]
	jr nc, .invalidID
	ld [wCurSongID], a
.invalidID
	pop hl
	ret

Music2_PlaySFX: ; f802d (3e:402d)
	push bc
	push hl
	ld b, $0
	ld c, a
	or a
	jr z, .asm_f8043
	ld hl, Unknown_f8e85
	add hl, bc
	ld b, [hl]
	ld a, [wdd83]
	or a
	jr z, .asm_f8043
	cp b
	jr c, .asm_f804b
.asm_f8043
	ld a, b
	ld [wdd83], a
	ld a, c
	ld [wCurSfxID], a
.asm_f804b
	pop hl
	pop bc
	ret

Func_f804e: ; f804e (3e:404e)
	ld [wddf0], a
	ret

Music2_AssertSongFinished: ; f8052 (3e:4052)
	ld a, [wCurSongID]
	cp $80
	ld a, $1
	ret nz
	xor a
	ret

Music2_AssertSFXFinished: ; f805c (3e:405c)
	ld a, [wCurSfxID]
	cp $80
	ld a, $1
	ret nz
	xor a
	ret

Func_f8066: ; f8066 (3e:4066)
	ld a, [wddf2]
	xor $1
	ld [wddf2], a
	ret

Func_f806f: ; f806f (3e:406f)
	push bc
	push af
	and $7
	ld b, a
	swap b
	or b
	ld [wMusicPanning], a
	pop af
	pop bc
	ret

Music2_Init: ; f807d (3e:407d)
	xor a
	ldh [rNR52], a
	ld a, $80
	ldh [rNR52], a
	ld a, $77
	ldh [rNR50], a
	ld a, $ff
	ldh [rNR51], a
	ld a, $3d
	ld [wCurSongBank], a
	ld a, $80
	ld [wCurSongID], a
	ld [wCurSfxID], a
	ld a, $77 ; set both speakers to max volume
	ld [wMusicPanning], a
	xor a
	ld [wdd8c], a
	ld [wde53], a
	ld [wMusicWaveChange], a
	ld [wddef], a
	ld [wddf0], a
	ld [wddf2], a
	dec a
	ld [wMusicDC], a
	ld de, $0001
	ld bc, $0000
.zero_loop1
	ld hl, wMusicIsPlaying
	add hl, bc
	ld [hl], d
	ld hl, wMusicTie
	add hl, bc
	ld [hl], d
	ld hl, wddb3
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
	jr nz, .zero_loop1
	ld hl, Music2_ChannelLoopStacks
	ld bc, wMusicChannelStackPointers
	ld d, $8
.zero_loop2
	ld a, [hli]
	ld [bc], a
	inc bc
	dec d
	jr nz, .zero_loop2
	ret

Music2_Update: ; f80e9 (3e:40e9)
	call Music2_EmptyFunc
	call Music2_CheckForNewSound
	ld hl, SFX_UpdateSFX
	call Bankswitch3dTo3f
	ld a, [wCurSongBank]
	ldh [hBankROM], a
	ld [MBC3RomBank], a
	ld a, [wddf2]
	cp $0
	jr z, .update_channels
	call Func_f8980
	jr .skip_channel_Updates
.update_channels
	call Music2_UpdateChannel1
	call Music2_UpdateChannel2
	call Music2_UpdateChannel3
	call Music2_UpdateChannel4
.skip_channel_Updates
	call Func_f8866
	call Music2_CheckForEndOfSong
	ret

Music2_CheckForNewSound: ; f811c (3e:411c)
	ld a, [wCurSongID]
	rla
	jr c, .check_for_new_sfx
	call Music2_StopAllChannels
	ld a, [wCurSongID]
	call Music2_BeginSong
	ld a, [wCurSongID]
	or $80
	ld [wCurSongID], a
.check_for_new_sfx
	ld a, [wCurSfxID]
	rla
	jr c, .no_new_sound
	ld a, [wCurSfxID]
	ld hl, SFX_PlaySFX
	call Bankswitch3dTo3f
	ld a, [wCurSfxID]
	or $80
	ld [wCurSfxID], a
.no_new_sound
	ret

Music2_StopAllChannels: ; f814b (3e:414b)
	ld a, [wdd8c]
	ld d, a
	xor a
	ld [wMusicIsPlaying], a
	bit 0, d
	jr nz, .stop_channel_2
	ld a, $8
	ldh [rNR12], a
	swap a
	ldh [rNR14], a
.stop_channel_2
	xor a
	ld [wMusicIsPlaying + 1], a
	bit 1, d
	jr nz, .stop_channel_4
	ld a, $8
	ldh [rNR22], a
	swap a
	ldh [rNR24], a
.stop_channel_4
	xor a
	ld [wMusicIsPlaying + 3], a
	bit 3, d
	jr nz, .stop_channel_3
	ld a, $8
	ldh [rNR42], a
	swap a
	ldh [rNR44], a
.stop_channel_3
	xor a
	ld [wMusicIsPlaying + 2], a
	bit 2, d
	jr nz, .done
	ld a, $0
	ldh [rNR32], a
.done
	ret

; plays the song given by the id in a
Music2_BeginSong: ; f818c (3e:418c)
	push af
	ld c, a
	ld b, $0
	ld hl, SongBanks2
	add hl, bc
	ld a, [hl]
	ld [wCurSongBank], a
	ldh [hBankROM], a
	ld [MBC3RomBank], a
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
	jr nc, .no_channel_1
	ld a, [bc]
	inc bc
	ld [wMusicChannelPointers], a
	ld [wMusicMainLoopStart], a
	ld a, [bc]
	inc bc
	ld [wMusicChannelPointers + 1], a
	ld [wMusicMainLoopStart + 1], a
	ld a, $1
	ld [wddbb], a
	ld [wMusicIsPlaying], a
	xor a
	ld [wMusicTie], a
	ld [wMusicE4], a
	ld [wMusicE8], a
	ld [wMusicVibratoDelay], a
	ld [wMusicEC], a
	ld a, [Music2_ChannelLoopStacks]
	ld [wMusicChannelStackPointers], a
	ld a, [Music2_ChannelLoopStacks + 1]
	ld [wMusicChannelStackPointers + 1], a
	ld a, $8
	ld [wMusicE9], a
.no_channel_1
	rr e
	jr nc, .no_channel_2
	ld a, [bc]
	inc bc
	ld [wMusicChannelPointers + 2], a
	ld [wMusicMainLoopStart + 2], a
	ld a, [bc]
	inc bc
	ld [wMusicChannelPointers + 3], a
	ld [wMusicMainLoopStart + 3], a
	ld a, $1
	ld [wddbb + 1], a
	ld [wMusicIsPlaying + 1], a
	xor a
	ld [wMusicTie + 1], a
	ld [wMusicE4 + 1], a
	ld [wMusicE8 + 1], a
	ld [wMusicVibratoDelay + 1], a
	ld [wMusicEC + 1], a
	ld a, [Music2_ChannelLoopStacks + 2]
	ld [wMusicChannelStackPointers + 2], a
	ld a, [Music2_ChannelLoopStacks + 3]
	ld [wMusicChannelStackPointers + 3], a
	ld a, $8
	ld [wMusicE9 + 1], a
.no_channel_2
	rr e
	jr nc, .no_channel_3
	ld a, [bc]
	inc bc
	ld [wMusicChannelPointers + 4], a
	ld [wMusicMainLoopStart + 4], a
	ld a, [bc]
	inc bc
	ld [wMusicChannelPointers + 5], a
	ld [wMusicMainLoopStart + 5], a
	ld a, $1
	ld [wddbb + 2], a
	ld [wMusicIsPlaying + 2], a
	xor a
	ld [wMusicTie + 2], a
	ld [wMusicE4 + 2], a
	ld [wMusicE8 + 2], a
	ld [wMusicVibratoDelay + 2], a
	ld [wMusicEC + 2], a
	ld a, [Music2_ChannelLoopStacks + 4]
	ld [wMusicChannelStackPointers + 4], a
	ld a, [Music2_ChannelLoopStacks + 5]
	ld [wMusicChannelStackPointers + 5], a
	ld a, $40
	ld [wMusicE9 + 2], a
.no_channel_3
	rr e
	jr nc, .no_channel_4
	ld a, [bc]
	inc bc
	ld [wMusicChannelPointers + 6], a
	ld [wMusicMainLoopStart + 6], a
	ld a, [bc]
	inc bc
	ld [wMusicChannelPointers + 7], a
	ld [wMusicMainLoopStart + 7], a
	ld a, $1
	ld [wddbb + 3], a
	ld [wMusicIsPlaying + 3], a
	xor a
	ld [wMusicTie + 3], a
	ld [wMusicE8 + 3], a
	ld [wMusicVibratoDelay + 3], a
	ld [wMusicEC + 3], a
	ld a, [Music2_ChannelLoopStacks + 6]
	ld [wMusicChannelStackPointers + 6], a
	ld a, [Music2_ChannelLoopStacks + 7]
	ld [wMusicChannelStackPointers + 7], a
	ld a, $40
	ld [wMusicE9 + 3], a
.no_channel_4
	xor a
	ld [wddf2], a
	ret

Music2_EmptyFunc: ; f82a4 (3e:42a4)
	ret

Music2_UpdateChannel1: ; f82a5 (3e:42a5)
	ld a, [wMusicIsPlaying]
	or a
	jr z, .asm_f82fa
	ld a, [wddb7]
	cp $0
	jr z, .asm_f82d4
	ld a, [wddc3]
	dec a
	ld [wddc3], a
	jr nz, .asm_f82d4
	ld a, [wddbb]
	cp $1
	jr z, .asm_f82d4
	ld a, [wdd8c]
	bit 0, a
	jr nz, .asm_f82d4
	ld hl, rNR12
	ld a, [wMusicE9]
	ld [hli], a
	inc hl
	ld a, $80
	ld [hl], a
.asm_f82d4
	ld a, [wddbb]
	dec a
	ld [wddbb], a
	jr nz, .asm_f82f4
	ld a, [wMusicChannelPointers + 1]
	ld h, a
	ld a, [wMusicChannelPointers]
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
	ld a, [wdd8c]
	bit 0, a
	jr nz, .asm_f8309
	ld a, $8
	ldh [rNR12], a
	swap a
	ldh [rNR14], a
.asm_f8309
	ret

Music2_UpdateChannel2: ; f830a (3e:430a)
	ld a, [wMusicIsPlaying + 1]
	or a
	jr z, .asm_f835f
	ld a, [wddb8]
	cp $0
	jr z, .asm_f8339
	ld a, [wddc3 + 1]
	dec a
	ld [wddc3 + 1], a
	jr nz, .asm_f8339
	ld a, [wddbb + 1]
	cp $1
	jr z, .asm_f8339
	ld a, [wdd8c]
	bit 1, a
	jr nz, .asm_f8339
	ld hl, rNR22
	ld a, [wMusicE9 + 1]
	ld [hli], a
	inc hl
	ld a, $80
	ld [hl], a
.asm_f8339
	ld a, [wddbb + 1]
	dec a
	ld [wddbb + 1], a
	jr nz, .asm_f8359
	ld a, [wMusicChannelPointers + 3]
	ld h, a
	ld a, [wMusicChannelPointers + 2]
	ld l, a
	ld bc, $0001
	call Music2_PlayNextNote
	ld a, [wMusicIsPlaying + 1]
	or a
	jr z, .asm_f835f
	call Func_f875a
.asm_f8359
	ld a, $1
	call Func_f885a
	ret
.asm_f835f
	ld a, [wdd8c]
	bit 1, a
	jr nz, .asm_f836e
	ld a, $8
	ldh [rNR22], a
	swap a
	ldh [rNR24], a
.asm_f836e
	ret

Music2_UpdateChannel3: ; f836f (3e:436f)
	ld a, [wMusicIsPlaying + 2]
	or a
	jr z, .asm_f83be
	ld a, [wddb9]
	cp $0
	jr z, .asm_f8398
	ld a, [wddc3 + 2]
	dec a
	ld [wddc3 + 2], a
	jr nz, .asm_f8398
	ld a, [wdd8c]
	bit 2, a
	jr nz, .asm_f8398
	ld a, [wddbb + 2]
	cp $1
	jr z, .asm_f8398
	ld a, [wMusicE9 + 2]
	ldh [rNR32], a
.asm_f8398
	ld a, [wddbb + 2]
	dec a
	ld [wddbb + 2], a
	jr nz, .asm_f83b8
	ld a, [wMusicChannelPointers + 5]
	ld h, a
	ld a, [wMusicChannelPointers + 4]
	ld l, a
	ld bc, $0002
	call Music2_PlayNextNote
	ld a, [wMusicIsPlaying + 2]
	or a
	jr z, .asm_f83be
	call Func_f879c
.asm_f83b8
	ld a, $2
	call Func_f885a
	ret
.asm_f83be
	ld a, [wdd8c]
	bit 2, a
	jr nz, .asm_f83cd
	ld a, $0
	ldh [rNR32], a
	ld a, $80
	ldh [rNR34], a
.asm_f83cd
	ret

Music2_UpdateChannel4: ; f83ce (3e:43ce)
	ld a, [wMusicIsPlaying + 3]
	or a
	jr z, .asm_f8400
	ld a, [wddbb + 3]
	dec a
	ld [wddbb + 3], a
	jr nz, .asm_f83f6
	ld a, [wMusicChannelPointers + 7]
	ld h, a
	ld a, [wMusicChannelPointers + 6]
	ld l, a
	ld bc, $0003
	call Music2_PlayNextNote
	ld a, [wMusicIsPlaying + 3]
	or a
	jr z, .asm_f8400
	call Func_f880a
	jr .asm_f8413
.asm_f83f6
	ld a, [wddef]
	or a
	jr z, .asm_f8413
	call Func_f8839
	ret
.asm_f8400
	ld a, [wdd8c]
	bit 3, a
	jr nz, .asm_f8413
	xor a
	ld [wddef], a
	ld a, $8
	ldh [rNR42], a
	swap a
	ldh [rNR44], a
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
	jp hl

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
	ld hl, wdddb
	add hl, bc
	ld [hl], a
	ld hl, wdde3
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
	ld hl, wddbb
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
	ld hl, wddc3
	add hl, bc
	ld [hl], a
	pop af
	and $f0
	ld hl, wddb7
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
	ld de, wddab
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
	ld hl, wdded
	ld [hli], a
	ld [hl], d
	ld a, $1
	ld [wddef], a
	jr .asm_f858e
.asm_f8564
	ld hl, wMusicCh1CurPitch
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
	ld hl, wMusicChannelPointers
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
	ld hl, wMusicMainLoopStart
	add hl, bc
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	jp Music2_PlayNextNote_pop

Music2_EndMainLoop: ; f85fd (3e:45fd)
	pop hl
	ld hl, wMusicMainLoopStart
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp Music2_PlayNextNote

Music2_Loop: ; f8609 (3e:4609)
	pop de
	ld a, [de] ; get loop count
	inc de
	push af
	call Music2_GetChannelStackPointer
	ld [hl], e ;
	inc hl     ; store address of command at beginning of loop
	ld [hl], d ;
	inc hl
	pop af
	ld [hl], a ; store loop count
	inc hl
	push de
	call Music2_SetChannelStackPointer
	jp Music2_PlayNextNote_pop

Music2_EndLoop: ; f861e (3e:461e)
	call Music2_GetChannelStackPointer
	dec hl
	ld a, [hl] ; get remaining loop count
	dec a
	jr z, .loop_done
	ld [hld], a
	ld d, [hl]
	dec hl
	ld e, [hl]
	pop hl
	ld h, d ;
	ld l, e ; go to address of beginning of loop
	jp Music2_PlayNextNote
.loop_done
	dec hl
	dec hl
	call Music2_SetChannelStackPointer
	jp Music2_PlayNextNote_pop

Music2_jp: ; f8638 (3e:4638)
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp Music2_PlayNextNote

Music2_call: ; f863f (3e:463f)
	call Music2_GetChannelStackPointer
	pop de
	ld a, e
	ld [hli], a ;
	ld a, d     ; store address of command after call
	ld [hli], a ;
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	ld d, a
	ld e, b
	ld b, $0
	push de
	call Music2_SetChannelStackPointer
	jp Music2_PlayNextNote_pop

Music2_ret: ; f8656 (3e:4656)
	pop de
	call Music2_GetChannelStackPointer
	dec hl
	ld a, [hld] ;
	ld e, [hl]  ; retrieve address of caller of this sub branch
	ld d, a
	inc de
	inc de
	push de
	call Music2_SetChannelStackPointer
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
	ld hl, wMusicDuty1
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

; returns the address of the top of the stack
; for the current channel
; used for loops and calls
Music2_GetChannelStackPointer: ; f86fc (3e:46fc)
	ld hl, wMusicChannelStackPointers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

; sets the current channel's stack pointer to hl
Music2_SetChannelStackPointer: ; f8705 (3e:4705)
	ld d, h
	ld e, l
	ld hl, wMusicChannelStackPointers
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
	ld a, [wdd8c]
	bit 0, a
	jr nz, .asm_f8749
	ld a, [wddb7]
	cp $0
	jr z, .asm_f874a
	ld d, $0
	ld hl, wMusicTie
	ld a, [hl]
	cp $80
	jr z, .asm_f8733
	ld a, [wMusicVolume]
	ldh [rNR12], a
	ld d, $80
.asm_f8733
	ld [hl], $2
	ld a, $8
	ldh [rNR10], a
	ld a, [wMusicDuty1]
	ldh [rNR11], a
	ld a, [wMusicCh1CurPitch]
	ldh [rNR13], a
	ld a, [wMusicCh1CurOctave]
	or d
	ldh [rNR14], a
.asm_f8749
	ret
.asm_f874a
	ld hl, wMusicTie
	ld [hl], $0
	ld hl, rNR12
	ld a, $8
	ld [hli], a
	inc hl
	swap a
	ld [hl], a
	ret

Func_f875a: ; f875a (3e:475a)
	ld a, [wdd8c]
	bit 1, a
	jr nz, .asm_f878b
	ld a, [wddb8]
	cp $0
	jr z, .asm_f878c
	ld d, $0
	ld hl, wMusicTie + 1
	ld a, [hl]
	cp $80
	jr z, .asm_f8779
	ld a, [wMusicVolume + 1]
	ldh [rNR22], a
	ld d, $80
.asm_f8779
	ld [hl], $2
	ld a, [wMusicDuty2]
	ldh [rNR21], a
	ld a, [wMusicCh2CurPitch]
	ldh [rNR23], a
	ld a, [wMusicCh2CurOctave]
	or d
	ldh [rNR24], a
.asm_f878b
	ret
.asm_f878c
	ld hl, wMusicTie + 1
	ld [hl], $0
	ld hl, rNR22
	ld a, $8
	ld [hli], a
	inc hl
	swap a
	ld [hl], a
	ret

Func_f879c: ; f879c (3e:479c)
	ld a, [wdd8c]
	bit 2, a
	jr nz, .asm_f87e0
	ld d, $0
	ld a, [wMusicWaveChange]
	or a
	jr z, .no_wave_change
	xor a
	ldh [rNR30], a
	call Music2_LoadWaveInstrument
	ld d, $80
.no_wave_change
	ld a, [wddb9]
	cp $0
	jr z, .asm_f87e1
	ld hl, wMusicTie + 2
	ld a, [hl]
	cp $80
	jr z, .asm_f87cc
	ld a, [wMusicVolume + 2]
	ldh [rNR32], a
	xor a
	ldh [rNR30], a
	ld d, $80
.asm_f87cc
	ld [hl], $2
	xor a
	ldh [rNR31], a
	ld a, [wMusicCh3CurPitch]
	ldh [rNR33], a
	ld a, $80
	ldh [rNR30], a
	ld a, [wMusicCh3CurOctave]
	or d
	ldh [rNR34], a
.asm_f87e0
	ret
.asm_f87e1
	ld hl, wMusicTie
	ld [hl], $0
	xor a
	ldh [rNR30], a
	ret

Music2_LoadWaveInstrument: ; f879c (3e:47ea)
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
.copy_wave_loop
	ld a, [hli]
	ld [de], a
	inc de
	inc b
	ld a, b
	cp $10
	jr nz, .copy_wave_loop
	xor a
	ld [wMusicWaveChange], a
	ret

Func_f880a: ; f880a (3e:480a)
	ld a, [wdd8c]
	bit 3, a
	jr nz, .asm_f8829
	ld a, [wddba]
	cp $0
	jr z, asm_f882a
	ld de, rNR41
	ld hl, wddab
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
asm_f882a:
	xor a
	ld [wddef], a
	ld hl, rNR42
	ld a, $8
	ld [hli], a
	inc hl
	swap a
	ld [hl], a
	ret

Func_f8839: ; f8839 (3e:4839)
	ld a, [wdd8c]
	bit 3, a
	jr z, .asm_f8846
	xor a
	ld [wddef], a
	jr .asm_f8859
.asm_f8846
	ld hl, wdded
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld a, [de]
	cp $ff
	jr nz, .asm_f8853
	jr asm_f882a
.asm_f8853
	ldh [rNR43], a
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
	ld a, [wMusicPanning]
	ldh [rNR50], a
	ld a, [wdd8c]
	or a
	ld hl, wMusicDC
	ld a, [hli]
	jr z, .asm_f8888
	ld a, [wdd8c]
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
	ld a, [wddf0]
	xor $ff
	and $f
	ld e, a
	swap e
	or e
	and d
	ldh [rNR51], a
	ret

Func_f8898: ; f8898 (3e:4898)
	ld hl, wMusicVibratoDelay
	add hl, bc
	ld a, [hl]
	cp $0
	jr z, .asm_f8902
	ld hl, wdde3
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
	ld hl, wdddb
	add hl, bc
	ld d, $0
	ld e, [hl]
	inc [hl]
	pop hl
	add hl, de
	ld a, [hli]
	cp $80
	jr z, .asm_f88ee
	ld hl, wMusicCh1CurPitch
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
	ld hl, wdddb
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
	ld hl, wMusicCh1CurPitch
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret

Func_f890b: ; f890b (3e:490b)
	cp $0
	jr nz, .not_channel_1
	ld a, [wMusicVibratoDelay]
	cp $0
	jr z, .done
	ld a, [wdd8c]
	bit 0, a
	jr nz, .done
	ld a, e
	ldh [rNR13], a
	ldh a, [rNR11]
	and $c0
	ldh [rNR11], a
	ld a, d
	and $3f
	ldh [rNR14], a
	ret
.not_channel_1
	cp $1
	jr nz, .not_channel_2
	ld a, [wMusicVibratoDelay + 1]
	cp $0
	jr z, .done
	ld a, [wdd8c]
	bit 1, a
	jr nz, .done
	ld a, e
	ldh [rNR23], a
	ldh a, [rNR21]
	and $c0
	ldh [rNR21], a
	ld a, d
	ldh [rNR24], a
	ret
.not_channel_2
	cp $2
	jr nz, .done
	ld a, [wMusicVibratoDelay + 2]
	cp $0
	jr z, .done
	ld a, [wdd8c]
	bit 2, a
	jr nz, .done
	ld a, e
	ldh [rNR33], a
	xor a
	ldh [rNR31], a
	ld a, d
	ldh [rNR34], a
.done
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
	ld a, [wdd8c]
	ld d, a
	bit 0, d
	jr nz, .asm_f8990
	ld a, $8
	ldh [rNR12], a
	swap a
	ldh [rNR14], a
.asm_f8990
	bit 1, d
	jr nz, .asm_f899c
	swap a
	ldh [rNR22], a
	swap a
	ldh [rNR24], a
.asm_f899c
	bit 3, d
	jr nz, .asm_f89a8
	swap a
	ldh [rNR42], a
	swap a
	ldh [rNR44], a
.asm_f89a8
	bit 2, d
	jr nz, .asm_f89b0
	ld a, $0
	ldh [rNR32], a
.asm_f89b0
	ret

Music2_CheckForEndOfSong: ; f89b1 (3e:49b1)
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
	ld [wCurSongID], a
	ret

Music2_PauseSong: ; f89c4 (3e:49c4)
	di
	call Func_f8980
	call Music2_BackupSong
	call Music2_StopAllChannels
	ei
	ret

Music2_ResumeSong: ; f89d0 (3e:49d0)
	di
	call Func_f8980
	call Music2_StopAllChannels
	call Music2_LoadBackup
	ei
	ret

Music2_BackupSong: ; f89dc (3e:49dc)
	ld a, [wCurSongID]
	ld [wCurSongIDBackup], a
	ld a, [wCurSongBank]
	ld [wCurSongBankBackup], a
	ld a, [wMusicDC]
	ld [wMusicDCBackup], a
	ld hl, wMusicDuty1
	ld de, wMusicDuty1Backup
	ld a, $4
	call Music2_CopyData
	ld a, [wMusicWave]
	ld [wMusicWaveBackup], a
	ld a, [wMusicWaveChange]
	ld [wMusicWaveChangeBackup], a
	ld hl, wMusicIsPlaying
	ld de, wMusicIsPlayingBackup
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicTie
	ld de, wMusicTieBackup
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicChannelPointers
	ld de, wMusicChannelPointersBackup
	ld a, $8
	call Music2_CopyData
	ld hl, wMusicMainLoopStart
	ld de, wMusicMainLoopStartBackup
	ld a, $8
	call Music2_CopyData
	ld a, [wddab]
	ld [wde76], a
	ld a, [wddac]
	ld [wde77], a
	ld hl, wMusicOctave
	ld de, wMusicOctaveBackup
	ld a, $4
	call Music2_CopyData
	ld hl, wddb3
	ld de, wde7c
	ld a, $4
	call Music2_CopyData
	ld hl, wddb7
	ld de, wde80
	ld a, $4
	call Music2_CopyData
	ld hl, wddbb
	ld de, wde84
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicE8
	ld de, wMusicE8Backup
	ld a, $4
	call Music2_CopyData
	ld hl, wddc3
	ld de, wde8c
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicE9
	ld de, wMusicE9Backup
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicEC
	ld de, wMusicECBackup
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicSpeed
	ld de, wMusicSpeedBackup
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicVibratoType2
	ld de, wMusicVibratoType2Backup
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicVibratoDelay
	ld de, wMusicVibratoDelayBackup
	ld a, $4
	call Music2_CopyData
	ld a, $0
	ld [wdddb], a
	ld [wdddb + 1], a
	ld [wdddb + 2], a
	ld [wdddb + 3], a
	ld hl, wMusicVolume
	ld de, wMusicVolumeBackup
	ld a, $3
	call Music2_CopyData
	ld hl, wMusicE4
	ld de, wMusicE4Backup
	ld a, $3
	call Music2_CopyData
	ld hl, wdded
	ld de, wdeaa
	ld a, $2
	call Music2_CopyData
	ld a, $0
	ld [wdeac], a
	ld hl, wMusicChannelStackPointers
	ld de, wMusicChannelStackPointersBackup
	ld a, $8
	call Music2_CopyData
	ld hl, wMusicCh1Stack
	ld de, wMusicCh1StackBackup
	ld a, $c * 4
	call Music2_CopyData
	ret

Music2_LoadBackup: ; f8b01 (3e:4b01)
	ld a, [wCurSongIDBackup]
	ld [wCurSongID], a
	ld a, [wCurSongBankBackup]
	ld [wCurSongBank], a
	ld a, [wMusicDCBackup]
	ld [wMusicDC], a
	ld hl, wMusicDuty1Backup
	ld de, wMusicDuty1
	ld a, $4
	call Music2_CopyData
	ld a, [wMusicWaveBackup]
	ld [wMusicWave], a
	ld a, $1
	ld [wMusicWaveChange], a
	ld hl, wMusicIsPlayingBackup
	ld de, wMusicIsPlaying
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicTieBackup
	ld de, wMusicTie
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicChannelPointersBackup
	ld de, wMusicChannelPointers
	ld a, $8
	call Music2_CopyData
	ld hl, wMusicMainLoopStartBackup
	ld de, wMusicMainLoopStart
	ld a, $8
	call Music2_CopyData
	ld a, [wde76]
	ld [wddab], a
	ld a, [wde77]
	ld [wddac], a
	ld hl, wMusicOctaveBackup
	ld de, wMusicOctave
	ld a, $4
	call Music2_CopyData
	ld hl, wde7c
	ld de, wddb3
	ld a, $4
	call Music2_CopyData
	ld hl, wde80
	ld de, wddb7
	ld a, $4
	call Music2_CopyData
	ld hl, wde84
	ld de, wddbb
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicE8Backup
	ld de, wMusicE8
	ld a, $4
	call Music2_CopyData
	ld hl, wde8c
	ld de, wddc3
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicE9Backup
	ld de, wMusicE9
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicECBackup
	ld de, wMusicEC
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicSpeedBackup
	ld de, wMusicSpeed
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicVibratoType2Backup
	ld de, wMusicVibratoType2
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicVibratoDelayBackup
	ld de, wMusicVibratoDelay
	ld a, $4
	call Music2_CopyData
	ld hl, wMusicVolumeBackup
	ld de, wMusicVolume
	ld a, $3
	call Music2_CopyData
	ld hl, wMusicE4Backup
	ld de, wMusicE4
	ld a, $3
	call Music2_CopyData
	ld hl, wdeaa
	ld de, wdded
	ld a, $2
	call Music2_CopyData
	ld a, [wdeac]
	ld [wddef], a
	ld hl, wMusicChannelStackPointersBackup
	ld de, wMusicChannelStackPointers
	ld a, $8
	call Music2_CopyData
	ld hl, wMusicCh1StackBackup
	ld de, wMusicCh1Stack
	ld a, $c * 4
	call Music2_CopyData
	ret

; copies a bytes from hl to de
Music2_CopyData: ; f8c18 (3e:4c18)
	ld c, a
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

Music2_ChannelLoopStacks: ; f8c20 (3e:4c20)
	dw wMusicCh1Stack
	dw wMusicCh2Stack
	dw wMusicCh3Stack
	dw wMusicCh4Stack

Unknown_f8c28: ; f8c28 (3e:4c28)
	INCROM $f8c28, $f8c30

Unknown_f8c30: ; f8c30 (3e:4c30)
	INCROM $f8c30, $f8cda

Music2_WaveInstruments: ; f8cda (3e:4cda)
INCLUDE "audio/wave_instruments.asm"

Music2_NoiseInstruments: ; f8d34 (3e:4d34)
INCLUDE "audio/noise_instruments.asm"

Music2_VibratoTypes: ; f8dde (3e:4dde)
INCLUDE "audio/vibrato_types.asm"

Unknown_f8e85: ; f8e85 (3e:4e85)
	INCROM $f8e85, $f8ee5

INCLUDE "audio/music2_headers.asm"

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
