_SetupSound:: ; f4000 (3d:4000)
	jp Music1_Init

SoundTimerHandler:: ; f4003 (3d:4003)
	jp Music1_Update

_PlaySong:: ; f4006 (3d:4006)
	jp Music1_PlaySong

_PlaySFX:: ; f4009 (3d:4009)
	jp Music1_PlaySFX

Func_f400c:: ; f400c (3d:400c)
	jp Func_f404e

_AssertSongFinished:: ; f400f (3d:400f)
	jp Music1_AssertSongFinished

_AssertSFXFinished:: ; f4012 (3d:4012)
	jp Music1_AssertSFXFinished

Func_f4015:: ; f4015 (3d:4015)
	jp Func_f4066

Func_f4018:: ; f4018 (3d:4018)
	jp Func_f406f

_PauseSong:: ; f401b (3d:401b)
	jp Music1_PauseSong

_ResumeSong:: ; f401e (3d:401e)
	jp Music1_ResumeSong

Music1_PlaySong: ; f4021 (3d:4021)
	push hl
	ld hl, NumberOfSongs1
	cp [hl]
	jr nc, .invalidID
	ld [wCurSongID], a
.invalidID
	pop hl
	ret

Music1_PlaySFX: ; f402d (3d:402d)
	push bc
	push hl
	ld b, $0
	ld c, a
	or a
	jr z, .asm_f4043
	ld hl, Unknown_f4e85
	add hl, bc
	ld b, [hl]
	ld a, [wdd83]
	or a
	jr z, .asm_f4043
	cp b
	jr c, .asm_f404b
.asm_f4043
	ld a, b
	ld [wdd83], a
	ld a, c
	ld [wCurSfxID], a
.asm_f404b
	pop hl
	pop bc
	ret

Func_f404e: ; f404e (3d:404e)
	ld [wddf0], a
	ret

Music1_AssertSongFinished: ; f4052 (3d:4052)
	ld a, [wCurSongID]
	cp $80
	ld a, $1
	ret nz
	xor a
	ret

Music1_AssertSFXFinished: ; f405c (3d:405c)
	ld a, [wCurSfxID]
	cp $80
	ld a, $1
	ret nz
	xor a
	ret

Func_f4066: ; f4066 (3d:4066)
	ld a, [wddf2]
	xor $1
	ld [wddf2], a
	ret

Func_f406f: ; f406f (3d:406f)
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

Music1_Init: ; f407d (3d:407d)
	xor a
	ld [rNR52], a
	ld a, $80
	ld [rNR52], a
	ld a, $77
	ld [rNR50], a
	ld a, $ff
	ld [rNR51], a
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
	ld hl, Music1_ChannelLoopStacks
	ld bc, wMusicChannelStackPointers
	ld d, $8
.zero_loop2
	ld a, [hli]
	ld [bc], a
	inc bc
	dec d
	jr nz, .zero_loop2
	ret

Music1_Update: ; f40e9 (3d:40e9)
	call Music1_EmptyFunc
	call Music1_CheckForNewSound
	ld hl, SFX_UpdateSFX
	call Bankswitch3dTo3f
	ld a, [wCurSongBank]
	ldh [hBankROM], a
	ld [MBC3RomBank], a
	ld a, [wddf2]
	cp $0
	jr z, .update_channels
	call Func_f4980
	jr .skip_channel_Updates
.update_channels
	call Music1_UpdateChannel1
	call Music1_UpdateChannel2
	call Music1_UpdateChannel3
	call Music1_UpdateChannel4
.skip_channel_Updates
	call Func_f4866
	call Music1_CheckForEndOfSong
	ret

Music1_CheckForNewSound: ; f411c (3d:411c)
	ld a, [wCurSongID]
	rla
	jr c, .check_for_new_sfx
	call Music1_StopAllChannels
	ld a, [wCurSongID]
	call Music1_BeginSong
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

Music1_StopAllChannels: ; f414b (3d:414b)
	ld a, [wdd8c]
	ld d, a
	xor a
	ld [wMusicIsPlaying], a
	bit 0, d
	jr nz, .stop_channel_2
	ld a, $8
	ld [rNR12], a
	swap a
	ld [rNR14], a
.stop_channel_2
	xor a
	ld [wMusicIsPlaying + 1], a
	bit 1, d
	jr nz, .stop_channel_4
	ld a, $8
	ld [rNR22], a
	swap a
	ld [rNR24], a
