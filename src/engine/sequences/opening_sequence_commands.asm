ExecuteOpeningSequenceCmd: ; 1d408 (7:5408)
	ld a, [wSequenceDelay]
	or a
	jr z, .call_function
	cp $ff
	ret z ; sequence ended

	dec a ; still waiting
	ld [wSequenceDelay], a
	ret

.call_function
	ld a, [wSequenceCmdPtr + 0]
	ld l, a
	ld a, [wSequenceCmdPtr + 1]
	ld h, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld l, e
	ld h, d
	call CallHL2
	jr c, ExecuteOpeningSequenceCmd
	ret

AdvanceOpeningSequenceCmdPtrBy2: ; 1d42e (7:542e)
	ld a, 2
	jr AdvanceOpeningSequenceCmdPtr

AdvanceOpeningSequenceCmdPtrBy3: ; 1d432 (7:5432)
	ld a, 3
	jr AdvanceOpeningSequenceCmdPtr

AdvanceOpeningSequenceCmdPtrBy4: ; 1d436 (7:5436)
	ld a, 4
;	fallthrough

AdvanceOpeningSequenceCmdPtr: ; 1d438 (7:5438)
	push hl
	ld hl, wSequenceCmdPtr
	add [hl]
	ld [hli], a
	ld a, [hl]
	adc 0
	ld [hl], a
	pop hl
	ret

OpeningSequenceCmd_WaitOrbsAnimation: ; 1d444 (7:5444)
	ld c, $7
	ld de, wTitleScreenSprites
.loop
	ld a, [de]
	ld [wWhichSprite], a
	farcall GetSpriteAnimCounter
	cp $ff
	jr nz, .no_carry
	inc de
	dec c
	jr nz, .loop
	call AdvanceOpeningSequenceCmdPtrBy2
	scf
	ret

.no_carry
	or a
	ret

OpeningSequenceCmd_Wait: ; 1d460 (7:5460)
	ld a, c
	ld [wSequenceDelay], a
	call AdvanceOpeningSequenceCmdPtrBy3
	scf
	ret

OpeningSequenceCmd_SetOrbsAnimations: ; 1d469 (7:5469)
	ld l, c
	ld h, b

	ld c, $7
	ld de, wTitleScreenSprites
.loop
	push bc
	push de
	ld a, [de]
	ld [wWhichSprite], a
	ld a, [hli]
	farcall StartSpriteAnimation
	pop de
	pop bc
	inc de
	dec c
	jr nz, .loop

	call AdvanceOpeningSequenceCmdPtrBy4
	scf
	ret

OpeningSequenceCmd_SetOrbsCoordinates: ; 1d486 (7:5486)
	ld l, c
	ld h, b

	ld c, $7
	ld de, wTitleScreenSprites
.loop
	push bc
	push de
	ld a, [de]
	ld [wWhichSprite], a
	push hl
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ld e, l
	ld d, h
	pop hl
	ld a, [hli]
	add 8
	ld [de], a ; x
	inc de
	ld a, [hli]
	add 16
	ld [de], a ; y
	pop de
	pop bc
	inc de
	dec c
	jr nz, .loop

	call AdvanceOpeningSequenceCmdPtrBy4
	scf
	ret

OpeningOrbAnimations_CharizardScene: ; 1d4b0 (7:54b0)
	db $c0 ; GRASS
	db $c1 ; FIRE
	db $c1 ; WATER
	db $c0 ; COLORLESS
	db $c1 ; LIGHTNING
	db $c0 ; PSYCHIC
	db $c1 ; FIGHTING

OpeningOrbCoordinates_CharizardScene: ; 1d4b7 (7:54b7)
	; x coord, y coord
	db 240,  28 ; GRASS
	db 160, 120 ; FIRE
	db 160,   8 ; WATER
	db 240,  64 ; COLORLESS
	db 160,  84 ; LIGHTNING
	db 240, 100 ; PSYCHIC
	db 160,  44 ; FIGHTING

OpeningOrbAnimations_ScytherScene: ; 1d4c5 (7:54c5)
	db $c1 ; GRASS
	db $c0 ; FIRE
	db $c0 ; WATER
	db $c1 ; COLORLESS
	db $c0 ; LIGHTNING
	db $c1 ; PSYCHIC
	db $c0 ; FIGHTING

OpeningOrbCoordinates_ScytherScene: ; 1d4cc (7:54cc)
	; x coord, y coord
	db 160,  28 ; GRASS
	db 240, 120 ; FIRE
	db 240,   8 ; WATER
	db 160,  64 ; COLORLESS
	db 240,  84 ; LIGHTNING
	db 160, 100 ; PSYCHIC
	db 240,  44 ; FIGHTING

OpeningOrbAnimations_AerodactylScene: ; 1d4da (7:54da)
	db $c2 ; GRASS
	db $c5 ; FIRE
	db $c8 ; WATER
	db $cb ; COLORLESS
	db $ce ; LIGHTNING
	db $d1 ; PSYCHIC
	db $d4 ; FIGHTING

