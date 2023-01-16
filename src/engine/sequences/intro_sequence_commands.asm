ExecuteIntroSequenceCmd:
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

AdvanceIntroSequenceCmdPtrBy2:
	ld a, 2
	jr AdvanceIntroSequenceCmdPtr

AdvanceIntroSequenceCmdPtrBy3:
	ld a, 3
	jr AdvanceIntroSequenceCmdPtr

AdvanceIntroSequenceCmdPtrBy4:
	ld a, 4
;	fallthrough

AdvanceIntroSequenceCmdPtr:
	push hl
	ld hl, wSequenceCmdPtr
	add [hl]
	ld [hli], a
	ld a, [hl]
	adc 0
	ld [hl], a
	pop hl
	ret

IntroSequenceCmd_WaitOrbsAnimation:
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

IntroSequenceCmd_Wait:
	ld a, c
	ld [wSequenceDelay], a
	call AdvanceIntroSequenceCmdPtrBy3
	scf
	ret

IntroSequenceCmd_SetOrbsAnimations:
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

IntroSequenceCmd_SetOrbsCoordinates:
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

IntroOrbAnimations_CharizardScene:
	db SPRITE_ANIM_192 ; GRASS
	db SPRITE_ANIM_193 ; FIRE
	db SPRITE_ANIM_193 ; WATER
	db SPRITE_ANIM_192 ; COLORLESS
	db SPRITE_ANIM_193 ; LIGHTNING
	db SPRITE_ANIM_192 ; PSYCHIC
	db SPRITE_ANIM_193 ; FIGHTING

IntroOrbCoordinates_CharizardScene:
	; x coord, y coord
	db 240,  28 ; GRASS
	db 160, 120 ; FIRE
	db 160,   8 ; WATER
	db 240,  64 ; COLORLESS
	db 160,  84 ; LIGHTNING
	db 240, 100 ; PSYCHIC
	db 160,  44 ; FIGHTING

IntroOrbAnimations_ScytherScene:
	db SPRITE_ANIM_193 ; GRASS
	db SPRITE_ANIM_192 ; FIRE
	db SPRITE_ANIM_192 ; WATER
	db SPRITE_ANIM_193 ; COLORLESS
	db SPRITE_ANIM_192 ; LIGHTNING
	db SPRITE_ANIM_193 ; PSYCHIC
	db SPRITE_ANIM_192 ; FIGHTING

IntroOrbCoordinates_ScytherScene:
	; x coord, y coord
	db 160,  28 ; GRASS
	db 240, 120 ; FIRE
	db 240,   8 ; WATER
	db 160,  64 ; COLORLESS
	db 240,  84 ; LIGHTNING
	db 160, 100 ; PSYCHIC
	db 240,  44 ; FIGHTING

IntroOrbAnimations_AerodactylScene:
	db SPRITE_ANIM_194 ; GRASS
	db SPRITE_ANIM_197 ; FIRE
	db SPRITE_ANIM_200 ; WATER
	db SPRITE_ANIM_203 ; COLORLESS
	db SPRITE_ANIM_206 ; LIGHTNING
	db SPRITE_ANIM_209 ; PSYCHIC
	db SPRITE_ANIM_212 ; FIGHTING

IntroOrbCoordinates_AerodactylScene:
	; x coord, y coord
	db 240,  32 ; GRASS
	db 160, 112 ; FIRE
	db 160,  16 ; WATER
	db 240,  64 ; COLORLESS
	db 160,  80 ; LIGHTNING
	db 240,  96 ; PSYCHIC
	db 160,  48 ; FIGHTING

IntroOrbAnimations_InitialTitleScreen:
	db SPRITE_ANIM_195 ; GRASS
	db SPRITE_ANIM_198 ; FIRE
	db SPRITE_ANIM_201 ; WATER
	db SPRITE_ANIM_204 ; COLORLESS
	db SPRITE_ANIM_207 ; LIGHTNING
	db SPRITE_ANIM_210 ; PSYCHIC
	db SPRITE_ANIM_213 ; FIGHTING