.stop_channel_4
	xor a
	ld [wMusicIsPlaying + 3], a
	bit 3, d
	jr nz, .stop_channel_3
	ld a, $8
	ld [rNR42], a
	swap a
	ld [rNR44], a
.stop_channel_3
	xor a
	ld [wMusicIsPlaying + 2], a
	bit 2, d
	jr nz, .done
	ld a, $0
	ld [rNR32], a
.done
	ret

; plays the song given by the id in a
Music1_BeginSong: ; f418c (3d:418c)
	push af
	ld c, a
	ld b, $0
	ld hl, SongBanks1
	add hl, bc
	ld a, [hl]
	ld [wCurSongBank], a
	ldh [hBankROM], a
	ld [MBC3RomBank], a
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
	ld a, [Music1_ChannelLoopStacks]
	ld [wMusicChannelStackPointers], a
	ld a, [Music1_ChannelLoopStacks + 1]
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
	ld a, [Music1_ChannelLoopStacks + 2]
	ld [wMusicChannelStackPointers + 2], a
	ld a, [Music1_ChannelLoopStacks + 3]
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
	ld a, [Music1_ChannelLoopStacks + 4]
	ld [wMusicChannelStackPointers + 4], a
	ld a, [Music1_ChannelLoopStacks + 5]
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
	ld a, [Music1_ChannelLoopStacks + 6]
	ld [wMusicChannelStackPointers + 6], a
	ld a, [Music1_ChannelLoopStacks + 7]
	ld [wMusicChannelStackPointers + 7], a
	ld a, $40
	ld [wMusicE9 + 3], a
.no_channel_4
	xor a
	ld [wddf2], a
	ret

Music1_EmptyFunc: ; f42a4 (3d:42a4)
	ret

Music1_UpdateChannel1: ; f42a5 (3d:42a5)
	ld a, [wMusicIsPlaying]
	or a
	jr z, .asm_f42fa
	ld a, [wddb7]
	cp $0
	jr z, .asm_f42d4
	ld a, [wddc3]
	dec a
	ld [wddc3], a
	jr nz, .asm_f42d4
	ld a, [wddbb]
	cp $1
	jr z, .asm_f42d4
	ld a, [wdd8c]
	bit 0, a
	jr nz, .asm_f42d4
	ld hl, rNR12
	ld a, [wMusicE9]
	ld [hli], a
	inc hl
	ld a, $80
	ld [hl], a
.asm_f42d4
	ld a, [wddbb]
	dec a
	ld [wddbb], a
	jr nz, .asm_f42f4
	ld a, [wMusicChannelPointers + 1]
	ld h, a
	ld a, [wMusicChannelPointers]
	ld l, a
	ld bc, $0000
	call Music1_PlayNextNote
	ld a, [wMusicIsPlaying]
	or a
	jr z, .asm_f42fa
	call Func_f4714
.asm_f42f4
	ld a, $0
	call Func_f485a
	ret
.asm_f42fa
	ld a, [wdd8c]
	bit 0, a
	jr nz, .asm_f4309
	ld a, $8
	ld [rNR12], a
	swap a
	ld [rNR14], a
.asm_f4309
	ret

Music1_UpdateChannel2: ; f430a (3d:430a)
	ld a, [wMusicIsPlaying + 1]
	or a
	jr z, .asm_f435f
	ld a, [wddb8]
	cp $0
	jr z, .asm_f4339
	ld a, [wddc3 + 1]
	dec a
	ld [wddc3 + 1], a
	jr nz, .asm_f4339
	ld a, [wddbb + 1]
	cp $1
	jr z, .asm_f4339
	ld a, [wdd8c]
	bit 1, a
	jr nz, .asm_f4339
	ld hl, rNR22
	ld a, [wMusicE9 + 1]
	ld [hli], a
	inc hl
	ld a, $80
	ld [hl], a
.asm_f4339
	ld a, [wddbb + 1]
	dec a
	ld [wddbb + 1], a
	jr nz, .asm_f4359
	ld a, [wMusicChannelPointers + 3]
	ld h, a
	ld a, [wMusicChannelPointers + 2]
	ld l, a
	ld bc, $0001
	call Music1_PlayNextNote
	ld a, [wMusicIsPlaying + 1]
	or a
	jr z, .asm_f435f
	call Func_f475a
.asm_f4359
	ld a, $1
	call Func_f485a
	ret
