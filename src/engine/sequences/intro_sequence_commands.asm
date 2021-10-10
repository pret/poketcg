ExecuteIntroSequenceCmd: ; 1d408 (7:5408)
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
	jr c, ExecuteIntroSequenceCmd
	ret

AdvanceIntroSequenceCmdPtrBy2: ; 1d42e (7:542e)
	ld a, 2
	jr AdvanceIntroSequenceCmdPtr

AdvanceIntroSequenceCmdPtrBy3: ; 1d432 (7:5432)
	ld a, 3
	jr AdvanceIntroSequenceCmdPtr

AdvanceIntroSequenceCmdPtrBy4: ; 1d436 (7:5436)
	ld a, 4
;	fallthrough

AdvanceIntroSequenceCmdPtr: ; 1d438 (7:5438)
	push hl
	ld hl, wSequenceCmdPtr
	add [hl]
	ld [hli], a
	ld a, [hl]
	adc 0
	ld [hl], a
	pop hl
	ret

IntroSequenceCmd_WaitOrbsAnimation: ; 1d444 (7:5444)
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
	call AdvanceIntroSequenceCmdPtrBy2
	scf
	ret

.no_carry
	or a
	ret

IntroSequenceCmd_Wait: ; 1d460 (7:5460)
	ld a, c
	ld [wSequenceDelay], a
	call AdvanceIntroSequenceCmdPtrBy3
	scf
	ret

IntroSequenceCmd_SetOrbsAnimations: ; 1d469 (7:5469)
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

	call AdvanceIntroSequenceCmdPtrBy4
	scf
	ret

IntroSequenceCmd_SetOrbsCoordinates: ; 1d486 (7:5486)
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

	call AdvanceIntroSequenceCmdPtrBy4
	scf
	ret

IntroOrbAnimations_CharizardScene: ; 1d4b0 (7:54b0)
	db SPRITE_ANIM_192 ; GRASS
	db SPRITE_ANIM_193 ; FIRE
	db SPRITE_ANIM_193 ; WATER
	db SPRITE_ANIM_192 ; COLORLESS
	db SPRITE_ANIM_193 ; LIGHTNING
	db SPRITE_ANIM_192 ; PSYCHIC
	db SPRITE_ANIM_193 ; FIGHTING

IntroOrbCoordinates_CharizardScene: ; 1d4b7 (7:54b7)
	; x coord, y coord
	db 240,  28 ; GRASS
	db 160, 120 ; FIRE
	db 160,   8 ; WATER
	db 240,  64 ; COLORLESS
	db 160,  84 ; LIGHTNING
	db 240, 100 ; PSYCHIC
	db 160,  44 ; FIGHTING

IntroOrbAnimations_ScytherScene: ; 1d4c5 (7:54c5)
	db SPRITE_ANIM_193 ; GRASS
	db SPRITE_ANIM_192 ; FIRE
	db SPRITE_ANIM_192 ; WATER
	db SPRITE_ANIM_193 ; COLORLESS
	db SPRITE_ANIM_192 ; LIGHTNING
	db SPRITE_ANIM_193 ; PSYCHIC
	db SPRITE_ANIM_192 ; FIGHTING

IntroOrbCoordinates_ScytherScene: ; 1d4cc (7:54cc)
	; x coord, y coord
	db 160,  28 ; GRASS
	db 240, 120 ; FIRE
	db 240,   8 ; WATER
	db 160,  64 ; COLORLESS
	db 240,  84 ; LIGHTNING
	db 160, 100 ; PSYCHIC
	db 240,  44 ; FIGHTING

IntroOrbAnimations_AerodactylScene: ; 1d4da (7:54da)
	db SPRITE_ANIM_194 ; GRASS
	db SPRITE_ANIM_197 ; FIRE
	db SPRITE_ANIM_200 ; WATER
	db SPRITE_ANIM_203 ; COLORLESS
	db SPRITE_ANIM_206 ; LIGHTNING
	db SPRITE_ANIM_209 ; PSYCHIC
	db SPRITE_ANIM_212 ; FIGHTING

IntroOrbCoordinates_AerodactylScene: ; 1d4e1 (7:54e1)
	; x coord, y coord
	db 240,  32 ; GRASS
	db 160, 112 ; FIRE
	db 160,  16 ; WATER
	db 240,  64 ; COLORLESS
	db 160,  80 ; LIGHTNING
	db 240,  96 ; PSYCHIC
	db 160,  48 ; FIGHTING

IntroOrbAnimations_InitialTitleScreen: ; 1d4ef (7:54ef)
	db SPRITE_ANIM_195 ; GRASS
	db SPRITE_ANIM_198 ; FIRE
	db SPRITE_ANIM_201 ; WATER
	db SPRITE_ANIM_204 ; COLORLESS
	db SPRITE_ANIM_207 ; LIGHTNING
	db SPRITE_ANIM_210 ; PSYCHIC
	db SPRITE_ANIM_213 ; FIGHTING

IntroOrbCoordinates_InitialTitleScreen: ; 1d4f6 (7:54f6)
	; x coord, y coord
	db 112, 144 ; GRASS
	db  12, 144 ; FIRE
	db  32, 144 ; WATER
	db  92, 144 ; COLORLESS
	db  52, 144 ; LIGHTNING
	db 132, 144 ; PSYCHIC
	db  72, 144 ; FIGHTING