IntroOrbCoordinates_InitialTitleScreen:
	; x coord, y coord
	db 112, 144 ; GRASS
	db  12, 144 ; FIRE
	db  32, 144 ; WATER
	db  92, 144 ; COLORLESS
	db  52, 144 ; LIGHTNING
	db 132, 144 ; PSYCHIC
	db  72, 144 ; FIGHTING

IntroOrbAnimations_InTitleScreen:
	db SPRITE_ANIM_196 ; GRASS
	db SPRITE_ANIM_199 ; FIRE
	db SPRITE_ANIM_202 ; WATER
	db SPRITE_ANIM_205 ; COLORLESS
	db SPRITE_ANIM_208 ; LIGHTNING
	db SPRITE_ANIM_211 ; PSYCHIC
	db SPRITE_ANIM_214 ; FIGHTING

IntroOrbCoordinates_InTitleScreen:
	; x coord, y coord
	db 112,  76 ; GRASS
	db   0,  28 ; FIRE
	db  32,  76 ; WATER
	db  92, 252 ; COLORLESS
	db  52, 252 ; LIGHTNING
	db 144,  28 ; PSYCHIC
	db  72,  76 ; FIGHTING

IntroSequenceCmd_PlayTitleScreenMusic:
	ld a, MUSIC_TITLESCREEN
	call PlaySong
	call AdvanceIntroSequenceCmdPtrBy2
	scf
	ret

IntroSequenceCmd_WaitSFX:
	call AssertSFXFinished
	or a
	jr nz, .no_carry
	call AdvanceIntroSequenceCmdPtrBy2
	scf
	ret

.no_carry
	or a
	ret

IntroSequenceCmd_PlaySFX:
	ld a, c
	call PlaySFX
	call AdvanceIntroSequenceCmdPtrBy3
	scf
	ret

IntroSequenceCmd_FadeIn:
	ld a, TRUE
	ld [wIntroSequencePalsNeedUpdate], a
	call AdvanceIntroSequenceCmdPtrBy2
	scf
	ret

IntroSequenceCmd_FadeOut:
	farcall Func_10d50
	ld a, TRUE
	ld [wIntroSequencePalsNeedUpdate], a
	call AdvanceIntroSequenceCmdPtrBy2
	scf
	ret

IntroSequenceCmd_LoadCharizardScene:
	lb bc, 6, 3
	ld a, SCENE_CHARIZARD_INTRO
	jr LoadOpeningSceneAndUpdateSGBBorder

IntroSequenceCmd_LoadScytherScene:
	lb bc, 6, 3
	ld a, SCENE_SCYTHER_INTRO
	jr LoadOpeningSceneAndUpdateSGBBorder

IntroSequenceCmd_LoadAerodactylScene:
	lb bc, 6, 3
	ld a, SCENE_AERODACTYL_INTRO
;	fallthrough

LoadOpeningSceneAndUpdateSGBBorder:
	call LoadOpeningScene
	ld l, %001010
	lb bc, 0, 0
	lb de, 20, 18
	farcall Func_70498
	scf
	ret

IntroSequenceCmd_LoadTitleScreenScene:
	lb bc, 0, 0
	ld a, SCENE_TITLE_SCREEN
	call LoadOpeningScene
	call IntroSequenceEmptyFunc
	scf
	ret

; a = scene ID
; bc = coordinates for scene
LoadOpeningScene:
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

IntroSequenceEmptyFunc:
	ret

INCLUDE "data/sequences/intro.asm"

; once every 63 frames randomly choose an orb sprite
; to animate, i.e. circle around the screen
AnimateRandomTitleScreenOrb:
	ld a, [wConsole]
	cp CONSOLE_CGB
	call z, .UpdateSpriteAttributes
	ld a, [wTitleScreenOrbCounter]
	and %111111
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