.asm_f435f
	ld a, [wdd8c]
	bit 1, a
	jr nz, .asm_f436e
	ld a, $8
	ld [rNR22], a
	swap a
	ld [rNR24], a
.asm_f436e
	ret

Music1_UpdateChannel3: ; f436f (3d:436f)
	ld a, [wMusicIsPlaying + 2]
	or a
	jr z, .asm_f43be
	ld a, [wddb9]
	cp $0
	jr z, .asm_f4398
	ld a, [wddc3 + 2]
	dec a
	ld [wddc3 + 2], a
	jr nz, .asm_f4398
	ld a, [wdd8c]
	bit 2, a
	jr nz, .asm_f4398
	ld a, [wddbb + 2]
	cp $1
	jr z, .asm_f4398
	ld a, [wMusicE9 + 2]
	ld [rNR32], a
.asm_f4398
	ld a, [wddbb + 2]
	dec a
	ld [wddbb + 2], a
	jr nz, .asm_f43b8
	ld a, [wMusicChannelPointers + 5]
	ld h, a
	ld a, [wMusicChannelPointers + 4]
	ld l, a
	ld bc, $0002
	call Music1_PlayNextNote
	ld a, [wMusicIsPlaying + 2]
	or a
	jr z, .asm_f43be
	call Func_f479c
.asm_f43b8
	ld a, $2
	call Func_f485a
	ret
.asm_f43be
	ld a, [wdd8c]
	bit 2, a
	jr nz, .asm_f43cd
	ld a, $0
	ld [rNR32], a
	ld a, $80
	ld [rNR34], a
.asm_f43cd
	ret

Music1_UpdateChannel4: ; f43ce (3d:43ce)
	ld a, [wMusicIsPlaying + 3]
	or a
	jr z, .asm_f4400
	ld a, [wddbb + 3]
	dec a
	ld [wddbb + 3], a
	jr nz, .asm_f43f6
	ld a, [wMusicChannelPointers + 7]
	ld h, a
	ld a, [wMusicChannelPointers + 6]
	ld l, a
	ld bc, $0003
	call Music1_PlayNextNote
	ld a, [wMusicIsPlaying + 3]
	or a
	jr z, .asm_f4400
	call Func_f480a
	jr .asm_f4413
.asm_f43f6
	ld a, [wddef]
	or a
	jr z, .asm_f4413
	call Func_f4839
	ret
.asm_f4400
	ld a, [wdd8c]
	bit 3, a
	jr nz, .asm_f4413
	xor a
	ld [wddef], a
	ld a, $8
	ld [rNR42], a
	swap a
	ld [rNR44], a
.asm_f4413
	ret

Music1_PlayNextNote: ; f4414 (3d:4414)
	ld a, [hli]
	push hl
	push af
	cp $d0
	jr c, Music1_note
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
	jp hl

Music1_CommandTable: ; f442c (3d:442c)
	dw Music1_speed
	dw Music1_octave
	dw Music1_octave
	dw Music1_octave
	dw Music1_octave
	dw Music1_octave
	dw Music1_octave
	dw Music1_inc_octave
	dw Music1_dec_octave
	dw Music1_tie
	dw Music1_end
	dw Music1_end
	dw Music1_musicdc
	dw Music1_MainLoop
	dw Music1_EndMainLoop
	dw Music1_Loop
	dw Music1_EndLoop
	dw Music1_jp
	dw Music1_call
	dw Music1_ret
	dw Music1_musice4
	dw Music1_duty
	dw Music1_volume
	dw Music1_wave
	dw Music1_musice8
	dw Music1_musice9
	dw Music1_vibrato_type
	dw Music1_vibrato_delay
	dw Music1_musicec
	dw Music1_musiced
	dw Music1_end
	dw Music1_end
	dw Music1_end
	dw Music1_end
	dw Music1_end
	dw Music1_end
	dw Music1_end
	dw Music1_end
	dw Music1_end
	dw Music1_end
	dw Music1_end
	dw Music1_end
	dw Music1_end
	dw Music1_end
	dw Music1_end
	dw Music1_end
	dw Music1_end
	dw Music1_end

