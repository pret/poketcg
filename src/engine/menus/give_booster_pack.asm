GiveBoosterPack:
	ld c, a
	ld a, [wd291]
	push af
	push bc
	call DisableLCD
	call InitMenuScreen
	xor a
	ld [wTextBoxFrameType], a
	pop bc
	push bc
	ld b, 0
	ld hl, BoosterTypes
	add hl, bc
	ld a, [hl]
	ld c, a
	add a
	add a
	ld c, a
	ld hl, BoosterScenesAndNameTexts
	add hl, bc
	ld a, [hli]
	push hl
	lb bc, 6, 0
	call LoadBoosterGfx
	pop hl
	ld a, [hli]
	ld [wTxRam3], a
	xor a
	ld [wTxRam3 + 1], a
	ld a, [hli]
	ld [wTxRam2], a
	ld a, [hl]
	ld [wTxRam2 + 1], a
	call FlashWhiteScreen
	call PauseSong
	ld a, MUSIC_BOOSTER_PACK
	call PlaySong
	pop bc
	ld a, c
	farcall GenerateBoosterPack
	ldtx hl, ReceivedBoosterPackText
	ld a, [wAnotherBoosterPack]
	cp TRUE
	jr nz, .first_booster
	ldtx hl, AndAnotherBoosterPackText
.first_booster
	call PrintScrollableText_NoTextBoxLabel
	call WaitForSongToFinish
	call ResumeSong
	ldtx hl, CheckedCardsInBoosterPackText
	call PrintScrollableText_NoTextBoxLabel
	call DisableLCD
	call SetDefaultPalettes
	call ZeroObjectPositions
	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	ld a, $4
	ld [wTextBoxFrameType], a
	farcall OpenBoosterPack
	farcall WhiteOutDMGPals
	call DoFrameIfLCDEnabled
	pop af
	ld [wd291], a
	ret

BoosterTypes:
	table_width 1, BoosterTypes
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_NEUTRAL
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_GRASS
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_FIRE
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_WATER
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_LIGHTNING
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_FIGHTING
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_TRAINER
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_NEUTRAL
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_GRASS
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_FIRE
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_WATER
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_FIGHTING
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_PSYCHIC
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_TRAINER
	db BOOSTER_MYSTERY    ; BOOSTER_MYSTERY_NEUTRAL
	db BOOSTER_MYSTERY    ; BOOSTER_MYSTERY_GRASS_COLORLESS
	db BOOSTER_MYSTERY    ; BOOSTER_MYSTERY_WATER_COLORLESS
	db BOOSTER_MYSTERY    ; BOOSTER_MYSTERY_LIGHTNING_COLORLESS
	db BOOSTER_MYSTERY    ; BOOSTER_MYSTERY_FIGHTING_COLORLESS
	db BOOSTER_MYSTERY    ; BOOSTER_MYSTERY_TRAINER_COLORLESS
	db BOOSTER_LABORATORY ; BOOSTER_LABORATORY_NEUTRAL
	db BOOSTER_LABORATORY ; BOOSTER_LABORATORY_GRASS
	db BOOSTER_LABORATORY ; BOOSTER_LABORATORY_WATER
	db BOOSTER_LABORATORY ; BOOSTER_LABORATORY_PSYCHIC
	db BOOSTER_LABORATORY ; BOOSTER_LABORATORY_TRAINER
	db BOOSTER_COLOSSEUM  ; BOOSTER_ENERGY_LIGHTNING_FIRE
	db BOOSTER_COLOSSEUM  ; BOOSTER_ENERGY_WATER_FIGHTING
	db BOOSTER_COLOSSEUM  ; BOOSTER_ENERGY_GRASS_PSYCHIC
	db BOOSTER_COLOSSEUM  ; BOOSTER_ENERGY_RANDOM
	assert_table_length NUM_BOOSTERS

BoosterScenesAndNameTexts:
	db SCENE_COLOSSEUM_BOOSTER, SCENE_COLOSSEUM_BOOSTER
	tx ColosseumBoosterText

	db SCENE_EVOLUTION_BOOSTER, SCENE_EVOLUTION_BOOSTER
	tx EvolutionBoosterText

	db SCENE_MYSTERY_BOOSTER, SCENE_MYSTERY_BOOSTER
	tx MysteryBoosterText

	db SCENE_LABORATORY_BOOSTER, SCENE_LABORATORY_BOOSTER
	tx LaboratoryBoosterText

_PauseMenu_Exit:
	ret
