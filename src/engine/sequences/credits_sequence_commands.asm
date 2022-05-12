SetCreditsSequenceCmdPtr: ; 1d7fc (7:57fc)
	ld a, LOW(CreditsSequence)
	ld [wSequenceCmdPtr + 0], a
	ld a, HIGH(CreditsSequence)
	ld [wSequenceCmdPtr + 1], a
	xor a
	ld [wSequenceDelay], a
	ret

ExecuteCreditsSequenceCmd: ; 1d80b (7:580b)
	ld a, [wSequenceDelay]
	or a
	jr z, .call_func
	cp $ff
	ret z ; sequence ended

	dec a ; still waiting
	ld [wSequenceDelay], a
	ret

.call_func
	ld a, [wSequenceCmdPtr + 0]
	ld l, a
	ld a, [wSequenceCmdPtr + 1]
	ld h, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push de
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	pop hl
	call CallHL2
	jr ExecuteCreditsSequenceCmd

	ret ; stray ret

AdvanceCreditsSequenceCmdPtrBy2: ; 1d835 (7:5835)
	ld a, 2
	jr AdvanceCreditsSequenceCmdPtr

AdvanceCreditsSequenceCmdPtrBy3: ; 1d839 (7:5839)
	ld a, 3
	jr AdvanceCreditsSequenceCmdPtr

AdvanceCreditsSequenceCmdPtrBy5: ; 1d83d (7:583d)
	ld a, 5
	jr AdvanceCreditsSequenceCmdPtr

AdvanceCreditsSequenceCmdPtrBy6: ; 1d841 (7:5841)
	ld a, 6
	jr AdvanceCreditsSequenceCmdPtr

AdvanceCreditsSequenceCmdPtrBy4: ; 1d845 (7:5845)
	ld a, 4
;	fallthrough

AdvanceCreditsSequenceCmdPtr: ; 1d847 (7:5847)
	push hl
	ld hl, wSequenceCmdPtr
	add [hl]
	ld [hli], a
	ld a, [hl]
	adc 0
	ld [hl], a
	pop hl
	ret

CreditsSequenceCmd_Wait: ; 1d853 (7:5853)
	ld a, c
	ld [wSequenceDelay], a
	jp AdvanceCreditsSequenceCmdPtrBy3

CreditsSequenceCmd_LoadScene: ; 1d85a (7:585a)
	push bc
	push de
	farcall ClearNumLoadedFramesetSubgroups
	call EmptyScreen
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	farcall SetDefaultPalettes
	pop de
	pop bc
	ld a, c
	ld c, b
	ld b, a
	ld a, e
	call LoadScene
	jp AdvanceCreditsSequenceCmdPtrBy5

CreditsSequenceCmd_LoadBooster: ; 1d878 (7:5878)
	push bc
	push de
	farcall ClearNumLoadedFramesetSubgroups
	call EmptyScreen
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	farcall SetDefaultPalettes
	pop de
	pop bc
	ld a, c
	ld c, b
	ld b, a
	ld a, e
	farcall LoadBoosterGfx
	jp AdvanceCreditsSequenceCmdPtrBy5

CreditsSequenceCmd_LoadClubMap: ; 1d897 (7:5897)
	ld b, $00
	ld hl, wMastersBeatenList
	add hl, bc
	ld a, [hl]
	or a
	jr nz, .at_least_1
	inc a
.at_least_1
	dec a
	ld c, a
	add a
	add a
	add c ; *5
	ld c, a
	ld hl, .CreditsOWClubMaps
	add hl, bc
	ld a, [hli] ; map x coord
	ld c, a
	ld a, [hli] ; map y coord
	ld b, a
	ld a, [hli] ; map ID
	ld e, a
	push hl
	call LoadOWMapForCreditsSequence
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, .done

.loop_npcs
	ld a, [hli] ; NPC ID
	or a
	jr z, .done
	ld d, a
	ld a, [hli] ; NPC x coord
	ld c, a
	ld a, [hli] ; NPC y coord
	ld b, a
	ld a, [hli] ; NPC direction
	ld e, a
	push hl
	call LoadNPCForCreditsSequence
	pop hl
	jr .loop_npcs

.done
	jp AdvanceCreditsSequenceCmdPtrBy3

MACRO credits_club_map
	db \1 ; x
	db \2 ; y
	db \3 ; OW map
	dw \4 ; list of NPCs to load
ENDM