Music1_note: ; f448c (3d:448c)
	push af
	ld a, [hl]
	ld e, a
	ld hl, wMusicTie
	add hl, bc
	ld a, [hl]
	cp $80
	jr z, .asm_f44b0
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
.asm_f44b0
	pop af
	push de
	ld hl, wMusicSpeed
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
	ld hl, wddbb
	add hl, bc
	ld [hl], a
	pop de
	ld d, a
	ld a, e
	cp $d9
	ld a, d
	jr z, .asm_f44fb
	ld e, a
	ld hl, wMusicE8
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
	ld hl, wddc3
	add hl, bc
	ld [hl], a
	pop af
	and $f0
	ld hl, wddb7
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
	ld hl, Music1_NoiseInstruments
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
	jr .asm_f458e
.asm_f4564
	ld hl, wMusicCh1CurPitch
	add hl, bc
	add hl, bc
	push hl
	ld hl, wMusicOctave
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld hl, Unknown_f4c28
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
	ld hl, wMusicChannelPointers
	add hl, bc
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ret

Music1_speed: ; f4598 (3d:4598)
	pop hl
	ld a, [hli]
	push hl
	ld hl, wMusicSpeed
	add hl, bc
	ld [hl], a
	jp Music1_PlayNextNote_pop

Music1_octave: ; f45a3 (3d:45a3)
	and $7
	dec a
	ld hl, wMusicOctave
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

Music1_inc_octave: ; f45bb (3d:45bb)
	ld hl, wMusicOctave
	add hl, bc
	inc [hl]
	jp Music1_PlayNextNote_pop

Music1_dec_octave: ; f45c3 (3d:45c3)
	ld hl, wMusicOctave
	add hl, bc
	dec [hl]
	jp Music1_PlayNextNote_pop

Music1_tie: ; f45cb (3d:45cb)
	ld hl, wMusicTie
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
	ld hl, wMusicDC
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
	ld hl, wMusicMainLoopStart
	add hl, bc
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	jp Music1_PlayNextNote_pop

Music1_EndMainLoop: ; f45fd (3d:45fd)
	pop hl
	ld hl, wMusicMainLoopStart
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp Music1_PlayNextNote

Music1_Loop: ; f4609 (3d:4609)
	pop de
	ld a, [de] ; get loop count
	inc de
	push af
	call Music1_GetChannelStackPointer
	ld [hl], e ;
	inc hl     ; store address of command at beginning of loop
	ld [hl], d ;
	inc hl
	pop af
	ld [hl], a ; store loop count
	inc hl
	push de
	call Music1_SetChannelStackPointer
	jp Music1_PlayNextNote_pop

Music1_EndLoop: ; f461e (3d:461e)
	call Music1_GetChannelStackPointer
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
	jp Music1_PlayNextNote
.loop_done
	dec hl
	dec hl
	call Music1_SetChannelStackPointer
	jp Music1_PlayNextNote_pop

Music1_jp: ; f4638 (3d:4638)
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp Music1_PlayNextNote

Music1_call: ; f463f (3d:463f)
	call Music1_GetChannelStackPointer
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
	call Music1_SetChannelStackPointer
	jp Music1_PlayNextNote_pop

Music1_ret: ; f4656 (3d:4656)
	pop de
	call Music1_GetChannelStackPointer
	dec hl
	ld a, [hld] ;
	ld e, [hl]  ; retrieve address of caller of this sub branch
	ld d, a
	inc de
	inc de
	push de
	call Music1_SetChannelStackPointer
	jp Music1_PlayNextNote_pop

Music1_musice4: ; f4667 (3d:4667)
	pop de
	ld a, [de]
	inc de
	ld hl, wMusicE4
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music1_PlayNextNote

Music1_duty: ; f4674 (3d:4674)
	pop de
	ld a, [de]
	and $c0
	inc de
	ld hl, wMusicDuty1
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music1_PlayNextNote

Music1_volume: ; f4683 (3d:4683)
	pop de
	ld a, [de]
	inc de
	ld hl, wMusicVolume
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music1_PlayNextNote

Music1_wave: ; f4690 (3d:4690)
	pop de
	ld a, [de]
	inc de
	ld [wMusicWave], a
	ld a, $1
	ld [wMusicWaveChange], a
	ld h, d
	ld l, e
	jp Music1_PlayNextNote

Music1_musice8: ; f46a0 (3d:46a0)
	pop de
	ld a, [de]
	inc de
	ld hl, wMusicE8
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music1_PlayNextNote

Music1_musice9: ; f46ad (3d:46ad)
	pop de
	ld a, [de]
	inc de
	ld hl, wMusicE9
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music1_PlayNextNote