IntroOrbAnimations_InTitleScreen: ; 1d504 (7:5504)
	db SPRITE_ANIM_196 ; GRASS
	db SPRITE_ANIM_199 ; FIRE
	db SPRITE_ANIM_202 ; WATER
	db SPRITE_ANIM_205 ; COLORLESS
	db SPRITE_ANIM_208 ; LIGHTNING
	db SPRITE_ANIM_211 ; PSYCHIC
	db SPRITE_ANIM_214 ; FIGHTING

IntroOrbCoordinates_InTitleScreen: ; 1d50b (7:550b)
	; x coord, y coord
	db 112,  76 ; GRASS
	db   0,  28 ; FIRE
	db  32,  76 ; WATER
	db  92, 252 ; COLORLESS
	db  52, 252 ; LIGHTNING
	db 144,  28 ; PSYCHIC
	db  72,  76 ; FIGHTING

IntroSequenceCmd_PlayTitleScreenMusic: ; 1d519 (7:5519)
	ld a, MUSIC_TITLESCREEN
	call PlaySong
	call AdvanceIntroSequenceCmdPtrBy2
	scf
	ret

IntroSequenceCmd_WaitSFX: ; 1d523 (7:5523)
	call AssertSFXFinished
	or a
	jr nz, .no_carry
	call AdvanceIntroSequenceCmdPtrBy2
	scf
	ret

.no_carry
	or a
	ret

IntroSequenceCmd_PlaySFX: ; 1d530 (7:5530)
	ld a, c
	call PlaySFX
	call AdvanceIntroSequenceCmdPtrBy3
	scf
	ret

IntroSequenceCmd_FadeIn: ; 1d539 (7:5539)
	ld a, TRUE
	ld [wIntroSequencePalsNeedUpdate], a
	call AdvanceIntroSequenceCmdPtrBy2
	scf
	ret

IntroSequenceCmd_FadeOut: ; 1d543 (7:5543)
	farcall Func_10d50
	ld a, TRUE
	ld [wIntroSequencePalsNeedUpdate], a
	call AdvanceIntroSequenceCmdPtrBy2
	scf
	ret

IntroSequenceCmd_LoadCharizardScene: ; 1d551 (7:5551)
	lb bc, 6, 3
	ld a, SCENE_CHARIZARD_INTRO
	jr LoadOpeningSceneAndUpdateSGBBorder

IntroSequenceCmd_LoadScytherScene: ; 1d558 (7:5558)
	lb bc, 6, 3
	ld a, SCENE_SCYTHER_INTRO
	jr LoadOpeningSceneAndUpdateSGBBorder

IntroSequenceCmd_LoadAerodactylScene: ; 1d55f (7:555f)
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

IntroSequenceCmd_LoadTitleScreenScene: ; 1d575 (7:5575)
	lb bc, 0, 0
	ld a, SCENE_TITLE_SCREEN
	call LoadOpeningScene
	call IntroSequenceEmptyFunc
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
	ld [wIntroSequencePalsNeedUpdate], a
	call AdvanceIntroSequenceCmdPtrBy2
	call EnableLCD
	ret

IntroSequenceEmptyFunc: ; 1d59c (7:559c)
	ret

INCLUDE "data/sequences/intro.asm"

; once every 63 frames randomly choose an orb sprite
; to animate, i.e. circle around the screen
AnimateRandomTitleScreenOrb:
	ld a, [wConsole]
	cp CONSOLE_CGB
	call z, .UpdateSpriteAttributes
	ld a, [wd635]
	and 63
	ret nz ; don't pick an orb now

.pick_orb
	ld a, $7
	call Random
	ld c, a
	ld b, $00
	ld hl, wTitleScreenSprites
	add hl, bc
	ld a, [hl]
	ld [wWhichSprite], a
	farcall GetSpriteAnimCounter
	cp $ff
	jr nz, .pick_orb

	ld c, SPRITE_ANIM_ATTRIBUTES
	call GetSpriteAnimBufferProperty
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .set_coords
	set SPRITE_ANIM_FLAG_UNSKIPPABLE, [hl]

.set_coords
	inc hl
	ld a, 248
	ld [hli], a ; SPRITE_ANIM_COORD_X
	ld a, 14
	ld [hl], a ; SPRITE_ANIM_COORD_Y
	ld a, [wConsole]
	cp CONSOLE_CGB
	ld a, SPRITE_ANIM_215
	jr nz, .start_anim
	ld a, SPRITE_ANIM_216
.start_anim
	farcall StartSpriteAnimation
	ret

.UpdateSpriteAttributes
	ld c, $7
	ld de, wTitleScreenSprites
.loop_orbs
	push bc
	ld a, [de]
	ld [wWhichSprite], a
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ld a, [hld]
	cp 152
	jr nz, .skip
	res SPRITE_ANIM_FLAG_UNSKIPPABLE, [hl]
.skip
	pop bc
	inc de
	dec c
	jr nz, .loop_orbs
	ret