.CreditsOWClubMaps
	credits_club_map 16,  0, FIGHTING_CLUB,  .CreditsNPCs_FightingClub
	credits_club_map 32,  0, ROCK_CLUB,      .CreditsNPCs_RockClub
	credits_club_map 64,  0, WATER_CLUB,     .CreditsNPCs_WaterClub
	credits_club_map 32,  0, LIGHTNING_CLUB, .CreditsNPCs_LightningClub
	credits_club_map 32,  0, GRASS_CLUB,     .CreditsNPCs_GrassClub
	credits_club_map 32, 16, PSYCHIC_CLUB,   .CreditsNPCs_PsychicClub
	credits_club_map  0,  0, SCIENCE_CLUB,   .CreditsNPCs_ScienceClub
	credits_club_map 32,  0, FIRE_CLUB,      .CreditsNPCs_FireClub
	credits_club_map 32,  0, CHALLENGE_HALL, .CreditsNPCs_ChallengeHall
	credits_club_map 48,  0, POKEMON_DOME,   .CreditsNPCs_PokemonDome

.CreditsNPCs_FightingClub
	; NPC ID, x, y, direction
	db NPC_CHRIS,           4,  8, SOUTH
	db NPC_MICHAEL,        14, 10, SOUTH
	db NPC_JESSICA,        18,  6, EAST
	db NPC_MITCH,          10,  4, SOUTH
	db NPC_PLAYER_CREDITS, 10,  6, NORTH
	db $00

.CreditsNPCs_RockClub
	; NPC ID, x, y, direction
	db NPC_RYAN,           20, 14, EAST
	db NPC_GENE,           12,  6, SOUTH
	db NPC_PLAYER_CREDITS, 12,  8, NORTH
	db $00

.CreditsNPCs_WaterClub
	; NPC ID, x, y, direction
	db NPC_JOSHUA,         22,  8, SOUTH
	db NPC_AMY,            22,  4, NORTH
	db NPC_PLAYER_CREDITS, 18, 10, NORTH
	db $00

.CreditsNPCs_LightningClub
	; NPC ID, x, y, direction
	db NPC_NICHOLAS,        6, 10, SOUTH
	db NPC_BRANDON,        22, 12, NORTH
	db NPC_ISAAC,          12,  4, NORTH
	db NPC_PLAYER_CREDITS, 12, 10, NORTH
	db $00

.CreditsNPCs_GrassClub
	; NPC ID, x, y, direction
	db NPC_KRISTIN,         4, 10, EAST
	db NPC_HEATHER,        14, 16, SOUTH
	db NPC_NIKKI,          12,  4, SOUTH
	db NPC_PLAYER_CREDITS, 12,  6, NORTH
	db $00

.CreditsNPCs_PsychicClub
	; NPC ID, x, y, direction
	db NPC_DANIEL,          8,  8, NORTH
	db NPC_STEPHANIE,      22, 12, EAST
	db NPC_MURRAY1,        12,  6, SOUTH
	db NPC_PLAYER_CREDITS, 12,  8, NORTH
	db $00

.CreditsNPCs_ScienceClub
	; NPC ID, x, y, direction
	db NPC_JOSEPH,         10, 10, WEST
	db NPC_RICK,            4,  4, SOUTH
	db NPC_PLAYER_CREDITS,  4,  6, NORTH
	db $00

.CreditsNPCs_FireClub
	; NPC ID, x, y, direction
	db NPC_ADAM,            8, 14, SOUTH
	db NPC_JONATHAN,       18, 10, SOUTH
	db NPC_KEN,            14,  4, SOUTH
	db NPC_PLAYER_CREDITS, 14,  6, NORTH
	db $00

.CreditsNPCs_ChallengeHall
	; NPC ID, x, y, direction
	db NPC_HOST,           14,  4, SOUTH
	db NPC_RONALD1,        18,  8, WEST
	db NPC_PLAYER_CREDITS, 12,  8, EAST
	db $00

.CreditsNPCs_PokemonDome
	; NPC ID, x, y, direction
	db NPC_COURTNEY,       18,  4, SOUTH
	db NPC_STEVE,          22,  4, SOUTH
	db NPC_JACK,            8,  4, SOUTH
	db NPC_ROD,            14,  6, SOUTH
	db NPC_PLAYER_CREDITS, 14, 10, NORTH
	db $00

; bc = coordinates
; e = OW map
LoadOWMapForCreditsSequence: ; 1d9a6 (7:59a6)
	push bc
	push de
	call EmptyScreen
	pop de
	pop bc

	; set input coordinates and map
	ld a, c
	ldh [hSCX], a
	ld a, b
	ldh [hSCY], a
	ld a, e
	ld [wCurMap], a

	farcall LoadMapTilesAndPals
	farcall Func_c9c7
	farcall SafelyCopyBGMapFromSRAMToVRAM
	farcall DoMapOWFrame
	xor a
	ld [wd4ca], a
	ld [wd4cb], a
	ld a, PALETTE_29
	farcall LoadPaletteData
	ret

CreditsSequenceCmd_LoadOWMap: ; 1d9d5 (7:59d5)
	call LoadOWMapForCreditsSequence
	jp AdvanceCreditsSequenceCmdPtrBy5