Music1_vibrato_type: ; f46ba (3d:46ba)
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
	jp Music1_PlayNextNote

Music1_vibrato_delay: ; f46cc (3d:46cc)
	pop de
	ld a, [de]
	inc de
	ld hl, wMusicVibratoDelay
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music1_PlayNextNote

Music1_musicec: ; f46d9 (3d:46d9)
	pop de
	ld a, [de]
	inc de
	ld hl, wMusicEC
	add hl, bc
	ld [hl], a
	ld h, d
	ld l, e
	jp Music1_PlayNextNote

Music1_musiced: ; f46e6 (3d:46e6)
	pop de
	ld a, [de]
	inc de
	ld hl, wMusicEC
	add hl, bc
	add [hl]
	ld [hl], a
	ld h, d
	ld l, e
	jp Music1_PlayNextNote

Music1_end: ; f46f4 (3d:46f4)
	ld hl, wMusicIsPlaying
	add hl, bc
	ld [hl], $0
	pop hl
	ret

; returns the address of the top of the stack
; for the current channel
; used for loops and calls
Music1_GetChannelStackPointer: ; f46fc (3d:46fc)
	ld hl, wMusicChannelStackPointers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

; sets the current channel's stack pointer to hl
Music1_SetChannelStackPointer: ; f4705 (3d:4705)
	ld d, h
	ld e, l
	ld hl, wMusicChannelStackPointers
	add hl, bc
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ret

Music1_PlayNextNote_pop: ; f4710 (3d:4710)
	pop hl
	jp Music1_PlayNextNote

Func_f4714: ; f4714 (3d:4714)
	ld a, [wdd8c]
	bit 0, a
	jr nz, .asm_f4749
	ld a, [wddb7]
	cp $0
	jr z, .asm_f474a
	ld d, $0
	ld hl, wMusicTie
	ld a, [hl]
	cp $80
	jr z, .asm_f4733
	ld a, [wMusicVolume]
	ld [rNR12], a
	ld d, $80
.asm_f4733
	ld [hl], $2
	ld a, $8
	ld [rNR10], a
	ld a, [wMusicDuty1]
	ld [rNR11], a
	ld a, [wMusicCh1CurPitch]
	ld [rNR13], a
	ld a, [wMusicCh1CurOctave]
	or d
	ld [rNR14], a
.asm_f4749
	ret
.asm_f474a
	ld hl, wMusicTie
	ld [hl], $0
	ld hl, rNR12
	ld a, $8
	ld [hli], a
	inc hl
	swap a
	ld [hl], a
	ret

Func_f475a: ; f475a (3d:475a)
	ld a, [wdd8c]
	bit 1, a
	jr nz, .asm_f478b
	ld a, [wddb8]
	cp $0
	jr z, .asm_f478c
	ld d, $0
	ld hl, wMusicTie + 1
	ld a, [hl]
	cp $80
	jr z, .asm_f4779
	ld a, [wMusicVolume + 1]
	ld [rNR22], a
	ld d, $80
.asm_f4779
	ld [hl], $2
	ld a, [wMusicDuty2]
	ld [rNR21], a
	ld a, [wMusicCh2CurPitch]
	ld [rNR23], a
	ld a, [wMusicCh2CurOctave]
	or d
	ld [rNR24], a
.asm_f478b
	ret
.asm_f478c
	ld hl, wMusicTie + 1
	ld [hl], $0
	ld hl, rNR22
	ld a, $8
	ld [hli], a
	inc hl
	swap a
	ld [hl], a
	ret

Func_f479c: ; f479c (3d:479c)
	ld a, [wdd8c]
	bit 2, a
	jr nz, .asm_f47e0
	ld d, $0
	ld a, [wMusicWaveChange]
	or a
	jr z, .no_wave_change
	xor a
	ld [rNR30], a
	call Music1_LoadWaveInstrument
	ld d, $80
.no_wave_change
	ld a, [wddb9]
	cp $0
	jr z, .asm_f47e1
	ld hl, wMusicTie + 2
	ld a, [hl]
	cp $80
	jr z, .asm_f47cc
	ld a, [wMusicVolume + 2]
	ld [rNR32], a
	xor a
	ld [rNR30], a
	ld d, $80
.asm_f47cc
	ld [hl], $2
	xor a
	ld [rNR31], a
	ld a, [wMusicCh3CurPitch]
	ld [rNR33], a
	ld a, $80
	ld [rNR30], a
	ld a, [wMusicCh3CurOctave]
	or d
	ld [rNR34], a