OpeningOrbCoordinates_AerodactylScene: ; 1d4e1 (7:54e1)
	; x coord, y coord
	db 240,  32 ; GRASS
	db 160, 112 ; FIRE
	db 160,  16 ; WATER
	db 240,  64 ; COLORLESS
	db 160,  80 ; LIGHTNING
	db 240,  96 ; PSYCHIC
	db 160,  48 ; FIGHTING

OpeningOrbAnimations_InitialTitleScreen: ; 1d4ef (7:54ef)
	db $c3 ; GRASS
	db $c6 ; FIRE
	db $c9 ; WATER
	db $cc ; COLORLESS
	db $cf ; LIGHTNING
	db $d2 ; PSYCHIC
	db $d5 ; FIGHTING

OpeningOrbCoordinates_InitialTitleScreen: ; 1d4f6 (7:54f6)
	; x coord, y coord
	db 112, 144 ; GRASS
	db  12, 144 ; FIRE
	db  32, 144 ; WATER
	db  92, 144 ; COLORLESS
	db  52, 144 ; LIGHTNING
	db 132, 144 ; PSYCHIC
	db  72, 144 ; FIGHTING

OpeningOrbAnimations_InTitleScreen: ; 1d504 (7:5504)
	db $c4 ; GRASS
	db $c7 ; FIRE
	db $ca ; WATER
	db $cd ; COLORLESS
	db $d0 ; LIGHTNING
	db $d3 ; PSYCHIC
	db $d6 ; FIGHTING

OpeningOrbCoordinates_InTitleScreen: ; 1d50b (7:550b)
	; x coord, y coord
	db 112,  76 ; GRASS
	db   0,  28 ; FIRE
	db  32,  76 ; WATER
	db  92, 252 ; COLORLESS
	db  52, 252 ; LIGHTNING
	db 144,  28 ; PSYCHIC
	db  72,  76 ; FIGHTING

OpeningSequenceCmd_PlayTitleScreenMusic: ; 1d519 (7:5519)
	ld a, MUSIC_TITLESCREEN
	call PlaySong
	call AdvanceOpeningSequenceCmdPtrBy2
	scf
	ret

OpeningSequenceCmd_WaitSFX: ; 1d523 (7:5523)
	call AssertSFXFinished
	or a
	jr nz, .no_carry
	call AdvanceOpeningSequenceCmdPtrBy2
	scf
	ret

.no_carry
	or a
	ret

OpeningSequenceCmd_PlaySFX: ; 1d530 (7:5530)
	ld a, c
	call PlaySFX
	call AdvanceOpeningSequenceCmdPtrBy3
	scf
	ret

OpeningSequenceCmd_FadeIn: ; 1d539 (7:5539)
	ld a, TRUE
	ld [wOpeningSequencePalsNeedUpdate], a
	call AdvanceOpeningSequenceCmdPtrBy2
	scf
	ret

OpeningSequenceCmd_FadeOut: ; 1d543 (7:5543)
	farcall Func_10d50
	ld a, TRUE
	ld [wOpeningSequencePalsNeedUpdate], a
	call AdvanceOpeningSequenceCmdPtrBy2
	scf
	ret

OpeningSequenceCmd_LoadCharizardScene: ; 1d551 (7:5551)
	lb bc, 6, 3
	ld a, SCENE_CHARIZARD_INTRO
	jr LoadOpeningSceneAndUpdateSGBBorder

OpeningSequenceCmd_LoadScytherScene: ; 1d558 (7:5558)
	lb bc, 6, 3
	ld a, SCENE_SCYTHER_INTRO
	jr LoadOpeningSceneAndUpdateSGBBorder

OpeningSequenceCmd_LoadAerodactylScene: ; 1d55f (7:555f)
	lb bc, 6, 3
	ld a, SCENE_AERODACTYL_INTRO
;	fallthrough

LoadOpeningSceneAndUpdateSGBBorder: ; 1d564 (7:5564)
	call LoadOpeningScene
	ld l, %001010
	lb bc, 0, 0
	lb de, 20, 18
	farcall Func_70498
	scf
	ret

OpeningSequenceCmd_LoadTitleScreenScene: ; 1d575 (7:5575)
	lb bc, 0, 0
	ld a, SCENE_TITLE_SCREEN
	call LoadOpeningScene
	call OpeningSequenceEmptyFunc
	scf
	ret

; a = scene ID
; bc = coordinates for scene
LoadOpeningScene: ; 1d582 (7:5582)
	push af
	push bc
	call DisableLCD
	pop bc
	pop af

	farcall _LoadScene ; TODO change func name?
	farcall Func_10d17

	xor a
	ld [wOpeningSequencePalsNeedUpdate], a
	call AdvanceOpeningSequenceCmdPtrBy2
	call EnableLCD
	ret

OpeningSequenceEmptyFunc: ; 1d59c (7:559c)
	ret