CreditsSequenceCmd_DisableLCD: ; 1d9db (7:59db)
	call DisableLCD
	jp AdvanceCreditsSequenceCmdPtrBy2

CreditsSequenceCmd_FadeIn: ; 1d9e1 (7:59e1)
	call DisableLCD
	call SetWindowOn
	farcall FadeScreenFromWhite
	jp AdvanceCreditsSequenceCmdPtrBy2

CreditsSequenceCmd_FadeOut: ; 1d9ee (7:59ee)
	farcall FadeScreenToWhite
	call Func_3ca4
	call EnableLCD
	call DoFrameIfLCDEnabled
	call DisableLCD
	call SetWindowOff
	jp AdvanceCreditsSequenceCmdPtrBy2

CreditsSequenceCmd_DrawRectangle: ; 1da04 (7:5a04)
	ld a, c
	or $20
	ld e, a
	ld d, $00
	ld c, b
	ld b, 20
	xor a
	lb hl, 0, 0
	call FillRectangle
	jp AdvanceCreditsSequenceCmdPtrBy4

CreditsSequenceCmd_PrintText: ; 1da17 (7:5a17)
	ld a, $01
	ld [wLineSeparation], a
	push de
	ld d, c
	ld a, b
	or $20
	ld e, a
	call InitTextPrinting
	pop hl
	call PrintTextNoDelay
	jp AdvanceCreditsSequenceCmdPtrBy6

CreditsSequenceCmd_PrintTextBox: ; 1da2c (7:5a2c)
	ld a, $01
	ld [wLineSeparation], a
	push de
	ld d, c
	ld e, b
	call InitTextPrinting
	pop hl
	call PrintTextNoDelay
	jp AdvanceCreditsSequenceCmdPtrBy6

CreditsSequenceCmd_InitOverlay: ; 1da3e (7:5a3e)
	ld a, c
	ld [wd647], a
	ld a, b
	ld [wd648], a
	ld a, e
	ld [wd649], a
	ld a, d
	ld [wd64a], a
	call Func_1d765
	jp AdvanceCreditsSequenceCmdPtrBy6

CreditsSequenceCmd_LoadNPC: ; 1da54 (7:5a54)
	call LoadNPCForCreditsSequence
	jp AdvanceCreditsSequenceCmdPtrBy6

; bc = coordinates
; e = direction
; d = NPC ID
LoadNPCForCreditsSequence: ; 1da5a (7:5a5a)
	ld a, c
	ld [wLoadNPCXPos], a
	ld a, b
	ld [wLoadNPCYPos], a
	ld a, e
	ld [wLoadNPCDirection], a
	ld a, d
	farcall LoadNPCSpriteData
	ld a, [wNPCSpriteID]
	farcall CreateSpriteAndAnimBufferEntry

	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ldh a, [hSCX]
	ld c, a
	ld a, [wLoadNPCXPos]
	add a
	add a
	add a ; *8
	add 8
	sub c
	ld [hli], a ; x
	ldh a, [hSCY]
	ld c, a
	ld a, [wLoadNPCYPos]
	add a
	add a
	add a ; *8
	add 16
	sub c
	ld [hli], a ; y

	ld a, [wNPCAnim]
	ld c, a
	ld a, [wLoadNPCDirection]
	add c
	farcall StartNewSpriteAnimation
	ret

CreditsSequenceCmd_InitVolcanoSprite: ; 1da9e (7:5a9e)
	farcall OverworldMap_InitVolcanoSprite
	jp AdvanceCreditsSequenceCmdPtrBy2

CreditsSequenceCmd_TransformOverlay: ; 1daa5 (7:5aa5)
; either stretches or shrinks overlay
; to the input configurations
	ld l, 0
	ld a, [wd647]
	call .Func_1dade
	ld [wd647], a
	ld a, [wd648]
	ld c, b
	call .Func_1dade
	ld [wd648], a
	ld a, [wd649]
	ld c, e
	call .Func_1dade
	ld [wd649], a
	ld a, [wd64a]
	ld c, d
	call .Func_1dade
	ld [wd64a], a
	ld a, l
	or a
	jr z, .advance_sequence
	ld a, 1
	ld [wSequenceDelay], a
	ret

.advance_sequence
	call Func_1d765
	jp AdvanceCreditsSequenceCmdPtrBy6

; compares a with c
; if it's smaller: increase by 2 and increment l
; if it's larger:  decrease by 2 and increment l
; if it's equal or $ff: do nothing
.Func_1dade
	cp $ff
	jr z, .done
	cp c
	jr z, .done
	inc l
	jr c, .incr_a
; decr a
	dec a
	dec a
	jr .done
.incr_a
	inc a
	inc a
.done
	ret