.asm_f47e0
	ret
.asm_f47e1
	ld hl, wMusicTie
	ld [hl], $0
	xor a
	ld [rNR30], a
	ret

Music1_LoadWaveInstrument: ; f479c (3d:47ea)
	ld a, [wMusicWave]
	add a
	ld d, $0
	ld e, a
	ld hl, Music1_WaveInstruments
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

Func_f480a: ; f480a (3d:480a)
	ld a, [wdd8c]
	bit 3, a
	jr nz, .asm_f4829
	ld a, [wddba]
	cp $0
	jr z, asm_f482a
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
.asm_f4829
	ret
asm_f482a:
	xor a
	ld [wddef], a
	ld hl, rNR42
	ld a, $8
	ld [hli], a
	inc hl
	swap a
	ld [hl], a
	ret

Func_f4839: ; f4839 (3d:4839)
	ld a, [wdd8c]
	bit 3, a
	jr z, .asm_f4846
	xor a
	ld [wddef], a
	jr .asm_f4859
.asm_f4846
	ld hl, wdded
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld a, [de]
	cp $ff
	jr nz, .asm_f4853
	jr asm_f482a
.asm_f4853
	ld [rNR43], a
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
	call Music1_UpdateVibrato
	pop af
	call Func_f490b
	ret

Func_f4866: ; f4866 (3d:4866)
	ld a, [wMusicPanning]
	ld [rNR50], a
	ld a, [wdd8c]
	or a
	ld hl, wMusicDC
	ld a, [hli]
	jr z, .asm_f4888
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
.asm_f4888
	ld d, a
	ld a, [wddf0]
	xor $ff
	and $f
	ld e, a
	swap e
	or e
	and d
	ld [rNR51], a
	ret

Music1_UpdateVibrato: ; f4898 (3d:4898)
	ld hl, wMusicVibratoDelay
	add hl, bc
	ld a, [hl]
	cp $0
	jr z, .asm_f4902
	ld hl, wdde3
	add hl, bc
	cp [hl]
	jr z, .asm_f48ab
	inc [hl]
	jr .asm_f4902
.asm_f48ab
	ld hl, wMusicVibratoType
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld hl, Music1_VibratoTypes
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
	jr z, .asm_f48ee
	ld hl, wMusicCh1CurPitch
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
	ld hl, wdddb
	add hl, bc
	ld [hl], $0
	pop hl
	ld a, [hl]
	cp $80
	jr z, .asm_f48ab
	ld hl, wMusicVibratoType
	add hl, bc
	ld [hl], a
	jr .asm_f48ab
.asm_f4902
	ld hl, wMusicCh1CurPitch
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret

Func_f490b: ; f490b (3d:490b)
	cp $0
	jr nz, .not_channel_1
	ld a, [wMusicVibratoDelay]
	cp $0
	jr z, .done
	ld a, [wdd8c]
	bit 0, a
	jr nz, .done
	ld a, e
	ld [rNR13], a
	ld a, [rNR11]
	and $c0
	ld [rNR11], a
	ld a, d
	and $3f
	ld [rNR14], a
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
	ld [rNR23], a
	ld a, [rNR21]
	and $c0
	ld [rNR21], a
	ld a, d
	ld [rNR24], a
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
	ld [rNR33], a
	xor a
	ld [rNR31], a
	ld a, d
	ld [rNR34], a
.done
	ret

Func_f4967: ; f4967 (3d:4967)
	ld hl, wMusicE4
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
	ld a, [wdd8c]
	ld d, a
	bit 0, d
	jr nz, .asm_f4990
	ld a, $8
	ld [rNR12], a
	swap a
	ld [rNR14], a
.asm_f4990
	bit 1, d
	jr nz, .asm_f499c
	swap a
	ld [rNR22], a
	swap a
	ld [rNR24], a
.asm_f499c
	bit 3, d
	jr nz, .asm_f49a8
	swap a
	ld [rNR42], a
	swap a
	ld [rNR44], a
.asm_f49a8
	bit 2, d
	jr nz, .asm_f49b0
	ld a, $0
	ld [rNR32], a
.asm_f49b0
	ret

Music1_CheckForEndOfSong: ; f49b1 (3d:49b1)
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

Music1_PauseSong: ; f49c4 (3d:49c4)
	di
	call Func_f4980
	call Music1_BackupSong
	call Music1_StopAllChannels
	ei
	ret

