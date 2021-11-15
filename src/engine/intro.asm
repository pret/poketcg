PlayIntroSequence:
	call DisableLCD
	farcall Func_10a9b
	farcall InitMenuScreen
	call Func_3ca0
	ld hl, HandleAllSpriteAnimations
	call SetDoFrameFunction
	call LoadTitleScreenSprites

	ld a, LOW(IntroSequence)
	ld [wSequenceCmdPtr + 0], a
	ld a, HIGH(IntroSequence)
	ld [wSequenceCmdPtr + 1], a

	xor a
	ld [wd317], a
	ld [wIntroSequencePalsNeedUpdate], a
	ld [wSequenceDelay], a
	farcall FlashWhiteScreen

.loop_cmds
	call DoFrameIfLCDEnabled
	call UpdateRNGSources
	ldh a, [hKeysPressed]
	and A_BUTTON | START
	jr nz, .jump_to_title_screen
	ld a, [wIntroSequencePalsNeedUpdate]
	or a
	jr z, .no_pal_update
	farcall Func_10d74
.no_pal_update
	call ExecuteIntroSequenceCmd
	ld a, [wSequenceDelay]
	cp $ff
	jr nz, .loop_cmds
	jr .asm_1d39f

.jump_to_title_screen
	call AssertSongFinished
	or a
	jr nz, .asm_1d39f
	call DisableLCD
	ld a, MUSIC_TITLESCREEN
	call PlaySong
	lb bc, 0, 0
	ld a, SCENE_TITLE_SCREEN
	call LoadScene
	call IntroSequenceEmptyFunc
.asm_1d39f
	call Func_3ca0
	call .ShowPressStart
	call EnableLCD
	ret

.ShowPressStart
	ld a, SPRITE_PRESS_START
	farcall CreateSpriteAndAnimBufferEntry
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ld a, 48
	ld [hli], a ; x
	ld a, 112
	ld [hl], a ; y
	ld c, SPRITE_ANIM_190
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .asm_1d3c5
	ld c, SPRITE_ANIM_191
.asm_1d3c5
	ld a, c
	ld bc, 60
	farcall Func_12ac9
	ret

LoadTitleScreenSprites:
	xor a
	ld [wd4ca], a
	ld [wd4cb], a
	ld a, PALETTE_30
	farcall LoadPaletteData

	ld bc, 0
	ld de, wTitleScreenSprites
.loop_load_sprites
	push bc
	push de
	ld hl, .TitleScreenSpriteList
	add hl, bc
	ld a, [hl]
	farcall CreateSpriteAndAnimBufferEntry
	ld a, [wWhichSprite]
	ld [de], a
	call GetFirstSpriteAnimBufferProperty
	inc hl
	ld a, [hl] ; SPRITE_ANIM_ATTRIBUTES
	or c
	ld [hl], a
	pop de
	pop bc
	inc de
	inc c
	ld a, c
	cp $7
	jr c, .loop_load_sprites
	ret

.TitleScreenSpriteList
	db SPRITE_GRASS
	db SPRITE_FIRE
	db SPRITE_WATER
	db SPRITE_COLORLESS
	db SPRITE_LIGHTNING
	db SPRITE_PSYCHIC
	db SPRITE_FIGHTING