Music1_ResumeSong: ; f49d0 (3d:49d0)
	di
	call Func_f4980
	call Music1_StopAllChannels
	call Music1_LoadBackup
	ei
	ret

Music1_BackupSong: ; f49dc (3d:49dc)
	ld a, [wCurSongID]
	ld [wCurSongIDBackup], a
	ld a, [wCurSongBank]
	ld [wCurSongBankBackup], a
	ld a, [wMusicDC]
	ld [wMusicDCBackup], a
	ld hl, wMusicDuty1
	ld de, wMusicDuty1Backup
	ld a, $4
	call Music1_CopyData
	ld a, [wMusicWave]
	ld [wMusicWaveBackup], a
	ld a, [wMusicWaveChange]
	ld [wMusicWaveChangeBackup], a
	ld hl, wMusicIsPlaying
	ld de, wMusicIsPlayingBackup
	ld a, $4
	call Music1_CopyData
	ld hl, wMusicTie
	ld de, wMusicTieBackup
	ld a, $4
	call Music1_CopyData
	ld hl, wMusicChannelPointers
	ld de, wMusicChannelPointersBackup
	ld a, $8
	call Music1_CopyData
	ld hl, wMusicMainLoopStart
	ld de, wMusicMainLoopStartBackup
	ld a, $8
	call Music1_CopyData
	ld a, [wddab]
	ld [wde76], a
	ld a, [wddac]
	ld [wde77], a
	ld hl, wMusicOctave
	ld de, wMusicOctaveBackup
	ld a, $4
	call Music1_CopyData
	ld hl, wddb3
	ld de, wde7c
	ld a, $4
	call Music1_CopyData
	ld hl, wddb7
	ld de, wde80
	ld a, $4
	call Music1_CopyData
	ld hl, wddbb
	ld de, wde84
	ld a, $4
	call Music1_CopyData
	ld hl, wMusicE8
	ld de, wMusicE8Backup
	ld a, $4
	call Music1_CopyData
	ld hl, wddc3
	ld de, wde8c
	ld a, $4
	call Music1_CopyData
	ld hl, wMusicE9
	ld de, wMusicE9Backup
	ld a, $4
	call Music1_CopyData
	ld hl, wMusicEC
	ld de, wMusicECBackup
	ld a, $4
	call Music1_CopyData
	ld hl, wMusicSpeed
	ld de, wMusicSpeedBackup
	ld a, $4
	call Music1_CopyData
	ld hl, wMusicVibratoType2
	ld de, wMusicVibratoType2Backup
	ld a, $4
	call Music1_CopyData
	ld hl, wMusicVibratoDelay
	ld de, wMusicVibratoDelayBackup
	ld a, $4
	call Music1_CopyData
	ld a, $0
	ld [wdddb], a
	ld [wdddb + 1], a
	ld [wdddb + 2], a
	ld [wdddb + 3], a
	ld hl, wMusicVolume
	ld de, wMusicVolumeBackup
	ld a, $3
	call Music1_CopyData
	ld hl, wMusicE4
	ld de, wMusicE4Backup
	ld a, $3
	call Music1_CopyData
	ld hl, wdded
	ld de, wdeaa
	ld a, $2
	call Music1_CopyData
	ld a, $0
	ld [wdeac], a
	ld hl, wMusicChannelStackPointers
	ld de, wMusicChannelStackPointersBackup
	ld a, $8
	call Music1_CopyData
	ld hl, wMusicCh1Stack
	ld de, wMusicCh1StackBackup
	ld a, $c * 4
	call Music1_CopyData
	ret

Music1_LoadBackup: ; f4b01 (3d:4b01)
	ld a, [wCurSongIDBackup]
	ld [wCurSongID], a
	ld a, [wCurSongBankBackup]
	ld [wCurSongBank], a
	ld a, [wMusicDCBackup]
	ld [wMusicDC], a
	ld hl, wMusicDuty1Backup
	ld de, wMusicDuty1
	ld a, $4
	call Music1_CopyData
	ld a, [wMusicWaveBackup]
	ld [wMusicWave], a
	ld a, $1
	ld [wMusicWaveChange], a
	ld hl, wMusicIsPlayingBackup
	ld de, wMusicIsPlaying
	ld a, $4
	call Music1_CopyData
	ld hl, wMusicTieBackup
	ld de, wMusicTie
	ld a, $4
	call Music1_CopyData
	ld hl, wMusicChannelPointersBackup
	ld de, wMusicChannelPointers
	ld a, $8
	call Music1_CopyData
	ld hl, wMusicMainLoopStartBackup
	ld de, wMusicMainLoopStart
	ld a, $8
	call Music1_CopyData
	ld a, [wde76]
	ld [wddab], a
	ld a, [wde77]
	ld [wddac], a
	ld hl, wMusicOctaveBackup
	ld de, wMusicOctave
	ld a, $4
	call Music1_CopyData
	ld hl, wde7c
	ld de, wddb3
	ld a, $4
	call Music1_CopyData
	ld hl, wde80
	ld de, wddb7
	ld a, $4
	call Music1_CopyData
	ld hl, wde84
	ld de, wddbb
	ld a, $4
	call Music1_CopyData
	ld hl, wMusicE8Backup
	ld de, wMusicE8
	ld a, $4
	call Music1_CopyData
	ld hl, wde8c
	ld de, wddc3
	ld a, $4
	call Music1_CopyData
	ld hl, wMusicE9Backup
	ld de, wMusicE9
	ld a, $4
	call Music1_CopyData
	ld hl, wMusicECBackup
	ld de, wMusicEC
	ld a, $4
	call Music1_CopyData
	ld hl, wMusicSpeedBackup
	ld de, wMusicSpeed
	ld a, $4
	call Music1_CopyData
	ld hl, wMusicVibratoType2Backup
	ld de, wMusicVibratoType2
	ld a, $4
	call Music1_CopyData
	ld hl, wMusicVibratoDelayBackup
	ld de, wMusicVibratoDelay
	ld a, $4
	call Music1_CopyData
	ld hl, wMusicVolumeBackup
	ld de, wMusicVolume
	ld a, $3
	call Music1_CopyData
	ld hl, wMusicE4Backup
	ld de, wMusicE4
	ld a, $3
	call Music1_CopyData
	ld hl, wdeaa
	ld de, wdded
	ld a, $2
	call Music1_CopyData
	ld a, [wdeac]
	ld [wddef], a
	ld hl, wMusicChannelStackPointersBackup
	ld de, wMusicChannelStackPointers
	ld a, $8
	call Music1_CopyData
	ld hl, wMusicCh1StackBackup
	ld de, wMusicCh1Stack
	ld a, $c * 4
	call Music1_CopyData
	ret

; copies a bytes from hl to de
Music1_CopyData: ; f4c18 (3d:4c18)
	ld c, a
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

Music1_ChannelLoopStacks: ; f4c20 (3d:4c20)
	dw wMusicCh1Stack
	dw wMusicCh2Stack
	dw wMusicCh3Stack
	dw wMusicCh4Stack

Unknown_f4c28: ; f4c28 (3d:4c28)
	INCROM $f4c28, $f4c30

Unknown_f4c30: ; f4c30 (3d:4c30)
	INCROM $f4c30, $f4cda

Music1_WaveInstruments: ; f4cda (3d:4cda)
INCLUDE "audio/wave_instruments.asm"

Music1_NoiseInstruments: ; f4d34 (3d:4d34)
INCLUDE "audio/noise_instruments.asm"

Music1_VibratoTypes: ; f4dde (3d:4dde)
INCLUDE "audio/vibrato_types.asm"

Unknown_f4e85: ; f4e85 (3d:4e85)
	INCROM $f4e85, $f4ee5

INCLUDE "audio/music1_headers.asm"

INCLUDE "audio/music/titlescreen.asm"
INCLUDE "audio/music/dueltheme1.asm"
INCLUDE "audio/music/dueltheme2.asm"
INCLUDE "audio/music/dueltheme3.asm"
INCLUDE "audio/music/pausemenu.asm"
INCLUDE "audio/music/deckmachine.asm"
INCLUDE "audio/music/cardpop.asm"
INCLUDE "audio/music/overworld.asm"
INCLUDE "audio/music/matchstart1.asm"
INCLUDE "audio/music/matchstart2.asm"
INCLUDE "audio/music/matchstart3.asm"
INCLUDE "audio/music/matchvictory.asm"
INCLUDE "audio/music/matchloss.asm"
INCLUDE "audio/music/darkdiddly.asm"
INCLUDE "audio/music/boosterpack.asm"
INCLUDE "audio/music/medal.asm"

rept $138
	db $ff
endr
